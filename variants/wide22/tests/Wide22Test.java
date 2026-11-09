package com.navipilot.obf;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

public final class Wide22Test {
    private static void check(boolean result, String message) {
        if (!result) throw new AssertionError(message);
    }

    public static void main(String[] args) throws Exception {
        WideVariant.Navigation car = WideVariant.Navigation.CAR;
        WideVariant.Navigation phone = WideVariant.Navigation.PHONE;
        WideVariant.Navigation google = WideVariant.Navigation.GOOGLE;
        check(WideVariant.Navigation.restore(null, true) == phone, "restore old phone preference");
        check(WideVariant.Navigation.restore(null, false) == car, "restore old car preference");
        check(WideVariant.Navigation.restore(google.packageName, true) == google, "restore Google selection");
        check(WideVariant.Navigation.restore("unknown", true) == phone, "fallback for unknown selection");
        check(!WideAmapSource.matches(google.packageName, google.packageName, "AMAP_NAVI_ACTION_TURN"),
                "Google sender is not a Navi v2 source");
        check(!WideAmapSource.matches(google.packageName, car.packageName, "AUTONAVI_STANDARD_BROADCAST_SEND"),
                "stop car Amap after switching");
        check(!WideAmapSource.matches(google.packageName, null, "com.autonavi.minimap.broadcast"),
                "stop anonymous phone Amap after switching");

        JSONObject sample = new JSONObject().put("road_limit_kph", 50);
        Map<String, Long> stamps = new HashMap<>();
        stamps.put("speed", Long.MAX_VALUE);
        stamps.put("route", Long.MAX_VALUE);
        MG wire = new MG();
        Field ready = WideAmapSource.class.getDeclaredField("ready");
        ready.setAccessible(true);
        WideAmapSource.select(car.packageName);
        ready.setBoolean(null, true);
        check(WideAmapSource.filter(wire, "speed", sample, stamps) == sample, "fresh car Amap");
        WideAmapSource.select(google.packageName);
        check(!ready.getBoolean(null), "switch clears ready");
        check(WideAmapSource.status().contains("僅投屏"), "Google presentation is explicit");
        ready.setBoolean(null, true);
        check(WideAmapSource.filter(wire, "speed", sample, stamps) == null, "no Amap speed during Google mode");
        check(WideAmapSource.filter(wire, "route", sample, stamps) == null, "no Amap route during Google mode");
        check(WideAmapSource.filter(wire, "app_status", sample, stamps) == sample, "app status remains available");
        WideAmapSource.select(phone.packageName);
        check(WideAmapSource.filter(wire, "speed", sample, stamps) == null, "new Amap waits for selected broadcast");
        ready.setBoolean(null, true);
        check(WideAmapSource.filter(wire, "speed", sample, stamps) == sample, "fresh phone Amap resumes");
        System.out.println("PASS: provider preference migration, Google mode stops Amap data, fresh Amap resumes");
    }
}
