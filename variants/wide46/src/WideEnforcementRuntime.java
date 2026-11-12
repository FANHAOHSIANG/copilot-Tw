package com.navipilot.obf;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ThreadFactory;
import java.util.zip.GZIPInputStream;
import org.json.JSONObject;

/** One latest-only worker owns the enforcement engine. Never publishes a C4 control field. */
public final class WideEnforcementRuntime {
    private static final String PREFS = "copilot_tw_enforcement";
    private static final Object LOCK = new Object();
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static final ScheduledExecutorService WORK = Executors.newSingleThreadScheduledExecutor(new ThreadFactory() {
        public Thread newThread(Runnable r) { Thread t = new Thread(r, "EnforcementAlerts"); t.setDaemon(true); return t; }
    });
    private static volatile Context context;
    private static volatile WideEnforcementEngine engine;
    private static volatile WideEnforcementEngine.Frame published;
    private static volatile String loadStatus = "科技執法資料尚未載入", snapshotDate = "";
    private static volatile boolean enabled = true, voiceEnabled = true;
    private static volatile long generation, rejectThrough, cameraVoiceUntil;
    private static Update pending;
    private static boolean draining, started;
    private static long processedFix;
    private static long processedGeneration = -1;
    private static boolean processedRoadResult;
    private static WideCameraEngine.Fix lastRoadFix;

    private static final class Update {
        final WideHcopRoad.Data data;
        final WideCameraEngine.Fix fix;
        final WideHcopRoad.Decision road;
        final long generation;
        final boolean roadResult;
        Update(WideHcopRoad.Data d, WideCameraEngine.Fix f, WideHcopRoad.Decision r, long g, boolean enriched) {
            data = d; fix = f; road = r; generation = g; roadResult = enriched;
        }
        boolean hasRoad() { return data != null && road != null && road.road != null && road.confirmed; }
    }

    public static synchronized void init(Context c) {
        if (started) return;
        started = true;
        context = c.getApplicationContext();
        enabled = context.getSharedPreferences(PREFS, 0).getBoolean("enabled", true);
        voiceEnabled = context.getSharedPreferences(PREFS, 0).getBoolean("voice", WideCameraVoice.enabled(context));
        if (voiceEnabled) MAIN.post(new Runnable() { public void run() { WideEnforcementVoice.warmup(context); }});
        loadStatus = "正在載入科技執法資料";
        WORK.execute(new Runnable() { public void run() {
            try {
                InputStream in = new GZIPInputStream(context.getAssets().open("tw_enforcement.json.gz"));
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                try {
                    byte[] b = new byte[8192]; int n;
                    while ((n = in.read(b)) != -1) {
                        if (out.size() + n > 8 * 1024 * 1024) throw new IllegalStateException("catalog too large");
                        out.write(b, 0, n);
                    }
                } finally { in.close(); }
                String json = new String(out.toByteArray(), "UTF-8");
                WideEnforcementEngine loaded = new WideEnforcementEngine(json);
                snapshotDate = new JSONObject(json).optString("snapshotDate", "");
                engine = loaded;
                loadStatus = "公告 " + loaded.totalRecords + " 筆 · 有座標 " + loaded.locatedRecords
                        + " 筆 · 待定位 " + loaded.pendingLocationRecords + " 筆";
            } catch (Exception e) {
                loadStatus = "科技執法資料載入失敗：" + e.getClass().getSimpleName();
            }
        }});
    }

    /** Hooked only after WideCamera accepted a newer real GPS-provider timestamp. */
    public static void onFix(WideCameraEngine.Fix fix) { offer(null, fix, null, false); }

    /** Receives the prepared fix and the exact decision from the existing road-trace worker. */
    public static void onRoadUpdate(WideHcopRoad.Data data, WideCameraEngine.Fix fix, WideHcopRoad.Decision road) {
        offer(data, fix, road, true);
    }

    private static void offer(WideHcopRoad.Data data, WideCameraEngine.Fix fix, WideHcopRoad.Decision road, boolean roadResult) {
        if (!enabled || fix == null || fix.time <= rejectThrough) return;
        synchronized (LOCK) {
            Update u = new Update(data, fix, road, generation, roadResult);
            if (prefer(pending, u)) pending = u;
            if (draining) return;
            draining = true;
        }
        WORK.execute(new Runnable() { public void run() { drain(); }});
    }

    /** Completed road results take priority over raw callbacks, including a negative result. */
    private static boolean prefer(Update previous, Update next) {
        return previous == null || previous.fix.time < next.fix.time
                || (previous.fix.time == next.fix.time && (!previous.roadResult || next.roadResult));
    }

    private static boolean shouldProcess(Update update) {
        return update.fix.time > processedFix || (update.fix.time == processedFix
                && (!processedRoadResult || update.roadResult));
    }

    private static void drain() {
        while (true) {
            final Update u;
            synchronized (LOCK) {
                u = pending; pending = null;
                if (u == null) { draining = false; return; }
            }
            if (u.generation != generation || !enabled || u.fix.time <= rejectThrough) continue;
            WideEnforcementEngine e = engine;
            if (e == null) continue;
            if (processedGeneration != u.generation) {
                e.clear(); processedFix = 0; processedRoadResult = false; lastRoadFix = null; processedGeneration = u.generation;
            }
            if (!shouldProcess(u)) continue;
            try {
                final WideEnforcementEngine.Frame frame = e.update(u.fix, u.data, u.road,
                        SystemClock.elapsedRealtime(), System.currentTimeMillis());
                if (!commit(u, frame)) continue;
                log(published);
                if (frame.speechText != null && !frame.speechText.isEmpty() && voiceEnabled) {
                    MAIN.post(new Runnable() { public void run() { speak(frame, u.generation); }});
                }
            } catch (Exception failure) {
                published = null;
                loadStatus = "科技執法判定暫停：" + failure.getClass().getSimpleName();
            }
        }
    }

    /** Linearizes publication with clear(): an invalidated worker can never republish its frame. */
    private static boolean commit(Update update, WideEnforcementEngine.Frame frame) {
        synchronized (LOCK) {
            if (update.generation != generation || !enabled || update.fix.time <= rejectThrough) return false;
            processedFix = update.fix.time;
            processedRoadResult = update.roadResult;
            // A raw callback may bridge the short worker gap using the OLD fixed expiry.
            // Every completed road result, including no match, replaces that retained frame.
            if (!retainRoadFrame(update, frame)) published = frame;
            if (update.hasRoad()) lastRoadFix = update.fix;
            return true;
        }
    }

    private static boolean retainRoadFrame(Update u, WideEnforcementEngine.Frame raw) {
        WideEnforcementEngine.Frame previous = published;
        WideCameraEngine.Fix f = u.fix, old = lastRoadFix;
        long now = SystemClock.elapsedRealtime();
        if (u.roadResult || previous == null || previous.primary == null || old == null
                || !speechLevel(previous.primary.level)
                || now > previous.expiresElapsedMs || now < previous.fixElapsedMs
                || f.time <= previous.fixElapsedMs || f.mock || !Double.isFinite(f.accuracy)
                || f.accuracy <= 0 || f.accuracy > 30 || now < f.time || now-f.time > 3000
                || !Double.isFinite(f.lat) || !Double.isFinite(f.lon)
                || (f.speedValid && (!Double.isFinite(f.speed) || f.speed < 1.5 || f.speed > 65))) return false;
        double moved = WideCameraEngine.distance(old.lat,old.lon,f.lat,f.lon);
        double limit = Math.max(30,Math.max(old.speed,f.speed)*(f.time-old.time)/1000.0+f.accuracy+old.accuracy+10);
        if (!Double.isFinite(moved) || !Double.isFinite(limit) || moved > limit) return false;
        if (f.headingValid && old.headingValid && WideCameraEngine.difference(f.heading,old.heading)>40) return false;
        if (!f.headingValid && old.headingValid && moved>3
                && WideCameraEngine.difference(WideCameraEngine.bearing(old.lat,old.lon,f.lat,f.lon),old.heading)>40) return false;
        return true;
    }

    private static void speak(final WideEnforcementEngine.Frame frame, final long gen) {
        long now = SystemClock.elapsedRealtime();
        WideEnforcementEngine.Frame live = current();
        WideEnforcementEngine.Alert owner = null;
        for (WideEnforcementEngine.Alert alert : frame.nearby)
            if (alert.id.equals(frame.speechAlertId)) { owner = alert; break; }
        final String signature = owner == null ? "" : speechSignature(owner, gen);
        if (context == null || gen != generation || !voiceEnabled || now < cameraVoiceUntil
                || live == null || frame.speechKey == null || frame.speechAlertId == null
                || !isSpeechCurrent(frame.speechAlertId, signature) || now > frame.expiresElapsedMs) return;
        WideEnforcementVoice.speak(context, frame.speechText, frame.speechKey, frame.speechAlertId, signature, new Runnable() { public void run() {
            WORK.execute(new Runnable() { public void run() {
                if (gen == generation && engine != null) engine.spoken(frame.speechKey, SystemClock.elapsedRealtime());
            }});
        }});
    }

    public static void clear() {
        synchronized (LOCK) {
            generation++;
            rejectThrough = SystemClock.elapsedRealtime();
            pending = null;
            published = null;
        }
        // The worker resets at the generation boundary before its next update.
        // Enqueuing a reset here could erase a newer fix already drained by that worker.
        MAIN.post(new Runnable() { public void run() { WideEnforcementVoice.stop("定位已停止或資料已撤銷"); }});
    }

    public static void cameraVoiceStarted() {
        cameraVoiceUntil = SystemClock.elapsedRealtime() + 8000;
        MAIN.post(new Runnable() { public void run() { WideEnforcementVoice.stop("優先播放測速提醒"); }});
    }

    public static WideEnforcementEngine.Frame current() {
        synchronized (LOCK) {
            WideEnforcementEngine.Frame f = published;
            long now = SystemClock.elapsedRealtime();
            return enabled && WideCamera.running && f != null && now >= f.fixElapsedMs && now <= f.expiresElapsedMs ? f : null;
        }
    }

    public static boolean enabled() { return enabled; }
    public static boolean voiceEnabled() { return voiceEnabled; }
    public static boolean isSpeechCurrent(String owner, String expectedSignature) {
        synchronized (LOCK) {
            WideEnforcementEngine.Frame f = current();
            if (!voiceEnabled || SystemClock.elapsedRealtime() < cameraVoiceUntil || f == null
                    || owner == null || expectedSignature == null || expectedSignature.isEmpty()) return false;
            for (WideEnforcementEngine.Alert alert : f.nearby)
                if (speechLevel(alert.level) && alert.id.equals(owner))
                    return expectedSignature.equals(speechSignature(alert, generation));
            return false;
        }
    }
    /** Binds the wording to the exact confidence and applicable notices, not just a grouped location. */
    private static String speechSignature(WideEnforcementEngine.Alert alert, long epoch) {
        List<String> ids = new ArrayList<String>(alert.recordIds);
        Collections.sort(ids);
        StringBuilder key = new StringBuilder().append(epoch).append(':');
        signaturePart(key, alert.id);
        signaturePart(key, alert.level.name());
        for (String id : ids) signaturePart(key, id);
        return key.toString();
    }
    private static void signaturePart(StringBuilder key, String value) {
        key.append(value.length()).append('#').append(value);
    }
    private static boolean speechLevel(WideEnforcementEngine.Level level) {
        return level == WideEnforcementEngine.Level.AHEAD || level == WideEnforcementEngine.Level.DIRECTION_UNKNOWN;
    }
    public static void setEnabled(Context c, boolean value) {
        init(c); enabled = value;
        context.getSharedPreferences(PREFS, 0).edit().putBoolean("enabled", value).apply();
        clear();
    }
    public static void setVoiceEnabled(Context c, boolean value) {
        init(c); voiceEnabled = value;
        context.getSharedPreferences(PREFS, 0).edit().putBoolean("voice", value).apply();
        if (!value) MAIN.post(new Runnable() { public void run() { WideEnforcementVoice.stop("科技執法語音已關閉"); }});
    }
    public static void previewVoice(Context c) {
        init(c);
        WideEnforcementVoice.speak(context, "科技執法語音試聽。前方科技執法，留意紅燈及行人。", "preview", "preview", "preview", null);
    }
    public static String status() {
        if (!enabled) return "科技執法提醒已關閉";
        if (engine == null) return loadStatus;
        if (!WideCamera.running) return "請先啟動 GPS 定位";
        WideEnforcementEngine.Frame f = current();
        return f == null ? "等待新定位；過期提醒已撤銷" : f.status;
    }
    public static String report() {
        StringBuilder s = new StringBuilder("科技執法 · wide.46\n");
        s.append(loadStatus).append("\n資料快照：").append(snapshotDate)
                .append("\n提醒：").append(enabled ? "開" : "關")
                .append(" · 語音：").append(voiceEnabled ? "開" : "關")
                .append("\n").append(status()).append("\n").append(WideEnforcementVoice.status());
        WideEnforcementEngine.Frame f = current();
        if (f != null) for (WideEnforcementEngine.Alert a : f.nearby) {
            s.append("\n\n").append(WideEnforcementLabels.level(a.level)).append(" · ")
                    .append(Math.round(a.distanceMeters)).append(a.alongRoad ? " m（沿路）" : " m（直線）")
                    .append("\n").append(a.location).append("\n")
                    .append(WideEnforcementLabels.categories(a.categories)).append("\n")
                    .append(a.reason).append("\n公告：").append(a.recordIds);
        }
        return s.append("\n\n科技執法只提供畫面及語音提醒，不產生道路速限或自動減速指令。")
                .append("\n無座標公告保留在清冊，不能定位提醒。資料日期不代表每個設備仍有效。")
                .toString();
    }
    private static void log(WideEnforcementEngine.Frame f) {
        try {
            JSONObject j = new JSONObject();
            j.put("status", f.status); j.put("fix_mono_ms", f.fixElapsedMs);
            j.put("expires_mono_ms", f.expiresElapsedMs); j.put("control_sent", false);
            if (f.primary != null) {
                j.put("id", f.primary.id); j.put("level", f.primary.level.name());
                j.put("distance_m", Math.round(f.primary.distanceMeters));
                j.put("along_road", f.primary.alongRoad); j.put("reason", f.primary.reason);
            }
            WideBridgeLog.event("enforcement_alert", j);
        } catch (Exception ignored) { }
    }
    private WideEnforcementRuntime() { }
}
