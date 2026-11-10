package android.view;
public class View {
 public boolean focus; public final ViewTreeObserver observer = new ViewTreeObserver();
 public boolean hasWindowFocus(){ return focus; }
 public ViewTreeObserver getViewTreeObserver(){ return observer; }
 public boolean post(Runnable r){ r.run(); return true; }
 public void setFocus(boolean value){ focus=value; if(observer.listener!=null)observer.listener.onWindowFocusChanged(value); }
}
