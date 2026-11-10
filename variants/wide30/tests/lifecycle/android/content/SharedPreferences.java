package android.content;
import java.util.HashMap; import java.util.Map;
public class SharedPreferences {
 private final Map<String,Boolean> values = new HashMap<>();
 public boolean getBoolean(String key, boolean value) { return values.getOrDefault(key, value); }
 public Editor edit() { return new Editor(); }
 public class Editor { public Editor putBoolean(String key, boolean value) { values.put(key,value); return this; } public void apply() {} }
}
