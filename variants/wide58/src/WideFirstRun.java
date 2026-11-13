package com.navipilot.obf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

public final class WideFirstRun {
    private static final String PREFS = "carrot_bridge_introduction";
    private static final String ACKNOWLEDGED = "read_v1";
    private static AlertDialog current;

    private WideFirstRun() {}

    public static void show(Activity activity) {
        SharedPreferences prefs = activity.getSharedPreferences(PREFS, Activity.MODE_PRIVATE);
        if (activity.isFinishing() || prefs.getBoolean(ACKNOWLEDGED, false)) return;
        if (current != null && current.getOwnerActivity() == activity && current.isShowing()) return;
        if (current != null) current.dismiss();

        ScrollView scroll = new ScrollView(activity);
        LinearLayout content = new LinearLayout(activity);
        content.setOrientation(LinearLayout.VERTICAL);
        int padding = WideUi.dp(activity, 20);
        content.setPadding(padding, WideUi.dp(activity, 12), padding, WideUi.dp(activity, 8));
        scroll.addView(content);
        addSection(content, "功能介紹",
                "Carrot Bridge 可投屏地圖及相容的 App，並顯示 comma 車況與連線資訊。支援的導航來源可將路線與轉彎資訊傳給 C4。\n\n"
                        + "停車後，在「地圖投屏」選擇導航來源，依畫面提示完成投屏授權。需要排查時，可從「即時診斷」匯出報告。");
        addSection(content, "使用須知與免責",
                "本 App 提供導航與車況資訊供參考，資料可能有延遲、誤差或中斷。請以現場路況、交通標誌及車輛警示為準。\n\n"
                        + "駕駛人須全程注意路況並能隨時接手。請在停車時操作投屏、導航設定及 ChatGPT。");
        AlertDialog dialog = new AlertDialog.Builder(activity)
                .setTitle("Carrot Bridge")
                .setView(scroll)
                .setCancelable(false)
                .setPositiveButton("我已閱讀", new DialogInterface.OnClickListener() {
                    @Override public void onClick(DialogInterface ignored, int which) {
                        prefs.edit().putBoolean(ACKNOWLEDGED, true).apply();
                    }
                }).create();
        dialog.setOwnerActivity(activity);
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            @Override public void onDismiss(DialogInterface dismissed) {
                if (current == dismissed) current = null;
            }
        });
        current = dialog;
        dialog.show();
    }

    public static void dismiss(Activity activity) {
        if (current != null && current.getOwnerActivity() == activity) current.dismiss();
    }

    private static void addSection(LinearLayout content, String title, String body) {
        Activity activity = (Activity) content.getContext();
        TextView heading = new TextView(activity);
        heading.setText(title);
        heading.setTextSize(17);
        heading.setTypeface(android.graphics.Typeface.DEFAULT, android.graphics.Typeface.BOLD);
        content.addView(heading);
        TextView paragraph = new TextView(activity);
        paragraph.setText(body);
        paragraph.setTextSize(15);
        paragraph.setLineSpacing(WideUi.dp(activity, 3), 1);
        paragraph.setPadding(0, WideUi.dp(activity, 8), 0, WideUi.dp(activity, 18));
        content.addView(paragraph);
    }
}
