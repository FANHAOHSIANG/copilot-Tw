package android.content;
import android.content.res.AssetManager;
import android.media.AudioManager;
public class Context {
    public static final String AUDIO_SERVICE = "audio";
    public final AudioManager audio = new AudioManager();
    private final SharedPreferences preferences = new SharedPreferences();
    public Context getApplicationContext() { return this; }
    public Object getSystemService(String name) { return audio; }
    public SharedPreferences getSharedPreferences(String name, int mode) { return preferences; }
    public AssetManager getAssets() { return new AssetManager(); }
}
