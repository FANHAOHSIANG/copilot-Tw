package com.navipilot.obf;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Build;
import java.lang.ref.WeakReference;
import java.util.Map;
import java.util.WeakHashMap;
import org.json.JSONObject;

/** Keeps the broadcast producer, pending decoder work and Navi v2 data on one selection. */
public final class WideAmapSource {
    private static final String AUTO = "com.autonavi.amapauto";
    private static final String PHONE = "com.autonavi.minimap";
    private static final String[] STREAMS = {
        "guidance_current", "guidance_next", "route", "speed", "navigation_status",
        "vehicle", "lane_current", "road_category", "traffic_signal", "ui_route_changed"
    };
    private static final WeakHashMap<Intent, Long> pending = new WeakHashMap<>();
    private static volatile String selected = AUTO;
    private static volatile long selectedSince;
    private static volatile boolean ready;
    private static long generation;
    private static volatile WeakReference<IG> parser = new WeakReference<>(null);
    private static volatile WeakReference<MG> bridge = new WeakReference<>(null);
    private static volatile String inputStatus = "等待所選高德的新資料";

    private static boolean isAmap(String packageName) {
        return AUTO.equals(packageName) || PHONE.equals(packageName);
    }

    static boolean matches(String selectedPackage, String sender, String action) {
        if (!isAmap(selectedPackage)) return false;
        if (sender != null && !sender.isEmpty()) return selectedPackage.equals(sender);
        if (PHONE.equals(selectedPackage)) {
            return "com.autonavi.minimap.broadcast".equals(action)
                    || "com.autonavi.minimap.navigation.broadcast".equals(action);
        }
        return AUTO.equals(selectedPackage) && "AUTONAVI_STANDARD_BROADCAST_SEND".equals(action);
    }

    public static synchronized boolean accept(BroadcastReceiver receiver, Intent intent) {
        if (intent == null || !isAmap(selected)) return false;
        String sender = Build.VERSION.SDK_INT >= 34 ? receiver.getSentFromPackage() : null;
        if (!matches(selected, sender, intent.getAction())) return false;
        pending.put(intent, generation);
        return true;
    }

    public static void attach(IG state) {
        parser = new WeakReference<>(state);
    }

    public static synchronized void dispatch(h4 receiver, Intent intent, int keyType) {
        Long stamped = pending.remove(intent);
        if (stamped == null || stamped.longValue() != generation) return;
        inputStatus = "已收到所選高德廣播，等待可用導航欄位";
        ready = true;
        h4.a(receiver, intent, keyType);
    }

    static synchronized void select(String packageName) {
        if (!isAmap(packageName) && !WideVariant.GOOGLE_PACKAGE.equals(packageName)) return;
        if (selectedSince != 0 && selected.equals(packageName)) return;
        ready = false;
        selectedSince = System.currentTimeMillis();
        selected = packageName;
        generation++;
        pending.clear();
        inputStatus = isAmap(packageName) ? "等待所選高德的新資料" : "Google 地圖僅投屏，高德資料已停用";
        IG state = parser.get();
        if (state != null) state.f(selectedSince);
        MG wire = bridge.get();
        if (wire != null) {
            synchronized (wire) {
                for (String stream : STREAMS) wire.b(stream, null, "amap_source_changed");
            }
        }
    }

    public static JSONObject filter(MG wire, String stream, JSONObject value, Map<?, ?> timestamps) {
        if (bridge.get() != wire) bridge = new WeakReference<>(wire);
        if (value == null || "app_status".equals(stream)) return value;
        if (!ready || !isAmap(selected)) return null;
        Object time = timestamps.get(stream);
        if (!(time instanceof Number) || ((Number) time).longValue() < selectedSince) return null;
        return value;
    }

    static String status() { return inputStatus; }
}
