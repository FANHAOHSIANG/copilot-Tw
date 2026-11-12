.class public final Lcom/navipilot/obf/WideDashboardFace;
.super Ljava/lang/Object;
.source "WideDashboardFace.java"


# static fields
.field private static final AMBER:I = -0x2f8b

.field private static final BG:I = -0xf6ece0

.field private static final BLUE:I = -0x812901

.field private static final CARD:I = -0xedddc8

.field private static final INK:I = -0x120a01

.field private static final MUTED:I = -0x5b4732


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static flag(Ljava/lang/String;Ljava/lang/Boolean;)Ljava/lang/String;
    .registers 3

    .line 6
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-nez p1, :cond_e

    const-string p0, " \u2014"

    goto :goto_19

    :cond_e
    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result p0

    if-eqz p0, :cond_17

    const-string p0, " \u5df2\u63a5\u7ba1"

    goto :goto_19

    :cond_17
    const-string p0, " \u672a\u63a5\u7ba1"

    :goto_19
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static render(Lcom/navipilot/obf/WideCameraFace$Painter;FFLcom/navipilot/obf/WideCameraFace$Model;JZI)V
    .registers 36

    .line 8
    move-object/from16 v0, p3

    const/high16 v1, 0x43660000    # 230.0f

    cmpg-float v1, p1, v1

    if-ltz v1, :cond_31f

    const/high16 v1, 0x438c0000    # 280.0f

    cmpg-float v1, p2, v1

    if-gez v1, :cond_10

    goto/16 :goto_31f

    .line 9
    :cond_10
    invoke-static {}, Lcom/navipilot/obf/WideVehiclePanel;->current()Lcom/navipilot/obf/WideVehiclePanel$State;

    move-result-object v1

    const/4 v2, 0x0

    const/4 v3, 0x1

    if-nez p6, :cond_22

    iget-wide v4, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    invoke-static {v4, v5}, Ljava/lang/Double;->isFinite(D)Z

    move-result v4

    if-eqz v4, :cond_22

    move v4, v3

    goto :goto_23

    :cond_22
    move v4, v2

    :goto_23
    if-eqz p6, :cond_28

    const-wide/high16 v5, 0x404d000000000000L    # 58.0

    goto :goto_2f

    :cond_28
    if-eqz v4, :cond_2d

    iget-wide v5, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    goto :goto_2f

    :cond_2d
    iget-wide v5, v0, Lcom/navipilot/obf/WideCameraFace$Model;->speedKph:D

    .line 10
    :goto_2f
    const v7, 0x3ee66666    # 0.45f

    mul-float v8, p2, v7

    const/high16 v9, 0x41100000    # 9.0f

    add-float v12, v8, v9

    .line 11
    const/16 v18, 0x0

    const v19, -0xf6ece0

    const/4 v14, 0x0

    const/4 v15, 0x0

    move-object/from16 v13, p0

    move/from16 v16, p1

    move/from16 v17, p2

    invoke-interface/range {v13 .. v19}, Lcom/navipilot/obf/WideCameraFace$Painter;->rect(FFFFFI)V

    const/high16 v9, 0x41a00000    # 20.0f

    sub-float v13, p1, v9

    const/high16 v11, 0x41200000    # 10.0f

    sub-float v24, v8, v11

    const/high16 v25, 0x41400000    # 12.0f

    const v26, -0xedddc8

    move/from16 v22, v11

    move-object/from16 v20, p0

    move/from16 v21, v11

    move/from16 v23, v13

    invoke-interface/range {v20 .. v26}, Lcom/navipilot/obf/WideCameraFace$Painter;->rect(FFFFFI)V

    const v10, 0x3edc28f6    # 0.43f

    mul-float v26, p1, v10

    const/16 v27, 0x0

    const-string v21, "\u5373\u6642\u8eca\u6cc1"

    const/high16 v22, 0x41b00000    # 22.0f

    const/high16 v23, 0x41f00000    # 30.0f

    const/high16 v24, 0x41500000    # 13.0f

    const v25, -0x120a01

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    move/from16 v10, v26

    if-eqz p6, :cond_7e

    const-string v4, "\u793a\u610f"

    :goto_7b
    move-object/from16 v21, v4

    goto :goto_86

    :cond_7e
    if-eqz v4, :cond_83

    const-string v4, "C4 \u8eca\u901f"

    goto :goto_7b

    :cond_83
    const-string v4, "GPS \u8eca\u901f"

    goto :goto_7b

    :goto_86
    const v4, 0x3f428f5c    # 0.76f

    mul-float v22, p1, v4

    const v4, 0x3ecccccd    # 0.4f

    mul-float v26, p1, v4

    const/16 v27, 0x1

    const/high16 v23, 0x41f00000    # 30.0f

    const/high16 v24, 0x41300000    # 11.0f

    const v25, -0x812901

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 12
    invoke-static {v5, v6}, Ljava/lang/Double;->isFinite(D)Z

    move-result v4

    const-string v17, "\u2014"

    if-eqz v4, :cond_b1

    invoke-static {v5, v6}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v4

    move-object/from16 v21, v4

    goto :goto_b3

    :cond_b1
    move-object/from16 v21, v17

    :goto_b3
    const/high16 v4, 0x42180000    # 38.0f

    sub-float v23, v8, v4

    const/high16 v4, 0x3f000000    # 0.5f

    mul-float/2addr v4, v8

    const/high16 v5, 0x42880000    # 68.0f

    invoke-static {v5, v4}, Ljava/lang/Math;->min(FF)F

    move-result v24

    mul-float v26, p1, v7

    const/16 v27, 0x0

    const/high16 v22, 0x41c00000    # 24.0f

    const v25, -0x120a01

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    const/high16 v4, 0x42200000    # 40.0f

    sub-float v23, v8, v4

    const v4, 0x3e23d70a    # 0.16f

    mul-float v26, p1, v4

    const-string v21, "km/h"

    const/high16 v24, 0x41400000    # 12.0f

    const v25, -0x5b4732

    move/from16 v22, v10

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 13
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraFace;->visibleLimit(Lcom/navipilot/obf/WideCameraFace$Model;)I

    move-result v4

    if-lez v4, :cond_eb

    move v5, v4

    goto :goto_ed

    :cond_eb
    move/from16 v5, p7

    :goto_ed
    const/high16 v6, 0x41500000    # 13.0f

    if-lez v5, :cond_15e

    const/high16 v7, 0x3e800000    # 0.25f

    mul-float/2addr v7, v8

    const/high16 v10, 0x41e80000    # 29.0f

    invoke-static {v10, v7}, Ljava/lang/Math;->min(FF)F

    move-result v24

    const v7, 0x3f4a3d71    # 0.79f

    mul-float v21, p1, v7

    const v7, 0x3f051eb8    # 0.52f

    mul-float v22, v8, v7

    move/from16 v23, v24

    const/16 v24, 0x0

    const v25, -0x60401

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v25}, Lcom/navipilot/obf/WideCameraFace$Painter;->circle(FFFFI)V

    move/from16 v7, v23

    const/high16 v10, 0x40000000    # 2.0f

    sub-float v23, v7, v10

    const/high16 v24, 0x40800000    # 4.0f

    const v25, -0xc9688

    invoke-interface/range {v20 .. v25}, Lcom/navipilot/obf/WideCameraFace$Painter;->circle(FFFFI)V

    move/from16 v14, v22

    invoke-static {v5}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    const v15, 0x3e99999a    # 0.3f

    mul-float v24, v7, v15

    add-float v23, v14, v24

    const v15, 0x3fd33333    # 1.65f

    mul-float v26, v7, v15

    const/16 v27, 0x1

    const v25, -0xe8dac9

    move/from16 v24, v7

    move/from16 v22, v21

    move-object/from16 v21, v5

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    move/from16 v21, v22

    move/from16 v23, v24

    if-gtz v4, :cond_15e

    add-float v22, v14, v23

    add-float v22, v22, v6

    mul-float v24, v23, v10

    add-float v26, v24, v9

    const/16 v27, 0x1

    move/from16 v23, v22

    move/from16 v22, v21

    const-string v21, "\u66ab\u5b58\u901f\u9650"

    const/high16 v24, 0x41100000    # 9.0f

    const v25, -0x5b4732

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 14
    :cond_15e
    if-eqz p6, :cond_163

    const-string v1, "\u6a6b\u5411 \u5df2\u63a5\u7ba1 \u00b7 \u7e31\u5411 \u5df2\u63a5\u7ba1"

    goto :goto_18a

    :cond_163
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "\u6a6b\u5411"

    iget-object v7, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->lateral:Ljava/lang/Boolean;

    invoke-static {v5, v7}, Lcom/navipilot/obf/WideDashboardFace;->flag(Ljava/lang/String;Ljava/lang/Boolean;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v5, " \u00b7 "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "\u7e31\u5411"

    iget-object v1, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->longitudinal:Ljava/lang/Boolean;

    invoke-static {v5, v1}, Lcom/navipilot/obf/WideDashboardFace;->flag(Ljava/lang/String;Ljava/lang/Boolean;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_18a
    move-object/from16 v21, v1

    sub-float v23, v8, v6

    const/high16 v1, 0x42300000    # 44.0f

    sub-float v26, p1, v1

    const/16 v27, 0x0

    const/high16 v22, 0x41b00000    # 22.0f

    const/high16 v24, 0x41300000    # 11.0f

    const v25, -0x5b4732

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 15
    sub-float v1, p2, v12

    sub-float v14, v1, v11

    const/high16 v15, 0x41400000    # 12.0f

    const v16, -0xedddc8

    move-object/from16 v10, p0

    invoke-interface/range {v10 .. v16}, Lcom/navipilot/obf/WideCameraFace$Painter;->rect(FFFFFI)V

    .line 16
    iget v4, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    const/4 v5, 0x3

    if-lt v4, v3, :cond_1c9

    iget v4, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-gt v4, v5, :cond_1c9

    iget-wide v6, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v6, v7}, Ljava/lang/Double;->isFinite(D)Z

    move-result v4

    if-eqz v4, :cond_1c9

    iget-wide v6, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide/16 v8, 0x0

    cmpl-double v4, v6, v8

    if-ltz v4, :cond_1c9

    move v4, v3

    goto :goto_1ca

    :cond_1c9
    move v4, v2

    .line 17
    :goto_1ca
    if-eqz p6, :cond_1ce

    const/4 v6, 0x0

    goto :goto_1d2

    :cond_1ce
    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->guidance()Lorg/json/JSONObject;

    move-result-object v6

    :goto_1d2
    const-string v7, "distance_m"

    if-eqz v6, :cond_1f3

    if-eqz v4, :cond_1f2

    iget v8, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-eq v8, v5, :cond_1f3

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-wide v10, 0x408f400000000000L    # 1000.0

    cmpl-double v8, v8, v10

    if-lez v8, :cond_1f3

    const v8, 0x186a1

    invoke-virtual {v6, v7, v8}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v8

    const/16 v9, 0x3e8

    if-gt v8, v9, :cond_1f3

    :cond_1f2
    move v2, v3

    .line 18
    :cond_1f3
    if-eqz v2, :cond_1fe

    const-string v3, "main_text"

    const-string v8, "\u4e0b\u4e00\u500b\u8f49\u5f4e"

    invoke-virtual {v6, v3, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    goto :goto_205

    :cond_1fe
    if-eqz v4, :cond_203

    iget-object v3, v0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    goto :goto_205

    :cond_203
    const-string v3, "\u524d\u65b9\u9053\u8def\u63d0\u9192"

    :goto_205
    if-nez v3, :cond_209

    const-string v3, "\u524d\u65b9\u63d0\u9192"

    :cond_209
    move-object/from16 v21, v3

    const/high16 v3, 0x41c80000    # 25.0f

    add-float v23, v12, v3

    const v25, -0x120a01

    const/16 v27, 0x0

    const/high16 v22, 0x41b00000    # 22.0f

    const/high16 v24, 0x41600000    # 14.0f

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 19
    const-string v3, " m"

    if-eqz v2, :cond_239

    new-instance v8, Ljava/lang/StringBuilder;

    invoke-virtual {v6, v7}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;)I

    move-result v7

    invoke-static {v7}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v7

    invoke-direct {v8, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    :goto_232
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v17

    :cond_236
    move-object/from16 v21, v17

    goto :goto_24f

    :cond_239
    if-eqz v4, :cond_236

    new-instance v7, Ljava/lang/StringBuilder;

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    invoke-static {v8, v9}, Ljava/lang/Math;->round(D)J

    move-result-wide v8

    invoke-static {v8, v9}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object v8

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    goto :goto_232

    :goto_24f
    const v3, 0x3f0ccccd    # 0.55f

    mul-float/2addr v3, v1

    const/high16 v7, 0x42ac0000    # 86.0f

    invoke-static {v7, v3}, Ljava/lang/Math;->min(FF)F

    move-result v3

    add-float v23, v12, v3

    const v3, 0x3e9eb852    # 0.31f

    mul-float/2addr v1, v3

    const/high16 v3, 0x42400000    # 48.0f

    invoke-static {v3, v1}, Ljava/lang/Math;->min(FF)F

    move-result v24

    if-eqz v4, :cond_26a

    const/16 v1, -0x2f8b

    goto :goto_26d

    :cond_26a
    const v1, -0x5b4732

    :goto_26d
    move/from16 v25, v1

    const/16 v27, 0x0

    const/high16 v22, 0x41b00000    # 22.0f

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 20
    if-eqz v2, :cond_283

    const-string v1, "road_name"

    invoke-virtual {v6, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    :goto_280
    move-object/from16 v21, v1

    goto :goto_2cc

    :cond_283
    iget v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-ne v1, v5, :cond_2b3

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v3, "\u5340\u9593\u5747\u901f "

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v3, v0, Lcom/navipilot/obf/WideCameraFace$Model;->average:D

    invoke-static {v3, v4}, Ljava/lang/Math;->round(D)J

    move-result-wide v3

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " \u00b7 \u5c1a\u9700 "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-wide v3, v0, Lcom/navipilot/obf/WideCameraFace$Model;->seconds:D

    invoke-static {v3, v4}, Ljava/lang/Math;->round(D)J

    move-result-wide v3

    invoke-virtual {v1, v3, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " \u79d2\uff08\u4f30\u7b97\uff09"

    :goto_2aa
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_280

    :cond_2b3
    if-eqz v4, :cond_2c9

    iget v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    if-lez v1, :cond_2c9

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v3, "\u6e2c\u901f\u9650\u901f "

    invoke-direct {v1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v3, v0, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, " km/h"

    goto :goto_2aa

    :cond_2c9
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    goto :goto_280

    :goto_2cc
    const/high16 v1, 0x42440000    # 49.0f

    sub-float v23, p2, v1

    const v25, -0x5b4732

    const/16 v27, 0x0

    const/high16 v22, 0x41b00000    # 22.0f

    const/high16 v24, 0x41300000    # 11.0f

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 21
    if-eqz v2, :cond_2e5

    const-string v0, "Google SDK \u5c0e\u822a\u8cc7\u6599"

    :goto_2e2
    move-object/from16 v21, v0

    goto :goto_30c

    :cond_2e5
    iget-boolean v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    if-eqz v1, :cond_2ec

    const-string v0, "GPS \u5099\u63f4 \u00b7 \u9053\u8def\u672a\u78ba\u8a8d"

    goto :goto_2e2

    :cond_2ec
    iget-boolean v1, v0, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    if-eqz v1, :cond_309

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6cbf\u9053\u8def\u8ddd\u96e2 \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, v0, Lcom/navipilot/obf/WideCameraFace$Model;->road:Ljava/lang/String;

    if-nez v2, :cond_2fe

    const-string v0, ""

    goto :goto_300

    :cond_2fe
    iget-object v0, v0, Lcom/navipilot/obf/WideCameraFace$Model;->road:Ljava/lang/String;

    :goto_300
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_2e2

    :cond_309
    const-string v0, "\u672a\u5c0e\u822a\u4e5f\u6301\u7e8c\u641c\u5c0b"

    goto :goto_2e2

    :goto_30c
    const/high16 v0, 0x41e00000    # 28.0f

    sub-float v23, p2, v0

    const v25, -0x812901

    const/16 v27, 0x0

    const/high16 v22, 0x41b00000    # 22.0f

    const/high16 v24, 0x41200000    # 10.0f

    move-object/from16 v20, p0

    invoke-interface/range {v20 .. v27}, Lcom/navipilot/obf/WideCameraFace$Painter;->text(Ljava/lang/String;FFFIFZ)V

    .line 22
    return-void

    .line 8
    :cond_31f
    :goto_31f
    invoke-static/range {p0 .. p7}, Lcom/navipilot/obf/WideLiveCameraFace;->render(Lcom/navipilot/obf/WideCameraFace$Painter;FFLcom/navipilot/obf/WideCameraFace$Model;JZI)V

    return-void
.end method
