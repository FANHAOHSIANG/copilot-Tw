package android.content;

import java.util.HashMap;
import java.util.Map;

public class Intent {
    private String action;
    private final Map<String, Object> extras = new HashMap<String, Object>();
    public Intent() { }
    public Intent(String action) { this.action = action; }
    public String getAction() { return action; }
    public Intent setAction(String value) { action = value; return this; }
    public Intent putExtra(String name, String value) { extras.put(name, value); return this; }
    public Intent putExtra(String name, boolean value) { extras.put(name, Boolean.valueOf(value)); return this; }
    public String getStringExtra(String name) {
        Object value = extras.get(name);
        return value instanceof String ? (String) value : null;
    }
    public boolean getBooleanExtra(String name, boolean fallback) {
        Object value = extras.get(name);
        return value instanceof Boolean ? ((Boolean) value).booleanValue() : fallback;
    }
}
