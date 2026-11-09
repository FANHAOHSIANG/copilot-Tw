package com.navipilot.obf;
import java.util.*;import org.json.*;import java.nio.file.*;
public class WideHcopTest {
 static int count;static void ok(boolean b,String n){if(!b)throw new AssertionError(n);count++;}
 static WideCameraEngine.Fix fix(double lat,long t,double h,double speed){return new WideCameraEngine.Fix(lat,121,6,h,speed,t,true,false);}
 static WideHcopRoad.Road road(String id,double lon){WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=id;r.names=new String[]{"測試路"};r.grade="0|no|no";r.dir=1;r.forward=50;r.backward=40;r.start=id.hashCode();r.end=r.start+1;r.xy=new double[][]{{lon,24},{lon,24.02}};return r;}
 static WideHcopRoad.Official sign(int limit){WideHcopRoad.Official o=new WideHcopRoad.Official();o.names=new String[]{"測試路"};o.limit=limit;o.xy=new double[][]{{121,24},{121,24.02}};return o;}
 static WideHcopRoad.Camera cam(String id,double lat,int limit){WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=id;c.edge="one";c.road="測試路";c.limit=limit;c.lat=lat;c.lon=121;c.dirs=new int[]{1};return c;}
 static WideHcopRoad.Data data(){WideHcopRoad.Data d=new WideHcopRoad.Data();d.roads.add(road("one",121));return d;}
 static WideHcopRoad.Decision m(WideHcopRoad.Data d){return WideHcopRoad.match(d,fix(24.006,10000,0,10),10000);}
 public static void main(String[] args)throws Exception {
  WideHcopRoad.Data d=data();ok(m(d).limit==50&&m(d).source.equals("OSM"),"OSM base");
  d.signs.add(sign(60));ok(m(d).limit==60&&m(d).source.equals("TDX"),"TDX overrides OSM");
  d.cameras.add(cam("camera",24.007,70));ok(m(d).limit==70&&m(d).source.equals("NPA"),"local NPA overrides");
  ok(m(d).camera!=null&&m(d).distance>100&&m(d).distance<120,"camera along road");
  d.cameras.add(cam("conflict",24.0071,60));ok(m(d).limit==0,"NPA conflict withdrawn");
  d.cameras.clear();d.signs.add(sign(80));ok(m(d).limit==0,"TDX conflict withdrawn");
  d.signs.remove(1);d.signs.get(0).names=new String[]{"別條路"};ok(m(d).limit==50,"TDX requires name");
  d.signs.get(0).names=new String[]{"測試路"};d.signs.get(0).xy=new double[][]{{121,24.02},{121,24}};ok(m(d).limit==50,"TDX requires direction");
  d.signs.get(0).xy=new double[][]{{121.001,24},{121.001,24.02}};ok(m(d).limit==50,"TDX requires geometry");
  d=data();d.cameras.add(cam("far",24.014,60));ok(m(d).limit==50&&m(d).camera!=null,"camera is not whole road limit");
  d.cameras.get(0).dirs=new int[]{-1};ok(m(d).camera==null,"camera wrong direction");
  d.cameras.get(0).dirs=new int[]{1};d.cameras.get(0).edge="another";ok(m(d).camera==null,"camera wrong edge");
  d.cameras.clear();d.cameras.add(cam("passed",24.0059,60));ok(m(d).camera==null,"passed camera withdrawn");
  d=data();WideHcopRoad.Road other=road("other",121.00005);d.roads.add(other);ok(m(d).road==null,"parallel road rejected");
  other.grade="1|yes|no";other.dir=-1;ok(m(d).road==null,"stacked roads rejected despite direction");
  d=data();d.expired=true;ok(m(d).road==null,"expired dataset rejected");
  d=data();ok(WideHcopRoad.match(d,fix(24.006,10000,180,10),10000).road==null,"oneway reverse rejected");
  d.roads.get(0).dir=0;ok(WideHcopRoad.match(d,fix(24.006,10000,180,10),10000).limit==40,"directional OSM limit");
  ok(WideHcopRoad.invalid(fix(24.006,10000,0,10),13001)!=null,"stale GPS");
  ok(WideHcopRoad.invalid(fix(24.006,10001,0,10),10000)!=null,"future GPS");
  ok(WideHcopRoad.invalid(fix(24.006,10000,360,10),10000)!=null,"invalid heading");
  ok(WideHcopRoad.invalid(fix(24.006,10000,Double.NaN,10),10000)!=null,"NaN heading");
  ok(WideHcopRoad.invalid(fix(24.006,10000,0,0),10000)!=null,"stopped withdraw");
  ok(WideHcopRoad.invalid(new WideCameraEngine.Fix(24,121,16,0,10,10000,true,false),10000)!=null,"poor accuracy");
  ok(WideHcopRoad.invalid(new WideCameraEngine.Fix(24,121,6,0,10,10000,true,true),10000)!=null,"mock rejected");
  ok(WideHcopRoad.invalid(fix(Double.NaN,10000,0,10),10000)!=null,"NaN position");
  d=data();WideHcopRoad.Tracker t=new WideHcopRoad.Tracker();ok(!t.accept(d,fix(24.006,10000,0,10),10000).confirmed,"first sample waits");
  ok(!t.accept(d,fix(24.0061,11000,0,10),11000).confirmed,"second sample waits");
  WideHcopRoad.Decision confirmed=t.accept(d,fix(24.0062,12000,0,10),12000);ok(confirmed.confirmed,"three moving samples pass");
  ok(!t.accept(d,fix(24.0062,12000,0,10),12000).confirmed,"duplicate GPS resets");
  t.reset();for(int i=0;i<5;i++)ok(!t.accept(d,fix(24.006,10000+i*1000,0,10),10000+i*1000).confirmed,"stationary coordinates do not prove road");
  t.reset();t.accept(d,fix(24.006,10000,0,10),10000);ok(!t.accept(d,fix(24.015,11000,0,10),11000).confirmed,"GPS jump resets");
  JSONObject original=new JSONObject("{\"road_limit_kph\":90,\"current_kph\":55,\"sdi\":{\"type\":7},\"sdi_secondary\":{},\"section\":{}}");
  JSONObject merged=WideHcopMerge.merge(original,true,confirmed);ok(merged.getInt("road_limit_kph")==50,"road output");
  ok(merged.getInt("current_kph")==55&&!merged.has("sdi")&&!merged.has("section"),"preserve fresh speed, clear prior cameras");
  ok(original.getInt("road_limit_kph")==90&&original.has("sdi"),"original immutable");
  merged=WideHcopMerge.merge(original,false,confirmed);ok(!merged.has("current_kph"),"stale source not refreshed");
  ok(WideHcopMerge.merge(original,false,new WideHcopRoad.Decision("bad",10000))==null,"invalid fully withdraws");
  ok(!WideHcopMerge.merge(original,true,new WideHcopRoad.Decision("bad",10000)).has("road_limit_kph"),"no hidden Amap road fallback");
  confirmed.camera=cam("test",24.007,60);confirmed.distance=445;
  merged=WideHcopMerge.merge(original,false,confirmed);ok(merged.getInt("road_limit_kph")==50&&merged.getJSONObject("sdi").getInt("speed_limit_kph")==60,"camera and road independent");
  Files.write(Paths.get("work/build/hcop-wire.json"),merged.toString(2).getBytes("UTF-8"));
  confirmed.limit=0;ok(!WideHcopMerge.merge(null,false,confirmed).has("road_limit_kph"),"camera never masquerades as road");
  System.out.println("PASS "+count+" matcher, freshness, conflict and merge assertions");
 }
}
