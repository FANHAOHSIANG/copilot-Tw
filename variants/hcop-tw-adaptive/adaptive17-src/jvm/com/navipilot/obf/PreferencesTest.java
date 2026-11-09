package com.navipilot.obf;
import java.lang.reflect.*;
import java.util.*;
import android.content.SharedPreferences;
import android.app.Activity;
public class PreferencesTest {
 static int tests;
 static void check(boolean value,String label){if(!value)throw new AssertionError(label);tests++;System.out.println("PASS "+label);}
 public static void main(String[] args){
  final Map<String,Integer> saved=new HashMap<String,Integer>();
  saved.put("left_percent",62);saved.put("top_percent",70);
  final SharedPreferences.Editor editor=(SharedPreferences.Editor)Proxy.newProxyInstance(PreferencesTest.class.getClassLoader(),new Class[]{SharedPreferences.Editor.class},new InvocationHandler(){public Object invoke(Object proxy,Method m,Object[] a){
    if(m.getName().equals("putInt")){saved.put((String)a[0],(Integer)a[1]);return proxy;}
    if(m.getName().equals("apply"))return null;
    throw new AssertionError(m.getName());
  }});
  SharedPreferences prefs=(SharedPreferences)Proxy.newProxyInstance(PreferencesTest.class.getClassLoader(),new Class[]{SharedPreferences.class},new InvocationHandler(){public Object invoke(Object proxy,Method m,Object[] a){
    if(m.getName().equals("getInt"))return saved.containsKey(a[0])?saved.get(a[0]):a[1];
    if(m.getName().equals("edit"))return editor;
    throw new AssertionError(m.getName());
  }});
  Activity a=new Activity(prefs);WideSettings.install(a);WideLayout.configure(1280,480);
  check(WideSettings.left()==62&&WideSettings.top()==70,"migrate existing landscape ratios");
  check(WideSettings.controlsVisible(),"wide window opens original controls");
  WideLayout.configure(360,780);
  check(WideSettings.left()==55&&WideSettings.top()==0&&!WideSettings.controlsVisible(),"portrait starts independently, controls collapsed");
  WideSettings.save(a,65,35);WideSettings.toggleControls(a);
  check(WideSettings.left()==65&&WideSettings.top()==35&&WideSettings.controlsVisible(),"portrait save and expand");
  WideLayout.configure(1280,480);
  check(WideSettings.left()==62&&WideSettings.top()==70&&WideSettings.controlsVisible(),"rotation preserves landscape values");
  WideLayout.configure(780,360);
  check(!WideSettings.controlsVisible(),"short landscape defaults to collapsed");
  WideSettings.toggleControls(a);WideSettings.save(a,40,55);
  check(WideSettings.controlsVisible()&&WideSettings.left()==40,"short landscape user expands controls");
  WideSettings.install(a);WideLayout.configure(360,780);
  check(WideSettings.left()==65&&WideSettings.top()==35&&WideSettings.controlsVisible(),"portrait persists after reinstalling UI state");
  WideLayout.configure(780,360);
  check(WideSettings.left()==40&&WideSettings.top()==55&&WideSettings.controlsVisible(),"landscape persists after reinstalling UI state");
  WideSettings.previewFor(true,99,-7);WideLayout.configure(360,780);
  check(WideSettings.left()==75&&WideSettings.top()==20,"invalid ratios clamped");
  check(saved.get("portrait_primary")==65&&saved.get("landscape_primary")==40,"preview does not persist a drag until release");
  System.out.println("TOTAL "+tests+" passed; production Settings/Layout classes, Android preference doubles");
 }
}
