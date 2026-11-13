package com.navipilot.obf;

import android.graphics.Bitmap;
import android.os.SystemClock;
import android.view.TextureView;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONException;
import org.json.JSONObject;

/** Collects bounded diagnostics from Shield's projection texture. */
final class WideShieldSample {
    private static final Executor WORKER = Executors.newSingleThreadExecutor();
    private static final AtomicBoolean BUSY = new AtomicBoolean();
    private static long nextSample;

    static void sample(TextureView texture) {
        if (!WideShieldSize.protect || !texture.isAvailable()) return;
        long now = SystemClock.elapsedRealtime();
        if (now < nextSample || !BUSY.compareAndSet(false, true)) return;
        nextSample = now + 1000;
        int width = texture.getWidth();
        int height = texture.getHeight();
        if (width < WideShieldSize.MIN_WIDTH || height < WideShieldSize.MIN_HEIGHT) {
            BUSY.set(false);
            report("pane_too_small", width, height, now);
            return;
        }

        Bitmap frame;
        try {
            frame = texture.getBitmap();
        } catch (RuntimeException error) {
            BUSY.set(false);
            report("capture_failed", width, height, now);
            return;
        }
        if (frame == null) {
            BUSY.set(false);
            report("capture_unavailable", width, height, now);
            return;
        }
        WORKER.execute(() -> {
            try {
                if (WideShieldSize.protect) inspect(frame, now);
            } finally {
                frame.recycle();
                BUSY.set(false);
            }
        });
    }

    private static void inspect(Bitmap frame, long time) {
        int width = frame.getWidth();
        int height = frame.getHeight();
        // Read a bounded grid so diagnostics stay cheap on larger screens.
        int step = Math.max(1, Math.max(width, height) / 256);
        int[] row = new int[width];
        int red = 0;
        int bright = 0;
        for (int y = 0; y < height; y += step) {
            frame.getPixels(row, 0, width, 0, y, width, 1);
            for (int x = 0; x < width; x += step) {
                int pixel = row[x];
                int r = (pixel >>> 16) & 255;
                int g = (pixel >>> 8) & 255;
                int b = pixel & 255;
                if (r >= 145 && r - Math.max(g, b) >= 60) red++;
                if (Math.min(r, Math.min(g, b)) >= 175) bright++;
            }
        }
        report(red > 0 && bright > 0 ? "frame_sampled" : "panel_unconfirmed", width, height, time);
    }

    private static void report(String state, int width, int height, long time) {
        JSONObject event = new JSONObject();
        try {
            event.put("state", state);
            event.put("width_px", width);
            event.put("height_px", height);
            event.put("sample_mono_ms", time);
            WideBridgeLog.event("shield_frame", event);
        } catch (JSONException ignored) {
            // Diagnostics must not interrupt projection.
        }
    }

    private WideShieldSample() {}
}
