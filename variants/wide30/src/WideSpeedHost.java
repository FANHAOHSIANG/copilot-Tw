package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import java.lang.ref.WeakReference;
import java.util.ArrayList;

/** Persistent selector swaps only the speed pane; navigation display and IME stay alive. */
public final class WideSpeedHost extends LinearLayout {
    private static final ArrayList<WeakReference<WideSpeedHost>> HOSTS = new ArrayList<>();
    private final FrameLayout body;
    private final LinearLayout selector;
    private final Button taiwan, shield, compactMenu;
    private View panel;
    private boolean showingShield, disposed, portrait, controls;

    public WideSpeedHost(Context context) {
        super(context);
        setOrientation(VERTICAL);
        setBackgroundColor(WideUi.BG);
        selector = new LinearLayout(context);
        selector.setPadding(dp(6), dp(4), dp(6), dp(4));
        taiwan = WideUi.button(context, "台灣測速", WideUi.TEAL, view -> select(false));
        shield = WideUi.button(context, "神盾投屏", WideUi.AMBER, view -> select(true));
        for (Button button : new Button[]{taiwan, shield}) {
            button.setSingleLine();
            button.setAutoSizeTextTypeUniformWithConfiguration(10, 14, 1, android.util.TypedValue.COMPLEX_UNIT_SP);
            LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(0, -1, 1);
            lp.setMargins(dp(2), 0, dp(2), 0);
            selector.addView(button, lp);
        }
        compactMenu = WideUi.button(context, "更多", WideUi.INK, this::openTaiwanMenu);
        compactMenu.setSingleLine();
        compactMenu.setVisibility(GONE);
        LinearLayout.LayoutParams menuParams = new LinearLayout.LayoutParams(dp(44), LayoutParams.MATCH_PARENT);
        menuParams.leftMargin = dp(2);
        selector.addView(compactMenu, menuParams);
        addView(selector, new LinearLayout.LayoutParams(-1, dp(50)));
        body = new FrameLayout(context);
        addView(body, new LinearLayout.LayoutParams(-1, 0, 1));
        HOSTS.add(new WeakReference<>(this));
        refresh();
    }
    private int dp(int value) { return WideUi.dp(getContext(), value); }

    @Override protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        boolean taiwanPanel = panel instanceof WideTaiwanHost;
        boolean bounded = MeasureSpec.getMode(heightMeasureSpec) != MeasureSpec.UNSPECIFIED;
        int height = MeasureSpec.getSize(heightMeasureSpec);
        // In a short slot the selector also hosts the menu, leaving the rest for the instruments.
        boolean compact = taiwanPanel && bounded && height < dp(182);
        int selectorHeight = dp(50);
        if (compact) selectorHeight = Math.min(dp(36), Math.max(dp(22), height / 3));
        selector.getLayoutParams().height = selectorHeight;
        compactMenu.setVisibility(compact ? VISIBLE : GONE);
        if (taiwanPanel) ((WideTaiwanHost) panel).fitLayout(compact, !bounded || height >= dp(96));
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    private void openTaiwanMenu(View anchor) {
        if (panel instanceof WideTaiwanHost) ((WideTaiwanHost) panel).openMenu(anchor);
    }

    private void select(boolean next) {
        Activity activity = WideVariant.activity(getContext());
        if (activity != null) WideVariant.selectPanel(activity, next);
    }
    static void refreshAll() {
        for (int i = HOSTS.size() - 1; i >= 0; i--) {
            WideSpeedHost host = HOSTS.get(i).get();
            if (host == null || host.disposed) HOSTS.remove(i);
            else host.refresh();
        }
    }
    private void clearPanel() {
        if (panel instanceof WideTaiwanHost) ((WideTaiwanHost)panel).dispose();
        else if (panel != null) WideDirect.disposeShieldPane(panel);
        body.removeAllViews();
        panel = null;
    }
    private void refresh() {
        if (disposed) return;
        boolean next = WideVariant.shieldPanel();
        if (panel == null || next != showingShield) {
            clearPanel();
            showingShield = next;
            panel = next ? WideDirect.newShieldPane(getContext()) : new WideTaiwanHost(getContext());
            body.addView(panel, new FrameLayout.LayoutParams(-1, -1));
        }
        taiwan.setText(next ? "台灣測速" : "✓ 台灣測速");
        shield.setText(next ? "✓ 神盾投屏" : "神盾投屏");
        taiwan.setSelected(!next); shield.setSelected(next);
        taiwan.setContentDescription(next ? "切換台灣測速" : "目前顯示台灣測速");
        shield.setContentDescription(next ? "目前顯示神盾測速照相投屏" : "切換神盾測速照相投屏");
        taiwan.setAlpha(next ? 0.7f : 1f); shield.setAlpha(next ? 1f : 0.7f);
        adapt(portrait, controls);
    }
    public void adapt(boolean portrait, boolean controls) {
        this.portrait = portrait; this.controls = controls;
        if (panel instanceof WideTaiwanHost) ((WideTaiwanHost)panel).adapt(portrait, controls);
        else if (panel != null) WideDirect.adaptShieldPane(panel, portrait, controls);
    }
    public void dispose() { disposed = true; clearPanel(); }
}
