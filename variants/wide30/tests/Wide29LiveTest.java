package com.navipilot.obf;
import java.util.ArrayList;
import java.util.List;

/** Exercises the same routing method used by the Android live card. */
public final class Wide29LiveTest {
 static final class Draw implements WideCameraFace.Painter {
  final List<String> calls=new ArrayList<>(),labels=new ArrayList<>();float distanceSize=-1,signX=-1,speedX=-1;
  public void rect(float x,float y,float w,float h,float r,int c){calls.add("rect:"+x+":"+y+":"+w+":"+h+":"+r+":"+c);}
  public void circle(float x,float y,float r,float s,int c){calls.add("circle:"+x+":"+y+":"+r+":"+s+":"+c);if(signX<0)signX=x;}
  public void line(float x,float y,float x2,float y2,float s,int c){calls.add("line:"+x+":"+y+":"+x2+":"+y2+":"+s+":"+c);}
  public void text(String v,float x,float y,float z,int c,float width,boolean center){
   labels.add(v);calls.add("text:"+v+":"+x+":"+y+":"+z+":"+c+":"+width+":"+center);
   if(v.endsWith(" m"))distanceSize=z;if("52".equals(v))speedX=x;
  }
 }
 static void check(boolean v,String why){if(!v)throw new AssertionError(why);}
 public static void main(String[] args){
  WideCameraFace.Model m=new WideCameraFace.Model();m.speedKph=52;m.roadLimit=60;m.limit=60;
  m.type=1;m.distance=450;m.roadMatched=true;m.title="同路段固定測速";
  m.state="已配對";m.footer="GPS ±10 m · 0.3 秒前 · 52 km/h";m.badge="最近已接收";
  Draw far=new Draw();WideLiveCameraFace.render(far,360,200,m,10000,false);
  check(far.labels.contains("台灣測速 · 即時")&&far.labels.contains("450 m"),"live data on actual panel");
  check(far.labels.contains(m.footer),"GPS accuracy and age shown in bottom panel");
  check(far.signX==180f&&far.speedX>10f&&far.speedX<far.signX,"centered speed and speed-limit sign");
  m.distance=50;Draw near=new Draw();WideLiveCameraFace.render(near,360,200,m,10000,false);
  check(near.distanceSize>far.distanceSize,"distance enlarges while approaching");
  m.previewOnly=true;m.roadMatched=false;m.roadLimit=0;m.limit=0;m.title="附近測速點";m.state="方向未確認 · 直線距離";
  Draw unconfirmed=new Draw();WideLiveCameraFace.render(unconfirmed,360,200,m,10000,false);
  check(unconfirmed.labels.contains("未確認 · 附近測速點")&&unconfirmed.labels.contains(m.state),"unconfirmed nearby status");
  check(unconfirmed.signX<0,"never invent a speed limit for nearby candidate");
  Draw compact=new Draw();WideLiveCameraFace.render(compact,250,48,m,10000,false);
  check(compact.labels.contains("50 m")&&compact.labels.contains("未確認 · "+m.footer),"compact live pane shows distance and GPS status");
  m.type=0;m.previewOnly=false;m.speedKph=Double.NaN;m.state="請開啟車機的位置服務";m.footer="GPS 搜尋中";
  Draw waiting=new Draw();WideLiveCameraFace.render(waiting,250,140,m,10000,false);
  check(waiting.labels.contains("—")&&waiting.labels.contains("GPS 搜尋中"),"missing GPS never becomes fake zero");
  WideCameraFace.Model example=WideCameraFace.demo(1,0);Draw direct=new Draw(),routed=new Draw();
  WideCameraFace.draw(direct,360,200,example,10000);WideLiveCameraFace.render(routed,360,200,example,10000,true);
  check(direct.calls.equals(routed.calls),"independent demo remains unchanged");
  System.out.println("PASS: live routing, GPS footer down to 48dp, centered speed, distance scale and unchanged demo");
 }
}
