package com.navipilot.obf;
import org.json.JSONObject;import java.util.Map;
public final class WideAmapSource {
 public static int calls;
 public static JSONObject filter(MG m,String s,JSONObject v,Map t){calls++;return v;}
}
