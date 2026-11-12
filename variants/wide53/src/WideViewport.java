package com.navipilot.obf;
/** Pure pixel geometry shared by rendering, fitting and regression tests. */
public final class WideViewport {
 public static int[] render(int width,int height,int density){
  if(width<2||height<2||density<=0)throw new IllegalArgumentException("Viewport not ready");
  double scale=Math.min(1.0,1280.0/Math.max(width,height));
  return new int[]{Math.max(2,(int)Math.round(width*scale)),Math.max(2,(int)Math.round(height*scale)),Math.max(120,(int)Math.round(density*scale))};
 }
 public static float[] fit(int sw,int sh,int bw,int bh){if(sw<1||sh<1||bw<1||bh<1)throw new IllegalArgumentException("Invalid surface");
  float scale=Math.min((float)sw/bw,(float)sh/bh),w=bw*scale,h=bh*scale;return new float[]{w,h,(sw-w)/2,(sh-h)/2};
 }
}
