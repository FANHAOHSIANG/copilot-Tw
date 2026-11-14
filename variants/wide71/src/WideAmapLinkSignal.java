package com.navipilot.obf;

import java.util.Map;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/** Phone Link phase countdown. This data belongs to the navigation display. */
final class WideAmapLinkSignal {
    private static final String STREAM = "traffic_signal";
    private static final int COUNTDOWN = 12;
    private static final int CLEAR_COUNTDOWN = 13;
    private static final long FRESH_MS = 2500;
    private static final int MAX_DISTANCE_M = 300;
    private static final double METERS_PER_DEGREE = 111_320.0;

    private long lastEvent = -1;
    private long lastRoute = -1;
    private long lastMatch = -1;
    private String path;
    private double latitude;
    private double longitude;
    private JSONObject signal;
    private long signalElapsed;
    private long signalWall;

    /** Returns true when the traffic stream needs to be published immediately. */
    synchronized boolean accept(int type, JSONObject data, long elapsed, long wall) {
        if (elapsed < 0 || elapsed < lastEvent || wall <= 0) return false;
        switch (type) {
            case 2:  // Route switch.
            case 3:  // Route invalidated.
            case 19:
            case 20:
            case 100: // Navigation stopped.
            case 200: // Arrived.
                reset();
                break;
            case 4:
                updateRoute(data, elapsed);
                break;
            case 16:
                if (data != null && Boolean.TRUE.equals(data.opt("isMatchNaviPath"))) {
                    lastMatch = elapsed;
                } else {
                    lastMatch = -1;
                    signal = null;
                }
                break;
            case COUNTDOWN:
                signal = decode(data, elapsed);
                signalElapsed = elapsed;
                signalWall = wall;
                break;
            case CLEAR_COUNTDOWN:
                signal = null;
                break;
            default:
                return false;
        }
        lastEvent = elapsed;
        return type == COUNTDOWN || type == CLEAR_COUNTDOWN || (type == 16 && lastMatch < 0);
    }

    private void updateRoute(JSONObject data, long elapsed) {
        Object nextPath = data == null ? null : data.opt("pathID");
        double lat = coordinate(data, "matchPosLat", 90);
        double lon = coordinate(data, "matchPosLon", 180);
        if (!(nextPath instanceof Number || nextPath instanceof String)
                || !Double.isFinite(lat) || !Double.isFinite(lon) || (lat == 0 && lon == 0)) {
            path = null;
            lastRoute = -1;
            signal = null;
            return;
        }
        String id = nextPath.toString();
        if (id.isEmpty() || !id.equals(path)) {
            signal = null;
            if (path != null) lastMatch = -1;
        }
        path = id.isEmpty() ? null : id;
        latitude = lat;
        longitude = lon;
        lastRoute = elapsed;
    }

    private JSONObject decode(JSONObject data, long now) {
        if (path == null || !fresh(lastRoute, now) || !fresh(lastMatch, now) || data == null
                || integer(data, "eventType") != 26035) return null;
        JSONArray junctions = data.optJSONArray("commonInfos");
        JSONObject junction = junctions == null ? null : junctions.optJSONObject(0);
        if (junction == null) return null;
        JSONObject position = junction.optJSONObject("pos");
        double lat = coordinate(position, "lat", 90);
        double lon = coordinate(position, "lon", 180);
        // Both positions come from Link in the same coordinate system.
        double north = (lat - latitude) * METERS_PER_DEGREE;
        double east = (lon - longitude) * METERS_PER_DEGREE * Math.cos(Math.toRadians(latitude));
        double distance = Math.hypot(north, east);
        if (!Double.isFinite(distance) || distance > MAX_DISTANCE_M) return null;

        JSONArray phases = junction.optJSONArray("statusInfos");
        JSONObject phase = phases != null && phases.length() == 1 ? phases.optJSONObject(0) : null;
        if (phase == null || integer(phase, "showType") != 2 || integer(phase, "mainAction") != 8) return null;
        if (integer(phase, "status") <= 0) return null;
        int seconds = integer(phase, "remainTime");
        if (seconds < 1 || seconds > 999) return null;

        try {
            return new JSONObject().put("visible", true).put("source", "amap_link")
                    .put("distance_m", Math.round(distance))
                    .put("ui_counter", new JSONObject().put("remain_sec", seconds));
        } catch (JSONException invalid) {
            return null;
        }
    }

    synchronized JSONObject filter(Map<String, Long> timestamps, long now) {
        if (signal == null || !fresh(signalElapsed, now) || !fresh(lastRoute, now) || !fresh(lastMatch, now)) {
            signal = null;
            timestamps.remove(STREAM);
            return null;
        }
        timestamps.put(STREAM, signalWall);
        return signal;
    }

    synchronized void reset() {
        lastEvent = -1;
        lastRoute = -1;
        lastMatch = -1;
        path = null;
        signal = null;
    }

    private static boolean fresh(long received, long now) {
        return received >= 0 && now >= received && now - received < FRESH_MS;
    }

    private static int integer(JSONObject data, String key) {
        Object field = data.opt(key);
        if (!(field instanceof Number)) return -1;
        double value = ((Number) field).doubleValue();
        int result = ((Number) field).intValue();
        return value == result ? result : -1;
    }

    private static double coordinate(JSONObject data, String key, int max) {
        Object field = data == null ? null : data.opt(key);
        if (!(field instanceof Number)) return Double.NaN;
        double value = ((Number) field).doubleValue();
        return Math.abs(value) <= max ? value : Double.NaN;
    }
}
