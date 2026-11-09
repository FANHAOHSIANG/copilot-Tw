package com.navipilot.obf;
import android.content.*;import android.service.notification.*;
public class WideNotificationTest {static int passed;static void check(boolean b,String m){if(!b)throw new AssertionError(m);passed++;System.out.println("PASS "+m);}public static void main(String[] a){
StatusBarNotification phone=new StatusBarNotification("com.autonavi.minimap",123);
NotificationListenerService.active=new StatusBarNotification[]{phone,new StatusBarNotification("com.autonavi.amapauto",1),new StatusBarNotification("private.other.app",2)};
WideNavNotifications service=new WideNavNotifications();service.onListenerConnected();check(WideNavProbe.connected&&WideNavProbe.notices==1,"Existing phone notification is sampled at listener connection without a posted callback");
check(WideNavProbe.total==3&&WideNavProbe.phone==1&&WideNavProbe.auto==1,"Snapshot identifies phone vs auto and does not read other app content");
check(WideNavProbe.last==phone&&WideNavProbe.last.postTime==123,"Snapshot preserves original notification identity and timestamp");
WideNavProbe.notices=0;WideNavNotifications.snapshot(new Context());check(WideNavProbe.notices==1,"Restart or manual snapshot repopulates an unchanged existing notification");
NotificationListenerService.active=new StatusBarNotification[0];WideNavNotifications.snapshot(new Context());check(WideNavProbe.total==0&&WideNavProbe.phone==0,"Empty notification tray is explicit");
NotificationListenerService.fail=true;WideNavNotifications.snapshot(new Context());check(WideNavProbe.total==-1&&WideNavProbe.error.contains("SecurityException"),"Snapshot failure is not reported as no notifications");NotificationListenerService.fail=false;
service.onListenerDisconnected();WideNavNotifications.snapshot(new Context());check(!WideNavProbe.connected&&NotificationListenerService.rebound==1,"Disconnected listener requests rebind instead of querying invalid service");
service.onListenerConnected();service.onDestroy();int before=NotificationListenerService.rebound;WideNavNotifications.snapshot(new Context());check(NotificationListenerService.rebound==before+1&&!WideNavProbe.connected,"Destroyed listener reference is cleared");
System.out.println("TOTAL "+passed+" passed; JVM framework doubles, not Android device verification");}}
