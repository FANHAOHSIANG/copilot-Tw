package com.navipilot.obf;
import java.util.*;
public class ForwardChecks {
 static int checks;
 static void check(boolean b,String message){checks++;if(!b)throw new AssertionError(message);}
 static WideHcopRoad.Road road(String id,String name,long start,long end,double[][] xy){
  WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=id;r.names=new String[]{name};r.start=start;r.end=end;r.xy=xy;r.dir=1;r.grade="0|no|no";return r;
 }
 static WideHcopRoad.Camera camera(String id,WideHcopRoad.Road road,double lat,double lon){
  WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=id;c.edge=road.id;c.road=road.names[0];c.dirs=new int[]{1};c.lat=lat;c.lon=lon;c.limit=60;return c;
 }
 static WideHcopRoad.Decision drive(WideHcopRoad.Data data){
  WideCameraTrace.clear();WideHcopRoad.Decision d=null;
  for(int i=0;i<5;i++){WideCameraEngine.Fix f=new WideCameraEngine.Fix(25+i*.0001,121,5,0,11.1,1000+i*1000,true,false,true);WideCameraTrace.update(data,f,f.time);d=WideCameraTrace.display(null,f,f.time);}return d;
 }
 public static void main(String[] args){
  WideHcopRoad.Data d=new WideHcopRoad.Data();
  WideHcopRoad.Road a=road("a","中山路",1,2,new double[][]{{121,24.999},{121,25.005}});
  WideHcopRoad.Road b=road("b","中山路",2,3,new double[][]{{121,25.005},{121,25.022}});
  WideHcopRoad.Road side=road("side","支路",2,4,new double[][]{{121,25.005},{121.005,25.009}});
  d.roads.addAll(Arrays.asList(a,b,side));d.cameras.add(camera("main",b,25.017,121));d.cameras.add(camera("side",side,25.007,121.0025));
  List<WideForwardRoads.Step> s=WideForwardRoads.explore(d,a,1,100);
  check(s.size()==3,"retain both reasonable branches");check(s.get(1).road==b,"same road first");
  WideHcopRoad.Decision out=drive(d);check(out.camera!=null&&out.camera.id.equals("main"),"preferred road camera survives a fork");
  check(out.distance>1500&&out.distance<2000,"2km horizon extends old 1500m limit");
  d.cameras.clear();d.cameras.add(camera("beyond",b,25.021,121));check(drive(d).camera==null,"do not exceed 2km");
  b.dir=-1;check(WideForwardRoads.explore(d,a,1,100).size()==2,"reject opposing one way");b.dir=1;
  side.start=999;check(WideForwardRoads.explore(d,a,1,100).size()==2,"no Euclidean jump to disconnected side road");side.start=2;
  d.cameras.clear();d.cameras.add(camera("branch",side,25.007,121.0025));out=drive(d);check(out.camera!=null&&out.reason.contains("分支"),"branch uncertainty is explicit");
  // Defer a hairpin camera until actual heading agrees; do not infer a U-turn.
  WideHcopRoad.Road curve=road("curve","中山路",2,5,new double[][]{{121,25.005},{121.003,25.006},{121.004,25.004}});
  d.roads.clear();d.roads.addAll(Arrays.asList(a,curve));d.cameras.clear();d.cameras.add(camera("bend",curve,25.0042,121.0039));
  out=drive(d);check(out.camera==null,"defer opposite-facing camera before hairpin");
  WideCameraTrace.clear();
  for(int i=0;i<5;i++){double lat=25.0058-i*.0001,lon=121.003+(25.006-lat)*.5;WideCameraEngine.Fix f=new WideCameraEngine.Fix(lat,lon,5,156,12,1000+i*1000,true,false,true);WideCameraTrace.update(d,f,f.time);out=WideCameraTrace.display(null,f,f.time);}
  check(out.camera!=null&&out.camera.id.equals("bend"),"camera becomes eligible after actual turn");
  d.cameras.get(0).dirs=new int[]{-1};check(drive(d).camera==null,"opposite enforcement direction excluded");
  d.expired=true;check(WideForwardRoads.explore(d,a,1,0).isEmpty(),"expired graph excluded");d.expired=false;
  WideHcopRoad.Road loop=road("loop","中山路",5,1,new double[][]{{121.004,25.004},{121,24.999}});d.roads.add(loop);
  check(WideForwardRoads.explore(d,a,1,0).size()<=3,"loop bounded");
  WideHcopRoad.Road rejoin=road("rejoin","中山路",4,9,new double[][]{{121.005,25.009},{121.005,25.013}});
  d.roads.clear();d.roads.addAll(Arrays.asList(a,side,rejoin));
  check(WideForwardRoads.explore(d,a,1,100).size()==2,"do not predict side-street crossing back onto original road");
  System.out.println("PASS "+checks+" forward-road checks");
 }
}
