package android.content;
import java.util.HashMap;
import java.util.Map;
public final class SharedPreferences {
    private final Map<String, Boolean> booleans = new HashMap<String, Boolean>();
    public boolean getBoolean(String key, boolean fallback) { return booleans.containsKey(key) ? booleans.get(key) : fallback; }
    public Editor edit() { return new Editor(); }
    public final class Editor {
        public Editor putBoolean(String key, boolean value) { booleans.put(key, value); return this; }
        public void apply() { }
    }
}
