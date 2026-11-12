package com.navipilot.obf;
import org.json.*;
public final class GoogleBridgeChecks {
 static int count;static void ok(boolean c,String m){count++;if(!c)throw new AssertionError(m);}
 static JSONObject nav()throws Exception{return new JSONObject("{\"v\":1,\"sessionId\":\"s1\",\"state\":\"navigating\",\"simulated\":false,\"navAgeMs\":200,\"routeVer\":2,\"loc\":{\"lat\":25.0,\"lng\":121.0,\"acc\":5,\"ageMs\":100,\"bearing\":0,\"speed\":10},\"step\":{\"maneuver\":\"turn\",\"modifier\":\"right\",\"dist\":400,\"time\":30,\"road\":\"中山路\",\"instruction\":\"右轉\"},\"next\":[{\"maneuver\":\"turn\",\"modifier\":\"left\",\"distFromPrev\":600}],\"remain\":{\"dist\":5000,\"time\":500}}");}
 static JSONObject route()throws Exception{return new JSONObject("{\"ver\":2,\"sessionId\":\"s1\",\"pts\":[[24.99,121],[25.01,121],[25.02,121.01]]}");}
 static void rejects(JSONObject n,String reason)throws Exception{try{WideGoogleAdapter.parse(n,route(),1000);ok(false,reason);}catch(JSONException e){ok(true,reason);}}
 public static void main(String[] a)throws Exception{
  WideGoogleAdapter.Snapshot s=WideGoogleAdapter.parse(nav(),route(),1000);
  ok(s.current.getInt("turn_type")==13,"right mapping");ok(s.next.getInt("turn_type")==12,"left mapping");ok(s.next.getInt("distance_m")==600,"receiver expects next gap from current maneuver");ok(s.route.getJSONArray("polyline").getJSONObject(0).getDouble("lon")==121,"lat lon ordering");ok(s.route.getJSONArray("polyline").length()==3,"sparse segment projects correctly");ok(s.vehicle.getDouble("speed_kph")==36,"m/s to km/h");ok(s.value("speed",1000)==null,"no invented limit");ok(s.value("guidance_current",3800)!=null,"TTL boundary");ok(s.value("guidance_current",3801)==null,"source age included");ok(s.value("route",999)==null,"reject backwards monotonic time");
  JSONObject n=nav().put("simulated",true);s=WideGoogleAdapter.parse(n,route(),1000);ok(s.current==null&&s.route==null,"simulation suppressed");
  for(String st:new String[]{"idle","arrived","rerouting","routing","error"}){s=WideGoogleAdapter.parse(nav().put("state",st),route(),1000);ok(s.current==null&&s.route==null,"clear "+st);}
  n=nav();n.remove("navAgeMs");rejects(n,"missing SDK timestamp");rejects(nav().put("navAgeMs",3001),"stale SDK");n=nav();n.getJSONObject("loc").put("ageMs",3001);rejects(n,"stale loc");n=nav();n.getJSONObject("loc").put("acc",100);rejects(n,"poor fix");n=nav();n.getJSONObject("loc").put("lat",91);rejects(n,"invalid latitude");
  s=WideGoogleAdapter.parse(nav(),route().put("ver",3),1000);ok(!s.route.has("polyline"),"reroute version mismatch");
  n=nav();n.getJSONObject("step").put("dist",-1);s=WideGoogleAdapter.parse(n,route(),1000);ok(s.current==null&&s.next==null,"missing distance never becomes zero");
  n=nav();n.getJSONObject("step").put("dist",0);s=WideGoogleAdapter.parse(n,route(),1000);ok(s.current.getInt("distance_m")==0,"zero distance valid");
  ok(WideGoogleAdapter.turn("turn","uturn")==14,"uturn");ok(WideGoogleAdapter.turn("fork","slight_left")==7,"fork not turn");ok(WideGoogleAdapter.turn("off_ramp","right")==101,"off ramp");ok(WideGoogleAdapter.turn("turn","slight_left")==-1,"unsupported slight turn not promoted");ok(WideGoogleAdapter.turn("made_up","left")==-1,"unknown type");
  JSONArray pts=new JSONArray();for(int i=0;i<1000;i++)pts.put(new JSONArray().put(25+i*.00001).put(121));s=WideGoogleAdapter.parse(nav(),new JSONObject().put("ver",2).put("sessionId","s1").put("pts",pts),1000);ok(s.route.getJSONArray("polyline").length()==256,"256 point cap");ok(s.route.getJSONArray("polyline").getJSONObject(255).getDouble("lat")<25.003,"no distant endpoint shortcut");
  s=WideGoogleAdapter.parse(nav(),route().put("sessionId","old"),1000);ok(!s.route.has("polyline"),"server restart does not reuse old route");
  n=nav();n.getJSONArray("next").getJSONObject(0).put("distFromPrev",0);s=WideGoogleAdapter.parse(n,route(),1000);ok(s.next==null,"zero gap cannot be safely represented by pinned receiver");
  n=nav();n.getJSONArray("next").getJSONObject(0).remove("distFromPrev");s=WideGoogleAdapter.parse(n,route(),1000);ok(s.next==null,"missing gap withdraws next");
  n=nav();n.getJSONObject("step").put("dist",90000);n.getJSONArray("next").getJSONObject(0).put("distFromPrev",90000);s=WideGoogleAdapter.parse(n,route(),1000);ok(s.next.getInt("distance_m")==90000,"independently bounded gap not rejected by double sum");
  n=nav();n.getJSONObject("step").put("maneuver","made_up");s=WideGoogleAdapter.parse(n,route(),1000);ok(s.current.getInt("turn_type")==-1,"unknown turn uses explicit receiver invalid code");
  n=nav().put("sessionId","");rejects(n,"empty producer session");
  n=nav();n.remove("simulated");s=WideGoogleAdapter.parse(n,route(),1000);ok(s.current==null&&s.next==null&&s.route==null,"missing simulation provenance withdraws control");
  System.out.println("PASS "+count+" Google bridge checks");
 }
}
