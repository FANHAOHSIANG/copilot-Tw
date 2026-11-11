.class final Lcom/navipilot/obf/WideCameraFallback;
.super Ljava/lang/Object;
.source "WideCameraFallback.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideCameraFallback$Track;
    }
.end annotation


# static fields
.field private static lastGood:J

.field private static lastTime:J

.field private static final motion:Lcom/navipilot/obf/WideAlertMotion;

.field private static published:Lcom/navipilot/obf/WideHcopRoad$Decision;

.field private static selected:Ljava/lang/String;

.field private static status:Ljava/lang/String;

.field private static final tracks:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Lcom/navipilot/obf/WideCameraFallback$Track;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 5
    new-instance v0, Lcom/navipilot/obf/WideAlertMotion;

    invoke-direct {v0}, Lcom/navipilot/obf/WideAlertMotion;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    .line 6
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    .line 8
    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

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
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v0

    .line 11
    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v1}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->clear()V

    const-wide/16 v1, 0x0

    sput-wide v1, Lcom/navipilot/obf/WideCameraFallback;->lastGood:J

    sput-wide v1, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    const-string v1, ""

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

    const/4 v1, 0x0

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u7b49\u5f85\u5b9a\u4f4d\u8ecc\u8de1"

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-void

    .line 11
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method static declared-synchronized match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 40
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

    move-object/from16 v0, p1

    move-wide/from16 v1, p2

    const-class v3, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v3

    .line 14
    :try_start_0
    invoke-static/range {p1 .. p3}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v4

    const-wide/16 v5, 0x2710

    const/4 v7, 0x0

    if-nez v4, :cond_2

    .line 15
    sget-object v4, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v4, v0, v1, v2}, Lcom/navipilot/obf/WideAlertMotion;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Fix;

    sput-object v7, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 16
    if-eqz v0, :cond_0

    iget-boolean v4, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->mock:Z

    if-nez v4, :cond_0

    sget-wide v8, Lcom/navipilot/obf/WideCameraFallback;->lastGood:J

    sub-long/2addr v1, v8

    cmp-long v1, v1, v5

    if-gtz v1, :cond_0

    iget-wide v0, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v4, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    cmp-long v0, v0, v4

    if-gez v0, :cond_1

    :cond_0
    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->clear()V

    .line 17
    :cond_1
    const-string v0, "GPS \u904e\u671f\u6216\u7cbe\u5ea6\u4e0d\u8db3\uff0c\u66ab\u505c\u63d0\u9192\uff1b\u77ed\u66ab\u4fdd\u7559\u8ecc\u8de1"

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v3

    return-object v7

    .line 19
    :cond_2
    :try_start_1
    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v10, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    cmp-long v4, v8, v10

    if-nez v4, :cond_3

    sget-object v0, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    monitor-exit v3

    return-object v0

    .line 20
    :cond_3
    :try_start_2
    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v10, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    cmp-long v4, v8, v10

    if-ltz v4, :cond_4

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sget-wide v10, Lcom/navipilot/obf/WideCameraFallback;->lastGood:J

    sub-long/2addr v8, v10

    cmp-long v4, v8, v5

    if-lez v4, :cond_5

    :cond_4
    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->clear()V

    .line 21
    :cond_5
    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sput-wide v8, Lcom/navipilot/obf/WideCameraFallback;->lastTime:J

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sput-wide v8, Lcom/navipilot/obf/WideCameraFallback;->lastGood:J

    sput-object v7, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 22
    sget-object v4, Lcom/navipilot/obf/WideCameraFallback;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v4, v0, v1, v2}, Lcom/navipilot/obf/WideAlertMotion;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Fix;

    move-result-object v1

    .line 23
    if-nez v1, :cond_7

    .line 24
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    invoke-virtual {v1}, Ljava/util/HashMap;->clear()V

    const-string v1, ""

    sput-object v1, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

    .line 25
    iget-boolean v1, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v1, :cond_6

    iget-wide v0, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 v4, 0x3ff8000000000000L    # 1.5

    cmpg-double v0, v0, v4

    if-gez v0, :cond_6

    const-string v0, "\u505c\u8eca\uff0f\u4f4e\u901f\uff0c\u7b49\u5f85\u8d77\u6b65"

    goto :goto_0

    :cond_6
    const-string v0, "\u7d2f\u7a4d\u79fb\u52d5\u8ecc\u8de1\u4ee5\u78ba\u8a8d\u65b9\u5411"

    :goto_0
    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 26
    monitor-exit v3

    return-object v7

    .line 28
    :cond_7
    :try_start_3
    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sput-wide v8, Lcom/navipilot/obf/WideCameraFallback;->lastGood:J

    .line 29
    nop

    .line 30
    nop

    .line 31
    new-instance v2, Ljava/util/HashSet;

    invoke-direct {v2}, Ljava/util/HashSet;-><init>()V

    .line 32
    const-wide v10, 0x7fefffffffffffffL    # Double.MAX_VALUE

    const-wide/16 v13, 0x0

    if-eqz p0, :cond_18

    invoke-interface/range {p0 .. p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v15

    move-object/from16 v23, v7

    move-object/from16 v24, v23

    move-object/from16 v25, v24

    move-wide/from16 v16, v13

    const/16 v18, 0x0

    const/16 v19, 0x0

    const/16 v20, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    move-wide v13, v10

    :goto_1
    invoke-interface {v15}, Ljava/util/Iterator;->hasNext()Z

    move-result v26

    if-nez v26, :cond_8

    move-wide v4, v10

    move-wide v10, v13

    move-wide/from16 v13, v16

    move/from16 v1, v18

    move/from16 v6, v19

    move/from16 v7, v20

    move/from16 v8, v21

    move/from16 v9, v22

    move-object/from16 v12, v25

    const-wide/high16 p2, 0x4049000000000000L    # 50.0

    const/16 v39, 0x1

    goto/16 :goto_7

    :cond_8
    invoke-interface {v15}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v26

    move-wide/from16 v27, v5

    move-object/from16 v5, v26

    check-cast v5, Lcom/navipilot/obf/WideCameraEngine$Point;

    .line 33
    const-wide/high16 p2, 0x4049000000000000L    # 50.0

    iget-wide v8, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v37, v13

    iget-wide v12, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v6, v5, Lcom/navipilot/obf/WideCameraEngine$Point;->lat:D

    move-wide/from16 v33, v6

    iget-wide v6, v5, Lcom/navipilot/obf/WideCameraEngine$Point;->lon:D

    move-wide/from16 v35, v6

    move-wide/from16 v29, v8

    move-wide/from16 v31, v12

    invoke-static/range {v29 .. v36}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v6

    .line 34
    invoke-static {v6, v7}, Ljava/lang/Double;->isFinite(D)Z

    move-result v8

    if-eqz v8, :cond_16

    const-wide v8, 0x4097700000000000L    # 1500.0

    cmpl-double v8, v6, v8

    if-gtz v8, :cond_16

    const-wide/high16 v8, 0x4028000000000000L    # 12.0

    cmpg-double v8, v6, v8

    if-gez v8, :cond_9

    const/16 v39, 0x1

    goto/16 :goto_6

    .line 35
    :cond_9
    add-int/lit8 v18, v18, 0x1

    .line 36
    iget-object v8, v5, Lcom/navipilot/obf/WideCameraEngine$Point;->bearings:[D

    array-length v8, v8

    if-nez v8, :cond_b

    add-int/lit8 v19, v19, 0x1

    cmpg-double v8, v6, v10

    if-gez v8, :cond_a

    move-object/from16 v25, v5

    move-wide v10, v6

    :cond_a
    move-wide/from16 v5, v27

    move-wide/from16 v13, v37

    const/4 v7, 0x0

    goto :goto_1

    .line 37
    :cond_b
    iget-wide v8, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    iget-wide v12, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-object v14, v5

    const/16 v39, 0x1

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v31, v4

    iget-wide v4, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->lat:D

    move-wide/from16 v33, v4

    iget-wide v4, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->lon:D

    move-wide/from16 v35, v4

    move-wide/from16 v29, v12

    invoke-static/range {v29 .. v36}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v4

    invoke-static {v8, v9, v4, v5}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v4

    .line 38
    const-wide/high16 v8, 0x403e000000000000L    # 30.0

    cmpl-double v8, v4, v8

    if-gtz v8, :cond_15

    invoke-static {v4, v5}, Ljava/lang/Math;->toRadians(D)D

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Math;->sin(D)D

    move-result-wide v4

    mul-double/2addr v4, v6

    const-wide/high16 v8, 0x404e000000000000L    # 60.0

    cmpl-double v4, v4, v8

    if-lez v4, :cond_c

    goto/16 :goto_5

    .line 39
    :cond_c
    iget-object v4, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->bearings:[D

    array-length v5, v4

    const/4 v8, 0x0

    const/4 v9, 0x0

    :goto_2
    if-lt v8, v5, :cond_13

    .line 40
    if-nez v9, :cond_d

    add-int/lit8 v21, v21, 0x1

    move-wide/from16 v5, v27

    move-wide/from16 v13, v37

    const/4 v7, 0x0

    goto/16 :goto_1

    .line 41
    :cond_d
    add-int/lit8 v22, v22, 0x1

    iget-object v4, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    .line 42
    sget-object v4, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    iget-object v5, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/util/HashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/navipilot/obf/WideCameraFallback$Track;

    .line 43
    if-eqz v4, :cond_f

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v12, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->time:J

    sub-long/2addr v8, v12

    cmp-long v5, v8, v27

    if-gtz v5, :cond_f

    iget-wide v8, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->distance:D

    iget-wide v12, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    move-object/from16 v29, v4

    const-wide/high16 v4, 0x4024000000000000L    # 10.0

    invoke-static {v4, v5, v12, v13}, Ljava/lang/Math;->max(DD)D

    move-result-wide v4

    add-double/2addr v8, v4

    cmpl-double v4, v6, v8

    if-lez v4, :cond_e

    goto :goto_3

    :cond_e
    move-object/from16 v4, v29

    goto :goto_4

    .line 44
    :cond_f
    :goto_3
    new-instance v4, Lcom/navipilot/obf/WideCameraFallback$Track;

    const/4 v5, 0x0

    invoke-direct {v4, v5}, Lcom/navipilot/obf/WideCameraFallback$Track;-><init>(Lcom/navipilot/obf/WideCameraFallback-IA;)V

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iput-wide v8, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->first:J

    iput-wide v6, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->start:D

    sget-object v5, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    iget-object v8, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    invoke-virtual {v5, v8, v4}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 46
    :goto_4
    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iput-wide v8, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->time:J

    iput-wide v6, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->distance:D

    iget v5, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->samples:I

    add-int/lit8 v5, v5, 0x1

    iput v5, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->samples:I

    .line 47
    iget v5, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->samples:I

    const/4 v8, 0x2

    if-lt v5, v8, :cond_17

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v12, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->first:J

    sub-long/2addr v8, v12

    const-wide/16 v12, 0x3e8

    cmp-long v5, v8, v12

    if-ltz v5, :cond_17

    iget-wide v4, v4, Lcom/navipilot/obf/WideCameraFallback$Track;->start:D

    sub-double/2addr v4, v6

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/high16 v12, 0x3fe0000000000000L    # 0.5

    mul-double/2addr v8, v12

    const-wide/high16 v12, 0x4014000000000000L    # 5.0

    invoke-static {v12, v13, v8, v9}, Ljava/lang/Math;->max(DD)D

    move-result-wide v8

    cmpg-double v4, v4, v8

    if-gez v4, :cond_10

    goto :goto_6

    .line 48
    :cond_10
    cmpg-double v4, v6, v37

    if-gez v4, :cond_11

    move-wide/from16 v37, v6

    move-object/from16 v24, v14

    .line 49
    :cond_11
    iget-object v4, v14, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    sget-object v5, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_12

    move-wide/from16 v16, v6

    move-object/from16 v23, v14

    :cond_12
    move-wide/from16 v5, v27

    move-wide/from16 v13, v37

    const/4 v7, 0x0

    goto/16 :goto_1

    .line 39
    :cond_13
    aget-wide v12, v4, v8

    move-object/from16 v29, v4

    move/from16 v30, v5

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v4, v5, v12, v13}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v4

    cmpg-double v4, v4, p2

    if-gtz v4, :cond_14

    move/from16 v9, v39

    :cond_14
    add-int/lit8 v8, v8, 0x1

    move-object/from16 v4, v29

    move/from16 v5, v30

    goto/16 :goto_2

    .line 38
    :cond_15
    :goto_5
    add-int/lit8 v20, v20, 0x1

    move-wide/from16 v5, v27

    move-wide/from16 v13, v37

    const/4 v7, 0x0

    goto/16 :goto_1

    .line 34
    :cond_16
    const/16 v39, 0x1

    .line 32
    :cond_17
    :goto_6
    move-wide/from16 v5, v27

    move-wide/from16 v13, v37

    const/4 v7, 0x0

    goto/16 :goto_1

    :cond_18
    const-wide/high16 p2, 0x4049000000000000L    # 50.0

    const/16 v39, 0x1

    move-wide v4, v10

    const/4 v1, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    const/4 v12, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    .line 51
    :goto_7
    sget-object v15, Lcom/navipilot/obf/WideCameraFallback;->tracks:Ljava/util/HashMap;

    invoke-virtual {v15}, Ljava/util/HashMap;->keySet()Ljava/util/Set;

    move-result-object v15

    invoke-interface {v15, v2}, Ljava/util/Set;->retainAll(Ljava/util/Collection;)Z

    .line 52
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "\u5019\u9078 "

    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 \u540c\u5411 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 \u65b9\u5411\u672a\u77e5 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 \u504f\u96e2 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " \u00b7 \u53cd\u5411 "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 54
    if-eqz v23, :cond_19

    add-double v6, v10, p2

    cmpg-double v2, v13, v6

    if-gtz v2, :cond_19

    move-wide v10, v13

    move-object/from16 v2, v23

    goto :goto_8

    .line 55
    :cond_19
    move-object/from16 v2, v24

    :goto_8
    if-nez v2, :cond_1c

    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

    if-lez v9, :cond_1a

    const-string v0, "\u78ba\u8a8d\u6301\u7e8c\u63a5\u8fd1\u4e2d"

    goto :goto_9

    :cond_1a
    if-eqz v12, :cond_1b

    invoke-static {v4, v5}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    iget-object v0, v12, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u9644\u8fd1\u6e2c\u901f\u9ede \u00b7 "

    invoke-virtual {v2, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, " m \u00b7 \u65b9\u5411\u672a\u78ba\u8a8d \u00b7 "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_9

    :cond_1b
    const-string v0, "\u524d\u65b9\u7121\u7b26\u5408\u6e2c\u901f\u9ede"

    :goto_9
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, "\uff1b"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    monitor-exit v3

    const/16 v26, 0x0

    return-object v26

    .line 56
    :cond_1c
    :try_start_4
    iget-object v4, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    sput-object v4, Lcom/navipilot/obf/WideCameraFallback;->selected:Ljava/lang/String;

    .line 57
    new-instance v4, Lcom/navipilot/obf/WideHcopRoad$Decision;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u540c\u5411\u63a5\u8fd1\u5019\u9078 \u00b7 \u76f4\u7dda\u8ddd\u96e2 \u00b7 \u9053\u8def\u672a\u78ba\u8a8d \u00b7 \u50c5\u63d0\u9192\uff1b"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iget-wide v5, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-direct {v4, v1, v5, v6}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    .line 58
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-direct {v0}, Lcom/navipilot/obf/WideHcopRoad$Camera;-><init>()V

    iget-object v1, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->lat:D

    iput-wide v5, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->lon:D

    iput-wide v5, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    .line 59
    iget-boolean v1, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->limitUncertain:Z

    if-eqz v1, :cond_1d

    const/4 v1, 0x0

    goto :goto_a

    :cond_1d
    iget v1, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->limit:I

    :goto_a
    iput v1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iget-object v1, v2, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "\u9053\u8def\u5c64\u7d1a\u672a\u6a19\u660e \u00b7 "

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    const-string v1, ""

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    const/4 v6, 0x0

    new-array v1, v6, [I

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    .line 60
    iput-object v0, v4, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iput-wide v10, v4, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    move/from16 v0, v39

    iput-boolean v0, v4, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    const-string v0, "candidate"

    iput-object v0, v4, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    iget-object v0, v4, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;

    sput-object v4, Lcom/navipilot/obf/WideCameraFallback;->published:Lcom/navipilot/obf/WideHcopRoad$Decision;
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    monitor-exit v3

    return-object v4

    .line 13
    :catchall_0
    move-exception v0

    :try_start_5
    monitor-exit v3
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    throw v0
.end method

.method static declared-synchronized status()Ljava/lang/String;
    .locals 2

    const-class v0, Lcom/navipilot/obf/WideCameraFallback;

    monitor-enter v0

    .line 12
    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideCameraFallback;->status:Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return-object v1

    .line 12
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method
