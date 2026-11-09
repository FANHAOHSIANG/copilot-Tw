package com.navipilot.obf;
import java.util.*;import org.json.*;import android.os.SystemClock;
public class BridgeReceiptTest {
 static int n;static void ok(boolean b,String s){if(!b)throw new AssertionError(s);n++;}
 static long received()throws Exception{java.lang.reflect.Field f=WideBridge.class.getDeclaredField("receivedCount");f.setAccessible(true);return f.getLong(null);}
 public static void main(String[] args)throws Exception{
  Map times=new HashMap();JSONObject original=new JSONObject("{\"road_limit_kph\":90}");
  ok(WideBridge.merge("speed",original,times)==original,"default Amap passthrough");
  WideBridge.setEnabled(true);ok(WideBridge.merge("guidance_current",original,times)==original,"turns preserved");
  ok(WideBridge.merge("speed",original,times)==null,"missing GPS withdraw");
  JSONObject value=new JSONObject("{\"road_limit_kph\":50}");JSONObject envelope=new JSONObject().put("session_id","session").put("sequence",1).put("value",value);
  WideBridge.queued("json:speed",envelope.toString(),true,"192.0.2.1",7714);
  JSONObject record=new JSONObject().put("present",true).put("sequence",1).put("value",new JSONObject("{\"road_limit_kph\":60}"));
  JSONObject health=new JSONObject().put("ok",true).put("service","carrot_navi_receiver").put("control_connected",true).put("session_id","session").put("items",new JSONObject().put("json:speed",record));
  WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==0,"wrong road limit rejected");
  record.put("value",value);WideBridge.confirm(health,"192.0.2.2:7714");ok(received()==0,"wrong target rejected");
  record.put("sequence",2);WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==0,"wrong sequence rejected");
  record.put("sequence",1);health.put("session_id","other");WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==0,"wrong session rejected");
  health.put("session_id","session");WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==1,"road-only acknowledgement accepted");
  WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==1,"ack deduplicated");
  envelope.put("sequence",2);WideBridge.queued("json:speed",envelope.toString(),true,"192.0.2.1",7714);record.put("sequence",2);value.put("sdi",new JSONObject().put("type",1));WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==1,"unexpected camera rejected");
  value.remove("sdi");SystemClock.now+=5001;WideBridge.confirm(health,"192.0.2.1:7714");ok(received()==1,"stale ack rejected");
  WideBridge.setEnabled(false);ok(WideBridge.merge("speed",original,times)==original,"return to Amap");
  System.out.println("PASS "+n+" bridge / road-only receipt assertions (Android doubles)");
 }
}
