package com.navipilot.obf;
import android.app.Activity;
public class WideCamera {
 public static boolean running, permission, accepted=true; public static int requests, starts;
 public static boolean hasPermission(Activity a){ return permission; }
 public static boolean start(Activity a){ if(!permission){ requests++; return false; } starts++; running=accepted; return accepted; }
}
