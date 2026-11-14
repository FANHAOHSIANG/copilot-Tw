package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.PopupMenu;

/** On-screen controls share the right pane without reserving projection height. */
final class WideProjectionControls extends LinearLayout {
    private final Button left;
    private final Button right;
    private final Button collapse;
    private final Button more;

    static void install(WideDirect.Pane pane) {
        if (pane.shield) {
            WideProjectionControls controls = new WideProjectionControls(pane);
            FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(
                    LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, Gravity.BOTTOM | Gravity.END);
            params.setMarginEnd(controls.dp(6));
            params.bottomMargin = controls.dp(5);
            pane.body.addView(controls, params);
            controls.update(WideSettings.controlsVisible());
            pane.body.addOnLayoutChangeListener((view, l, t, r, b, oldL, oldT, oldR, oldB) -> {
                if (r - l != oldR - oldL) controls.renderButtons();
            });
        }
    }

    static void update(FrameLayout body, boolean expanded) {
        for (int i = body.getChildCount() - 1; i >= 0; i--) {
            View child = body.getChildAt(i);
            if (child instanceof WideProjectionControls) {
                ((WideProjectionControls) child).update(expanded);
                return;
            }
        }
    }

    private WideProjectionControls(WideDirect.Pane pane) {
        super(pane.getContext());
        setOrientation(HORIZONTAL);
        left = button("左側 ⋯", "左側地圖更多選項", 62, v -> showPaneMenu(v, false));
        right = button("右側 ⋯", "右側投屏更多選項", 62, v -> showPaneMenu(v, true));
        collapse = button("⌄", "收起右下面板", 44, v -> togglePanel());
        more = button("⋯", "投屏與面板選項", 44, this::showCollapsedMenu);
    }

    private boolean expanded;

    private void update(boolean expanded) {
        this.expanded = expanded;
        renderButtons();
    }

    private void renderButtons() {
        int paneWidth = ((View) getParent()).getWidth();
        boolean separate = expanded && (paneWidth == 0 || paneWidth >= dp(182));
        int visibility = separate ? VISIBLE : GONE;
        left.setVisibility(visibility);
        right.setVisibility(visibility);
        collapse.setVisibility(visibility);
        more.setVisibility(separate ? GONE : VISIBLE);
    }

    private Button button(String text, String description, int width, OnClickListener click) {
        Context context = getContext();
        Button result = new Button(context);
        result.setText(text);
        result.setContentDescription(description);
        result.setTextColor(Color.WHITE);
        result.setTextSize(12);
        result.setAllCaps(false);
        result.setPadding(0, 0, 0, 0);
        result.setMinimumWidth(0);
        result.setMinWidth(0);
        GradientDrawable background = new GradientDrawable();
        background.setColor(0xdd101b28);
        background.setCornerRadius(dp(12));
        background.setStroke(dp(1), 0xff8598ad);
        result.setBackground(background);
        result.setOnClickListener(click);
        LayoutParams params = new LayoutParams(dp(width), dp(48));
        params.setMarginStart(dp(2));
        addView(result, params);
        return result;
    }

    private int dp(int dp) {
        return Math.round(dp * getResources().getDisplayMetrics().density);
    }

    private void togglePanel() {
        Activity host = WideVariant.activity(getContext());
        if (host != null) WideSettings.toggleControls(host);
    }

    private void showPaneMenu(View anchor, boolean shield) {
        WideDirect.Pane pane = WideDirect.paneFor(anchor, shield);
        if (pane != null) pane.menu(anchor);
    }

    private void showCollapsedMenu(View anchor) {
        PopupMenu popup = new PopupMenu(getContext(), anchor, Gravity.END);
        popup.getMenu().add(0, 1, 0, expanded ? "收起面板" : "展開面板");
        popup.getMenu().add(0, 2, 1, "重啟左側地圖");
        popup.getMenu().add(0, 3, 2, "重啟右側 App");
        popup.getMenu().add(0, 4, 3, "左側地圖選項");
        popup.getMenu().add(0, 5, 4, "右側投屏選項");
        popup.setOnMenuItemClickListener(item -> {
            int id = item.getItemId();
            if (id == 1) togglePanel();
            else if (id == 2 || id == 3) {
                WideDirect.Pane pane = WideDirect.paneFor(anchor, id == 3);
                if (pane != null) pane.restart();
            } else {
                // Let the first popup finish dismissing before opening the next one.
                anchor.post(() -> showPaneMenu(anchor, id == 5));
            }
            return true;
        });
        popup.show();
    }
}
