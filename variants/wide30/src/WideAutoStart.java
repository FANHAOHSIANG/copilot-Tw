package com.navipilot.obf;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import java.lang.ref.WeakReference;
import java.util.WeakHashMap;

/** Starts the existing GPS service and Taiwan speed source only from a visible activity. */
public final class WideAutoStart {
    private static final String PREFS = "copilot_tw_autostart";
    private static final String KEY = "taiwan_gps_and_source";
    private static final WeakHashMap<Activity, Boolean> attached = new WeakHashMap<>();
    private static WeakReference<Activity> current = new WeakReference<>(null);
    private static boolean registered;
    private static final LaunchGate gate = new LaunchGate();

    static final class LaunchGate {
        boolean requested, completed;
        boolean shouldRequest(boolean enabled, boolean hasPermission) {
            return enabled && !completed && !hasPermission && !requested;
        }
        boolean shouldStart(boolean enabled, boolean hasPermission) {
            return enabled && !completed && hasPermission;
        }
        void reset() { requested = false; completed = false; }
    }

    public static boolean enabled(Activity activity) {
        return activity.getSharedPreferences(PREFS, 0).getBoolean(KEY, true);
    }

    public static void setEnabled(Activity activity, boolean enabled) {
        activity.getSharedPreferences(PREFS, 0).edit().putBoolean(KEY, enabled).apply();
    }

    /** An explicit source change must not be undone by a later permission callback. */
    public static void manualSourceChange() { gate.completed = true; }

    public static void attach(final Activity activity) {
        current = new WeakReference<>(activity);
        if (!registered) {
            registered = true;
            activity.getApplication().registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
                public void onActivityCreated(Activity a, Bundle state) {}
                public void onActivityStarted(Activity a) {}
                public void onActivityResumed(Activity a) { if (current.get() == a) schedule(a); }
                public void onActivityPaused(Activity a) {}
                public void onActivityStopped(Activity a) {}
                public void onActivitySaveInstanceState(Activity a, Bundle state) {}
                public void onActivityDestroyed(Activity a) {
                    attached.remove(a);
                    if (current.get() == a && a.isFinishing()) {
                        gate.reset();
                        current = new WeakReference<>(null);
                    }
                }
            });
        }
        if (!attached.containsKey(activity)) {
            attached.put(activity, Boolean.TRUE);
            final View decor = activity.getWindow().getDecorView();
            decor.getViewTreeObserver().addOnWindowFocusChangeListener(new ViewTreeObserver.OnWindowFocusChangeListener() {
                public void onWindowFocusChanged(boolean hasFocus) { if (hasFocus) schedule(activity); }
            });
        }
        schedule(activity);
    }

    private static void schedule(final Activity activity) {
        activity.getWindow().getDecorView().post(new Runnable() {
            public void run() { attempt(activity); }
        });
    }

    private static void attempt(Activity activity) {
        if (current.get() != activity || activity.isFinishing() || activity.isDestroyed()
                || !activity.getWindow().getDecorView().hasWindowFocus()) return;
        boolean auto = enabled(activity);
        boolean permission = WideCamera.hasPermission(activity);
        if (gate.shouldRequest(auto, permission)) {
            gate.requested = true;
            WideCamera.start(activity); // Requests permission; no data is sent at this point.
        } else if (gate.shouldStart(auto, permission)) {
            boolean accepted = WideCamera.running || WideCamera.start(activity);
            if (!accepted) return;
            gate.completed = true;
            if (!WideBridge.enabled()) WideBridge.setEnabled(true);
        }
    }
}
