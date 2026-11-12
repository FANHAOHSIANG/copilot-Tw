package android.media;
public final class AudioManager {
    public static final int AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK = 3, AUDIOFOCUS_REQUEST_GRANTED = 1;
    public interface OnAudioFocusChangeListener { void onAudioFocusChange(int value); }
    public int requests, abandons;
    public int requestAudioFocus(AudioFocusRequest request) { requests++; return AUDIOFOCUS_REQUEST_GRANTED; }
    public int abandonAudioFocusRequest(AudioFocusRequest request) { abandons++; return AUDIOFOCUS_REQUEST_GRANTED; }
}
