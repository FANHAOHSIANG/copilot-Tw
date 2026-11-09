package com.navipilot.obf;

import android.app.Activity;
import android.content.Context;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.text.TextUtils;
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
    private static final String KEYBOARD_LOCAL = "phone_keyboard_in_pane";
    private static final String PREFS = "copilot_tw_projection";
    private static volatile String mapStatus = "尚未投屏", shieldStatus = "尚未投屏";

    public static String report() {
        return "Copilot tw wide.22\n" + WideVariant.mapName() + "：" + mapStatus
                + "\nCarrot 導航資料：" + WideAmapSource.status() + "\n"
                + (WideVariant.shieldPanel() ? "神盾：" + shieldStatus : "台灣測速：內建面板");
    }

    public static void connected(Mt value) {
        MAIN.post(() -> {
            if (binder != null && value != null && binder.asBinder().equals(value.asBinder())) {
                forEachPane(false, pane -> {
                    if (pane.shield && pane.teslaSuppressed != WideTeslaProjection.isActive()) pane.restart();
                });
                return;
            }
            if (binder == value) return;
            binder = value;
            forEachPane(false, Pane::restart);
        });
    }

    public static void disconnected() { connected(null); }

    static void changeMap() {
        MAIN.post(() -> forEachPane(true, pane -> {
            pane.updateHeader();
            pane.restart();
        }));
    }

    private static void forEachPane(boolean mapOnly, java.util.function.Consumer<Pane> action) {
        for (int i = PANES.size() - 1; i >= 0; i--) {
            Pane pane = PANES.get(i).get();
            if (pane == null || pane.disposed) PANES.remove(i);
            else if (pane.attached && (!mapOnly || !pane.shield)) action.accept(pane);
        }
    }

    private static void refreshWindow(Activity activity) {
        if (activity == null || activity.isDestroyed()) return;
        for (WeakReference<Pane> reference : PANES) {
            Pane pane = reference.get();
            if (pane != null && !pane.shield && pane.attached && !pane.disposed && activity(pane.getContext()) == activity) {
                WideInsets.projection(activity, true);
                return;
            }
        }
        WideInsets.projection(activity, false);
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
        final boolean shield;
        final TextureView texture;
        final FrameLayout body;
        final WideDivider handle;
        final TextView title, stateTitle, stateDetail;
        final LinearLayout state;
        final Button stateAction;
        Button controlsButton;
        tr start;
        boolean disposed, attached, starting, teslaSuppressed;
        int generation;
        long lastMove;
        SurfaceTexture source;
        Session session, workerSession;
        private final Runnable resize = this::resizeDisplay;

        Pane(Context context, boolean isShield, tr launch) {
            super(context);
            shield = isShield;
            start = launch;
            setOrientation(VERTICAL);
            setBackgroundColor(WideUi.BG);
            int accent = shield ? WideUi.AMBER : WideUi.BLUE;
            LinearLayout bar = WideUi.toolbar(context);
            title = WideUi.identity(bar, shield ? "測速提醒" : "路線導航", appName(), accent);
            WideUi.tool(bar, "返回", WideUi.INK, v -> {
                Session current = session;
                if (current != null) WORK.execute(() -> {
                    if (!current.closed) try { current.api.b(current.id, 4); } catch (Exception ignored) {}
                });
            });
            if (shield) controlsButton = WideUi.tool(bar, "快捷", WideUi.INK, v -> {
                Activity a = activity(getContext());
                if (a != null) WideSettings.toggleControls(a);
            });
            Button more = WideUi.tool(bar, "更多", accent, this::menu);
            more.setContentDescription(shield ? "神盾選項" : "導航選項與投屏設定");
            addView(bar, new LinearLayout.LayoutParams(-1, dp(48)));

            body = new FrameLayout(context);
            addView(body, new LinearLayout.LayoutParams(-1, 0, 1));
            texture = new TextureView(context);
            texture.setSurfaceTextureListener(this);
            body.addView(texture, new FrameLayout.LayoutParams(-1, -1));

            state = new LinearLayout(context);
            state.setOrientation(VERTICAL);
            state.setGravity(Gravity.CENTER_VERTICAL);
            state.setPadding(dp(12), dp(5), dp(12), dp(5));
            state.setBackgroundColor(WideUi.BG);
            stateTitle = WideUi.text(context, "", 17, accent, true);
            stateTitle.setMaxLines(1);
            stateTitle.setEllipsize(TextUtils.TruncateAt.END);
            state.addView(stateTitle, new LinearLayout.LayoutParams(-1, -2));
            stateDetail = WideUi.text(context, "", 12, WideUi.MUTED, false);
            stateDetail.setMaxLines(2);
            stateDetail.setEllipsize(TextUtils.TruncateAt.END);
            state.addView(stateDetail, new LinearLayout.LayoutParams(-1, -2));
            stateAction = WideUi.button(context, "", WideUi.INK, v -> {
                if (binder == null) WideProjectionHelp.start(activity(getContext()), start);
                else restart();
            });
            LinearLayout.LayoutParams action = new LinearLayout.LayoutParams(-2, dp(40));
            action.topMargin = dp(5);
            state.addView(stateAction, action);
            body.addView(state, new FrameLayout.LayoutParams(-1, -1));
            waiting();
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
        private int dp(float value) { return WideUi.dp(getContext(), value); }
        private String appName() { return shield ? "神盾測速" : WideVariant.mapName(); }
        private boolean localKeyboard() {
            return getContext().getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                    .getBoolean(KEYBOARD_LOCAL, false);
        }

        private void toggleKeyboard(Activity activity) {
            boolean local = !localKeyboard();
            getContext().getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                    .putBoolean(KEYBOARD_LOCAL, local).apply();
            Toast.makeText(activity, local ? "鍵盤將在導航區顯示" : "鍵盤將在車機主畫面顯示", Toast.LENGTH_SHORT).show();
            restart();
        }

        void menu(View anchor) {
            PopupMenu menu = new PopupMenu(getContext(), anchor);
            final int providerGroup = 10;
            final int firstProvider = 20;
            if (!shield) {
                for (WideVariant.Navigation option : WideVariant.Navigation.values()) {
                    menu.getMenu().add(providerGroup, firstProvider + option.ordinal(), option.ordinal(), option.label);
                }
                menu.getMenu().setGroupCheckable(providerGroup, true, true);
                menu.getMenu().findItem(firstProvider + WideVariant.navigation().ordinal()).setChecked(true);
                menu.getMenu().add(0, 3, 4, "啟動投屏／授權");
                if (WideVariant.isPhone()) menu.getMenu().add(0, 8, 5,
                        localKeyboard() ? "將鍵盤移至車機主畫面" : "將鍵盤移至導航區");
            } else if (controlsButton != null && controlsButton.getVisibility() == GONE) {
                menu.getMenu().add(0, 9, 4, WideSettings.controlsVisible() ? "收合快捷鍵" : "顯示快捷鍵");
            }
            menu.getMenu().add(0, 1, 6, "版面與比例設定");
            menu.getMenu().add(0, 2, 7, "重新開啟" + appName());
            menu.getMenu().add(0, 5, 8, "投屏安裝與授權");
            menu.getMenu().add(0, 6, 9, WideVariant.shieldPanel() ? "改用台灣測速面板" : "改用神盾面板");
            menu.getMenu().add(0, 7, 10, "Amap2Tesla 僅投神盾 · " + (WideVariant.teslaShield() ? "開" : "關"));
            menu.setOnMenuItemClickListener(item -> {
                Activity host = activity(getContext());
                int id = item.getItemId();
                if (id == 2) restart();
                else if (id == 3) WideProjectionHelp.start(host, start);
                else if (host != null) {
                    if (item.getGroupId() == providerGroup) {
                        WideVariant.select(host, WideVariant.Navigation.values()[id - firstProvider]);
                    } else if (id == 1) WideSettings.show(host, host.findViewById(android.R.id.content));
                    else if (id == 5) WideProjectionHelp.show(host);
                    else if (id == 6) WideVariant.togglePanel(host);
                    else if (id == 7) WideVariant.toggleTeslaShield(host);
                    else if (id == 8) toggleKeyboard(host);
                    else if (id == 9) WideSettings.toggleControls(host);
                }
                return true;
            });
            menu.show();
        }
        void adapt(boolean vertical,boolean shown){
            if(controlsButton!=null)controlsButton.setText(shown?"收合":"快捷");
            boolean horizontal=shield||vertical;
            FrameLayout.LayoutParams wanted=horizontal?new FrameLayout.LayoutParams(-1,dp(26),Gravity.BOTTOM):new FrameLayout.LayoutParams(dp(26),-1,Gravity.RIGHT);
            FrameLayout.LayoutParams old=(FrameLayout.LayoutParams)handle.getLayoutParams();
            if(old.width!=wanted.width||old.height!=wanted.height||old.gravity!=wanted.gravity)handle.setLayoutParams(wanted);
            handle.setVisibility(shield&&!shown?GONE:VISIBLE);handle.updateAxis();
        }
        @Override protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight) {
            super.onSizeChanged(width, height, oldWidth, oldHeight);
            updateHeader();
        }

        private void updateHeader() {
            if (title == null) return;
            boolean compact = getWidth() < dp(222);
            title.setText(compact ? (shield ? "神盾" : WideVariant.navigation().compactLabel) : appName());
            if (controlsButton != null) controlsButton.setVisibility(compact ? GONE : VISIBLE);
        }

        private void status(String headline, String detail, String action) {
            if (shield) shieldStatus = headline;
            else mapStatus = headline;
            stateTitle.setText(headline);
            stateDetail.setText(detail);
            stateDetail.setVisibility(detail.isEmpty() ? GONE : VISIBLE);
            stateAction.setText(action);
            stateAction.setVisibility(action.isEmpty() ? GONE : VISIBLE);
            state.setVisibility(detail.isEmpty() && action.isEmpty() ? GONE : VISIBLE);
        }

        private void waiting() {
            status("準備投屏", "啟動 Shizuku 或 Stellar 後授權 Copilot tw", shield ? "" : "啟動投屏");
        }

        @Override protected void onAttachedToWindow() {
            super.onAttachedToWindow();
            attached = true;
            if (!shield) refreshWindow(activity(getContext()));
            if (texture.isAvailable()) {
                source = texture.getSurfaceTexture();
                startIfNeeded();
            }
        }

        @Override protected void onDetachedFromWindow() {
            attached = false;
            stop();
            if (!shield) {
                Activity host = activity(getContext());
                MAIN.post(() -> refreshWindow(host));
            }
            super.onDetachedFromWindow();
        }

        void dispose() {
            disposed = true;
            stop();
        }

        private void stop() {
            MAIN.removeCallbacks(resize);
            generation++;
            starting = false;
            session = null;
            WORK.execute(() -> {
                if (workerSession != null) {
                    workerSession.close();
                    workerSession = null;
                }
            });
        }

        void restart() {
            stop();
            startIfNeeded();
        }

        private RenderSize renderSize() {
            int w = texture.getWidth(), h = texture.getHeight();
            float scale = Math.min(1f, 1280f / Math.max(w, h));
            return new RenderSize(Math.max(2, Math.round(w * scale)), Math.max(2, Math.round(h * scale)),
                    Math.max(120, Math.round(getResources().getDisplayMetrics().densityDpi * scale)));
        }

        private LayoutStamp layoutStamp() {
            WindowManager manager = getContext().getSystemService(WindowManager.class);
            Rect bounds = manager.getCurrentWindowMetrics().getBounds();
            return new LayoutStamp(bounds.width(), bounds.height(), getResources().getDisplayMetrics().densityDpi,
                    WideSettings.layoutPreferences());
        }

        private boolean surfaceReady() {
            return !disposed && attached && source != null && texture.getWidth() >= 2 && texture.getHeight() >= 2;
        }

        private void startIfNeeded() {
            if (!surfaceReady() || starting || session != null) return;
            if (binder == null) {
                waiting();
                return;
            }
            teslaSuppressed = shield && WideTeslaProjection.isActive();
            if (teslaSuppressed) {
                status("Tesla 投屏中", "神盾目前顯示於 Tesla 瀏覽器", "");
                return;
            }
            String pkg = shield ? "tw.com.ainvest.outpack" : WideVariant.packageName();
            String displayName = shield ? "WideShield" : WideVariant.isPhone() && !localKeyboard()
                    ? WideAmapIme.PHONE_HOST_IME : WideVariant.displayName();
            try { getContext().getPackageManager().getPackageInfo(pkg, 0); }
            catch (android.content.pm.PackageManager.NameNotFoundException missing) {
                status("尚未安裝" + appName(), "請先安裝，再回到此處連線", "重新檢查");
                return;
            }

            Mt api = binder;
            int ticket = generation;
            RenderSize size = renderSize();
            LayoutStamp layout = layoutStamp();
            starting = true;
            source.setDefaultBufferSize(size.width, size.height);
            Surface surface = new Surface(source);
            status("正在連線", "正在開啟" + appName() + "畫面", "");
            WORK.execute(() -> {
                int id = -1;
                Session made = null;
                String error = "";
                try {
                    if (!api.asBinder().isBinderAlive()) throw new IllegalStateException("投屏服務已斷線");
                    id = api.f(displayName, size.width, size.height, size.density, 30f, surface);
                    if (id <= 0) throw new IllegalStateException("車機無法建立投屏畫面");
                    if (!api.e(pkg, id)) throw new IllegalStateException("車機無法開啟投屏 App");
                    made = new Session(api, id, surface, size, layout);
                    workerSession = made;
                } catch (Exception failure) {
                    if (id > 0) try { api.a(id); } catch (Exception ignored) {}
                    surface.release();
                    error = failure.getMessage();
                }
                Session ready = made;
                String reason = error;
                MAIN.post(() -> {
                    if (ticket != generation || disposed || !attached) {
                        if (ready != null) WORK.execute(ready::close);
                        return;
                    }
                    starting = false;
                    session = ready;
                    if (ready == null) status("投屏暫時無法連線", reason == null ? "請確認投屏服務已啟動" : reason, "重試");
                    else {
                        showConnected(ready.size);
                        MAIN.postDelayed(resize, 350);
                    }
                });
            });
        }

        private void showConnected(RenderSize size) {
            status("投屏中 · " + size.width + " × " + size.height, "", "");
        }

        private void resizeDisplay() {
            if (!surfaceReady()) return;
            if (WideDivider.isDragging()) {
                MAIN.postDelayed(resize, 200);
                return;
            }
            WindowInsets insets = getRootWindowInsets();
            if (insets != null && insets.isVisible(WindowInsets.Type.ime())) return;

            Session current = session;
            if (current == null) {
                startIfNeeded();
                return;
            }
            LayoutStamp layout = layoutStamp();
            // A viewport-only change is not a configuration change, even if the ROM omits IME insets.
            if (layout.same(current.layout)) return;
            RenderSize size = renderSize();
            WORK.execute(() -> {
                if (current.closed || layout.same(current.layout)) return;
                if (!size.same(current.size)) {
                    try {
                        if (!WideDisplayResize.send(current.api, current.id, size.width, size.height, size.density)) return;
                        current.size = size;
                    } catch (Exception rejected) {
                        android.util.Log.w("WideDirect", "Kept existing projection after resize rejection", rejected);
                        return;
                    }
                }
                current.layout = layout;
                MAIN.post(() -> {
                    if (session != current || source == null) return;
                    source.setDefaultBufferSize(size.width, size.height);
                    showConnected(size);
                });
            });
        }

        public void onSurfaceTextureAvailable(SurfaceTexture surface, int width, int height) {
            source = surface;
            startIfNeeded();
        }

        public void onSurfaceTextureSizeChanged(SurfaceTexture surface, int width, int height) {
            if (session != null) {
                RenderSize size = session.size;
                surface.setDefaultBufferSize(size.width, size.height);
            }
            MAIN.removeCallbacks(resize);
            MAIN.postDelayed(resize, 350);
        }

        public boolean onSurfaceTextureDestroyed(SurfaceTexture surface) {
            source = null;
            stop();
            WORK.execute(surface::release);
            return false;
        }

        public void onSurfaceTextureUpdated(SurfaceTexture surface) {}
    }

    private static final class RenderSize {
        final int width, height, density;

        RenderSize(int width, int height, int density) {
            this.width = width;
            this.height = height;
            this.density = density;
        }

        boolean same(RenderSize other) {
            return width == other.width && height == other.height && density == other.density;
        }
    }

    private static final class LayoutStamp {
        final int width, height, density, preferences;

        LayoutStamp(int width, int height, int density, int preferences) {
            this.width = width;
            this.height = height;
            this.density = density;
            this.preferences = preferences;
        }

        boolean same(LayoutStamp other) {
            return width == other.width && height == other.height && density == other.density
                    && preferences == other.preferences;
        }
    }

    private static final class Session {
        final Mt api;
        final int id;
        final Surface surface;
        volatile boolean closed;
        volatile RenderSize size;
        volatile LayoutStamp layout;

        Session(Mt api, int id, Surface surface, RenderSize size, LayoutStamp layout) {
            this.api = api;
            this.id = id;
            this.surface = surface;
            this.size = size;
            this.layout = layout;
        }

        void close() {
            if (closed) return;
            closed = true;
            try { api.a(id); }
            catch (Exception ignored) {}
            finally { surface.release(); }
        }
    }
}
