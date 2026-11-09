package com.navipilot.obf;

import android.Manifest;
import android.app.Activity;
import android.content.*;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.SystemClock;
import android.widget.Toast;
import java.io.*;
import java.util.*;
import org.json.*;

/** Native display and GPS state; verified road matches feed the existing Navi v2 bridge. */
public final class WideCamera {
    private static volatile List<WideCameraEngine.Point> points=Collections.emptyList();
    private static volatile boolean loading,loaded;
    public static volatile boolean running;
    private static volatile String dataStatus="正在載入官方資料",serviceStatus="按「GPS」開始定位",date="",lastError="無";
    private static volatile WideCameraEngine.Fix fix;
    private static String metadata="";
    private static int knownDirections,sectionCount;
    private static final WideCameraSection sectionTracker=new WideCameraSection();
    private static String readAsset(Context c,String name)throws IOException {
        InputStream in=c.getAssets().open(name);ByteArrayOutputStream out=new ByteArrayOutputStream();
        try{byte[] b=new byte[8192];int n;while((n=in.read(b))!=-1)out.write(b,0,n);}finally{in.close();}
        return new String(out.toByteArray(),"UTF-8");
    }
    public static synchronized void init(final Context c){
        WideBridge.init(c);
        if(loading||loaded)return;loading=true;
        final Context app=c.getApplicationContext();
        new Thread(new Runnable(){public void run(){
            try{
                InputStream in=app.getAssets().open("tw_cameras.json");ByteArrayOutputStream out=new ByteArrayOutputStream();
                try{byte[]b=new byte[8192];int n;while((n=in.read(b))!=-1)out.write(b,0,n);}finally{in.close();}
                JSONObject doc=new JSONObject(new String(out.toByteArray(),"UTF-8"));JSONObject m=doc.getJSONObject("metadata");
                List<WideCameraEngine.Point> all=new ArrayList<WideCameraEngine.Point>();JSONArray rows=doc.getJSONArray("points");
                for(int i=0;i<rows.length();i++){JSONObject r=rows.getJSONObject(i);JSONArray d=r.getJSONArray("bearings");double[]deg=new double[d.length()];for(int j=0;j<deg.length;j++)deg[j]=d.getDouble(j);
                    all.add(new WideCameraEngine.Point(r.getString("id"),r.getString("road"),r.getString("city")+r.getString("region"),r.getString("direction"),r.getDouble("lat"),r.getDouble("lon"),r.getInt("limit"),deg,r.optBoolean("limitUncertain",false)));
                }
                if(all.size()!=m.getInt("fixedRecords")||all.isEmpty())throw new IOException("資料筆數不符");
                metadata=m.toString(2);knownDirections=m.getInt("knownDirectionRecords");date=m.getString("retrievedAt").substring(0,10);points=Collections.unmodifiableList(all);
                JSONObject sectionDoc=new JSONObject(readAsset(app,"tw_sections.json"));JSONArray sr=sectionDoc.getJSONArray("sections");
                List<WideCameraSection.Section> sl=new ArrayList<WideCameraSection.Section>();
                for(int i=0;i<sr.length();i++){JSONObject r=sr.getJSONObject(i);sl.add(new WideCameraSection.Section(r.getString("id"),r.getString("road"),r.getString("city"),r.getDouble("startLat"),r.getDouble("startLon"),r.getDouble("endLat"),r.getDouble("endLon"),r.getDouble("lengthM"),r.getInt("limit")));}
                sectionTracker.setSections(sl);sectionCount=sl.size();metadata+="\n區間快照：\n"+sectionDoc.getJSONObject("metadata").toString(2);
                dataStatus="固定 "+all.size()+" 筆 · 新北區間 "+sectionCount+" 方向 · "+date;loaded=true;
            }catch(Exception e){dataStatus="資料載入失敗";lastError=e.getClass().getSimpleName()+": "+e.getMessage();}finally{loading=false;}
        }},"WideCameraData").start();
    }
    public static boolean hasPermission(Context c){return c.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)==PackageManager.PERMISSION_GRANTED;}
    public static boolean start(Activity a){
        init(a);
        if(!hasPermission(a)){
            ArrayList<String> perms=new ArrayList<String>();perms.add(Manifest.permission.ACCESS_COARSE_LOCATION);perms.add(Manifest.permission.ACCESS_FINE_LOCATION);
            if(android.os.Build.VERSION.SDK_INT>=33&&a.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED)perms.add(Manifest.permission.POST_NOTIFICATIONS);
            a.requestPermissions(perms.toArray(new String[perms.size()]),8312);
            serviceStatus="請允許精確定位，再按 GPS";Toast.makeText(a,"請選「精確位置」，授權後再按 GPS",Toast.LENGTH_LONG).show();return false;
        }
        if(android.os.Build.VERSION.SDK_INT>=33&&a.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS)!=PackageManager.PERMISSION_GRANTED){
            a.requestPermissions(new String[]{Manifest.permission.POST_NOTIFICATIONS},8313);
        }
        try{a.startForegroundService(new Intent(a,WideCameraService.class));serviceStatus="正在啟動 GPS";return true;}
        catch(RuntimeException e){error("無法啟動 GPS："+e.getClass().getSimpleName());Toast.makeText(a,serviceStatus,Toast.LENGTH_LONG).show();return false;}
    }
    public static void stop(Context c){c.stopService(new Intent(c,WideCameraService.class));running=false;clearFix();serviceStatus="定位已停止";}
    public static void status(String s){serviceStatus=s;}
    public static void error(String s){lastError=s;serviceStatus=s;}
    public static void accept(Location l){
        if(!"gps".equals(l.getProvider()))return;
        long t=l.getElapsedRealtimeNanos()/1000000L;
        WideCameraEngine.Fix old=fix;if(old!=null&&t<=old.time)return;
        boolean heading=l.hasBearing()&&l.hasSpeed()&&l.getSpeed()>=1.5f;
        if(l.hasBearingAccuracy()&&l.getBearingAccuracyDegrees()>35)heading=false;
        fix=new WideCameraEngine.Fix(l.getLatitude(),l.getLongitude(),l.hasAccuracy()?l.getAccuracy():Double.NaN,l.getBearing(),l.hasSpeed()?l.getSpeed():0,t,heading,l.isMock());
        sectionTracker.accept(fix,SystemClock.elapsedRealtime());
        WideBridge.accept(fix);
    }
    public static void clearFix(){WideBridge.clear();fix=null;sectionTracker.reset("定位已中斷，區間計時失效");}
    public static WideCameraEngine.Fix fix(){return fix;}
    public static String data(){return dataStatus;}
    public static String service(){return serviceStatus;}
    public static WideCameraEngine.Result result(){
        if(!loaded)return new WideCameraEngine.Result(null,0,0,dataStatus);
        if(!running)return new WideCameraEngine.Result(null,0,0,serviceStatus);
        return WideCameraEngine.match(points,fix,SystemClock.elapsedRealtime());
    }
    public static WideCameraFace.Model model(){
        WideCameraEngine.Result fixed=result();WideCameraSection.Status s=sectionTracker.status(fix,SystemClock.elapsedRealtime());
        WideCameraFace.Model m=new WideCameraFace.Model();m.state=fixed.state;m.footer=gps();
        if(running&&s.section!=null&&(s.active||s.finished||fixed.point==null||s.distance<fixed.distance)){
            m.type=s.finished?4:s.active?3:2;m.limit=s.section.limit;m.distance=s.distance;m.seconds=s.seconds;m.average=s.average;
            m.title=s.finished?"區間已通過":s.active?"區間測速中（估）":"前方區間測速";
            m.road=s.section.road;m.state=s.reason;m.progress=s.active?1-s.distance/s.section.length:s.finished?1:1-s.distance/1500;
        }else if(fixed.point!=null){m.type=1;m.limit=fixed.point.limit;m.uncertain=fixed.point.limitUncertain;m.title="前方固定測速";m.distance=fixed.distance;m.road=fixed.point.road;m.progress=1-fixed.distance/1500;}
        m.badge=WideBridge.badge();
        if(WideBridge.enabled()){
            WideRoad.Match match=WideBridge.current();m.state=match.reason;
            if(match.camera!=null){m.type=1;m.limit=match.camera.limit;m.uncertain=false;m.title="台灣固定測速";m.distance=match.distance;m.road=match.camera.road;m.progress=1-match.distance/1500;m.roadMatched=true;}
            else if(m.type==1){m.title="固定點候選（未串接）";}
        }
        return m;
    }
    public static String gps(){
        WideCameraEngine.Fix f=fix;
        if(f==null)return running?"GPS 搜尋中":"GPS 未啟動";
        long age=Math.max(0,SystemClock.elapsedRealtime()-f.time);
        return String.format(Locale.TAIWAN,"GPS ±%.0f m · %.1f 秒前 · %.0f km/h",f.accuracy,age/1000.0,f.speed*3.6);
    }
    public static String preview(){
        WideCameraEngine.Result r=result();WideCameraEngine.Fix f=fix;
        try{
            JSONObject j=new JSONObject();j.put("previewOnly",true);j.put("sendEnabled",false);j.put("roadMatched",false);j.put("reason",r.state);j.put("distanceType","straight_line_candidate");
            WideCameraSection.Status section=sectionTracker.status(f,SystemClock.elapsedRealtime());
            j.put("sectionState",section.reason);
            if(section.section!=null){JSONObject sj=new JSONObject();sj.put("id",section.section.id);sj.put("activeEstimate",section.active);sj.put("finishedEstimate",section.finished);sj.put("limit",section.section.limit);sj.put("distanceM",Math.round(section.distance));sj.put("remainingRequiredSeconds",section.seconds>=0?Math.round(section.seconds):JSONObject.NULL);sj.put("distanceKind",section.active?"official_length_minus_gps_travel":"straight_to_start");j.put("sectionPreview",sj);}
            if(r.point!=null){j.put("cameraId",r.point.id);j.put("source","NPA Taiwan");j.put("nSdiType",1);j.put("nSdiDist",Math.round(r.distance));j.put("nSdiSpeedLimit",r.point.limitUncertain?JSONObject.NULL:r.point.limit);j.put("directionKnown",r.directionKnown);j.put("road",r.point.road);}
            if(f!=null)j.put("gpsAgeMs",Math.max(0,SystemClock.elapsedRealtime()-f.time));
            return j.toString(2);
        }catch(JSONException e){return "預覽產生失敗";}
    }
    public static String report(){
        WideCameraEngine.Result r=result();WideCameraEngine.Fix f=fix;
        return "Navipilot wide.14-tw-bridge\n"+dataStatus+"\n可辨識方向："+knownDirections+" 筆\n"+serviceStatus+"\n"+gps()+"\n"+r.state+
            (r.point==null?"":"\n"+r.point.city+" "+r.point.road+"\n來源方向："+r.point.direction+"\n直線距離："+Math.round(r.distance)+" m；側向偏移：約 "+Math.round(r.lateral)+" m")+
            (f==null?"":String.format(Locale.US,"\nGPS: %.6f, %.6f; heading=%.1f",f.lat,f.lon,f.heading))+
            "\n\n以下是寬鬆候選的顯示診斷，不代表已串接。實際傳送採 WideBridge 同路段配對，請看串接狀態與 speed_wire 紀錄。\n"+preview()+
            "\n\n資料快照：\n"+metadata+"\n最近錯誤："+lastError;
    }
}
