package com.navipilot.obf;
import java.io.PrintWriter;

/** Renders the live layout with sample data for offline visual review. */
public final class Wide29Preview {
 public static void main(String[] args)throws Exception{
  float w=Float.parseFloat(args[0]),h=Float.parseFloat(args[1]);String state=args[2];
  WideCameraFace.Model m=new WideCameraFace.Model();m.speedKph=52;m.roadLimit=60;m.limit=60;
  m.type=1;m.roadMatched=true;m.distance=args.length>3?Double.parseDouble(args[3]):466;
  m.title="同路段固定測速";m.state="已配對";m.footer="GPS ±10 m · 0.3 秒前 · 52 km/h";m.badge="最近已接收";
  if("nearby".equals(state)){m.roadLimit=0;m.limit=0;m.roadMatched=false;m.previewOnly=true;m.distance=163;
   m.title="附近測速點";m.state="方向未確認 · 直線距離";m.badge="僅提醒";}
  if("waiting".equals(state)){m.speedKph=Double.NaN;m.roadLimit=0;m.limit=0;m.type=0;m.roadMatched=false;
   m.title="等待 GPS 定位";m.state="請開啟車機的位置服務";m.footer="GPS 搜尋中";m.badge="台灣待回報";}
  PrintWriter out=new PrintWriter(System.out);Wide27Preview painter=new Wide27Preview(out,w,h);
  WideLiveCameraFace.render(painter,w,h,m,10000,false);out.print("</svg>");out.flush();
 }
}
