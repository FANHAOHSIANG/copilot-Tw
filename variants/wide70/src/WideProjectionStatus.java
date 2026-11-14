package com.navipilot.obf;

import android.graphics.Color;
import android.view.Gravity;
import android.view.View;

final class WideProjectionStatus {
    private static final int BACKGROUND = 0xff0b1018;

    static void show(WideDirect.Pane pane, String headline, String detail, String action) {
        boolean connected = detail.isEmpty() && action.isEmpty();
        String zone = pane.shield ? "分區一" : "分區二";
        pane.waitingForFrame = connected;
        pane.stateTitle.setText(connected ? zone : zone + " · " + headline);
        pane.stateDetail.setText(detail);
        pane.stateDetail.setVisibility(detail.isEmpty() ? View.GONE : View.VISIBLE);
        pane.stateAction.setText(action);
        pane.stateAction.setVisibility(action.isEmpty() ? View.GONE : View.VISIBLE);
        // Let the first texture update through while the placeholder is visible.
        pane.state.setGravity(Gravity.TOP);
        pane.state.setBackgroundColor(connected ? Color.TRANSPARENT : BACKGROUND);
        pane.state.setVisibility(connected && pane.frameShown ? View.GONE : View.VISIBLE);
    }

    static void onFrame(WideDirect.Pane pane) {
        if (pane.frameShown || (!pane.starting && pane.session == null)) return;
        pane.frameShown = true;
        if (pane.waitingForFrame) pane.state.setVisibility(View.GONE);
    }

    static void reset(WideDirect.Pane pane) {
        pane.frameShown = false;
        if (pane.waitingForFrame) pane.state.setVisibility(View.VISIBLE);
    }

    private WideProjectionStatus() {}
}
