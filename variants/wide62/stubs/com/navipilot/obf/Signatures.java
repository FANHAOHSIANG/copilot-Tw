package com.navipilot.obf;

// Compile-time signatures only. The patched app supplies these implementations.
final class WideVariant {
    static native Navigation navigation();
    enum Navigation { CAR, PHONE, GOOGLE, SDK }
}

final class WideOsmLimit {
    static native int currentValue();
}

final class WideCamera {
    static volatile boolean running;
    static native void error(String message);
}

final class WideLayout {
    static native WideGeometry.Plan plan();
}
final class WideGeometry {
    static native Plan plan(float width, float height, int left, int top, boolean controls);
    static final class Plan {
        float width, height, sideWidth, shieldHeight;
        boolean controls;
    }
}

final class WideBridgeLog {
    static native void event(String name, Object payload);
}
