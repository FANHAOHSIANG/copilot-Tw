package com.navipilot.obf;
import java.util.*;
public class WideCameraEngineTest {
 static int count;
 static void check(boolean v,String text){count++;if(!v)throw new AssertionError(text);}
 static WideCameraEngine.Fix fix(double lat,double lon,double acc,double heading,double speed,long time,boolean valid,boolean mock){return new WideCameraEngine.Fix(lat,lon,acc,heading,speed,time,valid,mock);}
 static WideCameraEngine.Point point(String id,double lat,double lon,double heading){return new WideCameraEngine.Point(id,id,"測試","",lat,lon,60,new double[]{heading},false);}
 public static void main(String[]args){
  long now=10000;WideCameraEngine.Fix f=fix(25,121,5,0,15,now,true,false);
  WideCameraEngine.Point ahead=point("ahead",25.005,121,0),behind=point("behind",24.998,121,0),opposite=point("opposite",25.002,121,180),parallel=point("parallel",25.003,121.002,0);
  List<WideCameraEngine.Point> p=Arrays.asList(behind,opposite,parallel,ahead);
  WideCameraEngine.Result r=WideCameraEngine.match(p,f,now);
  check(r.point==ahead,"forward direction and corridor");check(r.distance>550&&r.distance<560,"metres");check(r.lateral<1,"lateral metres");
  check(WideCameraEngine.match(p,fix(25,121,5,180,15,now,true,false),now).point==null,"opposite travel excludes front camera");
  check(WideCameraEngine.match(p,fix(25.006,121,5,0,15,now,true,false),now).point==null,"passed camera not selected");
  check(WideCameraEngine.match(p,f,now+5001).point==null,"stale GPS clears candidate");
  check(WideCameraEngine.match(p,f,now-1).point==null,"future timestamp rejected");
  check(WideCameraEngine.match(p,fix(25,121,31,0,15,now,true,false),now).point==null,"poor accuracy rejected");
  check(WideCameraEngine.match(p,fix(25,121,0,0,15,now,true,false),now).point==null,"missing accuracy rejected");
  check(WideCameraEngine.match(p,fix(25,121,5,0,0,now,true,false),now).point==null,"stopped heading rejected");
  check(WideCameraEngine.match(p,fix(25,121,5,0,15,now,false,false),now).point==null,"missing heading rejected");
  check(WideCameraEngine.match(p,fix(25,121,5,0,15,now,true,true),now).point==null,"mock GPS rejected");
  check(WideCameraEngine.match(p,fix(Double.NaN,121,5,0,15,now,true,false),now).point==null,"NaN coordinates rejected");
  check(WideCameraEngine.match(p,fix(25,121,Double.NaN,0,15,now,true,false),now).point==null,"NaN accuracy rejected");
  check(WideCameraEngine.match(p,fix(25,121,5,Double.NaN,15,now,true,false),now).point==null,"NaN heading rejected");
  check(WideCameraEngine.match(p,null,now).point==null,"no fix rejected");
  check(WideCameraEngine.match(Collections.<WideCameraEngine.Point>emptyList(),f,now).point==null,"empty database");
  check(WideCameraEngine.difference(359,1)==2,"wrap heading");
  check(Math.abs(WideCameraEngine.bearing(25,121,25.005,121))<.1,"north bearing");
  check(WideCameraEngine.distance(25,121,25,121)==0,"identical point");
  WideCameraEngine.Point unknown=new WideCameraEngine.Point("unknown","unknown","","雙向",25.002,121,50,new double[0],false);
  r=WideCameraEngine.match(Arrays.asList(unknown),f,now);check(r.point==unknown&&!r.directionKnown,"unknown direction retained as unverified");
  WideCameraEngine.Point conflict=new WideCameraEngine.Point("conflict","conflict","","南向60北向70",25.002,121,60,new double[0],true);
  check(WideCameraEngine.match(Arrays.asList(conflict),f,now).state.contains("速限有差異"),"speed conflict visible");
  check(WideCameraEngine.match(Arrays.asList(point("far",25.02,121,0)),f,now).point==null,"range limit");
  check(WideCameraEngine.demo().point.id.equals("demo"),"demo isolated id");
  check(WideCameraEngine.match(p,fix(25,121,5,0,Double.NaN,now,true,false),now).point==null,"NaN speed rejected");
  check(WideCameraEngine.match(p,fix(25,121,5,360,15,now,true,false),now).point==null,"bearing outside normalized bounds");
  System.out.println("PASS: "+count+" GPS/camera edge cases; control output intentionally absent");
 }
}
