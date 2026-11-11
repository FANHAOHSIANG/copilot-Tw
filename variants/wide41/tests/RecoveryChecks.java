package com.navipilot.obf;
import java.util.*;
public class RecoveryChecks {
 static int n;static void check(boolean b,String s){n++;if(!b)throw new AssertionError(s);}
 static WideCameraEngine.Fix f(int i){return AlertChecks.f(i,true);}
 static WideHcopRoad.Decision empty(long t){return new WideHcopRoad.Decision("等待道路確認",t);}
 public static void main(String[] args){
  WideHcopRoad.Data d=new WideHcopRoad.Data();d.roads.add(AlertChecks.road("r","0|no|no",121));d.cameras.add(AlertChecks.cam("r",1,25.005));
  WideCameraTrace.clear();for(int i=0;i<4;i++)WideCameraTrace.update(d,f(i),f(i).time);
  WideHcopRoad.Decision x=WideCameraTrace.display(empty(f(4).time),f(4),f(4).time);
  check(x.camera!=null,"asynchronous one-fix delay retains camera");check(x.distance<WideCameraTrace.display(empty(f(3).time),f(3),f(3).time).distance,"delayed distance advances");
  check(WideCameraTrace.display(empty(9000),f(4),9000).camera==null,"stale display revoked");
  WideCameraEngine.Fix turn=new WideCameraEngine.Fix(f(4).lat,121,10,180,11,5000,true,false,true);
  check(WideCameraTrace.display(empty(5000),turn,5000).camera==null,"turn removes delayed camera");
  WideHcopRoad.Decision original=empty(f(3).time);original.confirmed=true;original.camera=AlertChecks.cam("original",1,25.005);original.limit=80;original.distance=500;
  d.cameras.clear();WideCameraTrace.clear();for(int i=0;i<4;i++)WideCameraTrace.update(d,f(i),f(i).time);
  x=WideCameraTrace.display(original,f(3),f(3).time);check(x.camera==original.camera,"empty trace cannot erase original camera");check(x.limit==80,"original road speed retained");check(original.reason.equals("等待道路確認"),"controller untouched");
  d.cameras.add(AlertChecks.cam("r",1,25.005));
  for(int i=0;i<20;i++)d.roads.add(AlertChecks.road("parallel"+i,"0|no|no",121+i*.000001));
  WideCameraTrace.clear();for(int i=0;i<5;i++)WideCameraTrace.update(d,f(i),f(i).time);
  check(WideCameraTrace.display(empty(f(4).time),f(4),f(4).time).camera!=null,"21 candidate roads do not reset all history");
  List<WideCameraEngine.Point> points=Arrays.asList(new WideCameraEngine.Point("fallback","測試路","","北",25.005,121,60,new double[]{0},false));
  WideCameraTrace.clear();x=null;for(int i=0;i<4;i++)x=WideCameraTrace.displayPoints(empty(f(i).time),f(i),f(i).time,points);
  check(x.camera!=null&&"candidate".equals(x.source),"unmapped camera has independent directional fallback");
  check(x.distance<1000,"fallback within speech range");check(x.camera.road.contains("未標明"),"unknown layer not invented");
  WideCameraTrace.clear();x=WideCameraTrace.displayPoints(empty(5000),turn,5000,points);check(x.camera==null,"opposite fallback rejected");
  WideCameraEngine.Fix stop=new WideCameraEngine.Fix(25.0003,121,10,0,0,7000,false,false,true);check(WideCameraTrace.displayPoints(empty(7000),stop,7000,points).camera==null,"stop no vicinity false alarm");
  WideCameraTrace.clear();List<WideCameraEngine.Point> unknown=Arrays.asList(new WideCameraEngine.Point("u","路","","",25.005,121,60,new double[0],false));
  for(int i=0;i<4;i++)x=WideCameraTrace.displayPoints(empty(f(i).time),f(i),f(i).time,unknown);
  check(x.camera==null,"unknown enforcement direction not spoken as ahead");
  WideAmapInput.reset();check(WideAmapInput.status("").contains("尚未收到"),"no broadcast status");WideAmapInput.observed("phone",null,"shared",false);
  check(WideAmapInput.status("").contains("過濾 1"),"rejected broadcast visible");WideAmapInput.parsed(-1);check(WideAmapInput.status("").contains("缺少 KEY_TYPE"),"missing decoder type visible");WideAmapInput.forwarded("speed");check(WideAmapInput.status("").contains("speed"),"fresh forwarding stage visible");
  System.out.println("PASS "+n+" recovery checks");
 }
}
