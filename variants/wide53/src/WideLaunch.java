package com.navipilot.obf;
import android.content.Intent;
import java.util.*;
import java.util.concurrent.TimeUnit;
/** Called inside the existing privileged service after checking display ownership. */
public final class WideLaunch {
 public static boolean execute(String request,int display){try{
  if(display<=0||!request.startsWith("copilot-intent:"))return false;
  Intent i=Intent.parseUri(request.substring(15),Intent.URI_INTENT_SCHEME);String p=i.getPackage();
  if(i.getComponent()!=null){p=i.getComponent().getPackageName();if(!p.equals("com.jixiexiaoge.drivingassist.wide")||!i.getComponent().getClassName().equals("com.navdashn.KeyEntryActivity"))return false;}
  else if(!Arrays.asList("com.google.android.apps.maps","com.autonavi.minimap","com.autonavi.amapauto").contains(p))return false;
  ArrayList<String> args=new ArrayList<>(Arrays.asList("am","start","-W","--user","0","--display",Integer.toString(display),"-f","0x10000000"));
  if(i.getComponent()!=null){args.add("-n");args.add(i.getComponent().flattenToString());}
  else{args.add("-p");args.add(p);if(!Intent.ACTION_VIEW.equals(i.getAction())&&!Intent.ACTION_SEARCH.equals(i.getAction()))return false;args.add("-a");args.add(i.getAction());
   if(i.getData()!=null){String scheme=i.getData().getScheme();if(!Arrays.asList("google.navigation","androidamap").contains(scheme))return false;args.add("-d");args.add(i.getData().toString());}
   if(i.hasExtra("query")){args.add("--es");args.add("query");args.add(i.getStringExtra("query"));}}
  Process proc=new ProcessBuilder(args).redirectErrorStream(true).start();java.io.ByteArrayOutputStream out=new java.io.ByteArrayOutputStream();Thread reader=new Thread(()->{try{byte[] b=new byte[1024];int n;while((n=proc.getInputStream().read(b))!=-1){if(out.size()<16384)out.write(b,0,n);}}catch(Exception ignored){}});reader.start();
  if(!proc.waitFor(10,TimeUnit.SECONDS)){proc.destroy();return false;}reader.join(500);String result=out.toString("UTF-8");return proc.exitValue()==0&&!result.contains("Error:")&&!result.contains("Exception");
 }catch(Exception e){return false;}}
}
