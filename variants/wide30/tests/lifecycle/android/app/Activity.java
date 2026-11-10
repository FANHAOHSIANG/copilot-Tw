package android.app;
import android.content.SharedPreferences; import android.view.Window;
public class Activity {
 public final Application application = new Application(); public final Window window = new Window();
 public final SharedPreferences preferences = new SharedPreferences(); public boolean finishing; public boolean destroyed;
 public Application getApplication(){ return application; } public Window getWindow(){ return window; }
 public boolean isFinishing(){ return finishing; } public boolean isDestroyed(){ return destroyed; }
 public SharedPreferences getSharedPreferences(String key,int flags){ return preferences; }
}
