package com.navipilot.obf;
public final class WideGeometry {
    public static float left(float contentWidth, int percent) {
        return Math.max(0f, contentWidth - 6f) * Math.max(25, Math.min(75, percent)) / 100f;
    }
    public static float right(float contentWidth, int percent) {
        return Math.max(0f, contentWidth - 6f) - left(contentWidth, percent);
    }
    public static float upper(float width, float height, int left, int top) {
        if (top == 0) return Math.max(0, Math.min(right(width, left) / 2.1097047f, height * .60f));
        float space = Math.max(0, height - 6f);
        float minimum = Math.min(80f, space / 2f);
        float maximum = Math.max(minimum, space - 108f);
        return Math.max(minimum, Math.min(maximum, space * Math.max(20, Math.min(80, top)) / 100f));
    }
    public static boolean reconnect(boolean active, boolean socket, long now, long accepted, long started, boolean hello) {
        if (!active || !socket) return false;
        long latest = Math.max(accepted, started);
        return latest > 0 && now >= latest && now - latest > (hello ? 8000L : 12000L);
    }
}
