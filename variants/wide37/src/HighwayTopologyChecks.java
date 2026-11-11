package com.navipilot.obf;
public class HighwayTopologyChecks {
 static void check(boolean b,String m){if(!b)throw new AssertionError(m);}
 static WideHcopRoad.Road r(String id,double start,double end,long a,long b){WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=id;r.names=new String[]{"主線"};r.grade="0|no|no";r.dir=1;r.start=a;r.end=b;r.xy=new double[][]{{121,start},{121,end}};return r;}
 static WideCameraEngine.Fix f(double lat,long t){return new WideCameraEngine.Fix(lat,121,8,0,20,t,true,false,true);}
 static WideHcopRoad.Decision query(WideHcopRoad.Data data,WideHcopRoad.Road road,double lat){WideCameraEngine.Fix f=f(lat,3000);WideCameraTrace.update(data,f,3000);WideHcopRoad.Decision original=new WideHcopRoad.Decision("test",3000);original.confirmed=true;original.road=road;original.direction=1;return WideCameraTrace.display(original,f,3000);}
 public static void main(String[] args){
  WideHcopRoad.Data d=new WideHcopRoad.Data();WideHcopRoad.Road a=r("a",25,25.001,1,2),b=r("b",25.001,25.0011,2,3),c=r("c",25.0011,25.01,3,4);d.roads.add(a);d.roads.add(b);d.roads.add(c);
  WideHcopRoad.Camera cam=new WideHcopRoad.Camera();cam.id="test";cam.edge="c";cam.lat=25.007;cam.lon=121;cam.dirs=new int[]{1};d.cameras.add(cam);
  WideHcopRoad.Decision m=query(d,a,25.0004);check(m.camera==cam && m.distance>700 && m.distance<750,"search through two connected segments using along-road distance");
  WideHcopRoad.Road fork=r("fork",25.001,25.002,2,5);d.roads.add(fork);check(query(d,a,25.0004).camera==null,"stop at ambiguous fork");d.roads.remove(fork);
  b.start=90;check(query(d,a,25.0004).camera==null,"do not jump disconnected nearby road");b.start=2;
  c.names=new String[]{"高架道路"};check(query(d,a,25.0004).camera==null,"do not switch surface and elevated route");c.names=new String[]{"主線"};
  cam.dirs=new int[]{-1};check(query(d,a,25.0004).camera==null,"opposing camera direction");cam.dirs=new int[]{1};
  check(query(d,c,25.008).camera==null,"passed camera suppressed");
  WideCameraTrace trace=new WideCameraTrace();trace.accept(d,f(25.0007,1000),1000);trace.accept(d,f(25.00088,2000),2000);m=trace.accept(d,f(25.00124,4000),4000);check(m!=null&&m.camera==cam,"history survives skipped short segment");
  for(WideHcopRoad.Camera x:WideHighwayAlertData.CAMERAS)check(!x.road.contains("34.4"),"uncertain ramp not inserted");
  System.out.println("PASS multi-edge, fork, disconnect, elevated, opposing, passed, skipped short edge, uncertain ramp");
 }
}
