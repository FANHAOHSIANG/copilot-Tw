package com.navipilot.obf;
import java.util.*;import java.nio.file.*;import java.lang.reflect.*;import org.json.*;import android.os.SystemClock;
public class RuntimeMapTest {
 static int n;static void ok(boolean b,String s){if(!b)throw new AssertionError(s);n++;}
 static Field field(String name)throws Exception{Field f=WideHcop.class.getDeclaredField(name);f.setAccessible(true);return f;}
 static void idle()throws Exception{long end=System.nanoTime()+5000000000L;while(field("working").getBoolean(null)&&System.nanoTime()<end)Thread.sleep(5);ok(!field("working").getBoolean(null),"worker finishes");}
 static WideCameraEngine.Fix point(WideHcopRoad.Road r,double station,int direction,long time){
  double lat0=r.xy[0][1],sx=111320*Math.cos(Math.toRadians(lat0)),total=0;
  for(int i=1;i<r.xy.length;i++){
   double dx=(r.xy[i][0]-r.xy[i-1][0])*sx,dy=(r.xy[i][1]-r.xy[i-1][1])*111320,len=Math.hypot(dx,dy);
   if(total+len>=station&&len>0){double q=Math.max(0,Math.min(1,(station-total)/len));return new WideCameraEngine.Fix(r.xy[i-1][1]+q*(r.xy[i][1]-r.xy[i-1][1]),r.xy[i-1][0]+q*(r.xy[i][0]-r.xy[i-1][0]),6,(Math.toDegrees(Math.atan2(dx,dy))+360+(direction<0?180:0))%360,10,time,true,false);}
   total+=len;
  }return null;
 }
 public static void main(String[]args)throws Exception{
  JSONObject meta=new JSONObject(new String(Files.readAllBytes(Paths.get("work/assets/tw_hcop_metadata.json")),"UTF-8"));ok(meta.getInt("edges")>1000000,"complete offline roads present");ok(meta.getInt("matchedCameras")==482,"camera association count");
  WideHcop.init(new android.content.Context());long end=System.nanoTime()+5000000000L;while(!field("ready").getBoolean(null)&&System.nanoTime()<end)Thread.sleep(10);ok(field("ready").getBoolean(null),"assets initialized");
  Method load=WideHcop.class.getDeclaredMethod("load",WideCameraEngine.Fix.class);load.setAccessible(true);
  JSONArray cameras=new JSONArray(new String(Files.readAllBytes(Paths.get("work/data/matched-cameras.json")),"UTF-8"));int examined=0,matched=0;Map<String,Integer> reasons=new TreeMap<String,Integer>();List<Long> times=new ArrayList<Long>();WideCameraEngine.Fix[] good=null;int goodLimit=0;
  for(int z=0;z<cameras.length();z+=5){JSONArray c=cameras.getJSONArray(z);WideCameraEngine.Fix center=new WideCameraEngine.Fix(c.getDouble(4),c.getDouble(5),6,0,10,10000,true,false);
   long begin=System.nanoTime();WideHcopRoad.Data d=(WideHcopRoad.Data)load.invoke(null,center);WideHcopRoad.Road r=null;for(WideHcopRoad.Road v:d.roads)if(v.id.equals(c.getString(1)))r=v;ok(r!=null,"camera edge in tiles");
   int dir=c.getJSONArray(6).getInt(0);WideRoad.Projection cp=WideRoad.project(r.xy,center.lat,center.lon,0);double space=dir==1?cp.station:cp.length-cp.station;double distance=Math.min(100,space-30);if(distance<45)continue;
   WideCameraEngine.Fix f=point(r,cp.station-dir*distance,dir,10000);if(f==null)continue;
   WideHcopRoad.Decision v=WideHcopRoad.match(d,f,10000);examined++;times.add((System.nanoTime()-begin)/1000000);reasons.put(v.reason,reasons.containsKey(v.reason)?reasons.get(v.reason)+1:1);
   if(v.road!=null&&v.camera!=null&&v.limit==c.getInt(3)&&v.source.equals("NPA")){matched++;if(good==null){WideCameraEngine.Fix[] fs=new WideCameraEngine.Fix[3];boolean yes=true;for(int i=0;i<3;i++){fs[i]=point(r,cp.station-dir*(distance-i*10),dir,10000+i*1000);WideHcopRoad.Decision t=WideHcopRoad.match(d,fs[i],10000+i*1000);if(t.road==null||t.limit!=c.getInt(3))yes=false;}if(yes){good=fs;goodLimit=c.getInt(3);}}}
   if(examined>=60)break;
  }
  ok(examined>=30&&matched>=10,"nonempty real map coverage");ok(good!=null,"continuous real geometry fixture");
  for(WideCameraEngine.Fix f:good){SystemClock.now=f.time;WideCamera.f=f;WideHcop.accept(f);idle();}
  ok(WideHcop.current().confirmed&&WideHcop.current().limit==goodLimit,"real assets async pipeline confirms");
  SystemClock.now+=3001;ok(!WideHcop.current().confirmed,"runtime stale GPS withdraws");
  WideHcop.clear();ok(!WideHcop.current().confirmed,"runtime clear");
  ok(((Map)field("cache").get(null)).size()<=12,"bounded tile cache");
  JSONArray fixes=new JSONObject(new String(Files.readAllBytes(Paths.get("work/upstream/hcop-fixes.json")),"UTF-8")).getJSONArray("fixes");int tdxChecked=0,tdxMatched=0;
  for(int i=0;i<fixes.length();i+=37){JSONObject o=fixes.getJSONObject(i);JSONArray line=o.optJSONArray("line");if(line==null||line.length()<2)continue;int k=Math.max(1,line.length()/2);JSONArray a=line.getJSONArray(k-1),b=line.getJSONArray(k);double lat=(a.getDouble(0)+b.getDouble(0))/2,lon=(a.getDouble(1)+b.getDouble(1))/2;double h=WideCameraEngine.bearing(a.getDouble(0),a.getDouble(1),b.getDouble(0),b.getDouble(1));WideCameraEngine.Fix f=new WideCameraEngine.Fix(lat,lon,6,h,10,20000,true,false);WideHcopRoad.Data d=(WideHcopRoad.Data)load.invoke(null,f);WideHcopRoad.Decision v=WideHcopRoad.match(d,f,20000);tdxChecked++;if(v.source.equals("TDX")&&v.limit==o.getInt("limit"))tdxMatched++;if(tdxChecked>=150)break;}
  ok(tdxChecked==150&&tdxMatched>=10,"actual HCOP TDX lines join to OSM roads");
  Collections.sort(times);JSONObject report=new JSONObject();report.put("assertions",n);report.put("tdxSyntheticPositions",tdxChecked);report.put("tdxAccepted",tdxMatched);report.put("syntheticPositionsOnRealMap",examined);report.put("acceptedCameraRoadMatches",matched);report.put("reasons",new JSONObject(reasons));report.put("medianLoadAndMatchMs",times.get(times.size()/2));report.put("maxLoadAndMatchMs",Collections.max(times));report.put("deviceRuntime",false);report.put("note","Positions synthesized on actual map geometry; coverage count is not a real-driving success rate.");Files.write(Paths.get("work/build/runtime-map-tests.json"),report.toString(2).getBytes("UTF-8"));System.out.println(report.toString(2));
 }
}
