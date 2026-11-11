.class public final Lcom/navipilot/obf/WideBridge;
.super Ljava/lang/Object;
.source "WideBridge.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideBridge$Pending;
    }
.end annotation


# static fields
.field private static volatile context:Landroid/content/Context;

.field private static volatile enabled:Z

.field private static volatile failedCount:J

.field private static volatile lastProbe:J

.field private static volatile lastQueue:Ljava/lang/String;

.field private static volatile lastReceipt:Ljava/lang/String;

.field private static volatile lastTarget:Ljava/lang/String;

.field private static volatile lastTelemetryLog:J

.field private static volatile loadStatus:Ljava/lang/String;

.field private static volatile matched:Lcom/navipilot/obf/WideRoad$Match;

.field private static volatile metadata:Ljava/lang/String;

.field private static final pending:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Lcom/navipilot/obf/WideBridge$Pending;",
            ">;"
        }
    .end annotation
.end field

.field private static final preparedTime:Ljava/lang/ThreadLocal;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ThreadLocal<",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile probeStatus:Ljava/lang/String;

.field private static final probing:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static volatile queueAt:J

.field private static volatile queuedCount:J

.field private static volatile ready:Z

.field private static volatile receiptAt:J

.field private static volatile receivedCount:J

.field private static volatile roads:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideRoad$Corridor;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile started:Z

.field private static final tracker:Lcom/navipilot/obf/WideRoad$Tracker;


# direct methods
.method static constructor <clinit>()V
    .locals 9

    .line 11
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideBridge;->roads:Ljava/util/List;

    .line 12
    new-instance v0, Lcom/navipilot/obf/WideRoad$Tracker;

    invoke-direct {v0}, Lcom/navipilot/obf/WideRoad$Tracker;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideBridge;->tracker:Lcom/navipilot/obf/WideRoad$Tracker;

    .line 13
    new-instance v1, Lcom/navipilot/obf/WideRoad$Match;

    const-string v6, "\u6b63\u5728\u8f09\u5165\u9053\u8def"

    const-wide/16 v7, 0x0

    const/4 v2, 0x0

    const-wide/16 v3, 0x0

    const/4 v5, 0x0

    invoke-direct/range {v1 .. v8}, Lcom/navipilot/obf/WideRoad$Match;-><init>(Lcom/navipilot/obf/WideRoad$Corridor;DILjava/lang/String;J)V

    sput-object v1, Lcom/navipilot/obf/WideBridge;->matched:Lcom/navipilot/obf/WideRoad$Match;

    .line 14
    new-instance v0, Ljava/lang/ThreadLocal;

    invoke-direct {v0}, Ljava/lang/ThreadLocal;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideBridge;->preparedTime:Ljava/lang/ThreadLocal;

    .line 15
    const-string v0, "\u9053\u8def\u672a\u8f09\u5165"

    sput-object v0, Lcom/navipilot/obf/WideBridge;->loadStatus:Ljava/lang/String;

    const-string v0, "\u7b49\u5f85\u539f\u6709\u5c0e\u822a\u901a\u9053"

    sput-object v0, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideBridge;->lastTarget:Ljava/lang/String;

    const-string v1, "C4 \u5c1a\u672a\u78ba\u8a8d"

    sput-object v1, Lcom/navipilot/obf/WideBridge;->lastReceipt:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideBridge;->metadata:Ljava/lang/String;

    .line 17
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideBridge;->probing:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 18
    const-string v0, "\u7b49\u5f85\u53ef\u6838\u5c0d\u7684\u6e2c\u901f\u5c01\u5305"

    sput-object v0, Lcom/navipilot/obf/WideBridge;->probeStatus:Ljava/lang/String;

    .line 19
    new-instance v0, Ljava/util/LinkedHashMap;

    invoke-direct {v0}, Ljava/util/LinkedHashMap;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V
    .locals 0

    .line 26
    invoke-static {p0}, Lcom/navipilot/obf/WideHcop;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V

    return-void
.end method

.method static synthetic access$0()Ljava/util/concurrent/atomic/AtomicBoolean;
    .locals 1

    .line 17
    sget-object v0, Lcom/navipilot/obf/WideBridge;->probing:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-object v0
.end method

.method static synthetic access$1()Z
    .locals 1

    .line 10
    sget-boolean v0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    return v0
.end method

.method static synthetic access$2(Ljava/lang/String;)V
    .locals 0

    .line 18
    sput-object p0, Lcom/navipilot/obf/WideBridge;->probeStatus:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$3()Ljava/lang/String;
    .locals 1

    .line 18
    sget-object v0, Lcom/navipilot/obf/WideBridge;->probeStatus:Ljava/lang/String;

    return-object v0
.end method

.method public static badge()Ljava/lang/String;
    .locals 6

    .line 93
    sget-boolean v0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-nez v0, :cond_0

    const-string v0, "\u9810\u89bd \u00b7 \u9ad8\u5fb7\u4f86\u6e90"

    return-object v0

    :cond_0
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    iget-boolean v0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-nez v0, :cond_1

    const-string v0, "\u53f0\u7063\u66ab\u7121\u8cc7\u6599"

    return-object v0

    :cond_1
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sget-wide v2, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    const-wide/16 v4, 0x0

    cmp-long v2, v2, v4

    if-lez v2, :cond_2

    sget-wide v2, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0x1388

    cmp-long v0, v0, v2

    if-gez v0, :cond_2

    const-string v0, "\u6700\u8fd1\u5df2\u63a5\u6536"

    goto :goto_0

    :cond_2
    const-string v0, "\u53f0\u7063\u5f85\u56de\u5831"

    :goto_0
    return-object v0
.end method

.method public static clear()V
    .locals 0

    .line 27
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->clear()V

    return-void
.end method

.method public static confirm(Lorg/json/JSONObject;Ljava/lang/String;)V
    .locals 12

    .line 82
    :try_start_0
    sget-boolean v0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-eqz v0, :cond_b

    const-string v0, "ok"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b

    const-string v0, "carrot_navi_receiver"

    const-string v1, "service"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    const-string v0, "control_connected"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_0

    goto/16 :goto_8

    .line 83
    :cond_0
    const-string v0, "items"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_1

    move-object v0, v1

    goto :goto_0

    :cond_1
    const-string v2, "json:speed"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    :goto_0
    if-eqz v0, :cond_a

    const-string v2, "present"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_2

    goto/16 :goto_7

    .line 84
    :cond_2
    const-string v2, "value"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    if-nez v2, :cond_3

    :goto_1
    goto :goto_2

    :cond_3
    const-string v1, "sdi"

    invoke-virtual {v2, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    goto :goto_1

    :goto_2
    if-nez v2, :cond_4

    return-void

    .line 85
    :cond_4
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "session_id"

    invoke-virtual {p0, v4}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, ":"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "sequence"

    const-wide/16 v5, -0x1

    invoke-virtual {v0, v4, v5, v6}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v4

    invoke-virtual {v3, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    sget-object v4, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    monitor-enter v4
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    sget-object v5, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    invoke-virtual {v5, v3}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/navipilot/obf/WideBridge$Pending;

    monitor-exit v4
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    .line 86
    :try_start_2
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v6

    if-eqz v5, :cond_9

    iget-wide v8, v5, Lcom/navipilot/obf/WideBridge$Pending;->time:J

    sub-long v8, v6, v8

    const-wide/16 v10, 0x1388

    cmp-long v4, v8, v10

    if-gtz v4, :cond_9

    iget-object v4, v5, Lcom/navipilot/obf/WideBridge$Pending;->host:Ljava/lang/String;

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_9

    const-string v4, "road_limit_kph"

    const/4 v8, -0x1

    invoke-virtual {v2, v4, v8}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v2

    iget v4, v5, Lcom/navipilot/obf/WideBridge$Pending;->road:I

    if-ne v2, v4, :cond_9

    const/4 v2, 0x1

    if-eqz v1, :cond_5

    move v4, v2

    goto :goto_3

    :cond_5
    const/4 v4, 0x0

    :goto_3
    iget-boolean v9, v5, Lcom/navipilot/obf/WideBridge$Pending;->sdi:Z

    if-ne v4, v9, :cond_9

    iget-boolean v4, v5, Lcom/navipilot/obf/WideBridge$Pending;->sdi:Z

    if-eqz v4, :cond_6

    const-string v4, "type"

    invoke-virtual {v1, v4, v8}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v4

    if-ne v4, v2, :cond_9

    const-string v2, "speed_limit_kph"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v2

    iget v4, v5, Lcom/navipilot/obf/WideBridge$Pending;->limit:I

    if-ne v2, v4, :cond_9

    const-string v2, "distance_m"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v1

    iget v2, v5, Lcom/navipilot/obf/WideBridge$Pending;->distance:I

    if-eq v1, v2, :cond_6

    goto/16 :goto_6

    .line 87
    :cond_6
    sget-object v1, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    monitor-enter v1
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    :try_start_3
    sget-object v2, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, v3}, Ljava/util/LinkedHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    monitor-exit v1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    sput-wide v6, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    sget-wide v1, Lcom/navipilot/obf/WideBridge;->receivedCount:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    sput-wide v1, Lcom/navipilot/obf/WideBridge;->receivedCount:J

    const-string v1, "\u63a5\u6536\u7aef\u5df2\u56de\u5831\u540c\u4e00\u5e8f\u865f"

    sput-object v1, Lcom/navipilot/obf/WideBridge;->probeStatus:Ljava/lang/String;

    .line 88
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "C4 \u63a5\u6536\u7aef\u5df2\u6536\u5230\uff1a\u9053\u8def "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v5, Lcom/navipilot/obf/WideBridge$Pending;->road:I

    if-lez v2, :cond_7

    iget v2, v5, Lcom/navipilot/obf/WideBridge$Pending;->road:I

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    goto :goto_4

    :cond_7
    const-string v2, "\u2014"

    :goto_4
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " km/h"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-boolean v2, v5, Lcom/navipilot/obf/WideBridge$Pending;->sdi:Z

    if-eqz v2, :cond_8

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\uff1b\u6e2c\u901f "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v3, v5, Lcom/navipilot/obf/WideBridge$Pending;->limit:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " km/h \u00b7 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget v3, v5, Lcom/navipilot/obf/WideBridge$Pending;->distance:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " m"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_5

    :cond_8
    const-string v2, ""

    :goto_5
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\uff08\u975e\u57f7\u884c\u78ba\u8a8d\uff09"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/navipilot/obf/WideBridge;->lastReceipt:Ljava/lang/String;

    .line 89
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "target"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string p1, "session"

    const-string v2, "session_id"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, p1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string p1, "speed_record"

    invoke-virtual {v1, p1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string p1, "cereal_error"

    const-string v0, "cereal_error"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p1, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string p0, "c4_receipt"

    invoke-static {p0, v1}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    goto :goto_9

    .line 87
    :catchall_0
    move-exception p0

    :try_start_5
    monitor-exit v1
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    :try_start_6
    throw p0
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_0

    .line 86
    :cond_9
    :goto_6
    return-void

    .line 85
    :catchall_1
    move-exception p0

    :try_start_7
    monitor-exit v4
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    :try_start_8
    throw p0
    :try_end_8
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_8} :catch_0

    .line 83
    :cond_a
    :goto_7
    return-void

    .line 82
    :cond_b
    :goto_8
    return-void

    .line 90
    :catch_0
    move-exception p0

    :goto_9
    nop

    .line 91
    return-void
.end method

.method public static current()Lcom/navipilot/obf/WideRoad$Match;
    .locals 10

    .line 29
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    .line 30
    iget-boolean v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v1, :cond_0

    iget-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v1, :cond_0

    new-instance v1, Lcom/navipilot/obf/WideRoad$Corridor;

    invoke-direct {v1}, Lcom/navipilot/obf/WideRoad$Corridor;-><init>()V

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iput-object v2, v1, Lcom/navipilot/obf/WideRoad$Corridor;->id:Ljava/lang/String;

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    iput-object v2, v1, Lcom/navipilot/obf/WideRoad$Corridor;->road:Ljava/lang/String;

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iput v2, v1, Lcom/navipilot/obf/WideRoad$Corridor;->limit:I

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-wide v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iput-wide v2, v1, Lcom/navipilot/obf/WideRoad$Corridor;->lat:D

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-wide v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    iput-wide v2, v1, Lcom/navipilot/obf/WideRoad$Corridor;->lon:D

    move-object v3, v1

    goto :goto_0

    .line 31
    :cond_0
    const/4 v1, 0x0

    move-object v3, v1

    :goto_0
    new-instance v2, Lcom/navipilot/obf/WideRoad$Match;

    iget-wide v4, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iget v6, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    iget-object v7, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    iget-wide v8, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    invoke-direct/range {v2 .. v9}, Lcom/navipilot/obf/WideRoad$Match;-><init>(Lcom/navipilot/obf/WideRoad$Corridor;DILjava/lang/String;J)V

    return-object v2
.end method

.method public static decision()Lorg/json/JSONObject;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 92
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->json()Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "enabled"

    sget-boolean v2, Lcom/navipilot/obf/WideBridge;->enabled:Z

    invoke-virtual {v0, v1, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    return-object v0
.end method

.method public static enabled()Z
    .locals 1

    .line 24
    sget-boolean v0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    return v0
.end method

.method public static declared-synchronized init(Landroid/content/Context;)V
    .locals 2

    const-class v0, Lcom/navipilot/obf/WideBridge;

    monitor-enter v0

    .line 22
    :try_start_0
    sget-boolean v1, Lcom/navipilot/obf/WideBridge;->started:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    monitor-exit v0

    return-void

    :cond_0
    const/4 v1, 0x1

    :try_start_1
    sput-boolean v1, Lcom/navipilot/obf/WideBridge;->started:Z

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideBridge;->context:Landroid/content/Context;

    sget-object p0, Lcom/navipilot/obf/WideBridge;->context:Landroid/content/Context;

    invoke-static {p0}, Lcom/navipilot/obf/WideBridgeLog;->init(Landroid/content/Context;)V

    sget-object p0, Lcom/navipilot/obf/WideBridge;->context:Landroid/content/Context;

    invoke-static {p0}, Lcom/navipilot/obf/WideHcop;->init(Landroid/content/Context;)V

    const/4 p0, 0x0

    sput-boolean p0, Lcom/navipilot/obf/WideBridge;->enabled:Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 23
    monitor-exit v0

    return-void

    .line 21
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0
.end method

.method private static map(Ljava/lang/Object;)Ljava/util/Map;
    .locals 1

    .line 58
    instance-of v0, p0, Ljava/util/Map;

    if-eqz v0, :cond_0

    check-cast p0, Ljava/util/Map;

    goto :goto_0

    :cond_0
    invoke-static {}, Ljava/util/Collections;->emptyMap()Ljava/util/Map;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method public static merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    .locals 13

    .line 34
    const-string v0, "speed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    return-object p1

    .line 35
    :cond_0
    sget-object p0, Lcom/navipilot/obf/WideBridge;->preparedTime:Ljava/lang/ThreadLocal;

    invoke-virtual {p0}, Ljava/lang/ThreadLocal;->remove()V

    sget-boolean p0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-nez p0, :cond_1

    return-object p1

    .line 37
    :cond_1
    :try_start_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    instance-of p2, p0, Ljava/lang/Number;

    const-wide/16 v5, 0x0

    if-eqz p2, :cond_2

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide v7

    goto :goto_0

    :cond_2
    move-wide v7, v5

    .line 38
    :goto_0
    cmp-long p0, v7, v5

    if-lez p0, :cond_3

    cmp-long p0, v1, v7

    if-ltz p0, :cond_3

    sub-long v9, v1, v7

    const-wide/16 v11, 0x7d0

    cmp-long p0, v9, v11

    if-gtz p0, :cond_3

    const/4 p0, 0x1

    goto :goto_1

    :cond_3
    const/4 p0, 0x0

    .line 39
    :goto_1
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object p2

    invoke-static {p1, p0, p2}, Lcom/navipilot/obf/WideHcopMerge;->merge(Lorg/json/JSONObject;ZLcom/navipilot/obf/WideHcopRoad$Decision;)Lorg/json/JSONObject;

    move-result-object v0

    .line 40
    iget-boolean v9, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v9, :cond_4

    iget-wide v9, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    sub-long/2addr v3, v9

    invoke-static {v5, v6, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v3

    sub-long/2addr v1, v3

    .line 41
    :cond_4
    if-eqz p0, :cond_5

    if-eqz p1, :cond_5

    if-eqz v0, :cond_5

    invoke-static {v1, v2, v7, v8}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    .line 42
    :cond_5
    sget-object p0, Lcom/navipilot/obf/WideBridge;->preparedTime:Ljava/lang/ThreadLocal;

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 43
    :catch_0
    move-exception p0

    const-string p1, "\u6e2c\u901f\u5408\u4f75\u5931\u6557\uff0c\u64a4\u92b7 speed \u6d41"

    sput-object p1, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    sget-object p1, Lcom/navipilot/obf/WideBridge;->preparedTime:Ljava/lang/ThreadLocal;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/ThreadLocal;->set(Ljava/lang/Object;)V

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object p0

    const-string p1, "merge_error"

    invoke-static {p1, p0}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method private static number(Ljava/lang/Object;)J
    .locals 2

    .line 59
    instance-of v0, p0, Ljava/lang/Number;

    if-eqz v0, :cond_0

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide v0

    goto :goto_0

    :cond_0
    const-wide/16 v0, -0x1

    :goto_0
    return-wide v0
.end method

.method private static probe(Ljava/lang/String;I)V
    .locals 6

    .line 69
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    sget-object v2, Lcom/navipilot/obf/WideBridge;->context:Landroid/content/Context;

    if-eqz v2, :cond_1

    sget-wide v2, Lcom/navipilot/obf/WideBridge;->lastProbe:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x7d0

    cmp-long v2, v2, v4

    if-ltz v2, :cond_1

    sget-object v2, Lcom/navipilot/obf/WideBridge;->probing:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v4}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v2

    if-nez v2, :cond_0

    goto :goto_0

    :cond_0
    sput-wide v0, Lcom/navipilot/obf/WideBridge;->lastProbe:J

    .line 70
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/navipilot/obf/WideBridge$1;

    invoke-direct {v1, p0, p1}, Lcom/navipilot/obf/WideBridge$1;-><init>(Ljava/lang/String;I)V

    .line 78
    nop

    .line 70
    const-string p0, "TaiwanReceipt"

    invoke-direct {v0, v1, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 78
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    .line 79
    return-void

    .line 69
    :cond_1
    :goto_0
    return-void
.end method

.method public static queued(Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;I)V
    .locals 8

    .line 48
    :try_start_0
    const-string v0, "json:speed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    return-void

    :cond_0
    new-instance p0, Lorg/json/JSONObject;

    invoke-direct {p0, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string p1, "value"

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object p1

    const/4 v0, 0x0

    if-nez p1, :cond_1

    move-object v1, v0

    goto :goto_0

    :cond_1
    const-string v1, "sdi"

    invoke-virtual {p1, v1}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    .line 49
    :goto_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-static {p3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v5, ":"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    sput-object v4, Lcom/navipilot/obf/WideBridge;->lastTarget:Ljava/lang/String;

    sput-wide v2, Lcom/navipilot/obf/WideBridge;->queueAt:J

    .line 50
    const-wide/16 v4, 0x1

    if-eqz p2, :cond_4

    sget-wide v6, Lcom/navipilot/obf/WideBridge;->queuedCount:J

    add-long/2addr v6, v4

    sput-wide v6, Lcom/navipilot/obf/WideBridge;->queuedCount:J

    if-eqz p1, :cond_3

    if-nez v1, :cond_2

    const-string v4, "road_limit_kph"

    invoke-virtual {p1, v4}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    :cond_2
    const-string v4, "\u901f\u9650\u8cc7\u6599\u5df2\u6392\u5165\u50b3\u9001"

    goto :goto_1

    :cond_3
    const-string v4, "\u901f\u9650\u64a4\u92b7\u5df2\u6392\u5165"

    goto :goto_1

    :cond_4
    sget-wide v6, Lcom/navipilot/obf/WideBridge;->failedCount:J

    add-long/2addr v6, v4

    sput-wide v6, Lcom/navipilot/obf/WideBridge;->failedCount:J

    const-string v4, "\u50b3\u9001\u4f47\u5217\u62d2\u6536"

    :goto_1
    sput-object v4, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    .line 51
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    const-string v5, "acceptedBySocketQueue"

    invoke-virtual {v4, v5, p2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v5, "target"

    invoke-virtual {v4, v5, p3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v5, "envelope"

    invoke-virtual {v4, v5, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v5, "mode"

    sget-boolean v6, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-eqz v6, :cond_5

    const-string v6, "taiwan"

    goto :goto_2

    :cond_5
    const-string v6, "amap"

    :goto_2
    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v5, "match"

    invoke-static {}, Lcom/navipilot/obf/WideBridge;->decision()Lorg/json/JSONObject;

    move-result-object v6

    invoke-virtual {v4, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v5, "speed_wire"

    invoke-static {v5, v4}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V

    .line 52
    sget-boolean v4, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-eqz v4, :cond_b

    if-eqz p2, :cond_b

    if-eqz p1, :cond_b

    if-nez v1, :cond_6

    const-string p2, "road_limit_kph"

    invoke-virtual {p1, p2}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result p2

    if-eqz p2, :cond_b

    :cond_6
    new-instance p2, Lcom/navipilot/obf/WideBridge$Pending;

    invoke-direct {p2, v0}, Lcom/navipilot/obf/WideBridge$Pending;-><init>(Lcom/navipilot/obf/WideBridge$Pending;)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-static {p3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v0, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, ":"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, p2, Lcom/navipilot/obf/WideBridge$Pending;->host:Ljava/lang/String;

    const-string v0, "road_limit_kph"

    const/4 v4, -0x1

    invoke-virtual {p1, v0, v4}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p1

    iput p1, p2, Lcom/navipilot/obf/WideBridge$Pending;->road:I

    const/4 p1, 0x0

    if-eqz v1, :cond_7

    const/4 v0, 0x1

    goto :goto_3

    :cond_7
    move v0, p1

    :goto_3
    iput-boolean v0, p2, Lcom/navipilot/obf/WideBridge$Pending;->sdi:Z

    if-nez v1, :cond_8

    move v0, p1

    goto :goto_4

    :cond_8
    const-string v0, "speed_limit_kph"

    invoke-virtual {v1, v0}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v0

    :goto_4
    iput v0, p2, Lcom/navipilot/obf/WideBridge$Pending;->limit:I

    if-nez v1, :cond_9

    :goto_5
    goto :goto_6

    :cond_9
    const-string p1, "distance_m"

    invoke-virtual {v1, p1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result p1

    goto :goto_5

    :goto_6
    iput p1, p2, Lcom/navipilot/obf/WideBridge$Pending;->distance:I

    iput-wide v2, p2, Lcom/navipilot/obf/WideBridge$Pending;->time:J

    .line 53
    sget-object p1, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    monitor-enter p1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :try_start_1
    sget-object v0, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "session_id"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, ":"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "sequence"

    invoke-virtual {p0, v2}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v1, v2, v3}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0, p2}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_7
    sget-object p0, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    invoke-virtual {p0}, Ljava/util/LinkedHashMap;->size()I

    move-result p0

    const/16 p2, 0x40

    if-gt p0, p2, :cond_a

    monitor-exit p1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 54
    :try_start_2
    invoke-static {p3, p4}, Lcom/navipilot/obf/WideBridge;->probe(Ljava/lang/String;I)V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    .line 56
    goto :goto_8

    .line 53
    :cond_a
    :try_start_3
    sget-object p0, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    sget-object p2, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    invoke-virtual {p2}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object p2

    invoke-interface {p2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    invoke-virtual {p0, p2}, Ljava/util/LinkedHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_7

    :catchall_0
    move-exception p0

    monitor-exit p1
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw p0
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0

    .line 56
    :catch_0
    move-exception p0

    const-string p0, "\u50b3\u9001\u8a3a\u65b7\u5931\u6557\uff08\u539f\u6709\u901a\u9053\u7e7c\u7e8c\uff09"

    sput-object p0, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    .line 57
    :cond_b
    :goto_8
    return-void
.end method

.method public static report()Ljava/lang/String;
    .locals 14

    .line 94
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Navipilot wide.16-hcop-tw-test\n\u4f86\u6e90\uff1a"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-boolean v3, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-eqz v3, :cond_0

    const-string v3, "HCOP \u53f0\u7063\u9053\u8def\uff0f\u6e2c\u901f\uff08\u6e2c\u8a66\uff09"

    goto :goto_0

    :cond_0
    const-string v3, "\u9ad8\u5fb7\uff1b\u53f0\u7063\u53ea\u9810\u89bd"

    :goto_0
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {}, Lcom/navipilot/obf/WideHcop;->report()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, "\n\u5c0e\u822a\u901a\u9053\uff1a\u539f\u6709 Navi v2 / 7714\n\u76ee\u6a19\uff1a"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v4, Lcom/navipilot/obf/WideBridge;->lastTarget:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v4, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-wide v4, Lcom/navipilot/obf/WideBridge;->queueAt:J

    const-wide/16 v6, 0x0

    cmp-long v4, v4, v6

    const-string v5, " \u79d2\u524d\uff09"

    const-wide/16 v8, 0x3e8

    const-string v10, "\uff08"

    const-string v11, ""

    if-lez v4, :cond_1

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-wide v12, Lcom/navipilot/obf/WideBridge;->queueAt:J

    sub-long v12, v0, v12

    div-long/2addr v12, v8

    invoke-virtual {v4, v12, v13}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    goto :goto_1

    :cond_1
    move-object v4, v11

    :goto_1
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v4, Lcom/navipilot/obf/WideBridge;->lastReceipt:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-wide v12, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    cmp-long v4, v12, v6

    if-lez v4, :cond_2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-wide v6, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    sub-long/2addr v0, v6

    div-long/2addr v0, v8

    invoke-virtual {v4, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v11

    :cond_2
    invoke-virtual {v2, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u4f47\u5217\u63a5\u53d7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-wide v1, Lcom/navipilot/obf/WideBridge;->queuedCount:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " / \u62d2\u6536 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-wide v1, Lcom/navipilot/obf/WideBridge;->failedCount:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " / \u540c\u5e8f\u865f\u63a5\u6536\u78ba\u8a8d "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-wide v1, Lcom/navipilot/obf/WideBridge;->receivedCount:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u63a5\u6536\u78ba\u8a8d\u4e0d\u4ee3\u8868\u5df2\u57f7\u884c\u6e1b\u901f\u3002\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideBridge;->probeStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/navipilot/obf/WideBridgeLog;->status()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static declared-synchronized setEnabled(Z)V
    .locals 10

    const-class v1, Lcom/navipilot/obf/WideBridge;

    monitor-enter v1

    .line 25
    :try_start_0
    sput-boolean p0, Lcom/navipilot/obf/WideBridge;->enabled:Z

    invoke-static {}, Lcom/navipilot/obf/WideHcop;->clear()V

    sget-object v0, Lcom/navipilot/obf/WideBridge;->tracker:Lcom/navipilot/obf/WideRoad$Tracker;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideRoad$Tracker;->reset()V

    new-instance v2, Lcom/navipilot/obf/WideRoad$Match;

    const-string v7, "\u4f86\u6e90\u5207\u63db\uff0c\u7b49\u5f85\u65b0\u5b9a\u4f4d"

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v8

    const/4 v3, 0x0

    const-wide/16 v4, 0x0

    const/4 v6, 0x0

    invoke-direct/range {v2 .. v9}, Lcom/navipilot/obf/WideRoad$Match;-><init>(Lcom/navipilot/obf/WideRoad$Corridor;DILjava/lang/String;J)V

    sput-object v2, Lcom/navipilot/obf/WideBridge;->matched:Lcom/navipilot/obf/WideRoad$Match;

    sget-object v2, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    monitor-enter v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    :try_start_1
    sget-object v0, Lcom/navipilot/obf/WideBridge;->pending:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V

    monitor-exit v2
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    const-wide/16 v2, 0x0

    :try_start_2
    sput-wide v2, Lcom/navipilot/obf/WideBridge;->receiptAt:J

    sput-wide v2, Lcom/navipilot/obf/WideBridge;->queueAt:J

    const-string v0, "\u7b49\u5f85\u539f\u6709\u5c0e\u822a\u901a\u9053\u66f4\u65b0"

    sput-object v0, Lcom/navipilot/obf/WideBridge;->lastQueue:Ljava/lang/String;

    const-string v0, "C4 \u5c1a\u672a\u78ba\u8a8d"

    sput-object v0, Lcom/navipilot/obf/WideBridge;->lastReceipt:Ljava/lang/String;

    const-string v0, "source"

    if-eqz p0, :cond_0

    const-string p0, "taiwan"

    goto :goto_0

    :cond_0
    const-string p0, "amap"

    :goto_0
    invoke-static {v0, p0}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    move-object p0, v0

    :try_start_3
    monitor-exit v2
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw p0

    .line 25
    :catchall_1
    move-exception v0

    move-object p0, v0

    monitor-exit v1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    throw p0
.end method

.method public static telemetry(Lcom/navipilot/obf/zg;Ljava/lang/String;)V
    .locals 9

    .line 62
    const-string v0, "carrotMan"

    const-string v1, "carrotNavi"

    if-nez p0, :cond_0

    return-void

    :cond_0
    :try_start_0
    invoke-virtual {p0, v1}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object v2

    if-nez v2, :cond_1

    return-void

    :cond_1
    iget-object v2, v2, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v2, v2, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    .line 63
    const-string v3, "speed"

    invoke-interface {v2, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Lcom/navipilot/obf/WideBridge;->map(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object v3

    const-string v4, "meta"

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v3}, Lcom/navipilot/obf/WideBridge;->map(Ljava/lang/Object;)Ljava/util/Map;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    .line 64
    sget-wide v5, Lcom/navipilot/obf/WideBridge;->lastTelemetryLog:J

    sub-long v5, v3, v5

    const-wide/16 v7, 0x3e8

    cmp-long v5, v5, v7

    if-lez v5, :cond_3

    sput-wide v3, Lcom/navipilot/obf/WideBridge;->lastTelemetryLog:J

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    const-string v4, "target"

    invoke-virtual {v3, v4, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    new-instance p1, Lorg/json/JSONObject;

    invoke-direct {p1, v2}, Lorg/json/JSONObject;-><init>(Ljava/util/Map;)V

    invoke-virtual {v3, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    invoke-virtual {p0, v0}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object p0

    if-eqz p0, :cond_2

    new-instance p1, Lorg/json/JSONObject;

    iget-object p0, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object p0, p0, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    invoke-direct {p1, p0}, Lorg/json/JSONObject;-><init>(Ljava/util/Map;)V

    invoke-virtual {v3, v0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    :cond_2
    const-string p0, "c4_telemetry"

    invoke-static {p0, v3}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 65
    :catch_0
    move-exception p0

    :goto_0
    nop

    .line 66
    :cond_3
    return-void
.end method

.method public static timestamp(Ljava/lang/String;J)J
    .locals 2

    .line 45
    sget-object v0, Lcom/navipilot/obf/WideBridge;->preparedTime:Ljava/lang/ThreadLocal;

    invoke-virtual {v0}, Ljava/lang/ThreadLocal;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Long;

    sget-boolean v1, Lcom/navipilot/obf/WideBridge;->enabled:Z

    if-eqz v1, :cond_0

    const-string v1, "speed"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_0

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide p1

    :cond_0
    return-wide p1
.end method
