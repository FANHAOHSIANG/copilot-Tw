package com.navipilot.obf;
import android.app.*;
import android.content.*;
import android.content.pm.*;
import android.view.*;
import android.widget.*;
import java.util.*;
/** Per-pane preferences; the native command grid remains intact. */
public final class WidePanels {
 private static final TF mode=GS.f(Integer.valueOf(-1),bT.k);
 static SharedPreferences prefs(Context c){return c.getSharedPreferences("copilot_tw_projection",0);}
 static String sidePackage(Context c){return prefs(c).getString("side_package","tw.com.ainvest.outpack");}
 static String sideLabel(Context c){String p=sidePackage(c);if(p.isEmpty())return "留白";try{return c.getPackageManager().getApplicationLabel(c.getPackageManager().getApplicationInfo(p,0)).toString();}catch(Exception e){return "App 未安裝";}}
 static void chooseSide(Activity a){
  PackageManager pm=a.getPackageManager();Intent q=new Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER);
  List<ResolveInfo> all=pm.queryIntentActivities(q,0);Map<String,String> labels=new TreeMap<>();
  for(ResolveInfo r:all){String p=r.activityInfo.packageName;if(!p.equals(a.getPackageName())&&!p.equals(WideVariant.packageName()))labels.put(p,r.loadLabel(pm).toString());}
  ArrayList<String> packages=new ArrayList<>(labels.keySet());Collections.sort(packages,(x,y)->labels.get(x).compareTo(labels.get(y)));
  packages.add(0,"");String[] names=new String[packages.size()];names[0]="不投屏 · 靜謐時鐘";for(int i=1;i<names.length;i++)names[i]=labels.get(packages.get(i));
  new AlertDialog.Builder(a).setTitle("右上畫面").setSingleChoiceItems(names,packages.indexOf(sidePackage(a)),(d,i)->{
   prefs(a).edit().putString("side_package",packages.get(i)).apply();WideDirect.changeSide();d.dismiss();
  }).setNegativeButton("取消",null).show();
 }
 static void chooseLower(Activity a){new AlertDialog.Builder(a).setTitle("右下畫面").setSingleChoiceItems(new String[]{"九宮格快捷鍵","即時參數與連線診斷"},lower(a),(d,i)->{
  prefs(a).edit().putInt("lower_panel",i).apply();mode.setValue(Integer.valueOf(i));
  if(!WideSettings.controlsVisible())WideSettings.toggleControls(a);d.dismiss();
 }).setNegativeButton("取消",null).show();}
 static int lower(Context c){int v=((Number)mode.getValue()).intValue();if(v<0){v=prefs(c).getInt("lower_panel",0);mode.setValue(Integer.valueOf(v));}return v;}
 public static Object controls(yr original,Object modifier,Object composer,Object flags){
  Activity a=WideVariant.activity(null);if(a==null||lower(a)==0)return original.h(modifier,composer,flags);
  androidx.compose.ui.viewinterop.a.a(new vr(){public Object j(Object c){return new WideDiagnostics((Context)c);}},(VE)modifier,null,
   new vr(){public Object j(Object v){((WideDiagnostics)v).dispose();return J10.a;}},new vr(){public Object j(Object v){return J10.a;}},(Hh)composer,0);
  return J10.a;
 }
}
