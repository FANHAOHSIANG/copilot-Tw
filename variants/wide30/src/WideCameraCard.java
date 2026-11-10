package com.navipilot.obf;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Paint;
import android.graphics.Shader;
import android.graphics.Typeface;
import android.os.SystemClock;
import android.text.TextPaint;
import android.text.TextUtils;
import android.view.View;

/** Shared renderer for the live Taiwan card and the independent animated preview. */
final class WideCameraCard extends View implements WideCameraFace.Painter {
    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private final TextPaint textPaint = new TextPaint(Paint.ANTI_ALIAS_FLAG);
    private final int demoMode;
    private final long demoStart;
    private Canvas drawing;
    private WideCameraFace.Model liveModel;
    private long lastModelAt;
    private long lastFlashAt;
    private double flashPhase;

    WideCameraCard(Context context, int demoMode) {
        super(context);
        this.demoMode = demoMode;
        demoStart = SystemClock.elapsedRealtime();
        textPaint.setTypeface(Typeface.create("sans-serif-black", Typeface.BOLD));
        if (demoMode == 0) setContentDescription("台灣測速即時儀表");
    }

    @Override protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        float density = getResources().getDisplayMetrics().density;
        float width = getWidth() / density;
        float height = getHeight() / density;
        long now = SystemClock.elapsedRealtime();
        if (demoMode == 0 && (liveModel == null || now - lastModelAt >= 200)) {
            liveModel = WideCamera.model();
            lastModelAt = now;
        }
        WideCameraFace.Model model = demoMode == 0 ? liveModel
                : WideCameraFace.demo(demoMode, now - demoStart);
        float warning = WideCameraFace.warningStrength(model);
        if (warning > 0 && lastFlashAt > 0) {
            flashPhase += Math.min(250L, now - lastFlashAt) / WideCameraFace.flashPeriodMs(model);
            flashPhase %= 1.0;
        } else flashPhase = 0.0;
        lastFlashAt = warning > 0 ? now : 0;
        canvas.save();
        canvas.scale(density, density);
        canvas.clipRect(0, 0, width, height);
        drawing = canvas;
        WideLiveCameraFace.render(this, width, height, model, now, demoMode != 0);
        float pulse = (float) (0.45 + 0.55 * (0.5 + 0.5 * Math.sin(2 * Math.PI * flashPhase)));
        drawGlow(width, height, warning * pulse);
        drawing = null;
        canvas.restore();
        if (warning > 0 || demoMode != 0) postInvalidateDelayed(40);
    }

    private void drawGlow(float width, float height, float strength) {
        float depth = Math.min(30f, Math.min(width, height) / 4f);
        if (strength <= 0f || depth <= 0f) return;
        int red = (Math.round(150f * strength) << 24) | 0x00ff2438;
        int transparentRed = 0x00ff2438;
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(0xffffffff);
        paint.setShader(new LinearGradient(0, 0, 0, depth, red, transparentRed, Shader.TileMode.CLAMP));
        drawing.drawRect(0, 0, width, depth, paint);
        paint.setShader(new LinearGradient(0, height, 0, height - depth, red, transparentRed, Shader.TileMode.CLAMP));
        drawing.drawRect(0, height - depth, width, height, paint);
        paint.setShader(new LinearGradient(0, 0, depth, 0, red, transparentRed, Shader.TileMode.CLAMP));
        drawing.drawRect(0, 0, depth, height, paint);
        paint.setShader(new LinearGradient(width, 0, width - depth, 0, red, transparentRed, Shader.TileMode.CLAMP));
        drawing.drawRect(width - depth, 0, width, height, paint);
        paint.setShader(null);
    }

    @Override public void rect(float x, float y, float width, float height, float radius, int color) {
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(color);
        drawing.drawRoundRect(x, y, x + width, y + height, radius, radius, paint);
    }

    @Override public void circle(float x, float y, float radius, float stroke, int color) {
        paint.setColor(color);
        paint.setStyle(stroke > 0 ? Paint.Style.STROKE : Paint.Style.FILL);
        paint.setStrokeWidth(stroke);
        drawing.drawCircle(x, y, radius, paint);
    }

    @Override public void line(float x1, float y1, float x2, float y2, float stroke, int color) {
        paint.setStyle(Paint.Style.STROKE);
        paint.setColor(color);
        paint.setStrokeWidth(stroke);
        drawing.drawLine(x1, y1, x2, y2, paint);
    }

    @Override public void text(String value, float x, float y, float size, int color,
                               float maxWidth, boolean center) {
        if (maxWidth <= 0) return;
        textPaint.setColor(color);
        textPaint.setTextSize(size);
        textPaint.setTextAlign(center ? Paint.Align.CENTER : Paint.Align.LEFT);
        if (value.matches("[0-9 .—]+(?:m|秒)?")) {
            float measured = textPaint.measureText(value);
            if (measured > maxWidth) textPaint.setTextSize(Math.max(10, size * maxWidth / measured));
        }
        String fitted = TextUtils.ellipsize(value, textPaint, maxWidth, TextUtils.TruncateAt.END).toString();
        drawing.drawText(fitted, x, y, textPaint);
    }
}
