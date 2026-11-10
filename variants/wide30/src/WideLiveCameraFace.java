package com.navipilot.obf;

/** Live dashboard. Demo rendering remains on the original independent preview path. */
public final class WideLiveCameraFace {
 private static final int BG=0xff0a1524, SURFACE=0xff17283c, EDGE=0xff304b64;
 private static final int WHITE=0xfff6fbff, MUTED=0xffa8bacb, BLUE=0xff70c9ec;
 private static final int AMBER=0xffffc34b, RED=0xffff6575;

 public static void render(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m,long now,boolean demo){
  if(demo){WideCameraFace.draw(p,w,h,m,now);return;}
  draw(p,w,h,m);
 }
 private static boolean hasDistance(WideCameraFace.Model m){
  return (m.type==1||m.type==2||m.type==3)&&Double.isFinite(m.distance)&&m.distance>=0;
 }
 private static String speed(WideCameraFace.Model m){return Double.isFinite(m.speedKph)?String.valueOf(Math.round(m.speedKph)):"—";}
 private static String distance(WideCameraFace.Model m){return hasDistance(m)?Math.round(m.distance)+" m":"—";}
 private static int distanceColor(WideCameraFace.Model m){return hasDistance(m)&&m.distance<=200?RED:hasDistance(m)?AMBER:MUTED;}
 private static String title(WideCameraFace.Model m){
  String t=m.title==null||m.title.length()==0?"等待測速資料":m.title;
  return m.previewOnly?"未確認 · "+t:t;
 }
 private static String state(WideCameraFace.Model m){
  if(m.previewOnly)return m.state==null||m.state.length()==0?"道路及方向未確認":m.state;
  if(m.roadMatched&&m.limit>0)return "測速限速 "+m.limit+" km/h · 沿道路距離";
  return m.state==null||m.state.length()==0?"等待道路資料":m.state;
 }
 private static String gps(WideCameraFace.Model m){return m.footer==null||m.footer.length()==0?"等待 GPS 定位":m.footer;}
 private static float distanceFont(WideCameraFace.Model m,float heroHeight){
  float base=Math.max(13,Math.min(42,heroHeight*.38f));
  return Math.min(Math.max(base,heroHeight*.67f),base*WideCameraFace.distanceEmphasis(m));
 }
 private static void sign(WideCameraFace.Painter p,float x,float y,float radius,int value){
  p.circle(x,y,radius,0,WHITE);
  p.circle(x,y,Math.max(1,radius-2.2f),Math.min(4,Math.max(2,radius*.12f)),0xfff05b6a);
  p.text(String.valueOf(value),x,y+radius*.30f,Math.max(10,radius*.94f),0xff182231,radius*1.7f,true);
 }

 private static void drawCompact(WideCameraFace.Painter p, float w, float h, WideCameraFace.Model m, int limit) {
  float footer = h >= 44 ? 16 : 0;
  float hero = h - footer;
  boolean labels = hero >= 31;
  float speedX = w * .23f;
  float distanceX = w * .79f;
  float baseline = hero * (labels ? .64f : .78f);
  float number = Math.max(10, Math.min(38, hero * .50f));
  p.text(speed(m), speedX, baseline, number, WHITE, w * .25f, true);
  if (limit > 0) {
   float radius = Math.max(5, Math.min(20, Math.min(w * .10f, hero * .26f)));
   sign(p, w * .50f, hero * .43f, radius, limit);
  } else if (labels) {
   p.text("速限 —", w * .50f, baseline, 9, MUTED, w * .25f, true);
  }
  p.text(distance(m), distanceX, baseline, distanceFont(m, hero), distanceColor(m), w * .35f, true);
  if (labels) {
   p.text("GPS km/h", speedX, hero - 2, 8, MUTED, w * .28f, true);
   String label = hasDistance(m) ? (m.previewOnly ? "附近直線距離" : "距測速點") : "等待測速點";
   p.text(label, distanceX, hero - 2, 8, MUTED, w * .33f, true);
  }
  if (footer > 0 && w > 20) {
   p.rect(5, h - footer, w - 10, footer - 2, 4, SURFACE);
   String info = m.previewOnly ? "未確認 · " + gps(m) : gps(m);
   if (!hasDistance(m)) info += " · " + state(m);
   p.text(info, 10, h - 5, 9, m.previewOnly ? 0xffffc884 : BLUE, w - 20, false);
  }
 }

 private static void draw(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m){
  if(w<=0||h<=0)return;
  p.rect(0,0,w,h,0,BG);
  int limit=WideCameraFace.visibleLimit(m), color=distanceColor(m);
  boolean target=hasDistance(m);
  if(w<185||h<120){
   drawCompact(p,w,h,m,limit);
   return;
  }

  p.rect(10,9,4,11,2,BLUE);
  p.text("台灣測速 · 即時",21,18,11,WHITE,w*.38f,false);
  if(m.badge!=null&&w>=240)p.text(m.badge,w*.70f,18,10,MUTED,w*.27f,false);
  p.line(10,23,w-10,23,1,EDGE);
  float footerHeight=h>=175?61:40,footerTop=h-footerHeight-6;
  float heroTop=27,hero=Math.max(30,footerTop-heroTop-4);
  float speedX=w*.22f,limitX=w*.50f,distanceX=w*.79f;
  float baseline=heroTop+hero*.67f;
  p.text(speed(m),speedX,baseline,Math.max(19,Math.min(64,hero*.60f)),WHITE,w*.26f,true);
  p.text("GPS km/h",speedX,heroTop+hero-1,10,MUTED,w*.28f,true);
  if(limit>0){
   float radius=Math.max(10,Math.min(40,Math.min(w*.11f,(hero-17)*.38f)));
   float cy=heroTop+hero*.41f;sign(p,limitX,cy,radius,limit);
   p.text(m.roadLimit>0?"道路速限":"測速速限",limitX,Math.min(footerTop-3,cy+radius+12),9,MUTED,w*.25f,true);
  }else p.text("速限未取得",limitX,heroTop+hero*.50f,10,MUTED,w*.25f,true);
  p.text(distance(m),distanceX,baseline,distanceFont(m,hero),color,w*.34f,true);
  p.text(target?(m.previewOnly?"附近直線距離":"距測速點"):"等待測速點",distanceX,heroTop+hero-1,10,MUTED,w*.33f,true);
  p.rect(8,footerTop,w-16,footerHeight,8,SURFACE);
  p.rect(8,footerTop,3,footerHeight,1,BLUE);
  String headline=footerHeight<60&&!target?state(m):title(m);
  p.text(headline,18,footerTop+15,12,WHITE,w-36,false);
  if(footerHeight>=60){
   p.text(state(m),18,footerTop+33,10,m.previewOnly?0xffffc884:MUTED,w-36,false);
   p.text(gps(m),18,footerTop+51,10,BLUE,w-36,false);
  }else{
   p.text(gps(m),18,footerTop+31,10,BLUE,w-36,false);
  }
 }
}
