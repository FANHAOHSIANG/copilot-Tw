package com.navipilot.obf;

import android.content.Context;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONObject;

/** Only the Android/Binder boundary is replaced. Navigation and integration remain production code. */
public final class WideAmapLink {
    public interface Listener {
        void onState(String state, String detail);
        void onInvalidated(long epoch, String reason);
        void onData(long epoch, int type, JSONObject data, long receivedElapsedMs);
    }
    public static final List<WideAmapLink> instances = new ArrayList<WideAmapLink>();
    public final Listener listener;
    public int starts;
    public int closes;
    public int retries;
    public long epoch;
    public WideAmapLink(Context context, Listener listener) {
        this.listener = listener;
        instances.add(this);
    }
    public void start() {
        starts++;
        listener.onInvalidated(++epoch, "start");
        listener.onState("STARTING", "host boundary started");
    }
    public void close() {
        closes++;
        listener.onInvalidated(++epoch, "close");
        listener.onState("CLOSED", "host boundary closed");
    }
    public void retryAfterMapLaunch() {
        retries++;
        listener.onInvalidated(++epoch, "explicit_retry");
    }
    public void ready() {
        listener.onState("AUTHENTICATED", "授權成功");
        listener.onState("LISTENING", "訂閱成功");
    }
    public void barrier() { listener.onInvalidated(++epoch, "test_disconnect"); }
    public void deliver(int type, JSONObject data, long elapsed) {
        listener.onData(epoch, type, data, elapsed);
    }
}
