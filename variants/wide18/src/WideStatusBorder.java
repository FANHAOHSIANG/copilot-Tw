package com.navipilot.obf;

import android.app.Activity;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.view.View;
import java.util.Map;

/** Displays only the two active flags from the existing, validated C4 telemetry stream. */
public final class WideStatusBorder extends Drawable implements View.OnAttachStateChangeListener {
    private static final int GRAY = 0xffa1a7ae;
    private static final int GREEN = 0xff52d584;

    private static final class State {
        final int color;
        final long expiresAt;

        State(int color, long expiresAt) {
            this.color = color;
            this.expiresAt = expiresAt;
        }
    }

    private static volatile State state;
    private final View root;
    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private int shownColor;

    private final Runnable redraw = new Runnable() {
        @Override public void run() {
            if (!root.isAttachedToWindow()) return;
            int color = currentColor();
            if (shownColor != color) {
                shownColor = color;
                invalidateSelf();
            }
            root.postDelayed(this, 80);
        }
    };

    public static void update(zg telemetry) {
        vg sample = telemetry == null ? null : telemetry.b("carControl");
        if (sample == null || sample.a == null || sample.a.c == null) {
            clear();
            return;
        }
        Map<?, ?> fields = sample.a.c;
        int color = activeColor(fields.get("latActive"), fields.get("longActive"));
        state = color == 0 ? null : new State(color, sample.c);
    }

    public static void clear() {
        state = null;
    }

    static int activeColor(Object lateral, Object longitudinal) {
        if (!Boolean.TRUE.equals(lateral) || !(longitudinal instanceof Boolean)) return 0;
        return Boolean.TRUE.equals(longitudinal) ? GREEN : GRAY;
    }

    private static int currentColor() {
        State current = state;
        long now = System.nanoTime() / 1_000_000L;
        return current != null && now < current.expiresAt ? current.color : 0;
    }

    public static void install(Activity activity) {
        View root = activity.findViewById(android.R.id.content);
        if (root != null) new WideStatusBorder(root);
    }

    private WideStatusBorder(View root) {
        this.root = root;
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(Math.max(1f, 2f * root.getResources().getDisplayMetrics().density));
        root.getOverlay().add(this);
        root.addOnLayoutChangeListener((v, l, t, r, b, oldL, oldT, oldR, oldB) ->
                setBounds(0, 0, r - l, b - t));
        setBounds(0, 0, root.getWidth(), root.getHeight());
        root.addOnAttachStateChangeListener(this);
        if (root.isAttachedToWindow()) onViewAttachedToWindow(root);
    }

    @Override public void onViewAttachedToWindow(View view) {
        root.removeCallbacks(redraw);
        redraw.run();
    }

    @Override public void onViewDetachedFromWindow(View view) {
        root.removeCallbacks(redraw);
    }

    @Override public void draw(Canvas canvas) {
        int color = currentColor();
        if (color == 0) return;
        Rect bounds = getBounds();
        float inset = paint.getStrokeWidth() / 2f;
        if (bounds.width() <= inset * 2 || bounds.height() <= inset * 2) return;
        paint.setColor(color);
        canvas.drawRect(bounds.left + inset, bounds.top + inset,
                bounds.right - inset, bounds.bottom - inset, paint);
    }

    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter filter) {}
    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
}
