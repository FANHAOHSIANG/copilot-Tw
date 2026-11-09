package com.navipilot.obf;
public final class WideVariant {
 public static final boolean PHONE=true;
 public static final String NAME="高德一般版",PACKAGE="com.autonavi.minimap",DISPLAY="WideAmapPhone";
 public static void init(android.app.Activity a){WideNavProbe.init(a);}
 public static void diagnostics(android.app.Activity a){WideNavProbe.show(a);}
}