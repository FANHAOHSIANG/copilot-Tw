package com.navipilot.obf;
/** Automatic service binding never requests permission or repeatedly opens a manager. */
public final class WideReconnectPolicy {
 public static final int WAIT=0,OPEN_MANAGER=1,CONNECT=2;
 private boolean managerOpened,wasReady;private int attempts;private long lastAttempt=-5001;
 public int attempts(){return attempts;}
 public void retry(){attempts=0;lastAttempt=-5001;}
 public int decide(long now,boolean foreground,boolean service,boolean authorized,boolean projected,boolean callback,boolean auto){
  if(!foreground)return WAIT;
  if(service!=wasReady){retry();wasReady=service;}
  if(projected){retry();return WAIT;}
  if(service){if(authorized&&callback&&attempts<5&&now-lastAttempt>=5000){lastAttempt=now;attempts++;return CONNECT;}}
  else if(auto&&!managerOpened){managerOpened=true;return OPEN_MANAGER;}
  return WAIT;
 }
}
