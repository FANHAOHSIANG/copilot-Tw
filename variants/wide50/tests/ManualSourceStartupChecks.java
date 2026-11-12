package com.navipilot.obf;
public final class ManualSourceStartupChecks {
 public static void main(String[] args) throws Exception {
  java.lang.reflect.Field field=WideAutoStart.class.getDeclaredField("gate");field.setAccessible(true);
  WideAutoStart.LaunchGate gate=(WideAutoStart.LaunchGate)field.get(null);
  gate.reset();WideAutoStart.manualSourceChange();
  if(!gate.shouldStart(true,true))throw new AssertionError("source selection cancelled GPS startup");
  if(gate.shouldStart(false,true))throw new AssertionError("disabled auto-start ignored");
  if(!gate.shouldRequest(true,false))throw new AssertionError("permission request lost after source selection");
  gate.completed=true;WideAutoStart.manualSourceChange();
  if(gate.shouldStart(true,true))throw new AssertionError("completed/manual stop restarted");
  System.out.println("PASS 4 manual-source/startup regression assertions; Android lifecycle not exercised");
 }
}
