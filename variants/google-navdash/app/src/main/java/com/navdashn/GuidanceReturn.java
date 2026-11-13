package com.navdashn;

import android.app.Activity;
import android.app.ActivityOptions;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.widget.Toast;
import com.navdashn.navigation.NavController;
import com.navdashn.navigation.NavState;
import java.lang.ref.WeakReference;

/** Returns to the search screen in the task and display hosting guidance. */
public final class GuidanceReturn {
    private static final Handler MAIN = new Handler(Looper.getMainLooper());
    private static WeakReference<Activity> foreground = new WeakReference<>(null);

    private GuidanceReturn() {}

    public static void resume(Activity activity) {
        if (activity.isFinishing()) return;
        foreground = new WeakReference<>(activity);
        if (ended(NavController.INSTANCE.getState())) {
            openSearch(activity);
        }
    }

    public static void pause(Activity activity) {
        if (foreground.get() == activity) foreground.clear();
    }

    public static void onNavigationStateChanged(NavState state) {
        if (!ended(state)) return;
        // Run after the SDK stop call and ignore callbacks for a superseded route.
        MAIN.post(new Runnable() {
            @Override public void run() {
                Activity activity = foreground.get();
                if (activity != null && ended(NavController.INSTANCE.getState())) {
                    openSearch(activity);
                }
            }
        });
    }

    public static void openSearch(Activity activity) {
        if (activity.isFinishing()) return;
        Intent intent = new Intent(activity, MainActivity.class)
                .addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        try {
            int displayId = activity.getWindowManager().getDefaultDisplay().getDisplayId();
            ActivityOptions options = ActivityOptions.makeBasic().setLaunchDisplayId(displayId);
            activity.startActivity(intent, options.toBundle());
        } catch (RuntimeException displayError) {
            // An Activity-originated launch normally inherits the caller's display.
            try {
                activity.startActivity(intent);
            } catch (RuntimeException launchError) {
                Log.w("GuidanceReturn", "Could not reopen Google navigation search", launchError);
                Toast.makeText(activity, "無法返回搜尋頁，請再試一次", Toast.LENGTH_SHORT).show();
                return;
            }
        }
        pause(activity);
        activity.finish();
    }

    static boolean ended(NavState state) {
        return state == NavState.IDLE || state == NavState.ARRIVED || state == NavState.ERROR;
    }
}
