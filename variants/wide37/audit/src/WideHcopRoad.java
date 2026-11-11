package com.navipilot.obf;

import java.util.*;

/** Offline, directional road matching. No Android calls or network I/O. */
public final class WideHcopRoad {
 public static final long FRESH_MS=3000;
 public static final class Road {
  public String id,grade; public String[] names; public int dir,forward,backward;
  public long start,end; public double[][] xy;public double minLon,maxLon,minLat,maxLat;public boolean bounded;
 }
 public static final class Official {
  public int id,limit; public String[] names; public String source; public double[][] xy;
 }
 public static final class Camera {
  public String id,edge,road; public int limit; public double lat,lon; public int[] dirs;
 }
 public static final class Data {
  public final List<Road> roads=new ArrayList<Road>();
  public final List<Official> signs=new ArrayList<Official>();
  public final List<Camera> cameras=new ArrayList<Camera>();
  public boolean expired;
 }
 public static final class Decision {
  public Road road; public Camera camera; public int direction,limit; public double distance,offset;
  public String source="none",reason; public long time; public boolean confirmed;
  public Decision(String why,long t){reason=why;time=t;}
  public String roadName(){return road==null?"":road.names.length==0?"未命名道路":road.names[0];}
 }
 public static String invalid(WideCameraEngine.Fix f,long now){
  if(f==null)return "等待 GPS";
  if(f.mock)return "模擬定位，不採用";
  if(f.time<=0||now<f.time||now-f.time>FRESH_MS)return "GPS 超過 3 秒，資料已撤銷";
  if(!Double.isFinite(f.lat)||!Double.isFinite(f.lon)||f.lat<20||f.lat>27||f.lon<116||f.lon>124)return "定位超出資料範圍";
  if(!Double.isFinite(f.accuracy)||f.accuracy<=0||f.accuracy>15)return "GPS 精度不足，需 ≤15 m";
  if(!f.headingValid||!Double.isFinite(f.heading)||f.heading<0||f.heading>=360||!Double.isFinite(f.speed)||f.speed<2||f.speed>60)return "等待可靠行進方向";
  return null;
 }
 private static boolean names(String[] a,String[] b){for(String x:a)for(String y:b)if(x.equals(y))return true;return false;}
 private static boolean dir(Camera c,int d){for(int x:c.dirs)if(x==d)return true;return false;}
 private static int direction(Road r,WideRoad.Projection p,double heading){
  if(r.dir>=0&&WideRoad.delta(heading,p.heading)<=25)return 1;
  if(r.dir<=0&&WideRoad.delta(heading,(p.heading+180)%360)<=25)return -1;
  return 0;
 }
 public static Decision match(Data data,WideCameraEngine.Fix f,long now){
  String invalid=invalid(f,now); if(invalid!=null)return new Decision(invalid,now);
  if(data==null)return new Decision("圖資載入中",now);
  if(data.expired)return new Decision("圖資已過有效期，請更新測試包",now);
  Road best=null;WideRoad.Projection bp=null;int direction=0;
  ArrayList<Road> near=new ArrayList<Road>();ArrayList<WideRoad.Projection> projections=new ArrayList<WideRoad.Projection>();
  double tol=Math.max(10,f.accuracy*1.5),max=Math.min(18,Math.max(8,f.accuracy));
  for(Road r:data.roads){
   if(r.bounded&&(f.lon<r.minLon-.0005||f.lon>r.maxLon+.0005||f.lat<r.minLat-.0005||f.lat>r.maxLat+.0005))continue;
   WideRoad.Projection p=WideRoad.project(r.xy,f.lat,f.lon,tol);
   if(p.offset>45)continue;near.add(r);projections.add(p);
   int d=direction(r,p,f.heading);
   if(d!=0&&!p.ambiguous&&p.offset<=max&&(bp==null||p.offset<bp.offset)){best=r;bp=p;direction=d;}
  }
  if(best==null)return new Decision("未確認目前道路／方向",f.time);
  // A nearby alternative is evaluated even if its speed is unknown. Different grades cannot be resolved by 2-D GPS.
  for(int i=0;i<near.size();i++){
   Road r=near.get(i);WideRoad.Projection p=projections.get(i);if(r.id.equals(best.id))continue;
   if(p.offset-bp.offset>=tol)continue;
   boolean joined=(r.start==best.start||r.start==best.end||r.end==best.start||r.end==best.end)
       &&r.grade.equals(best.grade)&&names(r.names,best.names)&&Math.min(WideRoad.delta(p.heading,bp.heading),WideRoad.delta(p.heading,(bp.heading+180)%360))<15;
   if(joined)continue;
   if(!r.grade.equals(best.grade)||direction(r,p,f.heading)!=0||p.offset<Math.max(5,f.accuracy))
    return new Decision("平行道路／路口／高架平面無法區分",f.time);
  }
  if(bp.station<8||bp.length-bp.station<8)return new Decision("路段交界，等待進入道路",f.time);
  Decision out=new Decision("道路已配對",f.time);out.road=best;out.direction=direction;out.offset=bp.offset;
  int npa=0;boolean npaConflict=false;
  for(Camera c:data.cameras){
   if(!c.edge.equals(best.id)||!dir(c,direction))continue;
   WideRoad.Projection cp=WideRoad.project(best.xy,c.lat,c.lon,0);
   double dist=(cp.station-bp.station)*direction;
   if(dist>20&&dist<=1500&&(out.camera==null||dist<out.distance)){out.camera=c;out.distance=dist;}
   // Unlike HCOP's 800 m circles, only this verified junction-bounded edge and direction, within 200 m.
   if(Math.abs(dist)<=200){if(npa!=0&&npa!=c.limit)npaConflict=true;npa=c.limit;}
  }
  if(npaConflict){out.reason="同路段官方測速速限衝突，道路速限不採用";return out;}
  if(npa>0){out.limit=npa;out.source="NPA";out.reason="警政署同路段局部修正";return out;}
  int sign=0;boolean conflict=false;
  for(Official o:data.signs){
   if(!names(best.names,o.names))continue;
   WideRoad.Projection p=WideRoad.project(o.xy,f.lat,f.lon,12);
   if(p.ambiguous||p.offset>15||p.station<8||p.length-p.station<8||WideRoad.delta(p.heading,f.heading)>25)continue;
   if(sign!=0&&sign!=o.limit)conflict=true;sign=o.limit;
  }
  if(conflict){out.reason="TDX 同方向資料衝突，道路速限不採用";return out;}
  if(sign>0){out.limit=sign;out.source="TDX";out.reason="TDX 同道路同方向速限";return out;}
  out.limit=direction==1?best.forward:best.backward;
  if(out.limit>0){out.source="OSM";out.reason="OSM 道路速限";}else out.reason="道路已確認，尚無可用道路速限";
  return out;
 }
 public static final class Tracker {
  private WideCameraEngine.Fix last;private String key="";private int count;private long first;private double moved;
  public synchronized void reset(){last=null;key="";count=0;moved=0;}
  public synchronized Decision accept(Data data,WideCameraEngine.Fix f,long now){
   String bad=invalid(f,now);if(bad!=null){reset();return new Decision(bad,now);}
   double distance=0;
   if(last!=null){double dt=(f.time-last.time)/1000.;distance=WideCameraEngine.distance(last.lat,last.lon,f.lat,f.lon);
    if(dt<=0||dt>3||distance>Math.max(25,Math.max(last.speed,f.speed)*dt+last.accuracy+f.accuracy+5)){
     reset();last=f;return new Decision("定位跳點或中斷，重新確認",now);
    }
   }
   last=f;Decision d=match(data,f,now);
   if(d.road==null){key="";count=0;moved=0;return d;}
   String k=d.road.id+":"+d.direction+":"+d.limit+":"+d.source;
   if(!k.equals(key)){key=k;first=f.time;count=1;moved=0;}else{count++;moved+=distance;}
   if(count<3||f.time-first<1500||moved<5)return new Decision("道路確認中：至少 3 次定位／移動 5 m",f.time);
   d.confirmed=true;return d;
  }
 }
}
