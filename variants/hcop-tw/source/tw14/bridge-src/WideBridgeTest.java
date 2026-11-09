package com.navipilot.obf;
import java.util.*;import org.json.*;import android.os.SystemClock;
public class WideBridgeTest{
 static int count;static void ok(boolean v,String s){if(!v)throw new AssertionError(s);count++;}
 static long number(String f)throws Exception{java.lang.reflect.Field field=WideBridge.class.getDeclaredField(f);field.setAccessible(true);return field.getLong(null);}
 static void field(String f,Object v)throws Exception{java.lang.reflect.Field x=WideBridge.class.getDeclaredField(f);x.setAccessible(true);x.set(null,v);}
 public static void main(String[]args)throws Exception{
  JSONObject original=new JSONObject("{\"road_limit_kph\":60,\"sdi\":{\"type\":7}}");Map times=new HashMap();times.put("speed",System.currentTimeMillis());
  ok(WideBridge.merge("speed",original,times)==original,"default pass through");WideBridge.setEnabled(true);
  ok(WideBridge.merge("guidance_current",original,times)==original,"turn stream unchanged");
  ok(!WideBridge.merge("speed",original,times).has("sdi"),"no GPS clears old source");
  WideRoad.Corridor c=WideRoadTest.corridor();field("roads",Arrays.asList(c));field("ready",true);
  for(int i=0;i<3;i++){SystemClock.now=10000+i*1000;WideCamera.f=WideRoadTest.fix(24.004+i*.00009,SystemClock.now,0,5);WideBridge.accept(WideCamera.f);}
  JSONObject merged=WideBridge.merge("speed",original,times);ok(merged.has("sdi"),"GPS feeds existing stream");ok(merged.getInt("road_limit_kph")==60,"fresh road preserved");
  ok(WideBridge.timestamp("guidance_current",123)==123,"other timestamps unchanged");
  times.put("speed",System.currentTimeMillis()-10000);JSONObject withoutOld=WideBridge.merge("speed",original,times);ok(!withoutOld.has("road_limit_kph")&&withoutOld.has("sdi"),"stale speed not refreshed by GPS");
  String host="172.20.10.4";JSONObject e=new JSONObject().put("session_id","testsession").put("sequence",42).put("present",true).put("value",merged);
  WideBridge.queued("json:speed",e.toString(),true,host,7714);ok(number("receivedCount")==0,"enqueue is not receipt");
  JSONObject sdi=new JSONObject(merged.getJSONObject("sdi").toString());JSONObject record=new JSONObject().put("present",true).put("sequence",42).put("value",new JSONObject().put("sdi",sdi));
  JSONObject health=new JSONObject().put("ok",true).put("service","carrot_navi_receiver").put("control_connected",true).put("session_id","testsession").put("items",new JSONObject().put("json:speed",record));
  WideBridge.confirm(health,"172.20.10.5:7714");ok(number("receivedCount")==0,"wrong host rejected");
  record.put("sequence",43);WideBridge.confirm(health,"172.20.10.4:7714");ok(number("receivedCount")==0,"wrong sequence rejected");
  record.put("sequence",42);sdi.put("speed_limit_kph",60);WideBridge.confirm(health,"172.20.10.4:7714");ok(number("receivedCount")==0,"wrong value rejected");
  sdi.put("speed_limit_kph",50);WideBridge.confirm(health,"172.20.10.4:7714");ok(number("receivedCount")==1,"exact receipt accepted");
  WideBridge.confirm(health,"172.20.10.4:7714");ok(number("receivedCount")==1,"receipt dedup");
  JSONObject actual=new JSONObject(new String(java.nio.file.Files.readAllBytes(java.nio.file.Paths.get("bridge-build/health-fixture.json")),"UTF-8"));
  JSONObject actualRecord=actual.getJSONObject("items").getJSONObject("json:speed");
  JSONObject actualEnvelope=new JSONObject().put("session_id",actual.getString("session_id")).put("sequence",actualRecord.getLong("sequence")).put("value",actualRecord.getJSONObject("value"));
  WideBridge.queued("json:speed",actualEnvelope.toString(),true,host,7714);WideBridge.confirm(actual,host+":7714");ok(number("receivedCount")==2,"real C4 health fixture accepted");
  SystemClock.now+=5001;ok(WideBridge.current().camera==null,"current match expires");ok(WideBridge.merge("speed",original,times)==null,"expired GPS and old Amap withdrawn");
  WideBridge.setEnabled(false);ok(WideBridge.merge("speed",original,times)==original,"source rollback original");
  System.out.println("PASS "+count+" bridge state/receipt tests (JVM Android doubles, not device runtime)");
 }
}
