package com.navipilot.obf;
import android.content.Context;
import android.widget.*;
/** Keeps all native controls reachable in short car windows; no projection authorization needed. */
public final class WideTaiwanHost extends FrameLayout {
 private final WideCameraPanel panel;
 public WideTaiwanHost(Context c){super(c);ScrollView scroll=new ScrollView(c);scroll.setFillViewport(true);panel=new WideCameraPanel(c);scroll.addView(panel,new ScrollView.LayoutParams(-1,dp(290)));addView(scroll,new FrameLayout.LayoutParams(-1,-1));}
 private int dp(int n){return Math.round(n*getResources().getDisplayMetrics().density);}
 protected void onSizeChanged(int w,int h,int ow,int oh){super.onSizeChanged(w,h,ow,oh);android.view.ViewGroup.LayoutParams p=panel.getLayoutParams();int wanted=Math.max(dp(290),h);if(p.height!=wanted){p.height=wanted;panel.setLayoutParams(p);}}
 public void adapt(boolean portrait,boolean controls){panel.adapt(portrait,controls);}
 public void dispose(){panel.dispose();}
}
