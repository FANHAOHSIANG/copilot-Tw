package com.navipilot.obf;

import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;

/** Keeps the live panel bounded by the same slot as the projection selector. */
public final class WideTaiwanHost extends FrameLayout {
    private final WideCameraPanel panel;

    public WideTaiwanHost(Context context) {
        super(context);
        panel = new WideCameraPanel(context);
        addView(panel, new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
    }

    public void adapt(boolean portrait, boolean controls) {
        panel.adapt(portrait, controls);
    }

    void fitLayout(boolean compact, boolean dividerFits) {
        panel.fitLayout(compact, dividerFits);
    }

    void openMenu(View anchor) {
        panel.openMenu(anchor);
    }

    public void dispose() {
        panel.dispose();
    }
}
