package com.navipilot.obf;

import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;
import org.json.JSONArray;
import org.json.JSONObject;

public final class LinkSignalTest {
    private static final long WALL = 1_795_000_000_000L;

    private static JSONObject route(int id) throws Exception {
        return new JSONObject().put("pathID", id).put("matchPosLat", 24.5).put("matchPosLon", 121.0);
    }

    private static JSONObject signal(int phase, int seconds, int showType, double latitude) throws Exception {
        JSONObject position = new JSONObject().put("lat", latitude).put("lon", 121.0);
        JSONObject status = new JSONObject().put("status", phase).put("remainTime", seconds)
                .put("showType", showType).put("mainAction", 8);
        JSONObject junction = new JSONObject().put("pos", position).put("remainDis", 17000)
                .put("statusInfos", new JSONArray().put(status));
        return new JSONObject().put("eventType", 26035).put("commonInfos", new JSONArray().put(junction));
    }

    private static void check(boolean condition, String description) {
        if (!condition) throw new AssertionError(description);
    }

    private static void replay(Path packets) throws Exception {
        WideAmapLinkSignal input = new WideAmapLinkSignal();
        Map<String, Long> timestamps = new HashMap<>();
        int received = 0;
        int sent = 0;
        int clears = 0;
        int clearedActive = 0;
        int cameraPackets = 0;
        JSONObject firstSent = null;
        try (Stream<String> lines = Files.lines(packets)) {
            for (String line : (Iterable<String>) lines::iterator) {
                JSONObject packet = new JSONObject(line);
                long now = packet.getLong("received_mono_ms");
                JSONArray messages = packet.getJSONArray("datas");
                for (int index = 0; index < messages.length(); index++) {
                    JSONObject event = messages.getJSONObject(index);
                    int type = event.getInt("type");
                    JSONObject before = input.filter(timestamps, now);
                    input.accept(type, event.optJSONObject("data"), now, WALL + now);
                    JSONObject value = input.filter(timestamps, now);
                    if (type == 12) {
                        received++;
                        if (value != null) {
                            sent++;
                            if (firstSent == null) firstSent = value;
                            check(!value.has("lights"), "Replay must never infer a lamp color");
                        }
                    } else if (type == 13) {
                        clears++;
                        if (before != null) clearedActive++;
                        check(value == null, "Type 13 must withdraw the countdown");
                    } else if (type == 28) {
                        cameraPackets++;
                    }
                }
            }
        }
        check(sent > 0 && clears > 0, "Replay should contain eligible countdowns and clear events");
        System.out.println(new JSONObject().put("updates", received).put("sent", sent).put("clears", clears)
                .put("cleared_active", clearedActive).put("section_camera_packets", cameraPackets)
                .put("traffic_signal", firstSent));
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 1) {
            replay(Path.of(args[0]));
            return;
        }
        WideAmapLinkSignal input = new WideAmapLinkSignal();
        Map<String, Long> timestamps = new HashMap<>();
        JSONObject matched = new JSONObject().put("isMatchNaviPath", true);
        JSONObject active = signal(4, 31, 2, 24.5007);
        input.accept(12, active, 999, WALL);
        check(input.filter(timestamps, 999) == null, "Requires a current route and match");
        input.accept(4, route(7), 1000, WALL + 1);
        input.accept(16, matched, 1000, WALL + 1);
        check(input.accept(12, active, 1001, WALL + 2), "New countdown requests immediate send");
        JSONObject value = input.filter(timestamps, 1002);
        check(value != null && value.getBoolean("visible"), "Countdown is available");
        check("amap_link".equals(value.getString("source")), "Phone source retained");
        check(value.getJSONObject("ui_counter").getInt("remain_sec") == 31, "Seconds preserved");
        check(value.getLong("distance_m") == 78, "Uses matched position instead of route remaining distance");
        check(!value.has("lights") && !value.has("point"), "No inferred colors or mislabeled coordinates");
        check(timestamps.get("traffic_signal") == WALL + 2, "Retains input timestamp");
        check(!input.accept(13, null, 1000, WALL + 2), "Out-of-order update ignored");
        check(input.filter(timestamps, 1003) != null, "Late clear leaves newer countdown visible");
        input.accept(28, new JSONObject().put("maxSpeed", 90), 1002, WALL + 3);
        check(input.filter(timestamps, 1004) != null, "Section camera packets are separate");
        check(input.accept(13, null, 1004, WALL + 5), "Withdraw on type 13");
        check(input.filter(timestamps, 1004) == null && timestamps.isEmpty(), "Withdraw timestamp and display");
        input.accept(12, signal(2, 15, 0, 24.5002), 1005, WALL + 6);
        check(input.filter(timestamps, 1005) == null, "Ignore non-display phase");
        input.accept(12, signal(2, 15, 2, 24.504), 1006, WALL + 7);
        check(input.filter(timestamps, 1006) == null, "Ignore distant junction");
        input.accept(12, signal(2, 0, 2, 24.5002), 1007, WALL + 8);
        check(input.filter(timestamps, 1007) == null, "Ignore zero seconds");
        input.accept(12, active, 1008, WALL + 9);
        check(input.accept(16, new JSONObject().put("isMatchNaviPath", false), 1009, WALL + 10), "Clear off-route");
        check(input.filter(timestamps, 1009) == null, "Route departure clears display");
        input.accept(16, matched, 1010, WALL + 11);
        input.accept(12, active, 1010, WALL + 11);
        input.accept(4, route(8), 1011, WALL + 12);
        check(input.filter(timestamps, 1011) == null, "Route change drops previous countdown");
        input.accept(16, matched, 1011, WALL + 12);
        input.accept(12, active, 1011, WALL + 12);
        check(input.filter(timestamps, 3510) != null, "Shown within freshness window");
        check(input.filter(timestamps, 3511) == null, "Clear at 2.5 seconds");
        input.accept(4, route(8), 3512, WALL + 13);
        input.accept(16, matched, 3512, WALL + 13);
        input.accept(12, active, 3512, WALL + 13);
        input.reset();
        check(input.filter(timestamps, 3512) == null, "Disconnect drops previous countdown");
        System.out.println(new JSONObject().put("traffic_signal", value));
    }
}
