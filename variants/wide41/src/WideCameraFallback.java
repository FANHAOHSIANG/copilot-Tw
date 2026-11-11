package com.navipilot.obf;
import java.util.List;
/** Directional, approaching-camera UI fallback; never supplied to WideBridge. */
final class WideCameraFallback {
 private static final WideAlertMotion motion=new WideAlertMotion();
 private static WideCameraEngine.Fix prepared;
 private static long lastTime,firstTime;private static String id="",status="等待定位軌跡";
 private static double firstDistance,lastDistance;private static int samples;
 private static WideHcopRoad.Decision published;
 static synchronized void clear(){motion.clear();prepared=null;lastTime=0;id="";samples=0;published=null;status="等待定位軌跡";}
 static synchronized String status(){return status;}
 static synchronized WideHcopRoad.Decision match(List<WideCameraEngine.Point> points,WideCameraEngine.Fix raw,long now){
  if(!WideAlertMotion.position(raw,now)){clear();status="GPS 過期或精度不足，暫停提醒";return null;}
  if(raw.time==lastTime)return published;
  if(raw.time<lastTime)clear();
  lastTime=raw.time;prepared=motion.accept(raw,now);published=null;
  if(prepared==null){id="";samples=0;status=raw.speedValid&&raw.speed<1.5?"停車／低速，等待起步":"累積移動軌跡以確認方向";return null;}
  WideCameraEngine.Result r=WideCameraEngine.match(points,prepared,now);
  if(r.point==null){id="";samples=0;status=r.state;return null;}
  // Unknown enforcement direction remains a visual proximity feature, not a spoken ahead claim.
  if(!r.directionKnown){id="";samples=0;status="附近有測速點，但執法方向未標明";return null;}
  if(!r.point.id.equals(id)||r.distance>lastDistance+Math.max(10,raw.accuracy)){
   id=r.point.id;samples=1;firstTime=raw.time;firstDistance=r.distance;
  }else samples++;
  lastDistance=r.distance;
  if(samples<2||raw.time-firstTime<1000||firstDistance-r.distance<Math.max(5,raw.accuracy*.5)){
   status="前方候選點，確認持續接近中";return null;
  }
  WideHcopRoad.Decision d=new WideHcopRoad.Decision("同向接近候選 · 直線距離 · 道路未確認 · 僅提醒",raw.time);
  WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=r.point.id;c.lat=r.point.lat;c.lon=r.point.lon;
  c.limit=r.point.limitUncertain?0:r.point.limit;c.road="道路層級未標明 · "+r.point.road;
  c.edge="";c.dirs=new int[0];d.camera=c;d.distance=r.distance;d.confirmed=true;d.source="candidate";
  status=d.reason;published=d;return d;
 }
}
