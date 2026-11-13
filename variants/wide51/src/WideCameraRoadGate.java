package com.navipilot.obf;
import java.util.*;
/** Display/audio evidence only. Does not feed WideBridge. */
final class WideCameraRoadGate {
 private static volatile WideHcopRoad.Data data;
 private static volatile long time;
 static void update(WideHcopRoad.Data d,long t){data=d;time=t;}
 static void clear(){data=null;time=0;}
 static final class Snap {WideHcopRoad.Road road;WideRoad.Projection p;}
 private static Snap snap(WideHcopRoad.Data d,double lat,double lon,double max,double heading){
  Snap best=null;double second=Double.POSITIVE_INFINITY;
  for(WideHcopRoad.Road r:d.roads){
   if(r.xy==null||r.xy.length<2)continue;
   if(r.bounded&&(lon<r.minLon-.0004||lon>r.maxLon+.0004||lat<r.minLat-.0004||lat>r.maxLat+.0004))continue;
   WideRoad.Projection p=WideRoad.project(r.xy,lat,lon,5);
   if(p.ambiguous||p.offset>max)continue;
   if(Double.isFinite(heading)&&Math.min(WideRoad.delta(heading,p.heading),WideRoad.delta(heading,(p.heading+180)%360))>35)continue;
   if(best==null||p.offset<best.p.offset){if(best!=null)second=best.p.offset;best=new Snap();best.road=r;best.p=p;}else second=Math.min(second,p.offset);
  }
  return best!=null&&second-best.p.offset>=5?best:null;
 }
 /** 1: unique forward road chain; 0: not enough evidence; -1: different/behind road. */
 static int check(WideCameraEngine.Point c,WideCameraEngine.Fix f,long now){
  WideHcopRoad.Data d=data;if(d==null||d.expired||now<time||now-time>3000)return 0;
  Snap a=snap(d,f.lat,f.lon,Math.min(20,Math.max(8,f.accuracy)),f.heading);
  Snap b=snap(d,c.lat,c.lon,25,Double.NaN);if(a==null||b==null)return 0;
  int dir=WideRoad.delta(f.heading,a.p.heading)<=35?1:-1;
  if(dir>0&&a.road.dir<0||dir<0&&a.road.dir>0)return -1;
  double traveled=- (dir>0?a.p.station:a.p.length-a.p.station);
  WideHcopRoad.Road road=a.road;Set<String> seen=new HashSet<>();
  for(int hop=0;hop<64&&traveled<1500;hop++){
   if(!seen.add(road.id))return -1;
   if(road.id.equals(b.road.id)){double dist=traveled+(dir>0?b.p.station:b.p.length-b.p.station);return dist>12&&dist<=1500?1:-1;}
   WideRoad.Projection whole=WideRoad.project(road.xy,f.lat,f.lon,0);traveled+=whole.length;
   long exit=dir>0?road.end:road.start;
   double[][] xy=road.xy;int k=dir>0?xy.length-1:0,j=dir>0?k-1:1;
   double bearing=WideCameraEngine.bearing(xy[j][1],xy[j][0],xy[k][1],xy[k][0]);
   WideHcopRoad.Road next=null;int nd=0;
   for(WideHcopRoad.Road r:d.roads){
    if(seen.contains(r.id)||r.xy==null||r.xy.length<2)continue;
    int sign=r.start==exit&&r.dir>=0?1:r.end==exit&&r.dir<=0?-1:0;if(sign==0)continue;
    int start=sign>0?0:r.xy.length-1,end=sign>0?1:start-1;
    double h=WideCameraEngine.bearing(r.xy[start][1],r.xy[start][0],r.xy[end][1],r.xy[end][0]);
    if(WideRoad.delta(bearing,h)>35)continue;
    if(next!=null)return 0;next=r;nd=sign;
   }
   if(next==null)return -1;road=next;dir=nd;
  }
  return 0;
 }
}
