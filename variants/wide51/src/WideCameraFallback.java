package com.navipilot.obf;
import java.util.*;
/** UI/audio tracking only. Never authorizes WideBridge control packets. */
final class WideCameraFallback {
 private static final WideAlertMotion motion=new WideAlertMotion();
 private static final HashMap<String,Track> tracks=new HashMap<>();
 private static long lastTime,lastGood;
 private static String selected="",status="等待定位軌跡";
 private static WideHcopRoad.Decision published;
 static final class Advisory {final String id,road,reason;final long time;Advisory(String i,String r,String why,long t){id=i;road=r;reason=why;time=t;}}
 private static volatile Advisory advisory;
 static Advisory advisory(long now){Advisory a=advisory;return a!=null&&now>=a.time&&now-a.time<=3000?a:null;}
 static boolean uncertain(WideCameraEngine.Point p){return p.bearings.length==0||"bb3c86d11fbe09e8".equals(p.id);}
 private static class Track {long first,time; double start,distance;int samples;}
 static synchronized void clear(){motion.clear();tracks.clear();lastTime=lastGood=0;selected="";published=null;advisory=null;status="等待定位軌跡";}
 static synchronized String status(){return status;}
 static synchronized WideHcopRoad.Decision match(List<WideCameraEngine.Point> points,WideCameraEngine.Fix raw,long now){
  if(!WideAlertMotion.position(raw,now)){
   motion.accept(raw,now);published=null;advisory=null;
   if(raw==null||raw.mock||now-lastGood>10000||(raw.time<lastTime)){clear();}
   status="GPS 過期或精度不足，暫停提醒；短暫保留軌跡";return null;
  }
  if(raw.time==lastTime)return published;
  if(raw.time<lastTime||raw.time-lastGood>10000)clear();
  lastTime=raw.time;lastGood=raw.time;published=null;advisory=null;
  WideCameraEngine.Fix f=motion.accept(raw,now);
  if(f==null){
   tracks.clear();selected="";
   status=raw.speedValid&&raw.speed<1.5?"停車／低速，等待起步":"累積移動軌跡以確認方向";
   return null;
  }
  lastGood=raw.time;
  int near=0,unknown=0,off=0,reverse=0,eligible=0;
  WideCameraEngine.Point best=null,held=null,nearestUnknown=null;double bestD=Double.MAX_VALUE,heldD=0,unknownD=Double.MAX_VALUE;
  HashSet<String> seen=new HashSet<>();double noteD=Double.MAX_VALUE;
  if(points!=null)for(WideCameraEngine.Point p:points){
   double d=WideCameraEngine.distance(f.lat,f.lon,p.lat,p.lon);
   if(!Double.isFinite(d)||d>1500||d<12)continue;
   near++;
   boolean unsure=uncertain(p);if(unsure){unknown++;if(d<unknownD){nearestUnknown=p;unknownD=d;}}
   double ray=WideCameraEngine.difference(f.heading,WideCameraEngine.bearing(f.lat,f.lon,p.lat,p.lon));
   if(ray>30||d*Math.sin(Math.toRadians(ray))>60){off++;continue;}
   boolean same=false;for(double b:p.bearings)if(WideCameraEngine.difference(f.heading,b)<=50)same=true;
   if(!same&&!unsure){reverse++;continue;}
   eligible++;seen.add(p.id);
   Track t=tracks.get(p.id);
   if(t==null||raw.time-t.time>10000||d>t.distance+Math.max(10,raw.accuracy)){
    t=new Track();t.first=raw.time;t.start=d;tracks.put(p.id,t);
   }
   t.time=raw.time;t.distance=d;t.samples++;
   if(t.samples<2||raw.time-t.first<1000||t.start-d<Math.max(5,raw.accuracy*.5))continue;
   int road=WideCameraRoadGate.check(p,f,now);
   if(road<0)continue;
   if(unsure||road==0){
    if(d<=1000&&d<noteD){noteD=d;advisory=new Advisory(p.id,p.road,(road==1?"前方測速 · ":"附近測速 · 道路待確認 · ")+(unsure?"取締方向待確認":"取締方向符合"),raw.time);}
    continue;
   }
   if(d<bestD){best=p;bestD=d;}
   if(p.id.equals(selected)){held=p;heldD=d;}
  }
  tracks.keySet().retainAll(seen);
  String detail="候選 "+near+" · 同向 "+eligible+" · 方向未知 "+unknown+" · 偏離 "+off+" · 反向 "+reverse;
  // Keep a valid target only within 50 m of the nearest eligible one.
  if(held!=null&&heldD<=bestD+50){best=held;bestD=heldD;}
  if(best==null){selected="";status=detail+"；"+(eligible>0?"確認持續接近中":nearestUnknown!=null?"附近測速點 · "+Math.round(unknownD)+" m · 方向未確認 · "+nearestUnknown.road:"前方無符合測速點");return null;}
  selected=best.id;
  WideHcopRoad.Decision d=new WideHcopRoad.Decision("同向接近候選 · 道路連通已檢查 · 直線估距 · 僅提醒；"+detail,raw.time);
  WideHcopRoad.Camera c=new WideHcopRoad.Camera();c.id=best.id;c.lat=best.lat;c.lon=best.lon;
  c.limit=best.limitUncertain?0:best.limit;c.road="道路層級未標明 · "+best.road;c.edge="";c.dirs=new int[0];
  d.camera=c;d.distance=bestD;d.confirmed=true;d.source="candidate";status=d.reason;published=d;return d;
 }
}
