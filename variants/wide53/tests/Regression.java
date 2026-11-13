package com.navipilot.obf;
public final class Regression {
 static int count;static void check(boolean x,String message){count++;if(!x)throw new AssertionError(message);}
 public static void main(String[] args){
  // Phone/vehicle portrait, landscape, splitter drag and restored old buffers.
  for(int[] view:new int[][]{{1080,2400},{2400,1080},{1920,720},{800,480},{720,1280},{360,320},{320,180}}){
   int[] s=WideViewport.render(view[0],view[1],320);check(Math.max(s[0],s[1])<=1280,"pixel cap");
   check(Math.abs((double)s[0]/s[1]-(double)view[0]/view[1])<.006,"render aspect");
   float[] f=WideViewport.fit(view[0],view[1],1280,720);
   check(f[0]<=view[0]+.01&&f[1]<=view[1]+.01,"fit bounds");check(Math.abs(f[0]/f[1]-1280f/720)<.001,"no distortion");
   check(Math.abs((f[2]+f[0]/2)-view[0]/2f)<.01,"touch center x");check(Math.abs((f[3]+f[1]/2)-view[1]/2f)<.01,"touch center y");
  }
  WideReconnectPolicy p=new WideReconnectPolicy();
  check(p.decide(0,true,true,true,false,true,true)==2,"ready service connects without opening manager");
  check(p.decide(1000,true,true,true,false,true,true)==0,"no duplicate starts");
  check(p.decide(6000,true,true,false,false,true,true)==0,"no authorization bypass");
  check(p.decide(6000,false,true,true,false,true,true)==0,"no background launch");
  check(p.decide(6000,true,true,true,false,false,true)==0,"wait for start callback");
  for(int i=1;i<5;i++)check(p.decide(6000*i,true,true,true,false,true,true)==2,"bounded retry");
  check(p.decide(40000,true,true,true,false,true,true)==0,"stop repeated failure");
  check(p.decide(41000,true,true,true,true,true,true)==0,"connected is idle");
  check(p.decide(42000,true,true,true,false,true,true)==2,"binder lost can retry");
  p=new WideReconnectPolicy();check(p.decide(0,true,false,false,false,true,true)==1,"open selected manager once");
  check(p.decide(6000,true,false,false,false,true,true)==0,"do not bounce back to manager");
  check(p.decide(7000,true,true,true,false,true,true)==2,"delayed service arrival auto binds");
  p=new WideReconnectPolicy();check(p.decide(0,true,false,false,false,true,false)==0,"respect auto manager off");
  System.out.println("PASS "+count+" viewport, coordinate and lifecycle assertions");
 }
}
