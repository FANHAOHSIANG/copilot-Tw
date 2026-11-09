package com.navipilot.obf;
import android.content.*;
import android.os.SystemClock;
import java.io.*;
import java.util.*;
import org.json.*;

/** Uses the existing negotiated Navi v2 stream. No second socket, no drive commands. */
public final class WideBridge {
 private static volatile Context context;private static volatile boolean started,ready,enabled;
 private static volatile List<WideRoad.Corridor> roads=Collections.emptyList();
 private static final WideRoad.Tracker tracker=new WideRoad.Tracker();
 private static volatile WideRoad.Match matched=new WideRoad.Match(null,0,0,"正在載入道路",0);
 private static final ThreadLocal<Long> preparedTime=new ThreadLocal<Long>();
 private static volatile String loadStatus="道路未載入",lastQueue="等待原有導航通道",lastTarget="",lastReceipt="C4 尚未確認",metadata="";
 private static volatile long queueAt,receiptAt,queuedCount,receivedCount,failedCount,lastTelemetryLog;
 private static volatile long lastProbe;private static final java.util.concurrent.atomic.AtomicBoolean probing=new java.util.concurrent.atomic.AtomicBoolean();
 private static volatile String probeStatus="等待可核對的測速封包";
 private static final LinkedHashMap<String,Pending> pending=new LinkedHashMap<String,Pending>();
 private static final class Pending {String host;int limit,distance;long time;}
 public static synchronized void init(Context c){
  if(started)return;started=true;context=c.getApplicationContext();WideBridgeLog.init(context);
  // Test mode is deliberately not restored across process restarts.
  enabled=false;
  new Thread(new Runnable(){public void run(){try{
   InputStream in=context.getAssets().open("tw_corridors.json");ByteArrayOutputStream out=new ByteArrayOutputStream();try{byte[] b=new byte[8192];int n;while((n=in.read(b))!=-1)out.write(b,0,n);}finally{in.close();}
   JSONObject doc=new JSONObject(new String(out.toByteArray(),"UTF-8"));metadata=doc.getJSONObject("metadata").toString(2);JSONArray a=doc.getJSONArray("corridors");ArrayList<WideRoad.Corridor> list=new ArrayList<WideRoad.Corridor>();
   for(int i=0;i<a.length();i++){JSONObject j=a.getJSONObject(i);WideRoad.Corridor r=new WideRoad.Corridor();r.id=j.getString("id");r.road=j.getString("road");r.osmName=j.getString("osmName");r.osm=j.getLong("osm");r.limit=j.getInt("limit");r.lat=j.getDouble("lat");r.lon=j.getDouble("lon");r.xy=xy(j.getJSONArray("xy"));JSONArray d=j.getJSONArray("dirs");r.dirs=new int[d.length()];for(int n=0;n<d.length();n++)r.dirs[n]=d.getInt(n);JSONArray others=j.getJSONArray("others");r.others=new double[others.length()][][];for(int n=0;n<others.length();n++)r.others[n]=xy(others.getJSONArray(n));list.add(r);}
   roads=Collections.unmodifiableList(list);ready=true;loadStatus="同路段可配對固定點 "+list.size()+" / 1856（仍須 GPS 確認）";
  }catch(Exception e){loadStatus="道路載入失敗："+e.getClass().getSimpleName();}}},"TaiwanRoadData").start();
 }
 private static double[][] xy(JSONArray a)throws JSONException{double[][] xy=new double[a.length()][2];for(int i=0;i<a.length();i++){xy[i][0]=a.getJSONArray(i).getDouble(0);xy[i][1]=a.getJSONArray(i).getDouble(1);}return xy;}
 public static boolean enabled(){return enabled;}
 public static synchronized void setEnabled(boolean value){enabled=value;tracker.reset();matched=new WideRoad.Match(null,0,0,"來源切換，等待新定位",SystemClock.elapsedRealtime());synchronized(pending){pending.clear();}receiptAt=0;queueAt=0;lastQueue="等待原有導航通道更新";lastReceipt="C4 尚未確認";WideBridgeLog.event("source",value?"taiwan":"amap");}
 public static void accept(WideCameraEngine.Fix f){
  matched=ready?tracker.accept(roads,f,SystemClock.elapsedRealtime()):new WideRoad.Match(null,0,0,loadStatus,SystemClock.elapsedRealtime());
  try{JSONObject j=new JSONObject();j.put("match",decision());if(f!=null){j.put("latitude",f.lat);j.put("longitude",f.lon);j.put("accuracy_m",f.accuracy);j.put("heading_deg",f.heading);j.put("speed_mps",f.speed);j.put("gps_mono_ms",f.time);j.put("mock",f.mock);}WideBridgeLog.event("gps",j);}catch(Exception ignored){}
 }
 public static void clear(){tracker.reset();matched=new WideRoad.Match(null,0,0,"GPS 已停止",SystemClock.elapsedRealtime());}
 public static WideRoad.Match current(){
  long now=SystemClock.elapsedRealtime();if(!WideCamera.running)return new WideRoad.Match(null,0,0,"GPS 未啟動",now);
  String bad=WideRoad.invalid(WideCamera.fix(),now);if(bad!=null)return new WideRoad.Match(null,0,0,bad,now);
  WideRoad.Match m=matched;if(now-m.time>5000)return new WideRoad.Match(null,0,0,"配對已過期",now);return m;
 }
 public static JSONObject merge(String name,JSONObject original,Map times){
  if(!"speed".equals(name))return original;
  preparedTime.remove();if(!enabled)return original;
  try{
   long wall=System.currentTimeMillis(),mono=SystemClock.elapsedRealtime();Object source=times.get("speed");long old=source instanceof Number?((Number)source).longValue():0;
   boolean fresh=old>0&&wall>=old&&wall-old<=2000;
   WideRoad.Match m=current();JSONObject out=WideSpeedMerge.merge(original,fresh,m);
   long stamp=m.camera!=null?wall-Math.max(0,mono-m.time):wall;
   if(fresh&&original!=null&&out!=null&&(out.has("road_limit_kph")||out.has("current_kph")))stamp=Math.min(stamp,old);
   preparedTime.set(Long.valueOf(stamp));return out;
  }catch(Exception e){lastQueue="測速合併失敗，撤銷 speed 流";preparedTime.set(Long.valueOf(System.currentTimeMillis()));WideBridgeLog.event("merge_error",e.getClass().getSimpleName());return null;}
 }
 public static long timestamp(String name,long original){Long p=preparedTime.get();return enabled&&"speed".equals(name)&&p!=null?p.longValue():original;}
 public static void queued(String name,String wire,boolean ok,String host,int port){
  try{
   if(!"json:speed".equals(name))return;JSONObject envelope=new JSONObject(wire);JSONObject value=envelope.optJSONObject("value");JSONObject sdi=value==null?null:value.optJSONObject("sdi");
   long now=SystemClock.elapsedRealtime();lastTarget=host+":"+port;queueAt=now;
   if(ok){queuedCount++;lastQueue=sdi!=null?"測速資料已排入傳送":"測速撤銷／原有速度資料已排入";}else{failedCount++;lastQueue="傳送佇列拒收";}
   JSONObject event=new JSONObject();event.put("acceptedBySocketQueue",ok);event.put("target",host);event.put("envelope",envelope);event.put("mode",enabled?"taiwan":"amap");event.put("match",decision());WideBridgeLog.event("speed_wire",event);
   if(enabled&&ok&&sdi!=null){Pending p=new Pending();p.host=host+":"+port;p.limit=sdi.optInt("speed_limit_kph");p.distance=sdi.optInt("distance_m");p.time=now;
    synchronized(pending){pending.put(envelope.optString("session_id")+":"+envelope.optLong("sequence"),p);while(pending.size()>64)pending.remove(pending.keySet().iterator().next());}
    probe(host,port);
   }
  }catch(Exception e){lastQueue="傳送診斷失敗（原有通道繼續）";}
 }
 private static Map map(Object x){return x instanceof Map?(Map)x:Collections.emptyMap();}
 private static long number(Object x){return x instanceof Number?((Number)x).longValue():-1;}
 public static void telemetry(zg data,String url){
  try{
   if(data==null)return;vg sample=data.b("carrotNavi");if(sample==null)return;Map nav=sample.a.c;
   Map speed=map(nav.get("speed")),meta=map(speed.get("meta"));long now=SystemClock.elapsedRealtime();
   if(now-lastTelemetryLog>1000){lastTelemetryLog=now;JSONObject j=new JSONObject();j.put("target",url);j.put("carrotNavi",new JSONObject(nav));vg cm=data.b("carrotMan");if(cm!=null)j.put("carrotMan",new JSONObject(cm.a.c));WideBridgeLog.event("c4_telemetry",j);}
  }catch(Exception ignored){}
 }

 private static void probe(final String host,final int port){
  long now=SystemClock.elapsedRealtime();if(context==null||now-lastProbe<2000||!probing.compareAndSet(false,true))return;lastProbe=now;
  new Thread(new Runnable(){public void run(){java.net.HttpURLConnection connection=null;try{
   if(!enabled)return;
   java.net.URL url=new java.net.URI("http",null,host,port,"/health",null,null).toURL();connection=(java.net.HttpURLConnection)url.openConnection();
   connection.setConnectTimeout(700);connection.setReadTimeout(1000);connection.setUseCaches(false);connection.setInstanceFollowRedirects(false);
   if(connection.getResponseCode()!=200)throw new IOException("HTTP "+connection.getResponseCode());
   InputStream in=connection.getInputStream();ByteArrayOutputStream out=new ByteArrayOutputStream();try{byte[] b=new byte[4096];int n;while((n=in.read(b))!=-1){if(out.size()+n>512*1024)throw new IOException("response too large");out.write(b,0,n);}}finally{in.close();}
   confirm(new JSONObject(new String(out.toByteArray(),"UTF-8")),host+":"+port);
  }catch(Exception e){probeStatus="C4 接收查詢未完成："+e.getClass().getSimpleName();WideBridgeLog.event("receipt_query",probeStatus);}
  finally{if(connection!=null)connection.disconnect();probing.set(false);}}},"TaiwanReceipt").start();
 }
 public static void confirm(JSONObject health,String target){
  try{
   if(!enabled||!health.optBoolean("ok")||!"carrot_navi_receiver".equals(health.optString("service"))||!health.optBoolean("control_connected"))return;
   JSONObject items=health.optJSONObject("items"),record=items==null?null:items.optJSONObject("json:speed");if(record==null||!record.optBoolean("present"))return;
   JSONObject value=record.optJSONObject("value"),sdi=value==null?null:value.optJSONObject("sdi");if(sdi==null)return;
   String key=health.optString("session_id")+":"+record.optLong("sequence",-1);Pending p;synchronized(pending){p=pending.get(key);}
   long now=SystemClock.elapsedRealtime();if(p==null||now-p.time>5000||!p.host.equals(target)||sdi.optInt("type",-1)!=1||sdi.optInt("speed_limit_kph")!=p.limit||sdi.optInt("distance_m")!=p.distance)return;
   synchronized(pending){pending.remove(key);}receiptAt=now;receivedCount++;probeStatus="接收端已回報同一序號";
   lastReceipt="C4 接收端已收到："+p.limit+" km/h · "+p.distance+" m（非執行確認）";
   JSONObject log=new JSONObject();log.put("target",target);log.put("session",health.optString("session_id"));log.put("speed_record",record);log.put("cereal_error",health.optString("cereal_error"));WideBridgeLog.event("c4_receipt",log);
  }catch(Exception ignored){}
 }
 public static JSONObject decision()throws JSONException{WideRoad.Match m=current();JSONObject j=new JSONObject();j.put("enabled",enabled);j.put("reason",m.reason);j.put("roadMatched",m.camera!=null);if(m.camera!=null){j.put("cameraId",m.camera.id);j.put("osmWay",m.camera.osm);j.put("limit_kph",m.camera.limit);j.put("along_road_m",Math.round(m.distance));j.put("direction",m.direction);}return j;}
 public static String badge(){if(!enabled)return "高德來源";long now=SystemClock.elapsedRealtime();if(receiptAt>0&&now-receiptAt<5000)return "C4 已接收";return current().camera!=null?"台灣待回報":"台灣暫無資料";}
 public static String report(){long now=SystemClock.elapsedRealtime();return "Navipilot wide.14-tw-bridge\n測速來源："+(enabled?"台灣同路段配對（測試）":"原有高德")+"\n"+loadStatus+"\n配對："+current().reason+"\n導航通道：原有 Navi v2 / 7714\n目標："+lastTarget+"\n"+lastQueue+(queueAt>0?"（"+((now-queueAt)/1000)+" 秒前）":"")+"\n"+lastReceipt+(receiptAt>0?"（"+((now-receiptAt)/1000)+" 秒前）":"")+"\n佇列接受 "+queuedCount+" / 拒收 "+failedCount+" / 台灣同序號接收確認 "+receivedCount+"\n接收確認不表示 Carrot 已採用或執行減速。\n"+probeStatus+"\n"+WideBridgeLog.status()+"\n\n"+metadata;}
}
