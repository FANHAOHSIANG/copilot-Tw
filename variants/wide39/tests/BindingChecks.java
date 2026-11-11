package com.navipilot.obf;
import org.json.JSONObject;
public final class BindingChecks {
 static int count;
 static void check(boolean result){count++;if(!result)throw new AssertionError("case "+count);}
 static JSONObject original(int speed, Integer target){return WideAmapPreAdjust.mark(new JSONObject().put("road_limit_kph",speed),target);}
 static int limit(JSONObject value){return value==null?-1:value.optInt("road_limit_kph",-1);}
 public static void main(String[] args) throws Exception {
  JSONObject a=original(60,60), tw=new JSONObject().put("road_limit_kph",100).put("sdi",new JSONObject().put("speed_limit_kph",50).put("distance_m",900));
  JSONObject r=WideAmapPreAdjust.finish(a,tw,10000,11000);
  check(limit(r)==60);check(r.getJSONObject("sdi").getInt("speed_limit_kph")==50);check(r.getJSONObject("sdi").getInt("distance_m")==900);check(!r.has(WideAmapPreAdjust.KEY));check(limit(tw)==100);
  check(limit(WideAmapPreAdjust.finish(original(100,100),new JSONObject().put("road_limit_kph",60),10000,11000))==60);
  check(limit(WideAmapPreAdjust.finish(a,new JSONObject().put(WideAmapPreAdjust.KEY,60),10000,11000))==60);
  check(limit(WideAmapPreAdjust.finish(a,tw,10000,12001))==100);
  check(limit(WideAmapPreAdjust.finish(a,tw,11001,11000))==100);
  check(limit(WideAmapPreAdjust.finish(a,tw,0,11000))==100);
  check(limit(WideAmapPreAdjust.finish(original(60,null),tw,10000,11000))==100);
  check(limit(WideAmapPreAdjust.finish(original(60,80),tw,10000,11000))==100);
  check(limit(WideAmapPreAdjust.finish(original(0,0),tw,10000,11000))==100);
  check(limit(WideAmapPreAdjust.finish(original(65,65),tw,10000,11000))==100);
  check(limit(WideAmapPreAdjust.finish(original(210,210),tw,10000,11000))==100);
  check(WideAmapPreAdjust.finish(a,null,10000,11000)==null);
  check(limit(WideAmapPreAdjust.finish(null,tw,10000,11000))==100);
  check(limit(WideAmapPreAdjust.finish(a,tw,10000,12000))==60);
  check(WideAmapPreAdjust.mark(null,60)==null);
  check(limit(WideAmapPreAdjust.finish(a,a,10000,11000))==60);
  check(WideAmapPreAdjust.finish(null,new JSONObject().put(WideAmapPreAdjust.KEY,60),10000,11000)==null);
  WideHcopRoad.Decision d=new WideHcopRoad.Decision(); d.confirmed=true; d.limit=100;d.camera=new WideHcopRoad.Camera();d.camera.limit=50;d.distance=900;
  JSONObject merged=WideHcopMerge.merge(a,true,d);
  check(limit(WideAmapPreAdjust.finish(a,merged,10000,11000))==60);
  check(WideAmapPreAdjust.finish(a,merged,10000,11000).getJSONObject("sdi").getInt("speed_limit_kph")==50);
  check(limit(WideAmapPreAdjust.finish(a,WideHcopMerge.merge(a,true,null),10000,11000))==60);
  check(WideAmapPreAdjust.finish(a,WideHcopMerge.merge(a,false,null),10000,12001)==null);
  check(limit(WideAmapPreAdjust.finish(null,WideHcopMerge.merge(null,false,d),10000,11000))==100);
  System.out.println("PASS "+count+" binding, lower-limit arbitration, camera preservation, expiry, invalid target, revocation and provenance cases");
 }
}
