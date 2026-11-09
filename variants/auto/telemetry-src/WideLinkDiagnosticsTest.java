package com.navipilot.obf;

/** JVM tests for false-current-error and missed-disconnection regressions. */
public final class WideLinkDiagnosticsTest {
    private static int checks;
    private static void contains(String actual, String expected) {
        checks++;
        if (!actual.contains(expected)) throw new AssertionError("Missing: " + expected + "\n" + actual);
    }
    public static void main(String[] args) {
        WideLinkDiagnostics d = new WideLinkDiagnostics();
        contains(d.report(1000, "test-version"), "Navipilot test-version");
        contains(d.report(1000, "test-version"), "監測尚未啟動");
        d.hello(1100, 1);
        d.hello(1101, 1); // Duplicate hello must not inflate the handshake count.
        d.observe(1200, 1150, 1050, true, false, "host:7000", "無");
        contains(d.report(1200, "v"), "已連線；有效資料新鮮");
        contains(d.report(1200, "v"), "握手完成：1 次");
        d.failure(1500, "closed 1011: state_send_timeout");
        d.observe(1600, 1150, 1550, false, false, "host:7000", "無");
        contains(d.report(1600, "v"), "等待連線／握手");
        contains(d.report(1600, "v"), "斷線／連線失敗事件：1 次");
        contains(d.report(1600, "v"), "資料停滯強制重連：0 次");
        d.hello(1700, 3);
        d.observe(1750, 1150, 1550, true, false, "host:7000", "無");
        contains(d.report(1750, "v"), "等待本次連線的有效資料");
        contains(d.report(1750, "v"), "中斷後有效資料恢復：0 次");
        d.observe(1900, 1850, 1550, true, false, "host:7000", "無");
        String recovered = d.report(2000, "actual-apk-version");
        contains(recovered, "已連線；有效資料新鮮");
        contains(recovered, "中斷後有效資料恢復：1 次");
        contains(recovered, "上次斷線／失敗（歷史）：0.5 秒前");
        contains(recovered, "state_send_timeout：1 次");
        // A second identical failure must count even if no polling tick occurs in between.
        d.failure(2100, "closed 1011: state_send_timeout");
        d.hello(2200, 5);
        d.observe(2300, 2250, 2150, true, false, "host:7000", "無");
        contains(d.report(2300, "v"), "state_send_timeout：2 次");
        contains(d.report(2300, "v"), "中斷後有效資料恢復：2 次");
        d.failure(2400, "8 秒沒有有效車況，重新連線");
        d.forcedReconnect();
        contains(d.report(2500, "v"), "斷線／連線失敗事件：3 次");
        contains(d.report(2500, "v"), "資料停滯強制重連：1 次");
        contains(d.report(2500, "v"), "state_send_timeout：2 次");
        contains(d.report(6000, "v"), "監測未更新");
        d.observe(7000, 2250, 2150, true, false, "host:7000", "無");
        contains(d.report(7000, "v"), "等待本次連線的有效資料");
        // Freshness is evaluated at copy time, not at the last watchdog tick.
        WideLinkDiagnostics stale = new WideLinkDiagnostics();
        stale.observe(10000, 6100, 6000, true, false, "host:7000", "無");
        contains(stale.report(10200, "v"), "有效資料已過期");
        stale.observe(10200, 10200, 6000, true, true, "host:7000", "無");
        contains(stale.report(10200, "v"), "連線已暫停／停止");
        for (int i = 0; i < 50; i++) stale.failure(11000 + i, "reason");
        String history = stale.report(12000, "v");
        int eventLines = history.split("秒前 連線中斷／失敗：", -1).length - 1;
        if (eventLines != 8) throw new AssertionError("History unbounded: " + eventLines);
        checks++;
        System.out.println("PASS: " + checks + " diagnostic assertions; no Android runtime test");
    }
}
