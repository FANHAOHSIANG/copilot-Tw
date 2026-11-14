package com.navipilot.obf;
import java.util.HashMap;
import org.json.JSONObject;

@SuppressWarnings("unchecked")
class RoadOutputChecks {
    static int checks;
    static void check(boolean ok, String name) {
        if (!ok) throw new AssertionError(name);
        checks++;
    }
    static final double LAT = 24.80, LON = 121.01;
    static WideHcopRoad$Data data() {
        var data = new WideHcopRoad$Data();
        var road = new WideHcopRoad$Road();
        road.id = "main"; road.grade = "0"; road.dir = 0; road.forward = 80; road.backward = 90;
        road.names = new String[]{"台68"}; road.start = 1; road.end = 2;
        road.xy = new double[][]{{LON - .005,LAT},{LON + .005,LAT}};
        data.roads.add(road);
        return data;
    }
    static WideHcopRoad$Official sign(int kmh) {
        var sign = new WideHcopRoad$Official();
        sign.names = new String[]{"台68"};
        sign.limit = kmh; sign.source = "TDX";
        sign.xy = new double[][]{{LON - .004,LAT},{LON + .004,LAT}};
        return sign;
    }
    static WideHcopRoad$Decision match(WideHcopRoad$Data data, int bearing, boolean mock) {
        var t = new WideHcopRoad$Tracker();
        WideHcopRoad$Decision result = null;
        for (int i = 0; i < 3; i++) {
            long time = 4900 + i * 1000;
            result = t.accept(data, new WideCameraEngine$Fix(
                    LAT, LON + (bearing == 90 ? 1 : -1) * i * .0001, 5, bearing, 11, time, true, mock), time);
        }
        return result;
    }
    static int send(WideHcopRoad$Decision d) {
        WideHcop.decision = d;
        var time = new HashMap<String, Long>();
        var old = new JSONObject().put("road_limit_kph", 120).put("sdi_speed_kph", 50);
        var out = WideOsmLimit.filter("speed", old, time);
        check(out.optInt("sdi_speed_kph") == 50, "camera field independent");
        check(old.optInt("road_limit_kph") == 120, "input unmodified");
        if (out.has("road_limit_kph")) check(time.containsKey("speed"), "fix timestamp");
        return out.optInt("road_limit_kph", 0);
    }
    public static void main(String[] args) {
        WideOsmLocation.send = true;
        var data = data();
        var osm = match(data, 90, false);
        check(osm.confirmed && send(osm) == 80, "OSM fallback");
        check(send(match(data, 270, false)) == 90, "directional OSM fallback");
        var camera = new WideHcopRoad$Camera();
        camera.edge = "main";
        camera.id = "a";
        camera.road = "台68";
        camera.lat = LAT;
        camera.lon = LON + .0015;
        camera.dirs = new int[]{1};
        camera.limit = 60;
        data.cameras.add(camera);
        data.signs.add(sign(70));
        var tdx = match(data, 90, false);
        check(tdx.confirmed && tdx.camera != null, "keep independent camera discovery");
        check(send(tdx) == 70, "TDX 70 preferred without camera override");
        check(WideOsmLimit.status().contains("TDX 70"), "TDX diagnosis");
        check(send(match(data,270,false)) == 90, "wrong TDX direction retains OSM");
        check(send(match(data,90,true)) == 0, "mock fix");
        data.signs.add(sign(100));
        check(send(match(data,90,false)) == 0, "TDX conflict withdraws value");
        data.signs.clear();
        data.signs.add(sign(75));
        check(send(match(data,90,false)) == 0, "unsupported limit not rounded");
        data.signs.clear();
        var near = (WideHcopRoad$Road) data().roads.getFirst();
        near.id="ramp";near.grade="1";
        near.xy = new double[][]{{LON-.005,LAT+.00003},{LON+.005,LAT+.00003}};
        data.roads.add(near);
        check(send(match(data,90,false)) == 0, "ambiguous road");
        WideOsmLocation.send = false;
        check(send(tdx) == 0, "switch off");
        check(WideOsmLimit.filter("route", null, new HashMap<>()) == null, "route untouched");
        System.out.println(checks + " APK road-limit checks");
    }
}
