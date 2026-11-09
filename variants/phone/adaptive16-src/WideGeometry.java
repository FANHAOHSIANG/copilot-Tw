package com.navipilot.obf;

/** Pure dp geometry shared by the Compose anchors, native surfaces and drag handles. */
public final class WideGeometry {
    public static final float GAP=6f;
    public static int percent(int value) { return Math.max(25,Math.min(75,value)); }
    private static float finite(float n) { return Float.isNaN(n)||Float.isInfinite(n)?0:Math.max(0,n); }
    private static float bounded(float value,float available,float firstMin,float secondMin) {
        available=finite(available);
        float scale=Math.min(1f,available/Math.max(1,firstMin+secondMin));
        return Math.max(firstMin*scale,Math.min(available-secondMin*scale,value));
    }
    public static float left(float width,int percent) {
        float space=Math.max(0,finite(width)-GAP);
        return bounded(space*percent(percent)/100f,space,168,168);
    }
    public static float right(float width,int percent) { return Math.max(0,finite(width)-GAP)-left(width,percent); }
    public static float upper(float width,float height,int left,int top) {
        float space=Math.max(0,finite(height)-GAP);
        float desired=top==0?Math.max(144,right(width,left)/1.7f):space*Math.max(20,Math.min(80,top))/100f;
        return bounded(desired,space,96,156);
    }
    public static boolean portrait(float width,float height) { return height>=width; }
    public static boolean compact(float width,float height,int primary) {
        return portrait(width,height)||width<840f||height<400f||right(width,primary)<300f;
    }
    public static final class Plan {
        public final boolean portrait,compact,controls;
        public final float width,height,mapWidth,mapHeight,sideX,sideY,sideWidth,sideHeight,shieldHeight,controlsHeight;
        Plan(float w,float h,int primary,int secondary,boolean shown) {
            width=finite(w);height=finite(h);portrait=portrait(width,height);
            compact=compact(width,height,primary);controls=shown;
            if(portrait) {
                float space=Math.max(0,height-GAP);
                mapHeight=bounded(space*percent(primary)/100f,space,160,shown?258:144);
                mapWidth=width;sideX=0;sideY=mapHeight+Math.min(GAP,height);
                sideWidth=width;sideHeight=Math.max(0,height-sideY);
            } else {
                mapWidth=left(width,primary);mapHeight=height;
                sideX=mapWidth+Math.min(GAP,width);sideY=0;
                sideWidth=Math.max(0,width-sideX);sideHeight=height;
            }
            if(shown) {
                float space=Math.max(0,sideHeight-GAP);
                float desired=secondary==0?(compact?space-156:Math.max(144,sideWidth/1.7f)):space*Math.max(20,Math.min(80,secondary))/100f;
                shieldHeight=bounded(desired,space,96,156);
                controlsHeight=Math.max(0,space-shieldHeight);
            } else {shieldHeight=sideHeight;controlsHeight=0;}
        }
    }
    public static Plan plan(float width,float height,int primary,int secondary,boolean controls) {return new Plan(width,height,primary,secondary,controls);}
    public static boolean reconnect(boolean active,boolean socket,long now,long accepted,long started,boolean hello) {
        if(!active||!socket)return false;
        long latest=Math.max(accepted,started);
        return latest>0&&now>=latest&&now-latest>(hello?8000L:12000L);
    }
}
