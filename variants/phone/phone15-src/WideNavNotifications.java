package com.navipilot.obf;

import android.content.ComponentName;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;

/** Notifications are observations only. No text is turned into driving instructions. */
public final class WideNavNotifications extends NotificationListenerService {
 private static volatile WideNavNotifications live;
 public void onListenerConnected(){live=this;WideNavProbe.bind(this,true);snapshot(this);}
 public void onListenerDisconnected(){live=null;WideNavProbe.bind(this,false);}
 public void onDestroy(){if(live==this)live=null;WideNavProbe.bind(this,false);super.onDestroy();}
 public void onNotificationPosted(StatusBarNotification n){WideNavProbe.notification(this,n,"更新");}
 public void onNotificationRemoved(StatusBarNotification n){WideNavProbe.notification(this,n,"移除");}
 public static void snapshot(final Context c){
  new Handler(Looper.getMainLooper()).post(new Runnable(){public void run(){
   WideNavNotifications service=live;
   if(service==null){WideNavProbe.snapshotResult(-1,0,0,"服務尚未連接，已要求重新連接");
    try{requestRebind(new ComponentName(c,WideNavNotifications.class));}catch(RuntimeException e){WideNavProbe.error("重新連接："+e.getClass().getSimpleName());}return;}
   try{StatusBarNotification[] all=service.getActiveNotifications();int phone=0,auto=0;
    if(all!=null)for(StatusBarNotification n:all){if("com.autonavi.minimap".equals(n.getPackageName())){phone++;WideNavProbe.notification(c,n,"快照");}else if("com.autonavi.amapauto".equals(n.getPackageName()))auto++;}
    WideNavProbe.snapshotResult(all==null?0:all.length,phone,auto,"完成；非高德一般版通知不讀內容");
   }catch(RuntimeException e){WideNavProbe.snapshotResult(-1,0,0,"快照失敗："+e.getClass().getSimpleName());}
  }});
 }
}
