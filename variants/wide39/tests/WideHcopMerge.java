package com.navipilot.obf;
import org.json.*;
/** Road limits and camera limits are distinct fields in the existing Navi v2 speed stream. */
public final class WideHcopMerge {
 public static JSONObject merge(JSONObject original,boolean fresh,WideHcopRoad.Decision d)throws JSONException{
  JSONObject out=original!=null&&fresh?new JSONObject(original.toString()):new JSONObject();
  out.remove("sdi");out.remove("sdi_secondary");out.remove("section");
  // Taiwan mode owns road_limit too: no hidden fallback to a different source when matching fails.
  out.remove("road_limit_kph");
  if(d!=null&&d.confirmed){
   if(d.limit>0)out.put("road_limit_kph",d.limit);
   if(d.camera!=null&&d.distance>20&&d.distance<=1500){
    JSONObject s=new JSONObject();s.put("type",1);s.put("speed_limit_kph",d.camera.limit);s.put("distance_m",Math.round(d.distance));
    s.put("section_type",-1);s.put("block_type",-1);s.put("block_speed_kph",0);s.put("block_distance_m",0);out.put("sdi",s);
   }
  }
  return out.length()==0?null:out;
 }
}
