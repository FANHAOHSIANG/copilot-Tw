package com.navipilot.obf;

/** Original source-gate call boundary only; the decoded smali hook is verified by the APK build. */
public final class WideAmapSource {
    public static String selected;
    public static void select(String name) {
        selected = name;
        WideAmapLinkIntegration.select(name);
    }
}
