package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.SharedPreferences;
import java.lang.ref.WeakReference;

/** Projection selection for the Taiwan build. The app continues to use the original navigation bridge. */
public final class WideVariant {
    private static final String PREFS = "copilot_tw_projection";
    private static final String PHONE_KEY = "phone_amap";
    private static final String CAR_PACKAGE = "com.autonavi.amapauto";
    private static final String PHONE_PACKAGE = "com.autonavi.minimap";
    private static WeakReference<Activity> host = new WeakReference<>(null);
    private static boolean phone;
    private static boolean shield;
    private static volatile boolean teslaShield;

    public static void prepare(Activity activity) {
        host = new WeakReference<>(activity);
        SharedPreferences prefs = activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        phone = prefs.getBoolean(PHONE_KEY,
                !installed(activity, CAR_PACKAGE) && installed(activity, PHONE_PACKAGE));
        shield = prefs.getBoolean("shield_panel", false);
        teslaShield = prefs.getBoolean("tesla_shield", false);
        WideAmapSource.select(packageName());
    }

    public static void init(Activity activity) { WideCamera.init(activity); }

    public static boolean isPhone() { return phone; }
    public static String packageName() { return phone ? PHONE_PACKAGE : CAR_PACKAGE; }
    public static String mapName() { return phone ? "高德一般版" : "高德車機版"; }
    public static String displayName() { return phone ? "WideAmapPhone" : "WideAmapAuto"; }

    public static void select(Activity activity, boolean usePhone) {
        phone = usePhone;
        activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putBoolean(PHONE_KEY, usePhone).apply();
        WideAmapSource.select(packageName());
        WideDirect.changeMap();
    }

    static boolean shieldPanel() { return shield; }
    static boolean teslaShield() { return teslaShield; }

    static void togglePanel(Activity activity) {
        shield = !shield;
        activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putBoolean("shield_panel", shield).apply();
        activity.recreate();
    }

    static void toggleTeslaShield(Activity activity) {
        if (WideTeslaProjection.isActive()) {
            android.widget.Toast.makeText(activity, "請先停止 Amap2Tesla 投屏", android.widget.Toast.LENGTH_SHORT).show();
            return;
        }
        teslaShield = !teslaShield;
        activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putBoolean("tesla_shield", teslaShield).apply();
        android.widget.Toast.makeText(activity, teslaShield ? "下次 Amap2Tesla 僅投神盾" : "已關閉 Tesla 單投神盾",
                android.widget.Toast.LENGTH_SHORT).show();
    }

    private static boolean installed(Context context, String packageName) {
        try {
            context.getPackageManager().getPackageInfo(packageName, 0);
            return true;
        } catch (android.content.pm.PackageManager.NameNotFoundException missing) {
            return false;
        }
    }

    static Activity activity(Context context) {
        while (context instanceof ContextWrapper) {
            if (context instanceof Activity) return (Activity) context;
            Context base = ((ContextWrapper) context).getBaseContext();
            if (base == context) break;
            context = base;
        }
        return host.get();
    }
}
