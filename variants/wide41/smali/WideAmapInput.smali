.class public final Lcom/navipilot/obf/WideAmapInput;
.super Ljava/lang/Object;
.source "WideAmapInput.java"


# static fields
.field private static accepted:J

.field private static action:Ljava/lang/String;

.field private static forwardAt:J

.field private static key:Ljava/lang/String;

.field private static lastAt:J

.field private static parsedAt:J

.field private static rejected:J

.field private static seen:J

.field private static selected:Ljava/lang/String;

.field private static sender:Ljava/lang/String;

.field private static stream:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 5
    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideAmapInput;->selected:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideAmapInput;->sender:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideAmapInput;->action:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideAmapInput;->key:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideAmapInput;->stream:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 3
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized forwarded(Ljava/lang/String;)V
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideAmapInput;

    monitor-enter v0

    .line 12
    :try_start_0
    sput-object p0, Lcom/navipilot/obf/WideAmapInput;->stream:Ljava/lang/String;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->forwardAt:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 12
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static declared-synchronized observed(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V
    .locals 5

    const-class v0, Lcom/navipilot/obf/WideAmapInput;

    monitor-enter v0

    .line 8
    :try_start_0
    sget-wide v1, Lcom/navipilot/obf/WideAmapInput;->seen:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->seen:J

    if-eqz p3, :cond_0

    sget-wide v1, Lcom/navipilot/obf/WideAmapInput;->accepted:J

    add-long/2addr v1, v3

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->accepted:J

    goto :goto_0

    :cond_0
    sget-wide v1, Lcom/navipilot/obf/WideAmapInput;->rejected:J

    add-long/2addr v1, v3

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->rejected:J

    .line 9
    :goto_0
    sput-object p0, Lcom/navipilot/obf/WideAmapInput;->selected:Ljava/lang/String;

    if-eqz p1, :cond_1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    if-nez p0, :cond_2

    :cond_1
    const-string p1, "\u7cfb\u7d71\u672a\u63d0\u4f9b\u4f86\u6e90\u5957\u4ef6"

    :cond_2
    sput-object p1, Lcom/navipilot/obf/WideAmapInput;->sender:Ljava/lang/String;

    sput-object p2, Lcom/navipilot/obf/WideAmapInput;->action:Ljava/lang/String;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p0

    sput-wide p0, Lcom/navipilot/obf/WideAmapInput;->lastAt:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 10
    monitor-exit v0

    return-void

    .line 7
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static declared-synchronized parsed(I)V
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideAmapInput;

    monitor-enter v0

    .line 11
    if-gez p0, :cond_0

    :try_start_0
    const-string p0, "\u7f3a\u5c11 KEY_TYPE\uff0c\u4e0d\u80fd\u8996\u70ba\u5c0e\u822a\u8cc7\u6599"

    goto :goto_0

    :cond_0
    invoke-static {p0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object p0

    :goto_0
    sput-object p0, Lcom/navipilot/obf/WideAmapInput;->key:Ljava/lang/String;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->parsedAt:J
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 11
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static declared-synchronized reset()V
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideAmapInput;

    monitor-enter v0

    .line 6
    const-wide/16 v1, 0x0

    :try_start_0
    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->forwardAt:J

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->parsedAt:J

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->lastAt:J

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->rejected:J

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->accepted:J

    sput-wide v1, Lcom/navipilot/obf/WideAmapInput;->seen:J

    const-string v1, ""

    sput-object v1, Lcom/navipilot/obf/WideAmapInput;->stream:Ljava/lang/String;

    sput-object v1, Lcom/navipilot/obf/WideAmapInput;->key:Ljava/lang/String;

    sput-object v1, Lcom/navipilot/obf/WideAmapInput;->action:Ljava/lang/String;

    sput-object v1, Lcom/navipilot/obf/WideAmapInput;->sender:Ljava/lang/String;

    sput-object v1, Lcom/navipilot/obf/WideAmapInput;->selected:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 6
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method public static declared-synchronized status(Ljava/lang/String;)Ljava/lang/String;
    .locals 11

    const-class v0, Lcom/navipilot/obf/WideAmapInput;

    monitor-enter v0

    .line 14
    :try_start_0
    sget-wide v1, Lcom/navipilot/obf/WideAmapInput;->seen:J

    const-wide/16 v3, 0x0

    cmp-long v1, v1, v3

    if-nez v1, :cond_0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string p0, "\n\u5c1a\u672a\u6536\u5230\u5c0e\u822a\u5ee3\u64ad\uff1b\u958b\u555f\u5730\u5716\u4e0d\u4ee3\u8868\u5df2\u6709\u5c0e\u822a\u8cc7\u6599"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object p0

    .line 15
    :cond_0
    :try_start_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    .line 16
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v5, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string p0, "\n\u63a5\u6536 "

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->seen:J

    invoke-virtual {p0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, "\uff0f\u5141\u8a31 "

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->accepted:J

    invoke-virtual {p0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, "\uff0f\u904e\u6ffe "

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->rejected:J

    invoke-virtual {p0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, " \u00b7 "

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->lastAt:J

    sub-long v5, v1, v5

    const-wide/16 v7, 0x3e8

    div-long/2addr v5, v7

    invoke-static {v3, v4, v5, v6}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v5

    invoke-virtual {p0, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, " \u79d2\u524d"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 17
    const-string v5, "\n\u9078\u64c7\uff1a"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-object v5, Lcom/navipilot/obf/WideAmapInput;->selected:Ljava/lang/String;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, "\n\u4f86\u6e90\uff1a"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-object v5, Lcom/navipilot/obf/WideAmapInput;->sender:Ljava/lang/String;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v5, "\n\u5ee3\u64ad\uff1a"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-object v5, Lcom/navipilot/obf/WideAmapInput;->action:Ljava/lang/String;

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 18
    const-string v5, "\n\u89e3\u6790\u5165\u53e3\uff1a"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->parsedAt:J

    cmp-long v5, v5, v3

    if-nez v5, :cond_1

    const-string v5, "\u5c1a\u672a\u9032\u5165"

    goto :goto_0

    :cond_1
    new-instance v5, Ljava/lang/StringBuilder;

    sget-object v6, Lcom/navipilot/obf/WideAmapInput;->key:Ljava/lang/String;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, " \u00b7 "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget-wide v9, Lcom/navipilot/obf/WideAmapInput;->parsedAt:J

    sub-long v9, v1, v9

    div-long/2addr v9, v7

    invoke-static {v3, v4, v9, v10}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v9

    invoke-virtual {v5, v9, v10}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, " \u79d2\u524d"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    :goto_0
    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 19
    const-string v5, "\n\u901a\u904e\u4f86\u6e90\u904e\u6ffe\uff1a"

    invoke-virtual {p0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    sget-wide v5, Lcom/navipilot/obf/WideAmapInput;->forwardAt:J

    cmp-long v5, v5, v3

    if-nez v5, :cond_2

    const-string v1, "\u5c1a\u7121\u53ef\u9001\u51fa\u7684\u8cc7\u6599"

    goto :goto_1

    :cond_2
    new-instance v5, Ljava/lang/StringBuilder;

    sget-object v6, Lcom/navipilot/obf/WideAmapInput;->stream:Ljava/lang/String;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, " \u00b7 "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    sget-wide v9, Lcom/navipilot/obf/WideAmapInput;->forwardAt:J

    sub-long/2addr v1, v9

    div-long/2addr v1, v7

    invoke-static {v3, v4, v1, v2}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v1

    invoke-virtual {v5, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u79d2\u524d"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_1
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 20
    const-string v1, "\n\u4ee5\u4e0a\u662f\u624b\u6a5f\u7aef\u8655\u7406\u72c0\u614b\uff0c\u4e0d\u4ee3\u8868 C4 \u5df2\u6536\u5230\u3002"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    .line 16
    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v0

    return-object p0

    .line 13
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method
