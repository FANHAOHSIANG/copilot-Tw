package com.navipilot.obf;

import android.view.TextureView;
import java.lang.ref.WeakReference;

final class WideShieldSize {
    static final int MIN_WIDTH = 757;
    static final int MIN_HEIGHT = 384;
    static volatile boolean protect;
    private static WeakReference<TextureView> shield = new WeakReference<>(null);

    static void attach(TextureView texture) {
        shield = new WeakReference<>(texture);
    }

    static boolean allow(int left, int top) {
        TextureView texture = shield.get();
        if (!protect || texture == null || !texture.isShown()) return true;
        WideGeometry.Plan current = WideLayout.plan();
        WideGeometry.Plan next = WideGeometry.plan(current.width, current.height,
                left, top, current.controls);
        float density = texture.getResources().getDisplayMetrics().density;
        // Keep the pane chrome out of the measurement by starting with the live texture.
        float width = texture.getWidth() + (next.sideWidth - current.sideWidth) * density;
        float height = texture.getHeight() + (next.shieldHeight - current.shieldHeight) * density;
        return allowed(texture.getWidth(), width, MIN_WIDTH)
                && allowed(texture.getHeight(), height, MIN_HEIGHT);
    }

    private static boolean allowed(float current, float next, int minimum) {
        // Small displays can still grow toward the reference without a dead zone.
        return Math.round(next) >= Math.min(Math.round(current), minimum);
    }

    private WideShieldSize() {}
}
