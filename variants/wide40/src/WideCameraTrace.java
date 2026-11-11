package com.navipilot.obf;

import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;

/** Short rolling map match for camera display and audio on the existing offline road graph. */
final class WideCameraTrace {
    private static final int MAX_CANDIDATES = 12;
    private static final double MIN_MARGIN = 2.5;
    private static final WideCameraTrace shared = new WideCameraTrace();
    private static volatile Frame published;
    private static final WideAlertMotion motion = new WideAlertMotion();
    private static final class Frame {
        final WideHcopRoad.Data data;
        final long time;
        final WideHcopRoad.Decision decision;
        Frame(WideHcopRoad.Data d,long t,WideHcopRoad.Decision m){data=d;time=t;decision=m;}
    }
    private List<Candidate> previous = new ArrayList<>();
    private WideCameraEngine.Fix last;

    private static final class Candidate {
        final WideHcopRoad.Road road;
        final WideRoad.Projection point;
        final int direction;
        double cost;
        int samples = 1;
        long since;

        Candidate(WideHcopRoad.Road road, WideRoad.Projection point, int direction, double cost, long since) {
            this.road = road;
            this.point = point;
            this.direction = direction;
            this.cost = cost;
            this.since = since;
        }

        long entry() { return direction > 0 ? road.start : road.end; }
        long exit() { return direction > 0 ? road.end : road.start; }
        double progress() { return direction > 0 ? point.station : point.length - point.station; }
    }

    static void update(WideHcopRoad.Data data, WideCameraEngine.Fix fix, long now) {
        WideCameraEngine.Fix prepared = motion.accept(fix, now);
        WideHcopRoad.Decision decision = prepared == null ? null : shared.accept(data, prepared, now);
        published = new Frame(data, fix == null ? 0 : fix.time, decision);
    }

    static void clear() {
        published = null;
        shared.reset();
        motion.clear();
    }

    public static boolean eligible(WideCameraEngine.Fix f) { return WideAlertMotion.position(f, f == null ? 0 : f.time); }

    static WideHcopRoad.Decision display(WideHcopRoad.Decision original, WideCameraEngine.Fix fix, long now) {
        Frame frame=published;
        if (!WideAlertMotion.position(fix,now) || frame==null || frame.data==null || frame.data.expired
            || frame.time!=fix.time || frame.decision==null) {
            if(fix!=null && fix.speedValid && fix.speed<1.5)
                return new WideHcopRoad.Decision("目前停車／低速，等待起步確認方向",now);
            return original;
        }
        return frame.decision;
    }

    private void reset() {
        previous.clear();
        last = null;
    }

    WideHcopRoad.Decision accept(WideHcopRoad.Data data, WideCameraEngine.Fix fix, long now) {
        if (data == null || data.expired || (!WideAlertMotion.position(fix,now) || !fix.headingValid || fix.speed<1.5)) {
            reset();
            return null;
        }
        double elapsed = last == null ? 0 : (fix.time - last.time) / 1000.0;
        double motion = elapsed * (last == null ? fix.speed : (last.speed + fix.speed) / 2);
        double tolerance = Math.max(12, fix.accuracy * 2);
        if (elapsed <= 0 || elapsed > 3 || (last != null
                && WideCameraEngine.distance(last.lat, last.lon, fix.lat, fix.lon) > motion + tolerance * 2)) {
            reset();
        }
        List<Candidate> current = new ArrayList<>();
        for (WideHcopRoad.Road road : data.roads) {
            if (road.bounded && (fix.lon < road.minLon - .0005 || fix.lon > road.maxLon + .0005
                    || fix.lat < road.minLat - .0005 || fix.lat > road.maxLat + .0005)) continue;
            WideRoad.Projection point = WideRoad.project(road.xy, fix.lat, fix.lon, tolerance);
            if (point.ambiguous || point.offset > Math.min(35, Math.max(15, fix.accuracy * 1.5))) continue;
            double angle = WideRoad.delta(point.heading, fix.heading);
            int direction = angle <= 35 && road.dir >= 0 ? 1 : angle >= 145 && road.dir <= 0 ? -1 : 0;
            if (direction == 0) continue;
            double error = point.offset / Math.max(4, fix.accuracy);
            double headingError = Math.min(angle, 180 - angle) / 25;
            Candidate candidate = new Candidate(road, point, direction,
                    error * error + headingError * headingError, fix.time);
            continueFromHistory(candidate, motion, tolerance, data);
            current.add(candidate);
            if (current.size() > MAX_CANDIDATES) {
                reset();
                return null;
            }
        }
        previous = current;
        last = fix;
        Candidate best = null;
        double runnerUp = Double.POSITIVE_INFINITY;
        for (Candidate candidate : current) {
            if (best == null || candidate.cost < best.cost) {
                if (best != null) runnerUp = best.cost;
                best = candidate;
            } else runnerUp = Math.min(runnerUp, candidate.cost);
        }
        if (best == null) return null;
        double bestCost = best.cost;
        for (Candidate candidate : current) candidate.cost -= bestCost;
        WideHcopRoad.Decision selected=null;
        for(Candidate candidate:current) {
            if(candidate.samples<2 || fix.time-candidate.since<1000 || candidate.cost>3)continue;
            // Height ambiguity is informational: consider each forward road independently.
            WideHcopRoad.Decision found=ahead(data,candidate,fix.time);
            if(found.camera!=null && (selected==null || found.distance<selected.distance))selected=found;
        }
        if(selected!=null)return selected;
        if(best.samples<2 || fix.time-best.since<1000)return null;
        return ahead(data,best,fix.time);
    }

    private void continueFromHistory(Candidate candidate, double motion, double tolerance, WideHcopRoad.Data data) {
        double emission = candidate.cost;
        if (previous.isEmpty()) return;
        candidate.cost = emission + 5;
        for (Candidate old : previous) {
            double advance = advance(old, candidate, data, motion+tolerance);
            if (!Double.isFinite(advance) || advance < -tolerance || advance > motion + tolerance) continue;
            double deviation = (advance - motion) / tolerance;
            double cost = emission + old.cost * .75 + deviation * deviation;
            if (cost < candidate.cost) {
                candidate.cost = cost;
                candidate.samples = Math.min(10, old.samples + 1);
                candidate.since = old.since;
            }
        }
    }

    private static double advance(Candidate from, Candidate to, WideHcopRoad.Data data, double maximum) {
        if (from.road.id.equals(to.road.id)) {
            return from.direction == to.direction ? to.progress() - from.progress() : Double.NaN;
        }
        Candidate edge=from;
        double travelled=from.point.length-from.progress();
        Set<String> seen=new HashSet<>();
        for(int i=0;i<32 && travelled<=maximum;i++) {
            seen.add(edge.road.id);
            Candidate next=next(data,edge,seen);
            if(next==null)return Double.NaN;
            if(next.road.id.equals(to.road.id))return next.direction==to.direction ? travelled+to.progress() : Double.NaN;
            travelled+=next.point.length;edge=next;
        }
        return Double.NaN;
    }

    // Follow only a unique, connected continuation of the named road.
    // No Euclidean circle, arbitrary fork choice, U-turn or elevated/surface name swap.
    private static boolean sameRoute(WideHcopRoad.Road a,WideHcopRoad.Road b) {
        if(a.names==null || b.names==null)return false;
        for(String x:a.names)for(String y:b.names)
            if(x.equals(y) && x.length()>1 && !x.matches("[0-9]+"))return true;
        return false;
    }
    private static Candidate next(WideHcopRoad.Data data,Candidate from,Set<String> seen) {
        long exit=from.exit();if(exit==0)return null;
        Candidate found=null;
        for(WideHcopRoad.Road r:data.roads) {
            if(seen.contains(r.id) || !sameRoute(from.road,r))continue;
            int d=r.start==exit && r.dir>=0 ? 1 : r.end==exit && r.dir<=0 ? -1 : 0;
            if(d==0)continue;
            if(found!=null)return null;
            WideRoad.Projection p=WideRoad.project(r.xy,r.xy[0][1],r.xy[0][0],0);
            p.station=d>0?0:p.length;
            found=new Candidate(r,p,d,0,0);
        }
        return found;
    }
    private static void consider(WideHcopRoad.Decision decision, Candidate edge,
            WideHcopRoad.Camera camera,double entryDistance) {
        if(!edge.road.id.equals(camera.edge))return;
        boolean directionMatches=false;
        for(int direction:camera.dirs)directionMatches |= direction==edge.direction;
        if(!directionMatches)return;
        WideRoad.Projection point=WideRoad.project(edge.road.xy,camera.lat,camera.lon,0);
        double station=edge.direction>0?point.station:point.length-point.station;
        double distance=entryDistance+station;
        if(!point.ambiguous && distance>20 && distance<=1500
                && (decision.camera==null || distance<decision.distance)) {
            WideHcopRoad.Camera copy=new WideHcopRoad.Camera();
            copy.id=camera.id;copy.edge=camera.edge;copy.limit=camera.limit;copy.lat=camera.lat;copy.lon=camera.lon;copy.dirs=camera.dirs;
            String level=level(edge.road.grade);copy.road=level+" · "+camera.road;
            decision.camera=copy;decision.distance=distance;decision.source=level;
        }
    }
    public static String voiceKey(WideHcopRoad.Decision d) {
        if(d==null||d.camera==null)return null;
        return ("高架道路".equals(d.source)?"elev:":"平面道路".equals(d.source)?"flat:":"other:")+d.camera.id;
    }
    public static String voiceAsset(String id) {
        return id!=null&&id.startsWith("flat:")?"tw_camera_flat.mp3":id!=null&&id.startsWith("elev:")?"tw_camera_elevated.mp3":"tw_camera_voice_a.mp3";
    }
    static String level(String grade) {
        if(grade==null)return "道路層級未標明";
        String[] p=grade.split("\\|",-1);
        if(p.length!=3 || !"no".equals(p[2]))return "道路層級未標明";
        try {
            int layer=Integer.parseInt(p[0]);
            if(layer>0 || "yes".equals(p[1]) || "viaduct".equals(p[1]))return "高架道路";
            if(layer==0 && "no".equals(p[1]))return "平面道路";
        }catch(NumberFormatException ignored){}
        return "道路層級未標明";
    }
    private static WideHcopRoad.Decision ahead(WideHcopRoad.Data data, Candidate best, long time) {
        WideHcopRoad.Decision decision=new WideHcopRoad.Decision("同向道路候選 · 不區分本車高架／平面 · 僅提醒",time);
        Candidate edge=best;
        double entryDistance=-best.progress();
        Set<String> seen=new HashSet<>();
        for(int count=0;count<128 && entryDistance<=1500;count++) {
            seen.add(edge.road.id);
            for(WideHcopRoad.Camera camera:data.cameras)consider(decision,edge,camera,entryDistance);
            for(WideHcopRoad.Camera camera:WideHighwayAlertData.CAMERAS)consider(decision,edge,camera,entryDistance);
            entryDistance+=edge.point.length;
            Candidate following=next(data,edge,seen);
            if(following==null)break;
            edge=following;
        }
        decision.road=best.road;decision.direction=best.direction;
        decision.offset=best.point.offset;decision.confirmed=true;
        return decision;
    }
}
