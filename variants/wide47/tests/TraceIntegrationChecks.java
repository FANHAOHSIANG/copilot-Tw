package com.navipilot.obf;
import android.content.Context;
import android.os.Handler;
import org.json.JSONObject;
public final class TraceIntegrationChecks {
    private static int count;
    private static void check(boolean ok, String why) { count++; if (!ok) throw new AssertionError(why); }
    private static JSONObject cue(int icon) throws Exception {
        return new JSONObject().put("curManeuverID", icon).put("segmentRemainDist", 123).put("nextRouteName", "合成測試道路");
    }
    public static void main(String[] args) throws Exception {
        WideAmapLinkIntegration.prepare(new Context());
        WideAmapLinkIntegration.select("com.autonavi.minimap");
        WideAmapLink link = WideAmapLink.instances.get(0); link.ready(); MG wire=new MG();
        WideAmapLinkIntegration.filter(wire, "guidance_current", null, wire.timestamps);
        link.deliver(4,cue(2),1000);
        check(WideBridgeLog.names.isEmpty(), "recording off emits nothing");
        WideBridgeLog.enabled=true; Handler.runUntil(1100); link.deliver(4,cue(2),1100);
        check(WideBridgeLog.latest("amap_link_capture").getString("source").equals("com.autonavi.minimap"), "source recorded");
        check(!WideBridgeLog.latest("amap_link_capture").getBoolean("route_forwarding"), "route not falsely enabled");
        check(WideBridgeLog.latest("amap_link_decision").getBoolean("guidance_present"), "valid guidance recorded");
        check(WideBridgeLog.latest("amap_link_output").getBoolean("accepted_by_sender"), "actual sender acceptance recorded");
        check(!WideBridgeLog.latest("amap_link_output").getBoolean("c4_receipt"), "local send is not claimed as C4 receipt");
        Handler.runUntil(1200); link.deliver(4,cue(999),1200);
        check(!WideBridgeLog.latest("amap_link_decision").getBoolean("guidance_present"), "unsupported maneuver clears");
        check(WideBridgeLog.latest("amap_link_decision").getInt("raw_maneuver")==999, "unsupported maneuver ID visible");
        link.deliver(2,new JSONObject().put("route", "unconfirmed"),1200);
        check(WideAmapLinkIntegration.filter(wire,"route",null,wire.timestamps)==null, "unknown route never forwarded");
        check(WideAmapLinkIntegration.statusFor("com.autonavi.minimap").contains("2=1"), "unmapped event type counted");
        Handler.runUntil(1300); link.deliver(4,cue(2),1300); Handler.runUntil(4400);
        check(!WideBridgeLog.latest("amap_link_decision").getBoolean("guidance_present"), "staleness withdrawal recorded");
        check(WideBridgeLog.latest("amap_link_decision").getString("reason").equals("link_guidance_expired"), "expiry cause recorded");
        link.barrier();
        check(WideBridgeLog.latest("amap_link_reset").getString("reason").equals("test_disconnect"), "disconnect cause recorded");
        WideBridgeLog.enabled=false; int before=WideBridgeLog.names.size(); Handler.runUntil(4500); link.deliver(4,cue(2),4500);
        check(WideBridgeLog.names.size()==before,"stopping recording stops diagnostics");
        WideAmapLinkIntegration.select("com.autonavi.amapauto");
        check(WideAmapLinkIntegration.extendReport("original report").startsWith("original report"),"existing report preserved");
        System.out.println("TraceIntegrationChecks: " + count + " assertions passed");
    }
}
