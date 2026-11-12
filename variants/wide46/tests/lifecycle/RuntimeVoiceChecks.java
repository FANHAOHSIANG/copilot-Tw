package com.navipilot.obf;

import android.content.Context;
import android.os.Handler;
import android.os.SystemClock;
import android.speech.tts.TextToSpeech;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.time.Instant;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;
import org.json.JSONArray;
import org.json.JSONObject;

/** Executes production Engine, Runtime and Voice against deterministic Android boundaries. */
public final class RuntimeVoiceChecks {
    private static final Class<?> RUNTIME = WideEnforcementRuntime.class;
    private static final Class<?> VOICE = WideEnforcementVoice.class;
    private static final Class<?> UPDATE;
    private static final long WALL = Instant.parse("2026-11-12T04:00:00Z").toEpochMilli();
    private static final long EPOCH = 100;
    private static int checks;
    static {
        try { UPDATE = Class.forName("com.navipilot.obf.WideEnforcementRuntime$Update"); }
        catch (ClassNotFoundException missing) { throw new ExceptionInInitializerError(missing); }
    }
    private static void check(boolean value, String message) {
        checks++; if (!value) throw new AssertionError(message);
    }
    private static Field field(Class<?> type, String name) throws Exception {
        Field field = type.getDeclaredField(name); field.setAccessible(true); return field;
    }
    private static Object get(Class<?> type, String name) throws Exception { return field(type, name).get(null); }
    private static void set(Class<?> type, String name, Object value) throws Exception { field(type, name).set(null, value); }
    private static Object call(Class<?> type, String name, Class<?>[] signature, Object... args) throws Exception {
        Method method = type.getDeclaredMethod(name, signature); method.setAccessible(true); return method.invoke(null, args);
    }
    private static Object update(Fixture f, WideCameraEngine.Fix fix, boolean roadResult, boolean confirmed, long generation) throws Exception {
        Constructor<?> constructor = UPDATE.getDeclaredConstructor(WideHcopRoad.Data.class, WideCameraEngine.Fix.class,
                WideHcopRoad.Decision.class, long.class, boolean.class);
        constructor.setAccessible(true);
        WideHcopRoad.Decision road = roadResult ? decision(f.road, fix, confirmed) : null;
        return constructor.newInstance(roadResult ? f.data : null, fix, road, generation, roadResult);
    }
    private static boolean commit(Object update, WideEnforcementEngine.Frame frame) throws Exception {
        return (Boolean) call(RUNTIME, "commit", new Class<?>[] {UPDATE, WideEnforcementEngine.Frame.class}, update, frame);
    }
    private static boolean prefer(Object previous, Object next) throws Exception {
        return (Boolean) call(RUNTIME, "prefer", new Class<?>[] {UPDATE, UPDATE}, previous, next);
    }
    private static boolean shouldProcess(Object update) throws Exception {
        return (Boolean) call(RUNTIME, "shouldProcess", new Class<?>[] {UPDATE}, update);
    }
    private static String signature(WideEnforcementEngine.Alert alert, long epoch) throws Exception {
        return (String) call(RUNTIME, "speechSignature", new Class<?>[] {WideEnforcementEngine.Alert.class, long.class}, alert, epoch);
    }
    private static void speak(WideEnforcementEngine.Frame frame, long epoch) throws Exception {
        call(RUNTIME, "speak", new Class<?>[] {WideEnforcementEngine.Frame.class, long.class}, frame, epoch);
    }
    private static double north(double meters) { return 25 + meters / 111320.0; }
    private static WideCameraEngine.Fix fix(double station, long time) {
        return new WideCameraEngine.Fix(north(station), 121, 5, 0, 10, time, true, false);
    }
    private static WideHcopRoad.Decision decision(WideHcopRoad.Road road, WideCameraEngine.Fix fix, boolean confirmed) {
        WideHcopRoad.Decision d = new WideHcopRoad.Decision(confirmed ? "host confirmed" : "host no road", fix.time);
        d.confirmed = confirmed; d.road = confirmed ? road : null; d.direction = confirmed ? 1 : 0; return d;
    }
    private static JSONObject record(String id, boolean known, String category) throws Exception {
        return new JSONObject().put("id", id).put("sourceId", "fixture").put("region", "測試市")
                .put("district", "測試區").put("location", "測試路口")
                .put("categories", new JSONArray().put(category)).put("geometryRole", "site")
                .put("coordinates", new JSONArray().put(121).put(north(300)))
                .put("travelBearing", known ? 0 : JSONObject.NULL).put("status", "announced")
                .put("raw", new JSONObject());
    }
    private static final class Fixture {
        final WideEnforcementEngine engine;
        final WideHcopRoad.Data data = new WideHcopRoad.Data();
        final WideHcopRoad.Road road = new WideHcopRoad.Road();
        final WideEnforcementEngine.Frame frame;
        final WideCameraEngine.Fix fix;
        Fixture(boolean known, long time, String... noticeIds) throws Exception {
            road.id = "road"; road.names = new String[] {"測試路"}; road.grade = "0|no|no";
            road.start = 1; road.end = 2; road.dir = 0;
            road.xy = new double[][] {{121, north(0)}, {121, north(600)}};
            data.roads.add(road);
            JSONArray records = new JSONArray();
            if (noticeIds.length == 0) records.put(record("site", known, "red_light"));
            else {
                records.put(record("site", false, "unspecified")); // Stable grouped location ID.
                for (String id : noticeIds) records.put(record(id, known, id.endsWith("b") ? "pedestrian" : "red_light"));
            }
            String catalog = new JSONObject().put("schemaVersion", 1).put("snapshotDate", "2026-11-12")
                    .put("records", records).toString();
            engine = new WideEnforcementEngine(catalog);
            WideEnforcementEngine.Frame result = null; WideCameraEngine.Fix finalFix = null;
            for (int sample = 0; sample < 3; sample++) {
                finalFix = fix(180 + sample * 10, time - 2000 + sample * 1000);
                result = engine.update(finalFix, data, decision(road, finalFix, true), finalFix.time, WALL);
            }
            frame = result; fix = finalFix;
            if (frame.speechText.isEmpty()) throw new AssertionError("fixture must offer real engine speech");
        }
    }

    private static Context setup(Fixture fixture) throws Exception {
        WideEnforcementVoice.stop("host reset"); Handler.clearQueue();
        set(VOICE, "tts", null); set(VOICE, "ready", false); set(VOICE, "audio", null); set(VOICE, "focus", null);
        TextToSpeech.last = null; TextToSpeech.hasVoice = true;
        SystemClock.now = fixture.fix.time;
        Context context = new Context();
        set(RUNTIME, "context", context); set(RUNTIME, "started", true); set(RUNTIME, "engine", fixture.engine);
        set(RUNTIME, "published", fixture.frame); set(RUNTIME, "enabled", true); set(RUNTIME, "voiceEnabled", true);
        set(RUNTIME, "generation", EPOCH); set(RUNTIME, "rejectThrough", 0L); set(RUNTIME, "cameraVoiceUntil", 0L);
        set(RUNTIME, "processedGeneration", EPOCH); set(RUNTIME, "processedFix", fixture.fix.time);
        set(RUNTIME, "processedRoadResult", true); set(RUNTIME, "lastRoadFix", fixture.fix);
        set(RUNTIME, "pending", null); set(RUNTIME, "draining", false);
        WideCamera.running = true;
        return context;
    }
    private static void warm(Context context) {
        WideEnforcementVoice.warmup(context); Handler.runReady();
    }

    private static void negativeRoadResultPriority() throws Exception {
        Fixture f = new Fixture(true, 3000); setup(f);
        Object raw = update(f, f.fix, false, false, EPOCH);
        Object positive = update(f, f.fix, true, true, EPOCH);
        Object negative = update(f, f.fix, true, false, EPOCH);
        check(!prefer(negative, raw), "raw cannot replace pending negative road result at same GPS time");
        check(!prefer(positive, raw), "raw cannot replace pending confirmed road result");
        check(prefer(raw, negative), "completed negative result supersedes raw sample");
        check(prefer(positive, negative), "new negative road result can retract same-time confirmation");
        check(!shouldProcess(raw), "processed road result rejects same-time raw downgrade");
        check(shouldProcess(negative), "processed confirmation does not suppress same-time negative evidence");
        check(shouldProcess(positive), "same-time recomputed road result is evaluated");
        // Exercise the real offer entry points while the worker is deliberately blocked.
        WideEnforcementRuntime.onRoadUpdate(f.data, f.fix, decision(f.road, f.fix, false));
        WideEnforcementRuntime.onFix(f.fix);
        Object pending = get(RUNTIME, "pending");
        check(field(UPDATE, "roadResult").getBoolean(pending), "real callback coalescing preserves negative road-result provenance");
        set(RUNTIME, "pending", null);
        WideEnforcementEngine.Frame negativeFrame = f.engine.update(f.fix, f.data,
                decision(f.road, f.fix, false), f.fix.time, WALL);
        check(commit(negative, negativeFrame), "negative road result commits");
        check(WideEnforcementRuntime.current().primary.level == WideEnforcementEngine.Level.NEARBY,
                "negative result replaces held ahead frame immediately");
        check(!WideEnforcementRuntime.isSpeechCurrent(f.frame.primary.id, signature(f.frame.primary, EPOCH)),
                "negative road result revokes speech owner");
    }

    private static void clearCannotResurrectPublication() throws Exception {
        Fixture f = new Fixture(true, 3000); setup(f);
        final Object old = update(f, f.fix, true, true, EPOCH);
        Object lock = get(RUNTIME, "LOCK");
        CountDownLatch entered = new CountDownLatch(1);
        AtomicBoolean committed = new AtomicBoolean(true);
        AtomicReference<Throwable> failure = new AtomicReference<Throwable>();
        Thread worker = new Thread(new Runnable() { public void run() {
            entered.countDown();
            try { committed.set(commit(old, f.frame)); } catch (Throwable error) { failure.set(error); }
        } }, "host-race-commit");
        synchronized (lock) {
            worker.start();
            check(entered.await(2, TimeUnit.SECONDS), "worker reached blocked publication boundary");
            WideEnforcementRuntime.clear();
            check(get(RUNTIME, "published") == null, "clear immediately withdraws publication");
        }
        worker.join(2000);
        check(!worker.isAlive() && failure.get() == null, "race worker completes without exception");
        check(!committed.get() && get(RUNTIME, "published") == null,
                "old generation cannot republish after clear wins shared lock");
        setup(f);
        check(commit(update(f, f.fix, true, true, EPOCH), f.frame), "publication may precede clear");
        WideEnforcementRuntime.clear();
        check(WideEnforcementRuntime.current() == null, "clear wins when it follows committed publication");
        Fixture newer = new Fixture(true, 4000); SystemClock.now = 4000;
        check(commit(update(newer, newer.fix, true, true, EPOCH + 1), newer.frame), "new generation can publish its own fresh fix");
        check(!WideEnforcementRuntime.isSpeechCurrent(f.frame.primary.id, signature(f.frame.primary, EPOCH)),
                "same location in new generation cannot revive old utterance owner");
    }

    private static void rawHoldDoesNotRenewExpiry() throws Exception {
        for (boolean known : new boolean[] {true, false}) {
            Fixture f = new Fixture(known, 3000); setup(f);
            for (int sample = 1; sample <= 2; sample++) {
                WideCameraEngine.Fix raw = fix(200 + sample * 10, 3000 + sample * 1000);
                SystemClock.now = raw.time;
                WideEnforcementEngine.Frame rawFrame = f.engine.update(raw, null, null, raw.time, WALL);
                check(commit(update(f, raw, false, false, EPOCH), rawFrame), "new raw fix is processed");
                WideEnforcementEngine.Frame held = WideEnforcementRuntime.current();
                check(held == f.frame && held.fixElapsedMs == 3000 && held.expiresElapsedMs == 6000,
                        "raw/road gap retains original frame and original expiry for either speech level");
            }
            SystemClock.now = 6001;
            check(WideEnforcementRuntime.current() == null, "repeated newer raw samples cannot extend held-road TTL");
        }
    }

    private static void speechContextCannotChangeUnderOwnerId() throws Exception {
        Fixture confirmed = new Fixture(true, 3000), unknown = new Fixture(false, 3001);
        Context context = setup(confirmed); warm(context);
        set(RUNTIME, "published", unknown.frame); SystemClock.now = 3001;
        speak(confirmed.frame, EPOCH);
        check(TextToSpeech.last.speakCalls == 0, "queued unqualified text cannot start after same ID becomes direction-unknown");
        speak(unknown.frame, EPOCH);
        check(TextToSpeech.last.speakCalls == 1 && TextToSpeech.last.text.contains("取締方向待確認"),
                "new qualified direction-unknown offer can start");

        context = setup(confirmed); warm(context); speak(confirmed.frame, EPOCH);
        String started = TextToSpeech.last.utterance;
        set(RUNTIME, "published", unknown.frame); SystemClock.now = 3001;
        TextToSpeech.last.listener.onStart(started); Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1 && "".equals(get(VOICE, "activeId")),
                "onStart revalidates confidence before acknowledging playback");

        Fixture firstNotice = new Fixture(true, 3000, "notice-a"), otherNotice = new Fixture(true, 3001, "notice-b");
        context = setup(firstNotice); warm(context); speak(firstNotice.frame, EPOCH);
        set(RUNTIME, "published", otherNotice.frame); SystemClock.now = 3350; Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1, "WATCH revokes unchanged group ID when applicable record IDs change");

        context = setup(confirmed); warm(context); speak(confirmed.frame, EPOCH);
        set(RUNTIME, "published", unknown.frame); SystemClock.now = 3350; Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1, "WATCH revokes confidence downgrade during utterance");

        Fixture ordered = new Fixture(true, 3000, "notice-a", "notice-b");
        Fixture reversed = new Fixture(true, 3001, "notice-b", "notice-a");
        setup(ordered); set(RUNTIME, "published", reversed.frame); SystemClock.now = 3001;
        check(WideEnforcementRuntime.isSpeechCurrent(ordered.frame.primary.id, signature(ordered.frame.primary, EPOCH)),
                "same applicable record set in a different order remains the same owner signature");
    }

    private static void lifecycleStopsAudio() throws Exception {
        Fixture f = new Fixture(false, 3000);
        Context context = setup(f); warm(context); speak(f.frame, EPOCH);
        WideEnforcementRuntime.clear();
        check(!WideEnforcementRuntime.isSpeechCurrent(f.frame.primary.id, signature(f.frame.primary, EPOCH)),
                "clear invalidates speech authority before queued stop runs");
        Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1 && context.audio.abandons > 0,
                "clear stops active advisory speech and releases audio focus");

        context = setup(f); warm(context);
        new Handler(android.os.Looper.getMainLooper()).post(new Runnable() { public void run() {
            try { speak(f.frame, EPOCH); } catch (Exception error) { throw new AssertionError(error); }
        }});
        WideEnforcementRuntime.clear(); Handler.runReady();
        check(TextToSpeech.last.speakCalls == 0, "queued pre-clear offer cannot start after invalidation");

        context = setup(f); warm(context); speak(f.frame, EPOCH);
        SystemClock.now = 6001; Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1 && WideEnforcementRuntime.current() == null,
                "expiry watchdog stops speech with no fresh frame");

        context = setup(f); warm(context); speak(f.frame, EPOCH);
        WideCamera.running = false; SystemClock.now = 3350; Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1, "GPS service stopped revokes advisory speech");

        context = setup(f); warm(context); speak(f.frame, EPOCH);
        WideEnforcementRuntime.setVoiceEnabled(context, false); Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1, "voice preference off cancels active utterance");

        context = setup(f); warm(context); speak(f.frame, EPOCH);
        WideEnforcementRuntime.cameraVoiceStarted(); Handler.runReady();
        check(TextToSpeech.last.stopCalls == 1, "existing camera announcement preempts enforcement speech");
        int before = TextToSpeech.last.speakCalls; speak(f.frame, EPOCH);
        check(TextToSpeech.last.speakCalls == before, "camera priority window rejects additional advisory speech");
    }

    private static void missingVoiceCanRecover() throws Exception {
        Fixture f = new Fixture(false, 3000); Context context = setup(f);
        TextToSpeech.hasVoice = false; warm(context);
        check(!(Boolean) get(VOICE, "ready"), "missing Chinese voice does not report ready");
        TextToSpeech old = TextToSpeech.last;
        TextToSpeech.hasVoice = true;
        WideEnforcementRuntime.previewVoice(context); Handler.runReady();
        check(old.shutdownCalls == 1 && (Boolean) get(VOICE, "ready"), "preview retries initialization after voice installation");
        WideEnforcementRuntime.previewVoice(context);
        check(TextToSpeech.last.speakCalls == 1, "next explicit preview plays after successful initialization");
    }

    public static void main(String[] args) throws Exception {
        ScheduledExecutorService work = (ScheduledExecutorService) get(RUNTIME, "WORK");
        CountDownLatch workerEntered = new CountDownLatch(1), releaseWorker = new CountDownLatch(1);
        work.execute(new Runnable() { public void run() {
            workerEntered.countDown();
            try { releaseWorker.await(); } catch (InterruptedException stopped) { Thread.currentThread().interrupt(); }
        }});
        if (!workerEntered.await(2, TimeUnit.SECONDS)) throw new AssertionError("cannot establish worker boundary");
        try {
            negativeRoadResultPriority(); clearCannotResurrectPublication(); rawHoldDoesNotRenewExpiry();
            speechContextCannotChangeUnderOwnerId(); lifecycleStopsAudio(); missingVoiceCanRecover();
            System.out.println("RuntimeVoiceChecks: " + checks + " assertions passed");
        } finally {
            set(RUNTIME, "enabled", false); set(RUNTIME, "pending", null); WideEnforcementVoice.stop("host finished");
            work.shutdownNow(); releaseWorker.countDown(); Handler.clearQueue();
        }
    }
}
