.class public final Lcom/navipilot/obf/WideHcop;
.super Ljava/lang/Object;
.source "WideHcop.java"


# static fields
.field private static final MAX_WALL:J = 0x1a3bb705c00L

.field private static final MIN_WALL:J = 0x1a18f418c00L

.field private static available:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private static final cache:Ljava/util/LinkedHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashMap<",
            "Ljava/lang/String;",
            "Lcom/navipilot/obf/WideHcopRoad$Data;",
            ">;"
        }
    .end annotation
.end field

.field private static context:Landroid/content/Context;

.field private static volatile decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

.field private static volatile error:Ljava/lang/String;

.field private static generation:I

.field private static latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

.field private static volatile metadata:Ljava/lang/String;

.field private static volatile ready:Z

.field private static started:Z

.field private static volatile summary:Ljava/lang/String;

.field private static final tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

.field private static window:Lcom/navipilot/obf/WideHcopRoad$Data;

.field private static windowX:I

.field private static windowY:I

.field private static working:Z


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 14
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u6b63\u5728\u8f09\u5165\u96e2\u7dda\u9053\u8def"

    const-wide/16 v2, 0x0

    invoke-direct {v0, v1, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    sput-object v0, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 15
    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideHcop;->metadata:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideHcop;->error:Ljava/lang/String;

    const-string v0, "\u6b63\u5728\u8f09\u5165\u5716\u8cc7"

    sput-object v0, Lcom/navipilot/obf/WideHcop;->summary:Ljava/lang/String;

    .line 16
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Tracker;

    invoke-direct {v0}, Lcom/navipilot/obf/WideHcopRoad$Tracker;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideHcop;->tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

    .line 17
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideHcop;->available:Ljava/util/Set;

    .line 18
    new-instance v0, Ljava/util/LinkedHashMap;

    const/high16 v1, 0x3f400000    # 0.75f

    const/4 v2, 0x1

    const/16 v3, 0x20

    invoke-direct {v0, v3, v1, v2}, Ljava/util/LinkedHashMap;-><init>(IFZ)V

    sput-object v0, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    .line 19
    const/high16 v0, -0x80000000

    sput v0, Lcom/navipilot/obf/WideHcop;->windowX:I

    .line 20
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V
    .locals 4

    const-class v0, Lcom/navipilot/obf/WideHcop;

    monitor-enter v0

    .line 60
    :try_start_0
    sput-object p0, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 61
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    invoke-static {p0, v1, v2}, Lcom/navipilot/obf/WideHcopRoad;->invalid(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Ljava/lang/String;

    move-result-object p0

    .line 62
    const/4 v1, 0x1

    if-eqz p0, :cond_0

    sget v2, Lcom/navipilot/obf/WideHcop;->generation:I

    add-int/2addr v2, v1

    sput v2, Lcom/navipilot/obf/WideHcop;->generation:I

    sget-object v1, Lcom/navipilot/obf/WideHcop;->tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

    invoke-virtual {v1}, Lcom/navipilot/obf/WideHcopRoad$Tracker;->reset()V

    new-instance v1, Lcom/navipilot/obf/WideHcopRoad$Decision;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-direct {v1, p0, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    sput-object v1, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;
    sget-object p0, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraTrace;->eligible(Lcom/navipilot/obf/WideCameraEngine$Fix;)Z
    move-result p0
    if-eqz p0, :alert_invalid_return
    const/4 v1, 0x1
    goto :cond_0
    :alert_invalid_return
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 63
    :cond_0
    :try_start_1
    sget-boolean p0, Lcom/navipilot/obf/WideHcop;->ready:Z

    if-nez p0, :cond_2

    new-instance p0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    sget-object v1, Lcom/navipilot/obf/WideHcop;->error:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    sget-object v1, Lcom/navipilot/obf/WideHcop;->summary:Ljava/lang/String;

    goto :goto_0

    :cond_1
    sget-object v1, Lcom/navipilot/obf/WideHcop;->error:Ljava/lang/String;

    :goto_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-direct {p0, v1, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    sput-object p0, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v0

    return-void

    .line 64
    :cond_2
    :try_start_2
    sget-boolean p0, Lcom/navipilot/obf/WideHcop;->working:Z
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz p0, :cond_3

    monitor-exit v0

    return-void

    :cond_3
    :try_start_3
    sput-boolean v1, Lcom/navipilot/obf/WideHcop;->working:Z

    .line 65
    new-instance p0, Ljava/lang/Thread;

    new-instance v1, Lcom/navipilot/obf/WideHcop$2;

    invoke-direct {v1}, Lcom/navipilot/obf/WideHcop$2;-><init>()V

    const-string v2, "HcopRoadMatch"

    invoke-direct {p0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Thread;->start()V
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 66
    monitor-exit v0

    return-void

    .line 59
    :catchall_0
    move-exception p0

    :try_start_4
    monitor-exit v0
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    throw p0
.end method

.method static synthetic access$0()Landroid/content/Context;
    .locals 1

    .line 12
    sget-object v0, Lcom/navipilot/obf/WideHcop;->context:Landroid/content/Context;

    return-object v0
.end method

.method static synthetic access$1(Ljava/io/InputStream;)Ljava/lang/String;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 30
    invoke-static {p0}, Lcom/navipilot/obf/WideHcop;->read(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2(Ljava/lang/String;)V
    .locals 0

    .line 15
    sput-object p0, Lcom/navipilot/obf/WideHcop;->metadata:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$3(Ljava/util/Set;)V
    .locals 0

    .line 17
    sput-object p0, Lcom/navipilot/obf/WideHcop;->available:Ljava/util/Set;

    return-void
.end method

.method static synthetic access$4(Ljava/lang/String;)V
    .locals 0

    .line 15
    sput-object p0, Lcom/navipilot/obf/WideHcop;->summary:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$5(Z)V
    .locals 0

    .line 13
    sput-boolean p0, Lcom/navipilot/obf/WideHcop;->ready:Z

    return-void
.end method

.method static synthetic access$6(Ljava/lang/String;)V
    .locals 0

    .line 15
    sput-object p0, Lcom/navipilot/obf/WideHcop;->error:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$7()V
    .locals 0

    .line 67
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->drain()V

    return-void
.end method

.method public static declared-synchronized clear()V
    .locals 5

    const-class v0, Lcom/navipilot/obf/WideHcop;

    monitor-enter v0

    .line 82
    :try_start_0
    sget v1, Lcom/navipilot/obf/WideHcop;->generation:I

    add-int/lit8 v1, v1, 0x1

    sput v1, Lcom/navipilot/obf/WideHcop;->generation:I

    const/4 v1, 0x0

    sput-object v1, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {}, Lcom/navipilot/obf/WideCameraTrace;->clear()V

    sget-object v1, Lcom/navipilot/obf/WideHcop;->tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

    invoke-virtual {v1}, Lcom/navipilot/obf/WideHcopRoad$Tracker;->reset()V

    new-instance v1, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v2, "\u7b49\u5f85\u65b0\u5b9a\u4f4d"

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    invoke-direct {v1, v2, v3, v4}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    sput-object v1, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 82
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method public static current()Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 7

    .line 84
    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->running:Z

    if-nez v0, :cond_0

    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "GPS \u672a\u555f\u52d5"

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-direct {v0, v1, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    return-object v0

    .line 85
    :cond_0
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    invoke-static {}, Lcom/navipilot/obf/WideCamera;->fix()Lcom/navipilot/obf/WideCameraEngine$Fix;

    move-result-object v2

    invoke-static {v2, v0, v1}, Lcom/navipilot/obf/WideHcopRoad;->invalid(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Ljava/lang/String;

    move-result-object v2

    .line 86
    if-eqz v2, :cond_1

    new-instance v3, Lcom/navipilot/obf/WideHcopRoad$Decision;

    invoke-direct {v3, v2, v0, v1}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    return-object v3

    .line 87
    :cond_1
    sget-object v2, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    iget-wide v3, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    cmp-long v3, v0, v3

    if-ltz v3, :cond_3

    iget-wide v3, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    sub-long v3, v0, v3

    const-wide/16 v5, 0xbb8

    cmp-long v3, v3, v5

    if-lez v3, :cond_2

    goto :goto_0

    .line 88
    :cond_2
    return-object v2

    .line 87
    :cond_3
    :goto_0
    new-instance v2, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v3, "\u914d\u5c0d\u5df2\u904e\u671f"

    invoke-direct {v2, v3, v0, v1}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    return-object v2
.end method

.method private static drain()V
    .locals 10

    .line 68
    nop

    :goto_0
    const-class v0, Lcom/navipilot/obf/WideHcop;

    monitor-enter v0

    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

    sget v2, Lcom/navipilot/obf/WideHcop;->generation:I

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 69
    nop

    .line 70
    const/4 v0, 0x0

    if-eqz v1, :cond_0

    :try_start_1
    invoke-static {v1}, Lcom/navipilot/obf/WideHcop;->load(Lcom/navipilot/obf/WideCameraEngine$Fix;)Lcom/navipilot/obf/WideHcopRoad$Data;

    move-result-object v3
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_1

    :catch_0
    move-exception v3

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "\u5716\u8cc7\u8b80\u53d6\u5931\u6557\uff1a"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    move-object v9, v3

    move-object v3, v0

    move-object v0, v9

    goto :goto_1

    :cond_0
    move-object v3, v0

    .line 71
    :goto_1
    const-class v4, Lcom/navipilot/obf/WideHcop;

    monitor-enter v4

    .line 72
    :try_start_2
    sget v5, Lcom/navipilot/obf/WideHcop;->generation:I

    const/4 v6, 0x0

    if-ne v2, v5, :cond_4

    sget-object v2, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-ne v1, v2, :cond_4

    .line 73
    if-nez v0, :cond_1

    sget-object v2, Lcom/navipilot/obf/WideHcop;->tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v7

    invoke-virtual {v2, v3, v1, v7, v8}, Lcom/navipilot/obf/WideHcopRoad$Tracker;->accept(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v2

    invoke-static {v3, v1, v7, v8}, Lcom/navipilot/obf/WideCameraTrace;->update(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V

    goto :goto_2

    :cond_1
    new-instance v2, Lcom/navipilot/obf/WideHcopRoad$Decision;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v7

    invoke-direct {v2, v0, v7, v8}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    :goto_2
    sput-object v2, Lcom/navipilot/obf/WideHcop;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 74
    if-eqz v0, :cond_2

    sget-object v0, Lcom/navipilot/obf/WideHcop;->tracker:Lcom/navipilot/obf/WideHcopRoad$Tracker;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideHcopRoad$Tracker;->reset()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 75
    :cond_2
    :try_start_3
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->json()Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v1, :cond_3

    const-string v2, "latitude"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "longitude"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "accuracy_m"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "heading_deg"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "speed_mps"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "gps_mono_ms"

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-virtual {v0, v2, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    :cond_3
    const-string v1, "hcop_match"

    invoke-static {v1, v0}, Lcom/navipilot/obf/WideBridgeLog;->event(Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_3

    :catch_1
    move-exception v0

    .line 76
    :goto_3
    :try_start_4
    sput-boolean v6, Lcom/navipilot/obf/WideHcop;->working:Z

    monitor-exit v4

    return-void

    .line 78
    :cond_4
    sget-object v0, Lcom/navipilot/obf/WideHcop;->latest:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-nez v0, :cond_5

    sput-boolean v6, Lcom/navipilot/obf/WideHcop;->working:Z

    monitor-exit v4

    return-void

    .line 71
    :cond_5
    monitor-exit v4

    goto/16 :goto_0

    :catchall_0
    move-exception v0

    monitor-exit v4
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    throw v0

    .line 68
    :catchall_1
    move-exception v1

    :try_start_5
    monitor-exit v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    throw v1
.end method

.method public static declared-synchronized init(Landroid/content/Context;)V
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideHcop;

    monitor-enter v0

    .line 22
    :try_start_0
    sget-boolean v1, Lcom/navipilot/obf/WideHcop;->started:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v1, :cond_0

    monitor-exit v0

    return-void

    :cond_0
    const/4 v1, 0x1

    :try_start_1
    sput-boolean v1, Lcom/navipilot/obf/WideHcop;->started:Z

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideHcop;->context:Landroid/content/Context;

    .line 23
    new-instance p0, Ljava/lang/Thread;

    new-instance v1, Lcom/navipilot/obf/WideHcop$1;

    invoke-direct {v1}, Lcom/navipilot/obf/WideHcop$1;-><init>()V

    .line 28
    const-string v2, "HcopMapInit"

    .line 23
    invoke-direct {p0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 28
    invoke-virtual {p0}, Ljava/lang/Thread;->start()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 29
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

.method public static json()Lorg/json/JSONObject;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 91
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "confirmed"

    iget-boolean v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v2, "reason"

    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "road"

    invoke-virtual {v0}, Lcom/navipilot/obf/WideHcopRoad$Decision;->roadName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "source"

    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "road_limit_kph"

    iget v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "gps_mono_ms"

    iget-wide v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    invoke-virtual {v1, v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 92
    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    if-eqz v2, :cond_0

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    const-string v3, "edge"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "direction"

    iget v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    invoke-virtual {v1, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "offset_m"

    iget-wide v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->offset:D

    invoke-virtual {v1, v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 93
    :cond_0
    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v2, :cond_1

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    const-string v3, "cameraId"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget v2, v2, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    const-string v3, "camera_limit_kph"

    invoke-virtual {v1, v3, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    iget-wide v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    invoke-static {v2, v3}, Ljava/lang/Math;->round(D)J

    move-result-wide v2

    const-string v0, "along_road_m"

    invoke-virtual {v1, v0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    :cond_1
    return-object v1
.end method

.method public static label()Ljava/lang/String;
    .locals 5

    .line 95
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u9053\u8def\u901f\u9650 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-boolean v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v2, :cond_0

    iget v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    if-lez v2, :cond_0

    new-instance v2, Ljava/lang/StringBuilder;

    iget v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v3, " km/h \u00b7 "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_0

    :cond_0
    const-string v2, "\u2014"

    :goto_0
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\n"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    const-string v3, ""

    if-eqz v2, :cond_1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideHcopRoad$Decision;->roadName()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, " \u00b7 "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    goto :goto_1

    :cond_1
    move-object v2, v3

    :goto_1
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/navipilot/obf/WideBridge;->enabled()Z

    move-result v1

    if-eqz v1, :cond_2

    goto :goto_2

    :cond_2
    const-string v3, "\uff08\u9810\u89bd\uff09"

    :goto_2
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static load(Lcom/navipilot/obf/WideCameraEngine$Fix;)Lcom/navipilot/obf/WideHcopRoad$Data;
    .locals 13
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 46
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Data;

    invoke-direct {v0}, Lcom/navipilot/obf/WideHcopRoad$Data;-><init>()V

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v1

    const-wide v3, 0x1a18f418c00L

    cmp-long v1, v1, v3

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-ltz v1, :cond_0

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    const-wide v6, 0x1a3bb705c00L

    cmp-long v1, v4, v6

    if-gez v1, :cond_0

    move v1, v2

    goto :goto_0

    :cond_0
    move v1, v3

    :goto_0
    iput-boolean v1, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    .line 47
    iget-boolean v1, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-eqz v1, :cond_1

    return-object v0

    .line 48
    :cond_1
    iget-wide v4, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    const-wide v6, 0x3f947ae147ae147bL    # 0.02

    div-double/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->floor(D)D

    move-result-wide v4

    double-to-int v1, v4

    iget-wide v4, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    div-double/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Math;->floor(D)D

    move-result-wide v4

    double-to-int p0, v4

    .line 49
    sget-object v4, Lcom/navipilot/obf/WideHcop;->window:Lcom/navipilot/obf/WideHcopRoad$Data;

    if-eqz v4, :cond_2

    sget v4, Lcom/navipilot/obf/WideHcop;->windowX:I

    if-ne v4, v1, :cond_2

    sget v4, Lcom/navipilot/obf/WideHcop;->windowY:I

    if-ne v4, p0, :cond_2

    sget-object p0, Lcom/navipilot/obf/WideHcop;->window:Lcom/navipilot/obf/WideHcopRoad$Data;

    iput-boolean v2, p0, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    sget-object p0, Lcom/navipilot/obf/WideHcop;->window:Lcom/navipilot/obf/WideHcopRoad$Data;

    return-object p0

    .line 50
    :cond_2
    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    new-instance v4, Ljava/util/HashSet;

    invoke-direct {v4}, Ljava/util/HashSet;-><init>()V

    new-instance v5, Ljava/util/HashSet;

    invoke-direct {v5}, Ljava/util/HashSet;-><init>()V

    .line 51
    const/4 v3, 0x2

    const/4 v6, -0x2

    move v7, v6

    :goto_1
    if-le v7, v3, :cond_3

    .line 57
    sput v1, Lcom/navipilot/obf/WideHcop;->windowX:I

    sput p0, Lcom/navipilot/obf/WideHcop;->windowY:I

    sput-object v0, Lcom/navipilot/obf/WideHcop;->window:Lcom/navipilot/obf/WideHcopRoad$Data;

    return-object v0

    .line 51
    :cond_3
    move v8, v6

    :goto_2
    if-le v8, v3, :cond_4

    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    .line 52
    :cond_4
    new-instance v9, Ljava/lang/StringBuilder;

    add-int v10, v1, v7

    invoke-static {v10}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v10

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v10, "_"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    add-int v10, p0, v8

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, ".json.gz"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v9}, Lcom/navipilot/obf/WideHcop;->tile(Ljava/lang/String;)Lcom/navipilot/obf/WideHcopRoad$Data;

    move-result-object v9

    .line 53
    iget-object v10, v9, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v10}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v10

    :cond_5
    :goto_3
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v11

    if-nez v11, :cond_a

    .line 54
    iget-object v10, v9, Lcom/navipilot/obf/WideHcopRoad$Data;->cameras:Ljava/util/List;

    invoke-interface {v10}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v11

    :cond_6
    :goto_4
    invoke-interface {v11}, Ljava/util/Iterator;->hasNext()Z

    move-result v10

    if-nez v10, :cond_9

    .line 55
    iget-object v9, v9, Lcom/navipilot/obf/WideHcopRoad$Data;->signs:Ljava/util/List;

    invoke-interface {v9}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v10

    :cond_7
    :goto_5
    invoke-interface {v10}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-nez v9, :cond_8

    .line 51
    add-int/lit8 v8, v8, 0x1

    goto :goto_2

    .line 55
    :cond_8
    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/navipilot/obf/WideHcopRoad$Official;

    iget v11, v9, Lcom/navipilot/obf/WideHcopRoad$Official;->id:I

    invoke-static {v11}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v11

    invoke-interface {v5, v11}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_7

    iget-object v11, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->signs:Ljava/util/List;

    invoke-interface {v11, v9}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_5

    .line 54
    :cond_9
    invoke-interface {v11}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v10

    check-cast v10, Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object v12, v10, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    invoke-interface {v4, v12}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v12

    if-eqz v12, :cond_6

    iget-object v12, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->cameras:Ljava/util/List;

    invoke-interface {v12, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_4

    .line 53
    :cond_a
    invoke-interface {v10}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v11

    check-cast v11, Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v12, v11, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-interface {v2, v12}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v12

    if-eqz v12, :cond_5

    iget-object v12, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v12, v11}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_3
.end method

.method private static points(Lorg/json/JSONArray;)[[D
    .locals 7
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 32
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v0

    const/4 v1, 0x2

    new-array v2, v1, [I

    const/4 v3, 0x1

    aput v1, v2, v3

    const/4 v1, 0x0

    aput v0, v2, v1

    sget-object v0, Ljava/lang/Double;->TYPE:Ljava/lang/Class;

    invoke-static {v0, v2}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;[I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [[D

    move v2, v1

    :goto_0
    array-length v4, v0

    if-lt v2, v4, :cond_0

    return-object v0

    :cond_0
    aget-object v4, v0, v2

    invoke-virtual {p0, v2}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v5

    invoke-virtual {v5, v1}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v5

    aput-wide v5, v4, v1

    aget-object v4, v0, v2

    invoke-virtual {p0, v2}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v5

    invoke-virtual {v5, v3}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v5

    aput-wide v5, v4, v3

    add-int/lit8 v2, v2, 0x1

    goto :goto_0
.end method

.method private static read(Ljava/io/InputStream;)Ljava/lang/String;
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 30
    :try_start_0
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v1, 0x2000

    new-array v1, v1, [B

    :goto_0
    invoke-virtual {p0, v1}, Ljava/io/InputStream;->read([B)I

    move-result v2

    const/4 v3, -0x1

    if-ne v2, v3, :cond_0

    new-instance v1, Ljava/lang/String;

    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0

    const-string v2, "UTF-8"

    invoke-direct {v1, v0, v2}, Ljava/lang/String;-><init>([BLjava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    return-object v1

    :cond_0
    :try_start_1
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v3

    add-int/2addr v3, v2

    const/high16 v4, 0xc00000

    if-gt v3, v4, :cond_1

    const/4 v3, 0x0

    invoke-virtual {v0, v1, v3, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    :cond_1
    new-instance v0, Ljava/io/IOException;

    const-string v1, "tile too large"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :catchall_0
    move-exception v0

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    throw v0
.end method

.method public static report()Ljava/lang/String;
    .locals 3

    .line 96
    new-instance v0, Ljava/lang/StringBuilder;

    sget-object v1, Lcom/navipilot/obf/WideHcop;->summary:Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/navipilot/obf/WideHcop;->label()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v2, Lcom/navipilot/obf/WideHcop;->error:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideHcop;->metadata:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static strings(Lorg/json/JSONArray;)[Ljava/lang/String;
    .locals 4
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 31
    invoke-virtual {p0}, Lorg/json/JSONArray;->length()I

    move-result v0

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    :goto_0
    if-lt v2, v0, :cond_0

    return-object v1

    :cond_0
    invoke-virtual {p0, v2}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v1, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0
.end method

.method private static tile(Ljava/lang/String;)Lcom/navipilot/obf/WideHcopRoad$Data;
    .locals 16
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 34
    move-object/from16 v0, p0

    sget-object v1, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    invoke-virtual {v1, v0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideHcopRoad$Data;

    if-eqz v1, :cond_0

    return-object v1

    .line 35
    :cond_0
    new-instance v1, Lcom/navipilot/obf/WideHcopRoad$Data;

    invoke-direct {v1}, Lcom/navipilot/obf/WideHcopRoad$Data;-><init>()V

    .line 36
    sget-object v2, Lcom/navipilot/obf/WideHcop;->available:Ljava/util/Set;

    invoke-interface {v2, v0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_6

    .line 37
    new-instance v2, Lorg/json/JSONObject;

    new-instance v3, Ljava/util/zip/GZIPInputStream;

    sget-object v4, Lcom/navipilot/obf/WideHcop;->context:Landroid/content/Context;

    invoke-virtual {v4}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "tw_hcop/"

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/util/zip/GZIPInputStream;-><init>(Ljava/io/InputStream;)V

    invoke-static {v3}, Lcom/navipilot/obf/WideHcop;->read(Ljava/io/InputStream;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v2, v3}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 38
    const-string v3, "r"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v3

    .line 39
    const/4 v4, 0x0

    move v5, v4

    :goto_0
    invoke-virtual {v3}, Lorg/json/JSONArray;->length()I

    move-result v6

    const/4 v7, 0x6

    const/4 v8, 0x5

    const/4 v9, 0x4

    const/4 v10, 0x3

    const/4 v11, 0x2

    const/4 v12, 0x1

    if-lt v5, v6, :cond_4

    .line 40
    const-string v3, "f"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v6

    move v3, v4

    :goto_1
    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I

    move-result v5

    if-lt v3, v5, :cond_3

    .line 41
    const-string v3, "c"

    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    move v13, v4

    :goto_2
    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v2

    if-lt v13, v2, :cond_1

    goto/16 :goto_5

    :cond_1
    invoke-virtual {v5, v13}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v2

    new-instance v14, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-direct {v14}, Lcom/navipilot/obf/WideHcopRoad$Camera;-><init>()V

    invoke-virtual {v2, v4}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    invoke-virtual {v2, v12}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    invoke-virtual {v2, v11}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    invoke-virtual {v2, v10}, Lorg/json/JSONArray;->getInt(I)I

    move-result v3

    iput v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    invoke-virtual {v2, v9}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v10

    iput-wide v10, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    invoke-virtual {v2, v8}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v10

    iput-wide v10, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    invoke-virtual {v2, v7}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v10

    invoke-virtual {v10}, Lorg/json/JSONArray;->length()I

    move-result v2

    new-array v2, v2, [I

    iput-object v2, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    move v2, v4

    :goto_3
    iget-object v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    array-length v3, v3

    if-lt v2, v3, :cond_2

    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Data;->cameras:Ljava/util/List;

    invoke-interface {v2, v14}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v13, v13, 0x1

    const/4 v10, 0x3

    const/4 v11, 0x2

    goto :goto_2

    :cond_2
    iget-object v3, v14, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    invoke-virtual {v10, v2}, Lorg/json/JSONArray;->getInt(I)I

    move-result v6

    aput v6, v3, v2

    add-int/lit8 v2, v2, 0x1

    goto :goto_3

    .line 40
    :cond_3
    invoke-virtual {v6, v3}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v5

    new-instance v10, Lcom/navipilot/obf/WideHcopRoad$Official;

    invoke-direct {v10}, Lcom/navipilot/obf/WideHcopRoad$Official;-><init>()V

    invoke-virtual {v5, v4}, Lorg/json/JSONArray;->getInt(I)I

    move-result v11

    iput v11, v10, Lcom/navipilot/obf/WideHcopRoad$Official;->id:I

    invoke-virtual {v5, v12}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v11

    invoke-static {v11}, Lcom/navipilot/obf/WideHcop;->strings(Lorg/json/JSONArray;)[Ljava/lang/String;

    move-result-object v11

    iput-object v11, v10, Lcom/navipilot/obf/WideHcopRoad$Official;->names:[Ljava/lang/String;

    const/4 v11, 0x2

    invoke-virtual {v5, v11}, Lorg/json/JSONArray;->getInt(I)I

    move-result v13

    iput v13, v10, Lcom/navipilot/obf/WideHcopRoad$Official;->limit:I

    const/4 v15, 0x3

    invoke-virtual {v5, v15}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v11

    invoke-static {v11}, Lcom/navipilot/obf/WideHcop;->points(Lorg/json/JSONArray;)[[D

    move-result-object v11

    iput-object v11, v10, Lcom/navipilot/obf/WideHcopRoad$Official;->xy:[[D

    invoke-virtual {v5, v9}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v5

    iput-object v5, v10, Lcom/navipilot/obf/WideHcopRoad$Official;->source:Ljava/lang/String;

    iget-object v5, v1, Lcom/navipilot/obf/WideHcopRoad$Data;->signs:Ljava/util/List;

    invoke-interface {v5, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v3, v3, 0x1

    const/4 v10, 0x3

    const/4 v11, 0x2

    goto/16 :goto_1

    .line 39
    :cond_4
    invoke-virtual {v3, v5}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v6

    new-instance v10, Lcom/navipilot/obf/WideHcopRoad$Road;

    invoke-direct {v10}, Lcom/navipilot/obf/WideHcopRoad$Road;-><init>()V

    invoke-virtual {v6, v4}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v11

    iput-object v11, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {v6, v12}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v11

    invoke-static {v11}, Lcom/navipilot/obf/WideHcop;->strings(Lorg/json/JSONArray;)[Ljava/lang/String;

    move-result-object v11

    iput-object v11, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    const/4 v11, 0x2

    invoke-virtual {v6, v11}, Lorg/json/JSONArray;->getInt(I)I

    move-result v11

    iput v11, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    const/4 v15, 0x3

    invoke-virtual {v6, v15}, Lorg/json/JSONArray;->getString(I)Ljava/lang/String;

    move-result-object v11

    iput-object v11, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->grade:Ljava/lang/String;

    invoke-virtual {v6, v9}, Lorg/json/JSONArray;->getInt(I)I

    move-result v9

    iput v9, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->forward:I

    invoke-virtual {v6, v8}, Lorg/json/JSONArray;->getInt(I)I

    move-result v8

    iput v8, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->backward:I

    invoke-virtual {v6, v7}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v7

    invoke-static {v7}, Lcom/navipilot/obf/WideHcop;->points(Lorg/json/JSONArray;)[[D

    move-result-object v7

    iput-object v7, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    const/4 v7, 0x7

    invoke-virtual {v6, v7}, Lorg/json/JSONArray;->getLong(I)J

    move-result-wide v7

    iput-wide v7, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    const/16 v7, 0x8

    invoke-virtual {v6, v7}, Lorg/json/JSONArray;->getLong(I)J

    move-result-wide v6

    iput-wide v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    const-wide/high16 v6, 0x7ff0000000000000L    # Double.POSITIVE_INFINITY

    iput-wide v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLat:D

    iput-wide v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLon:D

    const-wide/high16 v6, -0x10000000000000L    # Double.NEGATIVE_INFINITY

    iput-wide v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLat:D

    iput-wide v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLon:D

    iget-object v6, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    array-length v7, v6

    move v8, v4

    :goto_4
    if-lt v8, v7, :cond_5

    iput-boolean v12, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->bounded:Z

    iget-object v6, v1, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v6, v10}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v5, v5, 0x1

    goto/16 :goto_0

    :cond_5
    aget-object v9, v6, v8

    iget-wide v13, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLon:D

    move v11, v4

    move v15, v5

    aget-wide v4, v9, v11

    invoke-static {v13, v14, v4, v5}, Ljava/lang/Math;->min(DD)D

    move-result-wide v4

    iput-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLon:D

    iget-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLon:D

    aget-wide v13, v9, v11

    invoke-static {v4, v5, v13, v14}, Ljava/lang/Math;->max(DD)D

    move-result-wide v4

    iput-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLon:D

    iget-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLat:D

    aget-wide v13, v9, v12

    invoke-static {v4, v5, v13, v14}, Ljava/lang/Math;->min(DD)D

    move-result-wide v4

    iput-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->minLat:D

    iget-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLat:D

    aget-wide v13, v9, v12

    invoke-static {v4, v5, v13, v14}, Ljava/lang/Math;->max(DD)D

    move-result-wide v4

    iput-wide v4, v10, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLat:D

    add-int/lit8 v8, v8, 0x1

    move v4, v11

    move v5, v15

    goto :goto_4

    .line 43
    :cond_6
    :goto_5
    sget-object v2, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, v0, v1}, Ljava/util/LinkedHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :goto_6
    sget-object v0, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->size()I

    move-result v0

    const/16 v2, 0x20

    if-gt v0, v2, :cond_7

    return-object v1

    :cond_7
    sget-object v0, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    sget-object v2, Lcom/navipilot/obf/WideHcop;->cache:Ljava/util/LinkedHashMap;

    invoke-virtual {v2}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/LinkedHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_6
.end method
