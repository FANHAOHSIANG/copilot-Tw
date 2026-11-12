package com.navipilot.obf;
import android.app.*;import android.content.*;import android.os.*;import java.net.*;import java.io.*;import java.util.*;import java.util.concurrent.*;import org.json.*;
/** Local SDK companion bridge, sharing the existing negotiated Navi v2 sender. */
public final class WideGoogleNav {
 public static final String PACKAGE="com.copilottw.googlenav";
 private static volatile boolean selected;private static volatile long generation;private static volatile WideGoogleAdapter.Snapshot snapshot;
 private static volatile String state="尚未選擇 CP Google 導航";private static boolean initialized;
 private static String geometrySession="";private static long geometryVersion=-1;private static JSONObject geometry;private static volatile long suppliedAt;
 public static synchronized void init(Context c){if(initialized)return;initialized=true;ScheduledExecutorService executor=Executors.newSingleThreadScheduledExecutor(r->{Thread t=new Thread(r,"GoogleNavInput");t.setDaemon(true);return t;});executor.scheduleWithFixedDelay(WideGoogleNav::poll,0,700,TimeUnit.MILLISECONDS);}
 public static synchronized void select(String source){boolean next=PACKAGE.equals(source);if(selected==next)return;selected=next;generation++;snapshot=null;geometry=null;geometryVersion=-1;suppliedAt=0;state=next?"等待 CP Google 導航資料":"未選擇 CP Google 導航";}
 public static boolean selected(){return selected;}
 private static JSONObject get(String path)throws Exception {
  HttpURLConnection c=(HttpURLConnection)new URL("http://127.0.0.1:5002"+path).openConnection();c.setConnectTimeout(700);c.setReadTimeout(900);c.setUseCaches(false);c.setInstanceFollowRedirects(false);
  try{if(c.getResponseCode()!=200)throw new IOException("source unavailable");try(InputStream in=c.getInputStream();ByteArrayOutputStream out=new ByteArrayOutputStream()){byte[] b=new byte[8192];int n;while((n=in.read(b))!=-1){if(out.size()+n>4*1024*1024)throw new IOException("response too large");out.write(b,0,n);}return new JSONObject(out.toString("UTF-8"));}}finally{c.disconnect();}
 }
 private static void poll(){if(!selected)return;long token=generation;long began=SystemClock.elapsedRealtime();try{
  JSONObject nav=get("/nav");long version=nav.optLong("routeVer",-1);JSONObject route;
  synchronized(WideGoogleNav.class){route=geometryVersion==version&&geometrySession.equals(nav.optString("sessionId"))?geometry:null;}
  if("navigating".equals(nav.optString("state"))&&route==null){JSONObject candidate=get("/route");if(candidate.optLong("ver",-2)==version)route=candidate;}
  // The local request duration consumes freshness too, instead of refreshing old data.
  WideGoogleAdapter.Snapshot result=WideGoogleAdapter.parse(nav,route,began);
  synchronized(WideGoogleNav.class){if(!selected||generation!=token)return;snapshot=result;geometry=route;geometryVersion=version;geometrySession=nav.optString("sessionId");state=result.reason;}
 }catch(Exception e){synchronized(WideGoogleNav.class){if(generation!=token)return;snapshot=null;geometry=null;geometryVersion=-1;state="Google 導航資料未就緒／過期，已撤銷";}}}
 public static JSONObject filter(String name,JSONObject original,Map timestamps){
  if(!selected)return null;
  if("app_status".equals(name))return original;
  WideGoogleAdapter.Snapshot s=snapshot;long now=SystemClock.elapsedRealtime();JSONObject out=s==null?null:s.value(name,now);
  if(out!=null){timestamps.put(name,Long.valueOf(System.currentTimeMillis()-Math.max(0,now-s.received+s.age)));suppliedAt=now;}else timestamps.remove(name);
  return out;
 }
 public static JSONObject guidance(){WideGoogleAdapter.Snapshot s=snapshot;return selected&&s!=null?s.value("guidance_current",SystemClock.elapsedRealtime()):null;}
 public static String status(){WideGoogleAdapter.Snapshot s=snapshot;long now=SystemClock.elapsedRealtime();String detail=s==null||s.value("navigation_status",now)==null?"目前無有效導航資料":state;
  return detail+"\n來源：CP Google 導航 SDK（本機）\n"+(suppliedAt>0&&now-suppliedAt<3000?"已交給原有 Navi v2 傳送流程":"等待原有 Navi v2 通道")+"\n尚不代表 C4 已接收；官方 Google Maps 投屏不提供此資料。";
 }
 public static void show(Activity a){new AlertDialog.Builder(a).setTitle("Google 導航串接").setMessage(status()+"\n\n在導航來源選『CP Google 導航』，於該畫面設定自己的金鑰並開始導航。原有 Google Maps 投屏仍獨立保留。").setPositiveButton("開啟 Google 金鑰／導航",(d,w)->{try{Intent i=a.getPackageManager().getLaunchIntentForPackage(PACKAGE);if(i==null)throw new IllegalStateException();a.startActivity(i);}catch(Exception e){new AlertDialog.Builder(a).setMessage("請先安裝配套的 CP Google 導航 APK。").setPositiveButton("關閉",null).show();}}).setNegativeButton("關閉",null).show();}
 private WideGoogleNav(){}
}
