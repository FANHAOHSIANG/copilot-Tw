package android.content;

/** Minimal host boundary. No Android lifecycle behavior is simulated here. */
public class Context {
    public static final int MODE_PRIVATE = 0;
    public final SharedPreferences preferences = new SharedPreferences();
    public Context getApplicationContext() { return this; }
    public SharedPreferences getSharedPreferences(String name, int mode) { return preferences; }
}
