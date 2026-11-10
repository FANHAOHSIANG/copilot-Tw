package com.navipilot.obf;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;

public final class Wide27Test {
 private static final class TextCapture implements WideCameraFace.Painter {
  final List<String> lines=new ArrayList<>();
  public void rect(float x,float y,float w,float h,float r,int c){}
  public void circle(float x,float y,float r,float s,int c){}
  public void line(float x,float y,float x2,float y2,float s,int c){}
  public void text(String v,float x,float y,float size,int c,float width,boolean centered){lines.add(v);}
 }
 private static void check(boolean b,String s){if(!b)throw new AssertionError(s);}
 public static void main(String[] args) throws Exception {
  long now=10000;
  WideCameraEngine.Point camera=new WideCameraEngine.Point("camera","road","city","north",24.8005,121,50,new double[]{0},false);
  WideCameraEngine.Fix stationary=new WideCameraEngine.Fix(24.8,121,8,0,0,now,false,false,true);
  WideCameraEngine.Result nearby=WideCameraEngine.nearby(Arrays.asList(camera),stationary,now);
  check(nearby.point==camera && nearby.proximityOnly && nearby.distance<100,"stationary nearby must be explicitly unconfirmed");
  check("低速／停車，等待行進方向".equals(WideCameraEngine.invalid(stationary,now)),"forward matching still needs heading");
  check(!WideHcopRoad.match(new WideHcopRoad.Data(),stationary,now).confirmed,"unconfirmed proximity cannot become road match");
  JSONObject stale=new JSONObject().put("road_limit_kph",50).put("sdi",new JSONObject().put("speed_limit_kph",50));
  check(WideHcopMerge.merge(stale,true,new WideHcopRoad.Decision("no heading",now))==null,"C4 cannot inherit unconfirmed speed or camera");
  check(WideCameraEngine.validSpeed(stationary,now),"valid GPS speed may be zero at rest");
  WideCameraEngine.Fix noSpeed=new WideCameraEngine.Fix(24.8,121,8,0,0,now,false,false,false);
  check(!WideCameraEngine.validSpeed(noSpeed,now),"missing speed must not display zero");
  check(!WideCameraEngine.validSpeed(stationary,now+3001),"stale speed must be hidden");
  check(WideCameraEngine.nearby(Arrays.asList(camera),stationary,now+5001).point==null,"stale position cannot warn");
  WideCameraEngine.Fix poor=new WideCameraEngine.Fix(24.8,121,31,0,0,now,false,false,true);
  check(WideCameraEngine.nearby(Arrays.asList(camera),poor,now).point==null,"poor position cannot warn");
  WideCameraEngine.Fix mock=new WideCameraEngine.Fix(24.8,121,8,0,0,now,false,true,true);
  check(WideCameraEngine.nearby(Arrays.asList(camera),mock,now).point==null,"mock location cannot warn");
  WideCameraFace.Model m=new WideCameraFace.Model();m.previewOnly=true;m.type=1;m.limit=50;m.distance=100;
  check(WideCameraFace.visibleLimit(m)==0,"proximity cannot supply a speed-limit sign");
  check(WideCameraFace.warningStrength(m)>0,"unconfirmed proximity remains visible-only");
  m.roadMatched=true;m.previewOnly=false;check(WideCameraFace.visibleLimit(m)==50,"verified camera speed sign");
  m.roadLimit=60;check(WideCameraFace.visibleLimit(m)==60,"current road limit wins over camera limit");
  TextCapture paint=new TextCapture();WideCameraFace.draw(paint,360,200,m,now);
  check(paint.lines.contains("測速限速 50 · 沿道路距離"),"distinct camera limit remains visible");
  TextCapture sectionPaint=new TextCapture();WideCameraFace.draw(sectionPaint,360,200,WideCameraFace.demo(2,0),now);
  check(sectionPaint.lines.contains("尚需 60 秒 · 均速 54 · 估算"),"section demo retains estimated time and average");
  m.distance=500;double slow=WideCameraFace.flashPeriodMs(m);m.distance=80;
  check(WideCameraFace.flashPeriodMs(m)<slow,"approaching camera flashes faster");
  System.out.println("PASS: GPS speed freshness, nearby-only warning, C4 isolation and speed-limit display");
 }
}
