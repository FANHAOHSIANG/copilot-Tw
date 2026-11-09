package android.app;
import android.content.SharedPreferences;
public class Activity extends android.content.ContextWrapper {
 public final SharedPreferences preferences;
 public Activity(SharedPreferences p){preferences=p;}
 public SharedPreferences getSharedPreferences(String key,int mode){return preferences;}
 public android.view.View findViewById(int id){return null;}
}
