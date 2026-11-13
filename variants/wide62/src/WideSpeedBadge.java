package com.navipilot.obf;

import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.PopupMenu;
import android.widget.TextView;

public final class WideSpeedBadge extends LinearLayout {
    private final FrameLayout map;
    private final boolean google;
    private final SharedPreferences preferences;
    private final TextView sign;
    private final TextView source;
    private final int size;
    private final int touchSlop;
    private String mode;
    private int displayed = -1;
    private float downX, downY, startX, startY;
    private boolean tracking, dragging;
    private final Runnable startDrag = this::startDrag;
    private final Runnable update = this::update;
    private final OnLayoutChangeListener fit =
            (view, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom) -> {
                if (dragging) move(getTranslationX(), getTranslationY());
                else restore();
            };

    public static void attach(FrameLayout map) {
        add(map, false);
    }

    public static void attachGoogle(Activity activity, int rootId) {
        View root = activity.findViewById(rootId);
        if (root instanceof FrameLayout) add((FrameLayout) root, true);
    }

    private static void add(FrameLayout map, boolean google) {
        WideSpeedBadge badge = new WideSpeedBadge(map, google);
        map.addView(badge, new FrameLayout.LayoutParams(
                badge.dp(112), badge.size + badge.dp(20), Gravity.TOP | Gravity.LEFT));
    }

    private WideSpeedBadge(FrameLayout map, boolean google) {
        super(map.getContext());
        this.map = map;
        this.google = google;
        preferences = getContext().getSharedPreferences("copilot_osm_badge", 0);
        size = dp(66);
        touchSlop = ViewConfiguration.get(getContext()).getScaledTouchSlop();
        setOrientation(VERTICAL);
        setGravity(Gravity.CENTER_HORIZONTAL);
        setElevation(dp(6));
        setVisibility(INVISIBLE);
        setFocusable(true);
        setOnClickListener(view -> showOptions());

        GradientDrawable circle = new GradientDrawable();
        circle.setShape(GradientDrawable.OVAL);
        circle.setColor(Color.WHITE);
        circle.setStroke(dp(6), 0xffdf242c);
        sign = label(30, Color.BLACK);
        sign.setBackground(circle);
        addView(sign, new LayoutParams(size, size));

        source = label(12, Color.WHITE);
        source.setText("OSM");
        GradientDrawable background = new GradientDrawable();
        background.setColor(0xe61a2431);
        background.setCornerRadius(dp(4));
        source.setBackground(background);
        source.setPadding(dp(4), 0, dp(4), 0);
        addView(source, new LayoutParams(LayoutParams.WRAP_CONTENT, dp(18)));
    }

    private TextView label(int sizeSp, int color) {
        TextView label = new TextView(getContext());
        label.setGravity(Gravity.CENTER);
        label.setTextSize(sizeSp);
        label.setTextColor(color);
        label.setTypeface(Typeface.DEFAULT, Typeface.BOLD);
        label.setImportantForAccessibility(IMPORTANT_FOR_ACCESSIBILITY_NO);
        label.setIncludeFontPadding(false);
        return label;
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        map.addOnLayoutChangeListener(fit);
        scheduleUpdate();
    }

    @Override
    protected void onDetachedFromWindow() {
        map.removeOnLayoutChangeListener(fit);
        removeCallbacks(update);
        endTouch();
        super.onDetachedFromWindow();
    }

    @Override
    protected void onWindowVisibilityChanged(int visibility) {
        super.onWindowVisibilityChanged(visibility);
        if (isAttachedToWindow()) scheduleUpdate();
    }

    private void scheduleUpdate() {
        removeCallbacks(update);
        if (getWindowVisibility() == VISIBLE) {
            post(update);
        } else {
            boolean wasDragging = dragging;
            endTouch();
            if (wasDragging) restore();
        }
    }

    private void update() {
        if (!isAttachedToWindow() || getWindowVisibility() != VISIBLE) return;
        String nextMode = google ? "SDK" : WideVariant.navigation().name();
        boolean supported = WideOsmLocation.badgeVisible(getContext())
                && (google || "CAR".equals(nextMode) || "PHONE".equals(nextMode));
        if (!nextMode.equals(mode)) {
            endTouch();
            mode = nextMode;
            restore();
        }
        if (supported) {
            int limit = WideOsmLimit.currentValue();
            String status = limit > 0 ? "OSM" : WideOsmLocation.label(getContext());
            if (!status.contentEquals(source.getText())) source.setText(status);
            if (displayed != limit) {
                displayed = limit;
                sign.setText(limit > 0 ? Integer.toString(limit) : "—");
                setContentDescription(limit > 0 ? "OSM 道路速限 " + limit + " 公里／小時"
                        : "OSM 道路速限未知");
            }
        }
        setVisibility(supported ? VISIBLE : INVISIBLE);
        postDelayed(update, 750);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getActionMasked()) {
            case MotionEvent.ACTION_DOWN:
                downX = event.getRawX();
                downY = event.getRawY();
                startX = getTranslationX();
                startY = getTranslationY();
                tracking = true;
                postDelayed(startDrag, ViewConfiguration.getLongPressTimeout());
                return true;
            case MotionEvent.ACTION_MOVE:
                float dx = event.getRawX() - downX;
                float dy = event.getRawY() - downY;
                if (dragging) move(startX + dx, startY + dy);
                else if (Math.abs(dx) > touchSlop || Math.abs(dy) > touchSlop) endTouch();
                return true;
            case MotionEvent.ACTION_UP:
                if (dragging) {
                    move(startX + event.getRawX() - downX, startY + event.getRawY() - downY);
                    save();
                } else if (tracking) {
                    performClick();
                }
                endTouch();
                return true;
            case MotionEvent.ACTION_CANCEL:
            case MotionEvent.ACTION_POINTER_DOWN:
                boolean wasDragging = dragging;
                endTouch();
                if (wasDragging) restore();
                return true;
            default:
                return true;
        }
    }

    private void startDrag() {
        if (!tracking) return;
        dragging = true;
        getParent().requestDisallowInterceptTouchEvent(true);
        performHapticFeedback(android.view.HapticFeedbackConstants.LONG_PRESS);
    }

    private void endTouch() {
        removeCallbacks(startDrag);
        if (dragging && getParent() != null) getParent().requestDisallowInterceptTouchEvent(false);
        tracking = false;
        dragging = false;
    }

    private void showOptions() {
        if (mode == null) return;
        final String selectedMode = mode;
        PopupMenu menu = new PopupMenu(getContext(), this);
        menu.getMenu().add("恢復速限牌位置");
        menu.setOnMenuItemClickListener(item -> {
            preferences.edit().remove(selectedMode + "_x").remove(selectedMode + "_y").apply();
            if (selectedMode.equals(mode)) restore();
            return true;
        });
        menu.show();
    }

    private void restore() {
        if (mode == null) return;
        float x = preferences.getFloat(mode + "_x", -1);
        float y = preferences.getFloat(mode + "_y", -1);
        move(x < 0 ? dp(8) : x * maxX(), y < 0 ? dp(94) : y * maxY());
    }

    private void save() {
        if (mode == null) return;
        SharedPreferences.Editor editor = preferences.edit();
        if (maxX() > 0) editor.putFloat(mode + "_x", getTranslationX() / maxX());
        if (maxY() > 0) editor.putFloat(mode + "_y", getTranslationY() / maxY());
        editor.apply();
    }

    private void move(float x, float y) {
        setTranslationX(Math.max(0, Math.min(x, maxX())));
        setTranslationY(Math.max(0, Math.min(y, maxY())));
    }

    private int maxX() {
        return Math.max(0, map.getWidth() - dp(112));
    }

    private int maxY() {
        return Math.max(0, map.getHeight() - size - dp(20));
    }

    private int dp(int value) {
        return Math.round(value * getResources().getDisplayMetrics().density);
    }
}
