package android.speech.tts;
import java.util.Locale;
public final class Voice {
    private final Locale locale;
    public Voice(Locale locale) { this.locale = locale; }
    public Locale getLocale() { return locale; }
    public boolean isNetworkConnectionRequired() { return false; }
}
