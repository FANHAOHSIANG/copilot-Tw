package com.navipilot.obf;

import android.app.Activity;
import android.app.Dialog;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

public final class WideSettings {
    private static final TF ratios = GS.f(Integer.valueOf(5000), bT.k);
    private static final String PREF = "wide_layout_preferences";
    public static int left() { return ((Number)ratios.getValue()).intValue()/100; }
    public static int top() { return ((Number)ratios.getValue()).intValue()%100; }
    private static int dp(Context c, float value) { return Math.round(c.getResources().getDisplayMetrics().density*value); }
    public static void install(final Activity activity) {
        WideTelemetry.init(activity);
        WideCamera.init(activity);
        SharedPreferences prefs = activity.getSharedPreferences(PREF, 0);
        int l = Math.max(25, Math.min(75, prefs.getInt("left_percent", 50)));
        int t = prefs.getInt("top_percent", 60);
        if (t == 0) t = 60;
        t = t == 0 ? 0 : Math.max(20, Math.min(80, t));
        ratios.setValue(Integer.valueOf(l*100+t));
        final ViewGroup root = activity.findViewById(android.R.id.content);
    }
    private static TextView text(Activity a, String value, int size) {
        TextView v=new TextView(a);v.setText(value);v.setTextColor(Color.WHITE);v.setTextSize(size);v.setPadding(0,dp(a,6),0,dp(a,6));return v;
    }
    private static Button action(Activity a, String value, View.OnClickListener listener) {
        Button b=new Button(a);b.setText(value);b.setTextSize(14);b.setOnClickListener(listener);return b;
    }
    public static void show(final Activity a, ViewGroup root) {
        final Dialog dialog=new Dialog(a); dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        LinearLayout panel=new LinearLayout(a);panel.setOrientation(LinearLayout.VERTICAL);panel.setPadding(dp(a,14),dp(a,8),dp(a,14),dp(a,8));panel.setBackgroundColor(0xff172230);
        panel.addView(text(a,"台灣測速 · 串接測試版",20));
        panel.addView(text(a,"左側高德車機版；右上測速面板；右下控制鈕。預設使用高德來源。開啟台灣來源後，通過道路配對的固定測速會替換原有測速資料；高德轉彎與路線維持原流程。",12));
        panel.addView(action(a,WideCamera.running?"停止測速 GPS":"開始測速 GPS",new View.OnClickListener(){public void onClick(View v){if(WideCamera.running)WideCamera.stop(a);else WideCamera.start(a);dialog.dismiss();}}));
        panel.addView(action(a,"開啟車機定位設定",new View.OnClickListener(){public void onClick(View v){try{a.startActivity(new android.content.Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));}catch(RuntimeException e){Toast.makeText(a,"無法開啟系統定位設定",Toast.LENGTH_SHORT).show();}}}));
        panel.addView(action(a,"App 權限設定（精確定位）",new View.OnClickListener(){public void onClick(View v){try{a.startActivity(new android.content.Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,android.net.Uri.parse("package:"+a.getPackageName())));}catch(RuntimeException e){Toast.makeText(a,"無法開啟權限設定",Toast.LENGTH_SHORT).show();}}}));
        panel.addView(text(a,"使用車機 GPS：每秒請求定位。串接只接受精度 ≤15 m、連續 3 次確認的同一道路段固定點。遇到路口、平行道路、高架疑慮、反向或 GPS 過期即撤銷測速。其他候選仍以直線距離顯示，並標示未串接。",12));
        panel.addView(text(a,"固定測速：相機圖示與距離大字，500 m 內轉黃、200 m 內轉紅。區間測速：使用新北官方起終點，記錄到入口後顯示估計剩餘距離與速限通過時間尚餘。秒數歸零仍需遵守道路速限。",12));
        panel.addView(text(a,"GPS 以持續通知運作，離開面板仍可定位；可在通知按停止。示範按鈕依序切換「固定測速 → 區間測速 → 實況」，只讓示範數字倒數，並切回高德來源；不傳送示範數值。若車機沒有 GPS，這版不會自動借用 C4 定位。",12));
        panel.addView(text(a,"畫面比例",20));
        panel.addView(text(a,"可直接拖動地圖右側或測速面板下方的分隔把手；也可在此設定，按「套用並儲存」。",12));
        final TextView leftLabel=text(a,"",15);panel.addView(leftLabel);
        final SeekBar left=new SeekBar(a);left.setMax(50);left.setProgress(left()-25);panel.addView(left);
        final TextView topLabel=text(a,"",15);panel.addView(topLabel);
        final SeekBar top=new SeekBar(a);top.setMax(60);top.setProgress((top()==0 ? 55 : top())-20);panel.addView(top);
        final Runnable refresh=new Runnable(){public void run(){
            int l=left.getProgress()+25,t=top.getProgress()+20;
            leftLabel.setText("導航 "+l+"% ｜右側 "+(100-l)+"%");
            topLabel.setText("右上測速 "+t+"% ｜右下按鍵 "+(100-t)+"%");
        }};
        SeekBar.OnSeekBarChangeListener listener=new SeekBar.OnSeekBarChangeListener(){
            public void onProgressChanged(SeekBar s,int p,boolean user){refresh.run();}
            public void onStartTrackingTouch(SeekBar s){} public void onStopTrackingTouch(SeekBar s){}
        };left.setOnSeekBarChangeListener(listener);top.setOnSeekBarChangeListener(listener);refresh.run();
        panel.addView(action(a,"套用並儲存",new View.OnClickListener(){public void onClick(View v){save(a,left.getProgress()+25,top.getProgress()+20);dialog.dismiss();}}));
        panel.addView(action(a,"恢復預設：左右各半／測速 60%",new View.OnClickListener(){public void onClick(View v){save(a,50,60);dialog.dismiss();}}));
        panel.addView(text(a,"Carrot 資料來源",20));
        panel.addView(action(a,WideBridge.enabled()?"切回高德測速來源":"啟用台灣測速串接（測試）",new View.OnClickListener(){public void onClick(View v){WideBridge.setEnabled(!WideBridge.enabled());dialog.dismiss();}}));
        panel.addView(action(a,WideBridgeLog.recording()?"停止測試紀錄":"開始測試紀錄（含 GPS 軌跡）",new View.OnClickListener(){public void onClick(View v){WideBridgeLog.toggle();dialog.dismiss();}}));
        panel.addView(action(a,"停止並匯出測試紀錄 ZIP",new View.OnClickListener(){public void onClick(View v){WideBridgeLog.share(a);}}));
        panel.addView(text(a,WideBridge.report(),12));
        panel.addView(text(a,"「已排入傳送」不是 C4 接收確認。台灣測速送出時，每 2 秒最多查詢一次接收端；查詢失敗不阻塞導航。只有由接收端 /health 回報相同目標、session、sequence、測速值，才顯示「C4 已接收」；接收不代表已執行減速。沒有相容的 Navi v2 通道時不會另開 UDP 強送。",13));

        panel.addView(text(a,"台灣模式：只有 226 / 1856 個固定點通過圖資初篩，行車時還需確認。未配對時撤銷測速，不自動改回高德測速。高德轉彎、路線與新鮮道路速限保留。重新啟動 App 會回到高德來源。",14));
        panel.addView(text(a,"區間僅顯示、不串接：本版只含新北 24 個方向區間。須連續記錄 GPS 通過入口才開始計時；中途開啟、GPS 中斷超過 5 秒、誤差超過 30 m、跳點或入口重疊時，不顯示有效倒數。未確認同一道路，不能保證符合執法設備的實際計時。",13));
        panel.addView(text(a,"面板候選診斷（不同於串接判定）",20));
        panel.addView(text(a,WideCamera.report(),11));
        panel.addView(action(a,"複製測速診斷（含目前座標）",new View.OnClickListener(){public void onClick(View v){
            ClipboardManager clipboard=(ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE);
            clipboard.setPrimaryClip(ClipData.newPlainText("測速診斷",WideCamera.report()));
            Toast.makeText(a,"已複製測速與 GPS 診斷",Toast.LENGTH_SHORT).show();
        }}));
        panel.addView(text(a,"資料來源：警政署 2026 測速執法設置點。本 App 整理之固定點快照，依政府資料開放授權條款第 1 版使用。\nhttps://data.gov.tw/dataset/7320\nhttps://data.gov.tw/license\n新增：新北市政府警察局 2026 區間平均速率執法設備設置地點（政府資料開放授權條款第 1 版）。\nhttps://data.ntpc.gov.tw/datasets/27b97ad9-9dba-4ca9-b0ed-14b29000ffec\n下載日期不是各點更新日期。固定點官方不定期更新，新北區間目錄標示每年更新。",12));
        panel.addView(text(a,"道路圖資：© OpenStreetMap contributors，Geofabrik Taiwan 2026-11-08。ODbL 1.0。\nhttps://www.openstreetmap.org/copyright\n只取同一道路的路口間片段，不推測跨路口路線。資料快照不保證所有測速點仍在使用。",12));
        panel.addView(text(a,WideDirect.report(),12));
        panel.addView(text(a,WideTelemetry.report(),12));
        panel.addView(action(a,"複製目前車況診斷",new View.OnClickListener(){public void onClick(View v){
            ClipboardManager clipboard=(ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE);
            clipboard.setPrimaryClip(ClipData.newPlainText("車況診斷",WideTelemetry.report()));
            Toast.makeText(a,"已複製，可貼上回報",Toast.LENGTH_SHORT).show();
        }}));
        panel.addView(action(a,"關閉",new View.OnClickListener(){public void onClick(View v){dialog.dismiss();}}));
        ScrollView scroll=new ScrollView(a);scroll.setFillViewport(true);scroll.addView(panel);dialog.setContentView(scroll);
        Window w=dialog.getWindow();w.setBackgroundDrawableResource(android.R.color.transparent);
        w.clearFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
        w.addFlags(WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL);
        dialog.show();
        int width=root.getWidth(),height=root.getHeight();
        int right=Math.round(width*(100-left())/100f);
        w.setLayout(Math.max(dp(a,240),right),height);
        w.setGravity(Gravity.RIGHT|Gravity.TOP);
    }
    public static void preview(int left,int top){
        left=Math.max(25,Math.min(75,left));
        top=top==0?0:Math.max(20,Math.min(80,top));
        ratios.setValue(Integer.valueOf(left*100+top));
    }
    public static void save(Activity a,int left,int top){
        a.getSharedPreferences(PREF,0).edit().putInt("left_percent",left).putInt("top_percent",top).apply();
        preview(left,top);
    }
}
