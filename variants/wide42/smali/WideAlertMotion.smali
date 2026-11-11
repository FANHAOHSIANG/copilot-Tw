.class final Lcom/navipilot/obf/WideAlertMotion;
.super Ljava/lang/Object;
.source "WideAlertMotion.java"


# instance fields
.field private final history:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Lcom/navipilot/obf/WideCameraEngine$Fix;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>()V
    .locals 1

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 5
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    .line 4
    return-void
.end method

.method static position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z
    .locals 4

    .line 7
    if-eqz p0, :cond_0

    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->mock:Z

    if-nez v0, :cond_0

    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    const-wide/16 v2, 0x0

    cmp-long v0, v0, v2

    if-lez v0, :cond_0

    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v0, p1, v0

    if-ltz v0, :cond_0

    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr p1, v0

    const-wide/16 v0, 0xbb8

    cmp-long p1, p1, v0

    if-gtz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    invoke-static {p1, p2}, Ljava/lang/Double;->isFinite(D)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    invoke-static {p1, p2}, Ljava/lang/Double;->isFinite(D)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    const-wide/high16 v0, 0x4034000000000000L    # 20.0

    cmpl-double p1, p1, v0

    if-ltz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    const-wide/high16 v0, 0x403b000000000000L    # 27.0

    cmpg-double p1, p1, v0

    if-gtz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    const-wide/high16 v0, 0x405d000000000000L    # 116.0

    cmpl-double p1, p1, v0

    if-ltz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    const-wide/high16 v0, 0x405f000000000000L    # 124.0

    cmpg-double p1, p1, v0

    if-gtz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-static {p1, p2}, Ljava/lang/Double;->isFinite(D)Z

    move-result p1

    if-eqz p1, :cond_0

    iget-wide p1, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/16 v0, 0x0

    cmpl-double p1, p1, v0

    if-lez p1, :cond_0

    iget-wide p0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/high16 v0, 0x403e000000000000L    # 30.0

    cmpg-double p0, p0, v0

    if-gtz p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method


# virtual methods
.method accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Fix;
    .locals 41

    .line 9
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-static/range {p1 .. p3}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v2

    const/4 v3, 0x1

    const/4 v4, 0x0

    if-nez v2, :cond_2

    .line 10
    if-eqz v1, :cond_0

    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->mock:Z

    if-nez v2, :cond_0

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v5, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v5}, Ljava/util/ArrayList;->size()I

    move-result v5

    sub-int/2addr v5, v3

    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long v5, p2, v5

    const-wide/16 v7, 0x2710

    cmp-long v2, v5, v7

    if-gtz v2, :cond_0

    iget-wide v1, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-object v5, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v6, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v6}, Ljava/util/ArrayList;->size()I

    move-result v6

    sub-int/2addr v6, v3

    invoke-virtual {v5, v6}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v5, v3, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v1, v1, v5

    if-gez v1, :cond_1

    :cond_0
    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    .line 11
    :cond_1
    return-object v4

    .line 13
    :cond_2
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    const-wide/16 v5, 0x0

    const-wide v7, 0x408f400000000000L    # 1000.0

    if-nez v2, :cond_5

    .line 14
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    sub-int/2addr v9, v3

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v11, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v9, v11

    long-to-double v9, v9

    div-double/2addr v9, v7

    .line 15
    cmpg-double v11, v9, v5

    if-gtz v11, :cond_3

    return-object v4

    .line 16
    :cond_3
    const-wide/high16 v11, 0x4024000000000000L    # 10.0

    cmpl-double v11, v9, v11

    if-gtz v11, :cond_4

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v14, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-object v11, v4

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 p2, v5

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v3

    move-wide/from16 v18, v5

    invoke-static/range {v12 .. v19}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v3

    const-wide v5, 0x4050400000000000L    # 65.0

    mul-double/2addr v9, v5

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v9, v5

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v9, v5

    cmpl-double v2, v3, v9

    if-lez v2, :cond_6

    goto :goto_0

    :cond_4
    move-object v11, v4

    move-wide/from16 p2, v5

    :goto_0
    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    goto :goto_1

    .line 13
    :cond_5
    move-object v11, v4

    move-wide/from16 p2, v5

    .line 19
    :cond_6
    :goto_1
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    const-wide/high16 v3, 0x404e000000000000L    # 60.0

    const-wide/high16 v5, 0x3ff8000000000000L    # 1.5

    if-eqz v2, :cond_8

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v9, v10}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_7

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpg-double v2, v9, v5

    if-ltz v2, :cond_7

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpl-double v2, v9, v3

    if-lez v2, :cond_8

    :cond_7
    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object v11

    .line 20
    :cond_8
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 21
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v2, :cond_9

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 v12, 0x4014000000000000L    # 5.0

    cmpg-double v2, v9, v12

    if-gez v2, :cond_9

    const/16 v2, 0x7530

    goto :goto_2

    :cond_9
    const/16 v2, 0x2ee0

    :goto_2
    int-to-long v9, v2

    .line 22
    nop

    :goto_3
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/16 v12, 0x80

    const/4 v13, 0x0

    if-gt v2, v12, :cond_17

    iget-wide v14, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v13}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    move-wide/from16 v16, v3

    iget-wide v3, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v14, v3

    cmp-long v2, v14, v9

    if-gtz v2, :cond_18

    .line 23
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->headingValid:Z

    if-eqz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v2, v3}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    cmpl-double v2, v2, p2

    if-ltz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    const-wide v9, 0x4076800000000000L    # 360.0

    cmpg-double v2, v2, v9

    if-gez v2, :cond_a

    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v2, v3}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpl-double v2, v2, v5

    if-ltz v2, :cond_a

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpg-double v2, v2, v16

    if-gtz v2, :cond_a

    return-object v1

    .line 25
    :cond_a
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/4 v3, 0x3

    if-ge v2, v3, :cond_b

    return-object v11

    .line 26
    :cond_b
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v13}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-object v3, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v4, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v4}, Ljava/util/ArrayList;->size()I

    move-result v4

    add-int/lit8 v4, v4, -0x2

    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 27
    iget-wide v9, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v14, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v18, v5

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v27, v5

    move-wide/from16 v21, v9

    move-wide/from16 v23, v12

    move-wide/from16 v25, v14

    invoke-static/range {v21 .. v28}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v4

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v9, v12

    long-to-double v9, v9

    div-double/2addr v9, v7

    .line 28
    cmpg-double v6, v9, v18

    if-ltz v6, :cond_16

    iget-wide v6, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-wide v12, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v6, v12

    const-wide/high16 v12, 0x4034000000000000L    # 20.0

    invoke-static {v12, v13, v6, v7}, Ljava/lang/Math;->max(DD)D

    move-result-wide v6

    cmpg-double v6, v4, v6

    if-gez v6, :cond_c

    move-object/from16 v27, v11

    goto/16 :goto_8

    .line 29
    :cond_c
    iget-wide v6, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v14, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-object v2, v11

    move-wide/from16 v23, v12

    iget-wide v11, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v21, v6

    move-wide/from16 v27, v11

    move-wide/from16 v25, v14

    invoke-static/range {v21 .. v28}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v6

    div-double/2addr v4, v9

    .line 30
    cmpg-double v8, v4, v18

    if-ltz v8, :cond_15

    cmpl-double v8, v4, v16

    if-lez v8, :cond_d

    move-object/from16 v27, v2

    goto/16 :goto_7

    .line 32
    :cond_d
    const/4 v8, 0x1

    :goto_4
    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    if-lt v8, v9, :cond_13

    .line 38
    iget-object v8, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v8}, Ljava/util/ArrayList;->size()I

    move-result v8

    add-int/lit8 v8, v8, -0x2

    :goto_5
    if-gez v8, :cond_e

    move-object/from16 v27, v2

    const-wide/high16 v24, 0x3fe0000000000000L    # 0.5

    goto :goto_6

    .line 39
    :cond_e
    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 40
    const-wide p2, 0x4041800000000000L    # 35.0

    iget-wide v10, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    const-wide/high16 v24, 0x3fe0000000000000L    # 0.5

    iget-wide v12, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-object/from16 v27, v2

    move-object/from16 v26, v3

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v14, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v20, v2

    move-wide/from16 v16, v10

    move-wide/from16 v18, v12

    move-wide/from16 v22, v14

    invoke-static/range {v16 .. v23}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v2

    .line 41
    iget-wide v10, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-wide v12, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v10, v12

    mul-double v10, v10, v24

    const-wide/high16 v12, 0x4020000000000000L    # 8.0

    invoke-static {v12, v13, v10, v11}, Ljava/lang/Math;->max(DD)D

    move-result-wide v10

    cmpl-double v2, v2, v10

    if-ltz v2, :cond_12

    .line 42
    iget-wide v10, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v14, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v2

    invoke-static/range {v10 .. v17}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v2

    invoke-static {v6, v7, v2, v3}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v2

    cmpl-double v2, v2, p2

    if-lez v2, :cond_f

    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    move-object/from16 v3, v26

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object v27

    .line 46
    :cond_f
    :goto_6
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v2, :cond_10

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v2, v3}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_10

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    sub-double/2addr v2, v4

    invoke-static {v2, v3}, Ljava/lang/Math;->abs(D)D

    move-result-wide v2

    iget-wide v8, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    mul-double v8, v8, v24

    const-wide/high16 v12, 0x4020000000000000L    # 8.0

    invoke-static {v12, v13, v8, v9}, Ljava/lang/Math;->max(DD)D

    move-result-wide v8

    cmpl-double v2, v2, v8

    if-lez v2, :cond_10

    return-object v27

    .line 47
    :cond_10
    new-instance v25, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v8, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-boolean v12, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v12, :cond_11

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    :cond_11
    move-wide/from16 v34, v4

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    const/16 v39, 0x0

    const/16 v40, 0x1

    const/16 v38, 0x1

    move-wide/from16 v26, v2

    move-wide/from16 v36, v4

    move-wide/from16 v32, v6

    move-wide/from16 v28, v8

    move-wide/from16 v30, v10

    invoke-direct/range {v25 .. v40}, Lcom/navipilot/obf/WideCameraEngine$Fix;-><init>(DDDDDJZZZ)V

    return-object v25

    .line 38
    :cond_12
    move-object/from16 v3, v26

    add-int/lit8 v8, v8, -0x1

    move-object/from16 v2, v27

    goto/16 :goto_5

    .line 33
    :cond_13
    move-object/from16 v27, v2

    const-wide p2, 0x4041800000000000L    # 35.0

    const-wide/high16 v24, 0x3fe0000000000000L    # 0.5

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    add-int/lit8 v9, v8, -0x1

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 34
    iget-wide v10, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v14, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v21, v4

    iget-wide v4, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v4

    invoke-static/range {v10 .. v17}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v4

    .line 35
    iget-wide v10, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-wide v12, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v10, v12

    mul-double v10, v10, v24

    const-wide/high16 v12, 0x4020000000000000L    # 8.0

    invoke-static {v12, v13, v10, v11}, Ljava/lang/Math;->max(DD)D

    move-result-wide v10

    cmpl-double v4, v4, v10

    if-ltz v4, :cond_14

    iget-wide v10, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v14, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v4, v9, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v4

    invoke-static/range {v10 .. v17}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v4

    invoke-static {v6, v7, v4, v5}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v4

    cmpl-double v2, v4, p2

    if-lez v2, :cond_14

    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object v27

    .line 32
    :cond_14
    add-int/lit8 v8, v8, 0x1

    move-wide/from16 v4, v21

    move-object/from16 v2, v27

    goto/16 :goto_4

    .line 30
    :cond_15
    move-object/from16 v27, v2

    :goto_7
    return-object v27

    .line 28
    :cond_16
    move-object/from16 v27, v11

    :goto_8
    return-object v27

    .line 22
    :cond_17
    move-wide/from16 v16, v3

    :cond_18
    move-wide/from16 v18, v5

    move-object/from16 v27, v11

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v13}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    move-wide/from16 v3, v16

    move-wide/from16 v5, v18

    move-object/from16 v11, v27

    goto/16 :goto_3
.end method

.method clear()V
    .locals 1

    .line 6
    iget-object v0, p0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    return-void
.end method
