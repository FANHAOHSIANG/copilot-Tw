package com.navipilot.obf;

import android.os.Binder;
import android.util.Log;

/** Applies the keyboard policy inside the already-authorized projection user service. */
public final class WideAmapIme {
    static final String DISPLAY_NAME = "WideAmapPhone";
    private static final int DISPLAY_IME_POLICY_LOCAL = 0;

    public static void configure(String displayName, int displayId) {
        if (!DISPLAY_NAME.equals(displayName) || displayId <= 0) return;
        long identity = Binder.clearCallingIdentity();
        try {
            Object manager = Class.forName("android.view.WindowManagerGlobal")
                    .getMethod("getWindowManagerService").invoke(null);
            Class.forName("android.view.IWindowManager")
                    .getMethod("setDisplayImePolicy", int.class, int.class)
                    .invoke(manager, displayId, DISPLAY_IME_POLICY_LOCAL);
        } catch (ReflectiveOperationException | RuntimeException | LinkageError unavailable) {
            Log.w("WideAmapIme", "Local keyboard unavailable for display " + displayId, unavailable);
        } finally {
            Binder.restoreCallingIdentity(identity);
        }
    }
}
