package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.SharedPreferences;
import java.lang.ref.WeakReference;

/** Projection selection for the Taiwan build. The app continues to use the original navigation bridge. */
public final class WideVariant {
    private static final String PREFS = "copilot_tw_projection";
    private static final String NAVIGATION_KEY = "navigation_package";
    private static final String PHONE_KEY = "phone_amap";
    static final String GOOGLE_PACKAGE = "com.google.android.apps.maps";
    static final String GOOGLE_DISPLAY = "WideGoogleMaps";

    enum Navigation {
        CAR("com.autonavi.amapauto", "高德車機版", "高德車機", "WideAmapAuto"),
        PHONE("com.autonavi.minimap", "高德一般版", "高德一般", "WideAmapPhone"),
        GOOGLE(GOOGLE_PACKAGE, "Google 地圖", "Google 地圖", GOOGLE_DISPLAY);

        final String packageName, label, compactLabel, displayName;

        Navigation(String packageName, String label, String compactLabel, String displayName) {
            this.packageName = packageName;
            this.label = label;
            this.compactLabel = compactLabel;
            this.displayName = displayName;
        }

        static Navigation restore(String saved, boolean legacyPhone) {
            for (Navigation option : values()) {
                if (option.packageName.equals(saved)) return option;
            }
            return legacyPhone ? PHONE : CAR;
        }
    }

    private static WeakReference<Activity> host = new WeakReference<>(null);
    private static Navigation navigation = Navigation.CAR;
    private static boolean shield;
    private static volatile boolean teslaShield;

    public static void prepare(Activity activity) {
        host = new WeakReference<>(activity);
        SharedPreferences prefs = activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        boolean legacyPhone = prefs.getBoolean(PHONE_KEY,
                !installed(activity, Navigation.CAR.packageName) && installed(activity, Navigation.PHONE.packageName));
        navigation = Navigation.restore(prefs.getString(NAVIGATION_KEY, null), legacyPhone);
        shield = prefs.getBoolean("shield_panel", false);
        teslaShield = prefs.getBoolean("tesla_shield", false);
        WideAmapSource.select(packageName());
    }

    public static void init(Activity activity) { WideCamera.init(activity); }

    static Navigation navigation() { return navigation; }
    public static boolean isPhone() { return navigation == Navigation.PHONE; }
    public static String packageName() { return navigation.packageName; }
    public static String mapName() { return navigation.label; }
    public static String displayName() { return navigation.displayName; }

    static void select(Activity activity, Navigation next) {
        if (navigation == next) return;
        navigation = next;
        SharedPreferences.Editor editor = activity.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putString(NAVIGATION_KEY, next.packageName);
        if (next != Navigation.GOOGLE) editor.putBoolean(PHONE_KEY, isPhone());
        editor.apply();
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
