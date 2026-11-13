package com.navipilot.obf;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Source-bound Link guidance and selected-route snapshots. Route schema provenance is in SCHEMA.md.
 *
 * Link ManeuverIconID is the AutoSDK icon domain, not the mobile SDK turn domain
 * and not Carrot's turn_type domain. Only equivalent, supported Carrot actions
 * are emitted. This class deliberately has no Android, broadcast or wire I/O.
 */
public final class WideAmapLinkNavigation {
    /** Conservative input expiry; this is not a vehicle-control validation. */
    public static final long GUIDANCE_TTL_MS = 3000L;
    private static final int UNKNOWN = 0, GUIDING = 1, STOPPED = 2, ARRIVED = 3;

    private final WideAmapLinkRoute routes = new WideAmapLinkRoute();
    private JSONObject routeNav;
    private long epoch;
    private long lastEventElapsed = -1;
    private int mode = UNKNOWN;
    private int maneuver = -1;
    private Integer distance;
    private String road = "";
    private long segmentElapsed = -1;
    private long segmentWall;
    private long statusElapsed = -1;
    private long statusWall;
    private String reason = "link_waiting_for_navigation";

    public synchronized void reset(long nextEpoch) {
        clear();
        epoch = nextEpoch > 0 ? nextEpoch : 0;
    }

    public synchronized void invalidate() {
        clear();
        epoch = 0;
        reason = "link_session_invalidated";
    }

    private void clear() {
        routes.clear();
        routeNav = null;
        lastEventElapsed = -1;
        mode = UNKNOWN;
        maneuver = -1;
        distance = null;
        road = "";
        segmentElapsed = statusElapsed = -1;
        segmentWall = statusWall = 0;
        reason = "link_waiting_for_navigation";
    }

    /**
     * receivedElapsedMs belongs to the Binder receipt, not the eventual UI task.
     * wallMs is retained only as Navi v2 provenance; it never determines TTL.
     */
    public synchronized boolean accept(long sourceEpoch, int type, JSONObject data,
            long receivedElapsedMs, long wallMs) {
        if (epoch == 0 || sourceEpoch != epoch || receivedElapsedMs < 0 || wallMs <= 0
                || receivedElapsedMs < lastEventElapsed) return false;
        if (type != 1 && type != 2 && type != 3 && type != 19 && type != 20
                && type != 4 && type != 5 && type != 100 && type != 200) return false;
        lastEventElapsed = receivedElapsedMs;
        if (type == 1) return false; // Calculation success is not route adoption.
        if (type == 2 || type == 20 || type == 19 || type == 3) {
            if (type == 20 && data != null
                    && routes.selected().equals(WideAmapLinkRoute.id(data.opt("routeId")))) return true;
            if (type == 2) routes.acceptGroup(data);
            else if (type == 20) routes.choose(data == null ? "" : WideAmapLinkRoute.id(data.opt("routeId")));
            else routes.clear();
            routeNav = null;
            maneuver = -1; distance = null; road = "";
            segmentElapsed = statusElapsed = -1;
            segmentWall = statusWall = 0; mode = UNKNOWN;
            reason = "link_waiting_for_segment";
            return true;
        }

        if (type == 100 || type == 200) {
            routes.clear();
            routeNav = null;
            maneuver = -1;
            distance = null;
            road = "";
            segmentElapsed = -1;
            segmentWall = 0;
            statusElapsed = receivedElapsedMs;
            statusWall = wallMs;
            mode = type == 200 ? ARRIVED : STOPPED;
            reason = type == 200 ? "link_arrived" : "link_navigation_stopped";
            return true;
        }

        if (type == 5) {
            Integer next = integer(data == null ? null : data.opt("maneuverID"), 65535);
            if (next != null && next.intValue() == maneuver) {
                // An icon heartbeat is not a new distance/road observation.
                return true;
            }
            maneuver = next == null ? -1 : next.intValue();
            distance = null;
            road = "";
            segmentElapsed = -1;
            segmentWall = 0;
            // Do not start navigation, refresh its lifetime or undo a stop from an icon alone.
            reason = next == null ? "link_invalid_maneuver" : "link_waiting_for_segment";
            return true;
        }

        routeNav = null;
        Integer next = integer(data == null ? null : data.opt("curManeuverID"), 65535);
        Integer metres = integer(data == null ? null : data.opt("segmentRemainDist"), Integer.MAX_VALUE);
        maneuver = next == null ? -1 : next.intValue();
        distance = null;
        road = "";
        segmentElapsed = -1;
        segmentWall = 0;
        statusElapsed = -1;
        statusWall = 0;
        mode = UNKNOWN;
        if (next == null || metres == null) {
            // A new malformed/partial segment must not leave the previous turn live.
            reason = "link_incomplete_segment";
            return true;
        }
        try { routeNav = new JSONObject(data.toString()); } catch (JSONException ignored) { }
        // A new path must not retain the geometry of the previous one.
        if (routeNav != null && !WideAmapLinkRoute.id(routeNav.opt("pathID")).isEmpty()
                && !routes.selected().equals(WideAmapLinkRoute.id(routeNav.opt("pathID")))) {
            routes.choose(WideAmapLinkRoute.id(routeNav.opt("pathID")));
        }
        distance = metres;
        road = text(data.opt("nextRouteName"));
        segmentElapsed = statusElapsed = receivedElapsedMs;
        segmentWall = statusWall = wallMs;
        mode = GUIDING;
        reason = turnType(maneuver) < 0 ? "link_unmapped_maneuver" : "link_guidance_available";
        return true;
    }

    public synchronized Snapshot snapshot(long elapsedMs) {
        if (epoch == 0) return new Snapshot(null, null, 0, 0, reason, -1, null, "", -1);
        boolean liveStatus = mode == GUIDING && fresh(statusElapsed, elapsedMs);
        boolean liveSegment = liveStatus && distance != null && fresh(segmentElapsed, elapsedMs);
        int turn = turnType(maneuver);
        JSONObject guidance = null;
        JSONObject status = null;
        try {
            if (liveSegment && turn >= 0) {
                String action = action(maneuver);
                guidance = new JSONObject()
                        .put("distance_m", distance.intValue())
                        .put("turn_type", turn)
                        .put("main_text", road.isEmpty() ? action : action + " " + road)
                        .put("near_direction", road)
                        .put("far_direction", "")
                        .put("road_name", road);
            }
            if (liveStatus || mode == STOPPED || mode == ARRIVED) {
                status = new JSONObject()
                        .put("mode", liveStatus ? "guiding" : "idle")
                        .put("guidance_active", guidance != null)
                        .put("route_present", false);
            }
        } catch (JSONException invalid) {
            // All values above are bounded primitives/strings. Fail closed if JSON still rejects them.
            guidance = null;
            status = null;
        }
        String snapshotReason = mode == GUIDING && !liveStatus ? "link_guidance_expired" : reason;
        Snapshot result = new Snapshot(guidance, status,
                guidance == null ? 0 : segmentWall, status == null ? 0 : statusWall,
                snapshotReason, maneuver, liveSegment ? distance : null,
                liveSegment ? road : "", liveStatus ? statusElapsed + GUIDANCE_TTL_MS + 1 : -1);
        try {
            if (liveSegment && routeNav != null) {
                result.route = routes.route(routeNav);
                result.next = routes.next(routeNav);
                if (result.route != null && status != null) status.put("route_present", true);
            }
        } catch (Exception invalid) { result.route = result.next = null; }
        result.routeReason = routes.reason();
        return result;
    }

    private static boolean fresh(long receipt, long now) {
        return receipt >= 0 && now >= receipt && now - receipt <= GUIDANCE_TTL_MS;
    }

    private static Integer integer(Object value, int maximum) {
        if (!(value instanceof Number)) return null;
        double number = ((Number) value).doubleValue();
        if (Double.isNaN(number) || Double.isInfinite(number) || number < 0 || number > maximum
                || number != Math.floor(number)) return null;
        return Integer.valueOf((int) number);
    }

    private static String text(Object value) {
        if (!(value instanceof String)) return "";
        String input = (String) value;
        StringBuilder clean = new StringBuilder();
        for (int i = 0; i < input.length() && clean.length() < 100; i++) {
            char c = input.charAt(i);
            clean.append(Character.isISOControl(c) ? ' ' : c);
        }
        return clean.toString().trim();
    }

    static int turnType(int icon) {
        switch (icon) {
            case 2: return 12;
            case 3: return 13;
            case 6: return 16;
            case 7: return 19;
            case 8: case 19: return 14;
            case 9: case 20: return 51;
            // Keep-left/right, roundabout detail and unverified IDs have no equivalent here.
            default: return -1;
        }
    }

    static String action(int icon) {
        switch (icon) {
            case 2: return "左轉";
            case 3: return "右轉";
            case 6: return "向左後方轉彎";
            case 7: return "向右後方轉彎";
            case 8: case 19: return "迴轉";
            case 9: case 20: return "直行";
            default: return "";
        }
    }

    /** JSON instances are fresh copies per snapshot; unknown source fields are absent. */
    public static final class Snapshot {
        public JSONObject route;
        public JSONObject next;
        public String routeReason = "尚無高德完整路線";
        public JSONObject stream(String name) {
            if ("route".equals(name)) return route;
            if ("guidance_next".equals(name)) return next;
            if ("guidance_current".equals(name)) return guidance;
            if ("navigation_status".equals(name)) return status;
            return null;
        }
        public long timestamp(String name) {
            return "navigation_status".equals(name) ? statusTimestampMs : guidanceTimestampMs;
        }
        public String routeStatus() {
            return "\n" + routeReason + (route == null ? "；等待同一路線的新鮮引導" : "；路線已可交付")
                + "\n再下一轉彎：" + (next == null ? "尚無可確認資料" : "已對應路段")
                + "\n道路限速：尚未確認 Link 有提供；未用車速或相機限速代替";
        }
        public final JSONObject guidance;
        public final JSONObject status;
        public final long guidanceTimestampMs;
        public final long statusTimestampMs;
        public final String reason;
        public final int rawManeuver;
        public final Integer distanceM;
        public final String roadName;
        public final long expiresElapsedMs;

        private Snapshot(JSONObject guidance, JSONObject status, long guidanceTimestampMs,
                long statusTimestampMs, String reason, int rawManeuver, Integer distanceM,
                String roadName, long expiresElapsedMs) {
            this.guidance = guidance;
            this.status = status;
            this.guidanceTimestampMs = guidanceTimestampMs;
            this.statusTimestampMs = statusTimestampMs;
            this.reason = reason;
            this.rawManeuver = rawManeuver;
            this.distanceM = distanceM;
            this.roadName = roadName;
            this.expiresElapsedMs = expiresElapsedMs;
        }
    }
}
