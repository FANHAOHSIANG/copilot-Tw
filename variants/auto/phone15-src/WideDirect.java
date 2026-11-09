package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;
import android.graphics.SurfaceTexture;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.*;
import android.widget.*;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/** In-process GPU surfaces. No JPEG encoder, HTTP image stream or WebView decoder. */
public final class WideDirect {
    private static final Handler MAIN=new Handler(Looper.getMainLooper());
    private static final ExecutorService WORK=Executors.newSingleThreadExecutor();
    private static final ArrayList<WeakReference<Pane>> PANES=new ArrayList<WeakReference<Pane>>();
    private static Mt binder;
    private static volatile String mapStatus="等待開始投屏",shieldStatus="等待開始投屏";
    public static String report(){return "直接顯示測試版 wide.15-phone-bridge\n高德一般版："+mapStatus+"\n神盾："+shieldStatus;}
    public static void connected(final Mt value){MAIN.post(new Runnable(){public void run(){
        binder=value;refreshAll();
    }});}
    public static void disconnected(){connected(null);}
    private static void refreshAll(){
        for(int i=PANES.size()-1;i>=0;i--){Pane p=PANES.get(i).get();if(p==null)PANES.remove(i);else p.restart();}
    }
    public static Object shield(Object modifier,Object composer,Object changed){
        compose((VE)modifier,(Hh)composer,true,null);return J10.a;
    }
    public static void map(VE modifier,tr start,Hh composer){compose(modifier,composer,false,start);}
    private static void compose(VE modifier,Hh composer,final boolean shield,final tr start){
        androidx.compose.ui.viewinterop.a.a(new vr(){public Object j(Object context){return new Pane((Context)context,shield,start);}},modifier,null,
            new vr(){public Object j(Object view){((Pane)view).dispose();return J10.a;}},
            new vr(){public Object j(Object view){((Pane)view).start=start;return J10.a;}},composer,0);
    }
    private static Activity activity(Context c){while(c instanceof ContextWrapper){if(c instanceof Activity)return (Activity)c;c=((ContextWrapper)c).getBaseContext();}return null;}
    private static final class Pane extends LinearLayout implements TextureView.SurfaceTextureListener {
        final boolean shield; final TextureView texture; final TextView state; final FrameLayout body;
        tr start; boolean disposed,attached; int generation; long lastMove;
        SurfaceTexture source; Session session; Session workerSession;
        final Runnable resize=new Runnable(){public void run(){if(WideDivider.isDragging()){MAIN.postDelayed(this,200);return;}restart();}};
        Pane(Context context,boolean isShield,tr launch){super(context);shield=isShield;start=launch;
            setOrientation(VERTICAL);setBackgroundColor(0xff172230);
            LinearLayout bar=new LinearLayout(context);bar.setGravity(Gravity.CENTER_VERTICAL);
            TextView title=new TextView(context);title.setText(shield?"神盾測速":"高德一般版");title.setTextColor(Color.WHITE);title.setTextSize(12);title.setPadding(dp(6),0,0,0);
            bar.addView(title,new LinearLayout.LayoutParams(0,dp(38),1));
            button(bar,"返回",new View.OnClickListener(){public void onClick(View v){final Session s=session;if(s!=null)WORK.execute(new Runnable(){public void run(){try{s.api.b(s.id,4);}catch(Exception e){}}});}});
            button(bar,"重開",new View.OnClickListener(){public void onClick(View v){restart();}});
            if(shield)button(bar,"版面",new View.OnClickListener(){public void onClick(View v){Activity a=activity(getContext());if(a!=null)WideSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));}});
            else button(bar,"投屏",new View.OnClickListener(){public void onClick(View v){if(start!=null)start.c();}});
            addView(bar,new LinearLayout.LayoutParams(-1,dp(38)));
            body=new FrameLayout(context);addView(body,new LinearLayout.LayoutParams(-1,0,1));
            texture=new TextureView(context);texture.setSurfaceTextureListener(this);body.addView(texture,new FrameLayout.LayoutParams(-1,-1));
            state=new TextView(context);state.setGravity(Gravity.CENTER);state.setTextColor(Color.WHITE);state.setTextSize(13);state.setBackgroundColor(0xff172230);state.setPadding(dp(8),0,dp(8),0);body.addView(state,new FrameLayout.LayoutParams(-1,-1));
            state.setOnClickListener(new View.OnClickListener(){public void onClick(View v){if(binder==null&&start!=null)start.c();else restart();}});
            status("請先啟動投屏並授權 Shizuku",true);
            texture.setOnTouchListener(new View.OnTouchListener(){public boolean onTouch(View v,MotionEvent e){
                final Session s=session;if(s==null)return true;
                int action=e.getActionMasked();int index=e.getActionIndex();
                if(action==MotionEvent.ACTION_POINTER_DOWN)action=MotionEvent.ACTION_DOWN;
                if(action==MotionEvent.ACTION_POINTER_UP)action=MotionEvent.ACTION_UP;
                if(action!=0&&action!=1&&action!=2&&action!=3)return true;
                if(action==2){long now=SystemClock.uptimeMillis();if(now-lastMove<32)return true;lastMove=now;}
                getParent().requestDisallowInterceptTouchEvent(true);
                int begin=action==2?0:index,end=action==2?e.getPointerCount():index+1;
                for(int k=begin;k<end;k++){
                    final int pointer=e.getPointerId(k);if(pointer>1)continue;
                    final int a=action;final float x=Math.max(0,Math.min(1,e.getX(k)/Math.max(1,v.getWidth()))),y=Math.max(0,Math.min(1,e.getY(k)/Math.max(1,v.getHeight())));
                    WORK.execute(new Runnable(){public void run(){if(s.closed)return;try{s.api.h(s.id,77,a,x,y,pointer);}catch(Exception ex){}}});
                }
                return true;
            }});
            WideDivider handle=new WideDivider(context,shield);
            FrameLayout.LayoutParams handleLayout=shield
                ? new FrameLayout.LayoutParams(-1,dp(26),Gravity.BOTTOM)
                : new FrameLayout.LayoutParams(dp(26),-1,Gravity.RIGHT);
            body.addView(handle,handleLayout);
            handle.bringToFront();
            PANES.add(new WeakReference<Pane>(this));
        }
        int dp(float x){return Math.round(getResources().getDisplayMetrics().density*x);}
        void button(LinearLayout bar,String text,View.OnClickListener click){Button b=new Button(getContext());b.setText(text);b.setTextSize(12);b.setMinWidth(0);b.setMinimumWidth(0);b.setMinHeight(0);b.setMinimumHeight(0);b.setPadding(0,0,0,0);b.setOnClickListener(click);bar.addView(b,new LinearLayout.LayoutParams(dp(48),dp(36)));}
        void status(String value,boolean visible){if(shield)shieldStatus=value;else mapStatus=value;state.setText(value);state.setVisibility(visible?VISIBLE:GONE);}
        @Override protected void onAttachedToWindow(){super.onAttachedToWindow();attached=true;if(texture.isAvailable()){source=texture.getSurfaceTexture();restart();}}
        @Override protected void onDetachedFromWindow(){attached=false;MAIN.removeCallbacks(resize);stop();super.onDetachedFromWindow();}
        void dispose(){disposed=true;MAIN.removeCallbacks(resize);stop();}
        void stop(){generation++;session=null;WORK.execute(new Runnable(){public void run(){if(workerSession!=null){workerSession.close();workerSession=null;}}});}
        void restart(){
            MAIN.removeCallbacks(resize);
            if(WideDivider.isDragging()){MAIN.postDelayed(resize,200);return;}
            stop();
            if(disposed||!attached||source==null||texture.getWidth()<2||texture.getHeight()<2)return;
            if(binder==null){status("請先啟動投屏並授權 Shizuku",true);return;}
            final String pkg=shield?"tw.com.ainvest.outpack":"com.autonavi.minimap";
            try{getContext().getPackageManager().getPackageInfo(pkg,0);}catch(Exception e){status("請先安裝"+(shield?"神盾測速照相":"高德一般版"),true);return;}
            final Mt api=binder;final int ticket=generation;
            // Fit the actual pane aspect ratio and cap GPU work at 1280 pixels on the long edge.
            float scale=Math.min(1f,1280f/Math.max(texture.getWidth(),texture.getHeight()));
            final int w=Math.max(2,Math.round(texture.getWidth()*scale)),h=Math.max(2,Math.round(texture.getHeight()*scale));
            final int density=Math.max(120,Math.round(getResources().getDisplayMetrics().densityDpi*scale));
            source.setDefaultBufferSize(w,h);final Surface surface=new Surface(source);
            status("正在開啟"+(shield?"神盾":"高德一般版"),true);
            WORK.execute(new Runnable(){public void run(){
                Session made=null;String error=null;int id=-1;
                try{
                    if(!api.asBinder().isBinderAlive())throw new IllegalStateException("Shizuku 已斷線");
                    id=api.f(shield?"WideShield":"WideAmapPhone",w,h,density,30f,surface);
                    if(id<0)throw new IllegalStateException("無法建立虛擬螢幕");
                    if(!api.e(pkg,id))throw new IllegalStateException("車機未能在分區啟動 App");
                    made=new Session(api,id,surface);workerSession=made;
                }catch(Exception e){if(id>=0)try{api.a(id);}catch(Exception ignored){}surface.release();error=e.getMessage();}
                final Session ready=made;final String failure=error;
                MAIN.post(new Runnable(){public void run(){
                    if(ticket!=generation||disposed||!attached){if(ready!=null)WORK.execute(new Runnable(){public void run(){ready.close();}});return;}
                    session=ready;status(ready!=null?"直接顯示 "+w+"×"+h+"／30 Hz":"啟動失敗："+failure+"\n點一下重試",ready==null);
                }});
            }});
        }
        public void onSurfaceTextureAvailable(SurfaceTexture s,int w,int h){source=s;restart();}
        public void onSurfaceTextureSizeChanged(SurfaceTexture s,int w,int h){MAIN.removeCallbacks(resize);MAIN.postDelayed(resize,500);}
        public boolean onSurfaceTextureDestroyed(final SurfaceTexture s){source=null;MAIN.removeCallbacks(resize);stop();WORK.execute(new Runnable(){public void run(){s.release();}});return false;}
        public void onSurfaceTextureUpdated(SurfaceTexture s){}
    }
    private static final class Session {
        final Mt api;final int id;final Surface surface;volatile boolean closed;
        Session(Mt api,int id,Surface surface){this.api=api;this.id=id;this.surface=surface;}
        void close(){if(closed)return;closed=true;try{api.a(id);}catch(Exception e){}finally{surface.release();}}
    }
}
