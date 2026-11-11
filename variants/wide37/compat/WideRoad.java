package com.navipilot.obf;
import java.util.*;
/** Conservative same-edge matching: never crosses an OSM junction or guesses a route. */
public final class WideRoad {
 public static final class Corridor {
  public String id,road,osmName;public long osm;public int limit;public double lat,lon;public int[] dirs;public double[][] xy;public double[][][] others;
 }
 public static final class Projection {
  public double offset=Double.POSITIVE_INFINITY,station,heading,length;public boolean ambiguous;
 }
 public static final class Match {
  public final Corridor camera;public final double distance;public final int direction;public final String reason;public final long time;
  public Match(Corridor c,double d,int dir,String r,long t){camera=c;distance=d;direction=dir;reason=r;time=t;}
 }
 public static double delta(double a,double b){double d=Math.abs(a-b)%360;return Math.min(d,360-d);}
 public static Projection project(double[][] line,double lat,double lon,double tolerance){
  Projection p=new Projection();double sx=111320*Math.cos(Math.toRadians(lat)),sy=111320,total=0;ArrayList<double[]> candidates=new ArrayList<double[]>();
  for(int i=1;i<line.length;i++){
   double ax=(line[i-1][0]-lon)*sx,ay=(line[i-1][1]-lat)*sy,bx=(line[i][0]-lon)*sx,by=(line[i][1]-lat)*sy;
   double dx=bx-ax,dy=by-ay,len=Math.hypot(dx,dy);if(len<.01)continue;
   double t=Math.max(0,Math.min(1,-(ax*dx+ay*dy)/(len*len))),off=Math.hypot(ax+t*dx,ay+t*dy),station=total+t*len;
   candidates.add(new double[]{off,station});
   if(off<p.offset){p.offset=off;p.station=station;p.heading=(Math.toDegrees(Math.atan2(dx,dy))+360)%360;}
   total+=len;
  }
  p.length=total;
  for(double[] c:candidates)if(Math.abs(c[1]-p.station)>40&&c[0]-p.offset<tolerance)p.ambiguous=true;
  return p;
 }
 public static String invalid(WideCameraEngine.Fix f,long now){
  if(f==null)return "等待 GPS";
  if(f.mock)return "模擬定位不傳送";
  if(now-f.time>5000||now<f.time)return "GPS 已過期";
  if(!Double.isFinite(f.lat)||!Double.isFinite(f.lon)||!Double.isFinite(f.accuracy)||!Double.isFinite(f.heading)||!Double.isFinite(f.speed)||f.lat<20||f.lat>27||f.lon<116||f.lon>124)return "GPS 數值無效";
  if(f.accuracy<=0||f.accuracy>15)return "GPS 精度不足（需 ≤15 m）";
  if(!f.headingValid||f.speed<1.5||f.speed>60)return "等待有效行進方向";
  return null;
 }
 public static Match match(List<Corridor> all,WideCameraEngine.Fix f,long now){
  String bad=invalid(f,now);if(bad!=null)return new Match(null,0,0,bad,now);
  Match winner=null;
  for(Corridor c:all){
   if(WideCameraEngine.distance(f.lat,f.lon,c.lat,c.lon)>1600)continue;
   double tolerance=Math.max(12,f.accuracy*2);
   Projection p=project(c.xy,f.lat,f.lon,tolerance);
   if(p.ambiguous||p.offset>Math.min(20,Math.max(8,f.accuracy))||p.station<20||p.length-p.station<20)continue;
   int dir=0;for(int d:c.dirs)if(delta(f.heading,(p.heading+(d<0?180:0))%360)<=25)dir=d;
   if(dir==0)continue;
   boolean ambiguous=false;
   for(double[][] other:c.others)if(project(other,f.lat,f.lon,0).offset-p.offset<tolerance){ambiguous=true;break;}
   if(ambiguous)continue;
   Projection camera=project(c.xy,c.lat,c.lon,0);double distance=(camera.station-p.station)*dir;
   if(distance<=20||distance>1500)continue;
   if(winner!=null&&winner.camera.osm!=c.osm)return new Match(null,0,0,"多條道路候選，暫不傳送",now);
   if(winner==null||distance<winner.distance)winner=new Match(c,distance,dir,"同一道路段配對",f.time);
  }
  return winner==null?new Match(null,0,0,"無可確認的同路段測速點",now):winner;
 }
 public static final class Tracker {
  private WideCameraEngine.Fix last;private String id="";private int direction,count;private long start;
  public synchronized void reset(){last=null;id="";count=0;}
  public synchronized Match accept(List<Corridor> all,WideCameraEngine.Fix f,long now){
   if(last!=null&&f!=null&&f.time<=last.time){reset();return new Match(null,0,0,"GPS 時間未前進",now);}
   if(last!=null&&f!=null){double dt=(f.time-last.time)/1000.;
    if(dt>5||WideCameraEngine.distance(last.lat,last.lon,f.lat,f.lon)>Math.max(25,Math.max(last.speed,f.speed)*dt+last.accuracy+f.accuracy+5)){reset();last=f;return new Match(null,0,0,"GPS 中斷或跳點，重新配對",now);}
   }
   last=f;Match m=match(all,f,now);
   if(m.camera==null){id="";count=0;return m;}
   if(!m.camera.id.equals(id)||m.direction!=direction){id=m.camera.id;direction=m.direction;count=1;start=f.time;}else count++;
   return count>=3&&f.time-start>=1500?m:new Match(null,0,0,"道路配對確認中（至少 3 次定位）",now);
  }
 }
}
