package com.navipilot.obf;
import java.util.ArrayList;
import org.json.JSONObject;
/** Only the local logger is replaced; tests execute production integration. */
public final class WideBridgeLog {
    public static boolean enabled;
    public static final ArrayList<String> names = new ArrayList<String>();
    public static final ArrayList<JSONObject> values = new ArrayList<JSONObject>();
    public static boolean recording() { return enabled; }
    public static void event(String name, Object value) {
        names.add(name); values.add((JSONObject) value);
    }
    public static JSONObject latest(String name) {
        for (int i = names.size() - 1; i >= 0; i--) if (name.equals(names.get(i))) return values.get(i);
        throw new AssertionError("Missing event: " + name);
    }
}
