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
        WideNavProbe.init(activity);
        SharedPreferences prefs = activity.getSharedPreferences(PREF, 0);
        int l = Math.max(25, Math.min(75, prefs.getInt("left_percent", 50)));
        int t = prefs.getInt("top_percent", 0);
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
        panel.addView(text(a,"一般版高德・原通道串接",20));
        panel.addView(text(a,"沿用車機版的原解析與 Navi v2 傳送；通知文字目前只取樣。",12));
        panel.addView(action(a,"一般版高德串接診斷",new View.OnClickListener(){public void onClick(View v){WideNavProbe.show(a);}}));
        panel.addView(text(a,"左側 高德地圖一般版，右上神盾，右下快捷鍵。兩個 App 都直接顯示在各自的虛擬螢幕；需安裝並授權 Shizuku。",12));
        panel.addView(action(a,"開啟神盾（設定後返回）",new View.OnClickListener(){public void onClick(View v){WideApps.openShield(a);}}));
        panel.addView(action(a,"神盾權限與電池設定",new View.OnClickListener(){public void onClick(View v){WideApps.shieldSettings(a);}}));
        panel.addView(text(a,"請先從車機桌面開啟神盾完成定位授權，再在右上神盾畫面開啟偵測。本 App 不會代按開始，也無法判斷偵測狀態。",12));
        panel.addView(text(a,"在串接診斷按開始取樣，會同時讀取既有高德通知。神盾維持投屏，沒有新增資料擷取。",12));
        panel.addView(text(a,"畫面比例",20));
        panel.addView(text(a,"可直接拖動地圖右側或神盾下方的分隔把手；也可在此設定，按「套用並儲存」。",12));
        final TextView leftLabel=text(a,"",15);panel.addView(leftLabel);
        final SeekBar left=new SeekBar(a);left.setMax(50);left.setProgress(left()-25);panel.addView(left);
        final TextView topLabel=text(a,"",15);panel.addView(topLabel);
        final SeekBar top=new SeekBar(a);top.setMax(60);top.setProgress((top()==0 ? 55 : top())-20);panel.addView(top);
        final Runnable refresh=new Runnable(){public void run(){
            int l=left.getProgress()+25,t=top.getProgress()+20;
            leftLabel.setText("導航 "+l+"% ｜右側 "+(100-l)+"%");
            topLabel.setText("右上神盾 "+t+"% ｜右下按鍵 "+(100-t)+"%");
        }};
        SeekBar.OnSeekBarChangeListener listener=new SeekBar.OnSeekBarChangeListener(){
            public void onProgressChanged(SeekBar s,int p,boolean user){refresh.run();}
            public void onStartTrackingTouch(SeekBar s){} public void onStopTrackingTouch(SeekBar s){}
        };left.setOnSeekBarChangeListener(listener);top.setOnSeekBarChangeListener(listener);refresh.run();
        panel.addView(action(a,"套用並儲存",new View.OnClickListener(){public void onClick(View v){save(a,left.getProgress()+25,top.getProgress()+20);dialog.dismiss();}}));
        panel.addView(action(a,"恢復預設：左右各半／神盾自動比例",new View.OnClickListener(){public void onClick(View v){save(a,50,0);dialog.dismiss();}}));
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
