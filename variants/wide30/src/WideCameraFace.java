package com.navipilot.obf;

/** One layout for the live fixed-camera panel and the simulated preview. */
public final class WideCameraFace {
 public interface Painter {
  void rect(float x,float y,float w,float h,float radius,int color);
  void circle(float x,float y,float r,float stroke,int color);
  void line(float x1,float y1,float x2,float y2,float stroke,int color);
  void text(String value,float x,float y,float size,int color,float maxWidth,boolean center);
 }
 public static final class Model {
  public int type,limit,roadLimit;public double distance,seconds,average,progress;
  public double speedKph=Double.NaN;
  public boolean demo,uncertain,roadMatched,previewOnly;
  public String badge="台灣未傳送",road="",state="",footer="",title="等待測速候選";
 }
 public static int color(Model m){return m.type==4?0xff52e2ba:m.type==3?0xff62d4ff:m.distance<=200&&m.type>0?0xffff687b:m.distance<=500&&m.type>0?0xffffc64d:0xff67b7ff;}
 public static float warningStrength(Model model) {
  if ((model.type != 1 && model.type != 2) || model.uncertain
      || (!model.demo && !model.roadMatched && !model.previewOnly) || !Double.isFinite(model.distance)
      || model.distance < 0) return 0f;
  return model.distance > 500.0 ? 0f : (float) (0.14 + 0.86 * (1.0 - model.distance / 500.0));
 }
 static double flashPeriodMs(Model model) {
  return 1200.0 - 800.0 * Math.max(0.0, 1.0 - model.distance / 500.0);
 }
 public static int visibleLimit(Model m) {
  if (m.roadLimit>0) return m.roadLimit;
  return m.roadMatched && !m.uncertain && m.limit>0 ? m.limit : 0;
 }
 static boolean hasDistance(Model m){
  return (m.type==1||m.type==2||m.type==3) && Double.isFinite(m.distance) && m.distance>=0;
 }
 /** 500 m: 1x; 0 m: 1.65x. Rendering also respects the available height. */
 public static float distanceEmphasis(Model m){
  if(!hasDistance(m)||m.type==3)return 1f;
  double near=Math.max(0,Math.min(1,(500.0-m.distance)/500.0));
  return (float)(1.0+0.65*near);
 }
 private static float distanceSize(Model m,float height){
  float base=Math.max(14f,Math.min(36f,height*.45f));
  float cap=Math.max(base,height*.75f);
  return Math.min(cap,base*distanceEmphasis(m));
 }
 private static String speed(Model m){return Double.isFinite(m.speedKph)?String.valueOf(Math.round(m.speedKph)):"—";}
 private static String title(Model m){
  if(m.demo)return m.type==3?"區間示範":"固定測速示範";
  return m.title==null||m.title.length()==0?"等待測速資訊":m.title;
 }
 private static String detail(Model m){
  if(m.type==3)return "尚需 "+Math.round(m.seconds)+" 秒 · 均速 "+Math.round(m.average)+" · 估算";
  if(m.roadMatched&&m.limit>0)return "測速限速 "+m.limit+" · 沿道路距離";
  if(m.state!=null&&m.state.length()>0)return m.state;
  return "等待 GPS 與道路資料";
 }
 public static void draw(Painter p,float w,float h,Model m,long now){
  int white=0xfff7fbff,muted=0xff94a9bd,accent=color(m);
  p.rect(0,0,w,h,0,0xff0b1422);
  if(w<=0||h<=0)return;
  final float pad=9;
  boolean distance=hasDistance(m);
  int limit=visibleLimit(m);

  // Narrow split-screen panes must not drop the real camera distance.
  if(w<180||h<105){
   float speedRoom=Math.max(24,w*.25f-7);
   p.text(speed(m),pad,Math.min(32,h*.45f),Math.max(14,Math.min(24,h*.33f)),white,speedRoom,false);
   if(h>=48)p.text("GPS",pad,Math.min(h-5,47),9,muted,speedRoom,false);
   if(limit>0&&w>90){
    float r=Math.max(8,Math.min(15,Math.min(w*.09f,h*.18f)));
    speedSign(p,w*.40f,Math.max(r+4,Math.min(h*.37f,27)),r,limit);
   }
   if(distance){
    float x=w*.58f,room=Math.max(20,w-x-pad),height=Math.max(22,Math.min(44,h*.60f));
    p.text(Math.round(m.distance)+" m",x,Math.min(h-17,Math.max(25,h*.54f)),distanceSize(m,height),accent,room,false);
    if(h>=54)p.text(m.previewOnly?"附近 · 未確認":title(m),pad,h-6,10,m.previewOnly?0xffffc67a:muted,w-pad*2,false);
   }else if(h>=54){
    String state=m.state==null||m.state.length()==0?title(m):m.state;
    p.text(state,pad,h-6,10,muted,w-pad*2,false);
   }
   return;
  }

  p.text(m.demo?"示範速度":"即時時速 · GPS",pad,17,11,muted,w*.42f,false);
  if(w>=250)p.text(m.demo?"示範 · 不傳送":m.badge,w*.62f,17,10,m.demo?0xffb9a7ff:muted,w*.34f,false);
  float alertHeight=h>=155?50:38;
  float alertTop=h-alertHeight-7;
  float heroTop=24,heroHeight=Math.max(30,alertTop-heroTop-4);
  float speedRoom=Math.max(28,w*.25f-pad);
  float speedSize=Math.max(20,Math.min(49,heroHeight*.59f));
  float speedY=Math.min(heroTop+heroHeight*.68f,heroTop+heroHeight-11);
  p.text(speed(m),pad,speedY,speedSize,white,speedRoom,false);
  p.text("km/h",pad,heroTop+heroHeight-1,10,muted,speedRoom,false);
  float limitX=distance?w*.41f:w*.57f;
  float radius=Math.max(11,Math.min(38,Math.min(w*.12f,(heroHeight-16)/2)));
  float limitY=heroTop+heroHeight*.43f;
  if(limit>0){
   speedSign(p,limitX,limitY,radius,limit);
   p.text(m.roadLimit>0?"道路速限":"測速速限",limitX,Math.min(alertTop-3,limitY+radius+12),9,muted,radius*2+30,true);
  }
  if(distance){
   float x=limit>0?Math.max(w*.57f,limitX+radius+8):w*.48f;
   float room=Math.max(20,w-x-pad);
   p.text(Math.round(m.distance)+" m",x,heroTop+heroHeight*.66f,distanceSize(m,heroHeight),accent,room,false);
   p.text(m.previewOnly?"附近直線距離":"距測速",x,Math.min(alertTop-3,heroTop+heroHeight-2),10,muted,room,false);
  }
  p.rect(pad,alertTop,w-pad*2,alertHeight,8,0xff172538);
  p.text(title(m),pad+8,alertTop+15,12,white,w-pad*2-16,false);
  p.text(detail(m),pad+8,alertTop+(alertHeight>=50?35:30),10,m.previewOnly?0xffffc67a:muted,w-pad*2-16,false);
 }
 private static void speedSign(Painter p,float x,float y,float r,int value){
  p.circle(x,y,r,0,0xfff9fbff);p.circle(x,y,Math.max(1,r-2.5f),Math.min(4,r*.3f),0xffef5264);
  p.text(String.valueOf(value),x,y+r*.29f,Math.max(10,r*.95f),0xff111a25,r*1.7f,true);
 }
 public static Model demo(int mode,long elapsed){
  Model m=new Model();m.demo=true;m.limit=60;m.roadLimit=60;m.speedKph=52;m.road="示範道路";m.state="示範資料，不影響 GPS 或 Carrot";
  if(mode==1){double seconds=(elapsed%16000)/1000.0;m.type=1;m.title="測速示範";m.roadMatched=true;m.distance=Math.max(0,560-seconds*38);m.progress=1-m.distance/560;}
  else{double seconds=(elapsed%60000)/1000.0;m.type=3;m.title="區間示範";m.distance=Math.max(0,1000-seconds*15);m.seconds=Math.max(0,60-Math.floor(seconds));m.average=54;m.progress=1-m.distance/1000;}
  return m;
 }
}
