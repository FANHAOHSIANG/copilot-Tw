package com.navipilot.obf;
import org.json.JSONObject;
/** Right upper vehicle panel + lower alert panel, using the existing Canvas view. */
public final class WideDashboardFace {
 private static final int BG=0xff091320,CARD=0xff122238,INK=0xffedf5ff,MUTED=0xffa4b8ce,BLUE=0xff7ed6ff,AMBER=0xffffd075;
 private static String flag(String name,Boolean value){return name+(value==null?" —":value?" 已接管":" 未接管");}
 public static void render(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m,long now,boolean demo,int retainedLimit){
  if(w<230||h<280){WideLiveCameraFace.render(p,w,h,m,now,demo,retainedLimit);return;}
  WideVehiclePanel.State car=WideVehiclePanel.current();boolean c4=!demo&&Double.isFinite(car.speed);double speed=demo?58:c4?car.speed:m.speedKph;
  float pad=10,top=h*.45f,gap=9,lower=top+gap;
  p.rect(0,0,w,h,0,BG);p.rect(pad,pad,w-2*pad,top-pad,12,CARD);p.text("即時車況",22,30,13,INK,w*.43f,false);p.text(demo?"示意":c4?"C4 車速":"GPS 車速",w*.76f,30,11,BLUE,w*.4f,true);
  p.text(Double.isFinite(speed)?String.valueOf(Math.round(speed)):"—",24,top-38,Math.min(68,top*.5f),INK,w*.45f,false);p.text("km/h",w*.43f,top-40,12,MUTED,w*.16f,false);
  int currentLimit=WideCameraFace.visibleLimit(m),limit=currentLimit>0?currentLimit:retainedLimit;if(limit>0){float r=Math.min(29,top*.25f),x=w*.79f,y=top*.52f;p.circle(x,y,r,0,0xfff9fbff);p.circle(x,y,r-2,4,0xfff36978);p.text(String.valueOf(limit),x,y+r*.3f,r,0xff172537,r*1.65f,true);if(currentLimit<=0)p.text("暫存速限",x,y+r+13,9,MUTED,r*2+20,true);}
  p.text(demo?"橫向 已接管 · 縱向 已接管":flag("橫向",car.lateral)+" · "+flag("縱向",car.longitudinal),22,top-13,11,MUTED,w-44,false);
  p.rect(pad,lower,w-2*pad,h-lower-pad,12,CARD);
  boolean target=m.type>=1&&m.type<=3&&Double.isFinite(m.distance)&&m.distance>=0;
  JSONObject turn=demo?null:WideGoogleNav.guidance();boolean showTurn=turn!=null&&(!target||(m.type!=3&&m.distance>1000&&turn.optInt("distance_m",100001)<=1000));
  String title=showTurn?turn.optString("main_text","下一個轉彎"):target?m.title:"前方道路提醒";p.text(title==null?"前方提醒":title,22,lower+25,14,INK,w-44,false);
  p.text(showTurn?turn.optInt("distance_m")+" m":target?Math.round(m.distance)+" m":"—",22,lower+Math.min(86,(h-lower)*.55f),Math.min(48,(h-lower)*.31f),target?AMBER:MUTED,w-44,false);
  p.text(showTurn?turn.optString("road_name"):m.type==3?"區間均速 "+Math.round(m.average)+" · 尚需 "+Math.round(m.seconds)+" 秒（估算）":target&&m.limit>0?"測速限速 "+m.limit+" km/h":m.state,22,h-49,11,MUTED,w-44,false);
  p.text(showTurn?"Google SDK 導航資料":m.previewOnly?"GPS 備援 · 道路未確認":m.roadMatched?"沿道路距離 · "+(m.road==null?"":m.road):"未導航也持續搜尋",22,h-28,10,BLUE,w-44,false);
 }
 private WideDashboardFace(){}
}
