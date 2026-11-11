.class final Lcom/navipilot/obf/WideCameraFallback;
.super Ljava/lang/Object;
.source "WideCameraFallback.java"


# static fields
.field private static firstDistance:D

.field private static firstTime:J

.field private static id:Ljava/lang/String;

.field private static lastDistance:D

.field private static lastTime:J

.field private static final motion:Lcom/navipilot/obf/WideAlertMotion;

.field private static prepared:Lcom/navipilot/obf/WideCameraEngine$Fix;

.field private static published:Lcom/navipilot/obf/WideHcopRoad$Decision;

.field private static samples:I

.field private static status:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 5
    new-instance v0, Lcom/navipilot/obf/WideAlertMotion;

    invoke-direct {v0}, Lcom/navipilot/obf/WideAlertMotion;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    .line 7
    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    const-string v0, "\u7b49\u5f85\u5b9a\u4f4d\u8ecc\u8de1"

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;

    .line 9
    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static declared-synchronized clear()V
    .locals 4

    const-class v0, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v0

    .line 10
    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v1}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    const/4 v1, 0x0

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->prepared:Lcom/navipilot/obf/WideCameraEngine$Fix;

    const-wide/16 v2, 0x0

    sput-wide v2, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    const-string v2, ""

    sput-object v2, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    const/4 v2, 0x0

    sput v2, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u7b49\u5f85\u5b9a\u4f4d\u8ecc\u8de1"

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 10
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method static declared-synchronized match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 12
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;",
            "Lcom/navipilot/obf/WideCameraEngine$Fix;",
            "J)",
            "Lcom/navipilot/obf/WideHcopRoad$Decision;"
        }
    .end annotation

    const-class v0, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v0

    .line 13
    :try_start_0
    invoke-static {p1, p2, p3}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->clear()V

    const-string p0, "GPS \u904e\u671f\u6216\u7cbe\u5ea6\u4e0d\u8db3\uff0c\u66ab\u505c\u63d0\u9192"

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v2

    .line 14
    :cond_0
    :try_start_1
    iget-wide v3, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v5, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    cmp-long v1, v3, v5

    if-nez v1, :cond_1

    sget-object p0, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v0

    return-object p0

    .line 15
    :cond_1
    :try_start_2
    iget-wide v3, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v5, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    cmp-long v1, v3, v5

    if-gez v1, :cond_2

    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->clear()V

    .line 16
    :cond_2
    iget-wide v3, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sput-wide v3, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v1, p1, p2, p3}, Lcom/navipilot/obf/WideAlertMotion;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Fix;

    move-result-object v1

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->prepared:Lcom/navipilot/obf/WideCameraEngine$Fix;

    sput-object v2, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 17
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->prepared:Lcom/navipilot/obf/WideCameraEngine$Fix;

    const/4 v3, 0x0

    if-nez v1, :cond_4

    const-string p0, ""

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    sput v3, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    iget-boolean p0, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz p0, :cond_3

    iget-wide p0, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 p2, 0x3ff8000000000000L    # 1.5

    cmpg-double p0, p0, p2

    if-gez p0, :cond_3

    const-string p0, "\u505c\u8eca\uff0f\u4f4e\u901f\uff0c\u7b49\u5f85\u8d77\u6b65"

    goto :goto_0

    :cond_3
    const-string p0, "\u7d2f\u7a4d\u79fb\u52d5\u8ecc\u8de1\u4ee5\u78ba\u8a8d\u65b9\u5411"

    :goto_0
    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    monitor-exit v0

    return-object v2

    .line 18
    :cond_4
    :try_start_3
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->prepared:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {p0, v1, p2, p3}, Lcom/navipilot/obf/WideCameraEngine;->match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object p0

    .line 19
    iget-object p2, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    if-nez p2, :cond_5

    const-string p1, ""

    sput-object p1, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    sput v3, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    iget-object p0, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->state:Ljava/lang/String;

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    monitor-exit v0

    return-object v2

    .line 21
    :cond_5
    :try_start_4
    iget-boolean p2, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->directionKnown:Z

    if-nez p2, :cond_6

    const-string p0, ""

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    sput v3, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    const-string p0, "\u9644\u8fd1\u6709\u6e2c\u901f\u9ede\uff0c\u4f46\u57f7\u6cd5\u65b9\u5411\u672a\u6a19\u660e"

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    monitor-exit v0

    return-object v2

    .line 22
    :cond_6
    :try_start_5
    iget-object p2, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object p2, p2, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    sget-object p3, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    const/4 p3, 0x1

    if-eqz p2, :cond_8

    iget-wide v4, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    sget-wide v6, Lcom/navipilot/obf/WideCameraFallback;->lastDistance:D

    iget-wide v8, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/high16 v10, 0x4024000000000000L    # 10.0

    invoke-static {v10, v11, v8, v9}, Ljava/lang/Math;->max(DD)D

    move-result-wide v8

    add-double/2addr v6, v8

    cmpl-double p2, v4, v6

    if-lez p2, :cond_7

    goto :goto_2

    .line 24
    :cond_7
    sget p2, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    add-int/2addr p2, p3

    sput p2, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    :goto_1
    goto :goto_3

    .line 23
    :cond_8
    :goto_2
    iget-object p2, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object p2, p2, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    sput-object p2, Lcom/navipilot/obf/WideCameraFallback;->id:Ljava/lang/String;

    sput p3, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    iget-wide v4, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sput-wide v4, Lcom/navipilot/obf/WideCameraFallback;->firstTime:J

    iget-wide v4, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    sput-wide v4, Lcom/navipilot/obf/WideCameraFallback;->firstDistance:D

    goto :goto_1

    .line 25
    :goto_3
    iget-wide v4, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    sput-wide v4, Lcom/navipilot/obf/WideCameraFallback;->lastDistance:D

    .line 26
    sget p2, Lcom/navipilot/obf/WideCameraFallback;->samples:I

    const/4 v1, 0x2

    if-lt p2, v1, :cond_b

    iget-wide v4, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v6, Lcom/navipilot/obf/WideCameraFallback;->firstTime:J

    sub-long/2addr v4, v6

    const-wide/16 v6, 0x3e8

    cmp-long p2, v4, v6

    if-ltz p2, :cond_b

    sget-wide v4, Lcom/navipilot/obf/WideCameraFallback;->firstDistance:D

    iget-wide v6, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    sub-double/2addr v4, v6

    iget-wide v6, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/high16 v8, 0x3fe0000000000000L    # 0.5

    mul-double/2addr v6, v8

    const-wide/high16 v8, 0x4014000000000000L    # 5.0

    invoke-static {v8, v9, v6, v7}, Ljava/lang/Math;->max(DD)D

    move-result-wide v6

    cmpg-double p2, v4, v6

    if-gez p2, :cond_9

    goto :goto_5

    .line 29
    :cond_9
    new-instance p2, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u540c\u5411\u63a5\u8fd1\u5019\u9078 \u00b7 \u76f4\u7dda\u8ddd\u96e2 \u00b7 \u9053\u8def\u672a\u78ba\u8a8d \u00b7 \u50c5\u63d0\u9192"

    iget-wide v4, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-direct {p2, v1, v4, v5}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    .line 30
    new-instance p1, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-direct {p1}, Lcom/navipilot/obf/WideHcopRoad$Camera;-><init>()V

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v1, v1, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    iput-object v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-wide v1, v1, Lcom/navipilot/obf/WideCameraEngine$Point;->lat:D

    iput-wide v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-wide v1, v1, Lcom/navipilot/obf/WideCameraEngine$Point;->lon:D

    iput-wide v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    .line 31
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-boolean v1, v1, Lcom/navipilot/obf/WideCameraEngine$Point;->limitUncertain:Z

    if-eqz v1, :cond_a

    move v1, v3

    goto :goto_4

    :cond_a
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget v1, v1, Lcom/navipilot/obf/WideCameraEngine$Point;->limit:I

    :goto_4
    iput v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u9053\u8def\u5c64\u7d1a\u672a\u6a19\u660e \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v2, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    .line 32
    const-string v1, ""

    iput-object v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    new-array v1, v3, [I

    iput-object v1, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    iput-object p1, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-wide p0, p0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    iput-wide p0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iput-boolean p3, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    const-string p0, "candidate"

    iput-object p0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    .line 33
    iget-object p0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;

    sput-object p2, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    monitor-exit v0

    return-object p2

    .line 27
    :cond_b
    :goto_5
    :try_start_6
    const-string p0, "\u524d\u65b9\u5019\u9078\u9ede\uff0c\u78ba\u8a8d\u6301\u7e8c\u63a5\u8fd1\u4e2d"

    sput-object p0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_0

    monitor-exit v0

    return-object v2

    .line 12
    :catchall_0
    move-exception p0

    :try_start_7
    monitor-exit v0
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_0

    throw p0
.end method

.method static declared-synchronized status()Ljava/lang/String;
    .locals 2

    const-class v0, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v0

    .line 11
    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    .line 11
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method
