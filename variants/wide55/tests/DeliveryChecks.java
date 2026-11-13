package com.navipilot.obf;
import org.json.JSONObject;import java.util.HashMap;import android.os.SystemClock;
public final class DeliveryChecks {
 static int n;static void check(boolean b,String m){n++;if(!b)throw new AssertionError(m);}
 public static void main(String[] args)throws Exception{
  MG m=new MG();HashMap t=new HashMap();JSONObject idle=new JSONObject().put("mode","idle");
  check(WideLinkDelivery.route(m,"navigation_status",idle,t)==idle,"Auto/Google preserved");
  WideAmapLinkIntegration.phone=true;WideAmapLinkIntegration.cue=new JSONObject().put("mode","guiding").put("guidance_active",true);WideAmapLinkIntegration.stamp=100;
  check(WideLinkDelivery.route(m,"navigation_status",idle,t).getBoolean("guidance_active"),"Link wins over stale legacy idle");
  check(t.get("navigation_status").equals(100L),"source timestamp preserved");
  check(WideAmapSource.calls==2,"original lifecycle registration preserved");
  WideAmapLinkIntegration.cue=null;
  check(WideLinkDelivery.route(m,"navigation_status",idle,t)==null,"expired/stopped Link cannot revive idle source");
  check(!t.containsKey("navigation_status"),"withdrawal removes timestamp");
  JSONObject cue=new JSONObject().put("turn_type",13).put("distance_m",1544);
  WideLinkDelivery.reset();SystemClock.now=1000;
  WideLinkDelivery.result("guidance_current",cue,"開始交付");
  WideLinkDelivery.result("guidance_current",cue,"傳送佇列未接受：檢查連線及資料流通道");
  check(WideLinkDelivery.status().contains("有效引導排入佇列：0"),"rejection is not acceptance");
  WideLinkDelivery.result("guidance_current",cue,"已交給傳送佇列");SystemClock.now=3500;
  check(WideLinkDelivery.status().contains("有效引導排入佇列：1"),"accepted counted");
  check(WideLinkDelivery.status().contains("2 秒前"),"elapsed time measured");
  WideLinkDelivery.result("guidance_current",null,"已交給傳送佇列");
  check(WideLinkDelivery.status().contains("撤銷排入佇列：1"),"withdrawal separate");
  check(WideLinkDelivery.status().contains("有效引導排入佇列：1"),"withdrawal not counted as valid cue");
  WideLinkDelivery.result("navigation_status",cue,"已交給傳送佇列");
  check(WideLinkDelivery.status().contains("有效引導排入佇列：1"),"status not counted as guidance");
  WideAmapLinkIntegration.phone=false;
  check(WideLinkDelivery.route(m,"navigation_status",idle,t)==idle,"switch back restores native routing");
  WideLinkDelivery.reset();check(WideLinkDelivery.status().contains("尚無"),"new source clears old acceptance");
  System.out.println("DeliveryChecks: "+n+" assertions passed; host doubles, not device receipt");
 }
}
