package com.navipilot.google;
/** Process-wide gate: never hot-swaps a Navigation SDK key. */
public final class GoogleKeyGate {
 public interface Installer { void install(String key); }
 public enum Result { DISABLED, INSTALLED, UNCHANGED, RESTART_REQUIRED }
 private String installed;
 public synchronized Result initialize(String key,Installer installer){
  String next=key==null?"":key.trim();
  if(installed!=null)return installed.equals(next)?Result.UNCHANGED:Result.RESTART_REQUIRED;
  if(next.isEmpty())return Result.DISABLED;
  installer.install(next); // On failure leave gate unset; do not log the key or exception text.
  installed=next;return Result.INSTALLED;
 }
}
