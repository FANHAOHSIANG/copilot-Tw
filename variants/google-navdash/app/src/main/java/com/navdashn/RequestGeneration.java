package com.navdashn;

/** Rejects results from a superseded or disposed UI/route request. Contains no Android state. */
public final class RequestGeneration {
    private long generation;
    private boolean closed;

    public synchronized long begin() {
        if (closed) throw new IllegalStateException("Request owner is closed");
        return ++generation;
    }

    public synchronized boolean accepts(long request) {
        return !closed && request > 0 && request == generation;
    }

    public synchronized void cancel() { generation++; }

    public synchronized void close() { generation++; closed = true; }
}
