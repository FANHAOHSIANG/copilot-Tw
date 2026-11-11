package com.navipilot.obf;
import java.util.*;
public class ToleranceChecks {
 static int checks;
 static void check(boolean b,String s){checks++;if(!b)throw new AssertionError(s);}
 static WideCameraEngine.Fix f(int i,double acc,boolean heading,double speed){return new WideCameraEngine.Fix(25+i*.0001,121,acc,0,speed,1000+i*1000,heading,false,true);}
 static List<WideCameraEngine.Point> ps=Arrays.asList(ScenarioAudit.p("unknown",25.004,false),ScenarioAudit.p("A",25.005,true),ScenarioAudit.p("B",25.011,true));
 static WideHcopRoad.Decision run(WideCameraEngine.Fix f,long now){return WideCameraTrace.displayPoints(new WideHcopRoad.Decision("no roads",f.time),f,now,ps);}
 public static void main(String[] args){
  WideCameraTrace.clear();run(f(0,10,true,11),1000);check(run(f(1,10,true,11),2000).camera.id.equals("A"),"unknown cannot occlude A");
  check(run(f(2,31,true,11),3000).camera==null,"bad fix has no alert");check(run(f(3,10,true,11),4000).camera!=null,"good fix resumes retained history");
  check(run(f(3,10,true,11),8000).camera==null,"stale fix has no alert");
  WideCameraTrace.clear();int hits=0;for(int i=0;i<12;i++){WideCameraEngine.Fix v=f(i,i%2==0?10:31,true,11);if(run(v,v.time).camera!=null)hits++;}check(hits>0,"alternating accuracy recovers");
  WideCameraTrace.clear();hits=0;for(int i=0;i<10;i++){WideCameraEngine.Fix v=new WideCameraEngine.Fix(25+i*.0004,121,10,0,11.12,1000+i*4000,false,false,true);if(run(v,v.time).camera!=null)hits++;}check(hits>0,"4s cadence heading recovery");
  WideCameraTrace.clear();hits=0;for(int i=0;i<50;i++){WideCameraEngine.Fix v=new WideCameraEngine.Fix(25+i*.000018,121,20,0,2,1000+i*1000,false,false,true);if(run(v,v.time).camera!=null)hits++;}check(hits>0,"slow motion eventually resolves");
  WideCameraTrace.clear();run(f(0,10,true,11),1000);run(f(1,10,true,11),2000);
  WideCameraEngine.Fix back=new WideCameraEngine.Fix(25.0002,121,10,180,11,3000,true,false,true);check(run(back,3000).camera==null,"U turn revokes target immediately");
  WideCameraEngine.Fix side=new WideCameraEngine.Fix(25.0002,121,10,90,11,4000,true,false,true);check(run(side,4000).camera==null,"90 degree turn revokes north camera");
  WideCameraEngine.Fix far=new WideCameraEngine.Fix(25,121.002,10,0,11,5000,true,false,true);check(run(far,5000).camera==null,"parallel road 200m offset rejected");
  WideCameraTrace.clear();Set<String> ids=new HashSet<>();for(int i=0;i<100;i++){WideCameraEngine.Fix v=f(i,10,true,11);WideHcopRoad.Decision d=run(v,v.time);if(d.camera!=null)ids.add(d.camera.id);}check(ids.containsAll(Arrays.asList("A","B")),"consecutive cameras independently tracked");
  WideCameraTrace.clear();run(f(0,10,true,11),1000);run(f(1,10,true,11),2000);
  WideCameraEngine.Fix fresh=new WideCameraEngine.Fix(25.001,121,10,0,11,20000,true,false,true);check(run(fresh,20000).camera==null,"long gap requires reconfirmation");
  WideCameraTrace.clear();WideCameraEngine.Fix raw=f(0,10,true,11);run(raw,raw.time);check(run(raw,raw.time).camera==null,"repeated same fix does not manufacture samples");
  WideCameraTrace.clear();WideHcopRoad.Decision u=null;for(int i=0;i<4;i++)u=WideCameraTrace.displayPoints(new WideHcopRoad.Decision("",f(i,10,true,11).time),f(i,10,true,11),f(i,10,true,11).time,Arrays.asList(ps.get(0)));check(u.camera==null&&u.reason.contains("方向未確認"),"unknown point proximity text only");
  WideAlertMotion m=new WideAlertMotion();for(int i=0;i<35;i++)m.accept(new WideCameraEngine.Fix(25+i*.000018,121,20,0,2,1000+i*1000,false,false,true),1000+i*1000);
  WideCameraEngine.Fix end=null;for(int i=1;i<=16;i++)end=m.accept(new WideCameraEngine.Fix(25+34*.000018,121+i*.000020,20,0,2,35000+i*1000,false,false,true),35000+i*1000);check(end==null||WideCameraEngine.difference(end.heading,90)<35,"slow turn does not preserve north direction");
  System.out.println("PASS "+checks+" tolerance checks");
 }
}
