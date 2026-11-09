package com.navipilot.obf;

import android.app.*;
import android.content.*;
import android.net.Uri;
import android.os.*;
import android.provider.Settings;
import android.service.notification.StatusBarNotification;
import android.view.*;
import android.widget.*;
import android.graphics.Color;
import java.io.*;
import java.util.*;
import java.util.zip.*;
import org.json.*;

/** Bounded diagnostics around the unmodified Auto parser and Navi v2 transport. */
public final class WideNavProbe {
 private static final String PHONE="com.autonavi.minimap",AUTO="com.autonavi.amapauto",PREF="amap_nav_probe";
 private static boolean enabled,connected;private static Context context;
 private static long broadcasts,updates,snapshots,removed,accepted,rejected,lastBroadcast,lastNotification,lastC4,lastTelemetry;
 private static String error="",snapshot="尚未讀取",lastWire="尚無 Navi v2 排入紀錄",c4="尚無 Carrot 導航回傳",input="尚無導航資料類廣播";
 private static final LinkedHashMap<Integer,Long> types=new LinkedHashMap<Integer,Long>();
 private static final LinkedHashMap<Integer,String> latest=new LinkedHashMap<Integer,String>();
 private static final LinkedHashMap<String,String> notifications=new LinkedHashMap<String,String>();
 private static final ArrayDeque<String> wires=new ArrayDeque<String>();
 private static String now(){return new java.text.SimpleDateFormat("HH:mm:ss",Locale.TAIWAN).format(new Date());}
 private static String clip(Object x,int max){String s=String.valueOf(x).replace('\u0000',' ');return s.length()>max?s.substring(0,max)+"…":s;}
 public static synchronized void init(Context c){context=c.getApplicationContext();enabled=context.getSharedPreferences(PREF,0).getBoolean("enabled",false);}
 public static synchronized void bind(Context c,boolean value){init(c);connected=value;}
 public static synchronized void error(String s){error=s;}
 public static synchronized void snapshotResult(int total,int phone,int auto,String status){snapshot=now()+" · 系統通知 "+total+"／一般版 "+phone+"／車機版 "+auto+" · "+status;}
 private static String value(Object v){
  if(v==null)return "null";
  if(v instanceof CharSequence||v instanceof Number||v instanceof Boolean)return clip(v,1200);
  if(v instanceof Bundle){Bundle b=(Bundle)v;return "Bundle keys="+clip(new TreeSet<String>(b.keySet()),1200);}
  if(v.getClass().isArray()){int len=java.lang.reflect.Array.getLength(v);StringBuilder b=new StringBuilder("array[").append(len).append("] ");for(int i=0;i<Math.min(len,12);i++){Object e=java.lang.reflect.Array.get(v,i);if(e instanceof Number||e instanceof Boolean||e instanceof CharSequence)b.append(clip(e,120)).append(" | ");else b.append(e==null?"null":e.getClass().getSimpleName()).append(" | ");}return b.toString();}
  return "<"+v.getClass().getName()+">";
 }
 private static String extras(Bundle b){
  if(b==null)return "（無 extras）";StringBuilder out=new StringBuilder();int count=0;
  try{for(String key:new TreeSet<String>(b.keySet())){if(count++>=96||out.length()>10000){out.append("\n（已截長）");break;}try{Object v=b.get(key);out.append('\n').append(key).append(" [").append(v==null?"null":v.getClass().getSimpleName()).append("] = ").append(value(v));}catch(RuntimeException e){out.append('\n').append(key).append("=<無法讀取>");}}}catch(RuntimeException e){out.append("extras 無法展開：").append(e.getClass().getSimpleName());}return out.toString();
 }
 private static boolean navType(int t){return t==10001||t==10003||t==10006||t==10007||t==10042||t==10065||t==10070||t==12110||t==13003||t==13005||t==13011||t==13012||t==60073;}
 public static synchronized void broadcast(Intent i){
  if(!enabled||i==null)return;try{int type=i.getIntExtra("KEY_TYPE",-1);broadcasts++;lastBroadcast=SystemClock.elapsedRealtime();
   if(!types.containsKey(type)&&types.size()>=64){Integer first=types.keySet().iterator().next();types.remove(first);latest.remove(first);}Long n=types.get(type);types.put(type,n==null?1:n+1);
   String row=now()+" · "+clip(i.getAction(),200)+" · KEY_TYPE="+type+"\n來源未驗證（action／Intent.package 不是發送者身分）"+extras(i.getExtras());latest.put(type,row);
   if(navType(type))input=now()+" · 收到 KEY_TYPE="+type+"，仍須核對欄位及 Carrot 回傳";
  }catch(RuntimeException e){error="廣播取樣："+e.getClass().getSimpleName();}
 }
 private static void viewText(View v,StringBuilder out,int[] count){if(v==null||count[0]++>=128||out.length()>1800)return;if(v instanceof TextView){CharSequence t=((TextView)v).getText();if(t!=null&&t.length()>0)out.append(clip(t,300)).append(" | ");}if(v instanceof ViewGroup){ViewGroup g=(ViewGroup)v;for(int j=0;j<g.getChildCount()&&count[0]<128;j++)viewText(g.getChildAt(j),out,count);}}
 private static String custom(Context c,Notification n){StringBuilder out=new StringBuilder();for(RemoteViews rv:new RemoteViews[]{n.contentView,n.bigContentView,n.headsUpContentView}){if(rv==null||out.length()>1800)continue;try{viewText(rv.apply(c,null),out,new int[]{0});}catch(RuntimeException e){out.append("<自訂版面無法讀取:").append(e.getClass().getSimpleName()).append("> ");}}return clip(out,2000);}
 public static synchronized void notification(Context c,StatusBarNotification s,String kind){
  if(s==null||!PHONE.equals(s.getPackageName()))return;init(c);if(!enabled)return;
  try{if("更新".equals(kind))updates++;else if("快照".equals(kind))snapshots++;else removed++;
   lastNotification=SystemClock.elapsedRealtime();Notification n=s.getNotification();
   String row=now()+" · "+kind+" · package="+s.getPackageName()+" · id="+s.getId()+" · postTime="+s.getPostTime()+"\n"+extras(n.extras);
   // RemoteViews inflation is reserved for a user-requested snapshot, not repeated updates.
   if("快照".equals(kind))row+="\n自訂通知文字："+custom(c,n);
   String key=s.getKey();if(!notifications.containsKey(key)&&notifications.size()>=12)notifications.remove(notifications.keySet().iterator().next());notifications.put(key,clip(row,12500));
  }catch(RuntimeException e){error="通知取樣："+e.getClass().getSimpleName();}
 }
 public static synchronized void queued(String name,String wire,boolean ok,String host,int port){
  if(!enabled||name==null||!name.startsWith("json:"))return;
  try{JSONObject envelope=new JSONObject(wire);boolean present=envelope.optBoolean("present");if(ok)accepted++;else rejected++;
   lastWire=now()+" · "+host+":"+port+" · "+name+" · present="+present+" · 佇列"+(ok?"接受":"拒收");
   String row=lastWire+"\n"+clip(envelope.toString(),2400);if(wires.size()>=16)wires.removeFirst();wires.addLast(row);
  }catch(Exception e){error="傳送診斷："+e.getClass().getSimpleName();}
 }
 public static synchronized void telemetry(zg data,String url){
  if(!enabled||data==null)return;long t=SystemClock.elapsedRealtime();if(t-lastTelemetry<1000)return;lastTelemetry=t;
  try{vg n=data.b("carrotNavi");if(n==null)return;JSONObject nav=new JSONObject(n.a.c),out=new JSONObject();for(String k:new String[]{"sessionId","connected","navigationStatus","guidanceCurrent","speed"})if(nav.has(k))out.put(k,nav.opt(k));vg cm=data.b("carrotMan");if(cm!=null){JSONObject m=new JSONObject(cm.a.c),small=new JSONObject();for(String k:new String[]{"activeCarrot","xSpdType","xSpdLimit","xSpdDist","xTurnInfo","xDistToTurn","nRoadLimitSpeed","desiredSource"})small.put(k,m.opt(k));out.put("carrotMan",small);}lastC4=t;c4=now()+" · "+clip(url,110)+"\n"+clip(out.toString(2),6000);}catch(Exception e){error="Carrot 回傳診斷："+e.getClass().getSimpleName();}
 }
 private static String age(long t){return t==0?"尚無":((SystemClock.elapsedRealtime()-t)/1000)+" 秒前";}
 private static String version(Context c,String p){try{android.content.pm.PackageInfo i=c.getPackageManager().getPackageInfo(p,0);return i.versionName+" / "+i.getLongVersionCode();}catch(Exception e){return "未安裝或不可見";}}
 public static synchronized String report(Context c){init(c);StringBuilder b=new StringBuilder();b.append("Navipilot ").append(version(c,c.getPackageName())).append("\n一般版高德 → 原車機解析器 → 原 Navi v2 通道\n高德一般版：").append(version(c,PHONE)).append("\n高德車機版：").append(version(c,AUTO)).append("（安裝狀態不代表正在發送）\n取樣：").append(enabled?"開啟":"停止").append("\n通知服務：").append(connected?"已連接":"未連接").append("\n通知快照：").append(snapshot).append("\n一般版通知 更新 ").append(updates).append("／快照 ").append(snapshots).append("／移除 ").append(removed).append("；最近 ").append(age(lastNotification)).append("\n廣播 ").append(broadcasts).append("；最近 ").append(age(lastBroadcast)).append("\n各類計數：").append(types).append("\n導航類輸入：").append(input).append("\nNavi v2 佇列接受 ").append(accepted).append("／拒收 ").append(rejected).append("\n").append(lastWire).append("\nCarrot 回傳：").append(age(lastC4)).append("\n").append(c4).append("\n\n通知內容只取樣，未把文字猜成轉向／測速指令。佇列接受不代表車端接收或執行。\n廣播沿用車機版原解析與時間有效性檢查；請先停止車機版，避免來源混入。\n最近錯誤：").append(error.isEmpty()?"無":error).append("\n\n【一般版高德通知；最新每則】\n");for(String s:notifications.values())b.append(s).append("\n\n");b.append("【廣播；最新每類，含完整欄位名稱】\n");for(String s:latest.values())b.append(s).append("\n\n");b.append("【實際排入原通道的紀錄】\n");for(String s:wires)b.append(s).append("\n\n");return b.toString();}
 private static synchronized void start(Context c){init(c);enabled=true;context.getSharedPreferences(PREF,0).edit().putBoolean("enabled",true).apply();types.clear();latest.clear();notifications.clear();wires.clear();broadcasts=updates=snapshots=removed=accepted=rejected=0;lastBroadcast=lastNotification=lastC4=0;input="尚無導航資料類廣播";c4="等待新的 Carrot 回傳";lastWire="等待原 Navi v2 通道";error="";snapshot="正在讀取";}
 private static void openSettings(Activity a){for(Intent i:new Intent[]{new Intent(Settings.ACTION_NOTIFICATION_LISTENER_DETAIL_SETTINGS).putExtra(Settings.EXTRA_NOTIFICATION_LISTENER_COMPONENT_NAME,new ComponentName(a,WideNavNotifications.class).flattenToString()),new Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS),new Intent(Settings.ACTION_SETTINGS)}){try{a.startActivity(i);return;}catch(RuntimeException ignored){}}Toast.makeText(a,"系統未提供設定入口",Toast.LENGTH_LONG).show();}
 private static Button button(Activity a,String s,View.OnClickListener l){Button b=new Button(a);b.setText(s);b.setOnClickListener(l);return b;}
 private static void share(Activity a){try{File dir=new File(a.getCacheDir(),"share_images");dir.mkdirs();File f=new File(dir,"Navipilot-phone-log-"+System.currentTimeMillis()+".zip");ZipOutputStream z=new ZipOutputStream(new FileOutputStream(f));try{z.putNextEntry(new ZipEntry("diagnostics.txt"));z.write((report(a)+"\n\n"+WideTelemetry.report()).getBytes("UTF-8"));z.closeEntry();}finally{z.close();}Uri u=new Uri.Builder().scheme("content").authority(a.getPackageName()+".fileprovider").appendPath("share_images").appendPath(f.getName()).build();Intent i=new Intent(Intent.ACTION_SEND).setType("application/zip").putExtra(Intent.EXTRA_STREAM,u).addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);i.setClipData(ClipData.newRawUri("高德一般版診斷",u));a.startActivity(Intent.createChooser(i,"分享診斷（含導航與通知內容）"));}catch(Exception e){Toast.makeText(a,"分享失敗："+e.getClass().getSimpleName(),Toast.LENGTH_LONG).show();}}
 public static void show(final Activity a){init(a);final Dialog dialog=new Dialog(a);dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);LinearLayout panel=new LinearLayout(a);panel.setOrientation(1);panel.setPadding(14,8,14,8);panel.setBackgroundColor(0xff172230);
  TextView title=new TextView(a);title.setText("高德一般版串接診斷\n取樣包含高德通知、道路、定位欄位，分享前可檢查內容。");title.setTextColor(Color.WHITE);panel.addView(title);
  panel.addView(button(a,"開始／重新取樣（同時讀取既有通知）",new View.OnClickListener(){public void onClick(View v){start(a);WideNavNotifications.snapshot(a);}}));
  panel.addView(button(a,"讀取目前高德通知",new View.OnClickListener(){public void onClick(View v){if(!enabled)start(a);WideNavNotifications.snapshot(a);}}));
  panel.addView(button(a,"通知存取設定",new View.OnClickListener(){public void onClick(View v){openSettings(a);}}));
  panel.addView(button(a,"高德車機版資訊（可在系統強制停止）",new View.OnClickListener(){public void onClick(View v){try{a.startActivity(new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS,Uri.parse("package:"+AUTO)));}catch(RuntimeException e){error("車機版資訊無法開啟");}}}));
  panel.addView(button(a,"複製診斷結果",new View.OnClickListener(){public void onClick(View v){((ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(ClipData.newPlainText("高德串接診斷",report(a)));Toast.makeText(a,"已複製",Toast.LENGTH_SHORT).show();}}));
  panel.addView(button(a,"分享診斷檔",new View.OnClickListener(){public void onClick(View v){share(a);}}));
  panel.addView(button(a,"停止取樣",new View.OnClickListener(){public void onClick(View v){enabled=false;context.getSharedPreferences(PREF,0).edit().putBoolean("enabled",false).apply();}}));
  panel.addView(button(a,"關閉",new View.OnClickListener(){public void onClick(View v){dialog.dismiss();}}));
  final TextView text=new TextView(a);text.setTextColor(Color.WHITE);text.setTextSize(12);text.setTextIsSelectable(true);panel.addView(text);ScrollView scroll=new ScrollView(a);scroll.addView(panel);dialog.setContentView(scroll);dialog.show();View root=a.findViewById(android.R.id.content);dialog.getWindow().setLayout(Math.max(300,root.getWidth()*(100-WideSettings.left())/100),root.getHeight());dialog.getWindow().setGravity(Gravity.RIGHT|Gravity.TOP);
  final Handler h=new Handler(Looper.getMainLooper());final Runnable update=new Runnable(){public void run(){if(!dialog.isShowing())return;text.setText(report(a));h.postDelayed(this,1500);}};h.post(update);dialog.setOnDismissListener(new DialogInterface.OnDismissListener(){public void onDismiss(DialogInterface d){h.removeCallbacks(update);}});if(enabled)WideNavNotifications.snapshot(a);
 }
}
