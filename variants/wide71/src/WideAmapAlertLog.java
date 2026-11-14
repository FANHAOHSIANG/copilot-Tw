package com.navipilot.obf;

import android.content.Intent;
import org.json.JSONException;
import org.json.JSONObject;

/** Correlates the existing Auto camera and signal inputs with the C4 socket queue. */
final class WideAmapAlertLog {
    static void autoInput(Intent intent, int type) {
        if (!WideBridgeLog.recording()) return;
        try {
            JSONObject event = new JSONObject().put("type", type);
            switch (type) {
                case 60073:
                    event.put("status", intent.getIntExtra("trafficLightStatus", -1));
                    event.put("direction", intent.getIntExtra("dir", -1));
                    event.put("red_seconds", intent.getIntExtra("redLightCountDownSeconds", -1));
                    event.put("green_seconds", intent.getIntExtra("greenLightLastSecond", -1));
                    break;
                case 10001:
                    if (!intent.hasExtra("CAMERA_DIST")) return;
                    camera(event, intent, "CAMERA_DIST", "CAMERA_SPEED");
                    break;
                case 13005:
                    camera(event, intent, "CAMERA_DISTANCE", "CAMERA_SPEED_LIMIT");
                    break;
                default:
                    return;
            }
            WideBridgeLog.event("amap_auto_alert_input", event);
        } catch (JSONException | RuntimeException malformed) {
            // Diagnostics cannot interrupt the existing parser.
        }
    }

    private static void camera(JSONObject event, Intent intent, String distance, String speed) throws JSONException {
        event.put("camera_type", intent.getIntExtra("CAMERA_TYPE", -1));
        event.put("distance_m", intent.getIntExtra(distance, -1));
        event.put("camera_limit_kph", intent.getIntExtra(speed, -1));
    }

    static void queued(String stream, String envelope, boolean accepted) {
        if (!"json:traffic_signal".equals(stream) || !WideBridgeLog.recording()) return;
        try {
            WideBridgeLog.event("traffic_signal_wire", new JSONObject()
                    .put("acceptedBySocketQueue", accepted).put("envelope", new JSONObject(envelope)));
        } catch (JSONException malformed) {
            // Existing diagnostic and sender paths continue.
        }
    }
}
