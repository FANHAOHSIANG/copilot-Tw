package com.navipilot.obf;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.Arrays;
import org.json.JSONArray;
import org.json.JSONObject;

/** Decisions exercised with distinct road topology, not only nearby-circle fixtures. */
public final class EngineChecks {
    private static int checks;
    private static final long WALL = Instant.parse("2026-11-12T04:00:00Z").toEpochMilli();
    private static final double LAT = 25, LON = 121;
    private static double north(double meters) { return LAT + meters / 111320.0; }
    private static double east(double meters) { return LON + meters / (111320 * Math.cos(Math.toRadians(LAT))); }
    private static void check(boolean okay, String message) {
        checks++; if (!okay) throw new AssertionError(message);
    }
    private static JSONObject record(String id, Double bearing, String... categories) throws Exception {
        return new JSONObject().put("id", id).put("sourceId", "official-test")
                .put("region", "測試縣市").put("district", "測試區")
                .put("location", "測試路與另一條路口").put("categories", new JSONArray(Arrays.asList(categories)))
                .put("coordinates", new JSONArray().put(LON).put(north(300)))
                .put("geometryRole", "site").put("directionText", bearing == null ? "" : "南向北")
                .put("travelBearing", bearing == null ? JSONObject.NULL : bearing)
                .put("status", "announced").put("raw", new JSONObject());
    }
    private static String catalog(JSONObject... records) throws Exception {
        return new JSONObject().put("schemaVersion", 1).put("snapshotDate", "2026-11-12")
                .put("records", new JSONArray(Arrays.asList(records))).toString();
    }
    private static WideHcopRoad.Road road(String id, double x, double start, double end, String name, String grade, long a, long b) {
        WideHcopRoad.Road road = new WideHcopRoad.Road();
        road.id = id; road.names = new String[] {name}; road.grade = grade; road.dir = 0;
        road.start = a; road.end = b;
        road.xy = new double[][] {{east(x), north(start)}, {east(x), north(end)}};
        return road;
    }
    private static WideHcopRoad.Road mainRoad() { return road("main", 0, 0, 600, "測試路", "0|no|no", 1, 2); }
    private static WideHcopRoad.Data roads(WideHcopRoad.Road... roads) {
        WideHcopRoad.Data result = new WideHcopRoad.Data(); result.roads.addAll(Arrays.asList(roads)); return result;
    }
    private static WideCameraEngine.Fix fix(double station, long time) {
        return new WideCameraEngine.Fix(north(station), LON, 5, 0, 10, time, true, false);
    }
    private static WideHcopRoad.Decision decision(WideHcopRoad.Road road, WideCameraEngine.Fix fix) {
        WideHcopRoad.Decision result = new WideHcopRoad.Decision("test trace confirmed", fix.time);
        result.road = road; result.direction = 1; result.confirmed = true; return result;
    }
    private static WideEnforcementEngine.Frame approach(WideEnforcementEngine engine, WideHcopRoad.Data data,
            WideHcopRoad.Road road) {
        WideEnforcementEngine.Frame result = null;
        for (int i = 0; i < 3; i++) {
            WideCameraEngine.Fix fix = fix(180 + i * 10, 1000 + i * 1000);
            result = engine.update(fix, data, road == null ? null : decision(road, fix), fix.time, WALL);
        }
        return result;
    }
    private static void directionAndRoadProof() throws Exception {
        WideHcopRoad.Road road = mainRoad();
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog(record("north", 0.0, "red_light", "speed")));
        WideEnforcementEngine.Frame frame = approach(engine, null, null);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "GPS proximity alone remains nearby");
        check(frame.speechText.isEmpty(), "GPS circle cannot speak an ahead warning");
        engine.clear(); frame = approach(engine, roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.AHEAD && frame.primary.alongRoad,
                "confirmed named road and travel direction produce an along-road candidate");
        check(!frame.speechText.isEmpty() && frame.speechText.contains("紅燈"), "three advancing fixes offer category speech");
        check(!frame.speechText.contains("方向待確認"), "confirmed approach keeps its distinct speech wording");
        check(!frame.speechText.contains("速限") && !frame.speechText.contains("減速"), "technology speech carries no speed command");
        check(Math.abs(frame.primary.distanceMeters - 100) < 2, "distance follows road station");
        WideEnforcementEngine reverse = new WideEnforcementEngine(catalog(record("south", 180.0, "red_light")));
        frame = approach(reverse, roads(road), road);
        check(frame.primary == null && frame.speechText.isEmpty(), "opposite enforcement approach excluded");
        WideEnforcementEngine unknown = new WideEnforcementEngine(catalog(record("unknown", null, "pedestrian")));
        frame = approach(unknown, roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.DIRECTION_UNKNOWN, "unknown bearing remains visible with qualified label");
        check(frame.speechText.startsWith("前方有科技執法公告，取締方向待確認，請留意")
                        && frame.speechText.contains("停讓行人"),
                "same-road unknown direction uses an explicitly qualified announcement");
        check(!frame.primary.reason.contains("不語音"), "display reason agrees with qualified advisory policy");
        unknown.clear();
        frame = approach(unknown, null, null);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY && frame.speechText.isEmpty(),
                "unknown-direction GPS proximity still cannot speak without road proof");
        JSONObject bidirectional = record("axis", null, "red_light").put("directionText", "南北雙向");
        frame = approach(new WideEnforcementEngine(catalog(bidirectional)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.AHEAD, "explicit north/south two-way axis is usable");
        bidirectional.put("directionText", "雙向");
        frame = approach(new WideEnforcementEngine(catalog(bidirectional)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.DIRECTION_UNKNOWN, "bare bidirectional text does not identify an approach");
        check(frame.speechText.contains("取締方向待確認"), "bare bidirectional advisory never upgrades its direction claim");
    }
    private static void topologyAndGrade() throws Exception {
        JSONObject site = record("north", 0.0, "red_light");
        WideHcopRoad.Road road = mainRoad();
        WideHcopRoad.Road elevated = road("elevated", 0, 0, 600, "高架路", "1|yes|no", 3, 4);
        WideEnforcementEngine.Frame frame = approach(new WideEnforcementEngine(catalog(site)), roads(road, elevated), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY && frame.speechText.isEmpty(),
                "overlapping elevated and surface current roads cannot be distinguished by 2-D GPS");
        frame = approach(new WideEnforcementEngine(catalog(record("unknown", null, "pedestrian"))),
                roads(road, elevated), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY && frame.speechText.isEmpty(),
                "qualified unknown-direction speech does not relax layer ambiguity checks");
        WideHcopRoad.Road parallel = road("parallel", 6, 0, 600, "測試路", "0|no|no", 3, 4);
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(road, parallel), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "close parallel carriageways are ambiguous");
        WideHcopRoad.Road frontage = road("frontage", 20, 250, 600, "另一條便道", "0|no|no", 7, 8);
        JSONObject frontageSite = record("frontage-notice", null, "pedestrian")
                .put("coordinates", new JSONArray().put(east(20)).put(north(300)));
        frame = approach(new WideEnforcementEngine(catalog(frontageSite)), roads(road, frontage), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY && frame.speechText.isEmpty(),
                "notice distinctly closer to another named parallel road cannot be called same-road advisory");
        WideHcopRoad.Road shortRoad = road("first", 0, 0, 240, "測試路", "0|no|no", 1, 2);
        WideHcopRoad.Road second = road("second", 0, 240, 600, "測試路", "0|no|no", 2, 3);
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(shortRoad, second), shortRoad);
        check(frame.primary.level == WideEnforcementEngine.Level.AHEAD, "unique same-name connected continuation works without destination");
        second.start = 99;
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(shortRoad, second), shortRoad);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "disconnected geometry is not a forward road path");
        second.start = 2;
        WideHcopRoad.Road branch = road("branch", 8, 240, 600, "測試路", "0|no|no", 2, 9);
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(shortRoad, second, branch), shortRoad);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "ambiguous same-name fork is not guessed");
        site.put("location", "測試路高架道路");
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "explicit elevated notice cannot match a surface road");
        site.put("location", "測試路二段路口");
        frame = approach(new WideEnforcementEngine(catalog(site)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.NEARBY, "base road name does not silently identify another section");
    }
    private static void conditionsAndDataQuality() throws Exception {
        WideHcopRoad.Road road = mainRoad();
        JSONObject limited = record("timed", 0.0, "parking")
                .put("raw", new JSONObject().put("時段性禁停時間", "07:00-09:00（國定假日除外）"));
        WideEnforcementEngine.Frame frame = approach(new WideEnforcementEngine(catalog(limited)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.CONDITIONAL && frame.speechText.isEmpty(),
                "unresolved time and holiday restrictions cannot claim active enforcement");
        limited.put("travelBearing", JSONObject.NULL);
        frame = approach(new WideEnforcementEngine(catalog(limited)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.CONDITIONAL && frame.speechText.isEmpty(),
                "unknown direction cannot bypass unresolved schedule restrictions");
        frame = approach(new WideEnforcementEngine(catalog(record("truck", 0.0, "restricted_vehicle"))), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.CONDITIONAL, "unknown vehicle applicability is conditional");
        frame = approach(new WideEnforcementEngine(catalog(record("speed", 0.0, "speed"))), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.REFERENCE && frame.speechText.isEmpty(),
                "speed-only point stays with existing speed-alert owner");
        frame = approach(new WideEnforcementEngine(catalog(record("unknown-items", 0.0, "unspecified"))), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.REFERENCE, "unknown violation field does not invent a violation");
        JSONObject future = record("future", 0.0, "red_light").put("activationDate", "2027-01-01");
        frame = approach(new WideEnforcementEngine(catalog(future)), roads(road), road);
        check(frame.primary.level == WideEnforcementEngine.Level.REFERENCE, "future activation is not an active alert");
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog(record("expired", 0.0, "red_light")));
        WideCameraEngine.Fix fix = fix(200, 1000);
        frame = engine.update(fix, roads(road), decision(road, fix), fix.time,
                Instant.parse("2027-06-01T04:00:00Z").toEpochMilli());
        check(frame.primary.level == WideEnforcementEngine.Level.REFERENCE, "stale catalog cannot authorize speech");
        JSONObject missing = record("missing", 0.0, "red_light").put("coordinates", JSONObject.NULL);
        engine = new WideEnforcementEngine(catalog(missing));
        check(engine.locatedRecords == 0 && engine.pendingLocationRecords == 1, "unlocated official record remains counted but not positioned");
        check(approach(engine, roads(road), road).primary == null, "unlocated notice cannot become an approximate alert");
    }
    private static void freshnessAndSpeechLifecycle() throws Exception {
        WideHcopRoad.Road road = mainRoad(); WideHcopRoad.Data data = roads(road);
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog(record("site", 0.0, "red_light")));
        WideCameraEngine.Fix same = fix(180, 1000);
        for (int i = 0; i < 5; i++) {
            WideEnforcementEngine.Frame frame = engine.update(same, data, decision(road, same), 1000 + i * 200, WALL);
            check(frame.speechText.isEmpty(), "same GPS time never accumulates samples");
            check(frame.expiresElapsedMs == 4000, "same GPS time never renews expiry");
        }
        engine.clear();
        WideEnforcementEngine.Frame frame = null;
        for (int i = 0; i < 3; i++) {
            WideCameraEngine.Fix enriched = fix(180 + i * 10, 1000 + i * 1000);
            WideCameraEngine.Fix raw = new WideCameraEngine.Fix(enriched.lat, enriched.lon, 5, 0, 10,
                    enriched.time, false, false);
            engine.update(raw, null, null, raw.time, WALL);
            frame = engine.update(enriched, data, decision(road, enriched), enriched.time, WALL);
        }
        check(!frame.speechText.isEmpty(), "raw-to-road enrichment does not erase derived-heading progress");
        check(engine.snapshot(3001).speechText.isEmpty(), "UI snapshot cannot replay speech offer");
        check(engine.snapshot(6001).primary == null, "GPS older than three seconds retracts display");
        engine.spoken(frame.speechKey, 3001);
        for (int i = 0; i < 8; i++) {
            WideCameraEngine.Fix fix = fix(210 + i * 10, 4000 + i * 1000);
            frame = engine.update(fix, data, decision(road, fix), fix.time, WALL);
            check(frame.speechText.isEmpty(), "accepted speech is not repeated during same approach");
        }
        WideCameraEngine.Fix passed = fix(310, 14000);
        frame = engine.update(passed, data, decision(road, passed), passed.time, WALL);
        check(frame.primary == null, "passed point is withdrawn rather than lingering as nearby alert");
        WideCameraEngine.Fix mock = new WideCameraEngine.Fix(LAT, LON, 5, 0, 10, 20000, true, true);
        check(engine.update(mock, data, decision(road, mock), mock.time, WALL).primary == null, "mock fix cannot alert");
    }
    private static void deduplicationAndImmutability() throws Exception {
        WideHcopRoad.Road road = mainRoad();
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog(
                record("one", 0.0, "red_light"), record("two", 0.0, "pedestrian"),
                record("reverse", 180.0, "turn")));
        WideEnforcementEngine.Frame frame = approach(engine, roads(road), road);
        check(frame.nearby.size() == 1 && frame.primary.recordIds.size() == 2,
                "colocated same-approach records form one display item while preserving provenance");
        check(frame.primary.categories.contains("red_light") && frame.primary.categories.contains("pedestrian")
                && !frame.primary.categories.contains("turn"), "opposite-direction violations are never unioned into confirmed alert");
        check(frame.speechText.contains("紅燈") && frame.speechText.contains("停讓行人"), "one speech covers matching categories");
        try { frame.nearby.clear(); throw new AssertionError("mutable frame"); }
        catch (UnsupportedOperationException expected) { checks++; }
        try { frame.primary.recordIds.add("bad"); throw new AssertionError("mutable provenance"); }
        catch (UnsupportedOperationException expected) { checks++; }
        JSONObject far = record("far", 0.0, "red_light")
                .put("coordinates", new JSONArray().put(LON).put(north(400)));
        frame = approach(new WideEnforcementEngine(catalog(record("near", 0.0, "red_light"), far)), roads(road), road);
        check(frame.nearby.size() == 2, "same address with materially different coordinates stays separate");
    }
    private static void speechHasItsOwnOwner() throws Exception {
        WideHcopRoad.Road road = mainRoad(); WideHcopRoad.Data data = roads(road);
        JSONObject second = record("second", null, "pedestrian")
                .put("location", "測試路與第三條路口")
                .put("coordinates", new JSONArray().put(LON).put(north(400)));
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog(record("first", 0.0, "red_light"), second));
        WideEnforcementEngine.Frame frame = approach(engine, data, road);
        check("first".equals(frame.speechAlertId), "speech carries exact first alert owner");
        engine.spoken(frame.speechKey, 3001);
        for (int i = 1; i <= 8; i++) {
            WideCameraEngine.Fix fix = new WideCameraEngine.Fix(north(200 + 2 * i), LON, 5, 0, 20,
                    3000 + i * 1000, true, false);
            frame = engine.update(fix, data, decision(road, fix), fix.time, WALL);
        }
        check("first".equals(frame.primary.id) && "second".equals(frame.speechAlertId),
                "already-spoken primary is not mistaken for the next speech owner");
        check(frame.speechText.contains("取締方向待確認"),
                "secondary unknown-direction owner retains qualified speech despite confirmed primary");
    }
    public static void main(String[] args) throws Exception {
        directionAndRoadProof(); topologyAndGrade(); conditionsAndDataQuality();
        freshnessAndSpeechLifecycle(); deduplicationAndImmutability(); speechHasItsOwnOwner();
        if (args.length > 0) {
            WideEnforcementEngine real = new WideEnforcementEngine(Files.readString(Paths.get(args[0])));
            check(real.totalRecords == 2148, "pinned official snapshot record count");
            check(real.locatedRecords == 1152 && real.pendingLocationRecords == 996,
                    "pinned official snapshot located/pending counts");
        }
        System.out.println("EngineChecks: " + checks + " assertions passed");
    }
}
