package com.navipilot.obf;

import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

/** Runs the real business decoder into the real state model, including malformed updates. */
public final class PipelineChecks {
    private static int checks;
    private static final long WALL = 1_800_000_000_000L;

    private static void check(boolean condition, String message) {
        checks++;
        if (!condition) throw new AssertionError(message);
    }

    private static JSONObject item(int type, Object value) throws Exception {
        return new JSONObject().put("type", type).put("data", value);
    }

    private static JSONObject cue(int icon, int distance) throws Exception {
        return new JSONObject().put("curManeuverID", icon).put("segmentRemainDist", distance)
                .put("nextRouteName", "合成測試道路");
    }

    private static String frame(JSONObject... values) throws Exception {
        JSONArray items = new JSONArray();
        for (JSONObject value : values) items.put(value);
        return new JSONObject().put("bizType", 113).put("datas", items.toString()).toString();
    }

    private static void deliver(WideAmapLinkNavigation model, long epoch, long now, String raw)
            throws Exception {
        List<WideAmapLinkCodec.Item> items = WideAmapLinkCodec.items(WideAmapLinkCodec.decodeEnvelope(raw));
        for (WideAmapLinkCodec.Item item : items) model.accept(epoch, item.type, item.data, now, WALL + now);
    }

    private static WideAmapLinkNavigation seeded() throws Exception {
        WideAmapLinkNavigation model = new WideAmapLinkNavigation();
        model.reset(10);
        deliver(model, 10, 1_000, frame(item(4, cue(2, 38).toString())));
        check(model.snapshot(1_001).guidance != null, "baseline cue present");
        return model;
    }

    public static void main(String[] args) throws Exception {
        WideAmapLinkNavigation model = seeded();
        deliver(model, 10, 2_000, frame(item(4, "malformed JSON")));
        check(model.snapshot(2_001).guidance == null,
                "malformed type 4 must reach invalidation, not disappear before mapper");

        model = seeded();
        deliver(model, 10, 2_000, frame(item(5, "malformed JSON")));
        check(model.snapshot(2_001).guidance == null,
                "malformed type 5 must withdraw previous direction/distance");

        model = seeded();
        deliver(model, 10, 2_000, frame(item(4, cue(3, 22)), item(7, new JSONObject())));
        check(model.snapshot(2_001).guidance.getInt("turn_type") == 13,
                "valid structured type 4 survives mode snapshot in same callback batch");
        check(model.snapshot(2_001).guidance.getInt("distance_m") == 22,
                "same callback batch preserves real next-turn distance");

        deliver(model, 10, 2_500, frame(item(100, JSONObject.NULL)));
        check(model.snapshot(2_501).guidance == null, "null-data stop is delivered and clears guidance");
        check(!model.snapshot(2_501).status.getBoolean("guidance_active"), "stop publishes inactive status");

        model = seeded();
        String wrongChannel = new JSONObject().put("bizType", 112)
                .put("datas", new JSONArray().put(item(100, JSONObject.NULL))).toString();
        deliver(model, 10, 2_000, wrongChannel);
        check(model.snapshot(2_001).guidance != null, "unrelated business channel cannot stop guidance");
        deliver(model, 10, 2_500, frame(item(16, new JSONObject().put("synthetic", true))));
        check(model.snapshot(4_001).guidance == null, "unrelated location callback cannot refresh navigation");

        model = seeded();
        model.reset(11);
        deliver(model, 11, 2_000, frame(item(4, cue(3, 22))));
        deliver(model, 10, 2_500, frame(item(4, cue(2, 99)), item(200, JSONObject.NULL)));
        check(model.snapshot(2_501).guidance.getInt("distance_m") == 22,
                "old decoded batch cannot overwrite or clear replacement session");
        System.out.println("PipelineChecks: " + checks + " assertions passed");
    }
}
