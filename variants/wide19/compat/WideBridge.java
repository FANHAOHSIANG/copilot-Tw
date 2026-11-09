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
 private static final class Pending {String host;int road,limit,distance;boolean sdi;long time;}
 public static synchronized void init(Context c){
  if(started)return;started=true;context=c.getApplicationContext();WideBridgeLog.init(context);WideHcop.init(context);enabled=false;
 }
 public static boolean enabled(){return enabled;}
 public static synchronized void setEnabled(boolean value){enabled=value;WideHcop.clear();tracker.reset();matched=new WideRoad.Match(null,0,0,"來源切換，等待新定位",SystemClock.elapsedRealtime());synchronized(pending){pending.clear();}receiptAt=0;queueAt=0;lastQueue="等待原有導航通道更新";lastReceipt="C4 尚未確認";WideBridgeLog.event("source",value?"taiwan":"amap");}
 public static void accept(WideCameraEngine.Fix f){WideHcop.accept(f);}
 public static void clear(){WideHcop.clear();}
 public static WideRoad.Match current(){
  WideHcopRoad.Decision d=WideHcop.current();WideRoad.Corridor c=null;
  if(d.confirmed&&d.camera!=null){c=new WideRoad.Corridor();c.id=d.camera.id;c.road=d.camera.road;c.limit=d.camera.limit;c.lat=d.camera.lat;c.lon=d.camera.lon;}
  return new WideRoad.Match(c,d.distance,d.direction,d.reason,d.time);
 }
 public static JSONObject merge(String name,JSONObject original,Map times){
  if(!"speed".equals(name))return original;
  preparedTime.remove();if(!enabled)return original;
  try{
   long wall=System.currentTimeMillis(),mono=SystemClock.elapsedRealtime();Object source=times.get("speed");long old=source instanceof Number?((Number)source).longValue():0;
   boolean fresh=old>0&&wall>=old&&wall-old<=2000;
   WideHcopRoad.Decision m=WideHcop.current();JSONObject out=WideHcopMerge.merge(original,fresh,m);
   long stamp=m.confirmed?wall-Math.max(0,mono-m.time):wall;
   if(fresh&&original!=null&&out!=null&&out.has("current_kph"))stamp=Math.min(stamp,old);
   preparedTime.set(Long.valueOf(stamp));return out;
  }catch(Exception e){lastQueue="測速合併失敗，撤銷 speed 流";preparedTime.set(Long.valueOf(System.currentTimeMillis()));WideBridgeLog.event("merge_error",e.getClass().getSimpleName());return null;}
 }
 public static long timestamp(String name,long original){Long p=preparedTime.get();return enabled&&"speed".equals(name)&&p!=null?p.longValue():original;}
 public static void queued(String name,String wire,boolean ok,String host,int port){
  try{
   if(!"json:speed".equals(name))return;JSONObject envelope=new JSONObject(wire);JSONObject value=envelope.optJSONObject("value");JSONObject sdi=value==null?null:value.optJSONObject("sdi");
   long now=SystemClock.elapsedRealtime();lastTarget=host+":"+port;queueAt=now;
   if(ok){queuedCount++;lastQueue=value!=null&&(sdi!=null||value.has("road_limit_kph"))?"速限資料已排入傳送":"速限撤銷已排入";}else{failedCount++;lastQueue="傳送佇列拒收";}
   JSONObject event=new JSONObject();event.put("acceptedBySocketQueue",ok);event.put("target",host);event.put("envelope",envelope);event.put("mode",enabled?"taiwan":"amap");event.put("match",decision());WideBridgeLog.event("speed_wire",event);
   if(enabled&&ok&&value!=null&&(sdi!=null||value.has("road_limit_kph"))){Pending p=new Pending();p.host=host+":"+port;p.road=value.optInt("road_limit_kph",-1);p.sdi=sdi!=null;p.limit=sdi==null?0:sdi.optInt("speed_limit_kph");p.distance=sdi==null?0:sdi.optInt("distance_m");p.time=now;
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
   JSONObject value=record.optJSONObject("value"),sdi=value==null?null:value.optJSONObject("sdi");if(value==null)return;
   String key=health.optString("session_id")+":"+record.optLong("sequence",-1);Pending p;synchronized(pending){p=pending.get(key);}
   long now=SystemClock.elapsedRealtime();if(p==null||now-p.time>5000||!p.host.equals(target)||value.optInt("road_limit_kph",-1)!=p.road||(sdi!=null)!=p.sdi||(p.sdi&&(sdi.optInt("type",-1)!=1||sdi.optInt("speed_limit_kph")!=p.limit||sdi.optInt("distance_m")!=p.distance)))return;
   synchronized(pending){pending.remove(key);}receiptAt=now;receivedCount++;probeStatus="接收端已回報同一序號";
   lastReceipt="C4 接收端已收到：道路 "+(p.road>0?p.road:"—")+" km/h"+(p.sdi?"；測速 "+p.limit+" km/h · "+p.distance+" m":"")+"（非執行確認）";
   JSONObject log=new JSONObject();log.put("target",target);log.put("session",health.optString("session_id"));log.put("speed_record",record);log.put("cereal_error",health.optString("cereal_error"));WideBridgeLog.event("c4_receipt",log);
  }catch(Exception ignored){}
 }
 public static JSONObject decision()throws JSONException{JSONObject j=WideHcop.json();j.put("enabled",enabled);return j;}
 public static String badge(){if(!enabled)return "預覽 · 高德來源";WideHcopRoad.Decision d=WideHcop.current();if(!d.confirmed)return "台灣暫無資料";long now=SystemClock.elapsedRealtime();return receiptAt>0&&now-receiptAt<5000?"最近已接收":"台灣待回報";}
 public static String report(){long now=SystemClock.elapsedRealtime();return "Navipilot wide.16-hcop-tw-test\n來源："+(enabled?"HCOP 台灣道路／測速（測試）":"高德；台灣只預覽")+"\n"+WideHcop.report()+"\n導航通道：原有 Navi v2 / 7714\n目標："+lastTarget+"\n"+lastQueue+(queueAt>0?"（"+((now-queueAt)/1000)+" 秒前）":"")+"\n"+lastReceipt+(receiptAt>0?"（"+((now-receiptAt)/1000)+" 秒前）":"")+"\n佇列接受 "+queuedCount+" / 拒收 "+failedCount+" / 同序號接收確認 "+receivedCount+"\n接收確認不代表已執行減速。\n"+probeStatus+"\n"+WideBridgeLog.status();}
}
