package com.navipilot.obf;

import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

// Compile-time declarations for the installed APK. This file is not packaged.
final class WideDirect {
    static final class Session {}

    static final class Pane {
        boolean shield;
        boolean starting;
        boolean waitingForFrame;
        boolean frameShown;
        Session session;
        LinearLayout state;
        TextView stateTitle;
        TextView stateDetail;
        Button stateAction;
    }
}
