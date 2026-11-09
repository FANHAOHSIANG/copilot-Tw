package com.navipilot.obf;
import java.util.Random;
public final class GeometryTest {
    private static int checks;
    static void check(boolean ok,String what){checks++;if(!ok)throw new AssertionError(what);}
    static void near(float a,float b,String what){check(Math.abs(a-b)<.02,what+" "+a+" != "+b);}
    static void verify(float w,float h,int primary,int secondary,boolean shown){
        WideGeometry.Plan p=WideGeometry.plan(w,h,primary,secondary,shown);
        check(p.mapWidth>=0&&p.mapHeight>=0&&p.sideWidth>=0&&p.sideHeight>=0,"nonnegative");
        check(p.mapWidth<=p.width&&p.mapHeight<=p.height,"map fits");
        check(p.sideX+p.sideWidth<=p.width+.01&&p.sideY+p.sideHeight<=p.height+.01,"side fits");
        if(p.portrait){near(p.sideY+p.sideHeight,p.height,"vertical extent");near(p.sideWidth,p.width,"vertical width");check(p.sideY>=p.mapHeight,"vertical overlap");}
        else {near(p.sideX+p.sideWidth,p.width,"horizontal extent");near(p.sideHeight,p.height,"horizontal height");check(p.sideX>=p.mapWidth,"horizontal overlap");}
        check(p.shieldHeight>=0&&p.controlsHeight>=0,"secondary sizes");
        near(p.shieldHeight+p.controlsHeight+(shown?Math.min(6,p.sideHeight):0),p.sideHeight,"secondary extent");
        if(shown&&p.sideHeight>=258){check(p.shieldHeight>=95.99,"Shield minimum");check(p.controlsHeight>=155.99,"3 touch rows");}
        if(!shown)near(p.shieldHeight,p.sideHeight,"collapsed controls release space");
        if(w>=342&&!p.portrait){check(p.mapWidth>=167.99&&p.sideWidth>=167.99,"toolbar minimum");}
    }
    public static void main(String[] args){
        int[][] screens={{360,780},{412,915},{780,360},{1024,600},{1280,480},{1920,720},{800,1280},{600,600},{320,480},{480,240},{1,1},{0,0}};
        for(int[] s:screens)for(int p:new int[]{0,25,50,55,75,100})for(int t:new int[]{0,20,55,80,100})for(boolean visible:new boolean[]{false,true})verify(s[0],s[1],p,t,visible);
        Random r=new Random(16);
        for(int i=0;i<20000;i++)verify(r.nextInt(2401),r.nextInt(1801),r.nextInt(151)-25,r.nextInt(131)-15,r.nextBoolean());
        check(WideGeometry.compact(780,360,50),"phone landscape compact");
        check(WideGeometry.compact(360,780,55),"phone portrait compact");
        check(!WideGeometry.compact(1280,480,50),"car wide expanded");
        check(!WideGeometry.reconnect(true,true,9000,1000,0,true),"8s freshness boundary");
        check(WideGeometry.reconnect(true,true,9001,1000,0,true),"8s reconnect preserved");
        System.out.println("PASS "+checks+" geometry/freshness checks, 12 screen sizes + 20,000 randomized layouts");
    }
}
