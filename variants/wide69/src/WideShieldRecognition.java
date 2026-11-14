package com.navipilot.obf;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Geometry and text checks for Shield's camera sign, type label and distance. */
final class WideShieldRecognition {
    private static final Pattern LIMIT = Pattern.compile("[1-9][0-9]{1,2}");
    private static final Pattern METRES = Pattern.compile("([0-9]{1,4})(?:公尺?|米|[mM])");
    private static final Pattern KILOMETRES = Pattern.compile("([0-9](?:[.,][0-9]{1,2})?)[kK](?:[mM])?");
    private static final int RING_POINTS = 12;
    private static final double[] COS = new double[RING_POINTS];
    private static final double[] SIN = new double[RING_POINTS];

    static {
        for (int i = 0; i < RING_POINTS; i++) {
            double angle = i * 2.0 * Math.PI / RING_POINTS;
            COS[i] = Math.cos(angle);
            SIN[i] = Math.sin(angle);
        }
    }

    record Sign(int x, int y, int radius, int fit) {}
    record Alert(String kind, int distance, int limit) {}

    static List<Sign> signs(int[] pixels, int width, int height) {
        List<Sign> found = new ArrayList<>();
        int stride = Math.max(3, height / 90);
        for (int radius = Math.max(9, height / 14); radius <= height * 23 / 100; radius += stride) {
            for (int y = Math.max(radius, height / 4); y < height - radius; y += stride) {
                for (int x = Math.max(radius, width * 35 / 100); x < width - radius; x += stride) {
                    if (!white(pixels[y * width + x - radius / 2])
                            || !white(pixels[y * width + x + radius / 2])
                            || !red(pixels[y * width + x - radius])
                            || !red(pixels[y * width + x + radius])) continue;
                    int outer = 0;
                    int inner = 0;
                    for (int i = 0; i < RING_POINTS; i++) {
                        int dx = (int) Math.round(COS[i] * radius);
                        int dy = (int) Math.round(SIN[i] * radius);
                        if (red(pixels[(y + dy) * width + x + dx])) outer++;
                        if (white(pixels[(y + dy * 3 / 5) * width + x + dx * 3 / 5])) inner++;
                    }
                    if (outer >= 10 && inner >= 9) found.add(new Sign(x, y, radius, inner + outer));
                }
            }
        }
        found.sort(Comparator.comparingInt(Sign::fit).thenComparingInt(Sign::radius).reversed());
        List<Sign> results = new ArrayList<>(2);
        for (Sign sign : found) {
            boolean overlaps = results.stream().anyMatch(previous ->
                    Math.hypot(previous.x - sign.x, previous.y - sign.y) < previous.radius);
            if (!overlaps) results.add(sign);
            if (results.size() == 2) break;
        }
        return results;
    }

    private static boolean white(int color) {
        return Math.min(color >>> 16 & 255, Math.min(color >>> 8 & 255, color & 255)) >= 160;
    }

    private static boolean red(int color) {
        int r = color >>> 16 & 255;
        return r >= 145 && r - Math.max(color >>> 8 & 255, color & 255) >= 95;
    }

    static boolean yellow(int color) {
        int g = color >>> 8 & 255;
        return (color >>> 16 & 255) >= 150 && g >= 115 && g - (color & 255) >= 50;
    }

    static String kind(String text) {
        return switch (compact(text)) {
            case "固定式", "固定測速" -> "固定式";
            case "移動式", "移動測速", "流動式", "經常出沒" -> "移動式";
            default -> "";
        };
    }

    static int limit(String text) {
        String value = compact(text);
        if (!LIMIT.matcher(value).matches()) return 0;
        int limit = Integer.parseInt(value);
        return limit >= 20 && limit <= 130 && limit % 10 == 0 ? limit : 0;
    }

    static int distance(String text) {
        String value = compact(text);
        Matcher metres = METRES.matcher(value);
        Matcher km = KILOMETRES.matcher(value);
        int result = 0;
        if (metres.matches()) result = Integer.parseInt(metres.group(1));
        else if (km.matches()) result = (int) Math.round(Double.parseDouble(km.group(1).replace(',', '.')) * 1000);
        return result > 0 && result <= 5000 ? result : 0;
    }

    static boolean agrees(Alert previous, Alert next, long deltaMs) {
        return previous != null && next != null && deltaMs >= 650 && deltaMs <= 2600
                && previous.kind.equals(next.kind) && previous.limit == next.limit
                && next.distance <= previous.distance + 20
                && previous.distance - next.distance <= 20 + 55 * deltaMs / 1000;
    }

    private static String compact(String text) {
        return text == null ? "" : text.replaceAll("[\\s\\p{Zs}]+", "");
    }
}
