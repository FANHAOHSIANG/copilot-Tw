.class public final Lcom/navipilot/obf/WideTaiwanSettings;
.super Ljava/lang/Object;
.source "WideTaiwanSettings.java"


# static fields
.field private static final PREF:Ljava/lang/String; = "wide_layout_preferences"

.field private static final ratios:Lcom/navipilot/obf/TF;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 25
    const/16 v0, 0x1388

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/bT;->k:Lcom/navipilot/obf/bT;

    invoke-static {v0, v1}, Lcom/navipilot/obf/GS;->f(Ljava/lang/Object;Lcom/navipilot/obf/KV;)Lcom/navipilot/obf/pK;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideTaiwanSettings;->ratios:Lcom/navipilot/obf/TF;

    .line 26
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 24
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;
    .locals 1

    .line 45
    new-instance v0, Landroid/widget/Button;

    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/high16 p0, 0x41600000    # 14.0f

    invoke-virtual {v0, p0}, Landroid/widget/Button;->setTextSize(F)V

    invoke-virtual {v0, p2}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object v0
.end method

.method private static dp(Landroid/content/Context;F)I
    .locals 0

    .line 29
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p0, p1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0
.end method

.method public static install(Landroid/app/Activity;)V
    .locals 5

    .line 31
    invoke-static {p0}, Lcom/navipilot/obf/WideTelemetry;->init(Landroid/content/Context;)V

    .line 32
    invoke-static {p0}, Lcom/navipilot/obf/WideCamera;->init(Landroid/content/Context;)V

    .line 33
    const-string v0, "wide_layout_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 34
    const-string v2, "left_percent"

    const/16 v3, 0x32

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v2

    const/16 v3, 0x4b

    invoke-static {v3, v2}, Ljava/lang/Math;->min(II)I

    move-result v2

    const/16 v3, 0x19

    invoke-static {v3, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    .line 35
    const-string v3, "top_percent"

    const/16 v4, 0x3c

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 36
    if-nez v0, :cond_0

    goto :goto_0

    :cond_0
    move v4, v0

    .line 37
    :goto_0
    if-nez v4, :cond_1

    goto :goto_1

    :cond_1
    const/16 v0, 0x50

    invoke-static {v0, v4}, Ljava/lang/Math;->min(II)I

    move-result v0

    const/16 v1, 0x14

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v1

    .line 38
    :goto_1
    sget-object v0, Lcom/navipilot/obf/WideTaiwanSettings;->ratios:Lcom/navipilot/obf/TF;

    mul-int/lit8 v2, v2, 0x64

    add-int/2addr v2, v1

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-interface {v0, v1}, Lcom/navipilot/obf/TF;->setValue(Ljava/lang/Object;)V

    .line 39
    const v0, 0x1020002

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    check-cast p0, Landroid/view/ViewGroup;

    .line 40
    return-void
.end method

.method static synthetic lambda$0(Landroid/app/Activity;Landroid/app/Dialog;Landroid/view/View;)V
    .locals 0

    .line 53
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->toggle(Landroid/content/Context;)V

    invoke-virtual {p1}, Landroid/app/Dialog;->dismiss()V

    return-void
.end method

.method static synthetic lambda$1(Landroid/app/Activity;Landroid/view/View;)V
    .locals 0

    .line 54
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->preview(Landroid/content/Context;)V

    return-void
.end method

.method public static left()I
    .locals 1

    .line 27
    sget-object v0, Lcom/navipilot/obf/WideTaiwanSettings;->ratios:Lcom/navipilot/obf/TF;

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    div-int/lit8 v0, v0, 0x64

    return v0
.end method

.method public static preview(II)V
    .locals 1

    .line 102
    const/16 v0, 0x4b

    invoke-static {v0, p0}, Ljava/lang/Math;->min(II)I

    move-result p0

    const/16 v0, 0x19

    invoke-static {v0, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    .line 103
    if-nez p1, :cond_0

    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    const/16 v0, 0x50

    invoke-static {v0, p1}, Ljava/lang/Math;->min(II)I

    move-result p1

    const/16 v0, 0x14

    invoke-static {v0, p1}, Ljava/lang/Math;->max(II)I

    move-result p1

    .line 104
    :goto_0
    sget-object v0, Lcom/navipilot/obf/WideTaiwanSettings;->ratios:Lcom/navipilot/obf/TF;

    mul-int/lit8 p0, p0, 0x64

    add-int/2addr p0, p1

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-interface {v0, p0}, Lcom/navipilot/obf/TF;->setValue(Ljava/lang/Object;)V

    .line 105
    return-void
.end method

.method public static save(Landroid/app/Activity;II)V
    .locals 2

    .line 107
    const-string v0, "wide_layout_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "left_percent"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "top_percent"

    invoke-interface {p0, v0, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 108
    invoke-static {p1, p2}, Lcom/navipilot/obf/WideTaiwanSettings;->preview(II)V

    .line 109
    return-void
.end method

.method public static show(Landroid/app/Activity;Landroid/view/ViewGroup;)V
    .locals 8

    .line 48
    new-instance v0, Landroid/app/Dialog;

    invoke-direct {v0, p0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    .line 49
    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/high16 v3, 0x41600000    # 14.0f

    invoke-static {p0, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result v4

    const/high16 v5, 0x41000000    # 8.0f

    invoke-static {p0, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result v6

    invoke-static {p0, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result v3

    invoke-static {p0, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result v5

    invoke-virtual {v2, v4, v6, v3, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const v3, -0xe8ddd0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 50
    const-string v3, "HCOP \u53f0\u7063\u901f\u9650 \u00b7 \u6e2c\u8a66\u7248"

    const/16 v4, 0x14

    invoke-static {p0, v3, v4}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 51
    const-string v3, "\u53f0\u7063\u8cc7\u6599\u53d6\u4ee3\u9053\u8def\u901f\u9650\u8207\u6e2c\u901f\u6b04\u4f4d\uff1b\u9ad8\u5fb7\u8f49\u5f4e\u8207\u8def\u7dda\u7e7c\u7e8c\u904b\u4f5c\u3002\u5be6\u969b\u4f86\u6e90\u8207\u9023\u7dda\u8acb\u770b\u4e0b\u65b9\u72c0\u614b\u3002"

    const/16 v5, 0xc

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 52
    invoke-static {p0}, Lcom/navipilot/obf/WideAutoStart;->enabled(Landroid/app/Activity;)Z

    move-result v3

    if-eqz v3, :cond_0

    const-string v3, "\u958b\u555f App \u6642\u81ea\u52d5\u555f\u7528\u53f0\u7063\u5b9a\u4f4d\u8207\u4f86\u6e90\uff1a\u958b"

    goto :goto_0

    :cond_0
    const-string v3, "\u958b\u555f App \u6642\u81ea\u52d5\u555f\u7528\u53f0\u7063\u5b9a\u4f4d\u8207\u4f86\u6e90\uff1a\u95dc"

    :goto_0
    new-instance v6, Lcom/navipilot/obf/WideTaiwanSettings$1;

    invoke-direct {v6, p0, v0}, Lcom/navipilot/obf/WideTaiwanSettings$1;-><init>(Landroid/app/Activity;Landroid/app/Dialog;)V

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 53
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->enabled(Landroid/content/Context;)Z

    move-result v3

    if-eqz v3, :cond_1

    const-string v3, "\u53f0\u7063\u6e2c\u901f\u8a9e\u97f3\uff1a\u958b"

    goto :goto_1

    :cond_1
    const-string v3, "\u53f0\u7063\u6e2c\u901f\u8a9e\u97f3\uff1a\u95dc"

    :goto_1
    new-instance v6, Lcom/navipilot/obf/WideTaiwanSettings$$ExternalSyntheticLambda0;

    invoke-direct {v6, p0, v0}, Lcom/navipilot/obf/WideTaiwanSettings$$ExternalSyntheticLambda0;-><init>(Landroid/app/Activity;Landroid/app/Dialog;)V

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 54
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$$ExternalSyntheticLambda1;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$$ExternalSyntheticLambda1;-><init>(Landroid/app/Activity;)V

    const-string v6, "\u8a66\u807d\u6e2c\u901f\u8a9e\u97f3"

    invoke-static {p0, v6, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 55
    sget-boolean v3, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v3, :cond_2

    const-string v3, "\u505c\u6b62\u6e2c\u901f GPS"

    goto :goto_2

    :cond_2
    const-string v3, "\u958b\u59cb\u6e2c\u901f GPS"

    :goto_2
    new-instance v6, Lcom/navipilot/obf/WideTaiwanSettings$2;

    invoke-direct {v6, p0, v0}, Lcom/navipilot/obf/WideTaiwanSettings$2;-><init>(Landroid/app/Activity;Landroid/app/Dialog;)V

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 56
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$3;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$3;-><init>(Landroid/app/Activity;)V

    const-string v6, "\u958b\u555f\u8eca\u6a5f\u5b9a\u4f4d\u8a2d\u5b9a"

    invoke-static {p0, v6, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 57
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$4;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$4;-><init>(Landroid/app/Activity;)V

    const-string v6, "App \u6b0a\u9650\u8a2d\u5b9a\uff08\u7cbe\u78ba\u5b9a\u4f4d\uff09"

    invoke-static {p0, v6, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 58
    const-string v3, "\u63a1\u7528 OSM \u96e2\u7dda\u9053\u8def\u3001HCOP \u7684 TDX \u65b9\u5411\u901f\u9650\uff0c\u4ee5\u53ca\u8b66\u653f\u7f72\u5c40\u90e8\u4fee\u6b63\u3002\u5b9a\u4f4d\u9700\u7cbe\u5ea6 \u226415 m\u3001\u9023\u7e8c 3 \u6b21\u4e14\u79fb\u52d5 5 m\u3002GPS \u8d85\u904e 3 \u79d2\u3001\u9053\u8def\u91cd\u758a\u6216\u901f\u9650\u885d\u7a81\u6642\uff0c\u4e0d\u63a1\u7528\u8a72\u7b46\u901f\u9650\u3002"

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 59
    const-string v3, "\u5df2\u78ba\u8a8d\u540c\u8def\u6bb5\u7684\u6e2c\u901f\u9ede\u986f\u793a\u6cbf\u8def\u8ddd\u96e2\uff0c\u4e0d\u8de8\u8def\u53e3\u731c\u8def\u7dda\u3002500 \u516c\u5c3a\u5167\u7684\u5019\u9078\u9ede\u53ea\u5728\u756b\u9762\u63d0\u9192\uff1b\u4f4e\u901f\u6216\u65b9\u5411\u4e0d\u660e\u6642\u4e5f\u53ef\u986f\u793a\u9644\u8fd1\u9ede\uff0c\u4f46\u53ef\u80fd\u4f4d\u65bc\u5f8c\u65b9\u3001\u5c0d\u5411\u6216\u5176\u4ed6\u9053\u8def\u3002\u672a\u914d\u5c0d\u7684\u56fa\u5b9a\u9ede\u8207\u5340\u9593\u8cc7\u6599\u4e0d\u50b3\u7d66 Carrot\u3002"

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 60
    const-string v3, "GPS \u4ee5\u6301\u7e8c\u901a\u77e5\u904b\u4f5c\uff0c\u96e2\u958b\u9762\u677f\u4ecd\u53ef\u5b9a\u4f4d\uff1b\u53ef\u5728\u901a\u77e5\u6309\u505c\u6b62\u3002\u793a\u7bc4\u8996\u7a97\u53ea\u986f\u793a\u6a21\u64ec\u6578\u5b57\u3002\u82e5\u8eca\u6a5f\u6c92\u6709 GPS\uff0c\u9019\u7248\u4e0d\u6703\u81ea\u52d5\u501f\u7528 C4 \u5b9a\u4f4d\u3002"

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 61
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$5;

    invoke-direct {v3, v0, p0, p1}, Lcom/navipilot/obf/WideTaiwanSettings$5;-><init>(Landroid/app/Dialog;Landroid/app/Activity;Landroid/view/ViewGroup;)V

    const-string v6, "\u7248\u9762\u8207\u6bd4\u4f8b\u8a2d\u5b9a"

    invoke-static {p0, v6, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 62
    const-string v3, "Carrot \u8cc7\u6599\u4f86\u6e90"

    invoke-static {p0, v3, v4}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 63
    invoke-static {}, Lcom/navipilot/obf/WideBridge;->enabled()Z

    move-result v3

    if-eqz v3, :cond_3

    const-string v3, "\u5207\u56de\u9ad8\u5fb7\u9053\u8def\u901f\u9650\u8207\u6e2c\u901f"

    goto :goto_3

    :cond_3
    const-string v3, "\u555f\u7528 HCOP \u53f0\u7063\u9053\u8def\u901f\u9650\uff0b\u6e2c\u901f\uff08\u6e2c\u8a66\uff09"

    :goto_3
    new-instance v6, Lcom/navipilot/obf/WideTaiwanSettings$6;

    invoke-direct {v6, v0}, Lcom/navipilot/obf/WideTaiwanSettings$6;-><init>(Landroid/app/Dialog;)V

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 64
    invoke-static {}, Lcom/navipilot/obf/WideBridgeLog;->recording()Z

    move-result v3

    if-eqz v3, :cond_4

    const-string v3, "\u505c\u6b62\u6e2c\u8a66\u7d00\u9304"

    goto :goto_4

    :cond_4
    const-string v3, "\u958b\u59cb\u6e2c\u8a66\u7d00\u9304\uff08\u542b GPS \u8ecc\u8de1\uff09"

    :goto_4
    new-instance v6, Lcom/navipilot/obf/WideTaiwanSettings$7;

    invoke-direct {v6, v0}, Lcom/navipilot/obf/WideTaiwanSettings$7;-><init>(Landroid/app/Dialog;)V

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 65
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$8;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$8;-><init>(Landroid/app/Activity;)V

    const-string v6, "\u505c\u6b62\u4e26\u532f\u51fa\u6e2c\u8a66\u7d00\u9304 ZIP"

    invoke-static {p0, v6, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 66
    invoke-static {}, Lcom/navipilot/obf/WideBridge;->report()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 67
    const-string v3, "\u300c\u5df2\u6392\u5165\u50b3\u9001\u300d\u4e0d\u662f C4 \u63a5\u6536\u78ba\u8a8d\u3002\u53f0\u7063\u6e2c\u901f\u9001\u51fa\u6642\uff0c\u6bcf 2 \u79d2\u6700\u591a\u67e5\u8a62\u4e00\u6b21\u63a5\u6536\u7aef\uff1b\u67e5\u8a62\u5931\u6557\u4e0d\u963b\u585e\u5c0e\u822a\u3002\u53ea\u6709\u7531\u63a5\u6536\u7aef /health \u56de\u5831\u76f8\u540c\u76ee\u6a19\u3001session\u3001sequence\u3001\u6e2c\u901f\u503c\uff0c\u624d\u986f\u793a\u300cC4 \u5df2\u63a5\u6536\u300d\uff1b\u63a5\u6536\u4e0d\u4ee3\u8868\u5df2\u57f7\u884c\u6e1b\u901f\u3002\u6c92\u6709\u76f8\u5bb9\u7684 Navi v2 \u901a\u9053\u6642\u4e0d\u6703\u53e6\u958b UDP \u5f37\u9001\u3002"

    const/16 v6, 0xd

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 69
    const-string v3, "\u53f0\u7063\u6a21\u5f0f\u7f3a\u5c11\u53ef\u9760\u8cc7\u6599\u6642\u986f\u793a \u2014 \u4e26\u64a4\u92b7\u8a72\u6b04\u4f4d\uff0c\u4e0d\u4ee5\u6e2c\u901f\u9ede\u731c\u6574\u689d\u9053\u8def\u901f\u9650\uff0c\u4e5f\u4e0d\u6697\u4e2d\u5207\u63db\u4f86\u6e90\u3002\u53ef\u624b\u52d5\u5207\u56de\u9ad8\u5fb7\u3002\u81ea\u52d5\u555f\u7528\u8a2d\u5b9a\u53ef\u65bc\u4e0a\u65b9\u95dc\u9589\uff1b\u672c\u5305\u96e2\u7dda\u8cc7\u6599\u4f7f\u7528\u671f\u9650\u81f3 2027-02-15\uff0c\u4e4b\u5f8c\u9700\u66f4\u65b0\u3002"

    const/16 v7, 0xe

    invoke-static {p0, v3, v7}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 70
    const-string v3, "\u5340\u9593\u50c5\u986f\u793a\u3001\u4e0d\u4e32\u63a5\uff1a\u672c\u7248\u53ea\u542b\u65b0\u5317 24 \u500b\u65b9\u5411\u5340\u9593\u3002\u9808\u9023\u7e8c\u8a18\u9304 GPS \u901a\u904e\u5165\u53e3\u624d\u958b\u59cb\u8a08\u6642\uff1b\u4e2d\u9014\u958b\u555f\u3001GPS \u4e2d\u65b7\u8d85\u904e 5 \u79d2\u3001\u8aa4\u5dee\u8d85\u904e 30 m\u3001\u8df3\u9ede\u6216\u5165\u53e3\u91cd\u758a\u6642\uff0c\u4e0d\u986f\u793a\u6709\u6548\u5012\u6578\u3002\u672a\u78ba\u8a8d\u540c\u4e00\u9053\u8def\uff0c\u4e0d\u80fd\u4fdd\u8b49\u7b26\u5408\u57f7\u6cd5\u8a2d\u5099\u7684\u5be6\u969b\u8a08\u6642\u3002"

    invoke-static {p0, v3, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 71
    const-string v3, "\u539f\u59cb\u9ede\u4f4d\u8a3a\u65b7\uff08\u4e0d\u5728\u4e3b\u8981\u9762\u677f\u986f\u793a\uff09"

    invoke-static {p0, v3, v4}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 72
    invoke-static {}, Lcom/navipilot/obf/WideCamera;->report()Ljava/lang/String;

    move-result-object v3

    const/16 v4, 0xb

    invoke-static {p0, v3, v4}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 73
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$9;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$9;-><init>(Landroid/app/Activity;)V

    const-string v4, "\u8907\u88fd\u6e2c\u901f\u8a3a\u65b7\uff08\u542b\u76ee\u524d\u5ea7\u6a19\uff09"

    invoke-static {p0, v4, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 78
    const-string v3, "\u8cc7\u6599\u4f86\u6e90\uff1a\u8b66\u653f\u7f72 2026 \u6e2c\u901f\u57f7\u6cd5\u8a2d\u7f6e\u9ede\u3002\u672c App \u6574\u7406\u4e4b\u56fa\u5b9a\u9ede\u5feb\u7167\uff0c\u4f9d\u653f\u5e9c\u8cc7\u6599\u958b\u653e\u6388\u6b0a\u689d\u6b3e\u7b2c 1 \u7248\u4f7f\u7528\u3002\nhttps://data.gov.tw/dataset/7320\nhttps://data.gov.tw/license\n\u65b0\u589e\uff1a\u65b0\u5317\u5e02\u653f\u5e9c\u8b66\u5bdf\u5c40 2026 \u5340\u9593\u5e73\u5747\u901f\u7387\u57f7\u6cd5\u8a2d\u5099\u8a2d\u7f6e\u5730\u9ede\uff08\u653f\u5e9c\u8cc7\u6599\u958b\u653e\u6388\u6b0a\u689d\u6b3e\u7b2c 1 \u7248\uff09\u3002\nhttps://data.ntpc.gov.tw/datasets/27b97ad9-9dba-4ca9-b0ed-14b29000ffec\n\u4e0b\u8f09\u65e5\u671f\u4e0d\u662f\u5404\u9ede\u66f4\u65b0\u65e5\u671f\u3002\u56fa\u5b9a\u9ede\u5b98\u65b9\u4e0d\u5b9a\u671f\u66f4\u65b0\uff0c\u65b0\u5317\u5340\u9593\u76ee\u9304\u6a19\u793a\u6bcf\u5e74\u66f4\u65b0\u3002"

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 79
    const-string v3, "\u9053\u8def\u5716\u8cc7\uff1a\u00a9 OpenStreetMap contributors\uff0cGeofabrik Taiwan 2026-11-08\u3002ODbL 1.0\u3002\nhttps://www.openstreetmap.org/copyright\nHCOP \u7a0b\u5f0f\u8207\u4fee\u6b63\u8cc7\u6599\u4f86\u6e90\uff1ahttps://github.com/henryopen/openpilot\uff08MIT\uff1b\u5716\u8cc7\u53e6\u4f9d\u539f\u6388\u6b0a\uff09\n\u5168\u53f0\u96e2\u7dda\u9053\u8def\u8207\u8def\u53e3\u9593\u7247\u6bb5\uff0c\u4e0d\u731c\u6e2c\u8de8\u8def\u53e3\u8def\u7dda\u3002HCOP TDX \u5feb\u7167 2026-10-18\uff1b\u4e0d\u5c07\u539f\u7248 800 m \u5713\u5f62\u4fee\u6b63\u76f4\u63a5\u5957\u7d66\u6574\u689d\u9053\u8def\u3002\u8cc7\u6599\u5feb\u7167\u4e0d\u4fdd\u8b49\u73fe\u5834\u6a19\u8a8c\u672a\u8b8a\u66f4\u3002"

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 80
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->report()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 81
    invoke-static {}, Lcom/navipilot/obf/WideTelemetry;->report()Ljava/lang/String;

    move-result-object v3

    invoke-static {p0, v3, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 82
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$10;

    invoke-direct {v3, p0}, Lcom/navipilot/obf/WideTaiwanSettings$10;-><init>(Landroid/app/Activity;)V

    const-string v4, "\u8907\u88fd\u76ee\u524d\u8eca\u6cc1\u8a3a\u65b7"

    invoke-static {p0, v4, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 87
    new-instance v3, Lcom/navipilot/obf/WideTaiwanSettings$11;

    invoke-direct {v3, v0}, Lcom/navipilot/obf/WideTaiwanSettings$11;-><init>(Landroid/app/Dialog;)V

    const-string v4, "\u95dc\u9589"

    invoke-static {p0, v4, v3}, Lcom/navipilot/obf/WideTaiwanSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 88
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v3, v1}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    invoke-virtual {v3, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    invoke-static {v0, v3}, Lcom/navipilot/obf/WideFixedFooter;->install(Landroid/app/Dialog;Landroid/widget/ScrollView;)V

    .line 89
    invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v1

    const v2, 0x106000d

    invoke-virtual {v1, v2}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 90
    const/4 v2, 0x2

    invoke-virtual {v1, v2}, Landroid/view/Window;->clearFlags(I)V

    .line 91
    const/16 v2, 0x20

    invoke-virtual {v1, v2}, Landroid/view/Window;->addFlags(I)V

    .line 92
    invoke-virtual {v0}, Landroid/app/Dialog;->show()V

    .line 93
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getWidth()I

    move-result v2

    invoke-virtual {p1}, Landroid/view/ViewGroup;->getHeight()I

    move-result v3

    .line 94
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->plan()Lcom/navipilot/obf/WideGeometry$Plan;

    move-result-object v4

    .line 95
    iget-boolean v5, v4, Lcom/navipilot/obf/WideGeometry$Plan;->compact:Z

    if-eqz v5, :cond_5

    goto :goto_5

    :cond_5
    const/high16 v5, 0x438c0000    # 280.0f

    invoke-static {p0, v5}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result v5

    iget v6, v4, Lcom/navipilot/obf/WideGeometry$Plan;->sideWidth:F

    invoke-static {p0, v6}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result p0

    invoke-static {v5, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    invoke-static {v2, p0}, Ljava/lang/Math;->min(II)I

    move-result v2

    :goto_5
    invoke-virtual {v1, v2, v3}, Landroid/view/Window;->setLayout(II)V

    .line 96
    iget-boolean p0, v4, Lcom/navipilot/obf/WideGeometry$Plan;->compact:Z

    if-eqz p0, :cond_6

    const/16 p0, 0x11

    goto :goto_6

    :cond_6
    const/16 p0, 0x35

    :goto_6
    invoke-virtual {v1, p0}, Landroid/view/Window;->setGravity(I)V

    .line 97
    new-instance p0, Lcom/navipilot/obf/WideTaiwanSettings$12;

    invoke-direct {p0, v0}, Lcom/navipilot/obf/WideTaiwanSettings$12;-><init>(Landroid/app/Dialog;)V

    .line 98
    invoke-virtual {p1, p0}, Landroid/view/ViewGroup;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 99
    new-instance v1, Lcom/navipilot/obf/WideTaiwanSettings$13;

    invoke-direct {v1, p1, p0}, Lcom/navipilot/obf/WideTaiwanSettings$13;-><init>(Landroid/view/ViewGroup;Landroid/view/View$OnLayoutChangeListener;)V

    invoke-virtual {v0, v1}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    .line 100
    return-void
.end method

.method private static text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 1

    .line 42
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, -0x1

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    int-to-float p1, p2

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextSize(F)V

    const/high16 p1, 0x40c00000    # 6.0f

    invoke-static {p0, p1}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result p2

    invoke-static {p0, p1}, Lcom/navipilot/obf/WideTaiwanSettings;->dp(Landroid/content/Context;F)I

    move-result p0

    const/4 p1, 0x0

    invoke-virtual {v0, p1, p2, p1, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method public static top()I
    .locals 1

    .line 28
    sget-object v0, Lcom/navipilot/obf/WideTaiwanSettings;->ratios:Lcom/navipilot/obf/TF;

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    rem-int/lit8 v0, v0, 0x64

    return v0
.end method
