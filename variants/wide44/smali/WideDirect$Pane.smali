.class final Lcom/navipilot/obf/WideDirect$Pane;
.super Landroid/widget/LinearLayout;
.source "WideDirect.java"

# interfaces
.implements Landroid/view/TextureView$SurfaceTextureListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideDirect;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Pane"
.end annotation


# instance fields
.field attached:Z

.field final body:Landroid/widget/FrameLayout;

.field controlsButton:Landroid/widget/Button;

.field disposed:Z

.field generation:I

.field final handle:Lcom/navipilot/obf/WideDivider;

.field lastMove:J

.field private final resize:Ljava/lang/Runnable;

.field session:Lcom/navipilot/obf/WideDirect$Session;

.field final shield:Z

.field source:Landroid/graphics/SurfaceTexture;

.field start:Lcom/navipilot/obf/tr;

.field starting:Z

.field final state:Landroid/widget/LinearLayout;

.field final stateAction:Landroid/widget/Button;

.field final stateDetail:Landroid/widget/TextView;

.field final stateTitle:Landroid/widget/TextView;

.field teslaSuppressed:Z

.field final texture:Landroid/view/TextureView;

.field final title:Landroid/widget/TextView;

.field workerSession:Lcom/navipilot/obf/WideDirect$Session;


# direct methods
.method public static synthetic $r8$lambda$6PELx0xQdSoXbgZA5ss_KWjZB10(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 1

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->resizeDisplay()V

    return-void
.end method

.method constructor <init>(Landroid/content/Context;ZLcom/navipilot/obf/tr;)V
    .registers 12

    .line 115
    invoke-direct {p0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 112
    new-instance v0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda17;

    invoke-direct {v0, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda17;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    .line 116
    iput-boolean p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    .line 117
    iput-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->start:Lcom/navipilot/obf/tr;

    .line 118
    const/4 p2, 0x1

    invoke-virtual {p0, p2}, Lcom/navipilot/obf/WideDirect$Pane;->setOrientation(I)V

    .line 119
    sget p3, Lcom/navipilot/obf/WideUi;->BG:I

    invoke-virtual {p0, p3}, Lcom/navipilot/obf/WideDirect$Pane;->setBackgroundColor(I)V

    .line 120
    iget-boolean p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz p3, :cond_1e

    sget p3, Lcom/navipilot/obf/WideUi;->AMBER:I

    goto :goto_20

    :cond_1e
    sget p3, Lcom/navipilot/obf/WideUi;->BLUE:I

    .line 121
    :goto_20
    invoke-static {p1}, Lcom/navipilot/obf/WideUi;->toolbar(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v0

    .line 122
    iget-boolean v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v1, :cond_2b

    const-string v1, "\u6e2c\u901f\u63d0\u9192"

    goto :goto_2d

    :cond_2b
    const-string v1, "\u8def\u7dda\u5c0e\u822a"

    :goto_2d
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->appName()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v1, v2, p3}, Lcom/navipilot/obf/WideUi;->identity(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v1

    iput-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->title:Landroid/widget/TextView;

    .line 123
    sget v1, Lcom/navipilot/obf/WideUi;->INK:I

    new-instance v2, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda18;

    invoke-direct {v2, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda18;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    const-string v3, "\u8fd4\u56de"

    invoke-static {v0, v3, v1, v2}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    .line 129
    iget-boolean v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v1, :cond_56

    sget v1, Lcom/navipilot/obf/WideUi;->INK:I

    new-instance v2, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda19;

    invoke-direct {v2, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda19;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    const-string v3, "\u5feb\u6377"

    invoke-static {v0, v3, v1, v2}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v1

    iput-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    .line 133
    :cond_56
    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda20;

    invoke-direct {v1, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda20;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    const-string v2, "\u66f4\u591a"

    invoke-static {v0, v2, p3, v1}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v1

    .line 134
    iget-boolean v2, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v2, :cond_68

    const-string v2, "\u795e\u76fe\u9078\u9805"

    goto :goto_6a

    :cond_68
    const-string v2, "\u5c0e\u822a\u9078\u9805\u8207\u6295\u5c4f\u8a2d\u5b9a"

    :goto_6a
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setContentDescription(Ljava/lang/CharSequence;)V

    .line 135
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v2, 0x42400000    # 48.0f

    invoke-direct {p0, v2}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v2

    const/4 v3, -0x1

    invoke-direct {v1, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 137
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;

    .line 138
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v2, 0x3f800000    # 1.0f

    const/4 v4, 0x0

    invoke-direct {v1, v3, v4, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p0, v0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 139
    new-instance v0, Landroid/view/TextureView;

    invoke-direct {v0, p1}, Landroid/view/TextureView;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    .line 140
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0, p0}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V

    .line 141
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v2, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 143
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    .line 144
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    invoke-virtual {v0, p2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 145
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    const/16 v1, 0x10

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 146
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    const/high16 v1, 0x41400000    # 12.0f

    invoke-direct {p0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v2

    const/high16 v5, 0x40a00000    # 5.0f

    invoke-direct {p0, v5}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v6

    invoke-direct {p0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v1

    invoke-direct {p0, v5}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v7

    invoke-virtual {v0, v2, v6, v1, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 147
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    sget v1, Lcom/navipilot/obf/WideUi;->BG:I

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 148
    const/16 v0, 0x11

    const-string v1, ""

    invoke-static {p1, v1, v0, p3, p2}, Lcom/navipilot/obf/WideUi;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object p3

    iput-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateTitle:Landroid/widget/TextView;

    .line 149
    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateTitle:Landroid/widget/TextView;

    invoke-virtual {p3, p2}, Landroid/widget/TextView;->setMaxLines(I)V

    .line 150
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateTitle:Landroid/widget/TextView;

    sget-object p3, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 151
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateTitle:Landroid/widget/TextView;

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x2

    invoke-direct {v0, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, p3, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 152
    const/16 p2, 0xc

    sget p3, Lcom/navipilot/obf/WideUi;->MUTED:I

    invoke-static {p1, v1, p2, p3, v4}, Lcom/navipilot/obf/WideUi;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object p2

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    .line 153
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    const/4 p3, 0x2

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setMaxLines(I)V

    .line 154
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    sget-object p3, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {p2, p3}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 155
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v3, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, p3, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 156
    sget p2, Lcom/navipilot/obf/WideUi;->INK:I

    new-instance p3, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda21;

    invoke-direct {p3, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda21;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    invoke-static {p1, v1, p2, p3}, Lcom/navipilot/obf/WideUi;->button(Landroid/content/Context;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object p2

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateAction:Landroid/widget/Button;

    .line 160
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 p3, 0x42200000    # 40.0f

    invoke-direct {p0, p3}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result p3

    invoke-direct {p2, v2, p3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 161
    invoke-direct {p0, v5}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result p3

    iput p3, p2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 162
    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateAction:Landroid/widget/Button;

    invoke-virtual {p3, v0, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 163
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;

    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v3, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p2, p3, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 164
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->waiting()V

    .line 165
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    new-instance p3, Lcom/navipilot/obf/WideDirect$Pane$1;

    invoke-direct {p3, p0}, Lcom/navipilot/obf/WideDirect$Pane$1;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    invoke-virtual {p2, p3}, Landroid/view/TextureView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 181
    new-instance p2, Lcom/navipilot/obf/WideDivider;

    iget-boolean p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    invoke-direct {p2, p1, p3}, Lcom/navipilot/obf/WideDivider;-><init>(Landroid/content/Context;Z)V

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    .line 182
    iget-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    const/high16 p2, 0x41d00000    # 26.0f

    if-eqz p1, :cond_17a

    .line 183
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, p2}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result p2

    const/16 p3, 0x50

    invoke-direct {p1, v3, p2, p3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    goto :goto_184

    .line 184
    :cond_17a
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, p2}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result p2

    const/4 p3, 0x5

    invoke-direct {p1, p2, v3, p3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 182
    :goto_184
    nop

    .line 185
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;

    iget-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {p2, p3, p1}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 186
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {p1}, Lcom/navipilot/obf/WideDivider;->bringToFront()V

    .line 187
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result p1

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result p2

    invoke-virtual {p0, p1, p2}, Lcom/navipilot/obf/WideDirect$Pane;->adapt(ZZ)V

    .line 188
    # getter for: Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$3()Ljava/util/ArrayList;

    move-result-object p1

    new-instance p2, Ljava/lang/ref/WeakReference;

    invoke-direct {p2, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    invoke-virtual {p1, p2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 189
    return-void
.end method

.method static synthetic access$0(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 1

    .line 260
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->updateHeader()V

    return-void
.end method

.method private appName()Ljava/lang/String;
    .registers 2

    .line 191
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_7

    const-string v0, "\u795e\u76fe\u6e2c\u901f"

    goto :goto_b

    :cond_7
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->mapName()Ljava/lang/String;

    move-result-object v0

    :goto_b
    return-object v0
.end method

.method private dp(F)I
    .registers 3

    .line 190
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideUi;->dp(Landroid/content/Context;F)I

    move-result p1

    return p1
.end method

.method static synthetic lambda$2(Lcom/navipilot/obf/WideDirect$Session;)V
    .registers 3

    .line 126
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Session;->closed:Z

    if-nez v0, :cond_e

    :try_start_4
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;

    iget p0, p0, Lcom/navipilot/obf/WideDirect$Session;->id:I

    const/4 v1, 0x4

    invoke-interface {v0, p0, v1}, Lcom/navipilot/obf/Mt;->b(II)Z
    :try_end_c
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_c} :catch_d

    goto :goto_e

    :catch_d
    move-exception p0

    .line 127
    :cond_e
    :goto_e
    return-void
.end method

.method static synthetic lambda$7(Landroid/app/Activity;)V
    .registers 1

    .line 297
    # invokes: Lcom/navipilot/obf/WideDirect;->refreshWindow(Landroid/app/Activity;)V
    invoke-static {p0}, Lcom/navipilot/obf/WideDirect;->access$6(Landroid/app/Activity;)V

    return-void
.end method

.method private layoutStamp()Lcom/navipilot/obf/WideDirect$LayoutStamp;
    .registers 6

    .line 333
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Landroid/view/WindowManager;

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    .line 334
    invoke-interface {v0}, Landroid/view/WindowManager;->getCurrentWindowMetrics()Landroid/view/WindowMetrics;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/WindowMetrics;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    .line 335
    new-instance v1, Lcom/navipilot/obf/WideDirect$LayoutStamp;

    invoke-virtual {v0}, Landroid/graphics/Rect;->width()I

    move-result v2

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v0

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v3, v3, Landroid/util/DisplayMetrics;->densityDpi:I

    .line 336
    invoke-static {}, Lcom/navipilot/obf/WideSettings;->layoutPreferences()I

    move-result v4

    .line 335
    invoke-direct {v1, v2, v0, v3, v4}, Lcom/navipilot/obf/WideDirect$LayoutStamp;-><init>(IIII)V

    return-object v1
.end method

.method private localKeyboard()Z
    .registers 4

    .line 193
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "copilot_tw_projection"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 194
    const-string v1, "phone_keyboard_in_pane"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 193
    return v0
.end method

.method private renderSize()Lcom/navipilot/obf/WideDirect$RenderSize;
    .registers 6

    .line 326
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getWidth()I

    move-result v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v1}, Landroid/view/TextureView;->getHeight()I

    move-result v1

    .line 327
    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v2

    int-to-float v2, v2

    const/high16 v3, 0x44a00000    # 1280.0f

    div-float/2addr v3, v2

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-static {v2, v3}, Ljava/lang/Math;->min(FF)F

    move-result v2

    .line 328
    new-instance v3, Lcom/navipilot/obf/WideDirect$RenderSize;

    int-to-float v0, v0

    mul-float/2addr v0, v2

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    const/4 v4, 0x2

    invoke-static {v4, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    int-to-float v1, v1

    mul-float/2addr v1, v2

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    invoke-static {v4, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 329
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    iget v4, v4, Landroid/util/DisplayMetrics;->densityDpi:I

    int-to-float v4, v4

    mul-float/2addr v4, v2

    invoke-static {v4}, Ljava/lang/Math;->round(F)I

    move-result v2

    const/16 v4, 0x78

    invoke-static {v4, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 328
    invoke-direct {v3, v0, v1, v2}, Lcom/navipilot/obf/WideDirect$RenderSize;-><init>(III)V

    return-object v3
.end method

.method private resizeDisplay()V
    .registers 6

    .line 410
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->surfaceReady()Z

    move-result v0

    if-nez v0, :cond_7

    return-void

    .line 411
    :cond_7
    invoke-static {}, Lcom/navipilot/obf/WideDivider;->isDragging()Z

    move-result v0

    if-eqz v0, :cond_19

    .line 412
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    const-wide/16 v2, 0xc8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 413
    return-void

    .line 415
    :cond_19
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getRootWindowInsets()Landroid/view/WindowInsets;

    move-result-object v0

    .line 416
    if-eqz v0, :cond_2a

    invoke-static {}, Landroid/view/WindowInsets$Type;->ime()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/WindowInsets;->isVisible(I)Z

    move-result v0

    if-eqz v0, :cond_2a

    return-void

    .line 418
    :cond_2a
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    .line 419
    if-nez v0, :cond_32

    .line 420
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V

    .line 421
    return-void

    .line 423
    :cond_32
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->layoutStamp()Lcom/navipilot/obf/WideDirect$LayoutStamp;

    move-result-object v1

    .line 425
    iget-object v2, v0, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

    invoke-virtual {v1, v2}, Lcom/navipilot/obf/WideDirect$LayoutStamp;->same(Lcom/navipilot/obf/WideDirect$LayoutStamp;)Z

    move-result v2

    if-eqz v2, :cond_3f

    return-void

    .line 426
    :cond_3f
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->renderSize()Lcom/navipilot/obf/WideDirect$RenderSize;

    move-result-object v2

    .line 427
    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v3

    new-instance v4, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda24;

    invoke-direct {v4, p0, v0, v1, v2}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda24;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$LayoutStamp;Lcom/navipilot/obf/WideDirect$RenderSize;)V

    invoke-interface {v3, v4}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 445
    return-void
.end method

.method private showConnected(Lcom/navipilot/obf/WideDirect$RenderSize;)V
    .registers 4

    .line 406
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6295\u5c4f\u4e2d \u00b7 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v1, p1, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " \u00d7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget p1, p1, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, ""

    invoke-direct {p0, p1, v0, v0}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 407
    return-void
.end method

.method private startIfNeeded()V
    .registers 14

    .line 344
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->surfaceReady()Z

    move-result v0

    if-eqz v0, :cond_d6

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->starting:Z

    if-nez v0, :cond_d6

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    if-eqz v0, :cond_10

    goto/16 :goto_d6

    .line 345
    :cond_10
    # getter for: Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$2()Lcom/navipilot/obf/Mt;

    move-result-object v0

    if-nez v0, :cond_1a

    .line 346
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->waiting()V

    .line 347
    return-void

    .line 349
    :cond_1a
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_28

    invoke-static {}, Lcom/navipilot/obf/WideTeslaProjection;->isActive()Z

    move-result v0

    if-eqz v0, :cond_28

    move v0, v1

    goto :goto_29

    :cond_28
    move v0, v2

    :goto_29
    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->teslaSuppressed:Z

    .line 350
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->teslaSuppressed:Z

    const-string v3, ""

    if-eqz v0, :cond_39

    .line 351
    const-string v0, "Tesla \u6295\u5c4f\u4e2d"

    const-string v1, "\u795e\u76fe\u76ee\u524d\u986f\u793a\u65bc Tesla \u700f\u89bd\u5668"

    invoke-direct {p0, v0, v1, v3}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 352
    return-void

    .line 354
    :cond_39
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_40

    const-string v0, "tw.com.ainvest.outpack"

    goto :goto_44

    :cond_40
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->packageName()Ljava/lang/String;

    move-result-object v0

    :goto_44
    move-object v10, v0

    .line 355
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_4d

    const-string v0, "WideShield"

    move-object v7, v0

    goto :goto_61

    :cond_4d
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->isPhone()Z

    move-result v0

    if-eqz v0, :cond_5c

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->localKeyboard()Z

    move-result v0

    if-nez v0, :cond_5c

    .line 356
    sget-object v0, Lcom/navipilot/obf/WideAmapIme;->PHONE_HOST_IME:Ljava/lang/String;

    goto :goto_60

    :cond_5c
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->displayName()Ljava/lang/String;

    move-result-object v0

    :goto_60
    move-object v7, v0

    .line 355
    :goto_61
    nop

    .line 357
    :try_start_62
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v0

    invoke-virtual {v0, v10, v2}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    :try_end_6d
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_62 .. :try_end_6d} :catch_b9

    .line 363
    # getter for: Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$2()Lcom/navipilot/obf/Mt;

    move-result-object v6

    .line 364
    iget v12, p0, Lcom/navipilot/obf/WideDirect$Pane;->generation:I

    .line 365
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->renderSize()Lcom/navipilot/obf/WideDirect$RenderSize;

    move-result-object v8

    .line 366
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->layoutStamp()Lcom/navipilot/obf/WideDirect$LayoutStamp;

    move-result-object v11

    .line 367
    iput-boolean v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->starting:Z

    .line 368
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    iget v1, v8, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget v2, v8, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    invoke-virtual {v0, v1, v2}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V

    .line 369
    new-instance v9, Landroid/view/Surface;

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    invoke-direct {v9, v0}, Landroid/view/Surface;-><init>(Landroid/graphics/SurfaceTexture;)V

    .line 370
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6b63\u5728\u958b\u555f"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->appName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\u756b\u9762"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\u6b63\u5728\u9023\u7dda"

    invoke-direct {p0, v1, v0, v3}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 371
    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    new-instance v4, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda15;

    move-object v5, p0

    invoke-direct/range {v4 .. v12}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda15;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/Mt;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$RenderSize;Landroid/view/Surface;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$LayoutStamp;I)V

    invoke-interface {v0, v4}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 403
    return-void

    .line 358
    :catch_b9
    move-exception v0

    move-object v5, p0

    .line 359
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u5c1a\u672a\u5b89\u88dd"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->appName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "\u8acb\u5148\u5b89\u88dd\uff0c\u518d\u56de\u5230\u6b64\u8655\u9023\u7dda"

    const-string v2, "\u91cd\u65b0\u6aa2\u67e5"

    invoke-direct {p0, v0, v1, v2}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 360
    return-void

    .line 344
    :cond_d6
    :goto_d6
    return-void
.end method

.method private status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 7

    .line 268
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_8

    invoke-static {p1}, Lcom/navipilot/obf/WideDirect;->access$4(Ljava/lang/String;)V

    goto :goto_b

    .line 269
    :cond_8
    invoke-static {p1}, Lcom/navipilot/obf/WideDirect;->access$5(Ljava/lang/String;)V

    .line 270
    :goto_b
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateTitle:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 271
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 272
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateDetail:Landroid/widget/TextView;

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const/16 v1, 0x8

    const/4 v2, 0x0

    if-eqz v0, :cond_22

    move v0, v1

    goto :goto_23

    :cond_22
    move v0, v2

    :goto_23
    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setVisibility(I)V

    .line 273
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateAction:Landroid/widget/Button;

    invoke-virtual {p1, p3}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 274
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->stateAction:Landroid/widget/Button;

    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_35

    move v0, v1

    goto :goto_36

    :cond_35
    move v0, v2

    :goto_36
    invoke-virtual {p1, v0}, Landroid/widget/Button;->setVisibility(I)V

    .line 275
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->state:Landroid/widget/LinearLayout;

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_48

    invoke-virtual {p3}, Ljava/lang/String;->isEmpty()Z

    move-result p2

    if-eqz p2, :cond_48

    goto :goto_49

    :cond_48
    move v1, v2

    :goto_49
    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 276
    return-void
.end method

.method private stop()V
    .registers 3

    .line 308
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 309
    iget v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->generation:I

    add-int/lit8 v0, v0, 0x1

    iput v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->generation:I

    .line 310
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->starting:Z

    .line 311
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    .line 312
    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda16;

    invoke-direct {v1, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda16;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 318
    return-void
.end method

.method private surfaceReady()Z
    .registers 3

    .line 340
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z

    if-nez v0, :cond_1f

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    if-eqz v0, :cond_1f

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    if-eqz v0, :cond_1f

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getWidth()I

    move-result v0

    const/4 v1, 0x2

    if-lt v0, v1, :cond_1f

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getHeight()I

    move-result v0

    if-lt v0, v1, :cond_1f

    const/4 v0, 0x1

    return v0

    :cond_1f
    const/4 v0, 0x0

    return v0
.end method

.method private toggleKeyboard(Landroid/app/Activity;)V
    .registers 7

    .line 198
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->localKeyboard()Z

    move-result v0

    .line 199
    xor-int/lit8 v1, v0, 0x1

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v2

    const-string v3, "copilot_tw_projection"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 200
    const-string v3, "phone_keyboard_in_pane"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 201
    if-nez v0, :cond_23

    const-string v0, "\u9375\u76e4\u5c07\u5728\u5c0e\u822a\u5340\u986f\u793a"

    goto :goto_25

    :cond_23
    const-string v0, "\u9375\u76e4\u5c07\u5728\u8eca\u6a5f\u4e3b\u756b\u9762\u986f\u793a"

    :goto_25
    invoke-static {p1, v0, v4}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 202
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V

    .line 203
    return-void
.end method

.method private updateHeader()V
    .registers 5

    .line 261
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->title:Landroid/widget/TextView;

    if-nez v0, :cond_5

    return-void

    .line 262
    :cond_5
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getWidth()I

    move-result v0

    const/high16 v1, 0x435e0000    # 222.0f

    invoke-direct {p0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v1

    const/4 v2, 0x0

    if-ge v0, v1, :cond_14

    const/4 v0, 0x1

    goto :goto_15

    :cond_14
    move v0, v2

    .line 263
    :goto_15
    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->title:Landroid/widget/TextView;

    if-eqz v0, :cond_27

    iget-boolean v3, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v3, :cond_20

    const-string v3, "\u795e\u76fe"

    goto :goto_2b

    :cond_20
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->navigation()Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object v3

    iget-object v3, v3, Lcom/navipilot/obf/WideVariant$Navigation;->compactLabel:Ljava/lang/String;

    goto :goto_2b

    :cond_27
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->appName()Ljava/lang/String;

    move-result-object v3

    :goto_2b
    invoke-virtual {v1, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 264
    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    if-eqz v1, :cond_3b

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    if-eqz v0, :cond_38

    const/16 v2, 0x8

    :cond_38
    invoke-virtual {v1, v2}, Landroid/widget/Button;->setVisibility(I)V

    .line 265
    :cond_3b
    return-void
.end method

.method private waiting()V
    .registers 4

    .line 279
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_7

    const-string v0, ""

    goto :goto_9

    :cond_7
    const-string v0, "\u555f\u52d5\u6295\u5c4f"

    :goto_9
    const-string v1, "\u6e96\u5099\u6295\u5c4f"

    const-string v2, "\u555f\u52d5 Shizuku \u6216 Stellar \u5f8c\u6388\u6b0a Copilot tw"

    invoke-direct {p0, v1, v2, v0}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 280
    return-void
.end method


# virtual methods
.method adapt(ZZ)V
    .registers 7

    .line 248
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    if-eqz v0, :cond_10

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    if-eqz p2, :cond_b

    const-string v1, "\u6536\u5408"

    goto :goto_d

    :cond_b
    const-string v1, "\u5feb\u6377"

    :goto_d
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 249
    :cond_10
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    const/4 v1, 0x0

    if-nez v0, :cond_19

    if-nez p1, :cond_19

    move p1, v1

    goto :goto_1a

    :cond_19
    const/4 p1, 0x1

    .line 250
    :goto_1a
    const/4 v0, -0x1

    const/high16 v2, 0x41d00000    # 26.0f

    if-eqz p1, :cond_2b

    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v2}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v2

    const/16 v3, 0x50

    invoke-direct {p1, v0, v2, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    goto :goto_35

    :cond_2b
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v2}, Lcom/navipilot/obf/WideDirect$Pane;->dp(F)I

    move-result v2

    const/4 v3, 0x5

    invoke-direct {p1, v2, v0, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 251
    :goto_35
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideDivider;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    .line 252
    iget v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    iget v3, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v2, v3, :cond_4f

    iget v2, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    iget v3, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v2, v3, :cond_4f

    iget v0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    iget v2, p1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    if-eq v0, v2, :cond_54

    :cond_4f
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideDivider;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 253
    :cond_54
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_5e

    if-nez p2, :cond_5e

    const/16 v1, 0x8

    :cond_5e
    invoke-virtual {p1, v1}, Lcom/navipilot/obf/WideDivider;->setVisibility(I)V

    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->handle:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {p1}, Lcom/navipilot/obf/WideDivider;->updateAxis()V

    .line 254
    return-void
.end method

.method dispose()V
    .registers 2

    .line 303
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z

    .line 304
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->stop()V

    .line 305
    return-void
.end method

.method synthetic lambda$1$com-navipilot-obf-WideDirect$Pane(Landroid/view/View;)V
    .registers 4

    .line 124
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    .line 125
    if-eqz p1, :cond_10

    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda27;

    invoke-direct {v1, p1}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda27;-><init>(Lcom/navipilot/obf/WideDirect$Session;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 128
    :cond_10
    return-void
.end method

.method synthetic lambda$10$com-navipilot-obf-WideDirect$Pane(ILcom/navipilot/obf/WideDirect$Session;Ljava/lang/String;)V
    .registers 6

    .line 390
    iget v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->generation:I

    if-ne p1, v0, :cond_31

    iget-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z

    if-nez p1, :cond_31

    iget-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    if-nez p1, :cond_d

    goto :goto_31

    .line 394
    :cond_d
    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->starting:Z

    .line 395
    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    .line 396
    if-nez p2, :cond_20

    if-nez p3, :cond_18

    const-string p3, "\u8acb\u78ba\u8a8d\u6295\u5c4f\u670d\u52d9\u5df2\u555f\u52d5"

    :cond_18
    const-string p1, "\u91cd\u8a66"

    const-string p2, "\u6295\u5c4f\u66ab\u6642\u7121\u6cd5\u9023\u7dda"

    invoke-direct {p0, p2, p3, p1}, Lcom/navipilot/obf/WideDirect$Pane;->status(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_30

    .line 398
    :cond_20
    iget-object p1, p2, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    invoke-direct {p0, p1}, Lcom/navipilot/obf/WideDirect$Pane;->showConnected(Lcom/navipilot/obf/WideDirect$RenderSize;)V

    .line 399
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object p1

    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    const-wide/16 v0, 0x15e

    invoke-virtual {p1, p2, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 401
    :goto_30
    return-void

    .line 391
    :cond_31
    :goto_31
    if-eqz p2, :cond_42

    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object p1

    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    new-instance p3, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda28;

    invoke-direct {p3, p2}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda28;-><init>(Lcom/navipilot/obf/WideDirect$Session;)V

    invoke-interface {p1, p3}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 392
    :cond_42
    return-void
.end method

.method synthetic lambda$12$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$LayoutStamp;Lcom/navipilot/obf/WideDirect$RenderSize;)V
    .registers 9

    .line 428
    iget-boolean v0, p1, Lcom/navipilot/obf/WideDirect$Session;->closed:Z

    if-nez v0, :cond_41

    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

    invoke-virtual {p2, v0}, Lcom/navipilot/obf/WideDirect$LayoutStamp;->same(Lcom/navipilot/obf/WideDirect$LayoutStamp;)Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_41

    .line 429
    :cond_d
    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    invoke-virtual {p3, v0}, Lcom/navipilot/obf/WideDirect$RenderSize;->same(Lcom/navipilot/obf/WideDirect$RenderSize;)Z

    move-result v0

    if-nez v0, :cond_32

    .line 431
    :try_start_15
    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;

    iget v1, p1, Lcom/navipilot/obf/WideDirect$Session;->id:I

    iget v2, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget v3, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    iget v4, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I

    invoke-static {v0, v1, v2, v3, v4}, Lcom/navipilot/obf/WideDisplayResize;->send(Lcom/navipilot/obf/Mt;IIII)Z

    move-result v0

    if-nez v0, :cond_26

    return-void

    .line 432
    :cond_26
    iput-object p3, p1, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;
    :try_end_28
    .catch Ljava/lang/Exception; {:try_start_15 .. :try_end_28} :catch_29

    .line 433
    goto :goto_32

    :catch_29
    move-exception p1

    .line 434
    const-string p2, "WideDirect"

    const-string p3, "Kept existing projection after resize rejection"

    invoke-static {p2, p3, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 435
    return-void

    .line 438
    :cond_32
    :goto_32
    iput-object p2, p1, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

    .line 439
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object p2

    new-instance v0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;

    invoke-direct {v0, p0, p1, p3}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;)V

    invoke-virtual {p2, v0}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 444
    return-void

    .line 428
    :cond_41
    :goto_41
    return-void
.end method

.method synthetic lambda$13$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;)V
    .registers 5

    .line 440
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    if-ne v0, p1, :cond_16

    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    if-nez p1, :cond_9

    goto :goto_16

    .line 441
    :cond_9
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    iget v0, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget v1, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    invoke-virtual {p1, v0, v1}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V

    .line 442
    invoke-direct {p0, p2}, Lcom/navipilot/obf/WideDirect$Pane;->showConnected(Lcom/navipilot/obf/WideDirect$RenderSize;)V

    .line 443
    return-void

    .line 440
    :cond_16
    :goto_16
    return-void
.end method

.method synthetic lambda$3$com-navipilot-obf-WideDirect$Pane(Landroid/view/View;)V
    .registers 2

    .line 130
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object p1

    # invokes: Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;
    invoke-static {p1}, Lcom/navipilot/obf/WideDirect;->access$1(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object p1

    .line 131
    if-eqz p1, :cond_d

    invoke-static {p1}, Lcom/navipilot/obf/WideSettings;->toggleControls(Landroid/app/Activity;)V

    .line 132
    :cond_d
    return-void
.end method

.method synthetic lambda$5$com-navipilot-obf-WideDirect$Pane(Landroid/view/View;)V
    .registers 3

    .line 157
    # getter for: Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$2()Lcom/navipilot/obf/Mt;

    move-result-object p1

    if-nez p1, :cond_14

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object p1

    # invokes: Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;
    invoke-static {p1}, Lcom/navipilot/obf/WideDirect;->access$1(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object p1

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->start:Lcom/navipilot/obf/tr;

    invoke-static {p1, v0}, Lcom/navipilot/obf/WideProjectionHelp;->start(Landroid/app/Activity;Lcom/navipilot/obf/tr;)V

    goto :goto_17

    .line 158
    :cond_14
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V

    .line 159
    :goto_17
    return-void
.end method

.method synthetic lambda$6$com-navipilot-obf-WideDirect$Pane(Landroid/view/MenuItem;)Z
    .registers 6

    .line 228
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    # invokes: Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;
    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->access$1(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v0

    .line 229
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result v1

    .line 230
    const/4 v2, 0x2

    const/4 v3, 0x1

    if-ne v1, v2, :cond_14

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V

    goto :goto_6e

    .line 231
    :cond_14
    const/4 v2, 0x3

    if-ne v1, v2, :cond_1d

    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->start:Lcom/navipilot/obf/tr;

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideProjectionHelp;->start(Landroid/app/Activity;Lcom/navipilot/obf/tr;)V

    goto :goto_6e

    .line 232
    :cond_1d
    if-eqz v0, :cond_6e

    .line 233
    invoke-interface {p1}, Landroid/view/MenuItem;->getGroupId()I

    move-result p1

    const/16 v2, 0xa

    if-ne p1, v2, :cond_33

    .line 234
    invoke-static {}, Lcom/navipilot/obf/WideVariant$Navigation;->values()[Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object p1

    add-int/lit8 v1, v1, -0x14

    aget-object p1, p1, v1

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideVariant;->select(Landroid/app/Activity;Lcom/navipilot/obf/WideVariant$Navigation;)V

    .line 235
    goto :goto_6e

    :cond_33
    if-ne v1, v3, :cond_42

    const p1, 0x1020002

    invoke-virtual {v0, p1}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup;

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideSettings;->show(Landroid/app/Activity;Landroid/view/ViewGroup;)V

    goto :goto_6e

    .line 236
    :cond_42
    const/4 p1, 0x5

    if-ne v1, p1, :cond_49

    invoke-static {v0}, Lcom/navipilot/obf/WideProjectionHelp;->show(Landroid/app/Activity;)V

    goto :goto_6e

    .line 237
    :cond_49
    const/4 p1, 0x6

    if-ne v1, p1, :cond_50

    invoke-static {v0}, Lcom/navipilot/obf/WideVariant;->togglePanel(Landroid/app/Activity;)V

    goto :goto_6e

    .line 238
    :cond_50
    const/4 p1, 0x7

    if-ne v1, p1, :cond_57

    invoke-static {v0}, Lcom/navipilot/obf/WideVariant;->toggleTeslaShield(Landroid/app/Activity;)V

    goto :goto_6e

    .line 239
    :cond_57
    const/16 p1, 0x8

    if-ne v1, p1, :cond_5f

    invoke-direct {p0, v0}, Lcom/navipilot/obf/WideDirect$Pane;->toggleKeyboard(Landroid/app/Activity;)V

    goto :goto_6e

    .line 240
    :cond_5f
    const/16 p1, 0x9

    if-ne v1, p1, :cond_67

    invoke-static {v0}, Lcom/navipilot/obf/WideSettings;->toggleControls(Landroid/app/Activity;)V

    goto :goto_6e

    .line 241
    :cond_67
    const/16 p1, 0xb

    if-ne v1, p1, :cond_6e

    invoke-static {v0}, Lcom/navipilot/obf/WideGoogleNav;->show(Landroid/app/Activity;)V

    .line 243
    :cond_6e
    :goto_6e
    return v3
.end method

.method synthetic lambda$8$com-navipilot-obf-WideDirect$Pane()V
    .registers 2

    .line 313
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->workerSession:Lcom/navipilot/obf/WideDirect$Session;

    if-eqz v0, :cond_c

    .line 314
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->workerSession:Lcom/navipilot/obf/WideDirect$Session;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideDirect$Session;->close()V

    .line 315
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->workerSession:Lcom/navipilot/obf/WideDirect$Session;

    .line 317
    :cond_c
    return-void
.end method

.method synthetic lambda$9$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/Mt;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$RenderSize;Landroid/view/Surface;Ljava/lang/String;Lcom/navipilot/obf/WideDirect$LayoutStamp;I)V
    .registers 18

    .line 372
    nop

    .line 373
    nop

    .line 374
    nop

    .line 376
    const/4 v8, -0x1

    const/4 v9, 0x0

    :try_start_5
    invoke-interface {p1}, Lcom/navipilot/obf/Mt;->asBinder()Landroid/os/IBinder;

    move-result-object v1

    invoke-interface {v1}, Landroid/os/IBinder;->isBinderAlive()Z

    move-result v1

    if-eqz v1, :cond_4e

    .line 377
    iget v3, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget v4, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    iget v5, p3, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I

    const/high16 v6, 0x41f00000    # 30.0f

    move-object v1, p1

    move-object v2, p2

    move-object v7, p4

    invoke-interface/range {v1 .. v7}, Lcom/navipilot/obf/Mt;->f(Ljava/lang/String;IIIFLandroid/view/Surface;)I

    move-result v3
    :try_end_1e
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_1e} :catch_56

    .line 378
    if-lez v3, :cond_46

    .line 379
    move-object v2, p5

    :try_start_21
    invoke-interface {p1, p5, v3}, Lcom/navipilot/obf/Mt;->e(Ljava/lang/String;I)Z

    move-result v2

    if-eqz v2, :cond_3a

    .line 380
    new-instance v1, Lcom/navipilot/obf/WideDirect$Session;

    move-object v2, p1

    move-object v5, p3

    move-object v4, p4

    move-object/from16 v6, p6

    invoke-direct/range {v1 .. v6}, Lcom/navipilot/obf/WideDirect$Session;-><init>(Lcom/navipilot/obf/Mt;ILandroid/view/Surface;Lcom/navipilot/obf/WideDirect$RenderSize;Lcom/navipilot/obf/WideDirect$LayoutStamp;)V
    :try_end_31
    .catch Ljava/lang/Exception; {:try_start_21 .. :try_end_31} :catch_42

    .line 381
    :try_start_31
    iput-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->workerSession:Lcom/navipilot/obf/WideDirect$Session;
    :try_end_33
    .catch Ljava/lang/Exception; {:try_start_31 .. :try_end_33} :catch_36

    .line 382
    const-string v0, ""

    goto :goto_67

    :catch_36
    move-exception v0

    move-object v9, v1

    move v8, v3

    goto :goto_57

    .line 379
    :cond_3a
    :try_start_3a
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "\u8eca\u6a5f\u7121\u6cd5\u958b\u555f\u6295\u5c4f App"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 382
    :catch_42
    move-exception v0

    move-object v1, v0

    move v8, v3

    goto :goto_58

    .line 378
    :cond_46
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "\u8eca\u6a5f\u7121\u6cd5\u5efa\u7acb\u6295\u5c4f\u756b\u9762"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_4e
    .catch Ljava/lang/Exception; {:try_start_3a .. :try_end_4e} :catch_42

    .line 376
    :cond_4e
    :try_start_4e
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "\u6295\u5c4f\u670d\u52d9\u5df2\u65b7\u7dda"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_56
    .catch Ljava/lang/Exception; {:try_start_4e .. :try_end_56} :catch_56

    .line 382
    :catch_56
    move-exception v0

    :goto_57
    move-object v1, v0

    .line 383
    :goto_58
    if-lez v8, :cond_5f

    :try_start_5a
    invoke-interface {p1, v8}, Lcom/navipilot/obf/Mt;->a(I)V
    :try_end_5d
    .catch Ljava/lang/Exception; {:try_start_5a .. :try_end_5d} :catch_5e

    goto :goto_5f

    :catch_5e
    move-exception v0

    .line 384
    :cond_5f
    :goto_5f
    invoke-virtual {p4}, Landroid/view/Surface;->release()V

    .line 385
    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    move-object v1, v9

    .line 387
    :goto_67
    nop

    .line 388
    nop

    .line 389
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v2

    new-instance v3, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;

    move/from16 v4, p7

    invoke-direct {v3, p0, v4, v1, v0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;-><init>(Lcom/navipilot/obf/WideDirect$Pane;ILcom/navipilot/obf/WideDirect$Session;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 402
    return-void
.end method

.method menu(Landroid/view/View;)V
    .registers 16

    .line 206
    new-instance v0, Landroid/widget/PopupMenu;

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/widget/PopupMenu;-><init>(Landroid/content/Context;Landroid/view/View;)V

    .line 209
    iget-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    const/4 v1, 0x4

    const/16 v2, 0x9

    const/4 v3, 0x5

    const/16 v4, 0xa

    const/16 v5, 0x8

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez p1, :cond_76

    .line 210
    invoke-static {}, Lcom/navipilot/obf/WideVariant$Navigation;->values()[Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object p1

    array-length v8, p1

    move v9, v7

    :goto_1d
    if-lt v9, v8, :cond_5e

    .line 213
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    invoke-interface {p1, v4, v6, v6}, Landroid/view/Menu;->setGroupCheckable(IZZ)V

    .line 214
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->navigation()Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object v8

    invoke-virtual {v8}, Lcom/navipilot/obf/WideVariant$Navigation;->ordinal()I

    move-result v8

    add-int/lit8 v8, v8, 0x14

    invoke-interface {p1, v8}, Landroid/view/Menu;->findItem(I)Landroid/view/MenuItem;

    move-result-object p1

    invoke-interface {p1, v6}, Landroid/view/MenuItem;->setChecked(Z)Landroid/view/MenuItem;

    .line 215
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const/4 v8, 0x3

    const-string v9, "\u555f\u52d5\u6295\u5c4f\uff0f\u6388\u6b0a"

    invoke-interface {p1, v7, v8, v1, v9}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 216
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->isPhone()Z

    move-result p1

    if-eqz p1, :cond_96

    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    .line 217
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->localKeyboard()Z

    move-result v1

    if-eqz v1, :cond_58

    const-string v1, "\u5c07\u9375\u76e4\u79fb\u81f3\u8eca\u6a5f\u4e3b\u756b\u9762"

    goto :goto_5a

    :cond_58
    const-string v1, "\u5c07\u9375\u76e4\u79fb\u81f3\u5c0e\u822a\u5340"

    .line 216
    :goto_5a
    invoke-interface {p1, v7, v5, v3, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    goto :goto_95

    .line 210
    :cond_5e
    aget-object v10, p1, v9

    .line 211
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object v11

    invoke-virtual {v10}, Lcom/navipilot/obf/WideVariant$Navigation;->ordinal()I

    move-result v12

    add-int/lit8 v12, v12, 0x14

    invoke-virtual {v10}, Lcom/navipilot/obf/WideVariant$Navigation;->ordinal()I

    move-result v13

    iget-object v10, v10, Lcom/navipilot/obf/WideVariant$Navigation;->label:Ljava/lang/String;

    invoke-interface {v11, v4, v12, v13, v10}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 210
    add-int/lit8 v9, v9, 0x1

    goto :goto_1d

    .line 218
    :cond_76
    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    if-eqz p1, :cond_95

    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->controlsButton:Landroid/widget/Button;

    invoke-virtual {p1}, Landroid/widget/Button;->getVisibility()I

    move-result p1

    if-ne p1, v5, :cond_95

    .line 219
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v8

    if-eqz v8, :cond_8f

    const-string v8, "\u6536\u5408\u5feb\u6377\u9375"

    goto :goto_91

    :cond_8f
    const-string v8, "\u986f\u793a\u5feb\u6377\u9375"

    :goto_91
    invoke-interface {p1, v7, v2, v1, v8}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    goto :goto_96

    .line 218
    :cond_95
    :goto_95
    nop

    .line 221
    :cond_96
    :goto_96
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "Google \u5c0e\u822a\u4e32\u63a5\u8207\u91d1\u9470"

    const/16 v8, 0xb

    invoke-interface {p1, v7, v8, v8, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 222
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u7248\u9762\u8207\u6bd4\u4f8b\u8a2d\u5b9a"

    const/4 v8, 0x6

    invoke-interface {p1, v7, v6, v8, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 223
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v6, "\u91cd\u65b0\u958b\u555f"

    invoke-direct {v1, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->appName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v6, 0x2

    const/4 v9, 0x7

    invoke-interface {p1, v7, v6, v9, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 224
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u6295\u5c4f\u5b89\u88dd\u8207\u6388\u6b0a"

    invoke-interface {p1, v7, v3, v5, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 225
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->shieldPanel()Z

    move-result v1

    if-eqz v1, :cond_dd

    const-string v1, "\u6539\u7528\u53f0\u7063\u6e2c\u901f\u9762\u677f"

    goto :goto_df

    :cond_dd
    const-string v1, "\u6539\u7528\u795e\u76fe\u9762\u677f"

    :goto_df
    invoke-interface {p1, v7, v8, v2, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 226
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Amap2Tesla \u50c5\u6295\u795e\u76fe \u00b7 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->teslaShield()Z

    move-result v2

    if-eqz v2, :cond_f6

    const-string v2, "\u958b"

    goto :goto_f8

    :cond_f6
    const-string v2, "\u95dc"

    :goto_f8
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {p1, v7, v9, v4, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 227
    new-instance p1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda25;

    invoke-direct {p1, p0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda25;-><init>(Lcom/navipilot/obf/WideDirect$Pane;)V

    invoke-virtual {v0, p1}, Landroid/widget/PopupMenu;->setOnMenuItemClickListener(Landroid/widget/PopupMenu$OnMenuItemClickListener;)V

    .line 245
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->show()V

    .line 246
    return-void
.end method

.method protected onAttachedToWindow()V
    .registers 2

    .line 283
    invoke-super {p0}, Landroid/widget/LinearLayout;->onAttachedToWindow()V

    .line 284
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    .line 285
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-nez v0, :cond_15

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    # invokes: Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;
    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->access$1(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v0

    # invokes: Lcom/navipilot/obf/WideDirect;->refreshWindow(Landroid/app/Activity;)V
    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->access$6(Landroid/app/Activity;)V

    .line 286
    :cond_15
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->isAvailable()Z

    move-result v0

    if-eqz v0, :cond_28

    .line 287
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getSurfaceTexture()Landroid/graphics/SurfaceTexture;

    move-result-object v0

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    .line 288
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V

    .line 290
    :cond_28
    return-void
.end method

.method protected onDetachedFromWindow()V
    .registers 4

    .line 293
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    .line 294
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->stop()V

    .line 295
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-nez v0, :cond_1e

    .line 296
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v0

    # invokes: Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;
    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->access$1(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v0

    .line 297
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v1

    new-instance v2, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda23;

    invoke-direct {v2, v0}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda23;-><init>(Landroid/app/Activity;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 299
    :cond_1e
    invoke-super {p0}, Landroid/widget/LinearLayout;->onDetachedFromWindow()V

    .line 300
    return-void
.end method

.method protected onSizeChanged(IIII)V
    .registers 5

    .line 256
    invoke-super {p0, p1, p2, p3, p4}, Landroid/widget/LinearLayout;->onSizeChanged(IIII)V

    .line 257
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->updateHeader()V

    .line 258
    return-void
.end method

.method public onSurfaceTextureAvailable(Landroid/graphics/SurfaceTexture;II)V
    .registers 4

    .line 448
    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    .line 449
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V

    .line 450
    return-void
.end method

.method public onSurfaceTextureDestroyed(Landroid/graphics/SurfaceTexture;)Z
    .registers 4

    .line 462
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;

    .line 463
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->stop()V

    .line 464
    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda29;

    invoke-direct {v1, p1}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda29;-><init>(Landroid/graphics/SurfaceTexture;)V

    invoke-interface {v0, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 465
    const/4 p1, 0x0

    return p1
.end method

.method public onSurfaceTextureSizeChanged(Landroid/graphics/SurfaceTexture;II)V
    .registers 6

    .line 453
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    if-eqz p2, :cond_f

    .line 454
    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    iget-object p2, p2, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    .line 455
    iget p3, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget p2, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    invoke-virtual {p1, p3, p2}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V

    .line 457
    :cond_f
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object p1

    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    invoke-virtual {p1, p2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 458
    # getter for: Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object p1

    iget-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    const-wide/16 v0, 0x15e

    invoke-virtual {p1, p2, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 459
    return-void
.end method

.method public onSurfaceTextureUpdated(Landroid/graphics/SurfaceTexture;)V
    .registers 2

    .line 468
    return-void
.end method

.method restart()V
    .registers 1

    .line 321
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->stop()V

    .line 322
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V

    .line 323
    return-void
.end method
