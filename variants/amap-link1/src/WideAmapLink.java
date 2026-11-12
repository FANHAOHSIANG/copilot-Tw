package com.navipilot.obf;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.os.Binder;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.os.Parcel;
import android.os.ParcelFileDescriptor;
import android.os.RemoteException;
import android.os.SystemClock;
import android.system.ErrnoException;
import android.system.Os;
import android.system.OsConstants;
import android.system.StructPollfd;
import java.io.ByteArrayOutputStream;
import java.io.FileDescriptor;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.RejectedExecutionException;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import org.json.JSONObject;

/** App-identity-only reader for the observed mobile AMap Link Binder interface.
 * All listener events and lifecycle decisions run on the Android main thread.
 * The listener must apply its own source selection and navigation freshness rules.
 * This reader makes no promise that a particular map version grants access. */
public final class WideAmapLink implements AutoCloseable {
    public interface Listener {
        void onState(String state, String detail);
        /** The new epoch is a barrier: discard every value from earlier epochs. */
        void onInvalidated(long newEpoch, String reason);
        void onData(long epoch, int type, JSONObject data, long receivedElapsedMs);
    }

    private static final String MAP_PACKAGE = "com.autonavi.minimap";
    private static final String SERVICE_CLASS = "com.amap.bundle.wearable.connect.glass.AmapLinkService";
    private static final String SERVICE_ACTION = "com.autonavi.minimap.service.NAVIGATION_SERVICE";
    private static final String CONTROL = "com.amap.linksdk.aidldefine.ILinkSdkControl";
    private static final String CALLBACK = "com.amap.linksdk.aidldefine.ILinkSdkCallback";
    private static final long HANDSHAKE_TIMEOUT_MS = 10000;
    private static final long IDLE_NOTICE_MS = 30000;
    private static final long FD_TIMEOUT_MS = 5000;
    private static final long MAX_PACKET_AGE_MS = 8000;
    private static final int MAX_INLINE_CHARS = 131072;
    private static final int MAX_METADATA_CHARS = 4096;
    private static final int MAX_PENDING_FDS = 2;
    private static final AtomicInteger THREAD_NUMBER = new AtomicInteger();

    private final Context context;
    private final Listener listener;
    private final Handler main = new Handler(Looper.getMainLooper());
    private final WideAmapLinkPolicy policy = new WideAmapLinkPolicy();
    // Binder calls are never made on the UI or payload thread. Even a stuck remote
    // transaction cannot create an unbounded number of threads after explicit retries.
    private final ThreadPoolExecutor controlWorkers = pool(2, 4, "amap-link-control");
    private final ThreadPoolExecutor payloadWorker = pool(1, 16, "amap-link-payload");
    private volatile Attempt current;
    private volatile boolean stopRequested = true;
    private volatile boolean closeRequested;

    private final Runnable retryTask = new Runnable() {
        @Override public void run() { beginAttempt(); }
    };

    public WideAmapLink(Context context, Listener listener) {
        if (context == null || listener == null) throw new IllegalArgumentException("context_listener");
        Context application = context.getApplicationContext();
        this.context = application != null ? application : context;
        this.listener = listener;
    }

    public void start() {
        onMain(new Runnable() { @Override public void run() {
            if (closeRequested || !policy.start()) return;
            stopRequested = false;
            barrier("start");
            state("STARTING", "正在準備高德手機版連線");
            beginAttempt();
        } });
    }

    /** Resets the finite startup budget after an actual map launch or explicit retry. */
    public void retryAfterMapLaunch() {
        onMain(new Runnable() { @Override public void run() {
            if (closeRequested) return;
            // Launching the map or changing its window layout does not require replacing
            // a working subscription, nor cancelling a handshake already in progress.
            Attempt existing = current;
            if (existing != null && existing.live()) return;
            if (!policy.retryAfterMapLaunch()) return;
            stopRequested = false;
            retireCurrent();
            main.removeCallbacks(retryTask);
            barrier("explicit_retry");
            state("STARTING", "重新準備高德手機版連線");
            beginAttempt();
        } });
    }

    public void stop() {
        stopRequested = true; // Suppress queued deliveries immediately, even off the main thread.
        onMain(new Runnable() { @Override public void run() {
            if (policy.isClosed()) return;
            stopRequested = true;
            policy.stop();
            main.removeCallbacks(retryTask);
            retireCurrent();
            barrier("stop");
            state("STOPPED", "高德手機版連線已停止");
        } });
    }

    @Override public void close() {
        closeRequested = true;
        stopRequested = true;
        onMain(new Runnable() { @Override public void run() {
            if (policy.isClosed()) return;
            policy.close();
            main.removeCallbacks(retryTask);
            retireCurrent();
            barrier("close");
            for (Runnable queued : payloadWorker.shutdownNow()) {
                if (queued instanceof FrameTask) ((FrameTask) queued).release();
            }
            // Previously submitted unregister work may finish; no further callbacks are accepted.
            controlWorkers.shutdown();
            state("CLOSED", "高德手機版連線已關閉");
        } });
    }

    private static ThreadPoolExecutor pool(int threads, int capacity, final String name) {
        return new ThreadPoolExecutor(threads, threads, 0, TimeUnit.MILLISECONDS,
                new ArrayBlockingQueue<Runnable>(capacity), new ThreadFactory() {
            @Override public Thread newThread(Runnable task) {
                Thread thread = new Thread(task, name + "-" + THREAD_NUMBER.incrementAndGet());
                thread.setDaemon(true);
                return thread;
            }
        }, new ThreadPoolExecutor.AbortPolicy());
    }

    private void onMain(Runnable task) {
        if (Looper.myLooper() == main.getLooper()) task.run();
        else main.post(task);
    }

    private void state(String code, String detail) {
        try { listener.onState(code, detail); }
        catch (RuntimeException ignored) { /* Client failures must not leak frame contents. */ }
    }

    private void barrier(String reason) {
        long next = policy.invalidate();
        try { listener.onInvalidated(next, reason); }
        catch (RuntimeException ignored) { }
    }

    private void beginAttempt() {
        if (stopRequested || closeRequested || current != null || !policy.isRunning()) return;
        if (!policy.beginAttempt()) {
            state("EXHAUSTED", "已達連線重試上限，請開啟高德後再試");
            return;
        }
        final int sourceUid;
        try {
            // Resolve anew for each binding; package replacement can change the UID.
            sourceUid = context.getPackageManager().getApplicationInfo(MAP_PACKAGE, 0).uid;
        } catch (PackageManager.NameNotFoundException absent) {
            policy.refuse();
            barrier("map_unavailable");
            state("UNAVAILABLE", "找不到可用的高德手機版");
            return;
        } catch (SecurityException denied) {
            policy.refuse();
            barrier("package_permission");
            state("PERMISSION_DENIED", "系統未允許存取高德手機版");
            return;
        }
        Attempt attempt = new Attempt(policy.generation(), sourceUid);
        current = attempt;
        state("BINDING", "正在連接高德手機版服務");
        Intent intent = new Intent(SERVICE_ACTION);
        intent.setComponent(new ComponentName(MAP_PACKAGE, SERVICE_CLASS));
        try {
            attempt.bound = context.bindService(intent, attempt.connection, Context.BIND_AUTO_CREATE);
            if (attempt.bound) main.postDelayed(attempt.handshakeWatchdog, HANDSHAKE_TIMEOUT_MS);
            else fail(attempt, false, "UNAVAILABLE", "高德服務暫未接受連線", "bind_rejected");
        } catch (SecurityException denied) {
            fail(attempt, true, "PERMISSION_DENIED", "高德或系統拒絕此應用程式連線", "bind_permission");
        } catch (RuntimeException unavailable) {
            fail(attempt, false, "UNAVAILABLE", "目前無法連接高德服務", "bind_error");
        }
    }

    private void fail(Attempt attempt, boolean terminal, String code, String detail, String reason) {
        if (current != attempt || attempt.retired) return;
        if (terminal) policy.refuse();
        retireCurrent();
        main.removeCallbacks(retryTask);
        barrier(reason);
        state(code, detail);
        if (terminal || stopRequested || closeRequested) return;
        long delay = policy.retryDelayMs();
        if (delay < 0) state("EXHAUSTED", "已達連線重試上限，請開啟高德後再試");
        else {
            state("RETRY_WAIT", "等待重新連線；導航資料已清除");
            main.postDelayed(retryTask, delay);
        }
    }

    private void failLater(final Attempt attempt, final boolean terminal, final String code,
            final String detail, final String reason) {
        main.post(new Runnable() { @Override public void run() {
            fail(attempt, terminal, code, detail, reason);
        } });
    }

    private void retireCurrent() {
        Attempt attempt = current;
        current = null;
        if (attempt == null) return;
        attempt.retired = true;
        attempt.authenticated = false;
        attempt.admitted.countDown();
        main.removeCallbacks(attempt.handshakeWatchdog);
        main.removeCallbacks(attempt.silenceWatchdog);
        controlWorkers.remove(attempt.handshake);
        for (Runnable queued : payloadWorker.getQueue().toArray(new Runnable[0])) {
            if (queued instanceof FrameTask && ((FrameTask) queued).attempt == attempt
                    && payloadWorker.remove(queued)) ((FrameTask) queued).release();
        }
        for (ParcelFileDescriptor descriptor : attempt.descriptors) closeFd(descriptor);
        attempt.descriptors.clear();
        attempt.payload.clear();
        final IBinder remote = attempt.remote;
        attempt.remote = null;
        if (remote != null) {
            try { remote.unlinkToDeath(attempt.death, 0); } catch (RuntimeException ignored) { }
        }
        final boolean unregister;
        synchronized (attempt.registrationLock) {
            unregister = attempt.registered;
            attempt.registered = false;
        }
        if (unregister && remote != null) {
            final IBinder callback = attempt.callback;
            try { controlWorkers.execute(new Runnable() { @Override public void run() {
                unregister(remote, callback);
            } }); } catch (RejectedExecutionException ignored) { }
        }
        if (attempt.bound) {
            attempt.bound = false;
            try { context.unbindService(attempt.connection); } catch (RuntimeException ignored) { }
        }
    }

    private final class Attempt {
        final long epoch;
        final int sourceUid;
        final CountDownLatch admitted = new CountDownLatch(1);
        final Object registrationLock = new Object();
        final WideAmapLinkCodec.Payload payload = new WideAmapLinkCodec.Payload();
        final Set<ParcelFileDescriptor> descriptors = ConcurrentHashMap.newKeySet();
        volatile boolean retired;
        volatile boolean authenticated;
        volatile boolean registered;
        volatile IBinder remote;
        boolean bound; // Main thread only.
        long lastTraffic;
        int badFrames;
        boolean announcedReceiving;

        Attempt(long epoch, int sourceUid) { this.epoch = epoch; this.sourceUid = sourceUid; }

        boolean live() {
            return !retired && !stopRequested && !closeRequested && current == this
                    && policy.isCurrent(epoch);
        }

        final Runnable handshakeWatchdog = new Runnable() { @Override public void run() {
            if (live() && !registered) fail(Attempt.this, false, "UNAVAILABLE",
                    "高德服務回應逾時", "handshake_timeout");
        } };

        final Runnable silenceWatchdog = new Runnable() { @Override public void run() {
            if (!live() || !registered) return;
            IBinder service = remote;
            if (service == null || !service.isBinderAlive()) {
                fail(Attempt.this, false, "UNAVAILABLE", "高德服務已中斷", "binder_not_alive");
                return;
            }
            // An idle map need not publish a heartbeat. Navigation expiry is the mapper's job.
            if (announcedReceiving && SystemClock.elapsedRealtime() - lastTraffic > IDLE_NOTICE_MS) {
                announcedReceiving = false;
                state("LISTENING", "高德服務仍已連線，等待新的導航資料");
            }
            main.postDelayed(this, 5000);
        } };

        final IBinder.DeathRecipient death = new IBinder.DeathRecipient() {
            @Override public void binderDied() {
                failLater(Attempt.this, false, "UNAVAILABLE", "高德服務已中斷", "binder_died");
            }
        };

        final ServiceConnection connection = new ServiceConnection() {
            @Override public void onServiceConnected(ComponentName name, IBinder service) {
                if (!live()) return;
                if (remote != null) return;
                remote = service;
                try { service.linkToDeath(death, 0); }
                catch (RemoteException disconnected) {
                    fail(Attempt.this, false, "UNAVAILABLE", "高德服務已中斷", "connect_died");
                    return;
                }
                state("AUTHENTICATING", "正在確認高德服務是否接受本應用程式");
                try { controlWorkers.execute(handshake); }
                catch (RejectedExecutionException busy) {
                    fail(Attempt.this, false, "UNAVAILABLE", "高德連線工作暫時忙碌", "control_busy");
                }
            }
            @Override public void onServiceDisconnected(ComponentName name) {
                fail(Attempt.this, false, "UNAVAILABLE", "高德服務已中斷", "service_disconnected");
            }
            @Override public void onBindingDied(ComponentName name) {
                fail(Attempt.this, false, "UNAVAILABLE", "高德服務連線已失效", "binding_died");
            }
            @Override public void onNullBinding(ComponentName name) {
                fail(Attempt.this, false, "UNAVAILABLE", "高德未提供此服務連線", "null_binding");
            }
        };

        final Binder callback = new Binder() {
            @Override protected boolean onTransact(int code, Parcel data, Parcel reply, int flags)
                    throws RemoteException {
                if (code == IBinder.INTERFACE_TRANSACTION) {
                    if (reply != null) reply.writeString(CALLBACK);
                    return true;
                }
                if ((code != 1 && code != 2) || Binder.getCallingUid() != sourceUid) return false;
                data.enforceInterface(CALLBACK);
                long received = SystemClock.elapsedRealtime();
                ParcelFileDescriptor descriptor = null;
                try {
                    String text = data.readString();
                    if (code == 1) {
                        if (live() && authenticated && text != null && text.length() <= MAX_INLINE_CHARS)
                            enqueue(new FrameTask(Attempt.this, text, null, received));
                    } else {
                        // AIDL argument order: metadata String, presence int, parcelled descriptor.
                        if (data.readInt() != 0) descriptor = ParcelFileDescriptor.CREATOR.createFromParcel(data);
                        if (descriptor != null && live() && authenticated && text != null
                                && text.length() <= MAX_METADATA_CHARS) {
                            boolean admittedFd;
                            synchronized (descriptors) {
                                admittedFd = live() && descriptors.size() < MAX_PENDING_FDS;
                                if (admittedFd) descriptors.add(descriptor);
                            }
                            if (admittedFd && live()) {
                                enqueue(new FrameTask(Attempt.this, text, descriptor, received));
                                descriptor = null; // Ownership transferred to the task.
                            }
                        }
                    }
                } catch (RuntimeException malformedParcel) {
                    badFrame(Attempt.this);
                } finally {
                    if (descriptor != null) {
                        descriptors.remove(descriptor);
                        closeFd(descriptor);
                    }
                }
                if (reply != null) reply.writeNoException();
                return true;
            }
        };

        final Runnable handshake = new Runnable() { @Override public void run() {
            IBinder service = remote;
            if (!live() || service == null) return;
            String token = null;
            try {
                if (!CONTROL.equals(service.getInterfaceDescriptor())) {
                    failLater(Attempt.this, true, "UNSUPPORTED", "此高德版本的服務介面不相容", "descriptor");
                    return;
                }
                String response = (String) transact(service, 1, null, null);
                JSONObject auth = WideAmapLinkCodec.objectValue(response);
                if (!"success".equals(auth.opt("status"))) {
                    failLater(Attempt.this, true, "AUTH_REFUSED", "高德未接受本應用程式認證，已停止重試", "auth_refused");
                    return;
                }
                if (!live()) return;
                authenticated = true;
                main.post(new Runnable() { @Override public void run() {
                    if (live()) state("AUTHENTICATED", "高德已接受本應用程式認證");
                } });
                boolean accepted = ((Boolean) transact(service, 3, null, callback)).booleanValue();
                if (!accepted) {
                    failLater(Attempt.this, true, "SUBSCRIPTION_REFUSED", "高德未接受資料訂閱，已停止重試", "subscribe_refused");
                    return;
                }
                boolean keep;
                synchronized (registrationLock) {
                    keep = live();
                    if (keep) registered = true;
                }
                if (!keep) { unregister(service, callback); return; }
                main.post(new Runnable() { @Override public void run() {
                    if (!live() || !registered) { admitted.countDown(); return; }
                    lastTraffic = SystemClock.elapsedRealtime();
                    main.removeCallbacks(handshakeWatchdog);
                    state("LISTENING", "已訂閱高德服務，等待實際導航資料");
                    admitted.countDown();
                    main.postDelayed(silenceWatchdog, 5000);
                } });
                JSONObject authData = auth.optJSONObject("data");
                if (authData != null && authData.opt("token") instanceof String)
                    token = (String) authData.opt("token");
                // These observed commands request current guidance and structure; neither starts navigation.
                if (token != null && !token.isEmpty() && token.length() <= 4096) {
                    for (int command : new int[] {7, 5}) {
                        if (!live()) break;
                        JSONObject request = new JSONObject();
                        request.put("cmd", command);
                        request.put("requestId", (int) ((SystemClock.elapsedRealtime() + command) % 1000000000L));
                        request.put("token", token);
                        request.put("sessionId", "copilot-link-" + epoch);
                        try { transact(service, 2, request.toString(), null); }
                        catch (SecurityException denied) {
                            failLater(Attempt.this, true, "AUTH_REFUSED", "高德拒絕資料查詢，已停止重試", "query_permission");
                            break;
                        } catch (Exception queryUnavailable) {
                            // A read query is optional; accepted callbacks remain authoritative.
                        }
                    }
                }
            } catch (SecurityException denied) {
                failLater(Attempt.this, true, "PERMISSION_DENIED", "高德拒絕此應用程式存取，已停止重試", "control_permission");
            } catch (RemoteException disconnected) {
                failLater(Attempt.this, false, "UNAVAILABLE", "高德服務通訊已中斷", "control_disconnected");
            } catch (Exception incompatible) {
                failLater(Attempt.this, true, "UNSUPPORTED", "無法確認此高德版本的認證回應", "control_format");
            } finally {
                token = null;
                if (!registered) admitted.countDown();
            }
        } };
    }

    private void enqueue(FrameTask task) {
        if (!task.attempt.live()) { task.release(); return; }
        try { payloadWorker.execute(task); }
        catch (RejectedExecutionException full) {
            task.release();
            failLater(task.attempt, false, "UNAVAILABLE", "高德資料處理佇列已滿", "payload_busy");
        }
    }

    private final class FrameTask implements Runnable {
        final Attempt attempt;
        final String text;
        final ParcelFileDescriptor descriptor;
        final long received;
        FrameTask(Attempt attempt, String text, ParcelFileDescriptor descriptor, long received) {
            this.attempt = attempt;
            this.text = text;
            this.descriptor = descriptor;
            this.received = received;
        }
        void release() {
            if (descriptor != null) {
                attempt.descriptors.remove(descriptor);
                closeFd(descriptor);
            }
        }
        @Override public void run() {
            try {
                if (!attempt.admitted.await(5, TimeUnit.SECONDS) || !attempt.live() || !attempt.registered) return;
                String frame = descriptor == null ? text : readDescriptor(this);
                if (!attempt.live() || stale(received)) return;
                String assembled = attempt.payload.accept(frame, SystemClock.elapsedRealtime(), received);
                if (assembled == null) return;
                final long payloadReceived = attempt.payload.outputReceivedElapsedMs();
                if (payloadReceived < 0 || stale(payloadReceived)) return;
                String decoded = WideAmapLinkCodec.decodeEnvelope(assembled);
                final List<WideAmapLinkCodec.Item> items = WideAmapLinkCodec.items(decoded);
                JSONObject business = new JSONObject(decoded);
                if (!WideAmapLinkCodec.isInteger(business.opt("bizType"), 113, 113)) return;
                main.post(new Runnable() { @Override public void run() {
                    if (!attempt.live() || !attempt.registered || stale(payloadReceived)) return;
                    attempt.lastTraffic = Math.max(attempt.lastTraffic, received);
                    attempt.badFrames = 0;
                    if (!attempt.announcedReceiving) {
                        attempt.announcedReceiving = true;
                        state("RECEIVING", "已收到高德導航資料，正在檢查可用欄位");
                    }
                    for (WideAmapLinkCodec.Item item : items) {
                        if (!attempt.live() || !attempt.registered) break;
                        try { listener.onData(attempt.epoch, item.type, item.data, payloadReceived); }
                        catch (RuntimeException ignored) { }
                    }
                } });
            } catch (InterruptedException cancelled) {
                Thread.currentThread().interrupt();
            } catch (Exception malformed) {
                badFrame(attempt);
            } finally { release(); }
        }
    }

    private void badFrame(final Attempt attempt) {
        main.post(new Runnable() { @Override public void run() {
            if (!attempt.live()) return;
            if (++attempt.badFrames >= 3) fail(attempt, false, "UNAVAILABLE",
                    "高德資料格式暫時無法讀取", "invalid_frames");
        } });
    }

    private static boolean stale(long received) {
        long age = SystemClock.elapsedRealtime() - received;
        return age < 0 || age > MAX_PACKET_AGE_MS;
    }

    private String readDescriptor(FrameTask task) throws Exception {
        JSONObject metadata = WideAmapLinkCodec.objectValue(task.text);
        Object size = metadata.opt("dataLength");
        if (!WideAmapLinkCodec.isInteger(size, 1, WideAmapLinkCodec.MAX_FRAME_BYTES))
            throw new IOException("fd_length");
        long expectedChars = ((Number) size).longValue();
        FileDescriptor fd = task.descriptor.getFileDescriptor();
        int flags = Os.fcntlInt(fd, OsConstants.F_GETFL, 0);
        Os.fcntlInt(fd, OsConstants.F_SETFL, flags | OsConstants.O_NONBLOCK);
        StructPollfd poll = new StructPollfd();
        poll.fd = fd;
        poll.events = (short) (OsConstants.POLLIN | OsConstants.POLLHUP | OsConstants.POLLERR);
        ByteArrayOutputStream bytes = new ByteArrayOutputStream((int) Math.min(expectedChars, 32768));
        byte[] buffer = new byte[16384];
        long deadline = task.received + FD_TIMEOUT_MS;
        while (true) {
            if (!task.attempt.live() || Thread.currentThread().isInterrupted()) throw new IOException("fd_cancelled");
            long left = deadline - SystemClock.elapsedRealtime();
            if (left <= 0) throw new IOException("fd_timeout");
            try {
                int ready = Os.poll(new StructPollfd[] {poll}, (int) Math.min(left, 250));
                if (ready == 0) continue;
                if ((poll.revents & OsConstants.POLLNVAL) != 0) throw new IOException("fd_invalid");
                int count = Os.read(fd, buffer, 0, buffer.length);
                if (count == 0) break;
                if (bytes.size() + (long) count > WideAmapLinkCodec.MAX_FRAME_BYTES)
                    throw new IOException("fd_size");
                bytes.write(buffer, 0, count);
            } catch (ErrnoException error) {
                if (error.errno == OsConstants.EINTR || error.errno == OsConstants.EAGAIN) continue;
                throw error;
            }
        }
        String result = WideAmapLinkCodec.utf8(bytes.toByteArray());
        // The observed callback metadata counts Java characters, while the transport cap is bytes.
        if (result.length() != expectedChars) throw new IOException("fd_length_mismatch");
        return result;
    }

    /** Calls only the four observed control operations; never changes the Binder identity. */
    private static Object transact(IBinder service, int operation, String message, IBinder callback)
            throws RemoteException {
        Parcel out = Parcel.obtain();
        Parcel in = Parcel.obtain();
        try {
            out.writeInterfaceToken(CONTROL);
            if (operation == 2) out.writeString(message);
            else if (operation == 3 || operation == 4) out.writeStrongBinder(callback);
            if (!service.transact(operation, out, in, 0)) throw new RemoteException("unsupported_operation");
            in.readException();
            if (operation == 1 || operation == 2) {
                String response = in.readString();
                if (response == null || response.length() > 131072)
                    throw new IllegalArgumentException("control_response");
                return response;
            }
            if (operation == 3) return Boolean.valueOf(in.readInt() != 0);
            return null;
        } finally {
            out.recycle();
            in.recycle();
        }
    }

    private static void unregister(IBinder service, IBinder callback) {
        try { transact(service, 4, null, callback); } catch (Exception ignored) { }
    }

    private static void closeFd(ParcelFileDescriptor descriptor) {
        try { descriptor.close(); } catch (IOException ignored) { }
    }
}
