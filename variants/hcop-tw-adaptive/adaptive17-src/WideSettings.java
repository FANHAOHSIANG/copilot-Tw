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
    private static final TF[] ratios = {GS.f(Integer.valueOf(5000),bT.k),GS.f(Integer.valueOf(5500),bT.k)};
    private static final TF[] expanded = {GS.f(Integer.valueOf(-1),bT.k),GS.f(Integer.valueOf(-1),bT.k)};
    private static final String PREF = "wide_layout_preferences";
    private static int index() { return WideLayout.portrait()?1:0; }
    private static String prefix(boolean portrait) { return portrait?"portrait_":"landscape_"; }
    public static int left() { return ((Number)ratios[index()].getValue()).intValue()/100; }
    public static int top() { return ((Number)ratios[index()].getValue()).intValue()%100; }
    public static boolean controlsVisible() {
        int value=((Number)expanded[index()].getValue()).intValue();
        return value<0?!WideGeometry.compact(WideLayout.pageWidth-12,WideLayout.pageHeight-12,left()):value==1;
    }
    public static void toggleControls(Activity activity) {
        boolean portrait=WideLayout.portrait();int value=controlsVisible()?0:1;
        expanded[portrait?1:0].setValue(Integer.valueOf(value));
        activity.getSharedPreferences(PREF,0).edit().putInt(prefix(portrait)+"controls",value).apply();
    }
    private static int dp(Context c, float value) { return Math.round(c.getResources().getDisplayMetrics().density*value); }
    public static void install(final Activity activity) {
        WideTelemetry.init(activity);
        WideVariant.init(activity);
        SharedPreferences prefs = activity.getSharedPreferences(PREF, 0);
        for(int i=0;i<2;i++) {
            String p=prefix(i==1);
            int l=prefs.getInt(p+"primary",i==0?prefs.getInt("left_percent",50):55);
            int t=prefs.getInt(p+"secondary",i==0?prefs.getInt("top_percent",0):0);
            previewFor(i==1,l,t);
            expanded[i].setValue(Integer.valueOf(Math.max(-1,Math.min(1,prefs.getInt(p+"controls",-1)))));
        }
        final ViewGroup root = activity.findViewById(android.R.id.content);
        WideInsets.install(activity,root);
    }
    private static TextView text(Activity a, String value, int size) {
        TextView v=new TextView(a);v.setText(value);v.setTextColor(Color.WHITE);v.setTextSize(size);v.setPadding(0,dp(a,6),0,dp(a,6));return v;
    }
    private static Button action(Activity a, String value, View.OnClickListener listener) {
        Button b=new Button(a);b.setText(value);b.setTextSize(14);b.setOnClickListener(listener);return b;
    }
    public static void show(final Activity a, final ViewGroup root) {
        final Dialog dialog=new Dialog(a); dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
        final boolean portrait=WideLayout.portrait();
        LinearLayout panel=new LinearLayout(a);panel.setOrientation(LinearLayout.VERTICAL);panel.setPadding(dp(a,14),dp(a,8),dp(a,14),dp(a,8));panel.setBackgroundColor(0xff172230);
        panel.addView(text(a,WideVariant.NAME+"・自動排版",20));
        if(WideVariant.PHONE) panel.addView(action(a,"一般版高德串接診斷",new View.OnClickListener(){public void onClick(View v){WideVariant.diagnostics(a);}}));
        panel.addView(text(a,"橫向：左導航、右台灣測速與快捷鍵。直向：上導航、下台灣測速。小視窗預設收合快捷鍵，點台灣測速工具列的「快捷」展開。",14));
        panel.addView(action(a,"台灣測速設定與診斷",new View.OnClickListener(){public void onClick(View v){dialog.dismiss();WideTaiwanSettings.show(a,root);}}));
        panel.addView(text(a,"自製台灣面板直接顯示，不需安裝神盾；GPS 與傳送來源可在台灣測速設定調整。",12));
        panel.addView(text(a,portrait?"直向比例（獨立儲存）":"橫向比例（獨立儲存）",20));
        panel.addView(text(a,"按住導航邊界拖拉即可調整。快捷鍵展開時，也可拖動台灣測速下緣；保留最小操作空間，避免把按鍵壓扁。",14));
        final TextView leftLabel=text(a,"",15);panel.addView(leftLabel);
        final SeekBar left=new SeekBar(a);left.setMax(50);left.setProgress(left()-25);panel.addView(left);
        final TextView topLabel=text(a,"",15);panel.addView(topLabel);
        final SeekBar top=new SeekBar(a);top.setMax(60);top.setProgress((top()==0 ? 55 : top())-20);panel.addView(top);
        final Runnable refresh=new Runnable(){public void run(){
            int l=left.getProgress()+25,t=top.getProgress()+20;
            leftLabel.setText((portrait?"上方導航 ":"左側導航 ")+l+"% ｜其餘 "+(100-l)+"%");
            topLabel.setText("台灣測速 "+t+"% ｜快捷鍵 "+(100-t)+"%（展開時）");
        }};
        SeekBar.OnSeekBarChangeListener listener=new SeekBar.OnSeekBarChangeListener(){
            public void onProgressChanged(SeekBar s,int p,boolean user){refresh.run();}
            public void onStartTrackingTouch(SeekBar s){} public void onStopTrackingTouch(SeekBar s){}
        };left.setOnSeekBarChangeListener(listener);top.setOnSeekBarChangeListener(listener);refresh.run();
        panel.addView(action(a,"套用並儲存",new View.OnClickListener(){public void onClick(View v){saveFor(a,portrait,left.getProgress()+25,top.getProgress()+20);dialog.dismiss();}}));
        panel.addView(action(a,"恢復這個方向的預設排版",new View.OnClickListener(){public void onClick(View v){
            saveFor(a,portrait,portrait?55:50,0);
            expanded[portrait?1:0].setValue(Integer.valueOf(-1));
            a.getSharedPreferences(PREF,0).edit().putInt(prefix(portrait)+"controls",-1).apply();dialog.dismiss();
        }}));
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
        WideGeometry.Plan p=WideLayout.plan();
        int width=root.getWidth(),height=root.getHeight();
        w.setLayout(p.compact?width:Math.min(width,Math.max(dp(a,280),dp(a,p.sideWidth))),height);
        w.setGravity(p.compact?Gravity.CENTER:Gravity.RIGHT|Gravity.TOP);
        final View.OnLayoutChangeListener resize=new View.OnLayoutChangeListener(){
            public void onLayoutChange(View v,int l,int t,int r,int b,int ol,int ot,int or,int ob){if(r-l!=or-ol||b-t!=ob-ot)dialog.dismiss();}
        };
        root.addOnLayoutChangeListener(resize);
        dialog.setOnDismissListener(new android.content.DialogInterface.OnDismissListener(){public void onDismiss(android.content.DialogInterface d){root.removeOnLayoutChangeListener(resize);}});
    }
    public static void preview(int left,int top){
        previewFor(WideLayout.portrait(),left,top);
    }
    public static void previewFor(boolean portrait,int left,int top){
        left=WideGeometry.percent(left);
        top=top==0?0:Math.max(20,Math.min(80,top));
        ratios[portrait?1:0].setValue(Integer.valueOf(left*100+top));
    }
    public static void save(Activity a,int left,int top){
        saveFor(a,WideLayout.portrait(),left,top);
    }
    public static void saveFor(Activity a,boolean portrait,int left,int top){
        String p=prefix(portrait);
        a.getSharedPreferences(PREF,0).edit().putInt(p+"primary",left).putInt(p+"secondary",top).apply();
        previewFor(portrait,left,top);
    }
}
