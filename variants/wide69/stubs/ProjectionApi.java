package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

final class WideDirect {
    static native Pane paneFor(View anchor, boolean shield);

    static final class Pane extends LinearLayout {
        boolean shield;
        FrameLayout body;

        Pane(Context context) { super(context); }

        native void menu(View anchor);
        native void back(View anchor);
        native void restart();
    }
}

final class WidePanels {
    static native void chooseLower(Activity activity);
    static native String sidePackage(Context context);
}

final class WideVariant {
    static native Activity activity(Context context);
}

final class WideSettings {
    static native boolean controlsVisible();
    static native void toggleControls(Activity activity);
}

final class WideShieldSize {
    static volatile boolean protect;
    static final int MIN_WIDTH = 757;
    static final int MIN_HEIGHT = 384;
}

final class WideBridgeLog {
    static native void event(String name, Object payload);
}
