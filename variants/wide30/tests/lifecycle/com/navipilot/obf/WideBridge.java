package com.navipilot.obf;
public class WideBridge {
 public static boolean active; public static int toggles;
 public static boolean enabled(){ return active; }
 public static void setEnabled(boolean a){ active=a; toggles++; }
}
