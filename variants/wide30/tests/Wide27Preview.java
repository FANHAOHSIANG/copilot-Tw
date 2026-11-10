package com.navipilot.obf;
import java.io.PrintWriter;
import java.util.Locale;

/** Offline visual aid; not a substitute for Android rendering. */
public class Wide27Preview implements WideCameraFace.Painter {
 private final PrintWriter out;
 Wide27Preview(PrintWriter out,float w,float h){this.out=out;out.printf(Locale.US,"<svg xmlns='http://www.w3.org/2000/svg' width='%.0f' height='%.0f' viewBox='0 0 %.0f %.0f'>",w,h,w,h);}
 String hex(int c){return String.format("#%06x",c&0xffffff);}
 public void rect(float x,float y,float w,float h,float radius,int color){out.printf(Locale.US,"<rect x='%f' y='%f' width='%f' height='%f' rx='%f' fill='%s'/>",x,y,w,h,radius,hex(color));}
 public void circle(float x,float y,float r,float stroke,int color){out.printf(Locale.US,"<circle cx='%f' cy='%f' r='%f' fill='%s' stroke='%s' stroke-width='%f'/>",x,y,r,stroke>0?"none":hex(color),hex(color),stroke);}
 public void line(float x1,float y1,float x2,float y2,float stroke,int color){out.printf(Locale.US,"<line x1='%f' y1='%f' x2='%f' y2='%f' stroke='%s' stroke-width='%f'/>",x1,y1,x2,y2,hex(color),stroke);}
 public void text(String v,float x,float y,float size,int color,float maxWidth,boolean center){if(maxWidth<=0)return;out.printf(Locale.US,"<text x='%f' y='%f' font-family='Noto Sans CJK TC, sans-serif' font-weight='700' font-size='%f' fill='%s' text-anchor='%s'>%s</text>",x,y,size,hex(color),center?"middle":"start",v.replace("&","&amp;").replace("<","&lt;"));}
 public static void main(String[] args)throws Exception{
  float w=Float.parseFloat(args[0]),h=Float.parseFloat(args[1]);String state=args[2];
  WideCameraFace.Model m=new WideCameraFace.Model();m.speedKph=68;m.roadLimit=70;m.state="道路已確認";m.title="前方暫無測速";m.badge="台灣來源";
  if("nearby".equals(state)){m.type=1;m.roadLimit=0;m.speedKph=0;m.previewOnly=true;m.distance=163;m.title="附近測速點";m.state="方向未確認 · 直線距離";}
  if("confirmed".equals(state)){m.type=1;m.roadMatched=true;m.distance=238;m.limit=60;m.title="同路段測速";m.state="沿道路距離";}
  if("waiting".equals(state)){m.speedKph=Double.NaN;m.roadLimit=0;m.state="等待 GPS 定位";m.title="等待道路確認";}
  PrintWriter out=new PrintWriter(System.out);Wide27Preview p=new Wide27Preview(out,w,h);WideCameraFace.draw(p,w,h,m,0);out.print("</svg>");out.flush();
 }
}
