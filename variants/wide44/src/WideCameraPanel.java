package com.navipilot.obf;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.PopupMenu;

/** Native live panel. The toolbar and the resize handle use separate rows from the canvas. */
public final class WideCameraPanel extends LinearLayout {
    private final Handler main = new Handler(Looper.getMainLooper());
    private final LinearLayout toolbar;
    private final WideCameraCard dashboard;
    private final Button gps, controls;
    private final WideDivider divider;
    private boolean autoCollapsed;
    private boolean compact, dividerFits = true, quickControls, disposed;

    private final Runnable tick = new Runnable() {
        @Override public void run() {
            if (disposed) return;
            updateButtons();
            dashboard.invalidate();
            main.postDelayed(this, 300);
        }
    };

    public WideCameraPanel(Context context) {
        super(context);
        setOrientation(VERTICAL);
        setBackgroundColor(WideUi.BG);
        WideCamera.init(context);

        toolbar = WideUi.toolbar(context);
        WideUi.identity(toolbar, "即時道路資訊", "台灣測速", WideUi.TEAL);
        gps = WideUi.tool(toolbar, "定位", WideUi.TEAL, view -> toggleGps());
        controls = WideUi.tool(toolbar, "快捷", WideUi.INK, view -> toggleQuickControls());
        WideUi.tool(toolbar, "更多", WideUi.INK, this::openMenu);
        addView(toolbar, new LayoutParams(LayoutParams.MATCH_PARENT, dp(48)));

        dashboard = new WideCameraCard(context, 0);
        addView(dashboard, new LayoutParams(LayoutParams.MATCH_PARENT, 0, 1));
        divider = new WideDivider(context, true);
        divider.setBackgroundColor(WideUi.SURFACE);
        divider.setVisibility(GONE);
        addView(divider, new LayoutParams(LayoutParams.MATCH_PARENT, dp(24)));
    }

    private int dp(float value) { return WideUi.dp(getContext(), value); }
    private Activity activity() { return WideVariant.activity(getContext()); }

    private void updateButtons() {
        String gpsLabel = WideCamera.running ? "停止" : "定位";
        String controlsLabel = WideSettings.controlsVisible() ? "收合" : "快捷";
        if (!TextUtils.equals(gps.getText(), gpsLabel)) gps.setText(gpsLabel);
        if (!TextUtils.equals(controls.getText(), controlsLabel)) controls.setText(controlsLabel);
    }

    private void toggleGps() {
        Activity activity = activity();
        if (activity == null) return;
        if (WideCamera.running) WideCamera.stop(activity);
        else WideCamera.start(activity);
        updateButtons();
        dashboard.invalidate();
    }

    private void toggleQuickControls() {
        Activity activity = activity();
        if (activity != null) WideSettings.toggleControls(activity);
    }

    public void adapt(boolean portrait, boolean shown) {
        quickControls = shown;
        updateButtons();
        updateDivider();
        divider.updateAxis();
    }

    void fitLayout(boolean compact, boolean dividerFits) {
        if (this.compact == compact && this.dividerFits == dividerFits) return;
        this.compact = compact;
        this.dividerFits = dividerFits;
        toolbar.setVisibility(compact ? GONE : VISIBLE);
        divider.getLayoutParams().height = dp(compact ? 12 : 24);
        updateDivider();
    }

    private void updateDivider() {
        divider.setVisibility(quickControls && dividerFits ? VISIBLE : GONE);
    }

    @Override protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight) {
        super.onSizeChanged(width, height, oldWidth, oldHeight);
        controls.setVisibility(width < dp(222) ? GONE : VISIBLE);
        if (!autoCollapsed && height > 0 && height < dp(300) && WideSettings.controlsVisible()) {
            autoCollapsed = true;
            post(() -> { if (isAttachedToWindow() && WideSettings.controlsVisible()) toggleQuickControls(); });
        }
    }

    void openMenu(View anchor) {
        PopupMenu menu = new PopupMenu(getContext(), anchor);
        menu.getMenu().add(0, 1, 0, "版面與比例設定");
        menu.getMenu().add(0, 2, 1, "台灣測速設定與診斷");
        menu.getMenu().add(0, 3, 2, "示範固定測速");
        menu.getMenu().add(0, 4, 3, "示範區間測速");
        if (compact || controls.getVisibility() == GONE) {
            menu.getMenu().add(0, 5, 4, WideSettings.controlsVisible() ? "收合快捷鍵" : "顯示快捷鍵");
        }
        if (compact) {
            menu.getMenu().add(0, 6, 5, WideCamera.running ? "停止 GPS 定位" : "啟動 GPS 定位");
        }
        menu.setOnMenuItemClickListener(item -> {
            Activity activity = activity();
            if (activity == null) return true;
            switch (item.getItemId()) {
                case 1:
                    WideSettings.show(activity, (ViewGroup) activity.findViewById(android.R.id.content));
                    break;
                case 2:
                    WideTaiwanSettings.show(activity, (ViewGroup) activity.findViewById(android.R.id.content));
                    break;
                case 3: showDemo(activity, 1); break;
                case 4: showDemo(activity, 2); break;
                case 5: toggleQuickControls(); break;
                case 6: toggleGps(); break;
                default: return false;
            }
            return true;
        });
        menu.show();
    }

    private void showDemo(Activity activity, int mode) {
        if (activity.isFinishing() || activity.isDestroyed()) return;
        WideCameraCard preview = new WideCameraCard(activity, mode);
        FrameLayout container = new FrameLayout(activity);
        int windowHeight = activity.getWindow().getDecorView().getHeight();
        int height = windowHeight > 0 ? Math.min(dp(280), Math.max(dp(96), windowHeight - dp(132))) : dp(240);
        container.addView(preview, new FrameLayout.LayoutParams(LayoutParams.MATCH_PARENT, height));
        new AlertDialog.Builder(activity)
                .setTitle(mode == 1 ? "固定測速示範" : "區間測速示範")
                .setView(container)
                .setPositiveButton("關閉", null)
                .show();
    }

    @Override protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        main.removeCallbacks(tick);
        tick.run();
    }

    @Override protected void onDetachedFromWindow() {
        main.removeCallbacks(tick);
        super.onDetachedFromWindow();
    }

    public void dispose() {
        disposed = true;
        main.removeCallbacks(tick);
    }
}
