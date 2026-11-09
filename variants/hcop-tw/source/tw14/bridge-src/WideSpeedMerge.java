package com.navipilot.obf;
import org.json.*;
/** Wire-schema-specific pure merge, tested against the actual C4 normalizer. */
public final class WideSpeedMerge {
 public static JSONObject merge(JSONObject original,boolean originalFresh,WideRoad.Match match)throws JSONException{
  JSONObject out=original!=null&&originalFresh?new JSONObject(original.toString()):new JSONObject();
  out.remove("sdi");out.remove("sdi_secondary");out.remove("section");
  if(match!=null&&match.camera!=null){
   JSONObject sdi=new JSONObject();sdi.put("type",1);sdi.put("distance_m",Math.round(match.distance));sdi.put("speed_limit_kph",match.camera.limit);
   sdi.put("section_type",-1);sdi.put("block_type",-1);sdi.put("block_speed_kph",0);sdi.put("block_distance_m",0);out.put("sdi",sdi);
  }
  return out.length()==0?null:out;
 }
}
