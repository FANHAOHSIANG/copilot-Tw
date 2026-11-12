.class public final Lcom/navipilot/obf/WideStatusBorder;
.super Landroid/graphics/drawable/Drawable;
.source "WideStatusBorder.java"

# interfaces
.implements Landroid/view/View$OnAttachStateChangeListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideStatusBorder$State;
    }
.end annotation


# static fields
.field private static final CLEAR_RED:I = 0xff2438

.field static final FRAME_DP:F = 6.0f

.field private static final GLOW_DP:F = 30.0f

.field private static final GREEN:I = -0xad2a7c

.field static final INNER_RADIUS_DP:F = 12.0f

.field private static final RED:I = -0xdbc8

.field private static final SKY_BLUE:I = -0x992601

.field private static volatile state:Lcom/navipilot/obf/WideStatusBorder$State;


# instance fields
.field private flashPhase:D

.field private final frame:Landroid/graphics/Path;

.field private geometryDensity:F

.field private glowAlpha:I

.field private glowDepth:F

.field private final gradients:[Landroid/graphics/LinearGradient;

.field private final inner:Landroid/graphics/RectF;

.field private lastFlashAt:J

.field private final paint:Landroid/graphics/Paint;

.field private final redraw:Ljava/lang/Runnable;

.field private final root:Landroid/view/View;

.field private shownColor:I


# direct methods
.method private constructor <init>(Landroid/view/View;)V
    .locals 3

    .line 115
    invoke-direct {p0}, Landroid/graphics/drawable/Drawable;-><init>()V

    .line 40
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    iput-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    .line 41
    new-instance v0, Landroid/graphics/Path;

    invoke-direct {v0}, Landroid/graphics/Path;-><init>()V

    iput-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    .line 42
    new-instance v0, Landroid/graphics/RectF;

    invoke-direct {v0}, Landroid/graphics/RectF;-><init>()V

    iput-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    .line 43
    const/4 v0, 0x4

    new-array v0, v0, [Landroid/graphics/LinearGradient;

    iput-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    .line 51
    new-instance v0, Lcom/navipilot/obf/WideStatusBorder$1;

    invoke-direct {v0, p0}, Lcom/navipilot/obf/WideStatusBorder$1;-><init>(Lcom/navipilot/obf/WideStatusBorder;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->redraw:Ljava/lang/Runnable;

    .line 116
    iput-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    .line 117
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    sget-object v1, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 118
    invoke-virtual {p1}, Landroid/view/View;->getOverlay()Landroid/view/ViewOverlay;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/ViewOverlay;->add(Landroid/graphics/drawable/Drawable;)V

    .line 119
    new-instance v0, Lcom/navipilot/obf/WideStatusBorder$$ExternalSyntheticLambda0;

    invoke-direct {v0, p0}, Lcom/navipilot/obf/WideStatusBorder$$ExternalSyntheticLambda0;-><init>(Lcom/navipilot/obf/WideStatusBorder;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 121
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {p0, v2, v2, v0, v1}, Lcom/navipilot/obf/WideStatusBorder;->setBounds(IIII)V

    .line 122
    invoke-virtual {p1, p0}, Landroid/view/View;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 123
    invoke-virtual {p1}, Landroid/view/View;->isAttachedToWindow()Z

    move-result v0

    if-eqz v0, :cond_0

    invoke-virtual {p0, p1}, Lcom/navipilot/obf/WideStatusBorder;->onViewAttachedToWindow(Landroid/view/View;)V

    .line 124
    :cond_0
    return-void
.end method

.method static synthetic access$0(Lcom/navipilot/obf/WideStatusBorder;)Landroid/view/View;
    .locals 0

    .line 39
    iget-object p0, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    return-object p0
.end method

.method static synthetic access$1()I
    .locals 1

    .line 104
    invoke-static {}, Lcom/navipilot/obf/WideStatusBorder;->currentColor()I

    move-result v0

    return v0
.end method

.method static synthetic access$2(Lcom/navipilot/obf/WideStatusBorder;J)I
    .locals 0

    .line 64
    invoke-direct {p0, p1, p2}, Lcom/navipilot/obf/WideStatusBorder;->cameraGlow(J)I

    move-result p0

    return p0
.end method

.method static synthetic access$3(Lcom/navipilot/obf/WideStatusBorder;)I
    .locals 0

    .line 46
    iget p0, p0, Lcom/navipilot/obf/WideStatusBorder;->shownColor:I

    return p0
.end method

.method static synthetic access$4(Lcom/navipilot/obf/WideStatusBorder;)I
    .locals 0

    .line 47
    iget p0, p0, Lcom/navipilot/obf/WideStatusBorder;->glowAlpha:I

    return p0
.end method

.method static synthetic access$5(Lcom/navipilot/obf/WideStatusBorder;I)V
    .locals 0

    .line 46
    iput p1, p0, Lcom/navipilot/obf/WideStatusBorder;->shownColor:I

    return-void
.end method

.method static synthetic access$6(Lcom/navipilot/obf/WideStatusBorder;I)V
    .locals 0

    .line 47
    iput p1, p0, Lcom/navipilot/obf/WideStatusBorder;->glowAlpha:I

    return-void
.end method

.method static activeColor(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 1

    .line 100
    sget-object v0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {v0, p0}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_2

    instance-of p0, p1, Ljava/lang/Boolean;

    if-nez p0, :cond_0

    goto :goto_1

    .line 101
    :cond_0
    sget-object p0, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-virtual {p0, p1}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    const p0, -0xad2a7c

    goto :goto_0

    :cond_1
    const p0, -0x992601

    :goto_0
    return p0

    .line 100
    :cond_2
    :goto_1
    const/4 p0, 0x0

    return p0
.end method

.method private cameraGlow(J)I
    .locals 9

    .line 65
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getWindowVisibility()I

    move-result v0

    const/4 v1, 0x0

    const-wide/16 v2, 0x0

    if-eqz v0, :cond_0

    .line 66
    iput-wide v2, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    .line 67
    return v1

    .line 69
    :cond_0
    invoke-static {p1, p2}, Lcom/navipilot/obf/WideCameraDisplay;->model(J)Lcom/navipilot/obf/WideCameraFace$Model;

    move-result-object v0

    .line 70
    iget-object v4, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    invoke-virtual {v4}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v4

    iget-object v5, v0, Lcom/navipilot/obf/WideCameraFace$Model;->voiceCameraId:Ljava/lang/String;

    invoke-static {v4, v5, p1, p2}, Lcom/navipilot/obf/WideCameraVoice;->observe(Landroid/content/Context;Ljava/lang/String;J)V

    .line 71
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraFace;->warningStrength(Lcom/navipilot/obf/WideCameraFace$Model;)F

    move-result v4

    .line 72
    const/4 v5, 0x0

    cmpg-float v5, v4, v5

    if-gtz v5, :cond_1

    .line 73
    iput-wide v2, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    .line 74
    return v1

    .line 76
    :cond_1
    iget-wide v5, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    cmp-long v1, v5, v2

    if-nez v1, :cond_2

    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/navipilot/obf/WideStatusBorder;->flashPhase:D

    goto :goto_0

    .line 77
    :cond_2
    iget-wide v1, p0, Lcom/navipilot/obf/WideStatusBorder;->flashPhase:D

    iget-wide v5, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    sub-long v5, p1, v5

    const-wide/16 v7, 0xfa

    invoke-static {v7, v8, v5, v6}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v5

    long-to-double v5, v5

    .line 78
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraFace;->flashPeriodMs(Lcom/navipilot/obf/WideCameraFace$Model;)D

    move-result-wide v7

    div-double/2addr v5, v7

    add-double/2addr v1, v5

    const-wide/high16 v5, 0x3ff0000000000000L    # 1.0

    rem-double/2addr v1, v5

    .line 77
    iput-wide v1, p0, Lcom/navipilot/obf/WideStatusBorder;->flashPhase:D

    .line 79
    :goto_0
    iput-wide p1, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    .line 80
    const-wide p1, 0x401921fb54442d18L    # 6.283185307179586

    iget-wide v0, p0, Lcom/navipilot/obf/WideStatusBorder;->flashPhase:D

    mul-double/2addr v0, p1

    invoke-static {v0, v1}, Ljava/lang/Math;->sin(D)D

    move-result-wide p1

    const-wide/high16 v0, 0x3fe0000000000000L    # 0.5

    mul-double/2addr p1, v0

    add-double/2addr p1, v0

    const-wide v0, 0x3fe199999999999aL    # 0.55

    mul-double/2addr p1, v0

    const-wide v0, 0x3fdccccccccccccdL    # 0.45

    add-double/2addr p1, v0

    .line 81
    const/high16 v0, 0x43160000    # 150.0f

    mul-float/2addr v4, v0

    float-to-double v0, v4

    mul-double/2addr v0, p1

    invoke-static {v0, v1}, Ljava/lang/Math;->round(D)J

    move-result-wide p1

    long-to-int p1, p1

    return p1
.end method

.method public static clear()V
    .locals 1

    .line 96
    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideStatusBorder;->state:Lcom/navipilot/obf/WideStatusBorder$State;

    .line 97
    return-void
.end method

.method private static currentColor()I
    .locals 5

    .line 105
    sget-object v0, Lcom/navipilot/obf/WideStatusBorder;->state:Lcom/navipilot/obf/WideStatusBorder$State;

    .line 106
    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v1

    const-wide/32 v3, 0xf4240

    div-long/2addr v1, v3

    .line 107
    if-eqz v0, :cond_0

    iget-wide v3, v0, Lcom/navipilot/obf/WideStatusBorder$State;->expiresAt:J

    cmp-long v1, v1, v3

    if-gez v1, :cond_0

    iget v0, v0, Lcom/navipilot/obf/WideStatusBorder$State;->color:I

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method private drawGlow(Landroid/graphics/Canvas;Landroid/graphics/Rect;)V
    .locals 13

    .line 164
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    const/4 v1, -0x1

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setColor(I)V

    .line 165
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    iget v1, p0, Lcom/navipilot/obf/WideStatusBorder;->glowAlpha:I

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 166
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    iget-object v1, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 167
    iget v0, p2, Landroid/graphics/Rect;->left:I

    int-to-float v2, v0

    iget v0, p2, Landroid/graphics/Rect;->top:I

    int-to-float v3, v0

    iget v0, p2, Landroid/graphics/Rect;->right:I

    int-to-float v4, v0

    iget v0, p2, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v1, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    add-float v5, v0, v1

    iget-object v6, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    move-object v1, p1

    invoke-virtual/range {v1 .. v6}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 168
    move-object v7, v1

    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    const/4 v1, 0x1

    aget-object v0, v0, v1

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 169
    iget p1, p2, Landroid/graphics/Rect;->left:I

    int-to-float v8, p1

    iget p1, p2, Landroid/graphics/Rect;->bottom:I

    int-to-float p1, p1

    iget v0, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    sub-float v9, p1, v0

    iget p1, p2, Landroid/graphics/Rect;->right:I

    int-to-float v10, p1

    iget p1, p2, Landroid/graphics/Rect;->bottom:I

    int-to-float v11, p1

    iget-object v12, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v7 .. v12}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 170
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 171
    iget p1, p2, Landroid/graphics/Rect;->left:I

    int-to-float v8, p1

    iget p1, p2, Landroid/graphics/Rect;->top:I

    int-to-float v9, p1

    iget p1, p2, Landroid/graphics/Rect;->left:I

    int-to-float p1, p1

    iget v0, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    add-float v10, p1, v0

    iget p1, p2, Landroid/graphics/Rect;->bottom:I

    int-to-float v11, p1

    iget-object v12, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v7 .. v12}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 172
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    const/4 v1, 0x3

    aget-object v0, v0, v1

    invoke-virtual {p1, v0}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 173
    iget p1, p2, Landroid/graphics/Rect;->right:I

    int-to-float p1, p1

    iget v0, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    sub-float v8, p1, v0

    iget p1, p2, Landroid/graphics/Rect;->top:I

    int-to-float v9, p1

    iget p1, p2, Landroid/graphics/Rect;->right:I

    int-to-float v10, p1

    iget p1, p2, Landroid/graphics/Rect;->bottom:I

    int-to-float v11, p1

    iget-object v12, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    invoke-virtual/range {v7 .. v12}, Landroid/graphics/Canvas;->drawRect(FFFFLandroid/graphics/Paint;)V

    .line 174
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    const/4 p2, 0x0

    invoke-virtual {p1, p2}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 175
    return-void
.end method

.method private static gradient(FFFF)Landroid/graphics/LinearGradient;
    .locals 8

    .line 160
    new-instance v0, Landroid/graphics/LinearGradient;

    const v6, 0xff2438

    sget-object v7, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    const v5, -0xdbc8

    move v1, p0

    move v2, p1

    move v3, p2

    move v4, p3

    invoke-direct/range {v0 .. v7}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    return-object v0
.end method

.method public static install(Landroid/app/Activity;)V
    .locals 1

    .line 111
    const v0, 0x1020002

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    .line 112
    if-eqz p0, :cond_0

    new-instance v0, Lcom/navipilot/obf/WideStatusBorder;

    invoke-direct {v0, p0}, Lcom/navipilot/obf/WideStatusBorder;-><init>(Landroid/view/View;)V

    .line 113
    :cond_0
    return-void
.end method

.method private prepareGeometry(Landroid/graphics/Rect;F)V
    .locals 11

    .line 141
    iput p2, p0, Lcom/navipilot/obf/WideStatusBorder;->geometryDensity:F

    .line 142
    invoke-virtual {p1}, Landroid/graphics/Rect;->width()I

    move-result v0

    invoke-virtual {p1}, Landroid/graphics/Rect;->height()I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->min(II)I

    move-result v0

    int-to-float v0, v0

    .line 143
    const/high16 v1, 0x40c00000    # 6.0f

    mul-float/2addr v1, p2

    const/high16 v2, 0x40000000    # 2.0f

    div-float v3, v0, v2

    invoke-static {v1, v3}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 144
    iget-object v3, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    invoke-virtual {v3}, Landroid/graphics/Path;->reset()V

    .line 145
    iget-object v3, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    sget-object v4, Landroid/graphics/Path$FillType;->EVEN_ODD:Landroid/graphics/Path$FillType;

    invoke-virtual {v3, v4}, Landroid/graphics/Path;->setFillType(Landroid/graphics/Path$FillType;)V

    .line 146
    iget-object v5, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    iget v3, p1, Landroid/graphics/Rect;->left:I

    int-to-float v6, v3

    iget v3, p1, Landroid/graphics/Rect;->top:I

    int-to-float v7, v3

    iget v3, p1, Landroid/graphics/Rect;->right:I

    int-to-float v8, v3

    iget v3, p1, Landroid/graphics/Rect;->bottom:I

    int-to-float v9, v3

    sget-object v10, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual/range {v5 .. v10}, Landroid/graphics/Path;->addRect(FFFFLandroid/graphics/Path$Direction;)V

    .line 147
    iget-object v3, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    iget v4, p1, Landroid/graphics/Rect;->left:I

    int-to-float v4, v4

    add-float/2addr v4, v1

    iget v5, p1, Landroid/graphics/Rect;->top:I

    int-to-float v5, v5

    add-float/2addr v5, v1

    iget v6, p1, Landroid/graphics/Rect;->right:I

    int-to-float v6, v6

    sub-float/2addr v6, v1

    iget v7, p1, Landroid/graphics/Rect;->bottom:I

    int-to-float v7, v7

    sub-float/2addr v7, v1

    invoke-virtual {v3, v4, v5, v6, v7}, Landroid/graphics/RectF;->set(FFFF)V

    .line 148
    iget-object v1, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    invoke-virtual {v1}, Landroid/graphics/RectF;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_0

    .line 149
    const/high16 v1, 0x41400000    # 12.0f

    mul-float/2addr v1, p2

    iget-object v3, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    invoke-virtual {v3}, Landroid/graphics/RectF;->width()F

    move-result v3

    iget-object v4, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    invoke-virtual {v4}, Landroid/graphics/RectF;->height()F

    move-result v4

    invoke-static {v3, v4}, Ljava/lang/Math;->min(FF)F

    move-result v3

    div-float/2addr v3, v2

    invoke-static {v1, v3}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 150
    iget-object v2, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    iget-object v3, p0, Lcom/navipilot/obf/WideStatusBorder;->inner:Landroid/graphics/RectF;

    sget-object v4, Landroid/graphics/Path$Direction;->CW:Landroid/graphics/Path$Direction;

    invoke-virtual {v2, v3, v1, v1, v4}, Landroid/graphics/Path;->addRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Path$Direction;)V

    .line 152
    :cond_0
    const/high16 v1, 0x41f00000    # 30.0f

    mul-float/2addr p2, v1

    const/high16 v1, 0x40800000    # 4.0f

    div-float/2addr v0, v1

    invoke-static {p2, v0}, Ljava/lang/Math;->min(FF)F

    move-result p2

    iput p2, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    .line 153
    iget-object p2, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    iget v0, p1, Landroid/graphics/Rect;->top:I

    int-to-float v0, v0

    iget v1, p1, Landroid/graphics/Rect;->top:I

    int-to-float v1, v1

    iget v2, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    add-float/2addr v1, v2

    const/4 v2, 0x0

    invoke-static {v2, v0, v2, v1}, Lcom/navipilot/obf/WideStatusBorder;->gradient(FFFF)Landroid/graphics/LinearGradient;

    move-result-object v0

    const/4 v1, 0x0

    aput-object v0, p2, v1

    .line 154
    iget-object p2, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    iget v0, p1, Landroid/graphics/Rect;->bottom:I

    int-to-float v0, v0

    iget v1, p1, Landroid/graphics/Rect;->bottom:I

    int-to-float v1, v1

    iget v3, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    sub-float/2addr v1, v3

    invoke-static {v2, v0, v2, v1}, Lcom/navipilot/obf/WideStatusBorder;->gradient(FFFF)Landroid/graphics/LinearGradient;

    move-result-object v0

    const/4 v1, 0x1

    aput-object v0, p2, v1

    .line 155
    iget-object p2, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    iget v0, p1, Landroid/graphics/Rect;->left:I

    int-to-float v0, v0

    iget v1, p1, Landroid/graphics/Rect;->left:I

    int-to-float v1, v1

    iget v3, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    add-float/2addr v1, v3

    invoke-static {v0, v2, v1, v2}, Lcom/navipilot/obf/WideStatusBorder;->gradient(FFFF)Landroid/graphics/LinearGradient;

    move-result-object v0

    const/4 v1, 0x2

    aput-object v0, p2, v1

    .line 156
    iget-object p2, p0, Lcom/navipilot/obf/WideStatusBorder;->gradients:[Landroid/graphics/LinearGradient;

    iget v0, p1, Landroid/graphics/Rect;->right:I

    int-to-float v0, v0

    iget p1, p1, Landroid/graphics/Rect;->right:I

    int-to-float p1, p1

    iget v1, p0, Lcom/navipilot/obf/WideStatusBorder;->glowDepth:F

    sub-float/2addr p1, v1

    invoke-static {v0, v2, p1, v2}, Lcom/navipilot/obf/WideStatusBorder;->gradient(FFFF)Landroid/graphics/LinearGradient;

    move-result-object p1

    const/4 v0, 0x3

    aput-object p1, p2, v0

    .line 157
    return-void
.end method

.method public static update(Lcom/navipilot/obf/zg;)V
    .locals 4

    invoke-static {p0}, Lcom/navipilot/obf/WideVehiclePanel;->update(Lcom/navipilot/obf/zg;)V

    .line 85
    const/4 v0, 0x0

    if-nez p0, :cond_0

    move-object p0, v0

    goto :goto_0

    :cond_0
    const-string v1, "carControl"

    invoke-virtual {p0, v1}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object p0

    .line 86
    :goto_0
    if-eqz p0, :cond_3

    iget-object v1, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    if-eqz v1, :cond_3

    iget-object v1, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v1, v1, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    if-nez v1, :cond_1

    goto :goto_2

    .line 90
    :cond_1
    iget-object v1, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v1, v1, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    .line 91
    const-string v2, "latActive"

    invoke-interface {v1, v2}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    const-string v3, "longActive"

    invoke-interface {v1, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/navipilot/obf/WideStatusBorder;->activeColor(Ljava/lang/Object;Ljava/lang/Object;)I

    move-result v1

    .line 92
    if-nez v1, :cond_2

    goto :goto_1

    :cond_2
    new-instance v0, Lcom/navipilot/obf/WideStatusBorder$State;

    iget-wide v2, p0, Lcom/navipilot/obf/vg;->c:J

    invoke-direct {v0, v1, v2, v3}, Lcom/navipilot/obf/WideStatusBorder$State;-><init>(IJ)V

    :goto_1
    sput-object v0, Lcom/navipilot/obf/WideStatusBorder;->state:Lcom/navipilot/obf/WideStatusBorder$State;

    .line 93
    return-void

    .line 87
    :cond_3
    :goto_2
    invoke-static {}, Lcom/navipilot/obf/WideStatusBorder;->clear()V

    .line 88
    return-void
.end method


# virtual methods
.method public draw(Landroid/graphics/Canvas;)V
    .locals 4

    .line 178
    invoke-static {}, Lcom/navipilot/obf/WideStatusBorder;->currentColor()I

    move-result v0

    .line 179
    if-nez v0, :cond_0

    iget v1, p0, Lcom/navipilot/obf/WideStatusBorder;->glowAlpha:I

    if-nez v1, :cond_0

    return-void

    .line 180
    :cond_0
    invoke-virtual {p0}, Lcom/navipilot/obf/WideStatusBorder;->getBounds()Landroid/graphics/Rect;

    move-result-object v1

    .line 181
    invoke-virtual {v1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    return-void

    .line 182
    :cond_1
    iget-object v2, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    invoke-virtual {v2}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v2

    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    .line 183
    iget v3, p0, Lcom/navipilot/obf/WideStatusBorder;->geometryDensity:F

    cmpl-float v3, v3, v2

    if-eqz v3, :cond_2

    invoke-direct {p0, v1, v2}, Lcom/navipilot/obf/WideStatusBorder;->prepareGeometry(Landroid/graphics/Rect;F)V

    .line 184
    :cond_2
    iget v2, p0, Lcom/navipilot/obf/WideStatusBorder;->glowAlpha:I

    if-lez v2, :cond_3

    invoke-direct {p0, p1, v1}, Lcom/navipilot/obf/WideStatusBorder;->drawGlow(Landroid/graphics/Canvas;Landroid/graphics/Rect;)V

    .line 185
    :cond_3
    if-eqz v0, :cond_4

    .line 186
    iget-object v1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v0}, Landroid/graphics/Paint;->setColor(I)V

    .line 187
    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->frame:Landroid/graphics/Path;

    iget-object v1, p0, Lcom/navipilot/obf/WideStatusBorder;->paint:Landroid/graphics/Paint;

    invoke-virtual {p1, v0, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 189
    :cond_4
    return-void
.end method

.method public getOpacity()I
    .locals 1

    .line 193
    const/4 v0, -0x3

    return v0
.end method

.method synthetic lambda$0$com-navipilot-obf-WideStatusBorder(Landroid/view/View;IIIIIIII)V
    .locals 0

    .line 120
    sub-int/2addr p4, p2

    sub-int/2addr p5, p3

    const/4 p1, 0x0

    invoke-virtual {p0, p1, p1, p4, p5}, Lcom/navipilot/obf/WideStatusBorder;->setBounds(IIII)V

    return-void
.end method

.method protected onBoundsChange(Landroid/graphics/Rect;)V
    .locals 0

    .line 137
    const/4 p1, 0x0

    iput p1, p0, Lcom/navipilot/obf/WideStatusBorder;->geometryDensity:F

    .line 138
    return-void
.end method

.method public onViewAttachedToWindow(Landroid/view/View;)V
    .locals 1

    .line 127
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->redraw:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 128
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->redraw:Ljava/lang/Runnable;

    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    .line 129
    return-void
.end method

.method public onViewDetachedFromWindow(Landroid/view/View;)V
    .locals 2

    .line 132
    iget-object p1, p0, Lcom/navipilot/obf/WideStatusBorder;->root:Landroid/view/View;

    iget-object v0, p0, Lcom/navipilot/obf/WideStatusBorder;->redraw:Ljava/lang/Runnable;

    invoke-virtual {p1, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 133
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/navipilot/obf/WideStatusBorder;->lastFlashAt:J

    .line 134
    return-void
.end method

.method public setAlpha(I)V
    .locals 0

    .line 191
    return-void
.end method

.method public setColorFilter(Landroid/graphics/ColorFilter;)V
    .locals 0

    .line 192
    return-void
.end method
