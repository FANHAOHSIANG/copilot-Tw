package com.navipilot.obf;
import android.content.Context;
import android.graphics.*;
import android.view.View;
/** Quiet, time-driven animation. No data or control claims; stops when not visible. */
final class WideIdle extends View {
 private final Paint p=new Paint(3);
 WideIdle(Context c){super(c);setContentDescription("空白投屏畫面，顯示時間");}
 @Override protected void onDraw(Canvas c){super.onDraw(c);c.drawColor(WideUi.BG);float w=getWidth(),h=getHeight(),d=getResources().getDisplayMetrics().density;
  double phase=android.os.SystemClock.uptimeMillis()/4000.0;
  p.setColor(0x183fa8c5);c.drawCircle(w*.5f,h*.45f,(float)(Math.min(w,h)*(.32+.012*Math.sin(phase))),p);
  p.setColor(WideUi.INK);p.setTextAlign(Paint.Align.CENTER);p.setTypeface(Typeface.create("sans-serif-light",0));p.setTextSize(Math.min(40*d,w/4));
  c.drawText(new java.text.SimpleDateFormat("HH:mm",java.util.Locale.TAIWAN).format(new java.util.Date()),w/2,h*.48f,p);
  p.setTextSize(12*d);p.setColor(WideUi.MUTED);c.drawText("留點空間，專心前行",w/2,h*.48f+26*d,p);
  if(isShown()&&getWindowVisibility()==VISIBLE)postInvalidateDelayed(100);
 }
 @Override protected void onVisibilityChanged(View changed,int visibility){super.onVisibilityChanged(changed,visibility);if(visibility==VISIBLE)invalidate();}
}
