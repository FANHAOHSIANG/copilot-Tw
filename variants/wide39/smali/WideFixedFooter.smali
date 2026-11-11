.class public final Lcom/navipilot/obf/WideFixedFooter;
.super Ljava/lang/Object;
.source "WideFixedFooter.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static dp(Landroid/content/Context;I)I
    .locals 0

    .line 14
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    int-to-float p1, p1

    mul-float/2addr p0, p1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0
.end method

.method public static install(Landroid/app/Dialog;Landroid/widget/ScrollView;)V
    .locals 8

    .line 16
    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/widget/ScrollView;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 17
    instance-of v2, v1, Landroid/view/ViewGroup;

    if-nez v2, :cond_0

    invoke-virtual {p0, p1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    return-void

    .line 18
    :cond_0
    check-cast v1, Landroid/view/ViewGroup;

    .line 19
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    const/4 v3, 0x1

    sub-int/2addr v2, v3

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 20
    instance-of v4, v2, Landroid/widget/Button;

    if-eqz v4, :cond_3

    check-cast v2, Landroid/widget/Button;

    invoke-virtual {v2}, Landroid/widget/Button;->getText()Ljava/lang/CharSequence;

    move-result-object v4

    const-string v5, "\u95dc\u9589"

    invoke-virtual {v5, v4}, Ljava/lang/String;->contentEquals(Ljava/lang/CharSequence;)Z

    move-result v4

    if-nez v4, :cond_1

    goto/16 :goto_1

    .line 21
    :cond_1
    invoke-virtual {p1}, Landroid/widget/ScrollView;->getContext()Landroid/content/Context;

    move-result-object v4

    .line 22
    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 23
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v4}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 24
    invoke-virtual {v1}, Landroid/view/ViewGroup;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    .line 25
    if-eqz v1, :cond_2

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v3

    if-eqz v3, :cond_2

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v1

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    goto :goto_0

    .line 26
    :cond_2
    const v1, -0xe8ddd0

    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 28
    :goto_0
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v3, 0x3f800000    # 1.0f

    const/4 v6, -0x1

    invoke-direct {v1, v6, v0, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v5, p1, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 29
    new-instance p1, Landroid/widget/FrameLayout;

    invoke-direct {p1, v4}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const/16 v0, 0xc

    invoke-static {v4, v0}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v1

    const/16 v3, 0x8

    invoke-static {v4, v3}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v7

    invoke-static {v4, v0}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v0

    invoke-static {v4, v3}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v3

    invoke-virtual {p1, v1, v7, v0, v3}, Landroid/widget/FrameLayout;->setPadding(IIII)V

    .line 30
    const/16 v0, 0xa0

    invoke-static {v4, v0}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v0

    invoke-virtual {v2, v0}, Landroid/widget/Button;->setMinWidth(I)V

    .line 31
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v1, 0x30

    invoke-static {v4, v1}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v1

    const/16 v3, 0x11

    const/4 v7, -0x2

    invoke-direct {v0, v7, v1, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-virtual {p1, v2, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 32
    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v1, 0x40

    invoke-static {v4, v1}, Lcom/navipilot/obf/WideFixedFooter;->dp(Landroid/content/Context;I)I

    move-result v1

    invoke-direct {v0, v6, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v5, p1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 33
    invoke-virtual {p0, v5}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    .line 34
    return-void

    .line 20
    :cond_3
    :goto_1
    invoke-virtual {p0, p1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    return-void
.end method
