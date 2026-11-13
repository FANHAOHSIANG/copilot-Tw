package com.navipilot.obf;

import java.util.ArrayList;
import java.util.ArrayDeque;
import org.json.JSONArray;
import org.json.JSONObject;

/** Link type 2 schema recovered from the official 17.03 APK; no route service. */
public final class WideAmapLinkRoute {
    public static final int MAX_POINTS = 4096;
    private JSONObject group;
    private String selected = "";
    private JSONArray geometry;
    private JSONArray segments;
    private int total;
    private String reason = "尚無高德完整路線";

    public void clear() { group = null; selected = ""; geometry = null; segments = null; total = 0; reason = "尚無高德完整路線"; }
    public String reason() { return reason; }
    public String selected() { return selected; }
    public boolean ready() { return geometry != null; }

    public void acceptGroup(JSONObject data) {
        clear();
        try {
            if (data == null || !(data.opt("info") instanceof JSONObject)) throw new Exception();
            group = new JSONObject(data.toString());
            choose(id(data.opt("highlightRoute")));
        } catch (Exception e) { clear(); reason = "高德路線格式不完整，已撤銷舊路線"; }
    }
    public void choose(String routeId) {
        geometry = null; segments = null; total = 0; selected = routeId;
        reason = "等待所選高德路線的完整資料";
        try {
            if (group == null || routeId.isEmpty()) return;
            JSONObject route = group.getJSONObject("info").getJSONObject(routeId);
            JSONArray segs = route.getJSONArray("segmentInfo");
            if (segs.length() == 0 || segs.length() > 8192) return;
            int length = integer(route.opt("routeLength"), 2000000);
            if (length <= 0) return;
            ArrayList<double[]> points = new ArrayList<double[]>();
            ArrayList<Integer> anchors = new ArrayList<Integer>();
            long sum = 0;
            for (int s = 0; s < segs.length(); s++) {
                JSONObject seg = segs.getJSONObject(s);
                int segmentLength = integer(seg.opt("length"), 2000000);
                if (segmentLength < 0) throw new Exception();
                sum += segmentLength;
                JSONArray links = seg.getJSONArray("linkInfo");
                if (links.length() == 0 || links.length() > 50000) throw new Exception();
                int before = points.size();
                for (int l = 0; l < links.length(); l++) {
                    JSONObject link = links.getJSONObject(l);
                    JSONArray lat = link.getJSONArray("lat"), lon = link.getJSONArray("lon");
                    if (lat.length() != lon.length() || lat.length() < 2) throw new Exception();
                    for (int p = 0; p < lat.length(); p++) {
                        double y = coordinate(lat.opt(p), 90), x = coordinate(lon.opt(p), 180);
                        if (x == 0 && y == 0) throw new Exception();
                        if (!points.isEmpty()) {
                            double[] prev = points.get(points.size()-1);
                            if (prev[0] == y && prev[1] == x) continue;
                        }
                        points.add(new double[]{y,x});
                        if (points.size() > 50000) throw new Exception();
                    }
                }
                if (points.size() == before) throw new Exception();
                anchors.add(points.size()-1); // Never discard a maneuver endpoint.
            }
            if (Math.abs(sum-length) > Math.max(50, length*0.02) || points.size()<2) throw new Exception();
            JSONArray reduced = simplify(points, anchors);
            if (reduced == null) { reason = "高德路線超出點數上限；未截斷送出"; return; }
            geometry = reduced; segments = segs; total = length;
            reason = "高德所選路線可用：" + geometry.length() + " 點";
        } catch (Exception e) { geometry = null; segments = null; reason = "高德路線欄位或座標無效，已撤銷"; }
    }
    public JSONObject route(JSONObject nav) throws Exception {
        if (geometry == null || !selected.equals(id(nav.opt("pathID")))) return null;
        JSONObject out = new JSONObject().put("polyline", new JSONArray(geometry.toString()))
            .put("total_distance_m",total);
        copyInteger(nav,out,"routeRemainDist","remain_distance_m",2000000);
        copyInteger(nav,out,"routeRemainTime","remain_time_sec",604800);
        copyInteger(nav,out,"drivenDist","moved_distance_m",2000000);
        copyInteger(nav,out,"driveTime","moved_time_sec",604800);
        return out;
    }
    public JSONObject next(JSONObject nav) throws Exception {
        if (segments == null || !selected.equals(id(nav.opt("pathID")))) return null;
        int index = integer(nav.opt("curSegIdx"),8191);
        if (index<0 || index+1>=segments.length()) return null;
        JSONObject current = segments.getJSONObject(index), next = segments.getJSONObject(index+1);
        // Index and maneuver must agree; never guess when a schema changes.
        if (integer(current.opt("iconType"),65535) != integer(nav.opt("curManeuverID"),65535)) return null;
        int icon=integer(next.opt("iconType"),65535), turn=WideAmapLinkNavigation.turnType(icon);
        int distance=integer(next.opt("length"),2000000);
        if (turn<0 || distance<0) return null;
        // C4 adds the current distance itself. This is the distance BETWEEN turns.
        return new JSONObject().put("distance_m",distance).put("turn_type",turn)
            .put("main_text",WideAmapLinkNavigation.action(icon)).put("road_name","")
            .put("near_direction","").put("far_direction","");
    }
    private static void copyInteger(JSONObject a,JSONObject b,String from,String to,int max) throws Exception {
        int v=integer(a.opt(from),max); if(v>=0)b.put(to,v);
    }
    static String id(Object v) {
        if (!(v instanceof Number)) return "";
        double n=((Number)v).doubleValue();
        return Double.isNaN(n)||Double.isInfinite(n)||n<0||n>4294967295L||n!=Math.floor(n)?"":Long.toString((long)n);
    }
    static int integer(Object v,int max) {
        if (!(v instanceof Number)) return -1;
        double n=((Number)v).doubleValue();
        return Double.isNaN(n)||Double.isInfinite(n)||n<0||n>max||n!=Math.floor(n)?-1:(int)n;
    }
    private static double coordinate(Object v,int bound) throws Exception {
        if (!(v instanceof Number)) throw new Exception();
        double n=((Number)v).doubleValue();
        if(Double.isNaN(n)||Double.isInfinite(n)||Math.abs(n)>bound || (bound==90 && Math.abs(n)>85.05112878))throw new Exception();
        return n; // Wire serializer already converts angular units to degrees.
    }
    private static JSONArray simplify(ArrayList<double[]> p,ArrayList<Integer> anchors) throws Exception {
        boolean[] keep=new boolean[p.size()]; keep[0]=true;
        ArrayDeque<int[]> work=new ArrayDeque<int[]>(); int start=0;
        for(int end:anchors){keep[end]=true;work.add(new int[]{start,end});start=end;}
        int operations=0;
        while(!work.isEmpty()) {
            int[] range=work.removeLast();int a=range[0],b=range[1],far=-1;double max=4; // squared 2 metre tolerance
            for(int j=a+1;j<b;j++) {
                if(++operations>4000000)return null;
                double d=distanceSquared(p.get(j),p.get(a),p.get(b));
                if(d>max){max=d;far=j;}
            }
            if(far>=0){keep[far]=true;work.add(new int[]{a,far});work.add(new int[]{far,b});}
        }
        JSONArray out=new JSONArray();
        for(int i=0;i<p.size();i++)if(keep[i]) {
            if(out.length()==MAX_POINTS)return null;
            out.put(new JSONObject().put("lat",p.get(i)[0]).put("lon",p.get(i)[1]));
        }
        return out;
    }
    private static double distanceSquared(double[] p,double[] a,double[] b) {
        double c=Math.cos(Math.toRadians((a[0]+b[0])/2));
        double x=(p[1]-a[1])*111320*c,y=(p[0]-a[0])*111320;
        double u=(b[1]-a[1])*111320*c,v=(b[0]-a[0])*111320;
        double t=u*u+v*v==0?0:Math.max(0,Math.min(1,(x*u+y*v)/(u*u+v*v)));
        return (x-t*u)*(x-t*u)+(y-t*v)*(y-t*v);
    }
}
