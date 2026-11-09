package com.navipilot.obf;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.*;
import android.graphics.*;
import android.os.*;
import android.text.TextUtils;
import android.view.*;
import android.widget.*;

/** Large, native camera/section presentation. Draw geometry shared with offline visual checks. */
public final class WideCameraPanel extends LinearLayout {
 private final Handler main=new Handler(Looper.getMainLooper());private final WideCameraCard dashboard;private final Button gps,controls;private final TextView roadLimit,title;private final WideDivider divider;
 private boolean disposed;
 private final Runnable tick=new Runnable(){public void run(){if(disposed)return;gps.setText(WideCamera.running?"停止":"GPS");controls.setText(WideSettings.controlsVisible()?"收合":"快捷");roadLimit.setText(WideHcop.label());dashboard.invalidate();main.postDelayed(this,300);}};
 public WideCameraPanel(Context c){super(c);setOrientation(VERTICAL);setBackgroundColor(0xff172230);WideCamera.init(c);
  LinearLayout bar=new LinearLayout(c);bar.setGravity(Gravity.CENTER_VERTICAL);bar.setPadding(dp(10),0,dp(4),0);
  title=new TextView(c);title.setText("自製台灣測速");title.setTextColor(0xfff4f8ff);title.setTypeface(null,Typeface.BOLD);title.setTextSize(14);title.setSingleLine(true);title.setEllipsize(TextUtils.TruncateAt.END);title.setGravity(Gravity.CENTER_VERTICAL);bar.addView(title,new LayoutParams(0,dp(48),1));
  gps=button(bar,"GPS",new OnClickListener(){public void onClick(View v){Activity a=activity();if(a==null)return;if(WideCamera.running)WideCamera.stop(a);else WideCamera.start(a);dashboard.invalidate();}});
  controls=button(bar,"快捷",new OnClickListener(){public void onClick(View v){Activity a=activity();if(a!=null)WideSettings.toggleControls(a);}});
  button(bar,"更多",new OnClickListener(){public void onClick(View v){menu(v);}});
  addView(bar,new LayoutParams(-1,dp(48)));roadLimit=new TextView(c);roadLimit.setTextColor(0xffe7f4ff);roadLimit.setTextSize(14);roadLimit.setMaxLines(2);roadLimit.setEllipsize(TextUtils.TruncateAt.END);roadLimit.setPadding(dp(10),dp(3),dp(8),dp(3));roadLimit.setText("道路速限 —\n等待定位");addView(roadLimit,new LayoutParams(-1,dp(49)));FrameLayout body=new FrameLayout(c);addView(body,new LayoutParams(-1,0,1));
  dashboard=new WideCameraCard(c,0);body.addView(dashboard,new FrameLayout.LayoutParams(-1,-1));
  divider=new WideDivider(c,true);body.addView(divider,new FrameLayout.LayoutParams(-1,dp(24),Gravity.BOTTOM));
 }
 private int dp(float x){return Math.round(x*getResources().getDisplayMetrics().density);}
 private Activity activity(){return WideVariant.activity(getContext());}
 private Button button(LinearLayout bar,String s,OnClickListener click){Button b=new Button(getContext());b.setText(s);b.setTextColor(0xffedf6ff);b.setTypeface(null,Typeface.BOLD);b.setTextSize(13);b.setMinWidth(0);b.setMinimumWidth(0);b.setMinHeight(0);b.setMinimumHeight(0);b.setPadding(0,0,0,0);b.setBackgroundTintList(android.content.res.ColorStateList.valueOf(0xff29435f));b.setOnClickListener(click);LayoutParams lp=new LayoutParams(dp(48),dp(48));lp.leftMargin=dp(3);bar.addView(b,lp);return b;}
 public void adapt(boolean portrait,boolean shown){controls.setText(shown?"收合":"快捷");divider.setVisibility(shown?VISIBLE:GONE);divider.updateAxis();dashboard.setFooterInset(shown?24:0);}
 @Override protected void onSizeChanged(int w,int h,int ow,int oh){super.onSizeChanged(w,h,ow,oh);title.setText(w<dp(300)?"台灣測速":"自製台灣測速");}
 private void menu(View v){PopupMenu m=new PopupMenu(getContext(),v);
  m.getMenu().add(0,1,0,"版面與比例設定");m.getMenu().add(0,2,1,"台灣測速設定與診斷");m.getMenu().add(0,3,2,"示範固定測速");m.getMenu().add(0,4,3,"示範區間測速");
  m.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener(){public boolean onMenuItemClick(MenuItem i){Activity a=activity();if(a==null)return true;
   if(i.getItemId()==1)WideSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));
   else if(i.getItemId()==2)WideTaiwanSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));
   else showDemo(a,i.getItemId()==3?1:2);
   return true;
  }});m.show();
 }
 private void showDemo(Activity activity,int mode){
  if(activity.isFinishing()||activity.isDestroyed())return;
  WideCameraCard preview=new WideCameraCard(activity,mode);
  FrameLayout container=new FrameLayout(activity);
  int windowHeight=activity.getWindow().getDecorView().getHeight();
  int height=windowHeight>0?Math.min(dp(280),Math.max(dp(96),windowHeight-dp(132))):dp(240);
  container.addView(preview,new FrameLayout.LayoutParams(-1,height));
  new AlertDialog.Builder(activity)
      .setTitle(mode==1?"固定測速示範":"區間測速示範")
      .setView(container)
      .setPositiveButton("關閉",null)
      .show();
 }
 @Override protected void onAttachedToWindow(){super.onAttachedToWindow();main.removeCallbacks(tick);tick.run();}
 @Override protected void onDetachedFromWindow(){main.removeCallbacks(tick);super.onDetachedFromWindow();}
 public void dispose(){disposed=true;main.removeCallbacks(tick);}
}
