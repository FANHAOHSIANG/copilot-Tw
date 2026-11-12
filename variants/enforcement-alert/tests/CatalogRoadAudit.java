package com.navipilot.obf;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.GZIPInputStream;
import org.json.JSONArray;
import org.json.JSONObject;

/** Uses the pinned public notices and shipped OSM tiles; no invented road lines in this audit.
 * Confirmed road identity is a synthetic input, so this measures potential eligibility, not
 * GPS tracker availability, real-world camera correctness, or on-device voice performance. */
public final class CatalogRoadAudit {
    private static final long WALL = Instant.parse("2026-11-12T04:00:00Z").toEpochMilli();
    private static Path tilesRoot;
    private static final LinkedHashMap<String, List<WideHcopRoad.Road>> cache =
            new LinkedHashMap<String, List<WideHcopRoad.Road>>(128, .75f, true);

    private static List<WideHcopRoad.Road> tile(String key) throws Exception {
        List<WideHcopRoad.Road> hit = cache.get(key);
        if (hit != null) return hit;
        List<WideHcopRoad.Road> roads = new ArrayList<WideHcopRoad.Road>();
        Path file = tilesRoot.resolve(key + ".json.gz");
        if (Files.exists(file)) {
            ByteArrayOutputStream bytes = new ByteArrayOutputStream();
            try (InputStream input = new GZIPInputStream(Files.newInputStream(file))) {
                byte[] buffer = new byte[8192]; int count;
                while ((count = input.read(buffer)) >= 0) {
                    if (bytes.size() + count > 12 * 1024 * 1024) throw new IllegalArgumentException("tile size");
                    bytes.write(buffer, 0, count);
                }
            }
            JSONArray rows = new JSONObject(bytes.toString("UTF-8")).getJSONArray("r");
            for (int i = 0; i < rows.length(); i++) {
                JSONArray row = rows.getJSONArray(i);
                WideHcopRoad.Road road = new WideHcopRoad.Road();
                road.id = row.getString(0); road.dir = row.getInt(2); road.grade = row.getString(3);
                JSONArray names = row.getJSONArray(1); road.names = new String[names.length()];
                for (int j = 0; j < names.length(); j++) road.names[j] = names.getString(j);
                JSONArray coordinates = row.getJSONArray(6); road.xy = new double[coordinates.length()][2];
                road.minLat = road.minLon = Double.POSITIVE_INFINITY;
                road.maxLat = road.maxLon = Double.NEGATIVE_INFINITY;
                for (int j = 0; j < coordinates.length(); j++) {
                    JSONArray point = coordinates.getJSONArray(j);
                    road.xy[j][0] = point.getDouble(0); road.xy[j][1] = point.getDouble(1);
                    road.minLon = Math.min(road.minLon, road.xy[j][0]); road.maxLon = Math.max(road.maxLon, road.xy[j][0]);
                    road.minLat = Math.min(road.minLat, road.xy[j][1]); road.maxLat = Math.max(road.maxLat, road.xy[j][1]);
                }
                road.bounded = true; road.start = row.getLong(7); road.end = row.getLong(8);
                roads.add(road);
            }
        }
        cache.put(key, roads);
        while (cache.size() > 96) cache.remove(cache.keySet().iterator().next());
        return roads;
    }

    private static WideHcopRoad.Data window(double lat, double lon) throws Exception {
        int x = (int) Math.floor(lon / .02), y = (int) Math.floor(lat / .02);
        WideHcopRoad.Data result = new WideHcopRoad.Data(); Set<String> seen = new HashSet<String>();
        for (int dx = -1; dx <= 1; dx++) for (int dy = -1; dy <= 1; dy++)
            for (WideHcopRoad.Road road : tile((x + dx) + "_" + (y + dy)))
                if (seen.add(road.id)) result.roads.add(road);
        return result;
    }
    private static double[] at(WideHcopRoad.Road road, double station, int direction) {
        for (int i = 1; i < road.xy.length; i++) {
            double[] a = road.xy[i - 1], b = road.xy[i];
            double length = WideCameraEngine.distance(a[1], a[0], b[1], b[0]);
            if (station <= length || i == road.xy.length - 1) {
                double part = Math.max(0, Math.min(1, station / length));
                return new double[] {a[1] + (b[1] - a[1]) * part, a[0] + (b[0] - a[0]) * part,
                        (WideCameraEngine.bearing(a[1], a[0], b[1], b[0]) + (direction < 0 ? 180 : 0)) % 360};
            }
            station -= length;
        }
        throw new IllegalArgumentException("empty geometry");
    }
    private static int rank(WideEnforcementEngine.Level level) { return level.ordinal(); }
    private static boolean named(String location, WideHcopRoad.Road road) {
        String value = location.replace('台', '臺').replaceAll("[\\s　]", "");
        for (String name : road.names) {
            String token = name.replace('台', '臺').replaceAll("[\\s　]", "");
            if (token.length() >= 2 && !token.matches("[0-9]+") && value.contains(token)) return true;
        }
        return false;
    }
    private static boolean sharedName(WideHcopRoad.Road a, WideHcopRoad.Road b) {
        for (String x : a.names) for (String y : b.names)
            if (x.length() > 1 && !x.matches("[0-9]+") && x.replace('台', '臺').equals(y.replace('台', '臺'))) return true;
        return false;
    }
    private static final class Leg {
        final WideHcopRoad.Road road; final int direction; final double available;
        Leg(WideHcopRoad.Road r, int d, double a) { road = r; direction = d; available = a; }
    }
    /** Include preceding short OSM edges so an intersection record need not sit on a long edge. */
    private static List<Leg> backward(WideHcopRoad.Data data, WideHcopRoad.Road road, int direction,
            WideRoad.Projection target) {
        List<Leg> result = new ArrayList<Leg>();
        double available = direction > 0 ? target.station : target.length - target.station;
        result.add(new Leg(road, direction, available));
        Set<String> seen = new HashSet<String>(); seen.add(road.id);
        while (available < 120 && result.size() < 16) {
            long entry = direction > 0 ? road.start : road.end;
            if (entry == 0) break;
            WideHcopRoad.Road incoming = null; int incomingDirection = 0;
            double length = WideRoad.project(road.xy, road.xy[0][1], road.xy[0][0], 0).length;
            double currentHeading = at(road, direction > 0 ? .01 : length - .01, direction)[2];
            for (WideHcopRoad.Road option : data.roads) {
                if (seen.contains(option.id) || option.xy.length < 2 || !road.grade.equals(option.grade)
                        || !sharedName(road, option)) continue;
                int d = option.end == entry && option.dir >= 0 ? 1 : option.start == entry && option.dir <= 0 ? -1 : 0;
                if (d == 0) continue;
                double optionLength = WideRoad.project(option.xy, option.xy[0][1], option.xy[0][0], 0).length;
                if (optionLength < .1 || WideRoad.delta(at(option, d > 0 ? optionLength - .01 : .01, d)[2], currentHeading) > 35) continue;
                if (incoming != null) { incoming = null; break; }
                incoming = option; incomingDirection = d;
            }
            if (incoming == null) break;
            road = incoming; direction = incomingDirection; seen.add(road.id);
            double distance = WideRoad.project(road.xy, road.xy[0][1], road.xy[0][0], 0).length;
            result.add(new Leg(road, direction, distance)); available += distance;
        }
        return result;
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 3) throw new IllegalArgumentException("catalog.json OSM-tile-directory report.json");
        String catalog = Files.readString(Paths.get(args[0]));
        JSONObject input = new JSONObject(catalog); JSONArray records = input.getJSONArray("records");
        tilesRoot = Paths.get(args[1]);
        WideEnforcementEngine engine = new WideEnforcementEngine(catalog);
        JSONArray outcomes = new JSONArray();
        Map<String, Integer> byLevel = new LinkedHashMap<String, Integer>();
        Map<String, int[]> regions = new LinkedHashMap<String, int[]>();
        Set<String> aheadGroups = new HashSet<String>(), speechGroups = new HashSet<String>();
        Set<String> confirmedSpeechGroups = new HashSet<String>(), advisorySpeechGroups = new HashSet<String>();
        int located = 0, ahead = 0, offered = 0, confirmedOffered = 0, advisoryOffered = 0, roadScenarios = 0;
        for (int index = 0; index < records.length(); index++) {
            JSONObject record = records.getJSONObject(index); JSONArray point = record.optJSONArray("coordinates");
            if (point == null || point.length() != 2) continue;
            located++;
            String id = record.getString("id"); String region = record.optString("region");
            int[] regionCounts = regions.get(region); if (regionCounts == null) { regionCounts = new int[5]; regions.put(region, regionCounts); }
            regionCounts[0]++;
            double lon = point.getDouble(0), lat = point.getDouble(1);
            WideHcopRoad.Data data = window(lat, lon);
            List<WideHcopRoad.Road> candidates = new ArrayList<WideHcopRoad.Road>();
            for (WideHcopRoad.Road road : data.roads) {
                if (road.xy.length < 2 || !named(record.optString("location"), road)
                        || lat < road.minLat - .0004 || lat > road.maxLat + .0004
                        || lon < road.minLon - .0004 || lon > road.maxLon + .0004) continue;
                if (WideRoad.project(road.xy, lat, lon, 0).offset <= 25) candidates.add(road);
            }
            Collections.sort(candidates, new Comparator<WideHcopRoad.Road>() {
                @Override public int compare(WideHcopRoad.Road a, WideHcopRoad.Road b) {
                    return Double.compare(WideRoad.project(a.xy, lat, lon, 0).offset,
                            WideRoad.project(b.xy, lat, lon, 0).offset);
                }
            });
            WideEnforcementEngine.Alert best = null;
            boolean speech = false, confirmedSpeech = false, advisorySpeech = false;
            engine.clear();
            WideCameraEngine.Fix raw = new WideCameraEngine.Fix(lat - .001, lon, 5, 0, 10, 1000, true, false);
            WideEnforcementEngine.Frame baseline = engine.update(raw, null, null, 1000, WALL);
            for (WideEnforcementEngine.Alert alert : baseline.nearby) if (alert.recordIds.contains(id)) best = alert;
            for (WideHcopRoad.Road road : candidates) {
                WideRoad.Projection target = WideRoad.project(road.xy, lat, lon, 0);
                for (int direction : new int[] {1, -1}) {
                    if ((direction > 0 && road.dir < 0) || (direction < 0 && road.dir > 0)) continue;
                    List<Leg> approach = backward(data, road, direction, target);
                    double available = 0; for (Leg leg : approach) available += leg.available;
                    double startDistance = Math.min(100, available - 5);
                    if (startDistance < 45) continue;
                    roadScenarios++;
                    engine.clear(); WideEnforcementEngine.Frame frame = null;
                    for (int sample = 0; sample < 3; sample++) {
                        double back = startDistance - sample * 10;
                        Leg selected = approach.get(0); int selectedIndex = 0;
                        while (back > selected.available && selectedIndex + 1 < approach.size()) {
                            back -= selected.available; selected = approach.get(++selectedIndex);
                        }
                        double selectedLength = WideRoad.project(selected.road.xy, selected.road.xy[0][1], selected.road.xy[0][0], 0).length;
                        double station = selectedIndex == 0 ? target.station - selected.direction * back
                                : selected.direction > 0 ? selectedLength - back : back;
                        double[] position = at(selected.road, station, selected.direction);
                        WideCameraEngine.Fix fix = new WideCameraEngine.Fix(position[0], position[1], 5,
                                position[2], 10, 1000 + sample * 1000, true, false);
                        WideHcopRoad.Decision decision = new WideHcopRoad.Decision("synthetic confirmed road", fix.time);
                        decision.confirmed = true; decision.road = selected.road; decision.direction = selected.direction;
                        frame = engine.update(fix, data, decision, fix.time, WALL);
                    }
                    for (WideEnforcementEngine.Alert alert : frame.nearby) if (alert.recordIds.contains(id)) {
                        if (best == null || rank(alert.level) < rank(best.level)) best = alert;
                        if (!frame.speechText.isEmpty() && frame.speechAlertId.equals(alert.id)) {
                            if (alert.level != WideEnforcementEngine.Level.AHEAD
                                    && alert.level != WideEnforcementEngine.Level.DIRECTION_UNKNOWN)
                                throw new AssertionError("Unqualified level offered speech: " + alert.level);
                            speech = true; speechGroups.add(alert.id);
                            if (alert.level == WideEnforcementEngine.Level.AHEAD) {
                                confirmedSpeech = true; confirmedSpeechGroups.add(alert.id);
                            } else {
                                if (!frame.speechText.startsWith("前方有科技執法公告，取締方向待確認，請留意"))
                                    throw new AssertionError("Advisory lost its uncertainty wording");
                                advisorySpeech = true; advisorySpeechGroups.add(alert.id);
                            }
                        }
                    }
                }
            }
            String level = best == null ? "NOT_EXPOSED_IN_BOUNDED_LIST" : best.level.name();
            byLevel.put(level, byLevel.containsKey(level) ? byLevel.get(level) + 1 : 1);
            if (best != null && best.level == WideEnforcementEngine.Level.AHEAD) {
                ahead++; regionCounts[1]++; aheadGroups.add(best.id);
            }
            if (speech) { offered++; regionCounts[2]++; }
            if (confirmedSpeech) { confirmedOffered++; regionCounts[3]++; }
            if (advisorySpeech) { advisoryOffered++; regionCounts[4]++; }
            outcomes.put(new JSONObject().put("id", id).put("level", level).put("speechOffered", speech)
                    .put("confirmedSpeechOffered", confirmedSpeech).put("directionUnknownAdvisorySpeechOffered", advisorySpeech)
                    .put("candidateRoads", candidates.size()).put("reason", best == null ? "" : best.reason));
            if (located % 100 == 0) System.out.println("Audited " + located + " located records");
        }
        JSONObject regionSummary = new JSONObject();
        for (Map.Entry<String, int[]> entry : regions.entrySet()) regionSummary.put(entry.getKey(),
                new JSONObject().put("located", entry.getValue()[0]).put("ahead", entry.getValue()[1]).put("speech", entry.getValue()[2])
                        .put("confirmedSpeech", entry.getValue()[3]).put("directionUnknownAdvisorySpeech", entry.getValue()[4]));
        JSONObject report = new JSONObject().put("catalogSnapshot", input.optString("snapshotDate"))
                .put("totalRecords", records.length()).put("locatedRecords", located)
                .put("pendingLocationRecords", records.length() - located).put("roadScenarios", roadScenarios)
                .put("aheadRecords", ahead).put("speechOfferedRecords", offered)
                .put("confirmedSpeechRecords", confirmedOffered).put("directionUnknownAdvisorySpeechRecords", advisoryOffered)
                .put("confirmedSpeechGroups", confirmedSpeechGroups.size()).put("directionUnknownAdvisorySpeechGroups", advisorySpeechGroups.size())
                .put("aheadDisplayGroups", aheadGroups.size()).put("speechGroups", speechGroups.size())
                .put("byLevel", new JSONObject(byLevel)).put("regions", regionSummary).put("outcomes", outcomes)
                .put("method", "Three synthetic advancing fixes on shipped OSM geometry, including unique connected preceding edges; supplied confirmed current-road identity; no route destination")
                .put("limitations", "Potential data/matcher eligibility only; not real GPS acquisition, real camera verification, Android TTS, or vehicle testing")
                .put("realDeviceVerified", false);
        Files.writeString(Paths.get(args[2]), report.toString(2) + "\n", StandardCharsets.UTF_8);
        System.out.println(new JSONObject().put("located", located).put("ahead", ahead).put("speech", offered)
                .put("confirmedSpeech", confirmedOffered).put("directionUnknownAdvisorySpeech", advisoryOffered)
                .put("aheadGroups", aheadGroups.size()).put("speechGroups", speechGroups.size()).put("byLevel", new JSONObject(byLevel)));
    }
}
