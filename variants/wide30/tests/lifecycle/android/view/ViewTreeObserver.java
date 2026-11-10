package android.view;
public class ViewTreeObserver {
 public interface OnWindowFocusChangeListener { void onWindowFocusChanged(boolean focus); }
 public OnWindowFocusChangeListener listener;
 public void addOnWindowFocusChangeListener(OnWindowFocusChangeListener l) { listener = l; }
}
