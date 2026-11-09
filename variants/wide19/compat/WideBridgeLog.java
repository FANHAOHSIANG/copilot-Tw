package com.navipilot.obf;
import android.app.Activity;
import android.content.*;
import android.net.Uri;
import android.os.*;
import android.widget.Toast;
import java.io.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.zip.*;
import org.json.*;

/** Bounded opt-in local recorder; export is only through the user's share sheet. */
public final class WideBridgeLog {
 private static Context context;private static Handler worker;private static volatile boolean recording;private static volatile String error="";
 private static final AtomicInteger queued=new AtomicInteger();private static volatile long dropped;private static File dir;
 public static synchronized void init(Context c){if(worker!=null)return;context=c.getApplicationContext();dir=new File(context.getFilesDir(),"tw_bridge_logs");dir.mkdirs();HandlerThread t=new HandlerThread("TaiwanBridgeLog");t.start();worker=new Handler(t.getLooper());}
 public static boolean recording(){return recording;}
 public static synchronized void toggle(){
  if(worker==null)return;
  if(recording){event("stop","user");recording=false;return;}
  dropped=0;error="";worker.post(new Runnable(){public void run(){for(int i=0;i<3;i++)new File(dir,"events"+i+".jsonl").delete();write("{\"event\":\"start\",\"version\":\"wide.16\",\"wall_ms\":"+System.currentTimeMillis()+"}");}});recording=true;
 }
 public static String status(){return (recording?"紀錄中":"紀錄已停止")+" · 最多約 12 MB · 丟棄 "+dropped+" 筆"+(error.isEmpty()?"":" · "+error);}
 public static void event(String type,Object data){
  if(!recording||worker==null)return;
  try{JSONObject j=new JSONObject();j.put("event",type);j.put("wall_ms",System.currentTimeMillis());j.put("mono_ms",SystemClock.elapsedRealtime());j.put("data",data);final String line=j.toString();
   if(queued.incrementAndGet()>200){queued.decrementAndGet();dropped++;return;}
   worker.post(new Runnable(){public void run(){try{write(line);}finally{queued.decrementAndGet();}}});
  }catch(Exception e){dropped++;}
 }
 private static void write(String line){try{
  File f=new File(dir,"events0.jsonl");if(f.length()>4*1024*1024){new File(dir,"events2.jsonl").delete();new File(dir,"events1.jsonl").renameTo(new File(dir,"events2.jsonl"));f.renameTo(new File(dir,"events1.jsonl"));}
  FileOutputStream out=new FileOutputStream(f,true);try{out.write((line+"\n").getBytes("UTF-8"));}finally{out.close();}
 }catch(Exception e){error="寫入失敗："+e.getClass().getSimpleName();}}
 public static void share(final Activity a){
  if(worker==null)return;event("export","user");recording=false;
  final String report=WideBridge.report()+"\n\n"+WideCamera.report()+"\n\n"+WideTelemetry.report();
  worker.post(new Runnable(){public void run(){try{
   File folder=new File(context.getCacheDir(),"share_images");folder.mkdirs();
   File[] old=folder.listFiles();if(old!=null)for(File f:old)if(f.getName().startsWith("Navipilot-TW-log-")&&System.currentTimeMillis()-f.lastModified()>86400000)f.delete();
   final File zip=new File(folder,"Navipilot-TW-log-"+System.currentTimeMillis()+".zip");ZipOutputStream z=new ZipOutputStream(new FileOutputStream(zip));
   try{z.putNextEntry(new ZipEntry("diagnostics.txt"));z.write(report.getBytes("UTF-8"));z.closeEntry();
    for(int i=2;i>=0;i--){File f=new File(dir,"events"+i+".jsonl");if(f.exists()){z.putNextEntry(new ZipEntry(f.getName()));FileInputStream in=new FileInputStream(f);try{byte[] b=new byte[8192];int n;while((n=in.read(b))!=-1)z.write(b,0,n);}finally{in.close();}z.closeEntry();}}
   }finally{z.close();}
   a.runOnUiThread(new Runnable(){public void run(){try{
    Uri uri=new Uri.Builder().scheme("content").authority(a.getPackageName()+".fileprovider").appendPath("share_images").appendPath(zip.getName()).build();
    Intent intent=new Intent(Intent.ACTION_SEND).setType("application/zip").putExtra(Intent.EXTRA_STREAM,uri).addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
    intent.setClipData(ClipData.newRawUri("台灣測速測試紀錄",uri));a.startActivity(Intent.createChooser(intent,"匯出紀錄（含 GPS 軌跡）"));
   }catch(Exception e){Toast.makeText(a,"無法開啟分享："+e.getClass().getSimpleName(),Toast.LENGTH_LONG).show();}}});
  }catch(final Exception e){error="匯出失敗："+e.getClass().getSimpleName();a.runOnUiThread(new Runnable(){public void run(){Toast.makeText(a,error,Toast.LENGTH_LONG).show();}});}}});
 }
}
