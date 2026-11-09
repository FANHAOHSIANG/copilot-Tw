package com.navipilot.obf;

import android.app.Activity;
import android.graphics.Insets;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowManager;

/** A projected editor may put its keyboard on the host display. Keep that host viewport fixed. */
public final class WideInsets {
    private static final int BARS = WindowInsets.Type.systemBars() | WindowInsets.Type.displayCutout();
    private static final int IME = WindowInsets.Type.ime();
    private static final int ADJUST_MASK = WindowManager.LayoutParams.SOFT_INPUT_MASK_ADJUST;
    private static final int ADJUST_NOTHING = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING;

    static void projection(Activity activity, boolean active) {
        Window window = activity.getWindow();
        int mode = window.getAttributes().softInputMode;
        int adjust = active ? ADJUST_NOTHING : WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE;
        if ((mode & ADJUST_MASK) == adjust) return;
        window.setSoftInputMode((mode & ~ADJUST_MASK) | adjust);
        window.getDecorView().requestApplyInsets();
    }

    public static void install(Activity activity, ViewGroup root) {
        if (root == null) return;
        int[] initial = {root.getPaddingLeft(), root.getPaddingTop(), root.getPaddingRight(), root.getPaddingBottom()};
        root.setOnApplyWindowInsetsListener((view, insets) -> {
            apply(activity, root, insets, initial);
            return new WindowInsets.Builder(insets).setInsets(BARS | IME, Insets.NONE)
                    .setInsetsIgnoringVisibility(BARS, Insets.NONE).build();
        });
        root.addOnLayoutChangeListener((view, l, t, r, b, ol, ot, or, ob) -> {
            WindowInsets insets = root.getRootWindowInsets();
            if (insets != null) apply(activity, root, insets, initial);
        });
        root.requestApplyInsets();
    }

    private static void apply(Activity activity, ViewGroup root, WindowInsets insets, int[] initial) {
        boolean fixed = (activity.getWindow().getAttributes().softInputMode & ADJUST_MASK) == ADJUST_NOTHING;
        Insets inset = insets.getInsets(fixed ? BARS : BARS | IME);
        int[] loc = new int[2];
        root.getLocationInWindow(loc);
        Rect bounds = activity.getWindowManager().getCurrentWindowMetrics().getBounds();
        int l = initial[0] + Math.max(0, inset.left - loc[0]);
        int t = initial[1] + Math.max(0, inset.top - loc[1]);
        int r = initial[2] + Math.max(0, inset.right - Math.max(0, bounds.width() - loc[0] - root.getWidth()));
        int b = initial[3] + Math.max(0, inset.bottom - Math.max(0, bounds.height() - loc[1] - root.getHeight()));
        if (root.getPaddingLeft() != l || root.getPaddingTop() != t
                || root.getPaddingRight() != r || root.getPaddingBottom() != b) root.setPadding(l, t, r, b);
    }
}
