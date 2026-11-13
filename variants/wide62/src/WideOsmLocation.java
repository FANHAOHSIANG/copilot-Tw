package com.navipilot.obf;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.widget.LinearLayout;
import android.widget.Switch;

public final class WideOsmLocation {
    private static final String BADGE_VISIBLE = "badge_visible";
    private static final String SEND_LIMIT = "send_limit_to_c4";
    private static volatile boolean sendLimit;
    private static final String SHIELD_SIZE = "shield_size_protection";
    private static final String ASKED = "permission_requested";

    private static SharedPreferences prefs(Context context) {
        return context.getSharedPreferences("copilot_osm_location", Context.MODE_PRIVATE);
    }

    static boolean badgeVisible(Context context) {
        return prefs(context).getBoolean(BADGE_VISIBLE, true);
    }

    static boolean sendLimitToC4() {
        return sendLimit;
    }

    public static void onResume(Activity activity) {
        sendLimit = prefs(activity).getBoolean(SEND_LIMIT, false);
        WideShieldSize.protect = prefs(activity).getBoolean(SHIELD_SIZE, false);
        activity.getWindow().getDecorView().post(() -> {
            if (activity.isFinishing() || activity.isDestroyed()) return;
            start(activity, !prefs(activity).getBoolean(ASKED, false));
        });
    }

    public static void onPermissionResult(Activity activity, int requestCode) {
        if (requestCode == 0x4f62) onResume(activity);
    }

    private static void start(Activity activity, boolean requestPermission) {
        if (activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            if (requestPermission) {
                prefs(activity).edit().putBoolean(ASKED, true).apply();
                activity.requestPermissions(new String[] {Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_COARSE_LOCATION}, 0x4f62);
            }
            return;
        }
        if (WideCamera.running) return;
        LocationManager location = activity.getSystemService(LocationManager.class);
        if (location == null || !location.isProviderEnabled(LocationManager.GPS_PROVIDER)) return;
        try {
            activity.startForegroundService(new Intent().setClassName(activity,
                    "com.navipilot.obf.WideCameraService"));
        } catch (IllegalStateException | SecurityException error) {
            WideCamera.error("OSM 定位啟動失敗");
        }
    }

    public static void addSetting(Activity activity, LinearLayout list) {
        Switch badge = setting(activity, "顯示 OSM 速限牌", badgeVisible(activity));
        badge.setOnCheckedChangeListener((button, checked) ->
                prefs(activity).edit().putBoolean(BADGE_VISIBLE, checked).apply());
        list.addView(badge, 1);

        Switch send = setting(activity, "傳送 OSM 道路速限至 C4",
                prefs(activity).getBoolean(SEND_LIMIT, false));
        send.setOnCheckedChangeListener((button, checked) -> {
            sendLimit = checked;
            prefs(activity).edit().putBoolean(SEND_LIMIT, checked).apply();
        });
        list.addView(send, 2);

        Switch shield = setting(activity, "神盾取樣診斷與尺寸保護",
                WideShieldSize.protect);
        shield.setOnCheckedChangeListener((button, checked) -> {
            WideShieldSize.protect = checked;
            prefs(activity).edit().putBoolean(SHIELD_SIZE, checked).apply();
        });
        list.addView(shield, 3);
    }

    private static Switch setting(Activity activity, String text, boolean checked) {
        Switch toggle = new Switch(activity);
        toggle.setText(text);
        toggle.setMinHeight(Math.round(48 * activity.getResources().getDisplayMetrics().density));
        toggle.setChecked(checked);
        return toggle;
    }

    static String label(Context context) {
        if (context.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) return "OSM 需定位權限";
        if (!WideCamera.running) return "OSM 定位未啟動";
        return "OSM 等待路段配對";
    }

    private WideOsmLocation() {}
}
