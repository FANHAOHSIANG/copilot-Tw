package com.navipilot.obf;
public class AlertChecks {
 static int checks;
 static void check(boolean b,String name){checks++;if(!b)throw new AssertionError(name);}
 static WideCameraEngine.Fix f(int i,boolean h){return new WideCameraEngine.Fix(25+i*.0001,121,10,0,11.1,1000+i*1000,h,false,true);}
 static WideHcopRoad.Road road(String id,String grade,double lon){WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=id;r.names=new String[]{"道路"};r.grade=grade;r.dir=0;r.start=id.hashCode();r.end=r.start+1;r.xy=new double[][]{{lon,24.99},{lon,25.02}};return r;}
 static WideHcopRoad.Camera cam(String edge,int dir,double lat){WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=edge;c.edge=edge;c.road="測試道路";c.lat=lat;c.lon=121;c.limit=60;c.dirs=new int[]{dir};return c;}
 static WideHcopRoad.Decision run(WideHcopRoad.Data d,boolean intermittent){WideCameraTrace.clear();WideHcopRoad.Decision out=null;for(int i=0;i<8;i++){WideCameraEngine.Fix f=f(i,!intermittent||i%3!=2);WideCameraTrace.update(d,f,f.time);out=WideCameraTrace.display(new WideHcopRoad.Decision("原控制未確認",f.time),f,f.time);}return out;}
 public static void main(String[] args){
  WideAlertMotion m=new WideAlertMotion();int valid=0;for(int i=0;i<10;i++)if(m.accept(f(i,i%3!=2),f(i,true).time)!=null)valid++;check(valid==10,"intermittent heading recovered");
  m.clear();WideCameraEngine.Fix derived=null;for(int i=0;i<8;i++){WideCameraEngine.Fix raw=f(i,false);derived=m.accept(new WideCameraEngine.Fix(raw.lat,raw.lon,10,0,0,raw.time,false,false,false),raw.time);}check(derived!=null&&derived.speed>10,"missing speed and heading use displacement");
  m.clear();for(int i=0;i<8;i++)check(m.accept(new WideCameraEngine.Fix(25+(i%2)*.00001,121,10,0,0,1000+i*1000,false,false,true),1000+i*1000)==null,"stop drift");
  check(m.accept(f(1,true),9000)==null,"stale rejected");
  WideCameraEngine.Fix mock=new WideCameraEngine.Fix(25,121,10,0,10,1000,true,true,true);check(m.accept(mock,1000)==null,"mock rejected");
  check("高架道路".equals(WideCameraTrace.level("1|yes|no")),"elevated");check("平面道路".equals(WideCameraTrace.level("0|no|no")),"surface");check("道路層級未標明".equals(WideCameraTrace.level("-1|no|yes")),"tunnel unknown");check("道路層級未標明".equals(WideCameraTrace.level(null)),"missing grade unknown");
  WideHcopRoad.Data d=new WideHcopRoad.Data();d.roads.add(road("flat","0|no|no",121));d.roads.add(road("high","1|yes|no",121));d.cameras.add(cam("flat",1,25.005));
  WideHcopRoad.Decision o=run(d,true);check(o.camera!=null&&o.camera.road.startsWith("平面道路"),"overlap surface camera");check(WideCameraTrace.voiceKey(o).startsWith("flat:"),"surface voice key");
  check(d.cameras.get(0).road.equals("測試道路"),"controller camera not mutated");
  d.cameras.clear();d.cameras.add(cam("high",1,25.005));o=run(d,true);check(o.camera!=null&&o.camera.road.startsWith("高架道路"),"overlap elevated camera");check(WideCameraTrace.voiceAsset(WideCameraTrace.voiceKey(o)).equals("tw_camera_elevated.mp3"),"elevated clip");
  d.cameras.clear();d.cameras.add(cam("flat",-1,25.005));o=run(d,false);check(o.camera==null,"opposing direction suppressed");
  d.cameras.clear();d.cameras.add(cam("flat",1,24.999));o=run(d,false);check(o.camera==null,"passed point suppressed");
  WideHcopRoad.Tracker control=new WideHcopRoad.Tracker();int confirmed=0;for(int i=0;i<10;i++)if(control.accept(d,f(i,i%3!=2),f(i,true).time).confirmed)confirmed++;check(confirmed==0,"raw controller still rejects ambiguous layers");
  check(WideCameraTrace.voiceAsset("other:id").equals("tw_camera_voice_a.mp3"),"generic A clip retained");
  m.clear();m.accept(f(0,true),1000);m.accept(f(1,true),2000);
  check(m.accept(new WideCameraEngine.Fix(26,121,10,0,0,3000,false,false,false),3000)==null,"jump cannot infer");
  check(m.accept(new WideCameraEngine.Fix(25,121,50,0,20,4000,true,false,true),4000)==null,"bad position accuracy");
  m.clear();for(int i=0;i<5;i++)m.accept(f(i,false),f(i,false).time);
  check(m.accept(new WideCameraEngine.Fix(25.0004,121.0003,10,0,11,6000,false,false,true),6000)==null,"turn rejects stale north heading");
  WideCameraTrace.clear();WideCameraEngine.Fix stopped=new WideCameraEngine.Fix(25,121,10,0,0,20000,false,false,true);
  WideCameraTrace.update(d,stopped,20000);check(WideCameraTrace.display(new WideHcopRoad.Decision("test",20000),stopped,20000).camera==null,"stop clears published alert");
  check(m.accept(new WideCameraEngine.Fix(25,121,10,0,Double.NaN,21000,false,false,true),21000)==null,"invalid reported speed rejected");
  System.out.println("PASS "+checks+" checks: missing direction/speed, stationary drift, stale/mock, grade/voice routing, overlapping layers, opposing/passed cameras, controller unchanged");
 }
}
