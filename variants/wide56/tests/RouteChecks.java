package com.navipilot.obf;
import org.json.*;
public final class RouteChecks {
 static int checks;
 static void check(boolean value,String name){checks++;if(!value)throw new AssertionError(name);}
 static JSONObject nav(int path,int seg,int icon,int distance)throws Exception {
  return new JSONObject().put("pathID",path).put("curSegIdx",seg).put("curManeuverID",icon)
   .put("segmentRemainDist",distance).put("nextRouteName","120縣道").put("routeRemainDist",900)
   .put("routeRemainTime",100).put("speed",42).put("cameraSpeedLimit",30);
 }
 static JSONObject group(int id,int points)throws Exception {
  JSONArray segments=new JSONArray();
  for(int s=0;s<2;s++){
   JSONArray lat=new JSONArray(),lon=new JSONArray();
   for(int i=0;i<points;i++){lat.put(24.7+s*.005+i*.005/(points-1));lon.put(121.0+Math.sin(i*.2)*.0001);}
   JSONObject link=new JSONObject().put("lat",lat).put("lon",lon).put("length",500).put("status",1).put("fineStatus",0);
   segments.put(new JSONObject().put("length",500).put("iconType",s==0?3:2).put("linkInfo",new JSONArray().put(link)));
  }
  JSONObject r=new JSONObject().put("segmentInfo",segments).put("routeLength",1000).put("routeTime",120);
  return new JSONObject().put("highlightRoute",id).put("info",new JSONObject().put(Integer.toString(id),r));
 }
 static WideAmapLinkNavigation ready(int points)throws Exception{
  WideAmapLinkNavigation n=new WideAmapLinkNavigation();n.reset(1);
  n.accept(1,2,group(11,points),100,100000);
  n.accept(1,4,nav(11,0,3,120),101,100001);return n;
 }
 public static void main(String[] args)throws Exception{
  WideAmapLinkNavigation n=ready(2000);
  WideAmapLinkNavigation.Snapshot x=n.snapshot(101);
  check(x.route!=null,"full route");
  JSONArray p=x.route.getJSONArray("polyline");
  check(p.length()>256,"route must exercise old C4 truncation");
  check(p.length()<=4096,"point budget");
  check(p.getJSONObject(0).getDouble("lat")==24.7,"original start");
  check(Math.abs(p.getJSONObject(p.length()-1).getDouble("lat")-24.71)<1e-8,"original destination retained");
  check(x.next.getInt("distance_m")==500,"next distance is between turns, not 620");
  check(x.next.getInt("turn_type")==12,"next left");
  check(x.status.getBoolean("route_present"),"route status");
  check(x.stream("speed")==null,"no speed or camera limit substitution");
  if(args.length>0)System.out.println(new JSONObject().put("route",x.route).put("guidance_current",x.guidance).put("guidance_next",x.next).put("navigation_status",x.status));
  x.route.getJSONArray("polyline").getJSONObject(0).put("lat",0);
  check(n.snapshot(101).route.getJSONArray("polyline").getJSONObject(0).getDouble("lat")==24.7,"defensive snapshot");
  check(n.snapshot(3102).route==null,"stale withdrawal");
  check(n.snapshot(3102).next==null,"next TTL");
  check(n.snapshot(100).route==null,"clock reversal");
  n.accept(1,5,new JSONObject().put("maneuverID",3),200,100100);
  check(n.snapshot(3102).route==null,"icon cannot renew geometry");
  n=ready(20);n.accept(1,20,new JSONObject().put("routeId",22),110,100010);
  check(n.snapshot(110).route==null,"selection clears previous route");
  check(n.snapshot(110).guidance==null,"selection clears old turn");
  n.accept(1,4,nav(22,0,3,120),111,100011);
  check(n.snapshot(111).route==null,"unknown new path waits geometry");
  n.accept(1,2,group(22,20),112,100012);
  check(n.snapshot(112).route==null,"route change waits new current guidance");
  n.accept(1,4,nav(22,0,3,120),113,100013);
  check(n.snapshot(113).route!=null,"new route recovers");
  n.accept(1,20,new JSONObject().put("routeId",22),114,100014);
  check(n.snapshot(114).route!=null,"same selection retains guidance");
  for(int type:new int[]{3,19,100,200}){n=ready(20);n.accept(1,type,new JSONObject(),110,100010);check(n.snapshot(110).route==null,"clear event "+type);}
  n=ready(20);n.reset(2);check(n.snapshot(111).route==null,"session reset");
  check(!n.accept(1,2,group(11,20),112,100012),"old session rejected");
  n=ready(20);n.accept(1,4,nav(11,0,2,120),110,100010);check(n.snapshot(110).next==null,"index/icon disagreement no next");
  n=ready(20);n.accept(1,4,nav(11,1,2,120),110,100010);check(n.snapshot(110).next==null,"last segment no next");
  n=ready(20);n.accept(1,4,new JSONObject().put("speed",50),110,100010);check(n.snapshot(110).route==null,"partial turn invalidates route freshness");
  n=ready(20);n.accept(1,4,nav(11,0,3,120),90,100010);check(n.snapshot(101).route!=null,"old receipt ignored");
  JSONObject malformed=group(11,20);malformed.getJSONObject("info").getJSONObject("11").getJSONArray("segmentInfo").getJSONObject(0).getJSONArray("linkInfo").getJSONObject(0).getJSONArray("lat").put(0,JSONObject.NULL);
  n=ready(20);n.accept(1,2,malformed,110,100010);n.accept(1,4,nav(11,0,3,120),111,100011);check(n.snapshot(111).route==null,"bad coordinate rejects whole route");
  malformed=group(11,20);malformed.put("highlightRoute",22);
  n=ready(20);n.accept(1,2,malformed,110,100010);check(n.snapshot(110).route==null,"never pick first alternative");
  WideAmapLinkRoute r=new WideAmapLinkRoute();malformed=group(11,20);malformed.getJSONObject("info").getJSONObject("11").put("routeLength",2000);r.acceptGroup(malformed);check(!r.ready(),"partial geometry length mismatch");
  r.acceptGroup(new JSONObject().put("routes",new JSONArray().put(11)));check(!r.ready(),"ID list is not geometry");
  if(args.length==0)System.out.println("RouteChecks: "+checks+" assertions passed");
 }
}
