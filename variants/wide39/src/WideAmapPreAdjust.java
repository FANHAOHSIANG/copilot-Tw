package com.navipilot.obf;

import java.util.Map;
import org.json.JSONObject;

/** Preserve only the selected Amap's already validated smart-speed override. */
public final class WideAmapPreAdjust {
    static final String KEY = "_copilot_amap_pre_adjust";
    static boolean valid(int value) { return value >= 10 && value <= 200 && value % 10 == 0; }

    public static JSONObject mark(JSONObject value, Integer target) {
        if (value == null) return null;
        try {
            JSONObject copy = new JSONObject(value.toString());
            copy.remove(KEY);
            if (target != null && valid(target) && copy.optInt("road_limit_kph", -1) == target)
                copy.put(KEY, target.intValue());
            return copy;
        } catch (Exception error) { return null; }
    }

    public static JSONObject merge(String stream, JSONObject original, Map times) {
        JSONObject merged = WideBridge.merge(stream, original, times);
        if (!"speed".equals(stream)) return merged;
        Object stamp = times.get("speed");
        long timestamp = stamp instanceof Number ? ((Number) stamp).longValue() : 0;
        return finish(original, merged, timestamp, System.currentTimeMillis());
    }

    static JSONObject finish(JSONObject original, JSONObject merged, long stamp, long now) {
        if (merged == null) return null; // Never revive a rejected stream.
        try {
            JSONObject result = new JSONObject(merged.toString());
            result.remove(KEY); // Internal provenance must not escape onto the wire.
            int target = original == null ? -1 : original.optInt(KEY, -1);
            if (stamp > 0 && now >= stamp && now - stamp <= 2000 && valid(target)
                    && original.optInt("road_limit_kph", -1) == target) {
                int road = result.optInt("road_limit_kph", -1);
                result.put("road_limit_kph", road > 0 ? Math.min(road, target) : target);
            }
            return result.length() == 0 ? null : result;
        } catch (Exception error) { return null; }
    }
}
