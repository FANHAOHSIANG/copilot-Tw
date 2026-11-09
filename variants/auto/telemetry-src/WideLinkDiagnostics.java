package com.navipilot.obf;

import java.util.ArrayDeque;
import java.util.Locale;

/** Read-only telemetry diagnostics. Timestamps share Ae's monotonic clock. */
public final class WideLinkDiagnostics {
    private long lastCheck, accepted, attemptStarted, failureAt, recoveredAt;
    private long lastHelloGeneration = Long.MIN_VALUE;
    private long pendingFailureAt;
    private boolean handshake, stopped, pendingRecovery;
    private int failures, reportedTimeouts, forcedReconnects, handshakes, recoveries;
    private String endpoint = "尚未選擇裝置", failure = "無", rejected = "無";
    private final ArrayDeque<Event> events = new ArrayDeque<Event>();

    private static final class Event {
        final long at;
        final String text;
        Event(long at, String text) { this.at = at; this.text = text; }
    }
    private void event(long now, String value) {
        if (events.size() == 8) events.removeFirst();
        events.addLast(new Event(now, value));
    }
    public synchronized void failure(long now, String reason) {
        failures++;
        failure = reason == null ? "未知原因" : reason.substring(0, Math.min(reason.length(), 200));
        if (failure.contains("state_send_timeout")) reportedTimeouts++;
        failureAt = now;
        if (!pendingRecovery) pendingFailureAt = now;
        pendingRecovery = true;
        handshake = false;
        event(now, "連線中斷／失敗：" + failure);
    }
    public synchronized void hello(long now, long generation) {
        if (lastHelloGeneration != generation) {
            handshakes++;
            lastHelloGeneration = generation;
            event(now, "握手完成；等待有效資料");
        }
    }
    public synchronized void forcedReconnect() { forcedReconnects++; }
    public synchronized void observe(long now, long lastAccepted, long started,
                                     boolean linked, boolean inactive, String target, String rejection) {
        lastCheck = now;
        accepted = lastAccepted;
        attemptStarted = started;
        handshake = linked;
        stopped = inactive;
        endpoint = target;
        rejected = rejection;
        if (pendingRecovery && linked && !inactive && lastAccepted > failureAt
                && lastAccepted >= started && now >= lastAccepted && now - lastAccepted <= 4000) {
            pendingRecovery = false;
            recoveredAt = lastAccepted;
            recoveries++;
            event(now, "有效資料恢復；中斷約 " + seconds(lastAccepted - pendingFailureAt) + " 秒");
        }
    }
    private static String seconds(long ms) {
        return String.format(Locale.ROOT, "%.1f", Math.max(0, ms) / 1000.0);
    }
    private static String ago(long now, long at) { return seconds(now - at) + " 秒前"; }
    public synchronized String report(long now, String version) {
        String state;
        if (lastCheck == 0) state = "車況監測尚未啟動";
        else if (now - lastCheck > 2000) state = "監測未更新（" + ago(now, lastCheck) + "），無法判定即時連線";
        else if (stopped) state = "連線已暫停／停止";
        else if (!handshake) state = "等待連線／握手";
        else if (accepted == 0 || accepted < attemptStarted || (pendingRecovery && accepted <= failureAt))
            state = "握手完成；等待本次連線的有效資料";
        else if (now < accepted || now - accepted > 4000) state = "握手完成；有效資料已過期";
        else state = "已連線；有效資料新鮮";
        StringBuilder text = new StringBuilder("Navipilot ").append(version)
            .append("\n目前狀態：").append(state)
            .append("\n目標連線：").append(endpoint)
            .append("\n最後有效資料：").append(accepted > 0 ? ago(now, accepted) : "尚無")
            .append("\n斷線／連線失敗事件：").append(failures).append(" 次")
            .append("\n其中車端回報 state_send_timeout：").append(reportedTimeouts).append(" 次")
            .append("\n握手完成：").append(handshakes).append(" 次")
            .append("\n中斷後有效資料恢復：").append(recoveries).append(" 次")
            .append("\n資料停滯強制重連：").append(forcedReconnects).append(" 次")
            .append("\n上次斷線／失敗（歷史）：").append(failureAt > 0 ? ago(now, failureAt) + "；" + failure : "無")
            .append("\n上次資料恢復：").append(recoveredAt > 0 ? ago(now, recoveredAt) : "尚無中斷後恢復紀錄")
            .append("\n最近資料拒收（歷史）：").append(rejected)
            .append("\n統計範圍：本次連線監測；重新開啟 App 或切換連線監測會重置")
            .append("\n最近事件（舊→新，最多 8 筆）：");
        if (events.isEmpty()) text.append("無");
        for (Event e : events) text.append("\n").append(ago(now, e.at)).append(" ").append(e.text);
        return text.toString();
    }
}
