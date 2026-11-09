package com.navipilot.obf;

import android.content.Context;
import android.os.SystemClock;
import java.io.*;
import java.util.*;
import java.util.zip.GZIPInputStream;
import org.json.*;

/** Bounded tile cache and latest-only worker; GPS callbacks never parse map files. */
public final class WideHcop {
 private static Context context;private static boolean started,working;private static int generation;
 private static volatile boolean ready;private static WideCameraEngine.Fix latest;
 private static volatile WideHcopRoad.Decision decision=new WideHcopRoad.Decision("正在載入離線道路",0);
 private static volatile String metadata="",error="",summary="正在載入圖資";
 private static final WideHcopRoad.Tracker tracker=new WideHcopRoad.Tracker();
 private static Set<String> available=new HashSet<String>();
 private static final LinkedHashMap<String,WideHcopRoad.Data> cache=new LinkedHashMap<String,WideHcopRoad.Data>(32,.75f,true);
 private static int windowX=Integer.MIN_VALUE,windowY;private static WideHcopRoad.Data window;
 private static final long MIN_WALL=1793404800000L,MAX_WALL=1802736000000L; // 2026-10-31 through 2027-02-16 UTC
 public static synchronized void init(Context c){
  if(started)return;started=true;context=c.getApplicationContext();
  new Thread(new Runnable(){public void run(){try{
   JSONObject m=new JSONObject(read(context.getAssets().open("tw_hcop_metadata.json")));metadata=m.toString(2);
   available=new HashSet<String>(Arrays.asList(context.getAssets().list("tw_hcop")));
   summary="道路 "+m.getInt("edges")+" 段 · TDX "+m.getInt("tdxDirectionalStretches")+" 段 · 可配對固定點 "+m.getInt("matchedCameras")+" / "+m.getInt("cameras");
   ready=true;
  }catch(Exception e){error="圖資載入失敗："+e.getClass().getSimpleName();}}},"HcopMapInit").start();
 }
 private static String read(InputStream in)throws IOException{try{ByteArrayOutputStream b=new ByteArrayOutputStream();byte[] buf=new byte[8192];int n;while((n=in.read(buf))!=-1){if(b.size()+n>12*1024*1024)throw new IOException("tile too large");b.write(buf,0,n);}return new String(b.toByteArray(),"UTF-8");}finally{in.close();}}
 private static String[] strings(JSONArray a)throws JSONException{String[] s=new String[a.length()];for(int i=0;i<s.length;i++)s[i]=a.getString(i);return s;}
 private static double[][] points(JSONArray a)throws JSONException{double[][] ps=new double[a.length()][2];for(int i=0;i<ps.length;i++){ps[i][0]=a.getJSONArray(i).getDouble(0);ps[i][1]=a.getJSONArray(i).getDouble(1);}return ps;}
 private static WideHcopRoad.Data tile(String name)throws Exception{
  WideHcopRoad.Data hit=cache.get(name);if(hit!=null)return hit;
  hit=new WideHcopRoad.Data();
  if(available.contains(name)){
   JSONObject j=new JSONObject(read(new GZIPInputStream(context.getAssets().open("tw_hcop/"+name))));
   JSONArray a=j.getJSONArray("r");
   for(int i=0;i<a.length();i++){JSONArray r=a.getJSONArray(i);WideHcopRoad.Road v=new WideHcopRoad.Road();v.id=r.getString(0);v.names=strings(r.getJSONArray(1));v.dir=r.getInt(2);v.grade=r.getString(3);v.forward=r.getInt(4);v.backward=r.getInt(5);v.xy=points(r.getJSONArray(6));v.start=r.getLong(7);v.end=r.getLong(8);v.minLon=v.minLat=Double.POSITIVE_INFINITY;v.maxLon=v.maxLat=Double.NEGATIVE_INFINITY;for(double[] q:v.xy){v.minLon=Math.min(v.minLon,q[0]);v.maxLon=Math.max(v.maxLon,q[0]);v.minLat=Math.min(v.minLat,q[1]);v.maxLat=Math.max(v.maxLat,q[1]);}v.bounded=true;hit.roads.add(v);}
   a=j.getJSONArray("f");for(int i=0;i<a.length();i++){JSONArray r=a.getJSONArray(i);WideHcopRoad.Official v=new WideHcopRoad.Official();v.id=r.getInt(0);v.names=strings(r.getJSONArray(1));v.limit=r.getInt(2);v.xy=points(r.getJSONArray(3));v.source=r.getString(4);hit.signs.add(v);}
   a=j.getJSONArray("c");for(int i=0;i<a.length();i++){JSONArray r=a.getJSONArray(i);WideHcopRoad.Camera v=new WideHcopRoad.Camera();v.id=r.getString(0);v.edge=r.getString(1);v.road=r.getString(2);v.limit=r.getInt(3);v.lat=r.getDouble(4);v.lon=r.getDouble(5);JSONArray dirs=r.getJSONArray(6);v.dirs=new int[dirs.length()];for(int k=0;k<v.dirs.length;k++)v.dirs[k]=dirs.getInt(k);hit.cameras.add(v);}
  }
  cache.put(name,hit);while(cache.size()>12)cache.remove(cache.keySet().iterator().next());return hit;
 }
 private static WideHcopRoad.Data load(WideCameraEngine.Fix f)throws Exception{
  WideHcopRoad.Data data=new WideHcopRoad.Data();data.expired=System.currentTimeMillis()<MIN_WALL||System.currentTimeMillis()>=MAX_WALL;
  if(data.expired)return data;
  int x=(int)Math.floor(f.lon/.02),y=(int)Math.floor(f.lat/.02);
  if(window!=null&&windowX==x&&windowY==y){window.expired=false;return window;}
  Set<String> roads=new HashSet<String>(),cameras=new HashSet<String>();Set<Integer> signs=new HashSet<Integer>();
  for(int dx=-1;dx<=1;dx++)for(int dy=-1;dy<=1;dy++){
   WideHcopRoad.Data t=tile((x+dx)+"_"+(y+dy)+".json.gz");
   for(WideHcopRoad.Road r:t.roads)if(roads.add(r.id))data.roads.add(r);
   for(WideHcopRoad.Camera c:t.cameras)if(cameras.add(c.id))data.cameras.add(c);
   for(WideHcopRoad.Official o:t.signs)if(signs.add(o.id))data.signs.add(o);
  }
  windowX=x;windowY=y;window=data;return data;
 }
 public static synchronized void accept(WideCameraEngine.Fix f){
  latest=f;
  String bad=WideHcopRoad.invalid(f,SystemClock.elapsedRealtime());
  if(bad!=null){generation++;tracker.reset();decision=new WideHcopRoad.Decision(bad,SystemClock.elapsedRealtime());return;}
  if(!ready){decision=new WideHcopRoad.Decision(error.isEmpty()?summary:error,SystemClock.elapsedRealtime());return;}
  if(working)return;working=true;
  new Thread(new Runnable(){public void run(){drain();}},"HcopRoadMatch").start();
 }
 private static void drain(){
  while(true){WideCameraEngine.Fix f;int gen;synchronized(WideHcop.class){f=latest;gen=generation;}
   WideHcopRoad.Data data=null;String failure=null;
   try{if(f!=null)data=load(f);}catch(Exception e){failure="圖資讀取失敗："+e.getClass().getSimpleName();}
   synchronized(WideHcop.class){
    if(gen==generation&&f==latest){
     decision=failure==null?tracker.accept(data,f,SystemClock.elapsedRealtime()):new WideHcopRoad.Decision(failure,SystemClock.elapsedRealtime());
     if(failure!=null)tracker.reset();
     try{JSONObject j=json();if(f!=null){j.put("latitude",f.lat);j.put("longitude",f.lon);j.put("accuracy_m",f.accuracy);j.put("heading_deg",f.heading);j.put("speed_mps",f.speed);j.put("gps_mono_ms",f.time);}WideBridgeLog.event("hcop_match",j);}catch(Exception ignored){}
     working=false;return;
    }
    if(latest==null){working=false;return;}
   }
  }
 }
 public static synchronized void clear(){generation++;latest=null;tracker.reset();decision=new WideHcopRoad.Decision("等待新定位",SystemClock.elapsedRealtime());}
 public static WideHcopRoad.Decision current(){
  if(!WideCamera.running)return new WideHcopRoad.Decision("GPS 未啟動",SystemClock.elapsedRealtime());
  long now=SystemClock.elapsedRealtime();String bad=WideHcopRoad.invalid(WideCamera.fix(),now);
  if(bad!=null)return new WideHcopRoad.Decision(bad,now);
  WideHcopRoad.Decision d=decision;if(now<d.time||now-d.time>WideHcopRoad.FRESH_MS)return new WideHcopRoad.Decision("配對已過期",now);
  return d;
 }
 public static JSONObject json()throws JSONException{
  WideHcopRoad.Decision d=current();JSONObject j=new JSONObject();j.put("confirmed",d.confirmed);j.put("reason",d.reason);j.put("road",d.roadName());j.put("source",d.source);j.put("road_limit_kph",d.limit);j.put("gps_mono_ms",d.time);
  if(d.road!=null){j.put("edge",d.road.id);j.put("direction",d.direction);j.put("offset_m",d.offset);}
  if(d.camera!=null){j.put("cameraId",d.camera.id);j.put("camera_limit_kph",d.camera.limit);j.put("along_road_m",Math.round(d.distance));}return j;
 }
 public static String label(){WideHcopRoad.Decision d=current();return "道路速限 "+(d.confirmed&&d.limit>0?d.limit+" km/h · "+d.source:"—")+"\n"+(d.road!=null?d.roadName()+" · ":"")+d.reason+(WideBridge.enabled()?"":"（預覽）");}
 public static String report(){return summary+"\n"+label()+"\n"+error+"\n"+metadata;}
}
