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
    .locals 35

    .line 9
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-static/range {p1 .. p3}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v2

    const/4 v3, 0x0

    if-nez v2, :cond_0

    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    return-object v3

    .line 10
    :cond_0
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    const-wide/16 v4, 0x0

    const-wide v6, 0x408f400000000000L    # 1000.0

    const/4 v8, 0x1

    if-nez v2, :cond_3

    .line 11
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    sub-int/2addr v9, v8

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v11, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v9, v11

    long-to-double v9, v9

    div-double/2addr v9, v6

    .line 12
    cmpg-double v11, v9, v4

    if-gtz v11, :cond_1

    return-object v3

    .line 13
    :cond_1
    const-wide/high16 v11, 0x4008000000000000L    # 3.0

    cmpl-double v11, v9, v11

    if-gtz v11, :cond_2

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v14, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-object/from16 p2, v3

    move-wide/from16 v20, v4

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v22, v6

    iget-wide v6, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v3

    move-wide/from16 v18, v6

    invoke-static/range {v12 .. v19}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v3

    const-wide v5, 0x4050400000000000L    # 65.0

    mul-double/2addr v9, v5

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v9, v5

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v9, v5

    cmpl-double v2, v3, v9

    if-lez v2, :cond_4

    goto :goto_0

    :cond_2
    move-object/from16 p2, v3

    move-wide/from16 v20, v4

    move-wide/from16 v22, v6

    :goto_0
    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    goto :goto_1

    .line 10
    :cond_3
    move-object/from16 p2, v3

    move-wide/from16 v20, v4

    move-wide/from16 v22, v6

    .line 16
    :cond_4
    :goto_1
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    const-wide/high16 v3, 0x404e000000000000L    # 60.0

    const-wide/high16 v5, 0x3ff8000000000000L    # 1.5

    if-eqz v2, :cond_6

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v9, v10}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_5

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpg-double v2, v9, v5

    if-ltz v2, :cond_5

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpl-double v2, v9, v3

    if-lez v2, :cond_6

    :cond_5
    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    iget-object v0, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object p2

    .line 17
    :cond_6
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :goto_2
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/16 v7, 0xc

    const/4 v9, 0x0

    if-gt v2, v7, :cond_11

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v12, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v10, v12

    const-wide/16 v12, 0x1f40

    cmp-long v2, v10, v12

    if-gtz v2, :cond_11

    .line 18
    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->headingValid:Z

    if-eqz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v10, v11}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    cmpl-double v2, v10, v20

    if-ltz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    const-wide v12, 0x4076800000000000L    # 360.0

    cmpg-double v2, v10, v12

    if-gez v2, :cond_7

    iget-boolean v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v10, v11}, Ljava/lang/Double;->isFinite(D)Z

    move-result v2

    if-eqz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpl-double v2, v10, v5

    if-ltz v2, :cond_7

    iget-wide v10, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    cmpg-double v2, v10, v3

    if-gtz v2, :cond_7

    return-object v1

    .line 20
    :cond_7
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const/4 v7, 0x3

    if-ge v2, v7, :cond_8

    return-object p2

    .line 21
    :cond_8
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-object v7, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    iget-object v9, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v9}, Ljava/util/ArrayList;->size()I

    move-result v9

    add-int/lit8 v9, v9, -0x2

    invoke-virtual {v7, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 22
    iget-wide v9, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v11, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v17, v3

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide v15, v3

    invoke-static/range {v9 .. v16}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v3

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v11, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v9, v11

    long-to-double v9, v9

    div-double v9, v9, v22

    .line 23
    cmpg-double v5, v9, v5

    if-ltz v5, :cond_10

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-wide v11, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v5, v11

    const-wide/high16 v11, 0x4034000000000000L    # 20.0

    invoke-static {v11, v12, v5, v6}, Ljava/lang/Math;->max(DD)D

    move-result-wide v5

    cmpg-double v5, v3, v5

    if-gez v5, :cond_9

    goto/16 :goto_5

    .line 24
    :cond_9
    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v11, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide v15, v9

    iget-wide v8, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v19, v5

    move-wide/from16 v25, v8

    move-wide/from16 v21, v11

    move-wide/from16 v23, v13

    invoke-static/range {v19 .. v26}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v26

    div-double/2addr v3, v15

    .line 25
    const-wide/high16 v5, 0x4000000000000000L    # 2.0

    cmpg-double v2, v3, v5

    if-ltz v2, :cond_f

    cmpl-double v2, v3, v17

    if-lez v2, :cond_a

    goto/16 :goto_4

    .line 27
    :cond_a
    const/4 v8, 0x1

    :goto_3
    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I

    move-result v2

    const-wide/high16 v5, 0x3fe0000000000000L    # 0.5

    const-wide/high16 v9, 0x4020000000000000L    # 8.0

    if-lt v8, v2, :cond_d

    .line 32
    iget-boolean v0, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v0, :cond_b

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    invoke-static {v7, v8}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_b

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    sub-double/2addr v7, v3

    invoke-static {v7, v8}, Ljava/lang/Math;->abs(D)D

    move-result-wide v7

    iget-wide v11, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    mul-double/2addr v11, v5

    invoke-static {v9, v10, v11, v12}, Ljava/lang/Math;->max(DD)D

    move-result-wide v5

    cmpl-double v0, v7, v5

    if-lez v0, :cond_b

    return-object p2

    .line 33
    :cond_b
    new-instance v19, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-boolean v0, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v0, :cond_c

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    :cond_c
    move-wide/from16 v28, v3

    iget-wide v0, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    const/16 v33, 0x0

    const/16 v34, 0x1

    const/16 v32, 0x1

    move-wide/from16 v30, v0

    move-wide/from16 v20, v5

    move-wide/from16 v22, v7

    move-wide/from16 v24, v9

    invoke-direct/range {v19 .. v34}, Lcom/navipilot/obf/WideCameraEngine$Fix;-><init>(DDDDDJZZZ)V

    return-object v19

    .line 28
    :cond_d
    move-wide/from16 v11, v26

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    add-int/lit8 v13, v8, -0x1

    invoke-virtual {v2, v13}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-object v13, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v13, v8}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v13

    check-cast v13, Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 29
    iget-wide v14, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v22, v5

    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v9, v13, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v26, v3

    iget-wide v3, v13, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v20, v3

    move-wide/from16 v16, v5

    move-wide/from16 v18, v9

    invoke-static/range {v14 .. v21}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v3

    .line 30
    iget-wide v5, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    iget-wide v9, v13, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v5, v9

    mul-double v5, v5, v22

    const-wide/high16 v9, 0x4020000000000000L    # 8.0

    invoke-static {v9, v10, v5, v6}, Ljava/lang/Math;->max(DD)D

    move-result-wide v5

    cmpl-double v3, v3, v5

    if-ltz v3, :cond_e

    iget-wide v14, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v2, v2, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v4, v13, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v9, v13, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v2

    move-wide/from16 v18, v4

    move-wide/from16 v20, v9

    invoke-static/range {v14 .. v21}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v2

    invoke-static {v11, v12, v2, v3}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v2

    const-wide v4, 0x4041800000000000L    # 35.0

    cmpl-double v2, v2, v4

    if-lez v2, :cond_e

    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v7}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    iget-object v0, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    return-object p2

    .line 27
    :cond_e
    add-int/lit8 v8, v8, 0x1

    move-wide/from16 v3, v26

    move-wide/from16 v26, v11

    goto/16 :goto_3

    .line 25
    :cond_f
    :goto_4
    return-object p2

    .line 23
    :cond_10
    :goto_5
    return-object p2

    .line 17
    :cond_11
    move-wide/from16 v17, v3

    iget-object v2, v0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v2, v9}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    move-wide/from16 v3, v17

    const/4 v8, 0x1

    goto/16 :goto_2
.end method

.method clear()V
    .locals 1

    .line 6
    iget-object v0, p0, Lcom/navipilot/obf/WideAlertMotion;->history:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->clear()V

    return-void
.end method
