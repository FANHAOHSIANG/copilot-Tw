package com.navipilot.obf;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import java.lang.ref.WeakReference;
import java.util.Map;
import org.json.JSONObject;

/** Phone-only Link lifecycle and an adapter into the existing MG / Navi v2 sender. */
public final class WideAmapLinkIntegration implements WideAmapLink.Listener {
    private static final String PHONE = "com.autonavi.minimap";
    private static final Object LOCK = new Object();
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ThreadLocal<Receipt> RECEIPT = new ThreadLocal<Receipt>();
    private static volatile Context application;
    private static volatile String selected = "com.autonavi.amapauto";
    private static volatile WideAmapLinkIntegration current;
    private static volatile WeakReference<MG> bridge = new WeakReference<MG>(null);
    private static volatile long selectionGeneration;
    private static volatile boolean sessionAllowed = true;

    private final long selection;
    private final WideAmapLinkNavigation navigation = new WideAmapLinkNavigation();
    private final WideAmapLink transport;
    private volatile String state = "STARTING";
    private volatile String detail = "正在連接手機高德 Link";
    private volatile boolean authenticated;
    private volatile boolean listening;
    private volatile long transportEpoch;
    private volatile long receivedCount;
    private volatile int lastType = -1;
    private volatile long lastReceiptElapsed = -1;
    private volatile String lastWireGuidance;
    private volatile long lastWireTimestamp;
    private volatile long lastWireElapsed = -1;

    private final Runnable expiry = new Runnable() {
        @Override public void run() {
            if (active()) publish();
        }
    };

    private final Runnable heartbeat = new Runnable() {
        @Override public void run() {
            if (!active()) return;
            publish();
            MAIN.postDelayed(this, 1000L);
        }
    };

    private WideAmapLinkIntegration(Context context, long selection) {
        this.selection = selection;
        this.transport = new WideAmapLink(context, this);
    }

    /** Called before WideVariant.prepare overwrites its Activity parameter. */
    public static void prepare(Context context) {
        if (context == null) return;
        Context app = context.getApplicationContext();
        if (app == null) return; // Never retain an Activity for the long-lived binding.
        application = app;
        onMain(new Runnable() {
            @Override public void run() { ensureStarted(); }
        });
    }

    /** Called after the original source gate has accepted a changed selection. */
    public static void select(String packageName) {
        final WideAmapLinkIntegration previous;
        synchronized (LOCK) {
            selected = packageName;
            selectionGeneration++;
            previous = current;
            current = null;
            if (previous != null) previous.navigation.invalidate();
        }
        onMain(new Runnable() {
            @Override public void run() {
                if (previous != null) previous.dispose();
                ensureStarted();
            }
        });
    }

    private static void ensureStarted() {
        WideAmapLinkIntegration created;
        synchronized (LOCK) {
            if (!sessionAllowed || !PHONE.equals(selected) || current != null || application == null) return;
            created = new WideAmapLinkIntegration(application, selectionGeneration);
            current = created;
        }
        MAIN.post(created.heartbeat);
        created.transport.start();
    }

    private boolean active() {
        return current == this && selection == selectionGeneration && sessionAllowed && PHONE.equals(selected);
    }

    /** Reuses the existing foreground-service lifetime; adds no service or permission. */
    public static void serviceCommand(Context context, Intent intent) {
        String action = intent == null ? null : intent.getAction();
        if ("STOP_SERVICE".equals(action)) {
            serviceStopped();
            return;
        }
        if (action != null && !"START_SERVICE".equals(action)) return;
        Context app = context == null ? null : context.getApplicationContext();
        if (app != null) application = app;
        sessionAllowed = true;
        if (selectionGeneration == 0 && application != null) {
            SharedPreferences prefs = application.getSharedPreferences("copilot_tw_projection", Context.MODE_PRIVATE);
            String fallback = prefs.getBoolean("phone_amap", false) ? PHONE : "com.autonavi.amapauto";
            String restored = prefs.getString("navigation_package", fallback);
            // The original gate also invalidates pending decoder work and stale Auto snapshots.
            WideAmapSource.select(restored);
        }
        onMain(new Runnable() {
            @Override public void run() { ensureStarted(); }
        });
    }

    public static void serviceStopped() {
        final WideAmapLinkIntegration previous;
        synchronized (LOCK) {
            sessionAllowed = false;
            selectionGeneration++;
            previous = current;
            current = null;
            if (previous != null) previous.navigation.invalidate();
        }
        onMain(new Runnable() {
            @Override public void run() {
                if (previous != null) previous.dispose();
                MG wire = bridge.get();
                if (wire == null || !PHONE.equals(selected)) return;
                synchronized (wire) {
                    if (!wire.j) return;
                    wire.b("guidance_current", null, "link_service_stopped");
                    wire.b("navigation_status", null, "link_service_stopped");
                }
            }
        });
    }

    private void dispose() {
        MAIN.removeCallbacks(heartbeat);
        MAIN.removeCallbacks(expiry);
        navigation.invalidate();
        transport.close();
    }

    /** Narrow hook after the existing projection launcher reports launch success. */
    public static void afterMapLaunch(final String packageName) {
        if (!PHONE.equals(packageName)) return;
        onMain(new Runnable() {
            @Override public void run() {
                WideAmapLinkIntegration instance = current;
                if (instance != null && instance.active()) instance.transport.retryAfterMapLaunch();
            }
        });
    }

    private static void onMain(Runnable task) {
        if (Looper.myLooper() == Looper.getMainLooper()) task.run();
        else MAIN.post(task);
    }

    @Override public void onState(String code, String explanation) {
        if (!active()) return;
        state = code;
        detail = explanation;
        if ("AUTHENTICATED".equals(code)) authenticated = true;
        if ("LISTENING".equals(code)) listening = true;
    }

    @Override public void onInvalidated(long epoch, String reason) {
        if (!active() || epoch <= transportEpoch || epoch <= 0) return;
        transportEpoch = epoch;
        authenticated = false;
        listening = false;
        navigation.reset(epoch);
        lastWireGuidance = null;
        lastWireTimestamp = 0;
        lastWireElapsed = -1;
        MAIN.removeCallbacks(expiry);
        publish();
    }

    @Override public void onData(long epoch, int type, JSONObject data, long receivedElapsedMs) {
        if (!active() || epoch != transportEpoch || epoch <= 0) return;
        long nowElapsed = SystemClock.elapsedRealtime();
        if (receivedElapsedMs < 0 || receivedElapsedMs > nowElapsed) return;
        receivedCount++;
        lastType = type;
        lastReceiptElapsed = receivedElapsedMs;
        // Preserve receipt time even if decoding/main-thread dispatch took time.
        long receiptWall = System.currentTimeMillis() - (nowElapsed - receivedElapsedMs);
        if (!navigation.accept(epoch, type, data, receivedElapsedMs, receiptWall)) return;
        MAIN.removeCallbacks(expiry);
        WideAmapLinkNavigation.Snapshot snapshot = navigation.snapshot(nowElapsed);
        if (snapshot.expiresElapsedMs >= 0) {
            MAIN.postDelayed(expiry, Math.max(1L, snapshot.expiresElapsedMs - nowElapsed));
        }
        publish();
    }

    private void publish() {
        if (!active()) return;
        MG wire = bridge.get();
        if (wire == null) return;
        synchronized (wire) {
            if (!active() || !wire.j) return;
            String reason = navigation.snapshot(SystemClock.elapsedRealtime()).reason;
            // MG keeps subscriptions, withdrawal ordering, throttling, retries and envelopes.
            wire.b("guidance_current", null, reason);
            wire.b("navigation_status", null, reason);
        }
    }

    /** Called only in the PHONE branch, before the existing Taiwan speed merge. */
    @SuppressWarnings({"rawtypes", "unchecked"})
    public static JSONObject filter(MG wire, String stream, JSONObject original, Map timestamps) {
        bridge = new WeakReference<MG>(wire);
        RECEIPT.remove();
        if ("app_status".equals(stream)) return original;
        WideAmapLinkIntegration instance = current;
        if (instance == null || !instance.active()) {
            timestamps.remove(stream);
            return null;
        }
        WideAmapLinkNavigation.Snapshot snapshot = instance.navigation.snapshot(SystemClock.elapsedRealtime());
        JSONObject value = null;
        long stamp = 0;
        if ("guidance_current".equals(stream)) {
            value = snapshot.guidance;
            stamp = snapshot.guidanceTimestampMs;
        } else if ("navigation_status".equals(stream)) {
            value = snapshot.status;
            stamp = snapshot.statusTimestampMs;
        }
        // No inferred route, camera, speed, vehicle, lane, traffic or next-turn values.
        if (value == null) timestamps.remove(stream);
        else timestamps.put(stream, Long.valueOf(stamp));
        RECEIPT.set(new Receipt(instance, wire, stream, value, stamp));
        return value;
    }

    /** Runs only after the existing XG.r call returned true, not merely after parsing. */
    public static void published(MG wire, String stream, JSONObject value) {
        Receipt receipt = RECEIPT.get();
        RECEIPT.remove();
        if (receipt == null || receipt.wire != wire || !receipt.stream.equals(stream)
                || receipt.value != value || !receipt.owner.active()) return;
        if (!"guidance_current".equals(stream)) return;
        receipt.owner.lastWireGuidance = value == null ? null : value.toString();
        receipt.owner.lastWireTimestamp = receipt.stamp;
        receipt.owner.lastWireElapsed = SystemClock.elapsedRealtime();
    }

    /** Null means retain the original Auto/Google diagnostic unchanged. */
    public static String statusFor(String packageName) {
        if (!PHONE.equals(packageName)) return null;
        if (!sessionAllowed) return "高德一般版 Link：CoPilot 服務已停止，已解除綁定";
        WideAmapLinkIntegration instance = current;
        if (instance == null || !instance.active()) return "高德一般版 Link：等待初始化";
        return instance.status();
    }

    private String status() {
        long now = SystemClock.elapsedRealtime();
        WideAmapLinkNavigation.Snapshot snapshot = navigation.snapshot(now);
        StringBuilder out = new StringBuilder("高德一般版 Link：");
        out.append(detail == null ? state : detail)
                .append("\n授權：").append(authenticated ? "成功" : "尚未成功")
                .append("；導航訂閱：").append(listening ? "已啟用" : "尚未啟用")
                .append("\nLink 資料：").append(receivedCount).append(" 筆");
        if (lastReceiptElapsed >= 0) out.append("；最近 type ").append(lastType)
                .append("，").append(Math.max(0, now - lastReceiptElapsed) / 1000).append(" 秒前");
        if (snapshot.guidance != null) {
            out.append("\n可用引導：").append(snapshot.guidance.optString("main_text"))
                    .append("，").append(snapshot.distanceM).append(" 公尺");
            boolean accepted = lastWireTimestamp == snapshot.guidanceTimestampMs
                    && snapshot.guidance.toString().equals(lastWireGuidance);
            out.append("\nNavi v2：").append(accepted ? "已接受這筆引導" : "這筆引導尚未被接受");
        } else {
            out.append("\n可用引導：").append(reasonLabel(snapshot.reason));
            if (snapshot.rawManeuver >= 0) out.append("（原始圖示 ").append(snapshot.rawManeuver).append("）");
            if (lastWireElapsed >= 0 && lastWireGuidance == null) out.append("\nNavi v2：已接受引導撤銷");
            else out.append("\nNavi v2：目前沒有可交付的引導");
        }
        out.append("\n尚未取得：路線折線、測速相機、道路限速")
                .append("\nNavi v2 接受狀態不代表 C4 已收到。");
        return out.toString();
    }

    private static String reasonLabel(String reason) {
        if ("link_guidance_expired".equals(reason)) return "超過 3 秒未更新，已撤銷";
        if ("link_unmapped_maneuver".equals(reason)) return "圖示尚無已確認的對應，未傳送轉向";
        if ("link_waiting_for_segment".equals(reason)) return "圖示已變更，等待新路口距離";
        if ("link_arrived".equals(reason)) return "已到達，已清除引導";
        if ("link_navigation_stopped".equals(reason)) return "導航已停止，已清除引導";
        if ("link_incomplete_segment".equals(reason) || "link_invalid_maneuver".equals(reason))
            return "導航欄位不完整，已撤銷舊引導";
        return "等待可用的導航欄位";
    }

    private static final class Receipt {
        final WideAmapLinkIntegration owner;
        final MG wire;
        final String stream;
        final JSONObject value;
        final long stamp;

        Receipt(WideAmapLinkIntegration owner, MG wire, String stream, JSONObject value, long stamp) {
            this.owner = owner;
            this.wire = wire;
            this.stream = stream;
            this.value = value;
            this.stamp = stamp;
        }
    }
}
