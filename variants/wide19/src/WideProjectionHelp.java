package com.navipilot.obf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.widget.Toast;

/** Launches the chosen manager when needed, and keeps authorization in Android's normal flow. */
public final class WideProjectionHelp {
    static final String SHIZUKU = "moe.shizuku.privileged.api";
    static final String STELLAR = "roro.stellar.manager";
    private static final String MANAGER = "projection_manager";
    private static final String AUTO = "projection_manager_on_open";

    private static SharedPreferences prefs(Context context) {
        return context.getSharedPreferences("copilot_tw_projection", Context.MODE_PRIVATE);
    }

    static boolean connected() {
        try { return zU.e(); } catch (RuntimeException unavailable) { return false; }
    }

    public static void onOpen(Activity activity) {
        if (!prefs(activity).getBoolean(AUTO, false) || connected()) return;
        launch(activity, prefs(activity).getString(MANAGER, SHIZUKU), false);
    }

    static void start(Activity activity, tr original) {
        if (connected() && original != null) original.c();
        else if (activity != null) show(activity);
    }

    static void show(Activity activity) {
        String manager = prefs(activity).getString(MANAGER, SHIZUKU);
        String label = STELLAR.equals(manager) ? "Stellar" : "Shizuku";
        boolean auto = prefs(activity).getBoolean(AUTO, false);
        boolean authorized;
        try { authorized = connected() && zU.c() == 0; }
        catch (RuntimeException unavailable) { authorized = false; }
        new AlertDialog.Builder(activity)
                .setTitle("投屏安裝與授權")
                .setMessage("服務：" + (connected() ? (authorized ? "已連線、已授權" : "已連線、待授權") : "尚未啟動")
                        + "\n管理工具：" + label
                        + "\n開 App 時開啟管理工具：" + (auto ? "已開" : "已關")
                        + "\n\n1. 安裝 Shizuku 或 Stellar，擇一啟動。\n"
                        + "2. Android 11 以上開啟開發人員選項與無線偵錯，在工具內配對並按啟動。沒有無線偵錯的車機可依管理工具指引用電腦 ADB。\n"
                        + "3. Stellar 請開啟 Shizuku 相容層。回到 Copilot tw 按啟動投屏，在系統提示中授權。\n"
                        + "4. 重開機後若服務已停止，回管理工具重新啟動。")
                .setPositiveButton("開啟 " + label, (d, w) -> launch(activity, manager, true))
                .setNeutralButton("選工具與自動開啟", (d, w) -> choose(activity))
                .setNegativeButton("關閉", null).show();
    }

    private static void choose(Activity activity) {
        new AlertDialog.Builder(activity).setTitle("投屏管理工具")
                .setItems(new String[]{"Shizuku", "Stellar", "切換開 App 時開啟管理工具"}, (d, which) -> {
                    if (which == 2) {
                        SharedPreferences p = prefs(activity);
                        p.edit().putBoolean(AUTO, !p.getBoolean(AUTO, false)).apply();
                    } else prefs(activity).edit().putString(MANAGER, which == 0 ? SHIZUKU : STELLAR).apply();
                    show(activity);
                }).show();
    }

    private static void launch(Activity activity, String packageName, boolean offerInstall) {
        try {
            Intent intent = activity.getPackageManager().getLaunchIntentForPackage(packageName);
            if (intent != null) {
                activity.startActivity(intent);
            } else if (offerInstall) {
                String url = STELLAR.equals(packageName) ? "https://github.com/roro2239/Stellar/releases"
                        : "https://github.com/RikkaApps/Shizuku/releases";
                activity.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
            }
        } catch (RuntimeException unavailable) {
            Toast.makeText(activity, "請從桌面開啟投屏管理工具", Toast.LENGTH_SHORT).show();
        }
    }
}
