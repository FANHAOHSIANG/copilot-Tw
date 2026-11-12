package android.speech.tts;
import android.content.Context;
import android.media.AudioAttributes;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import java.util.Collections;
import java.util.Locale;
import java.util.Set;
/** Captures transport calls; it does not synthesize audio or claim Android voice correctness. */
public final class TextToSpeech {
    public static final int SUCCESS = 0, ERROR = -1, LANG_AVAILABLE = 0, QUEUE_FLUSH = 0;
    public interface OnInitListener { void onInit(int status); }
    public static TextToSpeech last;
    public static boolean hasVoice = true;
    public UtteranceProgressListener listener;
    public int speakCalls, stopCalls, shutdownCalls;
    public String utterance = "", text = "";
    public TextToSpeech(Context context, final OnInitListener listener) {
        last = this;
        new Handler(Looper.getMainLooper()).post(new Runnable() { public void run() { listener.onInit(SUCCESS); }});
    }
    public Set<Voice> getVoices() { return hasVoice ? Collections.singleton(new Voice(Locale.TAIWAN)) : Collections.<Voice>emptySet(); }
    public int setLanguage(Locale locale) { return LANG_AVAILABLE; }
    public int setVoice(Voice voice) { return SUCCESS; }
    public int setAudioAttributes(AudioAttributes value) { return SUCCESS; }
    public int setSpeechRate(float value) { return SUCCESS; }
    public int setOnUtteranceProgressListener(UtteranceProgressListener listener) { this.listener = listener; return SUCCESS; }
    public int speak(String text, int strategy, Bundle bundle, String id) {
        this.text = text; this.utterance = id; speakCalls++; return SUCCESS;
    }
    public int stop() { stopCalls++; if (listener != null) listener.onStop(utterance, true); return SUCCESS; }
    public void shutdown() { shutdownCalls++; }
}
