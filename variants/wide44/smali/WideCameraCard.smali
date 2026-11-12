.class final Lcom/navipilot/obf/WideCameraCard;
.super Landroid/view/View;
.source "WideCameraCard.java"

# interfaces
.implements Lcom/navipilot/obf/WideCameraFace$Painter;


# instance fields
.field private final demoMode:I

.field private final demoStart:J

.field private drawing:Landroid/graphics/Canvas;

.field private flashPhase:D

.field private lastFlashAt:J

.field private final paint:Landroid/graphics/Paint;

.field private final textPaint:Landroid/text/TextPaint;


# direct methods
.method constructor <init>(Landroid/content/Context;I)V
    .locals 3

    .line 25
    invoke-direct {p0, p1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 16
    new-instance p1, Landroid/graphics/Paint;

    const/4 v0, 0x1

    invoke-direct {p1, v0}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    .line 17
    new-instance p1, Landroid/text/TextPaint;

    invoke-direct {p1, v0}, Landroid/text/TextPaint;-><init>(I)V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    .line 26
    iput p2, p0, Lcom/navipilot/obf/WideCameraCard;->demoMode:I

    .line 27
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    iput-wide v1, p0, Lcom/navipilot/obf/WideCameraCard;->demoStart:J

    .line 28
    iget-object p1, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    const-string v1, "sans-serif-black"

    invoke-static {v1, v0}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/text/TextPaint;->setTypeface(Landroid/graphics/Typeface;)Landroid/graphics/Typeface;

    .line 29
    if-nez p2, :cond_0

    const-string p1, "\u53f0\u7063\u6e2c\u901f\u5373\u6642\u5100\u8868"

    invoke-virtual {p0, p1}, Lcom/navipilot/obf/WideCameraCard;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 30
    :cond_0
    return-void
.end method

.method private drawGlow(FFF)V
    .locals 20

    .line 61
    move-object/from16 v0, p0

    invoke-static/range {p1 .. p2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const/high16 v2, 0x40800000    # 4.0f

    div-float/2addr v1, v2

    const/high16 v2, 0x41f00000    # 30.0f

    invoke-static {v2, v1}, Ljava/lang/Math;->min(FF)F

    move-result v6

    .line 62
    const/4 v1, 0x0

    cmpg-float v2, p3, v1

    if-lez v2, :cond_1

    cmpg-float v1, v6, v1

    if-gtz v1, :cond_0

    goto/16 :goto_0

    .line 63
    :cond_0
    const/high16 v1, 0x43160000    # 150.0f

    mul-float v1, v1, p3

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    shl-int/lit8 v1, v1, 0x18

    const v2, 0xff2438

    or-int v12, v1, v2

    .line 64
    nop

    .line 65
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    sget-object v2, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 66
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    const/4 v2, -0x1

    invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setColor(I)V

    .line 67
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    new-instance v3, Landroid/graphics/LinearGradient;

    move v7, v6

    const/4 v6, 0x0

    sget-object v10, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const/4 v4, 0x0

    const/4 v5, 0x0

    const v13, 0xff2438

    move v8, v12

    move v9, v13

    invoke-direct/range {v3 .. v10}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 68
    iget-object v3, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    iget-object v8, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move/from16 v6, p1

    invoke-virtual/range {v3 .. v8}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 69
    move v6, v7

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    new-instance v7, Landroid/graphics/LinearGradient;

    sub-float v16, p2, v6

    sget-object v14, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const/4 v8, 0x0

    const/4 v10, 0x0

    move/from16 v9, p2

    move/from16 v11, v16

    invoke-direct/range {v7 .. v14}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    invoke-virtual {v1, v7}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 70
    iget-object v14, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    const/4 v15, 0x0

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move/from16 v17, p1

    move/from16 v18, p2

    move-object/from16 v19, v1

    invoke-virtual/range {v14 .. v19}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 71
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    new-instance v3, Landroid/graphics/LinearGradient;

    const/4 v7, 0x0

    sget-object v10, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    move v8, v12

    move v9, v13

    invoke-direct/range {v3 .. v10}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    move v7, v6

    invoke-virtual {v1, v3}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 72
    iget-object v3, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    iget-object v8, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move/from16 v7, p2

    invoke-virtual/range {v3 .. v8}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 73
    move v7, v6

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    new-instance v7, Landroid/graphics/LinearGradient;

    sub-float v15, p1, v6

    const/4 v11, 0x0

    sget-object v14, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const/4 v9, 0x0

    move/from16 v8, p1

    move v10, v15

    invoke-direct/range {v7 .. v14}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    invoke-virtual {v1, v7}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 74
    iget-object v14, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    const/16 v16, 0x0

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move-object/from16 v19, v1

    invoke-virtual/range {v14 .. v19}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 75
    iget-object v0, v0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 76
    return-void

    .line 62
    :cond_1
    :goto_0
    return-void
.end method


# virtual methods
.method public circle(FFFFI)V
    .locals 1

    .line 85
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {v0, p5}, Landroid/graphics/Paint;->setColor(I)V

    .line 86
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    const/4 v0, 0x0

    cmpl-float v0, p4, v0

    if-lez v0, :cond_0

    sget-object v0, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    goto :goto_0

    :cond_0
    sget-object v0, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    :goto_0
    invoke-virtual {p5, v0}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 87
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {p5, p4}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 88
    iget-object p4, p0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {p4, p1, p2, p3, p5}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 89
    return-void
.end method

.method public line(FFFFFI)V
    .locals 2

    .line 92
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 93
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {v0, p6}, Landroid/graphics/Paint;->setColor(I)V

    .line 94
    iget-object p6, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {p6, p5}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 95
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    iget-object p6, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move-object p0, p5

    move-object p5, p6

    invoke-virtual/range {p0 .. p5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 96
    return-void
.end method

.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 18

    .line 33
    move-object/from16 v0, p0

    invoke-super/range {p0 .. p1}, Landroid/view/View;->onDraw(Landroid/graphics/Canvas;)V

    .line 34
    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraCard;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    .line 35
    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraCard;->getWidth()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v2, v1

    .line 36
    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraCard;->getHeight()I

    move-result v3

    int-to-float v3, v3

    div-float/2addr v3, v1

    .line 37
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v4

    .line 38
    iget v6, v0, Lcom/navipilot/obf/WideCameraCard;->demoMode:I

    if-eqz v6, :cond_0

    const/4 v6, 0x1

    goto :goto_0

    :cond_0
    const/4 v6, 0x0

    .line 39
    :goto_0
    if-eqz v6, :cond_1

    iget v9, v0, Lcom/navipilot/obf/WideCameraCard;->demoMode:I

    iget-wide v10, v0, Lcom/navipilot/obf/WideCameraCard;->demoStart:J

    sub-long v10, v4, v10

    invoke-static {v9, v10, v11}, Lcom/navipilot/obf/WideCameraFace;->demo(IJ)Lcom/navipilot/obf/WideCameraFace$Model;

    move-result-object v9

    goto :goto_1

    .line 40
    :cond_1
    invoke-static {v4, v5}, Lcom/navipilot/obf/WideCameraDisplay;->model(J)Lcom/navipilot/obf/WideCameraFace$Model;

    move-result-object v9

    .line 39
    :goto_1
    nop

    .line 41
    const/4 v10, 0x0

    if-eqz v6, :cond_2

    invoke-static {v9}, Lcom/navipilot/obf/WideCameraFace;->warningStrength(Lcom/navipilot/obf/WideCameraFace$Model;)F

    move-result v11

    goto :goto_2

    :cond_2
    move v11, v10

    .line 42
    :goto_2
    cmpl-float v12, v11, v10

    if-lez v12, :cond_4

    const-wide/16 v15, 0x0

    iget-wide v13, v0, Lcom/navipilot/obf/WideCameraCard;->lastFlashAt:J

    cmp-long v13, v13, v15

    if-lez v13, :cond_3

    .line 43
    iget-wide v13, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    move/from16 v17, v11

    iget-wide v10, v0, Lcom/navipilot/obf/WideCameraCard;->lastFlashAt:J

    sub-long v10, v4, v10

    const-wide/16 v7, 0xfa

    invoke-static {v7, v8, v10, v11}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    long-to-double v7, v7

    invoke-static {v9}, Lcom/navipilot/obf/WideCameraFace;->flashPeriodMs(Lcom/navipilot/obf/WideCameraFace$Model;)D

    move-result-wide v10

    div-double/2addr v7, v10

    add-double/2addr v13, v7

    iput-wide v13, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    .line 44
    iget-wide v7, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    const-wide/high16 v10, 0x3ff0000000000000L    # 1.0

    rem-double/2addr v7, v10

    iput-wide v7, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    .line 45
    goto :goto_4

    .line 42
    :cond_3
    move/from16 v17, v11

    goto :goto_3

    :cond_4
    move/from16 v17, v11

    const-wide/16 v15, 0x0

    .line 45
    :goto_3
    const-wide/16 v7, 0x0

    iput-wide v7, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    .line 46
    :goto_4
    if-lez v12, :cond_5

    move-wide v13, v4

    goto :goto_5

    :cond_5
    move-wide v13, v15

    :goto_5
    iput-wide v13, v0, Lcom/navipilot/obf/WideCameraCard;->lastFlashAt:J

    .line 47
    invoke-virtual/range {p1 .. p1}, Landroid/graphics/Canvas;->save()I

    .line 48
    move-object/from16 v8, p1

    invoke-virtual {v8, v1, v1}, Landroid/graphics/Canvas;->scale(FF)V

    .line 49
    const/4 v1, 0x0

    invoke-virtual {v8, v1, v1, v2, v3}, Landroid/graphics/Canvas;->clipRect(FFFF)Z

    .line 50
    iput-object v8, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    .line 51
    if-eqz v6, :cond_6

    const/4 v7, 0x0

    goto :goto_6

    :cond_6
    invoke-static {v4, v5}, Lcom/navipilot/obf/WideCameraDisplay;->retainedLimit(J)I

    move-result v7

    .line 52
    :goto_6
    move v1, v2

    move v2, v3

    move-object v3, v9

    invoke-static/range {v0 .. v7}, Lcom/navipilot/obf/WideDashboardFace;->render(Lcom/navipilot/obf/WideCameraFace$Painter;FFLcom/navipilot/obf/WideCameraFace$Model;JZI)V

    .line 53
    const-wide v3, 0x401921fb54442d18L    # 6.283185307179586

    iget-wide v9, v0, Lcom/navipilot/obf/WideCameraCard;->flashPhase:D

    mul-double/2addr v9, v3

    invoke-static {v9, v10}, Ljava/lang/Math;->sin(D)D

    move-result-wide v3

    const-wide/high16 v9, 0x3fe0000000000000L    # 0.5

    mul-double/2addr v3, v9

    add-double/2addr v3, v9

    const-wide v9, 0x3fe199999999999aL    # 0.55

    mul-double/2addr v3, v9

    const-wide v9, 0x3fdccccccccccccdL    # 0.45

    add-double/2addr v3, v9

    double-to-float v3, v3

    .line 54
    mul-float v11, v17, v3

    invoke-direct {v0, v1, v2, v11}, Lcom/navipilot/obf/WideCameraCard;->drawGlow(FFF)V

    .line 55
    const/4 v1, 0x0

    iput-object v1, v0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    .line 56
    invoke-virtual {v8}, Landroid/graphics/Canvas;->restore()V

    .line 57
    if-eqz v6, :cond_7

    const-wide/16 v1, 0x28

    invoke-virtual {v0, v1, v2}, Lcom/navipilot/obf/WideCameraCard;->postInvalidateDelayed(J)V

    .line 58
    :cond_7
    return-void
.end method

.method public rect(FFFFFI)V
    .locals 9

    .line 79
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 80
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    invoke-virtual {v0, p6}, Landroid/graphics/Paint;->setColor(I)V

    .line 81
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    add-float v4, p1, p3

    add-float v5, p2, p4

    iget-object v8, p0, Lcom/navipilot/obf/WideCameraCard;->paint:Landroid/graphics/Paint;

    move v7, p5

    move v2, p1

    move v3, p2

    move v6, p5

    invoke-virtual/range {v1 .. v8}, Landroid/graphics/Canvas;->drawRoundRect(FFFFFFLandroid/graphics/Paint;)V

    .line 82
    return-void
.end method

.method public text(Ljava/lang/String;FFFIFZ)V
    .locals 1

    .line 100
    const/4 v0, 0x0

    cmpg-float v0, p6, v0

    if-gtz v0, :cond_0

    return-void

    .line 101
    :cond_0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    invoke-virtual {v0, p5}, Landroid/text/TextPaint;->setColor(I)V

    .line 102
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    invoke-virtual {p5, p4}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 103
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    if-eqz p7, :cond_1

    sget-object p7, Landroid/graphics/Paint$Align;->CENTER:Landroid/graphics/Paint$Align;

    goto :goto_0

    :cond_1
    sget-object p7, Landroid/graphics/Paint$Align;->LEFT:Landroid/graphics/Paint$Align;

    :goto_0
    invoke-virtual {p5, p7}, Landroid/text/TextPaint;->setTextAlign(Landroid/graphics/Paint$Align;)V

    .line 104
    const-string p5, "[0-9 .\u2014]+(?:m|\u79d2)?"

    invoke-virtual {p1, p5}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result p5

    if-eqz p5, :cond_2

    .line 105
    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    invoke-virtual {p5, p1}, Landroid/text/TextPaint;->measureText(Ljava/lang/String;)F

    move-result p5

    .line 106
    cmpl-float p7, p5, p6

    if-lez p7, :cond_2

    iget-object p7, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    mul-float/2addr p4, p6

    div-float/2addr p4, p5

    const/high16 p5, 0x41200000    # 10.0f

    invoke-static {p5, p4}, Ljava/lang/Math;->max(FF)F

    move-result p4

    invoke-virtual {p7, p4}, Landroid/text/TextPaint;->setTextSize(F)V

    .line 108
    :cond_2
    iget-object p4, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    sget-object p5, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-static {p1, p4, p6, p5}, Landroid/text/TextUtils;->ellipsize(Ljava/lang/CharSequence;Landroid/text/TextPaint;FLandroid/text/TextUtils$TruncateAt;)Ljava/lang/CharSequence;

    move-result-object p1

    invoke-interface {p1}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object p1

    .line 109
    iget-object p4, p0, Lcom/navipilot/obf/WideCameraCard;->drawing:Landroid/graphics/Canvas;

    iget-object p5, p0, Lcom/navipilot/obf/WideCameraCard;->textPaint:Landroid/text/TextPaint;

    invoke-virtual {p4, p1, p2, p3, p5}, Landroid/graphics/Canvas;->drawText(Ljava/lang/String;FFLandroid/graphics/Paint;)V

    .line 110
    return-void
.end method
