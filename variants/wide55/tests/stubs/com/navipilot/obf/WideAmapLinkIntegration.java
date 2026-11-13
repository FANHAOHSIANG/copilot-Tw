package com.navipilot.obf;
import org.json.JSONObject;import java.util.Map;
public final class WideAmapLinkIntegration {
 public static boolean phone;public static JSONObject cue;public static long stamp;
 public static boolean phoneSelected(){return phone;}
 public static JSONObject filter(MG m,String s,JSONObject v,Map t){if(cue==null)t.remove(s);else t.put(s,Long.valueOf(stamp));return cue;}
}
