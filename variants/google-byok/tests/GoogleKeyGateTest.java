package com.navipilot.google;
public class GoogleKeyGateTest {
 public static void main(String[]args){
  final int[] calls={0};GoogleKeyGate g=new GoogleKeyGate();GoogleKeyGate.Installer install=k->{calls[0]++;};
  assert g.initialize("",install)==GoogleKeyGate.Result.DISABLED;
  assert calls[0]==0;
  assert g.initialize(" test-key ",install)==GoogleKeyGate.Result.INSTALLED;
  assert g.initialize("test-key",install)==GoogleKeyGate.Result.UNCHANGED;
  assert g.initialize("replacement",install)==GoogleKeyGate.Result.RESTART_REQUIRED;
  assert g.initialize("",install)==GoogleKeyGate.Result.RESTART_REQUIRED;
  assert calls[0]==1;
  GoogleKeyGate failed=new GoogleKeyGate();try{failed.initialize("test-key",k->{throw new IllegalStateException();});throw new AssertionError();}catch(IllegalStateException expected){}
  assert failed.initialize("test-key",install)==GoogleKeyGate.Result.INSTALLED;
  System.out.println("PASS 8 key lifecycle checks (synthetic keys; no Google calls)");
 }
}
