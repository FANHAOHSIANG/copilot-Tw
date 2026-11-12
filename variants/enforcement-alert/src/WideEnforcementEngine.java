package com.navipilot.obf;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/** Offline, advisory-only enforcement decisions. Never supplies speed limits or control data.
 * Android owners supply the existing road window and its confirmed current-road decision.
 * A destination, a paid API, and a network connection are not required. */
public final class WideEnforcementEngine {
    public enum Level { AHEAD, DIRECTION_UNKNOWN, CONDITIONAL, NEARBY, REFERENCE }
    public static final long FRESH_MS = 3000;
    public static final double SEARCH_METERS = 2000;
    private static final long OFFER_INTERVAL_MS = 8000;
    private static final long REARM_MS = 120000;
    private static final double REARM_METERS = 600;
    private static final ZoneId TAIPEI = ZoneId.of("Asia/Taipei");
    private static final Set<String> NON_SPEED = new HashSet<String>(Arrays.asList(
            "red_light", "pedestrian", "lane_signal", "turn", "parking",
            "restricted_vehicle", "following_distance", "wrong_way", "weighing"));
    private static final Pattern TIME_CONDITION = Pattern.compile(
            "時段|例假|平日|假日|星期|週[一二三四五六日]|[0-9]{1,2}[：:][0-9]{2}|上課期間");

    public static final class Alert {
        public final String id, location, reason, directionText;
        public final Level level;
        public final List<String> categories, recordIds;
        public final double distanceMeters;
        public final boolean alongRoad;
        public final long expiresElapsedMs;
        private final Group group;
        private Alert(Group group, Record record, Level level, double distance, boolean along,
                String reason, List<String> categories, List<String> ids, long expiry) {
            this.group = group;
            this.id = group.id;
            this.location = record.location;
            this.directionText = record.directionText;
            this.level = level;
            this.distanceMeters = distance;
            this.alongRoad = along;
            this.reason = reason;
            this.categories = Collections.unmodifiableList(new ArrayList<String>(categories));
            this.recordIds = Collections.unmodifiableList(new ArrayList<String>(ids));
            this.expiresElapsedMs = expiry;
        }
    }

    public static final class Frame {
        public final Alert primary;
        public final List<Alert> nearby;
        public final String speechAlertId, speechKey, speechText, status;
        public final long fixElapsedMs, expiresElapsedMs;
        private Frame(List<Alert> alerts, String speechAlertId, String key, String speech, String status, long fixTime, long expiry) {
            this.nearby = Collections.unmodifiableList(new ArrayList<Alert>(alerts));
            this.primary = alerts.isEmpty() ? null : alerts.get(0);
            this.speechAlertId = speechAlertId;
            this.speechKey = key;
            this.speechText = speech;
            this.status = status;
            this.fixElapsedMs = fixTime;
            this.expiresElapsedMs = expiry;
        }
    }

    public final int totalRecords, locatedRecords, pendingLocationRecords;
    private final Map<String, List<Group>> tiles = new HashMap<String, List<Group>>();
    private final Map<String, Track> tracks = new HashMap<String, Track>();
    private final List<Spoken> spoken = new ArrayList<Spoken>();
    private final LocalDate snapshotDate;
    private WideCameraEngine.Fix previousFix;
    private long lastOffer = Long.MIN_VALUE;
    private Alert pendingSpeech;
    private long pendingUntil;
    private Frame latest = empty("等待定位", 0);

    public WideEnforcementEngine(String catalogJson) throws JSONException {
        JSONObject root = new JSONObject(catalogJson);
        if (root.getInt("schemaVersion") != 1) throw new JSONException("Unsupported enforcement schema");
        snapshotDate = date(root.optString("snapshotDate", ""));
        JSONArray input = root.getJSONArray("records");
        if (input.length() > 20000) throw new JSONException("Enforcement record limit exceeded");
        totalRecords = input.length();
        Set<String> historical = new HashSet<String>();
        JSONArray sources = root.optJSONArray("sources");
        if (sources != null) for (int i = 0; i < sources.length(); i++) {
            JSONObject source = sources.optJSONObject(i);
            if (source != null && source.optString("title").contains("歷史快照"))
                historical.add(source.optString("id"));
        }
        Map<String, List<Group>> addresses = new LinkedHashMap<String, List<Group>>();
        int located = 0;
        for (int i = 0; i < input.length(); i++) {
            JSONObject source = input.optJSONObject(i);
            if (source == null) continue;
            JSONArray point = source.optJSONArray("coordinates");
            if (point == null || point.length() != 2) continue;
            double lon = point.optDouble(0, Double.NaN), lat = point.optDouble(1, Double.NaN);
            if (!coordinate(lat, lon)) continue;
            located++;
            Record record = new Record(source, lat, lon, historical);
            if (record.id.isEmpty() || record.location.isEmpty()) continue;
            List<Group> bucket = addresses.get(record.address);
            if (bucket == null) { bucket = new ArrayList<Group>(); addresses.put(record.address, bucket); }
            Group group = null;
            // Address text alone is not equipment identity. Merge only colocated display candidates.
            for (Group prior : bucket) if (distance(lat, lon, prior.lat, prior.lon) <= 12) {
                group = prior; break;
            }
            if (group == null) { group = new Group(record); bucket.add(group); }
            group.records.add(record);
        }
        locatedRecords = located;
        pendingLocationRecords = totalRecords - locatedRecords;
        for (List<Group> groups : addresses.values()) for (Group group : groups) {
            String tile = tile(group.lon, group.lat);
            List<Group> bucket = tiles.get(tile);
            if (bucket == null) { bucket = new ArrayList<Group>(); tiles.put(tile, bucket); }
            bucket.add(group);
        }
    }

    /** A raw fix and later road enrichment may share one timestamp: neither renews that fix. */
    public synchronized Frame update(WideCameraEngine.Fix fix, WideHcopRoad.Data roads,
            WideHcopRoad.Decision currentRoad, long nowElapsedMs, long nowWallMs) {
        String invalid = invalidPosition(fix, nowElapsedMs);
        if (invalid != null) {
            tracks.clear();
            pendingSpeech = null;
            latest = empty(invalid, fix == null ? 0 : fix.time);
            return latest;
        }
        boolean newFix = previousFix == null || fix.time != previousFix.time;
        if (previousFix != null) {
            long dt = fix.time - previousFix.time;
            double moved = distance(fix.lat, fix.lon, previousFix.lat, previousFix.lon);
            if (dt < 0 || (dt == 0 && moved > .1)) {
                tracks.clear(); pendingSpeech = null; previousFix = fix;
                return latest = empty("定位時間不連續，重新確認", fix.time);
            }
            if (dt > 10000) tracks.clear();
            else if (dt > 0 && moved > Math.max(35, Math.max(safeSpeed(fix), safeSpeed(previousFix))
                    * dt / 1000.0 + fix.accuracy + previousFix.accuracy + 10)) {
                tracks.clear(); pendingSpeech = null; previousFix = fix;
                return latest = empty("定位跳點，重新確認", fix.time);
            }
        }
        previousFix = fix;
        LocalDate today;
        try { today = Instant.ofEpochMilli(nowWallMs).atZone(TAIPEI).toLocalDate(); }
        catch (RuntimeException invalidClock) { return latest = empty("日期無法確認", fix.time); }
        boolean expiredCatalog = snapshotDate == null || today.isBefore(snapshotDate)
                || today.isAfter(snapshotDate.plusDays(180));
        List<PathPart> path = buildPath(roads, currentRoad, fix, nowElapsedMs);
        List<Group> groups = query(fix.lat, fix.lon);
        List<Alert> alerts = new ArrayList<Alert>();
        Set<String> seen = new HashSet<String>();
        for (Group group : groups) {
            double radial = distance(fix.lat, fix.lon, group.lat, group.lon);
            if (radial > SEARCH_METERS) continue;
            seen.add(group.id);
            Track track = track(group, fix, radial);
            if (track.passed) continue;
            List<Assessment> evaluations = new ArrayList<Assessment>();
            for (Record record : group.records) {
                Assessment evaluation = assess(record, roads, path, fix, radial, today, expiredCatalog);
                if (evaluation != null) evaluations.add(evaluation);
            }
            if (evaluations.isEmpty()) continue;
            Collections.sort(evaluations, new Comparator<Assessment>() {
                @Override public int compare(Assessment a, Assessment b) {
                    int order = Integer.compare(a.level.ordinal(), b.level.ordinal());
                    return order != 0 ? order : Double.compare(a.distance, b.distance);
                }
            });
            Assessment chosen = evaluations.get(0);
            if (chosen.along && chosen.distance <= 12) {
                if (track.wasAhead) { track.passed = true; track.passedAt = fix.time; }
                continue;
            }
            if (chosen.along && chosen.distance > 12) track.wasAhead = true;
            List<String> categories = new ArrayList<String>(), ids = new ArrayList<String>();
            for (Assessment item : evaluations) {
                // Never promote uncertain/opposite-direction rows by merging them into a confirmed row.
                if (item.level != chosen.level || item.along != chosen.along) continue;
                ids.add(item.record.id);
                for (String category : item.record.categories) if (!categories.contains(category)) categories.add(category);
            }
            alerts.add(new Alert(group, chosen.record, chosen.level, chosen.distance, chosen.along,
                    chosen.reason, categories, ids, fix.time + FRESH_MS));
        }
        for (Iterator<Map.Entry<String, Track>> it = tracks.entrySet().iterator(); it.hasNext();) {
            Track track = it.next().getValue();
            double away = distance(fix.lat, fix.lon, track.group.lat, track.group.lon);
            if (!seen.contains(track.group.id) && away > SEARCH_METERS) it.remove();
        }
        for (Iterator<Spoken> it = spoken.iterator(); it.hasNext();) {
            Spoken item = it.next();
            if (nowElapsedMs - item.time >= REARM_MS
                    && distance(fix.lat, fix.lon, item.lat, item.lon) > REARM_METERS) it.remove();
        }
        Collections.sort(alerts, new Comparator<Alert>() {
            @Override public int compare(Alert a, Alert b) {
                int priority = Integer.compare(a.level.ordinal(), b.level.ordinal());
                return priority != 0 ? priority : Double.compare(a.distanceMeters, b.distanceMeters);
            }
        });
        if (alerts.size() > 12) alerts = new ArrayList<Alert>(alerts.subList(0, 12));
        String speechAlertId = "", speechKey = "", speechText = "";
        if (pendingSpeech != null && nowElapsedMs > pendingUntil) pendingSpeech = null;
        // Enrichment of a raw sample can offer once; repeated UI ticks cannot consume or renew samples.
        if ((newFix || (roads != null && pendingSpeech == null))
                && (lastOffer == Long.MIN_VALUE || nowElapsedMs - lastOffer >= OFFER_INTERVAL_MS)) {
            for (Alert alert : alerts) {
                Track track = tracks.get(alert.id);
                double speakRange = Math.min(400, Math.max(120, safeSpeed(fix) * 12));
                if ((alert.level != Level.AHEAD && alert.level != Level.DIRECTION_UNKNOWN)
                        || alert.distanceMeters > speakRange || track == null
                        || !track.approaching(fix) || alreadySpoken(alert)) continue;
                pendingSpeech = alert;
                pendingUntil = fix.time + FRESH_MS;
                lastOffer = nowElapsedMs;
                speechKey = alert.id + ":" + fix.time;
                speechAlertId = alert.id;
                track.pendingKey = speechKey;
                speechText = speech(alert);
                break;
            }
        }
        String status = expiredCatalog ? "科技執法公告快照已超出提醒期限，僅供參考"
                : alerts.isEmpty() ? "附近沒有可用科技執法提醒"
                : path.isEmpty() ? "鄰近科技執法／道路待確認" : "科技執法提醒依道路與行向判定";
        return latest = new Frame(alerts, speechAlertId, speechKey, speechText, status, fix.time, fix.time + FRESH_MS);
    }

    /** Acknowledge only after the speech system accepted this exact offer. */
    public synchronized void spoken(String speechKey, long nowElapsedMs) {
        if (pendingSpeech == null || nowElapsedMs > pendingUntil || nowElapsedMs < 0) return;
        Track track = tracks.get(pendingSpeech.id);
        if (track == null || !track.pendingKey.equals(speechKey)) return;
        spoken.add(new Spoken(pendingSpeech.group, nowElapsedMs));
        if (spoken.size() > 128) spoken.remove(0);
        pendingSpeech = null;
    }

    public synchronized void clear() {
        tracks.clear(); spoken.clear(); previousFix = null; pendingSpeech = null;
        lastOffer = Long.MIN_VALUE; latest = empty("等待定位", 0);
    }

    /** A read never advances the GPS clock or creates a new speech offer. */
    public synchronized Frame snapshot(long nowElapsedMs) {
        if (nowElapsedMs < latest.fixElapsedMs || nowElapsedMs > latest.expiresElapsedMs)
            return empty("定位已過期，科技執法提醒已撤回", latest.fixElapsedMs);
        return new Frame(latest.nearby, "", "", "", latest.status, latest.fixElapsedMs, latest.expiresElapsedMs);
    }

    private boolean alreadySpoken(Alert alert) {
        for (Spoken item : spoken) if (item.id.equals(alert.id)
                || (item.address.equals(alert.group.address)
                && distance(item.lat, item.lon, alert.group.lat, alert.group.lon) <= 80)) return true;
        return false;
    }

    private Track track(Group group, WideCameraEngine.Fix fix, double distance) {
        Track track = tracks.get(group.id);
        if (track == null) { track = new Track(group); tracks.put(group.id, track); }
        if (track.passed && distance > REARM_METERS && fix.time - track.passedAt > REARM_MS) {
            track = new Track(group); tracks.put(group.id, track);
        }
        if (track.sampleTime == fix.time) return track;
        track.lastTime = fix.time;
        if (!track.passed && track.wasAhead && track.minimum < 30 && distance > track.minimum + 15) {
            track.passed = true; track.passedAt = fix.time;
        }
        track.minimum = Math.min(track.minimum, distance);
        // Raw GPS may lack a bearing that the existing trace derives later for this same fix.
        // Such a raw callback must neither consume a sample nor reset the enriched trace.
        if (!moving(fix)) return track;
        if (track.sampleTime == 0 || fix.time - track.sampleTime > 3500
                || distance > track.lastDistance + Math.max(10, fix.accuracy)) {
            track.count = 0; track.startTime = fix.time; track.startDistance = distance;
        }
        track.sampleTime = fix.time;
        track.lastDistance = distance;
        if (moving(fix)) track.count++;
        return track;
    }

    private Assessment assess(Record record, WideHcopRoad.Data roads, List<PathPart> path,
            WideCameraEngine.Fix fix, double radial, LocalDate today, boolean expiredCatalog) {
        Assessment a = new Assessment(record, radial);
        if (expiredCatalog || record.historical || !record.site || !record.hasNonSpeed
                || record.planned || (record.activation != null && today.isBefore(record.activation))) {
            a.level = Level.REFERENCE;
            a.reason = expiredCatalog ? "公告快照需更新" : record.historical ? "歷史公告，現況待核對"
                    : !record.site ? "區間參考點，不能當作起訖點" : !record.hasNonSpeed
                    ? "速度／項目未明記錄，維持既有測速提醒" : "尚未啟用的公告";
            return a;
        }
        SiteMatch best = null;
        for (PathPart part : path) {
            if (!roadName(record.location, part.road.names)) continue;
            if (!levelCompatible(record.location, part.road.grade)) continue;
            WideRoad.Projection p = WideRoad.project(part.road.xy, record.lat, record.lon, 8);
            if (p.ambiguous || p.offset > 25) continue;
            double ahead = part.startDistance + (part.direction > 0 ? p.station : p.length - p.station);
            if (ahead < -80 || ahead > SEARCH_METERS) continue;
            double heading = (p.heading + (part.direction < 0 ? 180 : 0)) % 360;
            SiteMatch candidate = new SiteMatch(part.road, p, ahead, heading);
            if (siteAmbiguous(record, roads, candidate)) continue;
            if (best == null || p.offset < best.projection.offset) best = candidate;
        }
        if (best == null) return a;
        a.along = true;
        a.distance = best.ahead;
        if (record.bearings.length > 0) {
            boolean compatible = false;
            for (double bearing : record.bearings)
                if (WideRoad.delta(bearing, best.heading) <= 35) compatible = true;
            if (!compatible) return null; // An explicitly opposite approach is not a candidate.
        }
        if (record.conditional) {
            a.level = Level.CONDITIONAL;
            a.reason = "同路前方；時段或適用車種尚未確認";
        } else if (record.bearings.length == 0) {
            a.level = Level.DIRECTION_UNKNOWN;
            a.reason = "同路前方；取締方向待確認，僅作公告提醒";
        } else {
            a.level = Level.AHEAD;
            a.reason = "同名連通道路、分層與公告行向符合";
        }
        return a;
    }

    private static List<PathPart> buildPath(WideHcopRoad.Data data, WideHcopRoad.Decision decision,
            WideCameraEngine.Fix fix, long now) {
        List<PathPart> path = new ArrayList<PathPart>();
        if (data == null || data.expired || decision == null || !decision.confirmed || decision.road == null
                || decision.time != fix.time || !moving(fix) || fix.accuracy > 15
                || (decision.direction != 1 && decision.direction != -1)) return path;
        WideHcopRoad.Road current = decision.road;
        if (!validRoad(current) || !permits(current, decision.direction)) return path;
        WideRoad.Projection start = WideRoad.project(current.xy, fix.lat, fix.lon, Math.max(6, fix.accuracy));
        double heading = (start.heading + (decision.direction < 0 ? 180 : 0)) % 360;
        if (start.ambiguous || start.offset > Math.max(8, Math.min(15, fix.accuracy + 3))
                || WideRoad.delta(fix.heading, heading) > 30) return path;
        Map<Long, List<WideHcopRoad.Road>> nodes = new HashMap<Long, List<WideHcopRoad.Road>>();
        boolean present = false;
        for (WideHcopRoad.Road road : data.roads) {
            if (!validRoad(road)) continue;
            if (road.id.equals(current.id)) present = true;
            add(nodes, road.start, road); add(nodes, road.end, road);
            if (road.id.equals(current.id) || far(road, fix.lat, fix.lon, .001)) continue;
            WideRoad.Projection alternative = WideRoad.project(road.xy, fix.lat, fix.lon, 0);
            if (alternative.offset > start.offset + Math.max(6, fix.accuracy)) continue;
            if (!sameGrade(current, road)) return path;
            boolean joined = joined(current, road) && sameName(current, road);
            if (!joined && (parallel(start.heading, alternative.heading) < 30
                    || alternative.offset < Math.max(4, fix.accuracy))) return path;
        }
        if (!present) return path;
        int direction = decision.direction;
        double entry = -(direction > 0 ? start.station : start.length - start.station);
        Set<String> visited = new HashSet<String>();
        while (path.size() < 48 && entry < SEARCH_METERS && visited.add(current.id)) {
            double length = length(current);
            path.add(new PathPart(current, direction, entry));
            long exit = direction > 0 ? current.end : current.start;
            List<WideHcopRoad.Road> connected = nodes.get(exit);
            if (exit == 0 || connected == null || length < 1) break;
            WideHcopRoad.Road next = null;
            int nextDirection = 0;
            for (WideHcopRoad.Road option : connected) {
                if (visited.contains(option.id) || !sameGrade(current, option) || !sameName(current, option)) continue;
                int d = option.start == exit ? 1 : option.end == exit ? -1 : 0;
                if (!permits(option, d) || WideRoad.delta(tangent(current, direction, true), tangent(option, d, false)) > 35) continue;
                if (next != null && !next.id.equals(option.id)) { next = null; nextDirection = 0; break; }
                next = option; nextDirection = d;
            }
            if (next == null) break; // No destination: never choose between plausible continuations.
            entry += length;
            current = next; direction = nextDirection;
        }
        return path;
    }

    private static boolean siteAmbiguous(Record record, WideHcopRoad.Data data, SiteMatch chosen) {
        if (data == null) return true;
        boolean explicitLevel = levelHint(record.location) != 0;
        for (WideHcopRoad.Road road : data.roads) {
            if (!validRoad(road) || road.id.equals(chosen.road.id) || far(road, record.lat, record.lon, .001)) continue;
            WideRoad.Projection alternate = WideRoad.project(road.xy, record.lat, record.lon, 0);
            if (alternate.offset > chosen.projection.offset + 12) continue;
            if (!sameGrade(road, chosen.road)) {
                if (!explicitLevel || levelCompatible(record.location, road.grade)) return true;
            } else if (!joined(road, chosen.road)
                    && parallel(alternate.heading, chosen.projection.heading) < 30
                    && (sameName(road, chosen.road)
                        || alternate.offset + 5 <= chosen.projection.offset)) return true;
        }
        return false;
    }

    private List<Group> query(double lat, double lon) {
        double dy = SEARCH_METERS / 110000.0, dx = dy / Math.cos(Math.toRadians(lat));
        List<Group> result = new ArrayList<Group>();
        for (int x = (int) Math.floor((lon - dx) * 100); x <= (int) Math.floor((lon + dx) * 100); x++)
            for (int y = (int) Math.floor((lat - dy) * 100); y <= (int) Math.floor((lat + dy) * 100); y++) {
                List<Group> found = tiles.get(x + ":" + y);
                if (found != null) result.addAll(found);
            }
        return result;
    }

    private static String invalidPosition(WideCameraEngine.Fix fix, long now) {
        if (fix == null) return "等待定位";
        if (fix.mock) return "模擬定位不啟用科技執法提醒";
        if (!coordinate(fix.lat, fix.lon) || !Double.isFinite(fix.accuracy)
                || fix.accuracy <= 0 || fix.accuracy > 30) return "定位精度不足，暫停科技執法提醒";
        if (fix.time <= 0 || now < fix.time || now - fix.time > FRESH_MS) return "定位已過期，科技執法提醒已撤回";
        return null;
    }

    private static boolean moving(WideCameraEngine.Fix fix) {
        return fix.speedValid && Double.isFinite(fix.speed) && fix.speed >= 2 && fix.speed <= 60
                && fix.headingValid && Double.isFinite(fix.heading) && fix.heading >= 0 && fix.heading < 360;
    }
    private static double safeSpeed(WideCameraEngine.Fix fix) {
        return fix.speedValid && Double.isFinite(fix.speed) && fix.speed >= 0 && fix.speed <= 60 ? fix.speed : 0;
    }
    private static Frame empty(String reason, long time) {
        return new Frame(Collections.<Alert>emptyList(), "", "", "", reason, time, 0);
    }
    private static String speech(Alert alert) {
        List<String> terms = new ArrayList<String>();
        if (alert.categories.contains("red_light")) terms.add("紅燈");
        if (alert.categories.contains("pedestrian")) terms.add("停讓行人");
        if (alert.categories.contains("lane_signal")) terms.add("標誌標線");
        if (alert.categories.contains("turn")) terms.add("轉彎規定");
        if (alert.categories.contains("parking")) terms.add("停車規定");
        if (alert.categories.contains("following_distance")) terms.add("安全車距");
        if (alert.categories.contains("wrong_way")) terms.add("行駛方向");
        if (terms.size() > 3) terms = terms.subList(0, 3);
        int meters = Math.max(10, (int) Math.round(alert.distanceMeters / 10) * 10);
        StringBuilder text = alert.level == Level.DIRECTION_UNKNOWN
                ? new StringBuilder("前方有科技執法公告，取締方向待確認，請留意")
                : new StringBuilder("前方約").append(meters).append("公尺，科技執法，請注意");
        if (terms.isEmpty()) text.append("現場標誌");
        else for (int i = 0; i < terms.size(); i++) { if (i > 0) text.append("、"); text.append(terms.get(i)); }
        return text.toString();
    }
    private static LocalDate date(String value) {
        try { return LocalDate.parse(value); } catch (RuntimeException invalid) { return null; }
    }
    private static String text(JSONObject value, String key) {
        Object raw = value.opt(key); return raw instanceof String ? ((String) raw).trim() : "";
    }
    private static boolean coordinate(double lat, double lon) {
        return Double.isFinite(lat) && Double.isFinite(lon) && lat >= 21 && lat <= 27 && lon >= 118 && lon <= 123;
    }
    private static String tile(double lon, double lat) { return (int) Math.floor(lon * 100) + ":" + (int) Math.floor(lat * 100); }
    private static double distance(double a, double b, double c, double d) { return WideCameraEngine.distance(a, b, c, d); }
    private static String normalize(String value) {
        return value == null ? "" : value.replace('台', '臺').replaceAll("[\\s　]", "");
    }
    private static boolean roadName(String location, String[] names) {
        if (names == null) return false;
        String normalized = normalize(location);
        for (String name : names) {
            String token = normalize(name);
            if (token.length() < 2 || token.matches("[0-9]+")) continue;
            int at = normalized.indexOf(token);
            if (at < 0) continue;
            String after = normalized.substring(at + token.length());
            if (token.endsWith("路") && after.matches("^[一二三四五六七八九十0-9]+段.*")) continue;
            return true;
        }
        return false;
    }
    private static boolean sameName(WideHcopRoad.Road a, WideHcopRoad.Road b) {
        if (a.names == null || b.names == null) return false;
        for (String x : a.names) for (String y : b.names) {
            String name = normalize(x);
            if (name.length() > 1 && !name.matches("[0-9]+") && name.equals(normalize(y))) return true;
        }
        return false;
    }
    private static boolean sameGrade(WideHcopRoad.Road a, WideHcopRoad.Road b) {
        return a.grade != null && !a.grade.isEmpty() && a.grade.equals(b.grade);
    }
    private static int levelHint(String location) {
        if (location.contains("橋下") || location.contains("平面") || location.contains("便道") || location.contains("側車道")) return 1;
        if (location.contains("高架") || location.contains("橋上")) return 2;
        if ((location.contains("隧道") || location.contains("地下道"))
                && !location.contains("前方") && !location.contains("出口") && !location.contains("入口")) return 3;
        return 0;
    }
    private static boolean levelCompatible(String location, String grade) {
        if (grade == null || grade.isEmpty()) return false;
        String[] parts = grade.split("\\|", -1);
        if (parts.length != 3) return false;
        int layer;
        try { layer = Integer.parseInt(parts[0]); } catch (NumberFormatException invalid) { return false; }
        int hint = levelHint(location);
        if (hint == 1) return layer == 0 && "no".equals(parts[1]) && "no".equals(parts[2]);
        if (hint == 2) return layer > 0 || !"no".equals(parts[1]);
        if (hint == 3) return layer < 0 || !"no".equals(parts[2]);
        return true;
    }
    private static boolean validRoad(WideHcopRoad.Road road) {
        return road != null && road.id != null && road.xy != null && road.xy.length >= 2
                && road.grade != null && !road.grade.isEmpty();
    }
    private static boolean permits(WideHcopRoad.Road road, int direction) {
        return (direction == 1 && road.dir >= 0) || (direction == -1 && road.dir <= 0);
    }
    private static boolean joined(WideHcopRoad.Road a, WideHcopRoad.Road b) {
        return (a.start != 0 && (a.start == b.start || a.start == b.end))
                || (a.end != 0 && (a.end == b.start || a.end == b.end));
    }
    private static double parallel(double a, double b) { return Math.min(WideRoad.delta(a, b), WideRoad.delta(a, (b + 180) % 360)); }
    private static double length(WideHcopRoad.Road road) {
        return WideRoad.project(road.xy, road.xy[0][1], road.xy[0][0], 0).length;
    }
    private static double tangent(WideHcopRoad.Road road, int direction, boolean exit) {
        int index = exit == (direction > 0) ? road.xy.length - 2 : 0;
        double[] a = road.xy[index], b = road.xy[index + 1];
        return (WideCameraEngine.bearing(a[1], a[0], b[1], b[0]) + (direction < 0 ? 180 : 0)) % 360;
    }
    private static boolean far(WideHcopRoad.Road road, double lat, double lon, double margin) {
        return road.bounded && (lat < road.minLat - margin || lat > road.maxLat + margin
                || lon < road.minLon - margin || lon > road.maxLon + margin);
    }
    private static void add(Map<Long, List<WideHcopRoad.Road>> map, long node, WideHcopRoad.Road road) {
        if (node == 0) return;
        List<WideHcopRoad.Road> list = map.get(node);
        if (list == null) { list = new ArrayList<WideHcopRoad.Road>(); map.put(node, list); }
        list.add(road);
    }

    private static final class Record {
        final String id, location, address, directionText;
        final double lat, lon;
        final List<String> categories = new ArrayList<String>();
        final double[] bearings;
        final boolean site, conditional, hasNonSpeed, historical, planned;
        final LocalDate activation;
        Record(JSONObject source, double lat, double lon, Set<String> historicalSources) {
            this.id = text(source, "id"); this.location = text(source, "location");
            this.lat = lat; this.lon = lon; this.directionText = text(source, "directionText");
            this.address = normalize(text(source, "region") + "|" + text(source, "district") + "|" + location);
            JSONArray items = source.optJSONArray("categories");
            boolean nonSpeed = false;
            if (items != null) for (int i = 0; i < items.length(); i++) {
                String category = items.optString(i, "");
                if (!category.isEmpty() && !categories.contains(category)) categories.add(category);
                nonSpeed |= NON_SPEED.contains(category);
            }
            hasNonSpeed = nonSpeed;
            site = "site".equals(text(source, "geometryRole"));
            historical = historicalSources.contains(text(source, "sourceId"));
            planned = "planned".equals(text(source, "status"));
            activation = date(text(source, "activationDate"));
            JSONObject raw = source.optJSONObject("raw");
            String restriction = text(source, "vehicleRestrictionText") + " " + text(source, "violationText")
                    + " " + (raw == null ? "" : raw.toString());
            conditional = categories.contains("restricted_vehicle") || TIME_CONDITION.matcher(restriction).find();
            Object bearing = source.opt("travelBearing");
            if (bearing instanceof Number && Double.isFinite(((Number) bearing).doubleValue())
                    && ((Number) bearing).doubleValue() >= 0 && ((Number) bearing).doubleValue() < 360)
                bearings = new double[] {((Number) bearing).doubleValue()};
            else if ("南北雙向".equals(directionText) || "北南雙向".equals(directionText)) bearings = new double[] {0, 180};
            else if ("東西雙向".equals(directionText) || "西東雙向".equals(directionText)) bearings = new double[] {90, 270};
            else bearings = new double[0]; // Bare 雙向, camera side, and turning phrases do not identify an approach.
        }
    }
    private static final class Group {
        final String id, address;
        final double lat, lon;
        final List<Record> records = new ArrayList<Record>();
        Group(Record record) { id = record.id; address = record.address; lat = record.lat; lon = record.lon; }
    }
    private static final class Track {
        final Group group;
        int count;
        long sampleTime, startTime, lastTime, passedAt;
        double startDistance, lastDistance, minimum = Double.POSITIVE_INFINITY;
        boolean wasAhead, passed;
        String pendingKey = "";
        Track(Group group) { this.group = group; }
        boolean approaching(WideCameraEngine.Fix fix) {
            return count >= 3 && fix.time - startTime >= 1500
                    && startDistance - lastDistance >= Math.max(8, fix.accuracy * 1.5) && moving(fix) && !passed;
        }
    }
    private static final class Spoken {
        final String id, address;
        final double lat, lon;
        final long time;
        Spoken(Group group, long time) { id = group.id; address = group.address; lat = group.lat; lon = group.lon; this.time = time; }
    }
    private static final class PathPart {
        final WideHcopRoad.Road road;
        final int direction;
        final double startDistance;
        PathPart(WideHcopRoad.Road road, int direction, double distance) { this.road = road; this.direction = direction; startDistance = distance; }
    }
    private static final class SiteMatch {
        final WideHcopRoad.Road road;
        final WideRoad.Projection projection;
        final double ahead, heading;
        SiteMatch(WideHcopRoad.Road road, WideRoad.Projection projection, double ahead, double heading) {
            this.road = road; this.projection = projection; this.ahead = ahead; this.heading = heading;
        }
    }
    private static final class Assessment {
        final Record record;
        Level level = Level.NEARBY;
        double distance;
        boolean along;
        String reason = "鄰近直線距離；道路、分層或行向待確認";
        Assessment(Record record, double radial) { this.record = record; distance = radial; }
    }
}
