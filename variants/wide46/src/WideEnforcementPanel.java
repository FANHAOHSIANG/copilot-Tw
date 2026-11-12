package com.navipilot.obf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.speech.tts.TextToSpeech;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

/** User controls and observable validation state for the new reminder source. */
public final class WideEnforcementPanel {
    private static TextView text(Activity a, String value, int size) {
        TextView t = new TextView(a); t.setText(value); t.setTextSize(size); t.setTextColor(0xffeaf3ff);
        t.setPadding(0, 12, 0, 12); t.setTextIsSelectable(true); return t;
    }
    private static Button button(Activity a, String value, View.OnClickListener action) {
        Button b = new Button(a); b.setText(value); b.setTextSize(14); b.setOnClickListener(action); return b;
    }
    public static void show(final Activity a) {
        if (a == null || a.isFinishing() || a.isDestroyed()) return;
        WideEnforcementRuntime.init(a);
        LinearLayout body = new LinearLayout(a); body.setOrientation(LinearLayout.VERTICAL);
        int pad = WideUi.dp(a, 16); body.setPadding(pad, pad, pad, pad); body.setBackgroundColor(0xff122238);
        body.addView(text(a, "科技執法提醒", 21));
        body.addView(text(a, "啟動 GPS 即可使用，不需設定目的地。同路前方且持續接近時才播報；取締方向不明會明說「方向待確認」。只在附近、道路不明或適用條件不明的公告只顯示，不播報。", 14));
        final Button enable = button(a, "", null);
        enable.setText(WideEnforcementRuntime.enabled() ? "科技執法提醒：開" : "科技執法提醒：關");
        enable.setOnClickListener(new View.OnClickListener() { public void onClick(View v) {
            WideEnforcementRuntime.setEnabled(a, !WideEnforcementRuntime.enabled());
            enable.setText(WideEnforcementRuntime.enabled() ? "科技執法提醒：開" : "科技執法提醒：關");
        }}); body.addView(enable);
        final Button voice = button(a, "", null);
        voice.setText(WideEnforcementRuntime.voiceEnabled() ? "科技執法語音：開" : "科技執法語音：關");
        voice.setOnClickListener(new View.OnClickListener() { public void onClick(View v) {
            WideEnforcementRuntime.setVoiceEnabled(a, !WideEnforcementRuntime.voiceEnabled());
            voice.setText(WideEnforcementRuntime.voiceEnabled() ? "科技執法語音：開" : "科技執法語音：關");
        }}); body.addView(voice);
        body.addView(button(a, "試聽科技執法語音", new View.OnClickListener() { public void onClick(View v) {
            WideEnforcementRuntime.previewVoice(a);
            Toast.makeText(a, WideEnforcementVoice.status(), Toast.LENGTH_LONG).show();
        }}));
        body.addView(button(a, "安裝／管理中文語音資料", new View.OnClickListener() { public void onClick(View v) {
            try { a.startActivity(new Intent(TextToSpeech.Engine.ACTION_INSTALL_TTS_DATA)); }
            catch (RuntimeException missing) {
                try { a.startActivity(new Intent("com.android.settings.TTS_SETTINGS")); }
                catch (RuntimeException ignored) { Toast.makeText(a, "請到系統設定搜尋「文字轉語音」，安裝離線中文語音", Toast.LENGTH_LONG).show(); }
            }
        }}));
        body.addView(button(a, WideBridgeLog.recording() ? "停止測試紀錄" : "開始測試紀錄（含 GPS 軌跡）", new View.OnClickListener() { public void onClick(View v) {
            WideBridgeLog.toggle(); ((Button)v).setText(WideBridgeLog.recording() ? "停止測試紀錄" : "開始測試紀錄（含 GPS 軌跡）");
        }}));
        body.addView(button(a, "停止並匯出測試紀錄 ZIP", new View.OnClickListener() { public void onClick(View v) { WideBridgeLog.share(a); }}));
        body.addView(button(a, "複製科技執法診斷", new View.OnClickListener() { public void onClick(View v) {
            ClipboardManager clipboard = (ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE);
            if (clipboard != null) clipboard.setPrimaryClip(ClipData.newPlainText("科技執法診斷", WideEnforcementRuntime.report()));
            Toast.makeText(a, "已複製", Toast.LENGTH_SHORT).show();
        }}));
        final TextView report = text(a, WideEnforcementRuntime.report(), 13); body.addView(report);
        body.addView(text(a, "距離分為「沿路」與「直線」。直線附近點可能在對向、其他道路或不同層級。純測速、區間測速沿用原提醒，避免重複播報；其他科技執法不會變成速限或減速指令。", 13));
        ScrollView scroll = new ScrollView(a); scroll.addView(body);
        final AlertDialog dialog = new AlertDialog.Builder(a).setView(scroll).setPositiveButton("關閉", null).create();
        final Handler main = new Handler(Looper.getMainLooper());
        final Runnable tick = new Runnable() { public void run() {
            if (!dialog.isShowing()) return;
            report.setText(WideEnforcementRuntime.report()); main.postDelayed(this, 1000);
        }};
        dialog.setOnDismissListener(d -> main.removeCallbacks(tick)); dialog.show(); main.post(tick);
    }
    private WideEnforcementPanel() { }
}
