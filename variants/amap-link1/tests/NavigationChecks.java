package com.navipilot.obf;

import org.json.JSONObject;

/**
 * Independent behavior checks using synthetic values in confirmed Link type 4/5 shapes.
 * No fixture represents a capture from the user's phone or a successful C4 road test.
 */
public final class NavigationChecks {
    private static final long WALL = 1_800_000_000_000L;
    private static int checks;

    private static void check(boolean condition, String message) {
        checks++;
        if (!condition) throw new AssertionError(message);
    }

    private static JSONObject nav(int icon, int distance, String road) throws Exception {
        JSONObject value = new JSONObject()
                .put("curManeuverID", icon)
                .put("segmentRemainDist", distance);
        if (road != null) value.put("nextRouteName", road);
        return value;
    }

    private static JSONObject icon(int icon) throws Exception {
        return new JSONObject().put("maneuverID", icon);
    }

    private static WideAmapLinkNavigation model(long epoch) {
        WideAmapLinkNavigation model = new WideAmapLinkNavigation();
        model.reset(epoch);
        return model;
    }

    private static void absent(WideAmapLinkNavigation model, long now, String message) {
        check(model.snapshot(now).guidance == null, message);
    }

    private static void expectTurn(WideAmapLinkNavigation model, long now, int turn,
                                   int distance, String message) throws Exception {
        JSONObject value = model.snapshot(now).guidance;
        check(value != null, message + ": present");
        check(value.getInt("turn_type") == turn, message + ": target maneuver");
        check(value.getInt("distance_m") == distance, message + ": segment distance");
    }

    private static void supportedMappings() throws Exception {
        // Carrot's active _update_tbt path supports these target enums.
        // Slight/fork synthetic enums from its display table are deliberately absent.
        int[][] pairs = {{2, 12}, {3, 13}, {6, 16}, {7, 19}, {8, 14}, {19, 14}, {9, 51}, {20, 51}};
        for (int[] pair : pairs) {
            WideAmapLinkNavigation model = model(1);
            model.accept(1, 4, nav(pair[0], 38, "測試道路甲"), 1_000, WALL);
            expectTurn(model, 1_001, pair[1], 38, "icon " + pair[0]);
            JSONObject value = model.snapshot(1_001).guidance;
            check("測試道路甲".equals(value.optString("road_name", null)), "road is supplied verbatim");
            check(value.isNull("point"), "no invented maneuver coordinate");
            check(value.isNull("time_sec"), "no invented maneuver travel time");
        }
    }

    private static void nextTurnDistanceOnly() throws Exception {
        WideAmapLinkNavigation model = model(7);
        model.accept(7, 4, nav(2, 38, "測試道路甲").put("routeRemainDist", 28_000), 1_000, WALL);
        expectTurn(model, 1_001, 12, 38, "route distance must not replace segment distance");
        model.accept(7, 4, new JSONObject().put("curManeuverID", 3)
                .put("routeRemainDist", 27_900).put("nextRouteName", "測試道路乙"), 2_000, WALL + 1_000);
        absent(model, 2_001, "destination distance cannot create a next-turn distance");
        model.accept(7, 4, nav(3, 22, null), 3_000, WALL + 2_000);
        expectTurn(model, 3_001, 13, 22, "new complete instruction recovers");
        check(!"測試道路甲".equals(model.snapshot(3_001).guidance.optString("road_name")),
                "omitted road cannot retain an older road");
        check(!"測試道路乙".equals(model.snapshot(3_001).guidance.optString("road_name")),
                "incomplete instruction cannot lend its road to a later instruction");
    }

    private static void unsupportedAndMalformed() throws Exception {
        int[] unsupported = {0, 1, 4, 5, 11, 12, 9999, -1};
        for (int unknown : unsupported) {
            WideAmapLinkNavigation model = model(2);
            model.accept(2, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
            model.accept(2, 4, nav(unknown, 22, "測試道路乙"), 2_000, WALL + 1_000);
            absent(model, 2_001, "unsupported icon " + unknown + " clears old maneuver");
        }
        JSONObject[] invalid = {
                new JSONObject(),
                new JSONObject().put("curManeuverID", 2),
                new JSONObject().put("segmentRemainDist", 22),
                nav(2, -1, "測試道路甲"),
                new JSONObject().put("curManeuverID", 2).put("segmentRemainDist", JSONObject.NULL),
                new JSONObject().put("curManeuverID", 2).put("segmentRemainDist", "not a distance"),
                new JSONObject().put("curManeuverID", 2).put("segmentRemainDist", true)
        };
        for (JSONObject value : invalid) {
            WideAmapLinkNavigation model = model(2);
            model.accept(2, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
            model.accept(2, 4, value, 2_000, WALL + 1_000);
            absent(model, 2_001, "incomplete/malformed type 4 withdraws older guidance");
        }
    }

    private static void iconChangesInvalidateRelatedFields() throws Exception {
        WideAmapLinkNavigation model = model(3);
        model.accept(3, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
        model.accept(3, 5, icon(3), 1_500, WALL + 500);
        absent(model, 1_501, "new right arrow cannot reuse left distance/road");
        check(model.snapshot(1_501).distanceM == null, "arrow-only update has no distance");
        check(model.snapshot(1_501).roadName == null || model.snapshot(1_501).roadName.isEmpty(),
                "arrow-only update has no previous road");
        model.accept(3, 4, nav(3, 22, "測試道路乙"), 2_000, WALL + 1_000);
        expectTurn(model, 2_001, 13, 22, "complete instruction after icon change");
        model.accept(3, 5, icon(9999), 2_500, WALL + 1_500);
        absent(model, 2_501, "unknown arrow withdraws current guidance");
    }

    private static void unrelatedCallbacksDoNotRenewFreshness() throws Exception {
        WideAmapLinkNavigation model = model(4);
        model.accept(4, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
        model.accept(4, 7, new JSONObject(), 1_000, WALL);
        expectTurn(model, 1_001, 12, 38, "type 7 in same batch cannot clear type 4");
        model.accept(4, 5, icon(2), 3_900, WALL + 2_900);
        model.accept(4, 7, new JSONObject(), 3_950, WALL + 2_950);
        model.accept(4, 16, new JSONObject(), 3_990, WALL + 2_990);
        expectTurn(model, 3_999, 12, 38, "same arrow before original TTL");
        check(model.snapshot(3_999).guidanceTimestampMs == WALL,
                "arrow, mode and location updates cannot renew guidance source timestamp");
        absent(model, 4_001, "same arrow, mode and location cannot renew complete-guidance TTL");
        check(model.snapshot(4_001).status == null, "stale navigation status is withdrawn");
    }

    private static void readAndPublishDoNotRenewFreshness() throws Exception {
        WideAmapLinkNavigation model = model(5);
        model.accept(5, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
        for (long now = 1_100; now < 4_000; now += 100) {
            WideAmapLinkNavigation.Snapshot value = model.snapshot(now);
            check(value.guidance != null, "snapshot remains available before source TTL");
            check(value.guidanceTimestampMs == WALL, "polling preserves original source time");
        }
        absent(model, 4_001, "periodic MG/UI polling does not extend source TTL");
        absent(model, 50_000, "later polling cannot revive expired instruction");
    }

    private static void stopAndArrival() throws Exception {
        for (int type : new int[] {100, 200}) {
            WideAmapLinkNavigation model = model(6);
            model.accept(6, 4, nav(3, 22, "測試道路乙"), 1_000, WALL);
            model.accept(6, type, new JSONObject(), 2_000, WALL + 1_000);
            absent(model, 2_001, "lifecycle " + type + " clears guidance immediately");
            JSONObject status = model.snapshot(2_001).status;
            check(status != null, "explicit stop publishes navigation status");
            check(!status.optBoolean("guidance_active", true), "stopped guidance inactive");
            check(!status.optBoolean("route_present", true), "stopped route absent");
            model.accept(6, 5, icon(3), 2_500, WALL + 1_500);
            model.accept(6, 7, new JSONObject(), 2_500, WALL + 1_500);
            absent(model, 2_501, "post-stop icon/mode cannot revive prior instruction");
        }
    }

    private static void generationAndDisconnect() throws Exception {
        WideAmapLinkNavigation model = model(10);
        model.accept(10, 4, nav(2, 38, "測試道路甲"), 1_000, WALL);
        model.reset(11);
        absent(model, 1_001, "new source epoch clears old guidance");
        check(model.snapshot(1_001).status == null, "new source epoch clears old status");
        model.accept(10, 4, nav(3, 22, "舊會話"), 1_500, WALL + 500);
        absent(model, 1_501, "old callback cannot populate new source epoch");
        model.accept(11, 4, nav(3, 22, "新會話"), 2_000, WALL + 1_000);
        model.accept(10, 100, new JSONObject(), 2_500, WALL + 1_500);
        expectTurn(model, 2_501, 13, 22, "old stop callback cannot clear new source epoch");
        model.invalidate();
        absent(model, 2_502, "disconnect/auth failure invalidates immediately");
        check(model.snapshot(2_502).status == null, "disconnect invalidates status");
    }

    private static void monotonicTimeAndSnapshotOwnership() throws Exception {
        WideAmapLinkNavigation model = model(12);
        JSONObject input = nav(2, 38, "測試道路甲");
        model.accept(12, 4, input, 1_000, WALL);
        input.put("segmentRemainDist", 9999).put("nextRouteName", "被修改的輸入");
        expectTurn(model, 1_001, 12, 38, "caller mutation does not change stored instruction");
        JSONObject first = model.snapshot(1_001).guidance;
        first.put("distance_m", 9999).put("road_name", "被修改的快照");
        expectTurn(model, 1_002, 12, 38, "snapshot mutation does not change stored instruction");
        model.accept(12, 4, nav(3, 22, "測試道路乙"), 2_000, WALL - 3_600_000);
        expectTurn(model, 4_999, 13, 22, "wall-clock correction cannot prematurely expire guidance");
        check(model.snapshot(4_999).guidanceTimestampMs == WALL - 3_600_000,
                "wire timestamp records actual input wall time without fabricating freshness");
        absent(model, 5_001, "monotonic elapsed time still expires after clock correction");
    }

    public static void main(String[] args) throws Exception {
        supportedMappings();
        nextTurnDistanceOnly();
        unsupportedAndMalformed();
        iconChangesInvalidateRelatedFields();
        unrelatedCallbacksDoNotRenewFreshness();
        readAndPublishDoNotRenewFreshness();
        stopAndArrival();
        generationAndDisconnect();
        monotonicTimeAndSnapshotOwnership();
        System.out.println("NavigationChecks: " + checks + " assertions passed");
    }
}
