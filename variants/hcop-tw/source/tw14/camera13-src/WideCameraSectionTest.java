package com.navipilot.obf;
import java.util.*;
public final class WideCameraSectionTest {
 static int n;static void ok(boolean value,String message){n++;if(!value)throw new AssertionError(message);}
 static WideCameraEngine.Fix f(double lat,long t){return new WideCameraEngine.Fix(lat,121,5,0,20,t,true,false);}
 static WideCameraSection.Section sec=new WideCameraSection.Section("s","test","test",25,121,25.009,121,1001,60);
 static WideCameraSection engine(){WideCameraSection e=new WideCameraSection();e.setSections(Arrays.asList(sec));return e;}
 static WideCameraSection entered(){WideCameraSection e=engine();e.accept(f(24.9999,10000),10000);e.accept(f(25.0001,11000),11000);return e;}
 public static void main(String[]args){
  WideCameraSection e=engine();WideCameraSection.Status s=e.status(f(24.998,10000),10000);
  ok(s.section==sec&&!s.active&&s.seconds<0,"entrance candidate has no fabricated timer");
  e=entered();s=e.status(f(25.0001,11000),11000);ok(s.active,"observed crossing starts");ok(s.distance>985&&s.distance<995,"distance accounts for part of crossing step");ok(s.seconds==60,"whole section length/speed less elapsed");
  WideCameraEngine.Fix stopped=new WideCameraEngine.Fix(25.0001,121,5,0,0,12000,false,false);e.accept(stopped,12000);s=e.status(stopped,12000);ok(s.active&&s.distance>985,"stationary GPS does not add drift");ok(s.seconds==59,"elapsed time continues while stopped");
  e=entered();s=e.status(f(25.0001,11000),17000);ok(!s.active,"stale fix invalidates active timer");e.accept(f(25.001,18000),18000);ok(!e.status(f(25.001,18000),18000).active,"not resumed mid-section after gap");
  e=engine();e.accept(f(25.004,10000),10000);e.accept(f(25.0041,11000),11000);ok(!e.status(f(25.0041,11000),11000).active,"starting app inside section is not a recorded entry");
  e=engine();e.accept(new WideCameraEngine.Fix(25.0001,121,5,180,20,10000,true,false),10000);WideCameraEngine.Fix reverse=new WideCameraEngine.Fix(24.9999,121,5,180,20,11000,true,false);e.accept(reverse,11000);ok(!e.status(reverse,11000).active,"reverse crossing rejected");
  e=engine();e.setSections(Arrays.asList(sec,new WideCameraSection.Section("s2","test","test",25,121,25.009,121,1001,60)));e.accept(f(24.9999,10000),10000);e.accept(f(25.0001,11000),11000);ok(!e.status(f(25.0001,11000),11000).active,"overlapping candidate starts not guessed");
  e=entered();WideCameraEngine.Fix mocked=new WideCameraEngine.Fix(25.0002,121,5,0,20,12000,true,true);e.accept(mocked,12000);ok(!e.status(mocked,12000).active,"mock location invalidates timer");
  e=entered();e.accept(f(25.008,12000),12000);ok(!e.status(f(25.008,12000),12000).active,"GPS teleport invalidates timer");
  e=entered();e.accept(new WideCameraEngine.Fix(25.0002,121,50,0,20,12000,true,false),12000);ok(!e.status(f(25.0002,12000),12000).active,"poor accuracy clears timer");
  e=entered();WideCameraEngine.Fix last=f(25.0001,11000);for(int i=1;i<=51;i++){last=f(25.0001+i*.00018,11000+i*1000);e.accept(last,last.time);}s=e.status(last,last.time);ok(s.finished&&!s.active,"observed endpoint crossing finishes");
  e=entered();e.reset("stopped");ok(!e.status(f(25.0001,11000),11000).active,"stop clears timer");
  e=engine();e.accept(f(24.9999,10000),10000);e.accept(f(25.0001,17000),17000);ok(!e.status(f(25.0001,17000),17000).active,"gap across start cannot create a timer");
  e=entered();e.accept(f(24.9999,10000),12000);ok(e.status(f(25.0001,11000),12000).active,"out of order fix ignored");
  e=entered();s=e.status(f(25.0001,11000),10000);ok(!s.active,"future fix invalidated");
  ok(WideCameraFace.demo(1,1000).distance>WideCameraFace.demo(1,2000).distance,"fixed demo countdown");
  ok(WideCameraFace.demo(2,1000).seconds>WideCameraFace.demo(2,2000).seconds,"section demo countdown");
  System.out.println("PASS: "+n+" section/demonstration cases (all estimates; no control output)");
 }
}
