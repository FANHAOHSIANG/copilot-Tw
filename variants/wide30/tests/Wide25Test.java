package com.navipilot.obf;
public final class Wide25Test {
 public static void main(String[] args) {
  check(WideStatusBorder.activeColor(true,false)==0xff66d9ff,"lateral only sky blue");
  check(WideStatusBorder.activeColor(true,true)==0xff52d584,"both active green");
  check(WideStatusBorder.activeColor(false,false)==0,"both off invisible");
  check(WideStatusBorder.activeColor(false,true)==0,"no lateral invisible");
  check(WideStatusBorder.activeColor(true,null)==0,"unknown longitudinal invisible");
  check(WideStatusBorder.activeColor(null,true)==0,"unknown lateral invisible");
  check(WideStatusBorder.activeColor("true",true)==0,"invalid flag invisible");
  System.out.println("PASS: C4 border state truth table and missing/invalid telemetry");
 }
 private static void check(boolean value,String reason){if(!value)throw new AssertionError(reason);}
}
