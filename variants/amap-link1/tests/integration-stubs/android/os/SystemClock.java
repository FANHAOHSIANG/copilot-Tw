package android.os;

public final class SystemClock {
    private static long now = 1000;
    public static long elapsedRealtime() { return now; }
    public static void setElapsedRealtime(long value) { now = value; }
}
