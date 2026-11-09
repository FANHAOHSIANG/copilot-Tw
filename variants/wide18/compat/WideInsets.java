package com.navipilot.obf;

import android.app.Activity;
import android.graphics.Insets;
import android.graphics.Rect;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowInsets;

/** Protect the host once, consuming only the system/IME insets applied here. */
public final class WideInsets {
    public static void install(final Activity a,final ViewGroup root) {
        if(root==null)return;
        final int bars=WindowInsets.Type.systemBars()|WindowInsets.Type.displayCutout();
        final int mask=bars|WindowInsets.Type.ime();
        final int[] initial={root.getPaddingLeft(),root.getPaddingTop(),root.getPaddingRight(),root.getPaddingBottom()};
        root.setOnApplyWindowInsetsListener(new View.OnApplyWindowInsetsListener(){
            public WindowInsets onApplyWindowInsets(View v,WindowInsets insets){
                apply(a,root,insets.getInsets(mask),initial);
                return new WindowInsets.Builder(insets).setInsets(mask,Insets.NONE).setInsetsIgnoringVisibility(bars,Insets.NONE).build();
            }
        });
        root.addOnLayoutChangeListener(new View.OnLayoutChangeListener(){
            public void onLayoutChange(View v,int l,int t,int r,int b,int ol,int ot,int or,int ob){
                WindowInsets i=root.getRootWindowInsets();if(i!=null)apply(a,root,i.getInsets(mask),initial);
            }
        });
        root.requestApplyInsets();
    }
    private static void apply(Activity a,ViewGroup root,Insets i,int[] initial) {
        int[] loc=new int[2];root.getLocationInWindow(loc);
        Rect bounds=a.getWindowManager().getCurrentWindowMetrics().getBounds();
        int l=initial[0]+Math.max(0,i.left-loc[0]),t=initial[1]+Math.max(0,i.top-loc[1]);
        int r=initial[2]+Math.max(0,i.right-Math.max(0,bounds.width()-loc[0]-root.getWidth()));
        int b=initial[3]+Math.max(0,i.bottom-Math.max(0,bounds.height()-loc[1]-root.getHeight()));
        if(root.getPaddingLeft()!=l||root.getPaddingTop()!=t||root.getPaddingRight()!=r||root.getPaddingBottom()!=b)root.setPadding(l,t,r,b);
    }
}
