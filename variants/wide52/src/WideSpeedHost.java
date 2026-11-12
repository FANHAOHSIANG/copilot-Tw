package com.navipilot.obf;
import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;
/** The speed pane now contains only the existing Shield projection. */
public final class WideSpeedHost extends LinearLayout {
 private View panel;
 public WideSpeedHost(Context c) {super(c);setOrientation(VERTICAL);panel=WideDirect.newShieldPane(c);addView(panel,new LayoutParams(-1,-1));}
 static void refreshAll() {}
 public void adapt(boolean portrait,boolean controls) {if(panel!=null)WideDirect.adaptShieldPane(panel,portrait,controls);}
 public void dispose() {if(panel!=null){WideDirect.disposeShieldPane(panel);removeAllViews();panel=null;}}
}
