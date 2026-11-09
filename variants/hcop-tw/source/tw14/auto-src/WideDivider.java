package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewParent;

/** Touch target sits inside each pane so settings dialogs and other screens remain above it. */
public final class WideDivider extends View {
    private static boolean dragging;
    private final boolean horizontal;
    private final Paint paint = new Paint(3);
    private float down, usable, initialUpper;
    private int initialLeft, initialTop;
    private boolean tracking;
    public static boolean isDragging() { return dragging; }
    public WideDivider(Context c, boolean horizontal) {
        super(c); this.horizontal=horizontal;
        setContentDescription(horizontal ? "拖曳調整右上與右下比例" : "拖曳調整左右畫面比例");
        setClickable(true);
    }
    private float dp(float x) {return x*getResources().getDisplayMetrics().density;}
    @Override protected void onDraw(Canvas c) {
        super.onDraw(c); paint.setColor(0xcc6d859e);
        float w=getWidth(),h=getHeight();
        if(horizontal) c.drawRoundRect(new RectF(w/2-dp(24),h/2-dp(2),w/2+dp(24),h/2+dp(2)),dp(2),dp(2),paint);
        else c.drawRoundRect(new RectF(w/2-dp(2),h/2-dp(24),w/2+dp(2),h/2+dp(24)),dp(2),dp(2),paint);
    }
    private Activity activity(){Context c=getContext();while(c instanceof ContextWrapper){if(c instanceof Activity)return (Activity)c;c=((ContextWrapper)c).getBaseContext();}return null;}
    @Override public boolean onTouchEvent(MotionEvent e) {
        switch(e.getActionMasked()) {
        case MotionEvent.ACTION_DOWN:
            if(!WideLayout.active || dragging) return false;
            down=horizontal?e.getRawY():e.getRawX();initialLeft=WideSettings.left();initialTop=WideSettings.top();
            float width=Math.max(0,WideLayout.pageWidth-12f),height=Math.max(0,WideLayout.pageHeight-12f);
            usable=dp(Math.max(1,(horizontal?height:width)-6f));
            initialUpper=dp(WideGeometry.upper(width,height,initialLeft,initialTop));
            tracking=true;dragging=true;ViewParent parent=getParent();if(parent!=null)parent.requestDisallowInterceptTouchEvent(true);return true;
        case MotionEvent.ACTION_MOVE:
            if(!tracking)return false;
            float delta=(horizontal?e.getRawY():e.getRawX())-down;
            int left=horizontal?initialLeft:Math.round(initialLeft+100f*delta/usable);
            int top=horizontal?Math.round(100f*(initialUpper+delta)/usable):initialTop;
            WideSettings.preview(left,top);return true;
        case MotionEvent.ACTION_UP:
            if(!tracking)return false;
            tracking=false;dragging=false;Activity a=activity();
            if(a!=null)WideSettings.save(a,WideSettings.left(),WideSettings.top());
            performClick();return true;
        case MotionEvent.ACTION_CANCEL:
            if(!tracking)return false;
            tracking=false;dragging=false;WideSettings.preview(initialLeft,initialTop);return true;
        }
        return tracking;
    }
    @Override public boolean performClick(){super.performClick();return true;}
    @Override protected void onDetachedFromWindow(){if(tracking){tracking=false;dragging=false;WideSettings.preview(initialLeft,initialTop);}super.onDetachedFromWindow();}
}
