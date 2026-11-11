.class public final Lcom/navipilot/obf/WideSettings;
.super Ljava/lang/Object;
.source "WideSettings.java"


# static fields
.field private static final PREF:Ljava/lang/String; = "wide_layout_preferences"

.field private static final expanded:[Lcom/navipilot/obf/TF;

.field private static final ratios:[Lcom/navipilot/obf/TF;


# direct methods
.method static constructor <clinit>()V
    .locals 5

    .line 22
    const/4 v0, 0x2

    new-array v1, v0, [Lcom/navipilot/obf/TF;

    const/16 v2, 0x1388

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    sget-object v3, Lcom/navipilot/obf/bT;->k:Lcom/navipilot/obf/bT;

    invoke-static {v2, v3}, Lcom/navipilot/obf/GS;->f(Ljava/lang/Object;Lcom/navipilot/obf/KV;)Lcom/navipilot/obf/pK;

    move-result-object v2

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const/16 v2, 0x157c

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    sget-object v4, Lcom/navipilot/obf/bT;->k:Lcom/navipilot/obf/bT;

    invoke-static {v2, v4}, Lcom/navipilot/obf/GS;->f(Ljava/lang/Object;Lcom/navipilot/obf/KV;)Lcom/navipilot/obf/pK;

    move-result-object v2

    const/4 v4, 0x1

    aput-object v2, v1, v4

    sput-object v1, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    .line 23
    new-array v0, v0, [Lcom/navipilot/obf/TF;

    const/4 v1, -0x1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    sget-object v2, Lcom/navipilot/obf/bT;->k:Lcom/navipilot/obf/bT;

    invoke-static {v1, v2}, Lcom/navipilot/obf/GS;->f(Ljava/lang/Object;Lcom/navipilot/obf/KV;)Lcom/navipilot/obf/pK;

    move-result-object v2

    aput-object v2, v0, v3

    sget-object v2, Lcom/navipilot/obf/bT;->k:Lcom/navipilot/obf/bT;

    invoke-static {v1, v2}, Lcom/navipilot/obf/GS;->f(Ljava/lang/Object;Lcom/navipilot/obf/KV;)Lcom/navipilot/obf/pK;

    move-result-object v1

    aput-object v1, v0, v4

    sput-object v0, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    .line 24
    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$0()[Lcom/navipilot/obf/TF;
    .locals 1

    .line 23
    sget-object v0, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    return-object v0
.end method

.method static synthetic access$1(Z)Ljava/lang/String;
    .locals 0

    .line 26
    invoke-static {p0}, Lcom/navipilot/obf/WideSettings;->prefix(Z)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;
    .locals 2

    .line 66
    const v0, -0xd0904

    invoke-static {p0, p1, v0, p2}, Lcom/navipilot/obf/WideUi;->button(Landroid/content/Context;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object p1

    .line 67
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v0, -0x1

    const/4 v1, -0x2

    invoke-direct {p2, v0, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 68
    const/high16 v0, 0x40400000    # 3.0f

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v1

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result p0

    const/4 v0, 0x0

    invoke-virtual {p2, v0, v1, v0, p0}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 69
    invoke-virtual {p1, p2}, Landroid/widget/Button;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 70
    return-object p1
.end method

.method public static controlsVisible()Z
    .locals 5

    .line 30
    sget-object v0, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->index()I

    move-result v1

    aget-object v0, v0, v1

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    .line 31
    const/4 v1, 0x0

    const/4 v2, 0x1

    if-gez v0, :cond_0

    sget v0, Lcom/navipilot/obf/WideLayout;->pageWidth:F

    const/high16 v3, 0x41400000    # 12.0f

    sub-float/2addr v0, v3

    sget v4, Lcom/navipilot/obf/WideLayout;->pageHeight:F

    sub-float/2addr v4, v3

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->left()I

    move-result v3

    invoke-static {v0, v4, v3}, Lcom/navipilot/obf/WideGeometry;->compact(FFI)Z

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    :cond_0
    if-ne v0, v2, :cond_2

    :cond_1
    move v1, v2

    :cond_2
    :goto_0
    return v1
.end method

.method private static dp(Landroid/content/Context;F)I
    .locals 0

    .line 43
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

.method private static index()I
    .locals 1

    .line 25
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v0

    return v0
.end method

.method public static install(Landroid/app/Activity;)V
    .locals 8

    .line 45
    invoke-static {p0}, Lcom/navipilot/obf/WideTelemetry;->init(Landroid/content/Context;)V

    .line 46
    invoke-static {p0}, Lcom/navipilot/obf/WideVariant;->init(Landroid/app/Activity;)V

    .line 47
    const-string v0, "wide_layout_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 48
    move v2, v1

    :goto_0
    const/4 v3, 0x2

    if-lt v2, v3, :cond_0

    .line 55
    const v0, 0x1020002

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    .line 56
    invoke-static {p0, v0}, Lcom/navipilot/obf/WideInsets;->install(Landroid/app/Activity;Landroid/view/ViewGroup;)V

    .line 57
    return-void

    .line 49
    :cond_0
    const/4 v3, 0x1

    if-ne v2, v3, :cond_1

    move v4, v3

    goto :goto_1

    :cond_1
    move v4, v1

    :goto_1
    invoke-static {v4}, Lcom/navipilot/obf/WideSettings;->prefix(Z)Ljava/lang/String;

    move-result-object v4

    .line 50
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v6

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v6, "primary"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    if-nez v2, :cond_2

    const-string v6, "left_percent"

    const/16 v7, 0x32

    invoke-interface {v0, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    goto :goto_2

    :cond_2
    const/16 v6, 0x37

    :goto_2
    invoke-interface {v0, v5, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v5

    .line 51
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v7

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v7, "secondary"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    if-nez v2, :cond_3

    const-string v7, "top_percent"

    invoke-interface {v0, v7, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v7

    goto :goto_3

    :cond_3
    move v7, v1

    :goto_3
    invoke-interface {v0, v6, v7}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v6

    .line 52
    if-ne v2, v3, :cond_4

    move v7, v3

    goto :goto_4

    :cond_4
    move v7, v1

    :goto_4
    invoke-static {v7, v5, v6}, Lcom/navipilot/obf/WideSettings;->previewFor(ZII)V

    .line 53
    sget-object v5, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    aget-object v5, v5, v2

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v6, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, "controls"

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const/4 v6, -0x1

    invoke-interface {v0, v4, v6}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v4

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    invoke-static {v6, v3}, Ljava/lang/Math;->max(II)I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v5, v3}, Lcom/navipilot/obf/TF;->setValue(Ljava/lang/Object;)V

    .line 48
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_0
.end method

.method static layoutPreferences()I
    .locals 4

    .line 34
    sget-object v0, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    mul-int/lit8 v0, v0, 0x3

    sget-object v2, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    aget-object v1, v2, v1

    invoke-interface {v1}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Number;

    invoke-virtual {v1}, Ljava/lang/Number;->intValue()I

    move-result v1

    add-int/2addr v0, v1

    const/4 v1, 0x1

    add-int/2addr v0, v1

    .line 35
    sget-object v2, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    aget-object v2, v2, v1

    invoke-interface {v2}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Number;

    invoke-virtual {v2}, Ljava/lang/Number;->intValue()I

    move-result v2

    mul-int/lit8 v2, v2, 0x3

    sget-object v3, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    aget-object v3, v3, v1

    invoke-interface {v3}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Number;

    invoke-virtual {v3}, Ljava/lang/Number;->intValue()I

    move-result v3

    add-int/2addr v2, v3

    add-int/2addr v2, v1

    .line 36
    shl-int/lit8 v0, v0, 0x10

    or-int/2addr v0, v2

    return v0
.end method

.method public static left()I
    .locals 2

    .line 27
    sget-object v0, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->index()I

    move-result v1

    aget-object v0, v0, v1

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    div-int/lit8 v0, v0, 0x64

    return v0
.end method

.method private static prefix(Z)Ljava/lang/String;
    .locals 0

    .line 26
    if-eqz p0, :cond_0

    const-string p0, "portrait_"

    goto :goto_0

    :cond_0
    const-string p0, "landscape_"

    :goto_0
    return-object p0
.end method

.method public static preview(II)V
    .locals 1

    .line 130
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v0

    invoke-static {v0, p0, p1}, Lcom/navipilot/obf/WideSettings;->previewFor(ZII)V

    .line 131
    return-void
.end method

.method public static previewFor(ZII)V
    .locals 1

    .line 133
    invoke-static {p1}, Lcom/navipilot/obf/WideGeometry;->percent(I)I

    move-result p1

    .line 134
    if-nez p2, :cond_0

    const/4 p2, 0x0

    goto :goto_0

    :cond_0
    const/16 v0, 0x50

    invoke-static {v0, p2}, Ljava/lang/Math;->min(II)I

    move-result p2

    const/16 v0, 0x14

    invoke-static {v0, p2}, Ljava/lang/Math;->max(II)I

    move-result p2

    .line 135
    :goto_0
    sget-object v0, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    aget-object p0, v0, p0

    mul-int/lit8 p1, p1, 0x64

    add-int/2addr p1, p2

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    invoke-interface {p0, p1}, Lcom/navipilot/obf/TF;->setValue(Ljava/lang/Object;)V

    .line 136
    return-void
.end method

.method public static save(Landroid/app/Activity;II)V
    .locals 1

    .line 138
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v0

    invoke-static {p0, v0, p1, p2}, Lcom/navipilot/obf/WideSettings;->saveFor(Landroid/app/Activity;ZII)V

    .line 139
    return-void
.end method

.method public static saveFor(Landroid/app/Activity;ZII)V
    .locals 3

    .line 141
    invoke-static {p1}, Lcom/navipilot/obf/WideSettings;->prefix(Z)Ljava/lang/String;

    move-result-object v0

    .line 142
    const-string v1, "wide_layout_preferences"

    const/4 v2, 0x0

    invoke-virtual {p0, v1, v2}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, "primary"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-interface {p0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "secondary"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p0, v0, p3}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 143
    invoke-static {p1, p2, p3}, Lcom/navipilot/obf/WideSettings;->previewFor(ZII)V

    .line 144
    return-void
.end method

.method public static show(Landroid/app/Activity;Landroid/view/ViewGroup;)V
    .locals 16

    .line 74
    move-object/from16 v1, p0

    move-object/from16 v6, p1

    new-instance v5, Landroid/app/Dialog;

    invoke-direct {v5, v1}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    const/4 v7, 0x1

    invoke-virtual {v5, v7}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    .line 75
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v2

    .line 76
    new-instance v15, Landroid/widget/LinearLayout;

    invoke-direct {v15, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v15, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/high16 v0, 0x41600000    # 14.0f

    invoke-static {v1, v0}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v3

    const/high16 v4, 0x41000000    # 8.0f

    invoke-static {v1, v4}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v8

    invoke-static {v1, v0}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v0

    invoke-static {v1, v4}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v4

    invoke-virtual {v15, v3, v8, v0, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const v0, -0xf4ecdf

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    .line 77
    const/16 v0, 0xb

    const v3, -0x6e3a01

    const-string v4, "COPILOT TW"

    invoke-static {v1, v4, v0, v3, v7}, Lcom/navipilot/obf/WideUi;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object v0

    .line 78
    const v3, 0x3de147ae    # 0.11f

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setLetterSpacing(F)V

    .line 79
    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 80
    const-string v0, "\u986f\u793a\u8207\u7248\u9762"

    const/16 v3, 0x16

    invoke-static {v1, v0, v3}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 81
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->shieldPanel()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "\u795e\u76fe\u6e2c\u901f"

    goto :goto_0

    :cond_0
    const-string v0, "\u53f0\u7063\u6e2c\u901f"

    :goto_0
    move-object v14, v0

    .line 82
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->mapName()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v3, "  \u00b7  "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const/16 v3, 0xe

    invoke-static {v1, v0, v3}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 83
    new-instance v0, Lcom/navipilot/obf/WideSettings$1;

    invoke-direct {v0, v5, v1, v6}, Lcom/navipilot/obf/WideSettings$1;-><init>(Landroid/app/Dialog;Landroid/app/Activity;Landroid/view/ViewGroup;)V

    const-string v3, "\u53f0\u7063\u6e2c\u901f\u8a2d\u5b9a\u8207\u8a3a\u65b7"

    invoke-static {v1, v3, v0}, Lcom/navipilot/obf/WideSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 84
    if-eqz v2, :cond_1

    const-string v0, "\u76f4\u5411\u914d\u7f6e"

    goto :goto_1

    :cond_1
    const-string v0, "\u6a6b\u5411\u914d\u7f6e"

    :goto_1
    const/16 v3, 0x12

    invoke-static {v1, v0, v3}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 85
    const-string v0, "\u5169\u7a2e\u65b9\u5411\u5404\u81ea\u5132\u5b58\u3002\u4e5f\u53ef\u76f4\u63a5\u62d6\u66f3\u5206\u5340\u908a\u7de3\u8abf\u6574\u3002"

    const/16 v4, 0xd

    invoke-static {v1, v0, v4}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 86
    const-string v0, ""

    const/16 v4, 0xf

    invoke-static {v1, v0, v4}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v11

    invoke-virtual {v15, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 87
    new-instance v9, Landroid/widget/SeekBar;

    invoke-direct {v9, v1}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    const/16 v8, 0x32

    invoke-virtual {v9, v8}, Landroid/widget/SeekBar;->setMax(I)V

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->left()I

    move-result v8

    add-int/lit8 v8, v8, -0x19

    invoke-virtual {v9, v8}, Landroid/widget/SeekBar;->setProgress(I)V

    invoke-virtual {v15, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 88
    invoke-static {v1, v0, v4}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v13

    invoke-virtual {v15, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 89
    new-instance v4, Landroid/widget/SeekBar;

    invoke-direct {v4, v1}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    const/16 v0, 0x3c

    invoke-virtual {v4, v0}, Landroid/widget/SeekBar;->setMax(I)V

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->top()I

    move-result v0

    if-nez v0, :cond_2

    const/16 v0, 0x37

    goto :goto_2

    :cond_2
    invoke-static {}, Lcom/navipilot/obf/WideSettings;->top()I

    move-result v0

    :goto_2
    add-int/lit8 v0, v0, -0x14

    invoke-virtual {v4, v0}, Landroid/widget/SeekBar;->setProgress(I)V

    invoke-virtual {v15, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 90
    new-instance v8, Lcom/navipilot/obf/WideSettings$2;

    move v12, v2

    move-object v10, v4

    invoke-direct/range {v8 .. v14}, Lcom/navipilot/obf/WideSettings$2;-><init>(Landroid/widget/SeekBar;Landroid/widget/SeekBar;Landroid/widget/TextView;ZLandroid/widget/TextView;Ljava/lang/String;)V

    .line 95
    new-instance v0, Lcom/navipilot/obf/WideSettings$3;

    invoke-direct {v0, v8}, Lcom/navipilot/obf/WideSettings$3;-><init>(Ljava/lang/Runnable;)V

    .line 98
    invoke-virtual {v9, v0}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    invoke-virtual {v4, v0}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    invoke-interface {v8}, Ljava/lang/Runnable;->run()V

    .line 99
    new-instance v0, Lcom/navipilot/obf/WideSettings$4;

    move v8, v3

    move-object v3, v9

    invoke-direct/range {v0 .. v5}, Lcom/navipilot/obf/WideSettings$4;-><init>(Landroid/app/Activity;ZLandroid/widget/SeekBar;Landroid/widget/SeekBar;Landroid/app/Dialog;)V

    const-string v3, "\u5957\u7528\u4e26\u5132\u5b58"

    invoke-static {v1, v3, v0}, Lcom/navipilot/obf/WideSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 100
    new-instance v0, Lcom/navipilot/obf/WideSettings$5;

    invoke-direct {v0, v1, v2, v5}, Lcom/navipilot/obf/WideSettings$5;-><init>(Landroid/app/Activity;ZLandroid/app/Dialog;)V

    const-string v2, "\u6062\u5fa9\u9019\u500b\u65b9\u5411\u7684\u9810\u8a2d\u6392\u7248"

    invoke-static {v1, v2, v0}, Lcom/navipilot/obf/WideSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 105
    const-string v0, "\u9023\u7dda\u8207\u8a3a\u65b7"

    invoke-static {v1, v0, v8}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 106
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->report()Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0xc

    invoke-static {v1, v0, v2}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 107
    invoke-static {}, Lcom/navipilot/obf/WideTelemetry;->report()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0, v2}, Lcom/navipilot/obf/WideSettings;->text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 108
    new-instance v0, Lcom/navipilot/obf/WideSettings$6;

    invoke-direct {v0, v1}, Lcom/navipilot/obf/WideSettings$6;-><init>(Landroid/app/Activity;)V

    const-string v2, "\u8907\u88fd\u76ee\u524d\u8eca\u6cc1\u8a3a\u65b7"

    invoke-static {v1, v2, v0}, Lcom/navipilot/obf/WideSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 113
    new-instance v0, Lcom/navipilot/obf/WideSettings$7;

    invoke-direct {v0, v5}, Lcom/navipilot/obf/WideSettings$7;-><init>(Landroid/app/Dialog;)V

    const-string v2, "\u95dc\u9589"

    invoke-static {v1, v2, v0}, Lcom/navipilot/obf/WideSettings;->action(Landroid/app/Activity;Ljava/lang/String;Landroid/view/View$OnClickListener;)Landroid/widget/Button;

    move-result-object v0

    invoke-virtual {v15, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 114
    new-instance v0, Landroid/widget/ScrollView;

    invoke-direct {v0, v1}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v7}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    invoke-virtual {v0, v15}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    invoke-static {v5, v0}, Lcom/navipilot/obf/WideFixedFooter;->install(Landroid/app/Dialog;Landroid/widget/ScrollView;)V

    .line 115
    invoke-virtual {v5}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v0

    const v2, 0x106000d

    invoke-virtual {v0, v2}, Landroid/view/Window;->setBackgroundDrawableResource(I)V

    .line 116
    const/4 v2, 0x2

    invoke-virtual {v0, v2}, Landroid/view/Window;->clearFlags(I)V

    .line 117
    const/16 v2, 0x20

    invoke-virtual {v0, v2}, Landroid/view/Window;->addFlags(I)V

    .line 118
    invoke-virtual {v5}, Landroid/app/Dialog;->show()V

    .line 119
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->plan()Lcom/navipilot/obf/WideGeometry$Plan;

    move-result-object v2

    .line 120
    invoke-virtual {v6}, Landroid/view/ViewGroup;->getWidth()I

    move-result v3

    invoke-virtual {v6}, Landroid/view/ViewGroup;->getHeight()I

    move-result v4

    .line 121
    iget-boolean v7, v2, Lcom/navipilot/obf/WideGeometry$Plan;->compact:Z

    if-eqz v7, :cond_3

    goto :goto_3

    :cond_3
    const/high16 v7, 0x438c0000    # 280.0f

    invoke-static {v1, v7}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v7

    iget v8, v2, Lcom/navipilot/obf/WideGeometry$Plan;->sideWidth:F

    invoke-static {v1, v8}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v1

    invoke-static {v7, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    invoke-static {v3, v1}, Ljava/lang/Math;->min(II)I

    move-result v3

    :goto_3
    invoke-virtual {v0, v3, v4}, Landroid/view/Window;->setLayout(II)V

    .line 122
    iget-boolean v1, v2, Lcom/navipilot/obf/WideGeometry$Plan;->compact:Z

    if-eqz v1, :cond_4

    const/16 v1, 0x11

    goto :goto_4

    :cond_4
    const/16 v1, 0x35

    :goto_4
    invoke-virtual {v0, v1}, Landroid/view/Window;->setGravity(I)V

    .line 123
    new-instance v0, Lcom/navipilot/obf/WideSettings$8;

    invoke-direct {v0, v5}, Lcom/navipilot/obf/WideSettings$8;-><init>(Landroid/app/Dialog;)V

    .line 126
    invoke-virtual {v6, v0}, Landroid/view/ViewGroup;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 127
    new-instance v1, Lcom/navipilot/obf/WideSettings$9;

    invoke-direct {v1, v6, v0}, Lcom/navipilot/obf/WideSettings$9;-><init>(Landroid/view/ViewGroup;Landroid/view/View$OnLayoutChangeListener;)V

    invoke-virtual {v5, v1}, Landroid/app/Dialog;->setOnDismissListener(Landroid/content/DialogInterface$OnDismissListener;)V

    .line 128
    return-void
.end method

.method private static text(Landroid/app/Activity;Ljava/lang/String;I)Landroid/widget/TextView;
    .locals 3

    .line 59
    const/16 v0, 0xf

    if-lt p2, v0, :cond_0

    const v1, -0xd0904

    goto :goto_0

    :cond_0
    const v1, -0x594837

    .line 60
    :goto_0
    const/4 v2, 0x0

    if-lt p2, v0, :cond_1

    const/4 v0, 0x1

    goto :goto_1

    :cond_1
    move v0, v2

    :goto_1
    invoke-static {p0, p1, p2, v1, v0}, Lcom/navipilot/obf/WideUi;->text(Landroid/content/Context;Ljava/lang/String;IIZ)Landroid/widget/TextView;

    move-result-object p1

    .line 61
    const/high16 p2, 0x40c00000    # 6.0f

    invoke-static {p0, p2}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result v0

    invoke-static {p0, p2}, Lcom/navipilot/obf/WideSettings;->dp(Landroid/content/Context;F)I

    move-result p0

    invoke-virtual {p1, v2, v0, v2, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 62
    return-object p1
.end method

.method public static toggleControls(Landroid/app/Activity;)V
    .locals 4

    .line 39
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v0

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v1

    .line 40
    xor-int/lit8 v1, v1, 0x1

    sget-object v2, Lcom/navipilot/obf/WideSettings;->expanded:[Lcom/navipilot/obf/TF;

    aget-object v2, v2, v0

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-interface {v2, v3}, Lcom/navipilot/obf/TF;->setValue(Ljava/lang/Object;)V

    .line 41
    const-string v2, "wide_layout_preferences"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-static {v0}, Lcom/navipilot/obf/WideSettings;->prefix(Z)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "controls"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 42
    return-void
.end method

.method public static top()I
    .locals 2

    .line 28
    sget-object v0, Lcom/navipilot/obf/WideSettings;->ratios:[Lcom/navipilot/obf/TF;

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->index()I

    move-result v1

    aget-object v0, v0, v1

    invoke-interface {v0}, Lcom/navipilot/obf/TF;->getValue()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->intValue()I

    move-result v0

    rem-int/lit8 v0, v0, 0x64

    return v0
.end method
