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

public final class WideTaiwanSettings {
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
    public static void show(final Activity a, final ViewGroup root) {
        final Dialog dialog=new Dialog(a); dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        LinearLayout panel=new LinearLayout(a);panel.setOrientation(LinearLayout.VERTICAL);panel.setPadding(dp(a,14),dp(a,8),dp(a,14),dp(a,8));panel.setBackgroundColor(0xff172230);
        panel.addView(text(a,"HCOP 台灣速限 · 測試版",20));
        panel.addView(text(a,"橫向左導航、右台灣測速；直向上導航、下台灣測速。預設使用高德來源；台灣資料先預覽。啟用台灣後，會取代道路速限與測速欄位；高德轉彎與路線繼續運作。",12));
        panel.addView(action(a,WideCamera.running?"停止測速 GPS":"開始測速 GPS",new View.OnClickListener(){public void onClick(View v){if(WideCamera.running)WideCamera.stop(a);else WideCamera.start(a);dialog.dismiss();}}));
        panel.addView(action(a,"開啟車機定位設定",new View.OnClickListener(){public void onClick(View v){try{a.startActivity(new android.content.Intent(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));}catch(RuntimeException e){Toast.makeText(a,"無法開啟系統定位設定",Toast.LENGTH_SHORT).show();}}}));
        panel.addView(action(a,"App 權限設定（精確定位）",new View.OnClickListener(){public void onClick(View v){try{a.startActivity(new android.content.Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,android.net.Uri.parse("package:"+a.getPackageName())));}catch(RuntimeException e){Toast.makeText(a,"無法開啟權限設定",Toast.LENGTH_SHORT).show();}}}));
        panel.addView(text(a,"採用 OSM 離線道路、HCOP 的 TDX 方向速限，以及警政署局部修正。定位需精度 ≤15 m、連續 3 次且移動 5 m。GPS 超過 3 秒、道路重疊或速限衝突時，不採用該筆速限。",12));
        panel.addView(text(a,"固定測速只顯示已確認同路段的點；距離沿道路計算，不跨路口猜路線。區間資料仍可在診斷查看；符合方向初篩且在 500 公尺內的附近固定點只在畫面提醒。未配對的固定點與區間資料不傳給 Carrot。",12));
        panel.addView(text(a,"GPS 以持續通知運作，離開面板仍可定位；可在通知按停止。示範視窗只顯示模擬數字。若車機沒有 GPS，這版不會自動借用 C4 定位。",12));
        panel.addView(action(a,"版面與比例設定",new View.OnClickListener(){public void onClick(View v){dialog.dismiss();WideSettings.show(a,root);}}));
        panel.addView(text(a,"Carrot 資料來源",20));
        panel.addView(action(a,WideBridge.enabled()?"切回高德道路速限與測速":"啟用 HCOP 台灣道路速限＋測速（測試）",new View.OnClickListener(){public void onClick(View v){WideBridge.setEnabled(!WideBridge.enabled());dialog.dismiss();}}));
        panel.addView(action(a,WideBridgeLog.recording()?"停止測試紀錄":"開始測試紀錄（含 GPS 軌跡）",new View.OnClickListener(){public void onClick(View v){WideBridgeLog.toggle();dialog.dismiss();}}));
        panel.addView(action(a,"停止並匯出測試紀錄 ZIP",new View.OnClickListener(){public void onClick(View v){WideBridgeLog.share(a);}}));
        panel.addView(text(a,WideBridge.report(),12));
        panel.addView(text(a,"「已排入傳送」不是 C4 接收確認。台灣測速送出時，每 2 秒最多查詢一次接收端；查詢失敗不阻塞導航。只有由接收端 /health 回報相同目標、session、sequence、測速值，才顯示「C4 已接收」；接收不代表已執行減速。沒有相容的 Navi v2 通道時不會另開 UDP 強送。",13));

        panel.addView(text(a,"台灣模式缺少可靠資料時顯示 — 並撤銷該欄位，不以測速點猜整條道路速限，也不暗中切換來源。可手動切回高德。App 重啟回到高德；本包離線資料使用期限至 2027-02-15，之後需更新。",14));
        panel.addView(text(a,"區間僅顯示、不串接：本版只含新北 24 個方向區間。須連續記錄 GPS 通過入口才開始計時；中途開啟、GPS 中斷超過 5 秒、誤差超過 30 m、跳點或入口重疊時，不顯示有效倒數。未確認同一道路，不能保證符合執法設備的實際計時。",13));
        panel.addView(text(a,"原始點位診斷（不在主要面板顯示）",20));
        panel.addView(text(a,WideCamera.report(),11));
        panel.addView(action(a,"複製測速診斷（含目前座標）",new View.OnClickListener(){public void onClick(View v){
            ClipboardManager clipboard=(ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE);
            clipboard.setPrimaryClip(ClipData.newPlainText("測速診斷",WideCamera.report()));
            Toast.makeText(a,"已複製測速與 GPS 診斷",Toast.LENGTH_SHORT).show();
        }}));
        panel.addView(text(a,"資料來源：警政署 2026 測速執法設置點。本 App 整理之固定點快照，依政府資料開放授權條款第 1 版使用。\nhttps://data.gov.tw/dataset/7320\nhttps://data.gov.tw/license\n新增：新北市政府警察局 2026 區間平均速率執法設備設置地點（政府資料開放授權條款第 1 版）。\nhttps://data.ntpc.gov.tw/datasets/27b97ad9-9dba-4ca9-b0ed-14b29000ffec\n下載日期不是各點更新日期。固定點官方不定期更新，新北區間目錄標示每年更新。",12));
        panel.addView(text(a,"道路圖資：© OpenStreetMap contributors，Geofabrik Taiwan 2026-11-08。ODbL 1.0。\nhttps://www.openstreetmap.org/copyright\nHCOP 程式與修正資料來源：https://github.com/henryopen/openpilot（MIT；圖資另依原授權）\n全台離線道路與路口間片段，不猜測跨路口路線。HCOP TDX 快照 2026-10-18；不將原版 800 m 圓形修正直接套給整條道路。資料快照不保證現場標誌未變更。",12));
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
        WideGeometry.Plan p=WideLayout.plan();
        w.setLayout(p.compact?width:Math.min(width,Math.max(dp(a,280),dp(a,p.sideWidth))),height);
        w.setGravity(p.compact?Gravity.CENTER:Gravity.RIGHT|Gravity.TOP);
        final View.OnLayoutChangeListener resize=new View.OnLayoutChangeListener(){public void onLayoutChange(View v,int l,int t,int r,int b,int ol,int ot,int or,int ob){if(r-l!=or-ol||b-t!=ob-ot)dialog.dismiss();}};
        root.addOnLayoutChangeListener(resize);
        dialog.setOnDismissListener(new android.content.DialogInterface.OnDismissListener(){public void onDismiss(android.content.DialogInterface d){root.removeOnLayoutChangeListener(resize);}});
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
