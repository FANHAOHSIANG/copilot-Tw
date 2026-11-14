package com.navipilot.obf;

// D8 type information. The APK supplies the real logger.
public final class WideBridgeLog {
    public static boolean recording() { return false; }
    public static void event(String name, Object value) {}
}
