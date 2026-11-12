package com.navipilot.obf;
import android.app.*;
import android.content.*;
import android.view.*;
import android.widget.*;
/** Read-only live data, fed by the existing timestamp-aware telemetry path. */
public final class WideDiagnostics extends LinearLayout {
 private final TextView output;private boolean disposed;
 private final Runnable tick=new Runnable(){public void run(){if(disposed||!isAttachedToWindow())return;output.setText(report());postDelayed(this,1000);}};
 public WideDiagnostics(Context c){super(c);setOrientation(VERTICAL);setBackgroundColor(WideUi.BG);
  LinearLayout bar=WideUi.toolbar(c);WideUi.identity(bar,"即時診斷","comma",WideUi.TEAL);
  WideUi.tool(bar,"切換",WideUi.BLUE,v->{Activity a=WideVariant.activity(c);if(a!=null)WidePanels.chooseLower(a);});addView(bar,new LayoutParams(-1,WideUi.dp(c,44)));
  ScrollView scroll=new ScrollView(c);output=WideUi.text(c,"",12,WideUi.INK,false);output.setTextIsSelectable(true);int pad=WideUi.dp(c,10);output.setPadding(pad,pad,pad,pad);scroll.addView(output);addView(scroll,new LayoutParams(-1,0,1));
 }
 static String report(){WideVehiclePanel.State s=WideVehiclePanel.current();return "comma 車速："+(Double.isNaN(s.speed)?"未知／資料過期":String.format(java.util.Locale.TAIWAN,"%.0f km/h",s.speed))
 +"\n橫向："+flag(s.lateral)+"  縱向："+flag(s.longitudinal)+"\n\n"+WideProjectionHelp.report()+"\n\n"+WideDirect.report()+"\n\n"+WideTelemetry.report();}
 private static String flag(Boolean v){return v==null?"未知":v?"啟用":"未啟用";}
 public static void show(Activity a){WideDiagnostics panel=new WideDiagnostics(a);FrameLayout frame=new FrameLayout(a);int height=Math.max(WideUi.dp(a,160),(int)(a.getResources().getDisplayMetrics().heightPixels*.65f));frame.addView(panel,new FrameLayout.LayoutParams(-1,height));AlertDialog d=new AlertDialog.Builder(a).setTitle("診斷與連線").setView(frame).setPositiveButton("關閉",null).setNeutralButton("複製",(x,y)->{
 ((ClipboardManager)a.getSystemService(Context.CLIPBOARD_SERVICE)).setPrimaryClip(ClipData.newPlainText("comma 診斷",report()));}).create();d.setOnDismissListener(x->panel.dispose());d.show();}
 @Override protected void onAttachedToWindow(){super.onAttachedToWindow();removeCallbacks(tick);post(tick);}
 @Override protected void onDetachedFromWindow(){removeCallbacks(tick);super.onDetachedFromWindow();}
 public void dispose(){disposed=true;removeCallbacks(tick);}
}
