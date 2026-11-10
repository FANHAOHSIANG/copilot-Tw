package com.navipilot.obf;
import android.app.Activity;
public class LifecycleTest {
 static void check(boolean ok,String why){if(!ok)throw new AssertionError(why);}
 public static void main(String[] args){
  Activity a=new Activity(); String scenario=args[0];
  if(scenario.equals("disabled")){ WideAutoStart.setEnabled(a,false); WideCamera.permission=true; WideAutoStart.attach(a); a.window.view.setFocus(true); check(WideCamera.starts==0&&!WideBridge.active,"disabled"); }
  else if(scenario.equals("permission")){
   WideAutoStart.attach(a); check(WideCamera.requests==0,"never request in background");
   a.window.view.setFocus(true); check(WideCamera.requests==1&&WideCamera.starts==0&&!WideBridge.active,"request permission");
   a.window.view.setFocus(false); a.window.view.setFocus(true); check(WideCamera.requests==1,"no repeated prompt");
   WideCamera.permission=true; a.window.view.setFocus(false); a.window.view.setFocus(true);
   check(WideCamera.starts==1&&WideBridge.active&&WideBridge.toggles==1,"grant starts GPS and Taiwan source");
   WideCamera.running=false; WideBridge.active=false; WideAutoStart.manualSourceChange();
   a.window.view.setFocus(false); a.window.view.setFocus(true);
   check(WideCamera.starts==1&&!WideBridge.active,"respect manual stop and source change");
  } else if(scenario.equals("failure")){
   WideCamera.permission=true; WideCamera.accepted=false; WideAutoStart.attach(a); a.window.view.setFocus(true);
   check(WideCamera.starts==1&&!WideBridge.active,"service failure must not enable transmission");
   WideCamera.accepted=true; a.window.view.setFocus(false); a.window.view.setFocus(true);
   check(WideCamera.starts==2&&WideBridge.active,"retry on visible resume");
  } else if(scenario.equals("relaunch")){
   WideCamera.permission=true; WideAutoStart.attach(a); a.window.view.setFocus(true); check(WideBridge.active,"first launch");
   a.finishing=true; a.application.callbacks.onActivityDestroyed(a); WideCamera.running=false; WideBridge.active=false;
   WideAutoStart.attach(a); a.finishing=false; a.window.view.setFocus(true);
   check(WideCamera.starts==2&&WideBridge.active,"next launch restarts after close");
  } else throw new AssertionError(scenario);
  System.out.println("PASS " + scenario);
 }
}
