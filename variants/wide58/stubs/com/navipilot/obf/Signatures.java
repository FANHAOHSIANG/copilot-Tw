package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;

// Compile-only signatures. These classes are already present in Carrot Bridge.
final class WideUi { static native int dp(Context c, float value); }
final class WideVariant { static native Activity activity(Context context); }
final class WideBridgeLog {
    static native boolean recording();
    static native void toggle();
    static native void share(Activity activity);
    static native String status();
    static native void event(String name, Object value);
}
final class WideDiagnostics { static native String report(); }
final class WideGoogleNav { static native String status(); }
final class WideAmapLinkIntegration { static native String extendReport(String report); }
