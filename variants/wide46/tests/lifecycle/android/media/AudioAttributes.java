package android.media;
public final class AudioAttributes {
    public static final int USAGE_ASSISTANCE_NAVIGATION_GUIDANCE = 12, CONTENT_TYPE_SPEECH = 1;
    public static final class Builder {
        public Builder setUsage(int value) { return this; }
        public Builder setContentType(int value) { return this; }
        public AudioAttributes build() { return new AudioAttributes(); }
    }
}
