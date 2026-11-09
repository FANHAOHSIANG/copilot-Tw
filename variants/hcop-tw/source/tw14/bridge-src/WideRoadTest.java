package com.navipilot.obf;
import java.util.*;
import org.json.*;
public final class WideRoadTest {
 static int count;static void check(boolean b,String name){if(!b)throw new AssertionError(name);count++;}
 static WideRoad.Corridor corridor(){WideRoad.Corridor c=new WideRoad.Corridor();c.id="test";c.osm=1;c.limit=50;c.lat=24.008;c.lon=121;c.dirs=new int[]{1};c.xy=new double[][]{{121,24},{121,24.01}};c.others=new double[0][][];return c;}
 static WideCameraEngine.Fix fix(double lat,long t,double heading,double accuracy){return new WideCameraEngine.Fix(lat,121,accuracy,heading,10,t,true,false);}
 public static void main(String[] args)throws Exception{
  WideRoad.Corridor c=corridor();List<WideRoad.Corridor> list=Arrays.asList(c);WideCameraEngine.Fix f=fix(24.004,10000,0,5);
  WideRoad.Match m=WideRoad.match(list,f,10000);check(m.camera==c&&m.distance>440&&m.distance<450,"along-road distance");
  check(WideRoad.match(list,f,15001).camera==null,"stale");check(WideRoad.match(list,f,9999).camera==null,"future");
  check(WideRoad.match(list,fix(24.004,10000,180,5),10000).camera==null,"opposite direction");check(WideRoad.match(list,fix(24.004,10000,0,16),10000).camera==null,"poor accuracy");
  check(WideRoad.match(list,fix(24.0081,10000,0,5),10000).camera==null,"passed camera");
  check(WideRoad.match(list,fix(24.00005,10000,0,5),10000).camera==null,"junction edge margin");
  c.others=new double[][][]{{{121.00005,24},{121.00005,24.01}}};check(WideRoad.match(list,f,10000).camera==null,"parallel road");
  c.others=new double[][][]{{{121,24},{121,24.01}}};check(WideRoad.match(list,f,10000).camera==null,"stacked road");c.others=new double[0][][];
  WideRoad.Tracker tracker=new WideRoad.Tracker();check(tracker.accept(list,fix(24.004,10000,0,5),10000).camera==null,"first fix held");check(tracker.accept(list,fix(24.00409,11000,0,5),11000).camera==null,"second held");check(tracker.accept(list,fix(24.00418,12000,0,5),12000).camera==c,"third stable accepted");check(tracker.accept(list,fix(24.00418,12000,0,5),12000).camera==null,"duplicate fix rejected");
  tracker.reset();tracker.accept(list,fix(24.004,10000,0,5),10000);check(tracker.accept(list,fix(24.007,11000,0,5),11000).camera==null,"jump resets");
  check(tracker.accept(list,fix(24.0071,18000,0,5),18000).camera==null,"gap resets");
  c.xy=new double[][]{{121,24},{121,24.005},{121.005,24.005}};c.lat=24.005;c.lon=121.004;
  WideRoad.Match curve=WideRoad.match(list,fix(24.001,10000,0,5),10000);check(curve.camera!=null&&curve.distance>800&&curve.distance>WideCameraEngine.distance(24.001,121,c.lat,c.lon)+150,"curve uses polyline not chord");
  JSONObject original=new JSONObject("{\"current_kph\":42,\"road_limit_kph\":60,\"sdi\":{\"type\":7,\"speed_limit_kph\":90},\"sdi_secondary\":{\"type\":8},\"section\":{\"active\":true}}");String before=original.toString();
  JSONObject out=WideSpeedMerge.merge(original,true,m);check(original.toString().equals(before),"does not mutate Amap");check(out.getInt("road_limit_kph")==60&&out.getInt("current_kph")==42,"retains fresh road speed");check(out.getJSONObject("sdi").getInt("speed_limit_kph")==50,"camera limit distinct");check(!out.has("sdi_secondary")&&!out.has("section"),"no competing camera source");
  JSONObject cleared=WideSpeedMerge.merge(original,true,null);check(!cleared.has("sdi")&&cleared.has("road_limit_kph"),"stale match clears camera only");
  JSONObject expired=WideSpeedMerge.merge(original,false,m);check(!expired.has("road_limit_kph")&&!expired.has("current_kph"),"does not refresh stale Amap fields");check(WideSpeedMerge.merge(original,false,null)==null,"all stale withdraws");
  check(WideSpeedMerge.merge(null,false,m).getJSONObject("sdi").getInt("type")==1,"GPS match without Amap speed");
  java.nio.file.Files.write(java.nio.file.Paths.get("bridge-build/merged-test.json"),out.toString().getBytes("UTF-8"));
  System.out.println("PASS "+count+" road/merge cases");
 }
}
