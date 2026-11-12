.class public final Lcom/navipilot/obf/WideCameraPanel;
.super Landroid/widget/LinearLayout;
.source "WideCameraPanel.java"


# instance fields
.field private autoCollapsed:Z

.field private compact:Z

.field private final controls:Landroid/widget/Button;

.field private final dashboard:Lcom/navipilot/obf/WideCameraCard;

.field private disposed:Z

.field private final divider:Lcom/navipilot/obf/WideDivider;

.field private dividerFits:Z

.field private final gps:Landroid/widget/Button;

.field private final main:Landroid/os/Handler;

.field private quickControls:Z

.field private final tick:Ljava/lang/Runnable;

.field private final toolbar:Landroid/widget/LinearLayout;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 8

    .line 36
    invoke-direct {p0, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 18
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;

    .line 24
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/navipilot/obf/WideCameraPanel;->dividerFits:Z

    .line 26
    new-instance v1, Lcom/navipilot/obf/WideCameraPanel$1;

    invoke-direct {v1, p0}, Lcom/navipilot/obf/WideCameraPanel$1;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->tick:Ljava/lang/Runnable;

    .line 37
    invoke-virtual {p0, v0}, Lcom/navipilot/obf/WideCameraPanel;->setOrientation(I)V

    .line 38
    sget v1, Lcom/navipilot/obf/WideUi;->BG:I

    invoke-virtual {p0, v1}, Lcom/navipilot/obf/WideCameraPanel;->setBackgroundColor(I)V

    .line 39
    invoke-static {p1}, Lcom/navipilot/obf/WideCamera;->init(Landroid/content/Context;)V

    .line 41
    invoke-static {p1}, Lcom/navipilot/obf/WideUi;->toolbar(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v1

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    .line 42
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    const-string v2, "\u53f0\u7063\u6e2c\u901f"

    sget v3, Lcom/navipilot/obf/WideUi;->TEAL:I

    const-string v4, "\u5373\u6642\u9053\u8def\u8cc7\u8a0a"

    invoke-static {v1, v4, v2, v3}, Lcom/navipilot/obf/WideUi;->identity(Landroid/widget/LinearLayout;Ljava/lang/String;Ljava/lang/String;I)Landroid/widget/TextView;

    .line 43
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    sget v2, Lcom/navipilot/obf/WideUi;->TEAL:I

    new-instance v3, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda5;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda5;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    const-string v4, "\u5b9a\u4f4d"

    invoke-static {v1, v4, v2, v3}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v1

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->gps:Landroid/widget/Button;

    .line 44
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    sget v2, Lcom/navipilot/obf/WideUi;->INK:I

    new-instance v3, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda6;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda6;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    const-string v4, "\u5feb\u6377"

    invoke-static {v1, v4, v2, v3}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v1

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->controls:Landroid/widget/Button;

    .line 45
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    sget v2, Lcom/navipilot/obf/WideUi;->INK:I

    new-instance v3, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda7;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda7;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    const-string v4, "\u66f4\u591a"

    invoke-static {v1, v4, v2, v3}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    .line 46
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v3, 0x42400000    # 48.0f

    invoke-direct {p0, v3}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v3

    const/4 v4, -0x1

    invoke-direct {v2, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1, v2}, Lcom/navipilot/obf/WideCameraPanel;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 48
    new-instance v1, Lcom/navipilot/obf/WideCameraCard;

    const/4 v2, 0x0

    invoke-direct {v1, p1, v2}, Lcom/navipilot/obf/WideCameraCard;-><init>(Landroid/content/Context;I)V

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->dashboard:Lcom/navipilot/obf/WideCameraCard;

    .line 49
    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->dashboard:Lcom/navipilot/obf/WideCameraCard;

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v5, 0x3f800000    # 1.0f

    invoke-direct {v3, v4, v2, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {p0, v1, v3}, Lcom/navipilot/obf/WideCameraPanel;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 50
    new-instance v1, Lcom/navipilot/obf/WideDivider;

    invoke-direct {v1, p1, v0}, Lcom/navipilot/obf/WideDivider;-><init>(Landroid/content/Context;Z)V

    iput-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    .line 51
    iget-object p1, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    sget v0, Lcom/navipilot/obf/WideUi;->SURFACE:I

    invoke-virtual {p1, v0}, Lcom/navipilot/obf/WideDivider;->setBackgroundColor(I)V

    .line 52
    iget-object p1, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    const/16 v0, 0x8

    invoke-virtual {p1, v0}, Lcom/navipilot/obf/WideDivider;->setVisibility(I)V

    .line 53
    iget-object p1, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v1, 0x41c00000    # 24.0f

    invoke-direct {p0, v1}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v1

    invoke-direct {v0, v4, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, p1, v0}, Lcom/navipilot/obf/WideCameraPanel;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 54
    return-void
.end method

.method static synthetic access$0(Lcom/navipilot/obf/WideCameraPanel;)Z
    .registers 1

    .line 24
    iget-boolean p0, p0, Lcom/navipilot/obf/WideCameraPanel;->disposed:Z

    return p0
.end method

.method static synthetic access$1(Lcom/navipilot/obf/WideCameraPanel;)V
    .registers 1

    .line 59
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->updateButtons()V

    return-void
.end method

.method static synthetic access$2(Lcom/navipilot/obf/WideCameraPanel;)Lcom/navipilot/obf/WideCameraCard;
    .registers 1

    .line 20
    iget-object p0, p0, Lcom/navipilot/obf/WideCameraPanel;->dashboard:Lcom/navipilot/obf/WideCameraCard;

    return-object p0
.end method

.method static synthetic access$3(Lcom/navipilot/obf/WideCameraPanel;)Landroid/os/Handler;
    .registers 1

    .line 18
    iget-object p0, p0, Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;

    return-object p0
.end method

.method private activity()Landroid/app/Activity;
    .registers 2

    .line 57
    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraPanel;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/navipilot/obf/WideVariant;->activity(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v0

    return-object v0
.end method

.method private dp(F)I
    .registers 3

    .line 56
    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraPanel;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideUi;->dp(Landroid/content/Context;F)I

    move-result p1

    return p1
.end method

.method private showDemo(Landroid/app/Activity;I)V
    .registers 9

    .line 143
    invoke-virtual {p1}, Landroid/app/Activity;->isFinishing()Z

    move-result v0

    if-nez v0, :cond_70

    invoke-virtual {p1}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_d

    goto :goto_70

    .line 144
    :cond_d
    new-instance v0, Lcom/navipilot/obf/WideCameraCard;

    invoke-direct {v0, p1, p2}, Lcom/navipilot/obf/WideCameraCard;-><init>(Landroid/content/Context;I)V

    .line 145
    new-instance v1, Landroid/widget/FrameLayout;

    invoke-direct {v1, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 146
    invoke-virtual {p1}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/View;->getHeight()I

    move-result v2

    .line 147
    if-lez v2, :cond_41

    const/high16 v3, 0x438c0000    # 280.0f

    invoke-direct {p0, v3}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v3

    const/high16 v4, 0x42c00000    # 96.0f

    invoke-direct {p0, v4}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v4

    const/high16 v5, 0x43040000    # 132.0f

    invoke-direct {p0, v5}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v5

    sub-int/2addr v2, v5

    invoke-static {v4, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    invoke-static {v3, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    goto :goto_47

    :cond_41
    const/high16 v2, 0x43700000    # 240.0f

    invoke-direct {p0, v2}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result v2

    .line 148
    :goto_47
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v3, v4, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v0, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 149
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p1}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    .line 150
    const/4 p1, 0x1

    if-ne p2, p1, :cond_5b

    const-string p1, "\u56fa\u5b9a\u6e2c\u901f\u793a\u7bc4"

    goto :goto_5d

    :cond_5b
    const-string p1, "\u5340\u9593\u6e2c\u901f\u793a\u7bc4"

    :goto_5d
    invoke-virtual {v0, p1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 151
    invoke-virtual {p1, v1}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 152
    const-string p2, "\u95dc\u9589"

    const/4 v0, 0x0

    invoke-virtual {p1, p2, v0}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p1

    .line 153
    invoke-virtual {p1}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    .line 154
    return-void

    .line 143
    :cond_70
    :goto_70
    return-void
.end method

.method private toggleGps()V
    .registers 3

    .line 67
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 68
    if-nez v0, :cond_7

    return-void

    .line 69
    :cond_7
    sget-boolean v1, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v1, :cond_f

    invoke-static {v0}, Lcom/navipilot/obf/WideCamera;->stop(Landroid/content/Context;)V

    goto :goto_12

    .line 70
    :cond_f
    invoke-static {v0}, Lcom/navipilot/obf/WideCamera;->start(Landroid/app/Activity;)Z

    .line 71
    :goto_12
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->updateButtons()V

    .line 72
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->dashboard:Lcom/navipilot/obf/WideCameraCard;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraCard;->invalidate()V

    .line 73
    return-void
.end method

.method private toggleQuickControls()V
    .registers 2

    .line 76
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 77
    if-eqz v0, :cond_9

    invoke-static {v0}, Lcom/navipilot/obf/WideSettings;->toggleControls(Landroid/app/Activity;)V

    .line 78
    :cond_9
    return-void
.end method

.method private updateButtons()V
    .registers 4

    .line 60
    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v0, :cond_7

    const-string v0, "\u505c\u6b62"

    goto :goto_9

    :cond_7
    const-string v0, "\u5b9a\u4f4d"

    .line 61
    :goto_9
    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v1

    if-eqz v1, :cond_12

    const-string v1, "\u6536\u5408"

    goto :goto_14

    :cond_12
    const-string v1, "\u5feb\u6377"

    .line 62
    :goto_14
    iget-object v2, p0, Lcom/navipilot/obf/WideCameraPanel;->gps:Landroid/widget/Button;

    invoke-virtual {v2}, Landroid/widget/Button;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    invoke-static {v2, v0}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v2

    if-nez v2, :cond_25

    iget-object v2, p0, Lcom/navipilot/obf/WideCameraPanel;->gps:Landroid/widget/Button;

    invoke-virtual {v2, v0}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 63
    :cond_25
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->controls:Landroid/widget/Button;

    invoke-virtual {v0}, Landroid/widget/Button;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-static {v0, v1}, Landroid/text/TextUtils;->equals(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Z

    move-result v0

    if-nez v0, :cond_36

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->controls:Landroid/widget/Button;

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 64
    :cond_36
    return-void
.end method

.method private updateDivider()V
    .registers 3

    .line 97
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    iget-boolean v1, p0, Lcom/navipilot/obf/WideCameraPanel;->quickControls:Z

    if-eqz v1, :cond_c

    iget-boolean v1, p0, Lcom/navipilot/obf/WideCameraPanel;->dividerFits:Z

    if-eqz v1, :cond_c

    const/4 v1, 0x0

    goto :goto_e

    :cond_c
    const/16 v1, 0x8

    :goto_e
    invoke-virtual {v0, v1}, Lcom/navipilot/obf/WideDivider;->setVisibility(I)V

    .line 98
    return-void
.end method


# virtual methods
.method public adapt(ZZ)V
    .registers 3

    .line 81
    iput-boolean p2, p0, Lcom/navipilot/obf/WideCameraPanel;->quickControls:Z

    .line 82
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->updateButtons()V

    .line 83
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->updateDivider()V

    .line 84
    iget-object p1, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {p1}, Lcom/navipilot/obf/WideDivider;->updateAxis()V

    .line 85
    return-void
.end method

.method public dispose()V
    .registers 3

    .line 168
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/navipilot/obf/WideCameraPanel;->disposed:Z

    .line 169
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->tick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 170
    return-void
.end method

.method fitLayout(ZZ)V
    .registers 4

    .line 88
    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraPanel;->compact:Z

    if-ne v0, p1, :cond_9

    iget-boolean v0, p0, Lcom/navipilot/obf/WideCameraPanel;->dividerFits:Z

    if-ne v0, p2, :cond_9

    return-void

    .line 89
    :cond_9
    iput-boolean p1, p0, Lcom/navipilot/obf/WideCameraPanel;->compact:Z

    .line 90
    iput-boolean p2, p0, Lcom/navipilot/obf/WideCameraPanel;->dividerFits:Z

    .line 91
    iget-object p2, p0, Lcom/navipilot/obf/WideCameraPanel;->toolbar:Landroid/widget/LinearLayout;

    if-eqz p1, :cond_14

    const/16 v0, 0x8

    goto :goto_15

    :cond_14
    const/4 v0, 0x0

    :goto_15
    invoke-virtual {p2, v0}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 92
    iget-object p2, p0, Lcom/navipilot/obf/WideCameraPanel;->divider:Lcom/navipilot/obf/WideDivider;

    invoke-virtual {p2}, Lcom/navipilot/obf/WideDivider;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p2

    if-eqz p1, :cond_23

    const/16 p1, 0xc

    goto :goto_25

    :cond_23
    const/16 p1, 0x18

    :goto_25
    int-to-float p1, p1

    invoke-direct {p0, p1}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result p1

    iput p1, p2, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 93
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->updateDivider()V

    .line 94
    return-void
.end method

.method synthetic lambda$0$com-navipilot-obf-WideCameraPanel(Landroid/view/View;)V
    .registers 2

    .line 43
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->toggleGps()V

    return-void
.end method

.method synthetic lambda$1$com-navipilot-obf-WideCameraPanel(Landroid/view/View;)V
    .registers 2

    .line 44
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->toggleQuickControls()V

    return-void
.end method

.method synthetic lambda$3$com-navipilot-obf-WideCameraPanel()V
    .registers 2

    .line 105
    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraPanel;->isAttachedToWindow()Z

    move-result v0

    if-eqz v0, :cond_f

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v0

    if-eqz v0, :cond_f

    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->toggleQuickControls()V

    :cond_f
    return-void
.end method

.method synthetic lambda$4$com-navipilot-obf-WideCameraPanel(Landroid/view/MenuItem;)Z
    .registers 5

    .line 122
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->activity()Landroid/app/Activity;

    move-result-object v0

    .line 123
    const/4 v1, 0x1

    if-nez v0, :cond_8

    return v1

    .line 124
    :cond_8
    invoke-interface {p1}, Landroid/view/MenuItem;->getItemId()I

    move-result p1

    const v2, 0x1020002

    packed-switch p1, :pswitch_data_3a

    .line 135
    const/4 p1, 0x0

    return p1

    .line 134
    :pswitch_14
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->toggleGps()V

    goto :goto_39

    .line 133
    :pswitch_18
    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraPanel;->toggleQuickControls()V

    goto :goto_39

    .line 132
    :pswitch_1c
    const/4 p1, 0x2

    invoke-direct {p0, v0, p1}, Lcom/navipilot/obf/WideCameraPanel;->showDemo(Landroid/app/Activity;I)V

    goto :goto_39

    .line 131
    :pswitch_21
    invoke-direct {p0, v0, v1}, Lcom/navipilot/obf/WideCameraPanel;->showDemo(Landroid/app/Activity;I)V

    goto :goto_39

    .line 129
    :pswitch_25
    invoke-virtual {v0, v2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup;

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideTaiwanSettings;->show(Landroid/app/Activity;Landroid/view/ViewGroup;)V

    .line 130
    goto :goto_39

    .line 126
    :pswitch_2f
    invoke-virtual {v0, v2}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup;

    invoke-static {v0, p1}, Lcom/navipilot/obf/WideSettings;->show(Landroid/app/Activity;Landroid/view/ViewGroup;)V

    .line 127
    nop

    .line 137
    :goto_39
    return v1

    :pswitch_data_3a
    .packed-switch 0x1
        :pswitch_2f
        :pswitch_25
        :pswitch_21
        :pswitch_1c
        :pswitch_18
        :pswitch_14
    .end packed-switch
.end method

.method protected onAttachedToWindow()V
    .registers 3

    .line 157
    invoke-super {p0}, Landroid/widget/LinearLayout;->onAttachedToWindow()V

    .line 158
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->tick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 159
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->tick:Ljava/lang/Runnable;

    invoke-interface {v0}, Ljava/lang/Runnable;->run()V

    .line 160
    return-void
.end method

.method protected onDetachedFromWindow()V
    .registers 3

    .line 163
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;

    iget-object v1, p0, Lcom/navipilot/obf/WideCameraPanel;->tick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 164
    invoke-super {p0}, Landroid/widget/LinearLayout;->onDetachedFromWindow()V

    .line 165
    return-void
.end method

.method protected onSizeChanged(IIII)V
    .registers 5

    .line 101
    invoke-super {p0, p1, p2, p3, p4}, Landroid/widget/LinearLayout;->onSizeChanged(IIII)V

    .line 102
    iget-object p3, p0, Lcom/navipilot/obf/WideCameraPanel;->controls:Landroid/widget/Button;

    const/high16 p4, 0x435e0000    # 222.0f

    invoke-direct {p0, p4}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result p4

    if-ge p1, p4, :cond_10

    const/16 p1, 0x8

    goto :goto_11

    :cond_10
    const/4 p1, 0x0

    :goto_11
    invoke-virtual {p3, p1}, Landroid/widget/Button;->setVisibility(I)V

    .line 103
    iget-boolean p1, p0, Lcom/navipilot/obf/WideCameraPanel;->autoCollapsed:Z

    if-nez p1, :cond_33

    if-lez p2, :cond_33

    const/high16 p1, 0x43960000    # 300.0f

    invoke-direct {p0, p1}, Lcom/navipilot/obf/WideCameraPanel;->dp(F)I

    move-result p1

    if-ge p2, p1, :cond_33

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result p1

    if-eqz p1, :cond_33

    .line 104
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/navipilot/obf/WideCameraPanel;->autoCollapsed:Z

    .line 105
    new-instance p1, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda8;

    invoke-direct {p1, p0}, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda8;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    invoke-virtual {p0, p1}, Lcom/navipilot/obf/WideCameraPanel;->post(Ljava/lang/Runnable;)Z

    .line 107
    :cond_33
    return-void
.end method

.method openMenu(Landroid/view/View;)V
    .registers 7

    .line 110
    new-instance v0, Landroid/widget/PopupMenu;

    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraPanel;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1, p1}, Landroid/widget/PopupMenu;-><init>(Landroid/content/Context;Landroid/view/View;)V

    .line 111
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u7248\u9762\u8207\u6bd4\u4f8b\u8a2d\u5b9a"

    const/4 v2, 0x0

    const/4 v3, 0x1

    invoke-interface {p1, v2, v3, v2, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 112
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u53f0\u7063\u6e2c\u901f\u8a2d\u5b9a\u8207\u8a3a\u65b7"

    const/4 v4, 0x2

    invoke-interface {p1, v2, v4, v3, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 113
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u793a\u7bc4\u56fa\u5b9a\u6e2c\u901f"

    const/4 v3, 0x3

    invoke-interface {p1, v2, v3, v4, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 114
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    const-string v1, "\u793a\u7bc4\u5340\u9593\u6e2c\u901f"

    const/4 v4, 0x4

    invoke-interface {p1, v2, v4, v3, v1}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 115
    iget-boolean p1, p0, Lcom/navipilot/obf/WideCameraPanel;->compact:Z

    const/4 v1, 0x5

    if-nez p1, :cond_41

    iget-object p1, p0, Lcom/navipilot/obf/WideCameraPanel;->controls:Landroid/widget/Button;

    invoke-virtual {p1}, Landroid/widget/Button;->getVisibility()I

    move-result p1

    const/16 v3, 0x8

    if-ne p1, v3, :cond_53

    .line 116
    :cond_41
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v3

    if-eqz v3, :cond_4e

    const-string v3, "\u6536\u5408\u5feb\u6377\u9375"

    goto :goto_50

    :cond_4e
    const-string v3, "\u986f\u793a\u5feb\u6377\u9375"

    :goto_50
    invoke-interface {p1, v2, v1, v4, v3}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 118
    :cond_53
    iget-boolean p1, p0, Lcom/navipilot/obf/WideCameraPanel;->compact:Z

    if-eqz p1, :cond_68

    .line 119
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;

    move-result-object p1

    sget-boolean v3, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v3, :cond_62

    const-string v3, "\u505c\u6b62 GPS \u5b9a\u4f4d"

    goto :goto_64

    :cond_62
    const-string v3, "\u555f\u52d5 GPS \u5b9a\u4f4d"

    :goto_64
    const/4 v4, 0x6

    invoke-interface {p1, v2, v4, v1, v3}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

    .line 121
    :cond_68
    new-instance p1, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda4;

    invoke-direct {p1, p0}, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda4;-><init>(Lcom/navipilot/obf/WideCameraPanel;)V

    invoke-virtual {v0, p1}, Landroid/widget/PopupMenu;->setOnMenuItemClickListener(Landroid/widget/PopupMenu$OnMenuItemClickListener;)V

    .line 139
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->show()V

    .line 140
    return-void
.end method
