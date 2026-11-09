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
    private final boolean secondary;
    private boolean horizontal,startPortrait;
    private final Paint paint = new Paint(3);
    private float down, usable, initialUpper,initialPrimary;
    private int initialLeft, initialTop;
    private boolean tracking;
    public static boolean isDragging() { return dragging; }
    public WideDivider(Context c, boolean horizontal) {
        super(c); this.secondary=horizontal;
        updateAxis();
        setClickable(true);
    }
    public void updateAxis() {
        horizontal=secondary||WideLayout.portrait();
        setContentDescription(secondary?"拖曳調整神盾與快捷鍵比例":horizontal?"拖曳調整上下畫面比例":"拖曳調整左右畫面比例");
        invalidate();
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
        if(tracking&&startPortrait!=WideLayout.portrait()){cancel();return true;}
        switch(e.getActionMasked()) {
        case MotionEvent.ACTION_DOWN:
            if(!WideLayout.active || dragging) return false;
            updateAxis();startPortrait=WideLayout.portrait();
            down=horizontal?e.getRawY():e.getRawX();initialLeft=WideSettings.left();initialTop=WideSettings.top();
            WideGeometry.Plan p=WideLayout.plan();
            usable=dp(Math.max(1,(secondary?p.sideHeight:horizontal?p.height:p.width)-6));
            initialUpper=dp(p.shieldHeight);initialPrimary=dp(horizontal?p.mapHeight:p.mapWidth);
            tracking=true;dragging=true;ViewParent parent=getParent();if(parent!=null)parent.requestDisallowInterceptTouchEvent(true);return true;
        case MotionEvent.ACTION_MOVE:
            if(!tracking)return false;
            float delta=(horizontal?e.getRawY():e.getRawX())-down;
            int left=secondary?initialLeft:Math.round(100f*(initialPrimary+delta)/usable);
            int top=secondary?Math.round(100f*(initialUpper+delta)/usable):initialTop;
            WideSettings.preview(left,top);return true;
        case MotionEvent.ACTION_UP:
            if(!tracking)return false;
            tracking=false;dragging=false;Activity a=activity();
            if(a!=null)WideSettings.saveFor(a,startPortrait,WideSettings.left(),WideSettings.top());
            performClick();return true;
        case MotionEvent.ACTION_CANCEL:
            if(!tracking)return false;
            cancel();return true;
        }
        return tracking;
    }
    @Override public boolean performClick(){super.performClick();return true;}
    private void cancel(){tracking=false;dragging=false;WideSettings.previewFor(startPortrait,initialLeft,initialTop);}
    @Override protected void onDetachedFromWindow(){if(tracking)cancel();super.onDetachedFromWindow();}
}
