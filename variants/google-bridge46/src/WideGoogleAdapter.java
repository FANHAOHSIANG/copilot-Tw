package com.navipilot.obf;
import org.json.*;
/** Google snapshot -> pinned Carrot Navi v2 receiver contract. No guessed speed limits. */
public final class WideGoogleAdapter {
 public static final long TTL=3000;
 public static final class Snapshot {
  public final JSONObject current,next,route,vehicle,status;public final long received,age;public final String reason;
  Snapshot(JSONObject c,JSONObject n,JSONObject r,JSONObject v,JSONObject s,long at,long age,String why){current=c;next=n;route=r;vehicle=v;status=s;received=at;this.age=age;reason=why;}
  public JSONObject value(String stream,long now){
   if(now<received||now-received+age>TTL)return null;
   if("guidance_current".equals(stream))return current;if("guidance_next".equals(stream))return next;
   if("route".equals(stream))return route;if("vehicle".equals(stream))return vehicle;if("navigation_status".equals(stream))return status;return null;
  }
 }
 static int num(JSONObject o,String key,int max){if(o==null||!(o.opt(key) instanceof Number))return -1;double n=o.optDouble(key,Double.NaN);return Double.isFinite(n)&&n>=0&&n<=max?(int)Math.round(n):-1;}
 static String text(JSONObject o,String k){String s=o.optString(k,"");return s.length()>240?s.substring(0,240):s;}
 public static int turn(String type,String modifier){
  if("arrive".equals(type))return 201;
  if("turn".equals(type)){if("uturn".equals(modifier))return 14;if("left".equals(modifier))return 12;if("right".equals(modifier))return 13;if("sharp_left".equals(modifier))return 16;if("sharp_right".equals(modifier))return 19;}
  if("fork".equals(type)){if(modifier.endsWith("left"))return 7;if(modifier.endsWith("right"))return 6;}
  if("off_ramp".equals(type)){if(modifier.endsWith("left"))return 102;if(modifier.endsWith("right"))return 101;}
  if("roundabout".equals(type))return 142;
  if("straight".equals(type)||"continue".equals(type))return 51;
  return -1; // Unmapped maneuvers are display-only; never invent an actionable turn.
 }
 static JSONObject guidance(JSONObject s,int distance)throws JSONException {
  if(s==null||distance<0||distance>100000)return null;
  return new JSONObject().put("distance_m",distance).put("turn_type",turn(s.optString("maneuver"),s.optString("modifier")))
   .put("road_name",text(s,"road")).put("main_text",text(s,"instruction")).put("near_direction",text(s,"modifier")).put("mid_direction","").put("far_direction","");
 }
 public static Snapshot parse(JSONObject nav,JSONObject geometry,long at)throws JSONException {
  if(nav==null||nav.optInt("v",-1)!=1)throw new JSONException("Unsupported NavDash snapshot");
  String state=nav.optString("state");
  if(nav.optString("sessionId","").isEmpty())throw new JSONException("Missing producer session");
  if(!Boolean.FALSE.equals(nav.opt("simulated"))||!"navigating".equals(state))return new Snapshot(null,null,null,null,new JSONObject().put("mode","idle").put("guidance_active",false).put("route_present",false),at,0,"未導航／重新規劃／模擬，撤銷資料");
  int navAge=num(nav,"navAgeMs",3000);JSONObject loc=nav.optJSONObject("loc");int locAge=num(loc,"ageMs",3000);
  if(navAge<0||locAge<0)throw new JSONException("SDK guidance/location missing or stale");
  double lat=loc.optDouble("lat",Double.NaN),lon=loc.optDouble("lng",Double.NaN),acc=loc.optDouble("acc",Double.NaN);
  if(!coordinate(lat,lon)||!Double.isFinite(acc)||acc<0||acc>50)throw new JSONException("Invalid snapped location");
  JSONObject step=nav.optJSONObject("step");int distance=num(step,"dist",100000);JSONObject current=guidance(step,distance),next=null;
  if(current!=null){int time=num(step,"time",86400);if(time>=0)current.put("time_sec",time);}
  // Carrot adds current distance to guidance_next. Send the inter-step gap once;
  // zero cannot be represented by its >0 next-distance gate, so withdraw next instead.
  JSONArray upcoming=nav.optJSONArray("next");
  if(current!=null&&upcoming!=null&&upcoming.length()>0){JSONObject n=upcoming.optJSONObject(0);int gap=num(n,"distFromPrev",100000);if(gap>0)next=guidance(n,gap);}
  JSONObject vehicle=new JSONObject().put("lat",lat).put("lon",lon).put("virtual_gps",false).put("road_name",step==null?"":text(step,"road"));
  double bearing=loc.optDouble("bearing",Double.NaN),speed=loc.optDouble("speed",Double.NaN);
  if(Double.isFinite(bearing)&&bearing>=0&&bearing<360)vehicle.put("heading_deg",bearing);
  if(Double.isFinite(speed)&&speed>=0&&speed<=100)vehicle.put("speed_kph",speed*3.6);
  JSONObject route=null;JSONObject remain=nav.optJSONObject("remain");int remD=num(remain,"dist",20000000),remT=num(remain,"time",604800);
  if(remD>=0&&remT>=0){route=new JSONObject().put("remain_distance_m",remD).put("remain_time_sec",remT);
   if(geometry!=null&&nav.getString("sessionId").equals(geometry.optString("sessionId"))&&nav.has("routeVer")&&geometry.optLong("ver",-2)==nav.optLong("routeVer",-1)){
    JSONArray pts=geometry.optJSONArray("pts");JSONArray out=polyline(pts,lat,lon);if(out!=null)route.put("polyline",out);
   }
  }
  JSONObject status=new JSONObject().put("mode","guiding").put("guidance_active",current!=null).put("off_route",false).put("route_present",route!=null);
  return new Snapshot(current,next,route,vehicle,status,at,Math.max(navAge,locAge),"Google SDK 資料有效");
 }
 static boolean coordinate(double lat,double lon){return Double.isFinite(lat)&&Double.isFinite(lon)&&Math.abs(lat)<=90&&Math.abs(lon)<=180;}
 static JSONArray polyline(JSONArray pts,double lat,double lon)throws JSONException {
  if(pts==null||pts.length()<2||pts.length()>100000)return null;
  int nearest=-1;double best=Double.POSITIVE_INFINITY,sx=111320*Math.cos(Math.toRadians(lat));
  for(int i=0;i<pts.length();i++){JSONArray p=pts.optJSONArray(i);if(p==null||p.length()!=2||!coordinate(p.optDouble(0,Double.NaN),p.optDouble(1,Double.NaN)))return null;}
  for(int i=0;i<pts.length()-1;i++){JSONArray a=pts.getJSONArray(i),b=pts.getJSONArray(i+1);
   double ax=(a.getDouble(1)-lon)*sx,ay=(a.getDouble(0)-lat)*111320,bx=(b.getDouble(1)-lon)*sx,by=(b.getDouble(0)-lat)*111320,dx=bx-ax,dy=by-ay,l=dx*dx+dy*dy;
   double t=l>0?Math.max(0,Math.min(1,-(ax*dx+ay*dy)/l)):0,d=Math.pow(ax+t*dx,2)+Math.pow(ay+t*dy,2);if(d<best){best=d;nearest=i;}}
  if(best>100*100)return null;
  JSONArray out=new JSONArray();for(int i=Math.max(0,nearest);i<pts.length()&&out.length()<256;i++){JSONArray p=pts.getJSONArray(i);out.put(new JSONObject().put("lat",p.getDouble(0)).put("lon",p.getDouble(1)));}
  return out.length()>=2?out:null;
 }
}
