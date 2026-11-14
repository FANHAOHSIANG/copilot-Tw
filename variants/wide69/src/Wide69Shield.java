package com.navipilot.obf;

import android.content.Context;
import android.graphics.Bitmap;
import android.os.SystemClock;
import android.view.TextureView;
import com.googlecode.tesseract.android.TessBaseAPI;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONException;
import org.json.JSONObject;

/** Bounded, on-device frame reading for a visual alert in the projection host. */
final class Wide69Shield {
    private static final String SHIELD_PACKAGE = "tw.com.ainvest.outpack";
    private static final String TRAINED_DATA = "chi_tra.traineddata";
    private static final Executor WORKER = Executors.newSingleThreadExecutor();
    private static final AtomicBoolean BUSY = new AtomicBoolean();
    private static final long FRESH_MS = 2600;
    private static TextureView owner;
    private static volatile int generation;
    private static long nextSample;
    private static long phaseStart;
    private static long lastGlow;
    private static double phase;
    // These values are used on the projection worker only.
    private static TessBaseAPI ocr;
    private static boolean ocrUnavailable;
    private static int previousGeneration;
    private static long previousTime;
    private static WideShieldRecognition.Alert previous;
    private static volatile TimedAlert active;

    private record TimedAlert(int generation, long time, WideShieldRecognition.Alert alert) {}

    static void sample(TextureView texture) {
        if (!WideShieldSize.protect || !texture.isShown() || !texture.isAvailable()
                || !SHIELD_PACKAGE.equals(WidePanels.sidePackage(texture.getContext()))) {
            clear(texture);
            return;
        }
        long now = SystemClock.elapsedRealtime();
        if (now < nextSample || !BUSY.compareAndSet(false, true)) return;
        nextSample = now + 1000;
        owner = texture;
        int epoch = generation;
        int width = texture.getWidth();
        int height = texture.getHeight();
        if (width < WideShieldSize.MIN_WIDTH || height < WideShieldSize.MIN_HEIGHT) {
            active = null;
            BUSY.set(false);
            report("pane_too_small", width, height, now, null);
            return;
        }

        // Bound the readback, memory transfer and recognition cost on wide displays.
        float scale = Math.min(1f, Math.min(960f / width, 540f / height));
        Bitmap frame;
        try {
            frame = texture.getBitmap(Math.round(width * scale), Math.round(height * scale));
        } catch (RuntimeException error) {
            frame = null;
        }
        if (frame == null) {
            active = null;
            BUSY.set(false);
            report("capture_unavailable", width, height, now, null);
            return;
        }

        Bitmap capture = frame;
        Context context = texture.getContext().getApplicationContext();
        WORKER.execute(() -> {
            try {
                inspect(context, capture, width, height, now, epoch);
            } catch (IOException | RuntimeException | LinkageError error) {
                active = null;
                previous = null;
                ocrUnavailable = true;
                report("recognizer_unavailable", width, height, now, null);
            } finally {
                capture.recycle();
                BUSY.set(false);
            }
        });
    }

    private static void inspect(Context context, Bitmap capture, int width, int height, long time, int epoch)
            throws IOException {
        if (!WideShieldSize.protect || epoch != generation) return;
        WideShieldRecognition.Alert candidate = recognize(context, capture);
        if (epoch != generation || !WideShieldSize.protect || SystemClock.elapsedRealtime() - time > FRESH_MS) return;
        boolean confirmed = previousGeneration == epoch
                && WideShieldRecognition.agrees(previous, candidate, time - previousTime);
        active = confirmed ? new TimedAlert(epoch, time, candidate) : null;
        previousGeneration = epoch;
        previousTime = time;
        previous = candidate;
        String state = confirmed ? "camera_recognized" : candidate != null ? "awaiting_second_frame"
                : ocrUnavailable ? "recognizer_unavailable" : "panel_unconfirmed";
        report(state, width, height, time, confirmed ? candidate : null);
    }

    private static WideShieldRecognition.Alert recognize(Context context, Bitmap frame) throws IOException {
        int width = frame.getWidth(), height = frame.getHeight();
        int[] pixels = new int[width * height];
        frame.getPixels(pixels, 0, width, 0, 0, width, height);
        for (WideShieldRecognition.Sign sign : WideShieldRecognition.signs(pixels, width, height)) {
            if (ocrUnavailable) break;
            if (ocr == null && !initialize(context)) break;
            int x = sign.x(), y = sign.y(), r = sign.radius();
            String type = WideShieldRecognition.kind(read(frame, x - 3.55 * r, y - .2 * r,
                    x - 1.17 * r, y + .65 * r, false, ""));
            if (type.isEmpty()) continue;
            int limit = WideShieldRecognition.limit(read(frame, x - .6 * r, y - .53 * r,
                    x + .6 * r, y + .53 * r, false, "0123456789"));
            if (limit == 0) continue;
            int distance = WideShieldRecognition.distance(read(frame, x - 3.43 * r, y - 3.32 * r,
                    x - .67 * r, y - 2.31 * r, true, ""));
            if (distance > 0) return new WideShieldRecognition.Alert(type, distance, limit);
        }
        return null;
    }

    private static boolean initialize(Context context) throws IOException {
        File folder = new File(context.getFilesDir(), "shield-ocr-4.1");
        File data = new File(folder, "tessdata/" + TRAINED_DATA);
        if (!data.isFile()) {
            Files.createDirectories(data.toPath().getParent());
            File pending = File.createTempFile("shield-", ".pending", data.getParentFile());
            try (InputStream asset = context.getAssets().open("shield/" + TRAINED_DATA)) {
                Files.copy(asset, pending.toPath(), StandardCopyOption.REPLACE_EXISTING);
                Files.move(pending.toPath(), data.toPath(), StandardCopyOption.REPLACE_EXISTING);
            } finally {
                Files.deleteIfExists(pending.toPath());
            }
        }
        TessBaseAPI api = new TessBaseAPI();
        if (!api.init(folder.getAbsolutePath(), "chi_tra", 1)) {
            api.recycle();
            ocrUnavailable = true;
            return false;
        }
        api.setPageSegMode(7);
        ocr = api;
        return true;
    }

    private static String read(Bitmap frame, double left, double top, double right, double bottom,
                               boolean yellowText, String whitelist) {
        int x = Math.max(0, (int) Math.round(left));
        int y = Math.max(0, (int) Math.round(top));
        int w = Math.min(frame.getWidth(), (int) Math.round(right)) - x;
        int h = Math.min(frame.getHeight(), (int) Math.round(bottom)) - y;
        if (w < 20 || h < 14) return "";
        if (yellowText) {
            // Reject other bright readings (clock, elevation and live speed).
            int yellow = 0;
            for (int row = y; row < y + h; row += 2) {
                for (int col = x; col < x + w; col += 2) {
                    if (WideShieldRecognition.yellow(frame.getPixel(col, row))) yellow++;
                }
            }
            if (yellow < w * h / 160) return "";
        }
        Bitmap region = Bitmap.createBitmap(frame, x, y, w, h);
        int scale = yellowText ? 3 : 2;
        Bitmap enlarged = Bitmap.createScaledBitmap(region, w * scale, h * scale, true);
        try {
            ocr.setVariable("tessedit_char_whitelist", whitelist);
            ocr.setImage(enlarged);
            String result = ocr.getUTF8Text();
            // The small unit can score below the large distance digits.
            // Require a recognized unit and a confident numeric word.
            if (yellowText) {
                int[] words = ocr.wordConfidences();
                return words.length > 0 && words[0] >= 72 ? result : "";
            }
            return ocr.meanConfidence() >= 72 ? result : "";
        } finally {
            ocr.clear();
            enlarged.recycle();
            if (region != frame && region != enlarged) region.recycle();
        }
    }

    static void clear(TextureView texture) {
        if (owner == texture) {
            generation++;
            owner = null;
            active = null;
        }
    }

    static int glow(long now) {
        TimedAlert alert = active;
        if (!WideShieldSize.protect || alert == null || alert.generation != generation
                || now < alert.time || now - alert.time > FRESH_MS || alert.alert.distance() > 500) {
            phaseStart = 0;
            phase = 0;
            return 0;
        }
        double closeness = 1 - alert.alert.distance() / 500.0;
        double period = 2000 - 1420 * closeness;
        if (phaseStart == 0 || now <= lastGlow || now - lastGlow > 500) {
            phaseStart = now;
            phase = 0;
        } else {
            phase = (phase + (now - lastGlow) / period) % 1;
        }
        lastGlow = now;
        double pulse = (1 + Math.cos(phase * Math.PI * 2)) / 2;
        return (int) ((55 + 177 * closeness) * (.19 + .81 * pulse));
    }

    private static void report(String state, int width, int height, long time, WideShieldRecognition.Alert candidate) {
        JSONObject event = new JSONObject();
        try {
            event.put("state", state);
            event.put("width_px", width);
            event.put("height_px", height);
            event.put("sample_mono_ms", time);
            if (candidate != null) {
                event.put("camera_type", candidate.kind());
                event.put("distance_m", candidate.distance());
                event.put("camera_limit_kph", candidate.limit());
            }
            WideBridgeLog.event("shield_frame", event);
        } catch (JSONException ignored) {
        }
    }

    private Wide69Shield() {}
}
