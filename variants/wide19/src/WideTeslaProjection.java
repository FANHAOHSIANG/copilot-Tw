package com.navipilot.obf;

import com.navipilot.amap2tesla.projection.ProjectionService;
import java.lang.ref.WeakReference;

/** Uses the service's existing image encoder and browser server for a dedicated Shield display. */
public final class WideTeslaProjection {
    private static final String SHIELD = "tw.com.ainvest.outpack";
    private static volatile WeakReference<ProjectionService> owner = new WeakReference<>(null);
    private static volatile boolean active;

    public static boolean isActive() { return active && owner.get() != null; }

    public static synchronized void start(ProjectionService service, Mt binder, int width, int height, int dpi) {
        if (!WideVariant.teslaShield() || service.n) return;
        if (service.getPackageManager().getLaunchIntentForPackage(SHIELD) == null) {
            throw new IllegalStateException("請先安裝神盾測速照相");
        }
        float scale = Math.min(1f, 1280f / Math.max(width, height));
        int w = Math.max(160, Math.round(width * scale));
        int h = Math.max(160, Math.round(height * scale));
        int density = Math.max(120, Math.round(dpi * scale));
        OE encoder = new OE(w, h, service.d);
        int display = -1;
        boolean started = false;
        try {
            display = binder.f("CopilotTeslaShield", w, h, density, 15f, encoder.i.getSurface());
            if (display < 0 || !binder.e(SHIELD, display) || service.n) {
                throw new IllegalStateException("神盾未能在 Tesla 投屏啟動");
            }
            Integer previousDisplay = service.i;
            OE previousEncoder = service.f;
            service.i = display;
            service.f = encoder;
            tv.p = width;
            tv.q = height;
            tv.r = dpi;
            owner = new WeakReference<>(service);
            active = true;
            started = true;
            if (previousDisplay != null && previousDisplay != display) release(binder, previousDisplay);
            if (previousEncoder != null) previousEncoder.close();
        } catch (Exception failure) {
            throw new IllegalStateException("Amap2Tesla 神盾投屏啟動失敗", failure);
        } finally {
            if (!started) {
                if (display >= 0) release(binder, display);
                encoder.close();
            }
        }
    }

    private static void release(Mt binder, int display) {
        try { binder.a(display); } catch (Exception ignored) {}
    }

    public static synchronized void stopped(ProjectionService service) {
        if (owner.get() == service) {
            active = false;
            owner = new WeakReference<>(null);
        }
    }
}
