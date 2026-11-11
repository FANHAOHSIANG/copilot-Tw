.class public final Lcom/navipilot/obf/WideCameraFace;
.super Ljava/lang/Object;
.source "WideCameraFace.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideCameraFace$Model;,
        Lcom/navipilot/obf/WideCameraFace$Painter;
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static color(Lcom/navipilot/obf/WideCameraFace$Model;)I
    .locals 4

    .line 17
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x4

    if-ne v0, v1, :cond_0

    const p0, -0xad1d46

    goto :goto_0

    :cond_0
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_1

    const p0, -0x9d2b01

    goto :goto_0

    :cond_1
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide/high16 v2, 0x4069000000000000L    # 200.0

    cmpg-double v0, v0, v2

    if-gtz v0, :cond_2

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-lez v0, :cond_2

    const p0, -0x9785

    goto :goto_0

    :cond_2
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide v2, 0x407f400000000000L    # 500.0

    cmpg-double v0, v0, v2

    if-gtz v0, :cond_3

    iget p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-lez p0, :cond_3

    const/16 p0, -0x39b3

    goto :goto_0

    :cond_3
    const p0, -0x984801

    :goto_0
    return p0
.end method

.method public static demo(IJ)Lcom/navipilot/obf/WideCameraFace$Model;
    .locals 10

    .line 116
    new-instance v0, Lcom/navipilot/obf/WideCameraFace$Model;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraFace$Model;-><init>()V

    const/4 v1, 0x1

    iput-boolean v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    const/16 v2, 0x3c

    iput v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    iput v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->roadLimit:I

    const-wide/high16 v2, 0x404a000000000000L    # 52.0

    iput-wide v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->speedKph:D

    const-string v2, "\u793a\u7bc4\u9053\u8def"

    iput-object v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->road:Ljava/lang/String;

    const-string v2, "\u793a\u7bc4\u8cc7\u6599\uff0c\u4e0d\u5f71\u97ff GPS \u6216 Carrot"

    iput-object v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    .line 117
    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    const-wide/16 v4, 0x0

    const-wide v6, 0x408f400000000000L    # 1000.0

    if-ne p0, v1, :cond_0

    const-wide/16 v8, 0x3e80

    rem-long/2addr p1, v8

    long-to-double p0, p1

    div-double/2addr p0, v6

    iput v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const-string p2, "\u6e2c\u901f\u793a\u7bc4"

    iput-object p2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    iput-boolean v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    const-wide/high16 v6, 0x4043000000000000L    # 38.0

    mul-double/2addr p0, v6

    const-wide v6, 0x4081800000000000L    # 560.0

    sub-double p0, v6, p0

    invoke-static {v4, v5, p0, p1}, Ljava/lang/Math;->max(DD)D

    move-result-wide p0

    iput-wide p0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    iget-wide p0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    div-double/2addr p0, v6

    sub-double/2addr v2, p0

    iput-wide v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->progress:D

    goto :goto_0

    .line 118
    :cond_0
    const-wide/32 v8, 0xea60

    rem-long/2addr p1, v8

    long-to-double p0, p1

    div-double/2addr p0, v6

    const/4 p2, 0x3

    iput p2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const-string p2, "\u5340\u9593\u793a\u7bc4"

    iput-object p2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    const-wide/high16 v8, 0x402e000000000000L    # 15.0

    mul-double/2addr v8, p0

    sub-double v8, v6, v8

    invoke-static {v4, v5, v8, v9}, Ljava/lang/Math;->max(DD)D

    move-result-wide v8

    iput-wide v8, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide/high16 v8, 0x404e000000000000L    # 60.0

    invoke-static {p0, p1}, Ljava/lang/Math;->floor(D)D

    move-result-wide p0

    sub-double/2addr v8, p0

    invoke-static {v4, v5, v8, v9}, Ljava/lang/Math;->max(DD)D

    move-result-wide p0

    iput-wide p0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->seconds:D

    const-wide/high16 p0, 0x404b000000000000L    # 54.0

    iput-wide p0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->average:D

    iget-wide p0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    div-double/2addr p0, v6

    sub-double/2addr v2, p0

    iput-wide v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->progress:D

    .line 119
    :goto_0
    return-object v0
.end method

.method private static detail(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;
    .locals 3

    .line 51
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_0

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u5c1a\u9700 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->seconds:D

    invoke-static {v1, v2}, Ljava/lang/Math;->round(D)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u79d2 \u00b7 \u5747\u901f "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->average:D

    invoke-static {v1, v2}, Ljava/lang/Math;->round(D)J

    move-result-wide v1

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, " \u00b7 \u4f30\u7b97"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 52
    :cond_0
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    if-eqz v0, :cond_1

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    if-lez v0, :cond_1

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6e2c\u901f\u9650\u901f "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, " \u00b7 \u6cbf\u9053\u8def\u8ddd\u96e2"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 53
    :cond_1
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-lez v0, :cond_2

    iget-object p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    return-object p0

    .line 54
    :cond_2
    const-string p0, "\u7b49\u5f85 GPS \u8207\u9053\u8def\u8cc7\u6599"

    return-object p0
.end method

.method public static distanceEmphasis(Lcom/navipilot/obf/WideCameraFace$Model;)F
    .locals 6

    .line 36
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraFace;->hasDistance(Lcom/navipilot/obf/WideCameraFace$Model;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x3

    if-ne v0, v1, :cond_0

    goto :goto_0

    .line 37
    :cond_0
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide v2, 0x407f400000000000L    # 500.0

    sub-double v0, v2, v0

    div-double/2addr v0, v2

    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->min(DD)D

    move-result-wide v0

    const-wide/16 v4, 0x0

    invoke-static {v4, v5, v0, v1}, Ljava/lang/Math;->max(DD)D

    move-result-wide v0

    .line 38
    const-wide v4, 0x3fe4cccccccccccdL    # 0.65

    mul-double/2addr v0, v4

    add-double/2addr v0, v2

    double-to-float p0, v0

    return p0

    .line 36
    :cond_1
    :goto_0
    const/high16 p0, 0x3f800000    # 1.0f

    return p0
.end method

.method private static distanceSize(Lcom/navipilot/obf/WideCameraFace$Model;F)F
    .locals 2

    .line 41
    const v0, 0x3ee66666    # 0.45f

    mul-float/2addr v0, p1

    const/high16 v1, 0x42100000    # 36.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    const/high16 v1, 0x41600000    # 14.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    .line 42
    const/high16 v1, 0x3f400000    # 0.75f

    mul-float/2addr p1, v1

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 43
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraFace;->distanceEmphasis(Lcom/navipilot/obf/WideCameraFace$Model;)F

    move-result p0

    mul-float/2addr v0, p0

    invoke-static {p1, v0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    return p0
.end method

.method public static draw(Lcom/navipilot/obf/WideCameraFace$Painter;FFLcom/navipilot/obf/WideCameraFace$Model;J)V
    .locals 31

    .line 57
    move-object/from16 v8, p3

    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->color(Lcom/navipilot/obf/WideCameraFace$Model;)I

    move-result v9

    .line 58
    const/4 v5, 0x0

    const v6, -0xf4ebde

    const/4 v1, 0x0

    const/4 v2, 0x0

    move-object/from16 v0, p0

    move/from16 v3, p1

    move/from16 v4, p2

    invoke-interface/range {v0 .. v6}, Lcom/navipilot/obf/WideCameraFace$Painter;->rect(FFFFFI)V

    .line 59
    const/4 v0, 0x0

    cmpg-float v1, p1, v0

    if-lez v1, :cond_19

    cmpg-float v0, p2, v0

    if-gtz v0, :cond_0

    goto/16 :goto_14

    .line 61
    :cond_0
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->hasDistance(Lcom/navipilot/obf/WideCameraFace$Model;)Z

    move-result v10

    .line 62
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->visibleLimit(Lcom/navipilot/obf/WideCameraFace$Model;)I

    move-result v11

    .line 65
    const/high16 v0, 0x43340000    # 180.0f

    cmpg-float v0, p1, v0

    const-string v1, " m"

    const/high16 v16, 0x40e00000    # 7.0f

    const/high16 v17, 0x3e800000    # 0.25f

    const/high16 v18, 0x41900000    # 18.0f

    const/high16 v19, 0x41100000    # 9.0f

    const/high16 v2, 0x41a00000    # 20.0f

    const/high16 v3, 0x41c00000    # 24.0f

    const v20, -0x80401

    const v5, -0x6b5643

    if-ltz v0, :cond_f

    const/high16 v0, 0x42d20000    # 105.0f

    cmpg-float v0, p2, v0

    if-gez v0, :cond_1

    move-object v12, v1

    move v13, v2

    move/from16 v24, v3

    move/from16 v22, v5

    move/from16 v5, v20

    const/high16 p5, 0x40800000    # 4.0f

    const/high16 v21, 0x41000000    # 8.0f

    const/high16 v23, 0x41700000    # 15.0f

    goto/16 :goto_c

    .line 84
    :cond_1
    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    if-eqz v0, :cond_2

    const-string v0, "\u793a\u7bc4\u901f\u5ea6"

    goto :goto_0

    :cond_2
    const-string v0, "\u5373\u6642\u6642\u901f \u00b7 GPS"

    :goto_0
    const v4, 0x3ed70a3d    # 0.42f

    mul-float v6, p1, v4

    const/4 v7, 0x0

    move v4, v2

    const/high16 v2, 0x41100000    # 9.0f

    move/from16 v21, v3

    const/high16 v3, 0x41880000    # 17.0f

    move/from16 v22, v4

    const/high16 v4, 0x41300000    # 11.0f

    move-object v12, v1

    move/from16 v15, v21

    move/from16 v13, v22

    const/high16 p5, 0x40800000    # 4.0f

    const/high16 v21, 0x41000000    # 8.0f

    move-object v1, v0

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 85
    move/from16 v22, v5

    const/high16 v0, 0x437a0000    # 250.0f

    cmpl-float v0, p1, v0

    if-ltz v0, :cond_5

    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    if-eqz v0, :cond_3

    const-string v0, "\u793a\u7bc4 \u00b7 \u4e0d\u50b3\u9001"

    goto :goto_1

    :cond_3
    iget-object v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->badge:Ljava/lang/String;

    :goto_1
    move-object v1, v0

    const v0, 0x3f1eb852    # 0.62f

    mul-float v2, p1, v0

    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    if-eqz v0, :cond_4

    const v5, -0x465801

    goto :goto_2

    :cond_4
    move/from16 v5, v22

    :goto_2
    const v0, 0x3eae147b    # 0.34f

    mul-float v6, p1, v0

    const/4 v7, 0x0

    const/high16 v3, 0x41880000    # 17.0f

    const/high16 v4, 0x41200000    # 10.0f

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 86
    :cond_5
    const/high16 v0, 0x431b0000    # 155.0f

    cmpl-float v0, p2, v0

    if-ltz v0, :cond_6

    const/16 v0, 0x32

    goto :goto_3

    :cond_6
    const/16 v0, 0x26

    :goto_3
    int-to-float v0, v0

    .line 87
    sub-float v1, p2, v0

    sub-float v16, v1, v16

    .line 88
    sub-float v1, v16, v15

    sub-float v1, v1, p5

    const/high16 v2, 0x41f00000    # 30.0f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 89
    mul-float v3, p1, v17

    sub-float v3, v3, v19

    const/high16 v4, 0x41e00000    # 28.0f

    invoke-static {v4, v3}, Ljava/lang/Math;->max(FF)F

    move-result v6

    .line 90
    const v3, 0x3f170a3d    # 0.59f

    mul-float/2addr v3, v1

    const/high16 v4, 0x42440000    # 49.0f

    invoke-static {v4, v3}, Ljava/lang/Math;->min(FF)F

    move-result v3

    invoke-static {v13, v3}, Ljava/lang/Math;->max(FF)F

    move-result v4

    .line 91
    const v3, 0x3f2e147b    # 0.68f

    mul-float/2addr v3, v1

    add-float/2addr v3, v15

    add-float v17, v1, v15

    const/high16 v5, 0x41300000    # 11.0f

    sub-float v7, v17, v5

    invoke-static {v3, v7}, Ljava/lang/Math;->min(FF)F

    move-result v3

    .line 92
    move v7, v1

    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->speed(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v1

    move/from16 v23, v2

    const/high16 v2, 0x41100000    # 9.0f

    move/from16 v24, v7

    const/4 v7, 0x0

    move/from16 v25, v23

    move/from16 v14, v24

    const/high16 v23, 0x41700000    # 15.0f

    move/from16 v24, v15

    move v15, v5

    move/from16 v5, v20

    move/from16 v20, v0

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 93
    move/from16 v26, v5

    const/high16 v0, 0x3f800000    # 1.0f

    sub-float v3, v17, v0

    const/high16 v4, 0x41200000    # 10.0f

    const-string v1, "km/h"

    move-object/from16 v0, p0

    move/from16 v5, v22

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 94
    const v22, 0x3f11eb85    # 0.57f

    if-eqz v10, :cond_7

    const v1, 0x3ed1eb85    # 0.41f

    mul-float v1, v1, p1

    goto :goto_4

    :cond_7
    mul-float v1, p1, v22

    :goto_4
    move v2, v1

    .line 95
    const v1, 0x3df5c28f    # 0.12f

    mul-float v1, v1, p1

    const/high16 v27, 0x41800000    # 16.0f

    sub-float v3, v14, v27

    const/high16 v28, 0x40000000    # 2.0f

    div-float v3, v3, v28

    invoke-static {v1, v3}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const/high16 v3, 0x42180000    # 38.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    invoke-static {v15, v1}, Ljava/lang/Math;->max(FF)F

    move-result v15

    .line 96
    const v1, 0x3edc28f6    # 0.43f

    mul-float/2addr v1, v14

    add-float v1, v1, v24

    .line 97
    const/high16 v29, 0x40400000    # 3.0f

    if-lez v11, :cond_9

    .line 98
    invoke-static {v0, v2, v1, v15, v11}, Lcom/navipilot/obf/WideCameraFace;->speedSign(Lcom/navipilot/obf/WideCameraFace$Painter;FFFI)V

    .line 99
    iget v3, v8, Lcom/navipilot/obf/WideCameraFace$Model;->roadLimit:I

    if-lez v3, :cond_8

    const-string v3, "\u9053\u8def\u901f\u9650"

    goto :goto_5

    :cond_8
    const-string v3, "\u6e2c\u901f\u901f\u9650"

    :goto_5
    sub-float v4, v16, v29

    add-float/2addr v1, v15

    const/high16 v6, 0x41400000    # 12.0f

    add-float/2addr v1, v6

    invoke-static {v4, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    mul-float v4, v15, v28

    add-float v6, v4, v25

    const/4 v7, 0x1

    const/high16 v4, 0x41100000    # 9.0f

    move-object/from16 v30, v3

    move v3, v1

    move-object/from16 v1, v30

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    move/from16 v25, v5

    goto :goto_6

    .line 97
    :cond_9
    move/from16 v25, v5

    .line 101
    :goto_6
    if-eqz v10, :cond_c

    .line 102
    if-lez v11, :cond_a

    mul-float v0, p1, v22

    add-float/2addr v2, v15

    add-float v2, v2, v21

    invoke-static {v0, v2}, Ljava/lang/Math;->max(FF)F

    move-result v0

    goto :goto_7

    :cond_a
    const v0, 0x3ef5c28f    # 0.48f

    mul-float v0, v0, p1

    :goto_7
    move v2, v0

    .line 103
    sub-float v0, p1, v2

    sub-float v0, v0, v19

    invoke-static {v13, v0}, Ljava/lang/Math;->max(FF)F

    move-result v6

    .line 104
    new-instance v0, Ljava/lang/StringBuilder;

    iget-wide v3, v8, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v3, v4}, Ljava/lang/Math;->round(D)J

    move-result-wide v3

    invoke-static {v3, v4}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const v0, 0x3f28f5c3    # 0.66f

    mul-float/2addr v0, v14

    add-float v3, v0, v24

    invoke-static {v8, v14}, Lcom/navipilot/obf/WideCameraFace;->distanceSize(Lcom/navipilot/obf/WideCameraFace$Model;F)F

    move-result v4

    const/4 v7, 0x0

    move-object/from16 v0, p0

    move v5, v9

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 105
    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v0, :cond_b

    const-string v0, "直線距離"

    goto :goto_8

    :cond_b
    const-string v0, "\u8ddd\u6e2c\u901f"

    :goto_8
    move-object v1, v0

    sub-float v0, v16, v29

    sub-float v3, v17, v28

    invoke-static {v0, v3}, Ljava/lang/Math;->min(FF)F

    move-result v3

    const/high16 v4, 0x41200000    # 10.0f

    const/4 v7, 0x0

    move-object/from16 v0, p0

    move/from16 v5, v25

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    move/from16 v22, v5

    goto :goto_9

    .line 101
    :cond_c
    move/from16 v22, v25

    .line 107
    :goto_9
    sub-float v3, p1, v18

    const/high16 v5, 0x41000000    # 8.0f

    const v6, -0xe8dac8

    const/high16 v1, 0x41100000    # 9.0f

    move-object/from16 v0, p0

    move/from16 v2, v16

    move/from16 v4, v20

    invoke-interface/range {v0 .. v6}, Lcom/navipilot/obf/WideCameraFace$Painter;->rect(FFFFFI)V

    .line 108
    move v9, v2

    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->title(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v1

    add-float v16, v9, v23

    sub-float v6, v3, v27

    const/4 v7, 0x0

    const/high16 v2, 0x41880000    # 17.0f

    const/high16 v4, 0x41400000    # 12.0f

    move/from16 v3, v16

    move/from16 v5, v26

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 109
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->detail(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v1

    const/high16 v0, 0x42480000    # 50.0f

    cmpl-float v0, v20, v0

    if-ltz v0, :cond_d

    const/16 v0, 0x23

    goto :goto_a

    :cond_d
    const/16 v0, 0x1e

    :goto_a
    int-to-float v0, v0

    add-float v3, v9, v0

    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v0, :cond_e

    const/16 v5, -0x3986

    goto :goto_b

    :cond_e
    move/from16 v5, v22

    :goto_b
    const/4 v7, 0x0

    const/high16 v2, 0x41880000    # 17.0f

    const/high16 v4, 0x41200000    # 10.0f

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 110
    return-void

    .line 65
    :cond_f
    move-object v12, v1

    move v13, v2

    move/from16 v24, v3

    move/from16 v22, v5

    move/from16 v5, v20

    const/high16 p5, 0x40800000    # 4.0f

    const/high16 v21, 0x41000000    # 8.0f

    const/high16 v23, 0x41700000    # 15.0f

    .line 66
    :goto_c
    mul-float v0, p1, v17

    sub-float v0, v0, v16

    move/from16 v15, v24

    invoke-static {v15, v0}, Ljava/lang/Math;->max(FF)F

    move-result v6

    .line 67
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->speed(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v1

    const v0, 0x3ee66666    # 0.45f

    mul-float v0, v0, p2

    const/high16 v2, 0x42000000    # 32.0f

    invoke-static {v2, v0}, Ljava/lang/Math;->min(FF)F

    move-result v3

    const v0, 0x3ea8f5c3    # 0.33f

    mul-float v0, v0, p2

    invoke-static {v15, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    const/high16 v2, 0x41600000    # 14.0f

    invoke-static {v2, v0}, Ljava/lang/Math;->max(FF)F

    move-result v4

    const/4 v7, 0x0

    const/high16 v2, 0x41100000    # 9.0f

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 68
    const/high16 v0, 0x42400000    # 48.0f

    cmpl-float v0, p2, v0

    if-ltz v0, :cond_10

    const/high16 v0, 0x40a00000    # 5.0f

    sub-float v0, p2, v0

    const/high16 v1, 0x423c0000    # 47.0f

    invoke-static {v0, v1}, Ljava/lang/Math;->min(FF)F

    move-result v3

    const/high16 v4, 0x41100000    # 9.0f

    const/4 v7, 0x0

    const-string v1, "GPS"

    const/high16 v2, 0x41100000    # 9.0f

    move-object/from16 v0, p0

    move/from16 v5, v22

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    goto :goto_d

    :cond_10
    move-object/from16 v0, p0

    .line 69
    :goto_d
    if-lez v11, :cond_11

    const/high16 v1, 0x42b40000    # 90.0f

    cmpl-float v1, p1, v1

    if-lez v1, :cond_11

    .line 70
    const v1, 0x3db851ec    # 0.09f

    mul-float v1, v1, p1

    const v2, 0x3e3851ec    # 0.18f

    mul-float v2, v2, p2

    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    move/from16 v2, v23

    invoke-static {v2, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    move/from16 v2, v21

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 71
    const v2, 0x3ecccccd    # 0.4f

    mul-float v2, v2, p1

    add-float v3, v1, p5

    const v4, 0x3ebd70a4    # 0.37f

    mul-float v4, v4, p2

    const/high16 v5, 0x41d80000    # 27.0f

    invoke-static {v4, v5}, Ljava/lang/Math;->min(FF)F

    move-result v4

    invoke-static {v3, v4}, Ljava/lang/Math;->max(FF)F

    move-result v3

    invoke-static {v0, v2, v3, v1, v11}, Lcom/navipilot/obf/WideCameraFace;->speedSign(Lcom/navipilot/obf/WideCameraFace$Painter;FFFI)V

    .line 73
    :cond_11
    const/high16 v11, 0x40c00000    # 6.0f

    const/high16 v14, 0x42580000    # 54.0f

    if-eqz v10, :cond_14

    .line 74
    const v1, 0x3f147ae1    # 0.58f

    mul-float v2, p1, v1

    sub-float v1, p1, v2

    sub-float v1, v1, v19

    invoke-static {v13, v1}, Ljava/lang/Math;->max(FF)F

    move-result v6

    const v1, 0x3f19999a    # 0.6f

    mul-float v1, v1, p2

    const/high16 v3, 0x42300000    # 44.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const/high16 v3, 0x41b00000    # 22.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 75
    new-instance v3, Ljava/lang/StringBuilder;

    iget-wide v4, v8, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v4, v5}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const/high16 v4, 0x41880000    # 17.0f

    sub-float v4, p2, v4

    const v5, 0x3f0a3d71    # 0.54f

    mul-float v5, v5, p2

    const/high16 v7, 0x41c80000    # 25.0f

    invoke-static {v7, v5}, Ljava/lang/Math;->max(FF)F

    move-result v5

    invoke-static {v4, v5}, Ljava/lang/Math;->min(FF)F

    move-result v4

    invoke-static {v8, v1}, Lcom/navipilot/obf/WideCameraFace;->distanceSize(Lcom/navipilot/obf/WideCameraFace$Model;F)F

    move-result v1

    const/4 v7, 0x0

    move v5, v4

    move v4, v1

    move-object v1, v3

    move v3, v5

    move v5, v9

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 76
    cmpl-float v0, p2, v14

    if-ltz v0, :cond_18

    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v0, :cond_12

    const-string v0, "同向候選 · 道路未確認"

    goto :goto_e

    :cond_12
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->title(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v0

    :goto_e
    move-object v1, v0

    sub-float v3, p2, v11

    iget-boolean v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v0, :cond_13

    const/16 v5, -0x3986

    goto :goto_f

    :cond_13
    move/from16 v5, v22

    :goto_f
    sub-float v6, p1, v18

    const/4 v7, 0x0

    const/high16 v2, 0x41100000    # 9.0f

    const/high16 v4, 0x41200000    # 10.0f

    move-object/from16 v0, p0

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    goto :goto_12

    .line 77
    :cond_14
    cmpl-float v0, p2, v14

    if-ltz v0, :cond_17

    .line 78
    iget-object v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    if-eqz v0, :cond_16

    iget-object v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_15

    goto :goto_10

    :cond_15
    iget-object v0, v8, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    goto :goto_11

    :cond_16
    :goto_10
    invoke-static {v8}, Lcom/navipilot/obf/WideCameraFace;->title(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;

    move-result-object v0

    :goto_11
    move-object v1, v0

    .line 79
    sub-float v3, p2, v11

    sub-float v6, p1, v18

    const/4 v7, 0x0

    const/high16 v2, 0x41100000    # 9.0f

    const/high16 v4, 0x41200000    # 10.0f

    move-object/from16 v0, p0

    move/from16 v5, v22

    invoke-interface/range {v0 .. v7}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    goto :goto_13

    .line 77
    :cond_17
    :goto_12
    nop

    .line 81
    :cond_18
    :goto_13
    return-void

    .line 59
    :cond_19
    :goto_14
    return-void
.end method

.method static flashPeriodMs(Lcom/navipilot/obf/WideCameraFace$Model;)D
    .locals 4

    .line 25
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide v2, 0x407f400000000000L    # 500.0

    div-double/2addr v0, v2

    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    sub-double/2addr v2, v0

    const-wide/16 v0, 0x0

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Math;->max(DD)D

    move-result-wide v0

    const-wide/high16 v2, 0x4089000000000000L    # 800.0

    mul-double/2addr v0, v2

    const-wide v2, 0x4092c00000000000L    # 1200.0

    sub-double/2addr v2, v0

    return-wide v2
.end method

.method static hasDistance(Lcom/navipilot/obf/WideCameraFace$Model;)Z
    .locals 6

    .line 32
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v2, 0x2

    if-eq v0, v2, :cond_0

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v2, 0x3

    if-ne v0, v2, :cond_1

    :cond_0
    iget-wide v2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v2, v3}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-wide v2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide/16 v4, 0x0

    cmpl-double p0, v2, v4

    if-ltz p0, :cond_1

    return v1

    :cond_1
    const/4 p0, 0x0

    return p0
.end method

.method private static speed(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;
    .locals 2

    .line 45
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->speedKph:D

    invoke-static {v0, v1}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->speedKph:D

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide v0

    invoke-static {v0, v1}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_0
    const-string p0, "\u2014"

    :goto_0
    return-object p0
.end method

.method private static speedSign(Lcom/navipilot/obf/WideCameraFace$Painter;FFFI)V
    .locals 14

    .line 112
    const/4 v4, 0x0

    const v5, -0x60401

    move-object v0, p0

    move v1, p1

    move/from16 v2, p2

    move/from16 v3, p3

    invoke-interface/range {v0 .. v5}, Lcom/navipilot/obf/WideCameraFace$Painter;->circle(FFFFI)V

    const/high16 v0, 0x40200000    # 2.5f

    sub-float v0, p3, v0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v9

    const v0, 0x3e99999a    # 0.3f

    mul-float v0, v0, p3

    const/high16 v1, 0x40800000    # 4.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v10

    const v11, -0x10ad9c

    move-object v6, p0

    move v7, p1

    move/from16 v8, p2

    invoke-interface/range {v6 .. v11}, Lcom/navipilot/obf/WideCameraFace$Painter;->circle(FFFFI)V

    .line 113
    invoke-static/range {p4 .. p4}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v7

    const v0, 0x3e947ae1    # 0.29f

    mul-float v0, v0, p3

    add-float v9, p2, v0

    const v0, 0x3f733333    # 0.95f

    mul-float v0, v0, p3

    const/high16 v1, 0x41200000    # 10.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v10

    const v0, 0x3fd9999a    # 1.7f

    mul-float v12, p3, v0

    const/4 v13, 0x1

    const v11, -0xeee5db

    move v8, p1

    invoke-interface/range {v6 .. v13}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 114
    return-void
.end method

.method private static title(Lcom/navipilot/obf/WideCameraFace$Model;)Ljava/lang/String;
    .locals 1

    .line 47
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    if-eqz v0, :cond_1

    iget p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v0, 0x3

    if-ne p0, v0, :cond_0

    const-string p0, "\u5340\u9593\u793a\u7bc4"

    goto :goto_0

    :cond_0
    const-string p0, "\u56fa\u5b9a\u6e2c\u901f\u793a\u7bc4"

    :goto_0
    return-object p0

    .line 48
    :cond_1
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v0

    if-nez v0, :cond_2

    goto :goto_1

    :cond_2
    iget-object p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    goto :goto_2

    :cond_3
    :goto_1
    const-string p0, "\u7b49\u5f85\u6e2c\u901f\u8cc7\u8a0a"

    :goto_2
    return-object p0
.end method

.method public static visibleLimit(Lcom/navipilot/obf/WideCameraFace$Model;)I
    .locals 1

    .line 28
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->roadLimit:I

    if-lez v0, :cond_0

    iget p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->roadLimit:I

    return p0

    .line 29
    :cond_0
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    if-eqz v0, :cond_1

    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->uncertain:Z

    if-nez v0, :cond_1

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    if-lez v0, :cond_1

    iget p0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method public static warningStrength(Lcom/navipilot/obf/WideCameraFace$Model;)F
    .locals 5

    .line 19
    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eq v0, v1, :cond_0

    iget v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_4

    :cond_0
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->uncertain:Z

    if-nez v0, :cond_4

    .line 20
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->demo:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    if-nez v0, :cond_1

    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v0, :cond_4

    :cond_1
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v0, v1}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 21
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide/16 v3, 0x0

    cmpg-double v0, v0, v3

    if-gez v0, :cond_2

    goto :goto_1

    .line 22
    :cond_2
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide v3, 0x407f400000000000L    # 500.0

    cmpl-double v0, v0, v3

    if-lez v0, :cond_3

    goto :goto_0

    :cond_3
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    div-double/2addr v0, v3

    const-wide/high16 v2, 0x3ff0000000000000L    # 1.0

    sub-double/2addr v2, v0

    const-wide v0, 0x3feb851eb851eb85L    # 0.86

    mul-double/2addr v2, v0

    const-wide v0, 0x3fc1eb851eb851ecL    # 0.14

    add-double/2addr v2, v0

    double-to-float v2, v2

    :goto_0
    return v2

    .line 21
    :cond_4
    :goto_1
    return v2
.end method
