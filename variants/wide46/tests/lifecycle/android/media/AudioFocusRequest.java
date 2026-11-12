package android.media;
import android.os.Handler;
public final class AudioFocusRequest {
    public static final class Builder {
        public Builder(int value) { }
        public Builder setAudioAttributes(AudioAttributes value) { return this; }
        public Builder setWillPauseWhenDucked(boolean value) { return this; }
        public Builder setAcceptsDelayedFocusGain(boolean value) { return this; }
        public Builder setOnAudioFocusChangeListener(AudioManager.OnAudioFocusChangeListener listener, Handler handler) { return this; }
        public AudioFocusRequest build() { return new AudioFocusRequest(); }
    }
}
