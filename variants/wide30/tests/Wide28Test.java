package com.navipilot.obf;
import java.util.ArrayList;
import java.util.List;

public final class Wide28Test {
 static final class Draw implements WideCameraFace.Painter {
  final List<String> labels=new ArrayList<>();float distanceSize=-1,signX=-1;
  public void rect(float x,float y,float w,float h,float radius,int color){}
  public void circle(float x,float y,float radius,float stroke,int color){if(signX<0)signX=x;}
  public void line(float x,float y,float x2,float y2,float stroke,int color){}
  public void text(String value,float x,float y,float size,int color,float width,boolean center){
   labels.add(value);if(value.endsWith(" m"))distanceSize=size;
  }
 }
 static void check(boolean v,String why){if(!v)throw new AssertionError(why);}
 static Draw draw(WideCameraFace.Model m,int w,int h){Draw d=new Draw();WideCameraFace.draw(d,w,h,m,10000);return d;}
 public static void main(String[] args){
  WideCameraFace.Model m=WideCameraFace.demo(1,0);m.distance=500;
  Draw far=draw(m,360,200);m.distance=50;Draw near=draw(m,360,200);
  check(far.labels.contains("500 m")&&near.labels.contains("50 m"),"distance rendered in demo");
  check(near.distanceSize>far.distanceSize,"distance grows when approaching");
  check(near.signX>0&&near.signX<360*.5,"speed sign moves nearer to center");
  m.demo=false;m.roadMatched=false;m.previewOnly=true;m.roadLimit=0;m.limit=0;
  m.title="附近測速點";m.state="方向未確認 · 直線距離";m.distance=100;
  Draw compact=draw(m,250,75);
  check(compact.labels.contains("100 m"),"compact live pane must render distance");
  check(compact.labels.contains("附近 · 未確認"),"compact nearby label remains unconfirmed");
  check(WideCameraFace.visibleLimit(m)==0,"unverified camera may not provide a speed sign");
  m.type=0;m.previewOnly=false;m.title="GPS 未啟動";m.state="請開啟車機的位置服務";
  Draw missing=draw(m,250,75);
  check(missing.labels.contains("請開啟車機的位置服務"),"compact pane shows why GPS is unavailable");
  System.out.println("PASS: compact camera visibility, approaching zoom, centered limit and GPS status");
 }
}
