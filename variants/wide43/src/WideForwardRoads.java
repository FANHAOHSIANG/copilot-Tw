package com.navipilot.obf;
import java.util.*;

/** Bounded directional OSM exploration for UI/audio only; no destination or network required. */
final class WideForwardRoads {
 static final double HORIZON_METERS=2000;
 static final int MAX_STATES=256, MAX_BRANCHES=3;
 static final class Step {
  final WideHcopRoad.Road road;final int direction,depth;final double entryDistance,penalty,length;
  final Set<String> visited;
  Step(WideHcopRoad.Road r,int d,double entry,double cost,int depth,Set<String> seen){
   road=r;direction=d;entryDistance=entry;penalty=cost;this.depth=depth;visited=seen;
   length=WideRoad.project(r.xy,r.xy[0][1],r.xy[0][0],0).length;
  }
  long exit(){return direction>0?road.end:road.start;}
 }
 static boolean sameName(WideHcopRoad.Road a,WideHcopRoad.Road b){
  if(a.names==null||b.names==null)return false;
  for(String x:a.names)for(String y:b.names)if(x!=null&&x.equals(y)&&x.length()>1&&!x.matches("[0-9]+"))return true;
  return false;
 }
 static double tangent(WideHcopRoad.Road r,int d,boolean atExit){
  int n=r.xy.length;int i=(atExit==(d>0))?n-2:0;
  double h=WideCameraEngine.bearing(r.xy[i][1],r.xy[i][0],r.xy[i+1][1],r.xy[i+1][0]);
  return (h+(d<0?180:0))%360;
 }
 static List<Step> explore(WideHcopRoad.Data data,WideHcopRoad.Road start,int direction,double station){
  List<Step> result=new ArrayList<>();
  if(data==null||data.expired||start==null||start.xy==null||start.xy.length<2)return result;
  Map<Long,List<WideHcopRoad.Road>> adjacency=new HashMap<>();
  for(WideHcopRoad.Road r:data.roads){
   if(r.xy==null||r.xy.length<2)continue;
   if(r.dir>=0&&r.start!=0)add(adjacency,r.start,r);
   if(r.dir<=0&&r.end!=0)add(adjacency,r.end,r);
  }
  Comparator<Step> order=new Comparator<Step>(){public int compare(Step a,Step b){
   int c=Double.compare(a.penalty,b.penalty);if(c==0)c=Double.compare(a.entryDistance,b.entryDistance);
   return c==0?a.road.id.compareTo(b.road.id):c;
  }};
  PriorityQueue<Step> queue=new PriorityQueue<>(16,order);
  double length=WideRoad.project(start.xy,start.xy[0][1],start.xy[0][0],0).length;
  queue.add(new Step(start,direction,-(direction>0?station:length-station),0,0,new HashSet<String>()));
  Set<String> expanded=new HashSet<>();
  while(!queue.isEmpty()&&result.size()<MAX_STATES){
   Step s=queue.remove();String key=s.road.id+":"+s.direction;
   if(s.visited.contains(key)||s.entryDistance>HORIZON_METERS||!expanded.add(key))continue;
   result.add(s);
   if(s.depth>=64||s.length<=.1||s.entryDistance+s.length>HORIZON_METERS)continue;
   List<WideHcopRoad.Road> connected=adjacency.get(s.exit());if(connected==null)continue;
   List<Step> options=new ArrayList<>();
   for(WideHcopRoad.Road r:connected){
    if(r.id.equals(s.road.id))continue;
    // Without a route, do not predict leaving and rejoining the original road
    // through a side street (often a median crossing to the opposite carriageway).
    if(s.depth>0 && sameName(start,r) && !sameName(start,s.road))continue;
    int d=r.start==s.exit()&&r.dir>=0?1:r.end==s.exit()&&r.dir<=0?-1:0;
    if(d==0)continue;
    double turn=WideCameraEngine.difference(tangent(s.road,s.direction,true),tangent(r,d,false));
    if(turn>110)continue;
    double cost=s.penalty+(sameName(s.road,r)?0:2)+turn/90.0;
    Set<String> seen=new HashSet<>(s.visited);seen.add(key);
    options.add(new Step(r,d,s.entryDistance+s.length,cost,s.depth+1,seen));
   }
   Collections.sort(options,order);
   for(int i=0;i<Math.min(MAX_BRANCHES,options.size());i++)if(queue.size()<MAX_STATES*MAX_BRANCHES)queue.add(options.get(i));
  }
  return result;
 }
 private static void add(Map<Long,List<WideHcopRoad.Road>> map,long node,WideHcopRoad.Road road){
  List<WideHcopRoad.Road> list=map.get(node);if(list==null){list=new ArrayList<>();map.put(node,list);}list.add(road);
 }
}
