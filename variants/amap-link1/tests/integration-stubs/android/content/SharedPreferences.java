package android.content;

import java.util.HashMap;
import java.util.Map;

public final class SharedPreferences {
    private final Map<String, Object> values = new HashMap<String, Object>();
    public void put(String name, Object value) { values.put(name, value); }
    public boolean getBoolean(String name, boolean fallback) {
        Object value = values.get(name);
        return value instanceof Boolean ? ((Boolean) value).booleanValue() : fallback;
    }
    public String getString(String name, String fallback) {
        Object value = values.get(name);
        return value instanceof String ? (String) value : fallback;
    }
}
