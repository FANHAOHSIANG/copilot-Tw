package com.navipilot.obf;

/** A finite retry budget and a monotonically increasing delivery barrier.
 * All mutations belong to the owner's main thread; volatile fields support worker checks. */
public final class WideAmapLinkPolicy {
    public static final int MAX_ATTEMPTS = 5;
    private static final long[] DELAYS_MS = {1500, 3000, 6000, 10000};
    private volatile long generation;
    private volatile boolean running;
    private volatile boolean closed;
    private volatile boolean refused;
    private int attempts;

    public boolean start() {
        if (closed || running) return false;
        running = true;
        refused = false;
        attempts = 0;
        return true;
    }

    /** Called only for an explicit retry or a successful, user-requested map launch. */
    public boolean retryAfterMapLaunch() {
        if (closed) return false;
        running = true;
        refused = false;
        attempts = 0;
        return true;
    }

    public long invalidate() { return ++generation; }
    public long generation() { return generation; }

    public boolean isCurrent(long candidate) {
        return running && !closed && !refused && candidate == generation;
    }

    public boolean beginAttempt() {
        if (!running || closed || refused || attempts >= MAX_ATTEMPTS) return false;
        attempts++;
        return true;
    }

    public int attempts() { return attempts; }

    public long retryDelayMs() {
        if (!running || closed || refused || attempts >= MAX_ATTEMPTS) return -1;
        return DELAYS_MS[Math.max(0, attempts - 1)];
    }

    public void refuse() { refused = true; }
    public void stop() { running = false; }
    public void close() { running = false; closed = true; refused = true; }
    public boolean isRunning() { return running; }
    public boolean isClosed() { return closed; }
}
