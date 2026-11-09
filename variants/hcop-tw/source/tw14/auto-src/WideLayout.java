package com.navipilot.obf;

/** Geometry and presentation only. No vehicle command, navigation or entitlement changes. */
public final class WideLayout {
    public static boolean active;
    public static float pageWidth, pageHeight;
    private static final float GAP = 6f;

    public static void configure(float width, float height) {
        active = width >= 600f && width > height;
        pageWidth = width;
        pageHeight = height;
    }

    public static VE mapPane(VE base, float width, float height) {
        return androidx.compose.foundation.layout.c.k(base,
            WideGeometry.left(width, WideSettings.left()), Math.max(0, height));
    }

    public static VE drivingPane(float width, float height) {
        float cardHeight = WideGeometry.upper(width, height, WideSettings.left(), WideSettings.top());
        return androidx.compose.foundation.layout.c.e(
            androidx.compose.foundation.layout.c.c(SE.a, 1f), cardHeight);
    }

    public static WO viewport(WO map, gO page) {
        if (!active) return map;
        cI origin = (cI) page.D.getValue();
        float left = cI.d(origin.a) + page.d.M(GAP);
        float top = cI.e(origin.a) + page.d.M(GAP);
        return new WO(left, top, left + page.d.M(Math.max(0, pageWidth - 12f)),
            top + page.d.M(Math.max(0, pageHeight - 12f)));
    }

    public static VE settingsPane(VE original, gO page) {
        if (!active) return original;
        return rightDetails(original);
    }

    public static VE rightDetails(VE original) {
        if (!active) return original;
        float width = WideGeometry.right(pageWidth - 12f, WideSettings.left());
        float height = Math.max(0, pageHeight - 12f);
        VE offset = androidx.compose.foundation.layout.a.i(SE.a,
            WideGeometry.left(pageWidth - 12f, WideSettings.left()) + GAP, 0f);
        return androidx.compose.foundation.layout.c.k(offset, width, height);
    }

    public static void browser(gO page, boolean available, tr openProjection, VE modifier,
                               vr probe, Integer port, String externalUrl, boolean interactive,
                               Hh composer, int flags) {
        if (!active) {
            OA.b(available, openProjection, modifier, probe, port, externalUrl, interactive, composer, flags);
            return;
        }
        VE mapModifier = androidx.compose.foundation.layout.c.k(SE.a,
            WideGeometry.left(pageWidth - 12f, WideSettings.left()), Math.max(0, pageHeight - 12f));
        WideDirect.map(mapModifier, openProjection, composer);
        composer.U(0x4f731001);
        if (externalUrl != null) {
            iO.b(settingsPane(modifier, page), "車機控制台", page.J,
                Ek.Q(0x4f731002, new ExternalContent(externalUrl, port, page.J), composer), composer, 3072);
        }
        composer.p(false);
    }

    private static final class ExternalContent implements yr {
        final String url;
        final Integer port;
        final tr close;
        ExternalContent(String url, Integer port, tr close) {
            this.url = url; this.port = port; this.close = close;
        }
        @Override public Object h(Object modifier, Object composer, Object changed) {
            OA.b(true, close, (VE) modifier, null, port, url, true, (Hh) composer, 0);
            return J10.a;
        }
    }
}
