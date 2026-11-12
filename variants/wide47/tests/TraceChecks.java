package com.navipilot.obf;
import java.net.URLEncoder;
import org.json.JSONArray;
import org.json.JSONObject;
public final class TraceChecks {
    private static int count;
    private static void check(boolean ok, String why) { count++; if (!ok) throw new AssertionError(why); }
    private static JSONObject capture(JSONObject o) { return WideAmapLinkTrace.capture(o.toString()); }
    public static void main(String[] args) throws Exception {
        JSONObject source = new JSONObject().put("curManeuverID", 999).put("segmentRemainDist", 123)
                .put("nextRouteName", "測試道路").put("token", "private-token")
                .put("unknownSecretContainer", "other-private-value");
        JSONObject frame = new JSONObject().put("biz", 113).put("datas", new JSONArray()
                .put(new JSONObject().put("type", 4).put("data", source.toString())).toString());
        String original = frame.toString(); JSONObject c = capture(frame);
        check(c.getString("parse_status").equals("decoded"), "decoded envelope");
        check(!c.getBoolean("control_input"), "capture is not control");
        check(!c.getBoolean("raw_bytes_preserved"), "sanitized copy is labeled");
        JSONObject payload = c.getJSONObject("payload");
        check(payload.getInt("biz") == 113, "business code retained");
        JSONObject data = payload.getJSONArray("datas").getJSONObject(0).getJSONObject("data");
        check(data.getInt("curManeuverID") == 999, "unknown icon retained for diagnosis");
        check(data.getInt("segmentRemainDist") == 123, "distance retained");
        check(data.getString("nextRouteName").equals("測試道路"), "known road text retained");
        check(!c.toString().contains("private-token"), "nested token removed");
        check(!c.toString().contains("other-private-value"), "unknown secret text removed");
        check(frame.toString().equals(original), "input never mutated");
        JSONObject structure = new JSONObject().put("route", new JSONArray().put(new JSONArray().put(121.01).put(24.8)))
                .put("next", new JSONObject().put("icon", 3).put("distance", 90));
        JSONObject query = new JSONObject().put("status", "success")
                .put("navi_structured_info", URLEncoder.encode(new JSONArray().put(structure).toString(), "UTF-8"));
        JSONObject q = capture(query).getJSONObject("payload");
        check(q.getString("status").equals("success"), "query status retained");
        JSONObject nested = q.getJSONArray("navi_structured_info").getJSONObject(0);
        check(nested.getJSONArray("route").getJSONArray(0).getDouble(0) == 121.01, "coordinate precision retained");
        check(nested.getJSONObject("next").getInt("icon") == 3, "unknown next structure retained");
        for (String k : new String[]{"access_token", "API-Key", "sessionId", "uid", "phone", "email", "cookie", "authorization"}) {
            check(!capture(new JSONObject().put(k, "SENSITIVE_VALUE")).toString().contains("SENSITIVE_VALUE"), "redact " + k);
        }
        check(capture(new JSONObject().put("unexpected", "SENSITIVE_VALUE")).getJSONObject("payload")
                .getJSONObject("unexpected").getInt("_string_chars") == 15, "unknown string retains shape only");
        check(WideAmapLinkTrace.capture("broken SENSITIVE_VALUE").getString("parse_status").equals("unparsed"), "bad JSON labeled");
        check(!WideAmapLinkTrace.capture("broken SENSITIVE_VALUE").toString().contains("SENSITIVE_VALUE"), "bad JSON never copied");
        check(WideAmapLinkTrace.capture(null).getBoolean("truncated"), "missing input bounded");
        check(WideAmapLinkTrace.capture("{} trailing").getString("parse_status").equals("unparsed"), "trailing input rejected");
        String deep = "0"; for (int i=0;i<100;i++) deep="["+deep+"]";
        check(WideAmapLinkTrace.capture(deep).getString("parse_status").equals("unparsed"), "parser depth bounded before recursion");
        JSONArray huge = new JSONArray(); for (int i=0;i<8000;i++) huge.put(i);
        JSONObject bounded = WideAmapLinkTrace.capture(huge.toString());
        check(bounded.getBoolean("truncated"), "large arrays flagged");
        check(bounded.getJSONArray("payload").length()==4096, "array cap");
        check(bounded.toString().length()<262144, "capture stays below practical record budget");
        String nestedJson = "{}"; for(int i=0;i<25;i++) nestedJson="{\"data\":"+nestedJson+"}";
        check(WideAmapLinkTrace.capture(nestedJson).getBoolean("truncated"), "copy depth cap");
        char[] oversized = new char[4*1024*1024+1];
        check(WideAmapLinkTrace.capture(new String(oversized)).getString("parse_status").equals("missing_or_oversize"), "input cap");
        check(capture(new JSONObject().put("empty", JSONObject.NULL)).getJSONObject("payload").isNull("empty"), "null preserved");
        check(!capture(new JSONObject().put("enabled", false)).getJSONObject("payload").getBoolean("enabled"), "boolean preserved");
        System.out.println("TraceChecks: " + count + " assertions passed");
    }
}
