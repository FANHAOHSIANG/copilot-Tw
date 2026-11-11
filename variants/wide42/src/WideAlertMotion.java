package com.navipilot.obf;
import java.util.ArrayList;
/** UI/audio only. Raw fixes are never replaced in the controller. */
final class WideAlertMotion {
 private final ArrayList<WideCameraEngine.Fix> history=new ArrayList<>();
 void clear(){history.clear();}
 static boolean position(WideCameraEngine.Fix f,long now){return f!=null&&!f.mock&&f.time>0&&now>=f.time&&now-f.time<=3000&&Double.isFinite(f.lat)&&Double.isFinite(f.lon)&&f.lat>=20&&f.lat<=27&&f.lon>=116&&f.lon<=124&&Double.isFinite(f.accuracy)&&f.accuracy>0&&f.accuracy<=30;}
 WideCameraEngine.Fix accept(WideCameraEngine.Fix f,long now){
  if(!position(f,now)){
   if(f==null||f.mock||(!history.isEmpty()&&(now-history.get(history.size()-1).time>10000||f.time<history.get(history.size()-1).time)))clear();
   return null;
  }
  if(!history.isEmpty()){
   WideCameraEngine.Fix p=history.get(history.size()-1);double dt=(f.time-p.time)/1000.;
   if(dt<=0)return null;
   if(dt>10||WideCameraEngine.distance(p.lat,p.lon,f.lat,f.lon)>65*dt+p.accuracy+f.accuracy)clear();
  }
  // A measured stop takes precedence over old direction or coordinate drift.
  if(f.speedValid&&(!Double.isFinite(f.speed)||f.speed<1.5||f.speed>60)){clear();history.add(f);return null;}
  history.add(f);
  long window=f.speedValid&&f.speed<5?30000:12000;
  while(history.size()>128||f.time-history.get(0).time>window)history.remove(0);
  if(f.headingValid&&Double.isFinite(f.heading)&&f.heading>=0&&f.heading<360&&f.speedValid&&Double.isFinite(f.speed)&&f.speed>=1.5&&f.speed<=60)return f;
  // Require at least three positions and displacement beyond positional uncertainty.
  if(history.size()<3)return null;
  WideCameraEngine.Fix first=history.get(0),recent=history.get(history.size()-2);
  double distance=WideCameraEngine.distance(first.lat,first.lon,f.lat,f.lon),dt=(f.time-first.time)/1000.;
  if(dt<1.5||distance<Math.max(20,first.accuracy+f.accuracy))return null;
  double heading=WideCameraEngine.bearing(first.lat,first.lon,f.lat,f.lon),speed=distance/dt;
  if(speed<1.5||speed>60)return null;
  // Reject a changing course; restart the window instead of holding a stale heading into a turn.
  for(int i=1;i<history.size();i++){
   WideCameraEngine.Fix a=history.get(i-1),b=history.get(i);
   double step=WideCameraEngine.distance(a.lat,a.lon,b.lat,b.lon);
   if(step>=Math.max(8,(a.accuracy+b.accuracy)*.5)&&WideCameraEngine.difference(heading,WideCameraEngine.bearing(a.lat,a.lon,b.lat,b.lon))>35){clear();history.add(recent);history.add(f);return null;}
  }
  // Recent displacement also checks turns made with individually small steps.
  for(int i=history.size()-2;i>=0;i--){
   WideCameraEngine.Fix a=history.get(i);
   double recentDistance=WideCameraEngine.distance(a.lat,a.lon,f.lat,f.lon);
   if(recentDistance>=Math.max(8,(a.accuracy+f.accuracy)*.5)){
    if(WideCameraEngine.difference(heading,WideCameraEngine.bearing(a.lat,a.lon,f.lat,f.lon))>35){clear();history.add(recent);history.add(f);return null;}
    break;
   }
  }
  if(f.speedValid&&Double.isFinite(f.speed)&&Math.abs(f.speed-speed)>Math.max(8,f.speed*.5))return null;
  return new WideCameraEngine.Fix(f.lat,f.lon,f.accuracy,heading,f.speedValid?f.speed:speed,f.time,true,false,true);
 }
}
