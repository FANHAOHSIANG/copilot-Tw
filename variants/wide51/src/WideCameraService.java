package com.navipilot.obf;

import android.app.*;
import android.content.*;
import android.content.pm.ServiceInfo;
import android.location.*;
import android.os.*;

/** Started from visible activity only; ongoing location notification, explicit stop action. */
public final class WideCameraService extends Service implements LocationListener {
    private LocationManager manager;
    private WideCameraAlerts alerts;
    private static final String CHANNEL="wide_camera_gps";
    public void onCreate(){super.onCreate();WideCamera.init(this);}
    public int onStartCommand(Intent intent,int flags,int id){
        if(intent!=null&&"STOP".equals(intent.getAction())){WideCamera.stop(this);stopSelf();return START_NOT_STICKY;}
        if(!WideCamera.hasPermission(this)){WideCamera.error("需要精確定位權限");stopSelf();return START_NOT_STICKY;}
        try{
            NotificationManager nm=(NotificationManager)getSystemService(NOTIFICATION_SERVICE);
            nm.createNotificationChannel(new NotificationChannel(CHANNEL,"測速 GPS 定位",NotificationManager.IMPORTANCE_LOW));
            Intent open=getPackageManager().getLaunchIntentForPackage(getPackageName());
            PendingIntent content=PendingIntent.getActivity(this,8312,open,PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
            PendingIntent stop=PendingIntent.getService(this,8313,new Intent(this,WideCameraService.class).setAction("STOP"),PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
            Notification n=new Notification.Builder(this,CHANNEL).setSmallIcon(android.R.drawable.ic_menu_mylocation).setContentTitle("台灣測速 GPS 定位")
                .setContentText("定位運作中 · 資料來源與傳送狀態請見 App").setContentIntent(content).setOngoing(true)
                .addAction(new Notification.Action.Builder(null,"停止定位",stop).build()).build();
            startForeground(8312,n,ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION);
            if(manager==null){
                manager=(LocationManager)getSystemService(LOCATION_SERVICE);
                if(!manager.getAllProviders().contains(LocationManager.GPS_PROVIDER))throw new IllegalStateException("這台車機沒有 GPS 定位來源");
                manager.requestLocationUpdates(LocationManager.GPS_PROVIDER,1000L,0f,this,Looper.getMainLooper());
            }
            WideCamera.running=true;
            if(alerts==null)alerts=new WideCameraAlerts(this);alerts.start();
            WideCamera.status(manager.isProviderEnabled(LocationManager.GPS_PROVIDER)?"GPS 定位已啟動":"請開啟車機的位置服務");
        }catch(RuntimeException e){WideCamera.error("GPS 啟動失敗："+e.getMessage());stopSelf();}
        return START_NOT_STICKY;
    }
    public void onLocationChanged(Location l){WideCamera.accept(l);}
    public void onProviderDisabled(String p){WideCamera.clearFix();WideCamera.status("GPS 已關閉，請開啟位置服務");}
    public void onProviderEnabled(String p){WideCamera.status("GPS 已開啟，等待新定位");}
    public void onStatusChanged(String p,int status,Bundle extras){}
    public IBinder onBind(Intent i){return null;}
    public void onDestroy(){
        if(alerts!=null){alerts.stop();alerts=null;}
        if(manager!=null)try{manager.removeUpdates(this);}catch(RuntimeException ignored){}
        manager=null;WideCamera.running=false;WideCamera.clearFix();stopForeground(STOP_FOREGROUND_REMOVE);super.onDestroy();
    }
}
