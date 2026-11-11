package com.navipilot.obf;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.ScrollView;
/** Keeps the existing close button and click handler outside scrollable settings. */
public final class WideFixedFooter {
 private static int dp(Context c,int value){return Math.round(c.getResources().getDisplayMetrics().density*value);}
 public static void install(Dialog dialog,ScrollView scroll){
  View child=scroll.getChildAt(0);
  if(!(child instanceof ViewGroup)){dialog.setContentView(scroll);return;}
  ViewGroup panel=(ViewGroup)child;
  View last=panel.getChildAt(panel.getChildCount()-1);
  if(!(last instanceof Button)||!"關閉".contentEquals(((Button)last).getText())){dialog.setContentView(scroll);return;}
  Context c=scroll.getContext();Button close=(Button)last;
  panel.removeView(close);
  LinearLayout layout=new LinearLayout(c);layout.setOrientation(LinearLayout.VERTICAL);
  Drawable background=panel.getBackground();
  if(background!=null&&background.getConstantState()!=null)layout.setBackground(background.getConstantState().newDrawable());
  else layout.setBackgroundColor(0xff172230);
  // Weight reserves the footer's height. The last content item remains scrollable above it.
  layout.addView(scroll,new LinearLayout.LayoutParams(-1,0,1f));
  FrameLayout footer=new FrameLayout(c);footer.setPadding(dp(c,12),dp(c,8),dp(c,12),dp(c,8));
  close.setMinWidth(dp(c,160));
  footer.addView(close,new FrameLayout.LayoutParams(-2,dp(c,48),Gravity.CENTER));
  layout.addView(footer,new LinearLayout.LayoutParams(-1,dp(c,64)));
  dialog.setContentView(layout);
 }
}
