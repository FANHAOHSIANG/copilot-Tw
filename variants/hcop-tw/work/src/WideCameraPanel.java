package com.navipilot.obf;
import android.app.Activity;
import android.content.*;
import android.graphics.*;
import android.os.*;
import android.text.TextPaint;
import android.text.TextUtils;
import android.view.*;
import android.widget.*;

/** Large, native camera/section presentation. Draw geometry shared with offline visual checks. */
public final class WideCameraPanel extends LinearLayout {
 private final Handler main=new Handler(Looper.getMainLooper());private final Dashboard dashboard;private final Button gps,demo;private final TextView roadLimit;
 private int demoMode;private long demoStart;private boolean disposed;
 private final Runnable tick=new Runnable(){public void run(){if(disposed)return;gps.setText(WideCamera.running?"停止":"GPS");roadLimit.setText(WideHcop.label());dashboard.invalidate();main.postDelayed(this,300);}};
 public WideCameraPanel(Context c){super(c);setOrientation(VERTICAL);setBackgroundColor(0xff15263b);WideCamera.init(c);
  LinearLayout bar=new LinearLayout(c);bar.setGravity(Gravity.CENTER_VERTICAL);bar.setPadding(dp(10),0,dp(4),0);
  TextView title=new TextView(c);title.setText("台灣測速");title.setTextColor(0xfff4f8ff);title.setTypeface(null,Typeface.BOLD);title.setTextSize(17);title.setSingleLine(true);title.setEllipsize(TextUtils.TruncateAt.END);title.setGravity(Gravity.CENTER_VERTICAL);bar.addView(title,new LayoutParams(0,dp(40),1));
  gps=button(bar,"GPS",new OnClickListener(){public void onClick(View v){demoMode=0;demo.setText("示範");Activity a=activity();if(a==null)return;if(WideCamera.running)WideCamera.stop(a);else WideCamera.start(a);dashboard.invalidate();}});
  demo=button(bar,"示範",new OnClickListener(){public void onClick(View v){demoMode=(demoMode+1)%3;if(demoMode>0)WideBridge.setEnabled(false);demoStart=SystemClock.elapsedRealtime();demo.setText(demoMode==1?"區間":demoMode==2?"實況":"示範");dashboard.invalidate();}});
  button(bar,"設定",new OnClickListener(){public void onClick(View v){Activity a=activity();if(a!=null)WideSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));}});
  addView(bar,new LayoutParams(-1,dp(40)));roadLimit=new TextView(c);roadLimit.setTextColor(0xffe7f4ff);roadLimit.setTextSize(14);roadLimit.setMaxLines(2);roadLimit.setEllipsize(TextUtils.TruncateAt.END);roadLimit.setPadding(dp(10),dp(3),dp(8),dp(3));roadLimit.setText("道路速限 —\n等待定位");addView(roadLimit,new LayoutParams(-1,dp(49)));FrameLayout body=new FrameLayout(c);addView(body,new LayoutParams(-1,0,1));
  dashboard=new Dashboard(c);body.addView(dashboard,new FrameLayout.LayoutParams(-1,-1));
  WideDivider divider=new WideDivider(c,true);body.addView(divider,new FrameLayout.LayoutParams(-1,dp(24),Gravity.BOTTOM));
 }
 private int dp(float x){return Math.round(x*getResources().getDisplayMetrics().density);}
 private Activity activity(){Context c=getContext();while(c instanceof ContextWrapper){if(c instanceof Activity)return(Activity)c;c=((ContextWrapper)c).getBaseContext();}return null;}
 private Button button(LinearLayout bar,String s,OnClickListener click){Button b=new Button(getContext());b.setText(s);b.setTextColor(0xffedf6ff);b.setTypeface(null,Typeface.BOLD);b.setTextSize(13);b.setMinWidth(0);b.setMinimumWidth(0);b.setMinHeight(0);b.setMinimumHeight(0);b.setPadding(0,0,0,0);b.setBackgroundTintList(android.content.res.ColorStateList.valueOf(0xff29435f));b.setOnClickListener(click);LayoutParams lp=new LayoutParams(dp(47),dp(38));lp.leftMargin=dp(3);bar.addView(b,lp);return b;}
 @Override protected void onAttachedToWindow(){super.onAttachedToWindow();main.removeCallbacks(tick);tick.run();}
 @Override protected void onDetachedFromWindow(){main.removeCallbacks(tick);super.onDetachedFromWindow();}
 public void dispose(){disposed=true;main.removeCallbacks(tick);}
 private final class Dashboard extends View {
  final Paint p=new Paint(Paint.ANTI_ALIAS_FLAG);final TextPaint t=new TextPaint(Paint.ANTI_ALIAS_FLAG);
  Dashboard(Context c){super(c);}
  protected void onDraw(final Canvas canvas){super.onDraw(canvas);float d=getResources().getDisplayMetrics().density;canvas.save();canvas.scale(d,d);
   long now=SystemClock.elapsedRealtime();WideCameraFace.Model m=demoMode>0?WideCameraFace.demo(demoMode,now-demoStart):WideCamera.model();
   setContentDescription(m.title+"，速限 "+m.limit+"，距離 "+Math.round(m.distance)+" 公尺，"+m.state);
   WideCameraFace.draw(new WideCameraFace.Painter(){
    public void rect(float x,float y,float w,float h,float radius,int color){p.setStyle(Paint.Style.FILL);p.setColor(color);canvas.drawRoundRect(x,y,x+w,y+h,radius,radius,p);}
    public void circle(float x,float y,float r,float stroke,int color){p.setColor(color);p.setStyle(stroke>0?Paint.Style.STROKE:Paint.Style.FILL);p.setStrokeWidth(stroke);canvas.drawCircle(x,y,r,p);}
    public void line(float x1,float y1,float x2,float y2,float stroke,int color){p.setStyle(Paint.Style.STROKE);p.setColor(color);p.setStrokeWidth(stroke);canvas.drawLine(x1,y1,x2,y2,p);}
    public void text(String value,float x,float y,float size,int color,float maxWidth,boolean center){t.setColor(color);t.setTypeface(Typeface.create("sans-serif-black",Typeface.BOLD));t.setFakeBoldText(true);t.setTextSize(size);t.setTextAlign(center?Paint.Align.CENTER:Paint.Align.LEFT);
     // Numbers shrink only as needed; explanatory strings ellipsize without overlapping neighbours.
     if(value.matches("[0-9 .—]+(?:m|秒)?")){float actual=t.measureText(value);if(actual>maxWidth)t.setTextSize(Math.max(12,size*maxWidth/actual));}
     String s=TextUtils.ellipsize(value,t,Math.max(0,maxWidth),TextUtils.TruncateAt.END).toString();canvas.drawText(s,x,y,t);
    }
   },getWidth()/d,Math.max(0,getHeight()/d-24),m,now);
   canvas.restore();
  }
 }
}
