package com.navipilot.obf;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.font.FontRenderContext;
import java.awt.font.TextLayout;
import java.awt.geom.Ellipse2D;
import java.awt.geom.Rectangle2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import javax.imageio.ImageIO;
import org.json.JSONArray;
import org.json.JSONObject;

/** Production drawState + production enforcement engine, synthetic inputs, approximate host fonts. */
public final class DashboardUiChecks {
    private static int checks;
    private static final long NOW=3000, WALL=Instant.parse("2026-11-12T04:00:00Z").toEpochMilli();
    private static final double LAT=25,LON=121;
    private static final String ROAD="示意大道";
    private static final Font FONT=new Font("Noto Sans CJK TC",Font.BOLD,12);
    private static final FontRenderContext FRC=new FontRenderContext(null,true,true);
    private static final JSONArray FINDINGS=new JSONArray(), CASES=new JSONArray();
    private static void check(boolean okay,String reason) {
        checks++; if(!okay) throw new AssertionError(reason);
    }
    private static double north(double meters){return LAT+meters/111320.0;}
    private static WideEnforcementEngine.Alert alert(Double bearing,double distance,String...categories)throws Exception {
        return alert(bearing,distance,bearing==null?WideEnforcementEngine.Level.DIRECTION_UNKNOWN:WideEnforcementEngine.Level.AHEAD,categories);
    }
    private static WideEnforcementEngine.Alert alert(Double bearing,double distance,WideEnforcementEngine.Level expected,String...categories)throws Exception {
        JSONObject record=new JSONObject().put("id","synthetic-ui-site").put("sourceId","synthetic-ui")
            .put("region","示意縣市").put("district","示意區")
            .put("location",ROAD+"與科技路口（示意資料，非實際執法點）")
            .put("categories",new JSONArray(Arrays.asList(categories)))
            .put("coordinates",new JSONArray().put(LON).put(north(200+distance)))
            .put("geometryRole","site").put("directionText",bearing==null?"":"南向北")
            .put("travelBearing",bearing==null?JSONObject.NULL:bearing)
            .put("status","announced").put("raw",new JSONObject());
        String catalog=new JSONObject().put("schemaVersion",1).put("snapshotDate","2026-11-12")
            .put("records",new JSONArray().put(record)).toString();
        WideEnforcementEngine engine=new WideEnforcementEngine(catalog);
        WideHcopRoad.Road road=new WideHcopRoad.Road();
        road.id="synthetic-ui-road";road.names=new String[]{ROAD};road.grade="0|no|no";
        road.dir=0;road.start=1;road.end=2;
        road.xy=new double[][]{{LON,north(0)},{LON,north(2200)}};
        WideHcopRoad.Data roads=new WideHcopRoad.Data();roads.roads.add(road);
        WideEnforcementEngine.Frame frame=null;
        for(int i=0;i<3;i++) {
            WideCameraEngine.Fix fix=new WideCameraEngine.Fix(north(180+10*i),LON,5,0,10,1000+1000*i,true,false);
            WideHcopRoad.Decision decision=new WideHcopRoad.Decision("synthetic confirmed road",fix.time);
            decision.road=road;decision.direction=1;decision.confirmed=true;
            frame=engine.update(fix,roads,decision,fix.time,WALL);
        }
        check(frame.primary!=null,"fixture is accepted by real enforcement engine");
        check(frame.primary.alongRoad==(expected!=WideEnforcementEngine.Level.REFERENCE),"fixture uses real along-road or reference assessment");
        check(Math.abs(frame.primary.distanceMeters-distance)<2,"fixture station distance remains physical");
        check(frame.primary.level==expected,"fixture level is decided by engine");
        return frame.primary;
    }
    private static WideCameraFace.Model model(boolean camera) {
        WideCameraFace.Model m=new WideCameraFace.Model();m.speedKph=57;m.distance=Double.NaN;
        m.title="前方道路提醒";m.state="沿目前道路持續搜尋";m.road=ROAD;
        if(camera){m.type=1;m.distance=480;m.limit=60;m.roadLimit=60;m.roadMatched=true;m.title="前方固定測速";}
        return m;
    }
    private static WideVehiclePanel.State car(double speed) {
        WideVehiclePanel.State car=new WideVehiclePanel.State();car.speed=speed;car.lateral=true;car.longitudinal=false;return car;
    }
    private static JSONObject turn(int distance)throws Exception {
        return new JSONObject().put("distance_m",distance).put("main_text","右轉，進入科技路")
            .put("road_name","科技路一段（示意目的地，不代表真實導航）");
    }
    private static final class Text {
        String raw,display;float x,y,size,maxWidth;boolean center,clipped;Rectangle2D bounds;
        JSONObject json()throws Exception {
            return new JSONObject().put("raw",raw).put("display",display).put("baseline",y).put("size",size)
                .put("x",x).put("max_width",maxWidth).put("center",center).put("ellipsized",clipped)
                .put("glyph_bounds",new JSONArray().put(bounds.getX()).put(bounds.getY()).put(bounds.getWidth()).put(bounds.getHeight()));
        }
    }
    private static final class Painter implements WideCameraFace.Painter {
        final int w,h;final BufferedImage image;final Graphics2D g;final StringBuilder svg=new StringBuilder();
        final List<Text> texts=new ArrayList<Text>();
        Painter(int w,int h) {
            this.w=w;this.h=h;image=new BufferedImage(w,h,BufferedImage.TYPE_INT_ARGB);g=image.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,RenderingHints.VALUE_ANTIALIAS_ON);
            g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
            g.setRenderingHint(RenderingHints.KEY_FRACTIONALMETRICS,RenderingHints.VALUE_FRACTIONALMETRICS_ON);
        }
        private static String n(double d){return String.format(Locale.ROOT,"%.3f",d);}
        private static String color(int c){return String.format(Locale.ROOT,"#%06x",c&0xffffff);}
        private static String esc(String s){return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");}
        public void rect(float x,float y,float width,float height,float r,int c) {
            check(width>=0&&height>=0,"rectangle has nonnegative size");
            g.setColor(new Color(c,true));g.fill(new RoundRectangle2D.Float(x,y,width,height,r*2,r*2));
            svg.append("<rect x=\"").append(n(x)).append("\" y=\"").append(n(y)).append("\" width=\"").append(n(width))
               .append("\" height=\"").append(n(height)).append("\" rx=\"").append(n(r)).append("\" fill=\"").append(color(c)).append("\"/>");
        }
        public void circle(float x,float y,float r,float stroke,int c) {
            check(r>=0,"circle has nonnegative radius");g.setColor(new Color(c,true));
            Ellipse2D shape=new Ellipse2D.Float(x-r,y-r,2*r,2*r);
            if(stroke>0){g.setStroke(new BasicStroke(stroke));g.draw(shape);}else g.fill(shape);
            svg.append("<circle cx=\"").append(n(x)).append("\" cy=\"").append(n(y)).append("\" r=\"").append(n(r))
               .append("\" fill=\"").append(stroke>0?"none":color(c)).append("\" stroke=\"").append(color(c))
               .append("\" stroke-width=\"").append(n(stroke)).append("\"/>");
        }
        public void line(float x1,float y1,float x2,float y2,float stroke,int c) {
            g.setColor(new Color(c,true));g.setStroke(new BasicStroke(stroke));g.draw(new java.awt.geom.Line2D.Float(x1,y1,x2,y2));
            svg.append("<line x1=\"").append(n(x1)).append("\" y1=\"").append(n(y1)).append("\" x2=\"").append(n(x2))
               .append("\" y2=\"").append(n(y2)).append("\" stroke=\"").append(color(c)).append("\" stroke-width=\"").append(n(stroke)).append("\"/>");
        }
        private static float width(String value,Font font){return value.isEmpty()?0:new TextLayout(value,font,FRC).getAdvance();}
        public void text(String raw,float x,float y,float size,int c,float maxWidth,boolean center) {
            if(maxWidth<=0||raw==null||raw.isEmpty())return;
            Font font=FONT.deriveFont(size);
            // Match the production Android painter's numeric shrink followed by END ellipsis.
            if(raw.matches("[0-9 .—]+(?:m|秒)?")) {
                float measured=width(raw,font);
                if(measured>maxWidth){size=Math.max(10,size*maxWidth/measured);font=FONT.deriveFont(size);}
            }
            String display=raw;
            if(width(display,font)>maxWidth) {
                int end=raw.length();
                while(end>0&&width(raw.substring(0,end)+"…",font)>maxWidth)end=raw.offsetByCodePoints(end,-1);
                display=width("…",font)<=maxWidth?raw.substring(0,end)+"…":"";
            }
            Text t=new Text();t.raw=raw;t.display=display;t.x=x;t.y=y;t.size=size;t.maxWidth=maxWidth;t.center=center;t.clipped=!display.equals(raw);
            float advance=width(display,font),left=center?x-advance/2:x;
            Rectangle2D relative=display.isEmpty()?new Rectangle2D.Double():new TextLayout(display,font,FRC).getBounds();
            t.bounds=new Rectangle2D.Double(left+relative.getX(),y+relative.getY(),relative.getWidth(),relative.getHeight());texts.add(t);
            check(advance<=maxWidth+.2,"text fitting obeys actual glyph advance allowance");
            g.setFont(font);g.setColor(new Color(c,true));g.drawString(display,left,y);
            svg.append("<text x=\"").append(n(x)).append("\" y=\"").append(n(y)).append("\" font-family=\"Noto Sans CJK TC,sans-serif\" font-weight=\"700\" font-size=\"")
               .append(n(size)).append("\" fill=\"").append(color(c)).append("\" text-anchor=\"").append(center?"middle":"start").append("\"><title>")
               .append(esc(raw)).append("</title>").append(esc(display)).append("</text>");
        }
        boolean has(String raw){for(Text t:texts)if(t.raw.equals(raw))return true;return false;}
        boolean contains(String part){for(Text t:texts)if(t.raw.contains(part))return true;return false;}
        Text named(String raw){for(Text t:texts)if(t.raw.equals(raw))return t;return null;}
        void inspect(String id)throws Exception {
            JSONArray overlaps=new JSONArray(),outside=new JSONArray(),clipped=new JSONArray(),details=new JSONArray();
            for(int i=0;i<texts.size();i++) {
                Text a=texts.get(i);details.put(a.json());if(a.clipped)clipped.put(a.raw);
                if(a.bounds.getMinX()<-.6||a.bounds.getMinY()<-.6||a.bounds.getMaxX()>w+.6||a.bounds.getMaxY()>h+.6)outside.put(a.json());
                for(int j=i+1;j<texts.size();j++) {
                    Text b=texts.get(j);Rectangle2D overlap=a.bounds.createIntersection(b.bounds);
                    if(overlap.getWidth()>1&&overlap.getHeight()>1)overlaps.put(new JSONObject().put("a",a.raw).put("b",b.raw)
                        .put("overlap_width",overlap.getWidth()).put("overlap_height",overlap.getHeight()));
                }
            }
            JSONObject result=new JSONObject().put("id",id).put("width",w).put("height",h).put("text",details)
                .put("overlaps",overlaps).put("outside",outside).put("ellipsized",clipped);CASES.put(result);
            if(overlaps.length()>0||outside.length()>0)FINDINGS.put(new JSONObject().put("id",id).put("overlaps",overlaps).put("outside",outside));
        }
        void save(Path dir,String id,String title)throws Exception {
            final int header=64,footer=42;
            String start="<svg xmlns=\"http://www.w3.org/2000/svg\" width=\""+w+"\" height=\""+(h+header+footer)+"\" viewBox=\"0 0 "+w+" "+(h+header+footer)+"\">";
            String top="<rect width=\"100%\" height=\"100%\" fill=\"#070d17\"/><text x=\"10\" y=\"20\" font-family=\"Noto Sans CJK TC,sans-serif\" font-size=\"12\" font-weight=\"700\" fill=\"#f4f8ff\">示意資料／同繪圖程式</text>"
                +"<text x=\"10\" y=\"41\" font-family=\"Noto Sans CJK TC,sans-serif\" font-size=\"10\" fill=\"#b5c6da\">"+esc(title)+" · "+w+"×"+h+"</text>"
                +"<text x=\"10\" y=\"57\" font-family=\"Noto Sans CJK TC,sans-serif\" font-size=\"9\" fill=\"#b5c6da\">右側車況＋提醒；非實機截圖</text>";
            String end="</g><text x=\"10\" y=\""+(h+header+19)+"\" font-family=\"Noto Sans CJK TC,sans-serif\" font-size=\"9\" fill=\"#b5c6da\">測試字型近似 Android；Alert 由真實引擎產生</text>"
                +"<text x=\"10\" y=\""+(h+header+34)+"\" font-family=\"Noto Sans CJK TC,sans-serif\" font-size=\"9\" fill=\"#b5c6da\">左側導航區與觸控流程不在此圖驗證範圍</text></svg>";
            Files.write(dir.resolve("ui-"+id+".svg"),(start+top+"<g transform=\"translate(0,"+header+")\">"+svg+end).getBytes(StandardCharsets.UTF_8));
            BufferedImage labelled=new BufferedImage(w,h+header+footer,BufferedImage.TYPE_INT_RGB);Graphics2D out=labelled.createGraphics();
            out.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
            out.setColor(new Color(0x070d17));out.fillRect(0,0,w,labelled.getHeight());out.drawImage(image,0,header,null);
            out.setColor(new Color(0xf4f8ff));out.setFont(FONT.deriveFont(12f));out.drawString("示意資料／同繪圖程式",10,20);
            out.setColor(new Color(0xb5c6da));out.setFont(FONT.deriveFont(10f));out.drawString(title+" · "+w+"×"+h,10,41);
            out.setFont(FONT.deriveFont(9f));out.drawString("右側車況＋提醒；非實機截圖",10,57);
            out.drawString("測試字型近似 Android；Alert 由真實引擎產生",10,h+header+19);
            out.drawString("左側導航區與觸控流程不在此圖驗證範圍",10,h+header+34);out.dispose();
            ImageIO.write(labelled,"png",dir.resolve("ui-"+id+".png").toFile());g.dispose();
        }
    }
    private static Painter render(int w,int h,WideCameraFace.Model m,WideVehiclePanel.State car,JSONObject turn,
                                  WideEnforcementEngine.Alert alert,long now,int retained) {
        Painter p=new Painter(w,h);WideDashboardFace.drawState(p,w,h,m,now,false,retained,car,turn,alert);return p;
    }
    private static void scenario(Path dir,String name,String title,int w,int h,WideCameraFace.Model m,JSONObject turn,
                                 WideEnforcementEngine.Alert alert)throws Exception {
        Painter p=render(w,h,m,car(108),turn,alert,NOW,0);
        check(p.has("即時車況")&&p.has("C4 車速"),"right top panel keeps car telemetry");
        check(p.has("108"),"three-digit vehicle speed not replaced by GPS fixture");
        if(name.startsWith("camera")) {
            check(p.has("前方固定測速")&&p.has("480 m"),"near camera keeps primary reminder");
            check(p.contains("科技執法 · 650 m"),"enforcement remains secondary alongside camera");
        }else if(name.startsWith("google")) {
            check(p.has("右轉，進入科技路")&&p.has("180 m"),"urgent Google turn keeps primary reminder");
            check(p.contains("科技執法 · 650 m"),"enforcement remains secondary alongside Google turn");
        }else if(name.startsWith("unknown")) {
            check(p.has("同路前方 · 方向待確認"),"unknown direction remains explicitly qualified");
            check(!p.has("前方科技執法"),"unknown direction does not become confirmed warning");
        }else {
            check(p.has("前方科技執法")&&p.has("650 m"),"enforcement-only gets primary reminder");
            check(!p.has("60"),"enforcement record does not fabricate a speed limit");
        }
        p.inspect(name);p.save(dir,name,title);
    }
    private static void contactSheet(Path dir)throws Exception {
        BufferedImage sheet=new BufferedImage(1532,1110,BufferedImage.TYPE_INT_RGB);Graphics2D g=sheet.createGraphics();
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
        g.setColor(new Color(0x050a12));g.fillRect(0,0,sheet.getWidth(),sheet.getHeight());
        g.setColor(new Color(0xeff6ff));g.setFont(FONT.deriveFont(22f));
        g.drawString("Wide46 右側儀表板｜示意資料／同繪圖程式",22,35);
        g.setColor(new Color(0xb5c6da));g.setFont(FONT.deriveFont(15f));
        g.drawString("上：寬右卡 360×440；下：手機窄卡 240×320。非實機截圖；左側導航區未在此圖驗證。",22,64);
        String[] names={"camera","enforcement","google","unknown"};
        for(int i=0;i<names.length;i++) {
            g.drawImage(ImageIO.read(dir.resolve("ui-"+names[i]+"-wide.png").toFile()),22+378*i,83,null);
            g.drawImage(ImageIO.read(dir.resolve("ui-"+names[i]+"-phone.png").toFile()),82+378*i,654,null);
        }
        g.dispose();ImageIO.write(sheet,"png",dir.resolve("ui-contact-sheet.png").toFile());
    }
    public static void main(String[] args)throws Exception {
        Path output=Paths.get(args[0]);Files.createDirectories(output);
        WideCameraFallback.value=new WideCameraFallback.Advisory();
        for(int[] size:new int[][]{{480,480},{320,360},{230,280}}){
            WideCameraFace.Model m=model(false);m.footer="GPS ±5 m · 0.5 秒前";
            Painter p=render(size[0],size[1],m,car(21),turn(1835),null,NOW,50);
            check(p.contains("方向待確認"),"advisory present beside Google");
            check(p.has("1835 m"),"Google turn distance preserved");
            for(Text t:p.texts)check(t.bounds.getMinY()>=0&&t.bounds.getMaxY()<=size[1],"text inside canvas");
            ImageIO.write(p.image,"png",output.resolve("preview-"+size[0]+".png").toFile());
        }
        WideCameraFace.Model m=model(true);Painter p=render(480,480,m,car(21),turn(180),null,NOW,50);
        check(p.has("480 m")&&!p.has("180 m"),"confirmed camera priority preserved");
        System.out.println("PASS "+checks+" painter checks (synthetic data; host typography)");
    }
}
