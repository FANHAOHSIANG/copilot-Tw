package com.navipilot.obf;
import java.util.Map;
import org.json.JSONObject;
// Compile-only seam; production delegates to the unmodified merge entry point.
public final class WideBridge {
 public static JSONObject merge(String name, JSONObject value, Map times) {return value;}
}
