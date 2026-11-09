package com.navipilot.obf;
import java.util.*;

/** Official paired endpoints plus continuous GPS. All outputs are unverified estimates, never control. */
public final class WideCameraSection {
 public static final class Section {
  public final String id,road,city; public final double slat,slon,elat,elon,length;public final int limit;
  public Section(String id,String road,String city,double slat,double slon,double elat,double elon,double length,int limit){this.id=id;this.road=road;this.city=city;this.slat=slat;this.slon=slon;this.elat=elat;this.elon=elon;this.length=length;this.limit=limit;}
 }
 public static final class Status {
  public final Section section;public final boolean active,finished;public final double distance,seconds,average;public final String reason;
  Status(Section s,boolean a,boolean f,double d,double seconds,double avg,String reason){section=s;active=a;finished=f;distance=d;this.seconds=seconds;average=avg;this.reason=reason;}
 }
 private List<Section> sections=Collections.emptyList();private Section active,finished;private WideCameraEngine.Fix previous;
 private long entered,finishedUntil;private double travelled;private String warning="尚未記錄區間入口";
 public synchronized void setSections(List<Section> list){sections=Collections.unmodifiableList(new ArrayList<Section>(list));reset("資料已載入，等待入口");}
 public synchronized void reset(String why){active=null;finished=null;previous=null;entered=0;travelled=0;warning=why;}
 private static String invalidPosition(WideCameraEngine.Fix f,long now){
  if(f==null||!WideCameraEngine.finite(f.lat)||!WideCameraEngine.finite(f.lon)||f.lat < -90||f.lat >90||f.lon < -180||f.lon>180)return "GPS 座標無效";
  if(f.time<=0||now<f.time||now-f.time>5000)return "GPS 中斷，區間計時失效";
  if(f.mock||!WideCameraEngine.finite(f.accuracy)||f.accuracy<=0||f.accuracy>30)return "GPS 精度不足，區間計時失效";
  if(!WideCameraEngine.finite(f.speed)||f.speed<0)return "GPS 速度無效";
  return null;
 }
 // Projection of gate onto this one GPS step, never projection onto the endpoint chord.
 private static double crossing(WideCameraEngine.Fix a,WideCameraEngine.Fix b,double lat,double lon,double tolerance){
  double scale=Math.cos(Math.toRadians(lat))*111195;
  double ax=(a.lon-lon)*scale,ay=(a.lat-lat)*111195,bx=(b.lon-lon)*scale,by=(b.lat-lat)*111195;
  double dx=bx-ax,dy=by-ay,len2=dx*dx+dy*dy;if(len2<4)return -1;
  double t=-(ax*dx+ay*dy)/len2;
  if(t<0||t>1||Math.hypot(ax+t*dx,ay+t*dy)>tolerance)return -1;
  return t;
 }
 public synchronized void accept(WideCameraEngine.Fix f,long now){
  String bad=invalidPosition(f,now);if(bad!=null){reset(bad);return;}
  WideCameraEngine.Fix old=previous;
  if(old!=null&&f.time<=old.time)return;
  if(old==null){previous=f;return;}
  long dt=f.time-old.time;
  if(dt>5000){reset("GPS 中斷，區間計時失效");previous=f;return;}
  double step=WideCameraEngine.distance(old.lat,old.lon,f.lat,f.lon);
  if(step>Math.max(40,Math.max(old.speed,f.speed)*dt/1000.0+old.accuracy+f.accuracy+15)){
   reset("GPS 跳點，區間計時失效");previous=f;return;
  }
  if(active!=null){
   if(f.speed>=.8&&step>=1)travelled+=step;
   double crossed=crossing(old,f,active.elat,active.elon,25);
   if(crossed>=0&&travelled>=active.length*.6){finished=active;finishedUntil=now+6000;active=null;warning="已通過區間終點（GPS 判斷）";previous=f;return;}
   // Unknown detour, exit or repeated loop must not keep an apparently valid count forever.
   if(travelled>active.length*1.25||now-entered>Math.max(900000,active.length*3.6/active.limit*6000)){
    reset("路程不符，區間計時失效");previous=f;return;
   }
  }else if(finished==null||now>finishedUntil){
   finished=null;
   if(f.headingValid&&f.speed>=1.5&&old.accuracy<=20&&f.accuracy<=20){
    Section picked=null;double at=0,best=Double.MAX_VALUE;boolean ambiguous=false;
    for(Section s:sections){
     double distance=WideCameraEngine.distance(f.lat,f.lon,s.slat,s.slon);if(distance>100)continue;
     double direction=WideCameraEngine.bearing(s.slat,s.slon,s.elat,s.elon);
     if(WideCameraEngine.difference(f.heading,direction)>75)continue;
     double t=crossing(old,f,s.slat,s.slon,20);if(t<0)continue;
     if(picked!=null){ambiguous=true;}if(distance<best){picked=s;at=t;best=distance;}
    }
    if(picked!=null&&!ambiguous){active=picked;entered=old.time+(long)(at*dt);travelled=(1-at)*step;warning="入口已記錄 · 未確認同一道路";}
    else if(ambiguous)warning="入口重疊，無法確認區間";
   }
  }
  previous=f;
 }
 public synchronized Status status(WideCameraEngine.Fix f,long now){
  String bad=invalidPosition(f,now);
  if(bad!=null){if(active!=null)reset(bad);return new Status(null,false,false,0,-1,0,bad);}
  if(active!=null){
   double elapsed=Math.max(0,(now-entered)/1000.0),remaining=Math.max(0,active.length-travelled);
   double seconds=Math.max(0,Math.ceil(active.length*3.6/active.limit-elapsed));
   return new Status(active,true,false,remaining,seconds,elapsed>0?travelled/elapsed*3.6:0,"區間估算 · 未確認同一道路");
  }
  if(finished!=null&&now<=finishedUntil)return new Status(finished,false,true,0,0,0,"已通過區間終點（GPS 判斷）");
  if(WideCameraEngine.invalid(f,now)!=null)return new Status(null,false,false,0,-1,0,warning);
  Section best=null;double nearest=1501;
  for(Section s:sections){
   double d=WideCameraEngine.distance(f.lat,f.lon,s.slat,s.slon);if(d>1500||d>=nearest)continue;
   double ray=WideCameraEngine.difference(f.heading,WideCameraEngine.bearing(f.lat,f.lon,s.slat,s.slon));
   if(ray>35||d*Math.sin(Math.toRadians(ray))>70)continue;
   if(WideCameraEngine.difference(f.heading,WideCameraEngine.bearing(s.slat,s.slon,s.elat,s.elon))>75)continue;
   best=s;nearest=d;
  }
  return new Status(best,false,false,best==null?0:nearest,-1,0,best==null?warning:"前方區間入口 · 尚未開始計時");
 }
}
