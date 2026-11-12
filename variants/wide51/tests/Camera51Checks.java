package com.navipilot.obf;
import java.util.*;
public final class Camera51Checks {
 static int count;static void ok(boolean b,String msg){count++;if(!b)throw new AssertionError(msg);}
 static WideHcopRoad.Road road(String id,double y,long start,long end){WideHcopRoad.Road r=new WideHcopRoad.Road();r.id=id;r.start=start;r.end=end;r.dir=0;r.grade="0|0|0";r.names=new String[]{"公道路"};r.xy=new double[][]{{121.015,y},{121.045,y}};return r;}
 static WideCameraEngine.Point point(boolean uncertain){return new WideCameraEngine.Point(uncertain?"bb3c86d11fbe09e8":"normal","公道路616號前","新竹縣","東往西",24.78785,121.03028,50,new double[]{270},false);}
 static WideCameraEngine.Fix fix(double meters,int heading,long t,double offset){return new WideCameraEngine.Fix(24.78785+offset/111195,121.03028+(heading==270?1:-1)*meters/(111195*Math.cos(Math.toRadians(24.78785))),5,heading,11,t,true,false,true);}
 static WideHcopRoad.Data graph(boolean parallel){WideHcopRoad.Data d=new WideHcopRoad.Data();d.roads.add(road("main",24.78785,1,2));if(parallel)d.roads.add(road("parallel",24.78785+40/111195.,3,4));return d;}
 static WideHcopRoad.Decision run(boolean uncertain,int heading,double offset,WideHcopRoad.Data data){WideCameraFallback.clear();WideCameraRoadGate.clear();WideHcopRoad.Decision out=null;for(int i=0;i<4;i++){long t=10000+i*1000;if(data!=null)WideCameraRoadGate.update(data,t);out=WideCameraFallback.match(Arrays.asList(point(uncertain)),fix(500-i*11,heading,t,offset),t);}return out;}
 public static void main(String[] args){
  for(int h:new int[]{90,270}){ok(run(true,h,0,graph(false))==null,"disputed point never promoted to confirmed");ok(WideCameraFallback.advisory(13000)!=null,"disputed both approaches advisory");ok(WideCameraFallback.advisory(13000).reason.startsWith("前方"),"same road evidence");}
  ok(run(false,270,0,graph(false))!=null,"known correct direction same road");ok(run(false,90,0,graph(false))==null&&WideCameraFallback.advisory(13000)==null,"known reverse excluded");
  ok(run(true,90,0,null)==null&&WideCameraFallback.advisory(13000).reason.startsWith("附近"),"no graph only nearby reference");
  ok(run(false,270,40,graph(true))==null&&WideCameraFallback.advisory(13000)==null,"parallel 40m road excluded");
  run(true,90,0,graph(false));WideCameraFallback.match(Arrays.asList(point(true)),fix(-40,90,14000,0),14000);ok(WideCameraFallback.advisory(14000)==null,"passed target removed");
  run(true,90,0,null);WideCameraFallback.match(Arrays.asList(point(true)),fix(450,270,14000,0),18000);ok(WideCameraFallback.advisory(18000)==null,"stale fix removed");
  run(true,90,0,null);ok(WideCameraFallback.advisory(17000)==null,"advisory expires without updates");
  WideCameraFallback.clear();WideCameraRoadGate.clear();WideCameraEngine.Fix f=fix(500,90,10000,0);WideCameraFallback.match(Arrays.asList(point(true)),f,10000);WideCameraFallback.match(Arrays.asList(point(true)),f,11000);ok(WideCameraFallback.advisory(11000)==null,"same fix cannot create approach");
  run(true,90,0,null);WideCameraFallback.match(Arrays.asList(point(true)),new WideCameraEngine.Fix(24.78785,121.027,5,90,0,14000,true,false,true),14000);ok(WideCameraFallback.advisory(14000)==null,"stop revokes advisory");
  WideHcopRoad.Data d=graph(false);d.expired=true;run(true,90,0,d);ok(WideCameraFallback.advisory(13000).reason.startsWith("附近"),"expired road graph not confirmed");
  System.out.println("PASS "+count+" camera51 checks");
 }
}
