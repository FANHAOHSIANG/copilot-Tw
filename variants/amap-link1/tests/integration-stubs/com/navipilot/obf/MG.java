package com.navipilot.obf;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;

/** Models only the documented MG hook call boundaries, not its Android/WebSocket implementation. */
public final class MG {
    public boolean j = true;
    public boolean accepting = true;
    public final Map<String, Long> timestamps = new LinkedHashMap<String, Long>();
    public final Map<String, JSONObject> latest = new LinkedHashMap<String, JSONObject>();
    public final List<String> sends = new ArrayList<String>();
    public void b(String stream, JSONObject supplied, String reason) {
        JSONObject value = WideAmapLinkIntegration.filter(this, stream, supplied, timestamps);
        if (accepting) {
            latest.put(stream, value);
            sends.add(stream + ":" + (value == null ? "withdrawn" : "present"));
            WideAmapLinkIntegration.published(this, stream, value);
        }
    }
}
