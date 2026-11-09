package com.navipilot.obf;

/** Same drawing coordinates are used by Android Canvas and the offline SVG layout check. */
public final class WideCameraFace {
 public interface Painter {
  void rect(float x,float y,float w,float h,float radius,int color);
  void circle(float x,float y,float r,float stroke,int color);
  void line(float x1,float y1,float x2,float y2,float stroke,int color);
  void text(String value,float x,float y,float size,int color,float maxWidth,boolean center);
 }
 public static final class Model {
  // 0 waiting, 1 fixed, 2 section entrance, 3 section active, 4 passed
  public int type,limit;public double distance,seconds,average,progress;public boolean demo,uncertain,roadMatched;
  public String badge="台灣未傳送",road="",state="",footer="",title="等待測速候選";
 }
 public static int color(Model m){return m.type==4?0xff52e2ba:m.type==3?0xff62d4ff:m.distance<=200&&m.type>0?0xffff687b:m.distance<=500&&m.type>0?0xffffc64d:0xff67b7ff;}
 public static void draw(Painter p,float w,float h,Model m,long now){
  int white=0xfff7fbff,muted=0xffbfd0e0,accent=color(m);float pad=12;
  p.rect(0,0,w,h,0,0xff0b1523);
  if(w<180||h<58){p.text("拖高測速面板",pad,30,18,white,w-pad*2,false);return;}
  float blink=(float)(.5+.5*Math.sin(now/1000.0*Math.PI*2));
  if(m.type==1)camera(p,pad,8,accent,blink);
  else if(m.type>=2)gate(p,pad,8,accent,blink);
  else camera(p,pad,8,0xff60768d,0);
  String title=m.demo?(m.type==3?"區間示範":"固定示範"):m.title;
  float tagW=Math.min(110,w*.31f);
  p.text(title,56,27,18,white,w-62-tagW,false);
  p.text(m.demo?"示範 · 不傳送":m.badge,w-tagW-6,25,12,m.demo?0xffc4a9ff:muted,tagW,false);
  if(h<150 || (m.type==3 && h<190)){
   float numberSize=Math.min(40,h*.36f),y=Math.min(h-22,72);
   p.text(m.limit>0&&!m.uncertain?String.valueOf(m.limit):"—",pad,y,numberSize,white,w*.22f,false);
   String value=m.type==0?"等待 GPS":m.type==4?"已通過":Math.round(m.distance)+" m";
   p.text(value,w*.28f,y,numberSize,accent,w*.68f-8,false);
   String bottom=m.type==3?"區間尚需 "+Math.round(m.seconds)+" 秒 · 距離估算":m.type==2?"距入口 · 直線距離":m.type==1?(m.roadMatched?"固定測速 · 沿道路距離":"候選 · 直線距離"):m.state;
   if(h>=115)p.text("km/h",pad,y+18,12,muted,w*.22f,false);
   if(m.type==3&&h>=155){
    p.text(Math.round(m.seconds)+" 秒",w*.28f,y+49,29,accent,w*.68f-8,false);
    p.text("速限通過時間尚餘 · 距離估算",pad,h-5,12,muted,w-24,false);
   }else p.text(bottom,pad,h-5,13,muted,w-24,false);
   return;
  }
  boolean section=m.type==3;
  float heroH=h-86,top=40;
  float radius=Math.min(51,Math.max(29,heroH*.40f));
  float cx=pad+radius,cy=top+heroH*.47f;
  p.circle(cx,cy,radius,0,white);p.circle(cx,cy,radius-3,5,m.uncertain?0xff8499ac:0xffed5268);
  p.text(m.limit>0&&!m.uncertain?String.valueOf(m.limit):"—",cx,cy+radius*.18f,radius*.98f,0xff101926,radius*1.75f,true);
  p.text("km/h",cx,cy+radius*.66f,Math.max(11,radius*.27f),0xff42566b,radius*1.8f,true);
  float x=cx+radius+18,room=w-x-pad;
  String distance=m.type==0?"—":m.type==4?"已通過":Math.round(m.distance)+" m";
  if(section){
   float size=Math.min(53,heroH*.38f);
   p.text(distance,x,top+heroH*.37f,size,white,room,false);
   p.text("估計剩餘距離",x,top+heroH*.37f+18,14,muted,room,false);
   p.text(Math.round(m.seconds)+" 秒",x,top+heroH*.83f,Math.min(43,heroH*.30f),accent,room,false);
   p.text("速限通過時間尚餘",x,top+heroH*.83f+17,13,muted,room,false);
  }else{
   p.text(distance,x,cy+8,Math.min(74,heroH*.68f),m.type==4?accent:white,room,false);
   p.text(m.type==2?"距區間入口 · 直線距離":m.type==4?"維持道路速限":m.roadMatched?"同路段 · 沿道路距離":"直線距離 · 道路待確認",x,cy+31,14,muted,room,false);
  }
  p.text(m.road.length()>0?m.road:m.state,pad,h-30,16,white,w-24,false);
  String state=section?String.format(java.util.Locale.TAIWAN,"GPS 均速估計 %.0f km/h · 秒數歸零仍需守速限",m.average):m.state;
  p.text(state,pad,h-10,13,muted,w-24,false);
  float progress=(float)Math.max(0,Math.min(1,m.progress));
  p.rect(pad,h-4,w-24,3,1,0xff24394d);p.rect(pad,h-4,(w-24)*progress,3,1,accent);
 }
 private static void camera(Painter p,float x,float y,int c,float pulse){
  p.rect(x,y+5,31,22,5,c);p.rect(x+5,y,13,7,2,c);p.circle(x+16,y+16,7,0,0xff0b1523);p.circle(x+16,y+16,3,0,0xfff7fbff);
  if(pulse>.35f){p.line(x+33,y+5,x+38,y+1,2,c);p.line(x+35,y+13,x+41,y+13,2,c);}
 }
 private static void gate(Painter p,float x,float y,int c,float pulse){
  p.line(x+2,y+28,x+2,y+3,3,c);p.line(x+33,y+28,x+33,y+3,3,c);p.line(x+2,y+3,x+33,y+3,3,c);
  p.rect(x+8,y+7,8,6,2,c);p.rect(x+23,y+7,8,6,2,c);p.line(x+17,y+15,x+17,y+26,2,c);
  if(pulse>.35f)p.line(x+10,y+23,x+24,y+23,2,c);
 }
 public static Model demo(int mode,long elapsed){
  Model m=new Model();m.demo=true;m.limit=60;m.road="示範道路 · 非實際測速資料";m.state="示範資料，不影響 GPS 或 Carrot";
  if(mode==1){double seconds=(elapsed%45000)/1000.0;m.type=1;m.title="固定測速";m.distance=Math.max(0,900-seconds*20);m.progress=1-m.distance/900;}
  else{double seconds=(elapsed%60000)/1000.0;m.type=3;m.title="區間測速";m.distance=Math.max(0,1000-seconds*15);m.seconds=Math.max(0,60-Math.floor(seconds));m.average=54;m.progress=1-m.distance/1000;}
  return m;
 }
}
