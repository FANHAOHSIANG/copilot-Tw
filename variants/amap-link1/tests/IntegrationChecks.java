package com.navipilot.obf;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.SystemClock;
import org.json.JSONObject;

/**
 * Executes production integration and navigation code with a deterministic Android boundary.
 * The source gate's actual Auto/Google smali branches and the real Binder/WebSocket are separate
 * build/device checks; these tests do not substitute a host simulation for those implementations.
 */
public final class IntegrationChecks {
    private static final String PHONE = "com.autonavi.minimap";
    private static final String AUTO = "com.autonavi.amapauto";
    private static final String GOOGLE = "com.google.android.apps.maps";
    private static int checks;

    private static void check(boolean condition, String message) {
        checks++;
        if (!condition) throw new AssertionError(message);
    }

    private static JSONObject cue(int icon, int distance) throws Exception {
        return new JSONObject().put("curManeuverID", icon).put("segmentRemainDist", distance)
                .put("nextRouteName", "合成測試道路");
    }

    private static WideAmapLink newest() {
        return WideAmapLink.instances.get(WideAmapLink.instances.size() - 1);
    }

    private static void tick(long now) { Handler.runUntil(now); }

    private static JSONObject guidance(MG wire) {
        return WideAmapLinkIntegration.filter(wire, "guidance_current", null, wire.timestamps);
    }

    private static String status() { return WideAmapLinkIntegration.statusFor(PHONE); }

    private static void foreignFieldsAreAbsent(MG wire) throws Exception {
        for (String stream : new String[] {"guidance_next", "route", "speed", "vehicle",
                "lane_current", "road_category", "traffic_signal", "ui_route_changed"}) {
            wire.timestamps.put(stream, Long.valueOf(System.currentTimeMillis()));
            JSONObject oldAuto = new JSONObject().put("road_limit_kph", 80)
                    .put("distance_m", 99).put("turn_type", 12)
                    .put("polyline", "old-auto-route");
            check(WideAmapLinkIntegration.filter(wire, stream, oldAuto, wire.timestamps) == null,
                    "phone cannot inherit Auto " + stream);
            check(!wire.timestamps.containsKey(stream), "withdrawn " + stream + " loses stale source timestamp");
        }
    }

    private static void publicationMustMatchActualReceipt(MG wire, WideAmapLink reader) throws Exception {
        tick(1_200);
        wire.accepting = false;
        reader.deliver(4, cue(3, 22), 1_200);
        check(status().contains("這筆引導尚未被接受"), "new cue cannot inherit previous wire acceptance");
        JSONObject value = guidance(wire);
        WideAmapLinkIntegration.published(new MG(), "guidance_current", value);
        check(status().contains("這筆引導尚未被接受"), "different sender cannot claim acceptance");
        value = guidance(wire);
        WideAmapLinkIntegration.published(wire, "navigation_status", value);
        check(status().contains("這筆引導尚未被接受"), "different stream cannot claim acceptance");
        value = guidance(wire);
        WideAmapLinkIntegration.published(wire, "guidance_current", new JSONObject(value.toString()));
        check(status().contains("這筆引導尚未被接受"), "equal JSON without exact receipt cannot claim acceptance");
        value = guidance(wire);
        WideAmapLinkIntegration.published(wire, "guidance_current", value);
        check(status().contains("已接受這筆引導"), "matching successful sender receipt records acceptance");
        wire.accepting = true;
        wire.b("guidance_current", null, "host_acceptance");
    }

    public static void main(String[] args) throws Exception {
        Context context = new Context();
        WideAmapLinkIntegration.prepare(context);
        check(WideAmapLink.instances.isEmpty(), "Auto preparation does not bind mobile service");
        check(WideAmapLinkIntegration.statusFor(AUTO) == null, "Auto diagnostics fall through unchanged");
        check(WideAmapLinkIntegration.statusFor(GOOGLE) == null, "Google diagnostics fall through unchanged");

        context.preferences.put("navigation_package", PHONE);
        WideAmapLinkIntegration.serviceCommand(context, null);
        check(PHONE.equals(WideAmapSource.selected), "cold service start restores selected source through existing gate");
        check(WideAmapLink.instances.size() == 1, "cold phone service start creates one reader");
        WideAmapLink first = newest();
        check(first.starts == 1, "phone reader started once");
        MG wire = new MG();
        wire.timestamps.put("guidance_current", Long.valueOf(System.currentTimeMillis()));
        check(WideAmapLinkIntegration.filter(wire, "guidance_current", cue(2, 99), wire.timestamps) == null,
                "phone selection never forwards old Auto cue while waiting");
        check(!wire.timestamps.containsKey("guidance_current"), "initial old cue timestamp removed");
        JSONObject appStatus = new JSONObject().put("active", true);
        check(WideAmapLinkIntegration.filter(wire, "app_status", appStatus, wire.timestamps) == appStatus,
                "app_status is unaffected by phone guidance gate");
        foreignFieldsAreAbsent(wire);

        first.ready();
        first.deliver(4, cue(2, 38), 1_000);
        check(wire.latest.get("guidance_current").getInt("turn_type") == 12, "real integration publishes mapped turn");
        check(wire.latest.get("guidance_current").getInt("distance_m") == 38, "real integration publishes supplied distance");
        check(wire.latest.get("navigation_status").getBoolean("guidance_active"), "active status accompanies guidance");
        check(status().contains("已接受這筆引導"), "matching successful publication is visible");
        publicationMustMatchActualReceipt(wire, first);

        long sourceStamp = wire.timestamps.get("guidance_current").longValue();
        for (int i = 0; i < 25; i++) status();
        check(guidance(wire).getInt("distance_m") == 22, "UI reads preserve cue");
        check(wire.timestamps.get("guidance_current").longValue() == sourceStamp, "UI reads do not renew source timestamp");
        tick(2_000);
        first.deliver(5, new JSONObject().put("maneuverID", 3), 2_000);
        check(wire.timestamps.get("guidance_current").longValue() == sourceStamp, "same-icon heartbeat preserves original receipt");
        tick(3_900);
        first.deliver(7, new JSONObject(), 3_900);
        tick(4_100);
        check(wire.latest.get("guidance_current") != null, "periodic publication remains valid before 3s deadline");
        int beforeExpiry = wire.sends.size();
        tick(4_201);
        check(wire.sends.size() > beforeExpiry, "expiry itself publishes without any UI access");
        check(wire.latest.get("guidance_current") == null, "deadline withdraws cue without UI polling");
        check(wire.latest.get("navigation_status") == null, "deadline withdraws stale navigation status");
        check(!wire.timestamps.containsKey("guidance_current"), "deadline removes cue source timestamp");
        check(!wire.timestamps.containsKey("navigation_status"), "deadline removes status source timestamp");

        tick(5_500);
        first.deliver(4, cue(2, 38), 2_000);
        check(guidance(wire) == null, "delayed decoding cannot date an old Binder receipt as fresh");
        tick(6_000);
        first.deliver(4, cue(2, 38), 6_000);
        check(guidance(wire) != null, "fresh data recovers after expiry");
        long oldEpoch = first.epoch;
        wire.accepting = false;
        first.barrier();
        check(guidance(wire) == null, "new transport epoch withdraws current data");
        check(!status().contains("已接受引導撤銷"), "failed withdrawal cannot inherit previous publication receipt");
        wire.accepting = true;
        tick(6_100);
        first.ready();
        first.deliver(4, cue(3, 22), 6_100);
        tick(6_200);
        first.listener.onData(oldEpoch, 4, cue(2, 99), 6_200);
        first.listener.onInvalidated(oldEpoch, "late_old_barrier");
        first.listener.onData(oldEpoch, 100, new JSONObject(), 6_200);
        first.listener.onInvalidated(first.epoch, "duplicate_current_barrier");
        check(guidance(wire).getInt("distance_m") == 22, "old data/stop/barrier and duplicate barrier cannot affect new epoch");
        foreignFieldsAreAbsent(wire);

        WideAmapLinkIntegration.select(AUTO);
        check(first.closes == 1, "Auto selection closes mobile binding");
        first.listener.onData(first.epoch, 4, cue(2, 99), 6_200);
        check(guidance(wire) == null, "disposed phone reader cannot restore data after source switch");
        check(!wire.timestamps.containsKey("guidance_current"), "source switch removes phone source timestamp");
        int instanceCount = WideAmapLink.instances.size();
        WideAmapLinkIntegration.select(GOOGLE);
        WideAmapLinkIntegration.afterMapLaunch(GOOGLE);
        WideAmapLinkIntegration.afterMapLaunch(AUTO);
        WideAmapLinkIntegration.afterMapLaunch(PHONE);
        check(WideAmapLink.instances.size() == instanceCount, "Auto/Google do not create mobile reader");
        check(first.retries == 0, "other source launches cannot restart disposed phone reader");
        check(WideAmapLinkIntegration.statusFor(GOOGLE) == null, "Google diagnostic remains original after switching");

        tick(7_000);
        WideAmapLinkIntegration.select(PHONE);
        WideAmapLink second = newest();
        check(second != first && second.starts == 1, "phone reselection gets a new isolated instance");
        first.listener.onInvalidated(first.epoch + 100, "late_old_instance");
        first.listener.onData(first.epoch + 100, 4, cue(2, 99), 7_000);
        check(guidance(wire) == null, "old source instance cannot populate newly selected phone");
        second.ready();
        second.deliver(4, cue(3, 22), 7_000);
        check(guidance(wire).getInt("distance_m") == 22, "new source instance provides its own cue");

        tick(7_100);
        WideAmapLinkIntegration.serviceCommand(context, new Intent("STOP_SERVICE"));
        check(second.closes == 1, "foreground service stop closes active binding");
        check(wire.latest.get("guidance_current") == null, "service stop publishes guidance withdrawal");
        check(!wire.timestamps.containsKey("guidance_current"), "service stop removes source timestamp");
        int sendsAfterStop = wire.sends.size();
        int readersAfterStop = WideAmapLink.instances.size();
        WideAmapLinkIntegration.prepare(context);
        WideAmapLinkIntegration.afterMapLaunch(PHONE);
        WideAmapLinkIntegration.serviceCommand(context, new Intent("UNRELATED_ACTION"));
        tick(9_500);
        check(WideAmapLink.instances.size() == readersAfterStop, "UI prepare/map launch cannot undo explicit service stop");
        check(wire.sends.size() == sendsAfterStop, "stopped heartbeat/expiry tasks cannot publish later");

        WideAmapLinkIntegration.serviceCommand(context, new Intent("START_SERVICE"));
        WideAmapLink third = newest();
        check(third != second && third.starts == 1, "explicit service restart creates a fresh binding");
        second.listener.onData(second.epoch, 4, cue(2, 99), 9_500);
        check(guidance(wire) == null, "stopped instance cannot cross explicit service restart");
        third.ready();
        third.deliver(4, cue(3, 22), 9_500);
        check(guidance(wire).getInt("distance_m") == 22, "restarted service accepts its own fresh data");
        WideAmapLinkIntegration.serviceStopped();
        check(Handler.pendingTasks() == 0, "test leaves no scheduled background task");
        System.out.println("IntegrationChecks: " + checks + " assertions passed");
    }
}
