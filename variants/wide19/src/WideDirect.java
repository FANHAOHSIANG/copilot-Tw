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
    public static String report(){return "Copilot tw wide.19\n"+WideVariant.mapName()+"："+mapStatus+"\nCarrot 高德來源："+WideAmapSource.status()+"\n"+(WideVariant.shieldPanel()?"神盾："+shieldStatus:"自製台灣測速：原生面板");}
    public static void connected(final Mt value){MAIN.post(new Runnable(){public void run(){
        binder=value;refreshAll();
    }});}
    public static void disconnected(){connected(null);}
    static void changeMap(){MAIN.post(WideDirect::refreshAll);}
    private static void refreshAll(){
        for(int i=PANES.size()-1;i>=0;i--){Pane p=PANES.get(i).get();if(p==null)PANES.remove(i);else {if(!p.shield)p.title.setText(WideVariant.mapName());p.restart();}}
    }
    public static Object shield(Object modifier,Object composer,Object changed){
        if (WideVariant.shieldPanel()) {
            compose((VE)modifier,(Hh)composer,true,null);
            return J10.a;
        }
        final boolean portrait=WideLayout.portrait(),controls=WideSettings.controlsVisible();
        androidx.compose.ui.viewinterop.a.a(new vr(){public Object j(Object context){return new WideTaiwanHost((Context)context);}},(VE)modifier,null,
            new vr(){public Object j(Object view){((WideTaiwanHost)view).dispose();return J10.a;}},
            new vr(){public Object j(Object view){((WideTaiwanHost)view).adapt(portrait,controls);return J10.a;}},(Hh)composer,0);
        return J10.a;
    }
    public static void map(VE modifier,tr start,Hh composer){compose(modifier,composer,false,start);}
    private static void compose(VE modifier,Hh composer,final boolean shield,final tr start){
        final boolean portrait=WideLayout.portrait(),controls=WideSettings.controlsVisible();
        androidx.compose.ui.viewinterop.a.a(new vr(){public Object j(Object context){return new Pane((Context)context,shield,start);}},modifier,null,
            new vr(){public Object j(Object view){((Pane)view).dispose();return J10.a;}},
            new vr(){public Object j(Object view){Pane p=(Pane)view;p.start=start;p.adapt(portrait,controls);return J10.a;}},composer,0);
    }
    private static Activity activity(Context c){return WideVariant.activity(c);}
    private static final class Pane extends LinearLayout implements TextureView.SurfaceTextureListener {
        final boolean shield; final TextureView texture; final TextView state; final FrameLayout body;
        final WideDivider handle; final TextView title; Button controlsButton;
        boolean portrait,controlsShown;
        tr start; boolean disposed,attached; int generation; long lastMove;
        SurfaceTexture source; Session session; Session workerSession;
        final Runnable resize=new Runnable(){public void run(){if(WideDivider.isDragging()){MAIN.postDelayed(this,200);return;}restart();}};
        Pane(Context context,boolean isShield,tr launch){super(context);shield=isShield;start=launch;
            setOrientation(VERTICAL);setBackgroundColor(0xff172230);
            LinearLayout bar=new LinearLayout(context);bar.setGravity(Gravity.CENTER_VERTICAL);
            title=new TextView(context);title.setText(shield?"神盾測速":WideVariant.mapName());title.setTextColor(Color.WHITE);title.setTextSize(14);title.setSingleLine(true);title.setEllipsize(android.text.TextUtils.TruncateAt.END);title.setPadding(dp(8),0,dp(4),0);
            bar.addView(title,new LinearLayout.LayoutParams(0,dp(48),1));
            button(bar,"返回",new View.OnClickListener(){public void onClick(View v){final Session s=session;if(s!=null)WORK.execute(new Runnable(){public void run(){try{s.api.b(s.id,4);}catch(Exception e){}}});}});
            if(shield)controlsButton=button(bar,"快捷",new View.OnClickListener(){public void onClick(View v){Activity a=activity(getContext());if(a!=null)WideSettings.toggleControls(a);}});
            Button more=button(bar,"更多",new View.OnClickListener(){public void onClick(View v){menu(v);}});
            more.setContentDescription("更多：版面設定、重新開啟、投屏");
            addView(bar,new LinearLayout.LayoutParams(-1,dp(48)));
            body=new FrameLayout(context);addView(body,new LinearLayout.LayoutParams(-1,0,1));
            texture=new TextureView(context);texture.setSurfaceTextureListener(this);body.addView(texture,new FrameLayout.LayoutParams(-1,-1));
            state=new TextView(context);state.setGravity(Gravity.CENTER);state.setTextColor(Color.WHITE);state.setTextSize(13);state.setBackgroundColor(0xff172230);state.setPadding(dp(8),0,dp(8),0);body.addView(state,new FrameLayout.LayoutParams(-1,-1));
            state.setOnClickListener(new View.OnClickListener(){public void onClick(View v){if(binder==null)WideProjectionHelp.start(activity(getContext()),start);else restart();}});
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
            handle=new WideDivider(context,shield);
            FrameLayout.LayoutParams handleLayout=shield
                ? new FrameLayout.LayoutParams(-1,dp(26),Gravity.BOTTOM)
                : new FrameLayout.LayoutParams(dp(26),-1,Gravity.RIGHT);
            body.addView(handle,handleLayout);
            handle.bringToFront();
            adapt(WideLayout.portrait(),WideSettings.controlsVisible());
            PANES.add(new WeakReference<Pane>(this));
        }
        int dp(float x){return Math.round(getResources().getDisplayMetrics().density*x);}
        Button button(LinearLayout bar,String text,View.OnClickListener click){Button b=new Button(getContext());b.setText(text);b.setTextSize(14);b.setSingleLine(true);b.setAutoSizeTextTypeUniformWithConfiguration(10,14,1,android.util.TypedValue.COMPLEX_UNIT_SP);b.setMinWidth(0);b.setMinimumWidth(0);b.setMinHeight(0);b.setMinimumHeight(0);b.setPadding(0,0,0,0);b.setOnClickListener(click);bar.addView(b,new LinearLayout.LayoutParams(dp(48),dp(48)));return b;}
        void menu(View anchor){
            PopupMenu menu=new PopupMenu(getContext(),anchor);
            menu.getMenu().add(0,1,0,"版面與比例設定");
            menu.getMenu().add(0,2,1,"重新開啟"+(shield?"神盾":WideVariant.mapName()));
            if(!shield){
                menu.getMenu().add(0,3,2,"啟動投屏／授權");
                menu.getMenu().add(0,4,3,"切換至"+(WideVariant.isPhone()?"高德車機版":"高德一般版"));
            }
            menu.getMenu().add(0,5,4,"投屏安裝與授權");
            menu.getMenu().add(0,6,5,WideVariant.shieldPanel()?"改用台灣測速面板":"改用神盾面板");
            menu.getMenu().add(0,7,6,"Amap2Tesla 僅投神盾 · "+(WideVariant.teslaShield()?"開":"關"));
            menu.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener(){public boolean onMenuItemClick(MenuItem item){
                if(item.getItemId()==1){Activity a=activity(getContext());if(a!=null)WideSettings.show(a,(ViewGroup)a.findViewById(android.R.id.content));}
                else if(item.getItemId()==2)restart();
                else if(item.getItemId()==4){
                    Activity a=activity(getContext());
                    if(a!=null)WideVariant.select(a,!WideVariant.isPhone());
                }else{
                    Activity a=activity(getContext());
                    if(item.getItemId()==3)WideProjectionHelp.start(a,start);
                    else if(a!=null&&item.getItemId()==5)WideProjectionHelp.show(a);
                    else if(a!=null&&item.getItemId()==6)WideVariant.togglePanel(a);
                    else if(a!=null&&item.getItemId()==7)WideVariant.toggleTeslaShield(a);
                }
                return true;
            }});menu.show();
        }
        void adapt(boolean vertical,boolean shown){
            portrait=vertical;controlsShown=shown;
            if(controlsButton!=null)controlsButton.setText(shown?"收合":"快捷");
            boolean horizontal=shield||portrait;
            FrameLayout.LayoutParams wanted=horizontal?new FrameLayout.LayoutParams(-1,dp(26),Gravity.BOTTOM):new FrameLayout.LayoutParams(dp(26),-1,Gravity.RIGHT);
            FrameLayout.LayoutParams old=(FrameLayout.LayoutParams)handle.getLayoutParams();
            if(old.width!=wanted.width||old.height!=wanted.height||old.gravity!=wanted.gravity)handle.setLayoutParams(wanted);
            handle.setVisibility(shield&&!shown?GONE:VISIBLE);handle.updateAxis();
        }
        @Override protected void onSizeChanged(int w,int h,int ow,int oh){super.onSizeChanged(w,h,ow,oh);if(title!=null)title.setVisibility(w<dp(shield?260:220)?GONE:VISIBLE);}
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
            if(shield&&WideTeslaProjection.isActive()){status("神盾正在投到 Tesla 瀏覽器",true);return;}
            final String pkg=shield?"tw.com.ainvest.outpack":WideVariant.packageName();
            try{getContext().getPackageManager().getPackageInfo(pkg,0);}catch(Exception e){status("請先安裝"+(shield?"神盾測速照相":WideVariant.mapName()),true);return;}
            final Mt api=binder;final int ticket=generation;
            // Fit the actual pane aspect ratio and cap GPU work at 1280 pixels on the long edge.
            float scale=Math.min(1f,1280f/Math.max(texture.getWidth(),texture.getHeight()));
            final int w=Math.max(2,Math.round(texture.getWidth()*scale)),h=Math.max(2,Math.round(texture.getHeight()*scale));
            final int density=Math.max(120,Math.round(getResources().getDisplayMetrics().densityDpi*scale));
            source.setDefaultBufferSize(w,h);final Surface surface=new Surface(source);
            status("正在開啟"+(shield?"神盾":WideVariant.mapName()),true);
            WORK.execute(new Runnable(){public void run(){
                Session made=null;String error=null;int id=-1;
                try{
                    if(!api.asBinder().isBinderAlive())throw new IllegalStateException("Shizuku 已斷線");
                    id=api.f(shield?"WideShield":WideVariant.displayName(),w,h,density,30f,surface);
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
