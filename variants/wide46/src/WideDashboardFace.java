package com.navipilot.obf;
import org.json.JSONObject;

/** Shared production painter: vehicle state above, camera/turn/enforcement reminders below. */
public final class WideDashboardFace {
    private static final int BG=0xff091320,CARD=0xff122238,INK=0xffedf5ff,MUTED=0xffa4b8ce,BLUE=0xff7ed6ff,AMBER=0xffffd075;
    private static String safe(String s) { return s == null ? "" : s; }
    private static String flag(String name,Boolean value) { return name+(value==null?" —":value?" 已接管":" 未接管"); }
    private static String distance(double d) { return Double.isFinite(d) && d >= 0 ? Math.round(d)+" m" : "—"; }
    private static boolean confirmed(WideEnforcementEngine.Alert e) { return e != null && e.level == WideEnforcementEngine.Level.AHEAD; }

    public static void render(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m,long now,boolean demo,int retainedLimit) {
        WideEnforcementEngine.Frame f = demo ? null : WideEnforcementRuntime.current();
        drawState(p,w,h,m,now,demo,retainedLimit,WideVehiclePanel.current(),demo?null:WideGoogleNav.guidance(),f==null?null:f.primary);
    }
    /** Also exercised by the host preview renderer with explicit, labelled demonstration data. */
    static void drawState(WideCameraFace.Painter p,float w,float h,WideCameraFace.Model m,long now,boolean demo,int retainedLimit,
                          WideVehiclePanel.State car,JSONObject turn,WideEnforcementEngine.Alert enforcement) {
        if (w <= 0 || h <= 0) return;
        WideEnforcementEngine.Alert e = enforcement != null && now <= enforcement.expiresElapsedMs ? enforcement : null;
        if (w < 230 || h < 280) {
            float strip = e != null && h >= 125 && w >= 160 ? 43 : 0;
            WideLiveCameraFace.render(p,w,h-strip,m,now,demo,retainedLimit);
            if (strip > 0) smallEnforcement(p,w,h-strip,strip,e);
            return;
        }
        boolean c4=!demo&&car!=null&&Double.isFinite(car.speed);
        double speed=demo?58:c4?car.speed:m.speedKph;
        float pad=10,top=h*.44f,gap=9,lower=top+gap,lowerH=h-lower-pad;
        p.rect(0,0,w,h,0,BG); p.rect(pad,pad,w-2*pad,top-pad,12,CARD);
        p.text("即時車況",22,30,13,INK,w*.43f,false);
        p.text(demo?"示意":c4?"C4 車速":"GPS 車速",w*.76f,30,11,BLUE,w*.4f,true);
        p.text(Double.isFinite(speed)?String.valueOf(Math.round(speed)):"—",24,top-44,Math.min(68,top*.5f),INK,w*.48f,false);
        p.text("km/h",24,top-28,11,MUTED,w*.3f,false);
        int currentLimit=WideCameraFace.visibleLimit(m),limit=currentLimit>0?currentLimit:retainedLimit;
        if(limit>0) {
            float r=Math.min(29,top*.25f),x=w*.79f,y=top*.52f;
            p.circle(x,y,r,0,0xfff9fbff); p.circle(x,y,r-2,4,0xfff36978);
            p.text(String.valueOf(limit),x,y+r*.3f,r,0xff172537,r*1.65f,true);
            if(currentLimit<=0)p.text("暫存速限",x,y+r+13,9,MUTED,r*2+20,true);
        }
        p.text(demo?"橫向 已接管 · 縱向 已接管":flag("橫向",car==null?null:car.lateral)+" · "+flag("縱向",car==null?null:car.longitudinal),22,top-13,11,MUTED,w-44,false);
        p.rect(pad,lower,w-2*pad,lowerH,12,CARD);
        boolean target=m.type>=1&&m.type<=3&&Double.isFinite(m.distance)&&m.distance>=0;
        boolean cameraPriority=target&&(m.type==3||m.distance<=1000);
        int turnDistance=turn==null?Integer.MAX_VALUE:turn.optInt("distance_m",Integer.MAX_VALUE);
        int mode=cameraPriority?1:turn!=null&&turnDistance<=200?2:confirmed(e)&&e.distanceMeters<=1000?3:turn!=null?2:target?1:e!=null?3:0;
        boolean secondary=e!=null&&mode!=3;
        float bodyH=lowerH-(secondary?43:0);
        String title,hero,detail,source;
        int color;
        if(mode==1) {
            title=safe(m.title); hero=distance(m.distance); color=AMBER;
            detail=m.type==3?"區間均速 "+Math.round(m.average)+" · 尚需 "+Math.round(m.seconds)+" 秒（估算）":m.limit>0?"測速限速 "+m.limit+" km/h":safe(m.state);
            source=m.previewOnly?"GPS 備援 · 道路未確認":m.roadMatched?"沿道路距離 · "+safe(m.road):"依目前 GPS 持續搜尋";
        } else if(mode==2) {
            title=turn.optString("main_text","下一個轉彎"); hero=turnDistance==Integer.MAX_VALUE?"—":distance(turnDistance); color=BLUE;
            detail=turn.optString("road_name",""); source="Google 導航資料";
        } else if(mode==3) {
            title=WideEnforcementLabels.level(e.level); hero=distance(e.distanceMeters); color=confirmed(e)?AMBER:BLUE;
            detail=WideEnforcementLabels.categories(e.categories);
            source=(e.alongRoad?"沿路距離 · ":"附近直線 · ")+e.location;
        } else {
            title="前方道路提醒"; hero="—"; color=MUTED;
            detail=safe(m.state); source="啟動 GPS 即可搜尋，不需設定目的地";
        }
        p.text(title,22,lower+23,14,INK,w-44,false);
        float baseline=lower+Math.max(54,Math.min(84,bodyH*.57f));
        p.text(hero,22,baseline,Math.max(22,Math.min(48,bodyH*.31f)),color,w-44,false);
        p.text(detail,22,lower+bodyH-26,11,MUTED,w-44,false);
        p.text(source,22,lower+bodyH-10,10,BLUE,w-44,false);
        if(secondary)smallEnforcement(p,w,lower+bodyH,43,e);
    }
    private static void smallEnforcement(WideCameraFace.Painter p,float w,float y,float h,WideEnforcementEngine.Alert e) {
        int color=confirmed(e)?AMBER:BLUE;
        p.rect(10,y,w-20,h,7,CARD);
        p.line(20,y+1,w-20,y+1,1,0xff30465b);
        String title=e.level==WideEnforcementEngine.Level.REFERENCE?"執法公告參考":
                confirmed(e)?"科技執法":e.alongRoad?"執法方向／條件待確認":"鄰近科技執法";
        p.text(title+" · "+distance(e.distanceMeters)+(e.alongRoad?" 沿路":" 直線"),20,y+17,11,color,w-40,false);
        p.text(WideEnforcementLabels.categories(e.categories)+" · "+e.location,20,y+34,10,MUTED,w-40,false);
    }
    private WideDashboardFace() { }
}
