package com.navipilot.obf;

import android.os.SystemClock;
import java.util.Map;
import org.json.JSONObject;

/** Sender-bound Link routing and local delivery diagnostics. Never claims a receiver ACK. */
public final class WideLinkDelivery {
    private static long attempts, accepted, withdrawals, lastAccepted = -1;
    private static String outcome = "尚未進入傳送流程";

    public static JSONObject route(MG wire, String stream, JSONObject original, Map timestamps) {
        JSONObject legacy = WideAmapSource.filter(wire, stream, original, timestamps);
        if (WideAmapLinkIntegration.phoneSelected()) {
            // The same source selection that owns the Link reader owns the outgoing snapshot.
            // Do not let a legacy Auto idle snapshot or a stale Google gate replace Link data.
            return WideAmapLinkIntegration.filter(wire, stream, original, timestamps);
        }
        return legacy;
    }

    public static synchronized void result(String stream, JSONObject value, String reason) {
        if (!WideAmapLinkIntegration.phoneSelected() || !"guidance_current".equals(stream)) return;
        outcome = reason;
        if ("已交給傳送佇列".equals(reason)) {
            if (value == null) withdrawals++;
            else { accepted++; lastAccepted = SystemClock.elapsedRealtime(); }
        } else if ("開始交付".equals(reason)) attempts++;
    }

    public static synchronized void reset() {
        attempts = accepted = withdrawals = 0;
        lastAccepted = -1;
        outcome = "來源已切換，等待交付";
    }

    public static synchronized String status() {
        long now = SystemClock.elapsedRealtime();
        return "\nLink 交付嘗試：" + attempts + "；有效引導排入佇列：" + accepted
            + "；撤銷排入佇列：" + withdrawals
            + "\n最後有效引導排入佇列：" + (lastAccepted < 0 ? "尚無" : Math.max(0, now-lastAccepted)/1000 + " 秒前")
            + "\n最近交付結果：" + outcome
            + "\n以上是手機傳送端紀錄；comma 接收仍需車端確認。";
    }
}
