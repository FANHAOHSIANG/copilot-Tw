package com.navipilot.obf;

import org.json.*;
import java.util.*;

/** Independent offline map layer. Never publishes speed limits or vehicle control commands. */
public final class WideEnforcementCatalog {
    private final JSONArray records;
    private final JSONObject tiles;
    private final double tileDegrees;
    public WideEnforcementCatalog(String json) throws JSONException {
        JSONObject root = new JSONObject(json);
        if (root.getInt("schemaVersion") != 1) throw new JSONException("Unsupported enforcement schema");
        records = root.getJSONArray("records");
        tiles = root.getJSONObject("tiles");
        tileDegrees = root.getDouble("tileDegrees");
        if (tileDegrees != .01) throw new JSONException("Unsupported spatial grid");
    }
    public static final class Site {
        public final JSONObject record;
        public final double distanceMeters;
        public final boolean oppositeDirection;
        Site(JSONObject record, double distance, boolean opposite) {
            this.record = record; this.distanceMeters = distance; this.oppositeDirection = opposite;
        }
        // Nearby is not the same road. The future road matcher must confirm a road/approach first.
        public boolean preciseAlertReady() { return false; }
    }
    /** Works with GPS alone, without an active route. Returns map candidates, not alert decisions. */
    public List<Site> nearby(double latitude, double longitude, double radiusMeters,
                             Double travelBearing, String todayISO) throws JSONException {
        if (!Double.isFinite(latitude) || !Double.isFinite(longitude)
                || latitude < 21 || latitude > 27 || longitude < 118 || longitude > 123
                || !Double.isFinite(radiusMeters) || radiusMeters <= 0 || radiusMeters > 5000)
            throw new IllegalArgumentException("Invalid Taiwan query or radius (0,5000]");
        if (todayISO == null || !todayISO.matches("20\\d\\d-\\d\\d-\\d\\d"))
            throw new IllegalArgumentException("ISO date required");
        double dy = radiusMeters / 110000.0;
        double dx = dy / Math.cos(Math.toRadians(latitude));
        List<Site> result = new ArrayList<Site>();
        for (int x = (int)Math.floor((longitude-dx)*100); x <= (int)Math.floor((longitude+dx)*100); x++)
            for (int y = (int)Math.floor((latitude-dy)*100); y <= (int)Math.floor((latitude+dy)*100); y++) {
                JSONArray ids = tiles.optJSONArray(x+":"+y);
                if (ids == null) continue;
                for (int i=0; i<ids.length(); i++) {
                    JSONObject record = records.getJSONObject(ids.getInt(i));
                    String active = record.optString("activationDate", "");
                    if (!active.isEmpty() && !active.equals("null") && active.compareTo(todayISO)>0) continue;
                    JSONArray point = record.getJSONArray("coordinates");
                    double distance = distance(latitude,longitude,point.getDouble(1),point.getDouble(0));
                    if (distance>radiusMeters) continue;
                    boolean opposite = false;
                    if (travelBearing != null && Double.isFinite(travelBearing) && !record.isNull("travelBearing")) {
                        double delta = Math.abs(((travelBearing-record.getDouble("travelBearing"))%360+540)%360-180);
                        opposite = delta>90;
                    }
                    result.add(new Site(record,distance,opposite));
                }
            }
        Collections.sort(result,new Comparator<Site>() { public int compare(Site a,Site b) {
            return Double.compare(a.distanceMeters,b.distanceMeters);
        }});
        return result;
    }
    private static double distance(double a,double b,double c,double d) {
        double p=Math.toRadians(c-a),q=Math.toRadians(d-b);
        double h=Math.sin(p/2)*Math.sin(p/2)+Math.cos(Math.toRadians(a))*Math.cos(Math.toRadians(c))*Math.sin(q/2)*Math.sin(q/2);
        return 6371000*2*Math.atan2(Math.sqrt(h),Math.sqrt(Math.max(0,1-h)));
    }
}
