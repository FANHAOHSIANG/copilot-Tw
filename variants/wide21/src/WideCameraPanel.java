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
 private final Runnable tick=new Runnable(){public void run(){if(disposed)return;gps.setText(WideCamera.running?"停止":"定位");controls.setText(WideSettings.controlsVisible()?"收合":"快捷");roadLimit.setText(WideHcop.label());dashboard.invalidate();main.postDelayed(this,300);}};
 public WideCameraPanel(Context context) {
  super(context);
  setOrientation(VERTICAL);
  setBackgroundColor(WideUi.BG);
  WideCamera.init(context);
  LinearLayout bar = WideUi.toolbar(context);
  title = WideUi.identity(bar, "台灣道路資料", "固定與區間測速", WideUi.TEAL);
  gps = WideUi.tool(bar, "定位", WideUi.TEAL, view -> {
   Activity activity = activity();
   if (activity == null) return;
   if (WideCamera.running) WideCamera.stop(activity);
   else WideCamera.start(activity);
   invalidateCamera();
  });
  controls = WideUi.tool(bar, "快捷", WideUi.INK, view -> {
   Activity activity = activity();
   if (activity != null) WideSettings.toggleControls(activity);
  });
  WideUi.tool(bar, "更多", WideUi.INK, this::menu);
  addView(bar, new LayoutParams(-1, dp(48)));

  roadLimit = WideUi.text(context, "道路速限 —\n等待 GPS 定位", 14, WideUi.INK, true);
  roadLimit.setMaxLines(2);
  roadLimit.setEllipsize(TextUtils.TruncateAt.END);
  roadLimit.setGravity(Gravity.CENTER_VERTICAL);
  roadLimit.setPadding(dp(10), dp(3), dp(8), dp(3));
  roadLimit.setBackground(WideUi.shape(context, WideUi.SURFACE, WideUi.EDGE, 9));
  LayoutParams info = new LayoutParams(-1, dp(49));
  info.setMargins(dp(8), dp(5), dp(8), dp(4));
  addView(roadLimit, info);

  FrameLayout body = new FrameLayout(context);
  addView(body, new LayoutParams(-1, 0, 1));
  dashboard = new WideCameraCard(context, 0);
  body.addView(dashboard, new FrameLayout.LayoutParams(-1, -1));
  divider = new WideDivider(context, true);
  body.addView(divider, new FrameLayout.LayoutParams(-1, dp(24), Gravity.BOTTOM));
 }

 private void invalidateCamera() { dashboard.invalidate(); }

 private int dp(float value) { return WideUi.dp(getContext(), value); }
 private Activity activity() { return WideVariant.activity(getContext()); }
 public void adapt(boolean portrait,boolean shown){controls.setText(shown?"收合":"快捷");divider.setVisibility(shown?VISIBLE:GONE);divider.updateAxis();dashboard.setFooterInset(shown?24:0);}
 @Override protected void onSizeChanged(int w, int h, int ow, int oh) {
  super.onSizeChanged(w, h, ow, oh);
  title.setText(w < dp(275) ? "台灣測速" : "固定與區間測速");
  controls.setVisibility(w < dp(222) ? GONE : VISIBLE);
 }
 private void menu(View v){PopupMenu m=new PopupMenu(getContext(),v);
  m.getMenu().add(0,1,0,"版面與比例設定");m.getMenu().add(0,2,1,"台灣測速設定與診斷");m.getMenu().add(0,3,2,"示範固定測速");m.getMenu().add(0,4,3,"示範區間測速");
  if (controls.getVisibility() == GONE)
   m.getMenu().add(0, 5, 4, WideSettings.controlsVisible() ? "收合快捷鍵" : "顯示快捷鍵");
  m.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener(){public boolean onMenuItemClick(MenuItem i){Activity a=activity();if(a==null)return true;
   if(i.getItemId()==1)WideSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));
   else if(i.getItemId()==2)WideTaiwanSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));
   else if(i.getItemId()==5)WideSettings.toggleControls(a);
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
