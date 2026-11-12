package com.navipilot.obf;
import java.util.List;

/** Display labels do not infer an enforcement type from a speed limit. */
public final class WideEnforcementLabels {
    public static String level(WideEnforcementEngine.Level value) {
        switch (value) {
            case AHEAD: return "前方科技執法";
            case DIRECTION_UNKNOWN: return "同路前方 · 方向待確認";
            case CONDITIONAL: return "前方公告 · 條件待確認";
            case REFERENCE: return "執法公告參考";
            default: return "鄰近科技執法 · 道路待確認";
        }
    }
    public static String category(String c) {
        if ("red_light".equals(c)) return "闖紅燈";
        if ("pedestrian".equals(c)) return "停讓行人";
        if ("lane_signal".equals(c)) return "標誌標線號誌";
        if ("turn".equals(c)) return "轉彎規定";
        if ("speed".equals(c)) return "測速";
        if ("section_speed".equals(c)) return "區間測速";
        if ("parking".equals(c)) return "停車規定";
        if ("seatbelt".equals(c)) return "安全帶";
        if ("phone".equals(c)) return "使用手機";
        if ("restricted_vehicle".equals(c)) return "車種限制";
        if ("following_distance".equals(c)) return "安全距離";
        if ("weighing".equals(c)) return "地磅檢測";
        if ("wrong_way".equals(c)) return "逆向行駛";
        if ("lane_change".equals(c)) return "變換車道";
        return "依公告項目";
    }
    public static String categories(List<String> categories) {
        if (categories == null || categories.isEmpty()) return "取締項目待確認";
        StringBuilder s = new StringBuilder();
        for (String c : categories) {
            String label = category(c);
            if (s.indexOf(label) >= 0) continue;
            if (s.length() > 0) s.append("／");
            s.append(label);
        }
        return s.toString();
    }
    private WideEnforcementLabels() { }
}
