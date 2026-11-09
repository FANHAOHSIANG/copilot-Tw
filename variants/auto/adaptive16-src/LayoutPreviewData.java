package com.navipilot.obf;
import java.util.Locale;
public final class LayoutPreviewData {
 public static void main(String[] args){
  int[][] cases={{1280,480,50,0,1},{780,360,50,0,0},{780,360,50,0,1},{360,780,55,0,0},{360,780,55,0,1},{800,1280,65,35,1}};
  System.out.println("[");
  for(int i=0;i<cases.length;i++){
   int[] c=cases[i];WideGeometry.Plan p=WideGeometry.plan(c[0],c[1],c[2],c[3],c[4]==1);
   System.out.printf(Locale.US,"{\"width\":%.2f,\"height\":%.2f,\"mapWidth\":%.2f,\"mapHeight\":%.2f,\"sideX\":%.2f,\"sideY\":%.2f,\"sideWidth\":%.2f,\"sideHeight\":%.2f,\"shieldHeight\":%.2f,\"controlsHeight\":%.2f,\"controls\":%s,\"portrait\":%s}%s%n",p.width,p.height,p.mapWidth,p.mapHeight,p.sideX,p.sideY,p.sideWidth,p.sideHeight,p.shieldHeight,p.controlsHeight,p.controls,p.portrait,i+1==cases.length?"":",");
  }
  System.out.println("]");
 }
}
