package com.navipilot.obf;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public final class Wide18Test {
    private static void check(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }

    public static void main(String[] args) throws Exception {
        check(WideStatusBorder.activeColor(false, false) == 0, "both off");
        check(WideStatusBorder.activeColor(false, true) == 0, "longitudinal only");
        check(WideStatusBorder.activeColor(true, false) == 0xffa1a7ae, "lateral only");
        check(WideStatusBorder.activeColor(true, true) == 0xff52d584, "both active");
        check(WideStatusBorder.activeColor(true, null) == 0, "unknown longitudinal");
        check(WideStatusBorder.activeColor("true", true) == 0, "malformed lateral");

        vg sample = new vg();
        sample.a = new tg();
        sample.a.c = new LinkedHashMap<>();
        sample.a.c.put("latActive", true);
        sample.a.c.put("longActive", true);
        zg decoded = new zg() {
            @Override public vg b(String name) { return "carControl".equals(name) ? sample : null; }
        };
        java.lang.reflect.Method currentColor = WideStatusBorder.class.getDeclaredMethod("currentColor");
        currentColor.setAccessible(true);
        sample.c = System.nanoTime() / 1_000_000L + 5000;
        WideStatusBorder.update(decoded);
        check((int) currentColor.invoke(null) == 0xff52d584, "fresh carControl");
        sample.c = System.nanoTime() / 1_000_000L - 1;
        WideStatusBorder.update(decoded);
        check((int) currentColor.invoke(null) == 0, "stale carControl clears border");
        WideStatusBorder.update(null);
        check((int) currentColor.invoke(null) == 0, "disconnect clears border");

        WideCameraFace.Model start = WideCameraFace.demo(1, 0);
        WideCameraFace.Model approaching = WideCameraFace.demo(1, 6000);
        WideCameraFace.Model near = WideCameraFace.demo(1, 12500);
        check(start.demo && start.distance > approaching.distance && approaching.distance > near.distance, "demo counts down");
        check(WideCameraFace.warningStrength(start) == 0, "outside warning range");
        check(WideCameraFace.warningStrength(approaching) > 0 &&
              WideCameraFace.warningStrength(near) > WideCameraFace.warningStrength(approaching), "glow increases");
        approaching.demo = false;
        approaching.roadMatched = false;
        check(WideCameraFace.warningStrength(approaching) == 0, "unmatched live road");
        approaching.roadMatched = true;
        check(WideCameraFace.warningStrength(approaching) > 0, "matched live road");
        approaching.distance = Double.NaN;
        check(WideCameraFace.warningStrength(approaching) == 0, "non-finite distance");
        List<String> labels = new ArrayList<>();
        WideCameraFace.draw(new WideCameraFace.Painter() {
            public void rect(float x, float y, float w, float h, float radius, int color) {}
            public void circle(float x, float y, float r, float stroke, int color) {}
            public void line(float x, float y, float xx, float yy, float stroke, int color) {}
            public void text(String value, float x, float y, float size, int color, float width, boolean center) {
                labels.add(value);
            }
        }, 155, 95, near, 12500);
        check(labels.contains("示範") && labels.stream().anyMatch(label -> label.endsWith(" m")), "compact demo shows distance");
        System.out.println("PASS: C4 combinations, absent/expired data, approaching glow, and compact demo card");
    }
}
