package com.navipilot.obf;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public final class Wide19Test {
    private static void check(boolean ok, String message) {
        if (!ok) throw new AssertionError(message);
    }

    public static void main(String[] args) throws Exception {
        String car = "com.autonavi.amapauto";
        String phone = "com.autonavi.minimap";
        String shared = "AMAP_NAVI_ACTION_TURN";
        check(WideAmapSource.matches(car, car, shared), "identified car");
        check(WideAmapSource.matches(phone, phone, shared), "identified phone");
        check(!WideAmapSource.matches(car, phone, shared), "exclude other sender");
        check(!WideAmapSource.matches(phone, car, "com.autonavi.minimap.broadcast"), "sender overrides action");
        check(!WideAmapSource.matches(car, null, shared), "ambiguous car action");
        check(!WideAmapSource.matches(phone, null, shared), "ambiguous phone action");
        check(WideAmapSource.matches(car, null, "AUTONAVI_STANDARD_BROADCAST_SEND"), "car legacy action");
        check(WideAmapSource.matches(phone, null, "com.autonavi.minimap.broadcast"), "phone legacy action");

        JSONObject speed = new JSONObject().put("road_limit_kph", 50);
        Map<String, Long> stamps = new HashMap<>();
        MG wire = new MG();
        WideAmapSource.select(car);
        Field since = WideAmapSource.class.getDeclaredField("selectedSince");
        since.setAccessible(true);
        long selectedAt = since.getLong(null);
        stamps.put("speed", selectedAt + 1);
        check(WideAmapSource.filter(wire, "speed", speed, stamps) == null, "wait for new producer");
        Field ready = WideAmapSource.class.getDeclaredField("ready");
        ready.setAccessible(true);
        ready.setBoolean(null, true);
        check(WideAmapSource.filter(wire, "speed", speed, stamps) == speed, "fresh selected speed");
        stamps.put("speed", selectedAt - 1);
        check(WideAmapSource.filter(wire, "speed", speed, stamps) == null, "old speed blocked");
        check(WideAmapSource.filter(wire, "route", speed, stamps) == null, "missing route blocked");
        WideAmapSource.select(phone);
        stamps.put("speed", Long.MAX_VALUE);
        check(WideAmapSource.filter(wire, "speed", speed, stamps) == null, "new selection requires new packet");
        check(WideAmapSource.filter(wire, "app_status", speed, stamps) == speed, "keep handshake status");

        WideCameraFace.Model camera = new WideCameraFace.Model();
        camera.type = 1;
        camera.distance = 500.1;
        camera.roadMatched = true;
        check(WideCameraFace.warningStrength(camera) == 0, "outside 500 m");
        camera.distance = 500;
        check(WideCameraFace.warningStrength(camera) > 0, "warning visible at 500 m");
        double far = WideCameraFace.flashPeriodMs(camera);
        camera.distance = 80;
        check(WideCameraFace.flashPeriodMs(camera) < far, "approach flashes faster");
        camera.roadMatched = false;
        check(WideCameraFace.warningStrength(camera) == 0, "unclassified excluded");
        camera.previewOnly = true;
        check(WideCameraFace.warningStrength(camera) > 0, "explicit nearby visual candidate");

        System.out.println("PASS: source selection, absent and stale fields, 500 m pulse, and visual candidates");
    }
}
