package com.navipilot.obf;

import android.os.Binder;
import android.util.Log;

/** Chooses the keyboard display within the already-authorized projection user service. */
public final class WideAmapIme {
    static final String PHONE = "WideAmapPhone";
    static final String PHONE_HOST_IME = "WideAmapPhoneHost";
    private static final int DISPLAY_IME_POLICY_LOCAL = 0;
    private static final int DISPLAY_IME_POLICY_FALLBACK_DISPLAY = 1;

    static boolean isPhoneDisplay(String name) {
        return PHONE.equals(name) || PHONE_HOST_IME.equals(name);
    }

    public static void configure(String displayName, int displayId) {
        if (displayId <= 0 || (!isPhoneDisplay(displayName) && !WideVariant.GOOGLE_DISPLAY.equals(displayName))) return;
        long identity = Binder.clearCallingIdentity();
        try {
            Object manager = Class.forName("android.view.WindowManagerGlobal")
                    .getMethod("getWindowManagerService").invoke(null);
            int policy = PHONE.equals(displayName) ? DISPLAY_IME_POLICY_LOCAL : DISPLAY_IME_POLICY_FALLBACK_DISPLAY;
            Class.forName("android.view.IWindowManager")
                    .getMethod("setDisplayImePolicy", int.class, int.class)
                    .invoke(manager, displayId, policy);
        } catch (ReflectiveOperationException | RuntimeException | LinkageError unavailable) {
            Log.w("WideAmapIme", "Keyboard policy unavailable for display " + displayId, unavailable);
        } finally {
            Binder.restoreCallingIdentity(identity);
        }
    }
}
