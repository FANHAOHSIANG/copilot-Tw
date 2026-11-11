package com.navipilot.obf;

import java.util.List;
import java.util.ArrayList;

/** Pure GPS candidate screening. Never authorizes a control packet or claims road matching. */
public final class WideCameraEngine {
    public static final long MAX_AGE_MS=5000;
    public static final double MAX_ACCURACY_M=30, RANGE_M=1500;
    public static final class Point {
        public final String id,road,city,direction;
        public final double lat,lon; public final int limit; public final double[] bearings; public final boolean limitUncertain;
        public Point(String id,String road,String city,String direction,double lat,double lon,int limit,double[] bearings,boolean uncertain){
            this.id=id;this.road=road;this.city=city;this.direction=direction;this.lat=lat;this.lon=lon;this.limit=limit;this.bearings=bearings;this.limitUncertain=uncertain;
        }
    }
    public static final class Fix {
        public final double lat,lon,accuracy,heading,speed; public final long time; public final boolean headingValid,mock,speedValid;
        public Fix(double lat,double lon,double accuracy,double heading,double speed,long time,boolean headingValid,boolean mock){
            this(lat,lon,accuracy,heading,speed,time,headingValid,mock,true);
        }
        public Fix(double lat,double lon,double accuracy,double heading,double speed,long time,boolean headingValid,boolean mock,boolean speedValid){
            this.lat=lat;this.lon=lon;this.accuracy=accuracy;this.heading=heading;this.speed=speed;this.time=time;this.headingValid=headingValid;this.mock=mock;this.speedValid=speedValid;
        }
    }
    public static final class Result {
        public final Point point; public final double distance,lateral; public final String state; public final boolean directionKnown,proximityOnly;
        public Result(Point point,double distance,double lateral,String state){this(point,distance,lateral,state,false);}
        public Result(Point point,double distance,double lateral,String state,boolean proximityOnly){this.point=point;this.distance=distance;this.lateral=lateral;this.state=state;this.directionKnown=point!=null&&point.bearings.length>0;this.proximityOnly=proximityOnly;}
    }
    public static boolean finite(double v){return !Double.isNaN(v)&&!Double.isInfinite(v);}
    public static double difference(double a,double b){double d=Math.abs((a-b)%360);return Math.min(d,360-d);}
    public static double distance(double lat1,double lon1,double lat2,double lon2){
        double p1=Math.toRadians(lat1),p2=Math.toRadians(lat2),d1=p2-p1,d2=Math.toRadians(lon2-lon1);
        double a=Math.sin(d1/2)*Math.sin(d1/2)+Math.cos(p1)*Math.cos(p2)*Math.sin(d2/2)*Math.sin(d2/2);
        return 6371000*2*Math.atan2(Math.sqrt(Math.max(0,Math.min(1,a))),Math.sqrt(Math.max(0,1-a)));
    }
    public static double bearing(double lat1,double lon1,double lat2,double lon2){
        double p1=Math.toRadians(lat1),p2=Math.toRadians(lat2),dl=Math.toRadians(lon2-lon1);
        return (Math.toDegrees(Math.atan2(Math.sin(dl)*Math.cos(p2),Math.cos(p1)*Math.sin(p2)-Math.sin(p1)*Math.cos(p2)*Math.cos(dl)))+360)%360;
    }
    public static String invalidPosition(Fix f,long now){
        if(f==null)return "等待 GPS 定位";
        if(!finite(f.lat)||!finite(f.lon)||f.lat < -90||f.lat > 90||f.lon < -180||f.lon > 180)return "定位座標無效";
        if(f.time<=0||now<f.time||now-f.time>MAX_AGE_MS)return "GPS 已過期，暫停判斷";
        if(f.mock)return "模擬定位，暫停判斷";
        if(!finite(f.accuracy)||f.accuracy<=0||f.accuracy>MAX_ACCURACY_M)return "GPS 精度不足，暫停判斷";
        return null;
    }
    public static boolean validSpeed(Fix f,long now){
        return invalidPosition(f,now)==null && now-f.time<=3000 && f.speedValid
                && finite(f.speed) && f.speed>=0 && f.speed<=100;
    }
    public static String invalid(Fix f,long now){
        String bad=invalidPosition(f,now);if(bad!=null)return bad;
        if(!finite(f.speed)||f.speed<1.5)return "低速／停車，等待行進方向";
        if(!f.headingValid||!finite(f.heading)||f.heading<0||f.heading>=360)return "等待可靠行進方向";
        return null;
    }
    public static Result match(List<Point> points,Fix f,long now){
        String invalid=invalid(f,now);if(invalid!=null)return new Result(null,0,0,invalid);
        Point best=null;double nearest=RANGE_M+1,lateral=0;
        for(Point p:points){
            if(!finite(p.lat)||!finite(p.lon)||Math.abs(p.lat-f.lat)>.014||Math.abs(p.lon-f.lon)>.02)continue;
            double d=distance(f.lat,f.lon,p.lat,p.lon);if(d>RANGE_M||d<12||d>=nearest)continue;
            double ray=difference(f.heading,bearing(f.lat,f.lon,p.lat,p.lon));
            double cross=d*Math.sin(Math.toRadians(ray));
            if(ray>30||cross>60)continue; // geometric corridor only, NOT road topology
            if(p.bearings.length>0){boolean same=false;for(double heading:p.bearings)if(difference(f.heading,heading)<=50)same=true;if(!same)continue;}
            best=p;nearest=d;lateral=cross;
        }
        if(best==null)return new Result(null,0,0,"前方 1.5 km 無符合的固定點");
        return new Result(best,nearest,lateral,best.limitUncertain?"雙向速限有差異，待核對":best.bearings.length==0?"方向不明，僅供參考":"方向初篩符合，尚未確認道路");
    }
    /** Nearest camera only; never calls it ahead or supplies it as vehicle-control data. */
    public static Result nearby(List<Point> points,Fix f,long now){
        String bad=invalidPosition(f,now);if(bad!=null)return new Result(null,0,0,bad);
        Point best=null;double nearest=500.0001;
        for(Point p:points){
            if(!finite(p.lat)||!finite(p.lon)||Math.abs(p.lat-f.lat)>.005||Math.abs(p.lon-f.lon)>.006)continue;
            double d=distance(f.lat,f.lon,p.lat,p.lon);if(d>500||d>=nearest)continue;
            best=p;nearest=d;
        }
        return best==null?new Result(null,0,0,"等待可靠行進方向"):
            new Result(best,nearest,0,"方向與道路未確認 · 附近直線距離",true);
    }
    public static Result demo(){return new Result(new Point("demo","測速面板示範 · 非實際道路","展示模式","往北",25,121,60,new double[]{0},false),620,0,"示範資料，不使用真實定位");}
}
