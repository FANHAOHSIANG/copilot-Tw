package android.app;

import android.os.Bundle;

/** Compile-only signatures missing from the older android.jar used by the APK overlay. */
public class ActivityOptions {
    public static ActivityOptions makeBasic() { throw new AssertionError(); }
    public ActivityOptions setLaunchDisplayId(int displayId) { throw new AssertionError(); }
    public Bundle toBundle() { throw new AssertionError(); }
}
