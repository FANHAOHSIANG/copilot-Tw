package com.navipilot.obf;
import java.lang.reflect.Field;
import java.util.Arrays;
import android.os.SystemClock;

public final class Wide27ModelTest {
 private static void put(String name,Object value)throws Exception{Field f=WideCamera.class.getDeclaredField(name);f.setAccessible(true);f.set(null,value);}
 private static void check(boolean b,String why){if(!b)throw new AssertionError(why);}
 public static void main(String[] args)throws Exception {
  WideCameraEngine.Point c=new WideCameraEngine.Point("id","test road","city","north",24.8005,121,50,new double[]{0},false);
  WideCameraEngine.Fix f=new WideCameraEngine.Fix(24.8,121,8,0,0,SystemClock.now,false,false,true);
  put("points",Arrays.asList(c));put("loaded",true);put("fix",f);WideCamera.running=true;
  WideCameraFace.Model m=WideCamera.model();
  check(m.type==1 && m.previewOnly && !m.roadMatched,"stationary camera must be preview only");
  check(m.title.equals("附近測速點") && m.state.contains("方向未確認"),"do not claim it is ahead");
  check(m.speedKph==0 && WideCameraFace.visibleLimit(m)==0,"valid stopped speed; no unverified limit");
  check(!WideHcop.current().confirmed,"preview must not turn into C4 match");
  SystemClock.now+=6000;m=WideCamera.model();
  check(m.type==0 && Double.isNaN(m.speedKph),"stale fix hides nearby camera and speed");
  put("fix",null);put("serviceStatus","請開啟車機的位置服務");WideCamera.running=false;
  m=WideCamera.model();check(m.title.equals("GPS 未啟動")&&m.state.contains("位置服務"),"show failure reason");
  WideCamera.running=true;m=WideCamera.model();
  check(m.title.equals("等待 GPS 定位")&&m.state.contains("位置服務"),"show waiting reason");
  System.out.println("PASS: real model shows nearby and GPS state; stale data is cleared");
 }
}
