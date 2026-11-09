package com.navipilot.obf;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.util.Log;
import java.lang.ref.WeakReference;

/** Observe existing socket callbacks; preserve retry scheduling and freshness rules. */
public final class WideTelemetry {
    private static WeakReference<Ae> owner = new WeakReference<Ae>(null);
    private static String target;
    private static WideLinkDiagnostics stats = new WideLinkDiagnostics();
    private static volatile String version = "（實際版本尚未讀取）";

    public static void init(Context context) {
        try {
            PackageInfo info = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            version = info.versionName + "（" + info.getLongVersionCode() + "）";
        } catch (Exception e) { version = "（無法讀取已安裝版本）"; }
    }
    private static long now() { return System.nanoTime() / 1000000L; }
    private static synchronized WideLinkDiagnostics tracker(Ae client) {
        String current = client.m;
        if (owner.get() != client || (target == null ? current != null : !target.equals(current))) {
            owner = new WeakReference<Ae>(client);
            target = current;
            stats = new WideLinkDiagnostics();
        }
        return stats;
    }
    // Hooked only after the original generation guard has accepted a failure.
    public static void failure(Ae client, String reason) { tracker(client).failure(now(), reason); }
    // Hooked only after a valid compact hello, inside the original client monitor.
    public static void hello(Ae client) { tracker(client).hello(now(), client.i); }

    /** Called under the client's existing monitor, on its existing watchdog. */
    public static void check(Ae client, long now) {
        WideLinkDiagnostics diagnostic = tracker(client);
        String endpoint = "尚未選擇裝置";
        if (client.m != null) {
            android.net.Uri uri = android.net.Uri.parse(client.m);
            endpoint = String.valueOf(uri.getHost()) + (uri.getPort() >= 0 ? ":" + uri.getPort() : "");
        }
        Object rejected = client.A.getValue();
        diagnostic.observe(now, client.o, client.p, client.l, client.j || client.k,
                           endpoint, rejected instanceof sg ? ((sg) rejected).a : "無");
        if (!WideGeometry.reconnect(client.a(client.i), client.f != null, now, client.o, client.p, client.l)) return;
        mO old = client.f;
        String reason = client.l ? "8 秒沒有有效車況，重新連線" : "12 秒未完成車況握手，重新連線";
        client.c(client.i, reason, null);
        diagnostic.forcedReconnect();
        if (old != null) {
            try { old.a(); } catch (RuntimeException errorOnCancel) { Log.w("WideTelemetry", "關閉舊連線失敗", errorOnCancel); }
        }
        Log.w("WideTelemetry", reason);
    }
    public static String report() {
        WideLinkDiagnostics snapshot;
        synchronized (WideTelemetry.class) { snapshot = stats; }
        return snapshot.report(now(), version);
    }
}
