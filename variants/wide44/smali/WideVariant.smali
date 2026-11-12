.class public final Lcom/navipilot/obf/WideVariant;
.super Ljava/lang/Object;
.source "WideVariant.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideVariant$Navigation;
    }
.end annotation


# static fields
.field static final GOOGLE_DISPLAY:Ljava/lang/String; = "WideGoogleMaps"

.field static final GOOGLE_PACKAGE:Ljava/lang/String; = "com.google.android.apps.maps"

.field private static final NAVIGATION_KEY:Ljava/lang/String; = "navigation_package"

.field private static final PHONE_KEY:Ljava/lang/String; = "phone_amap"

.field private static final PREFS:Ljava/lang/String; = "copilot_tw_projection"

.field private static host:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/app/Activity;",
            ">;"
        }
    .end annotation
.end field

.field private static navigation:Lcom/navipilot/obf/WideVariant$Navigation;

.field private static shield:Z

.field private static volatile teslaShield:Z


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 40
    new-instance v0, Ljava/lang/ref/WeakReference;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideVariant;->host:Ljava/lang/ref/WeakReference;

    .line 41
    sget-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->CAR:Lcom/navipilot/obf/WideVariant$Navigation;

    sput-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 43
    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static activity(Landroid/content/Context;)Landroid/app/Activity;
    .registers 2

    .line 108
    nop

    :goto_1
    instance-of v0, p0, Landroid/content/ContextWrapper;

    if-nez v0, :cond_6

    goto :goto_16

    .line 109
    :cond_6
    instance-of v0, p0, Landroid/app/Activity;

    if-eqz v0, :cond_d

    check-cast p0, Landroid/app/Activity;

    return-object p0

    .line 110
    :cond_d
    move-object v0, p0

    check-cast v0, Landroid/content/ContextWrapper;

    invoke-virtual {v0}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object v0

    .line 111
    if-ne v0, p0, :cond_1f

    .line 114
    :goto_16
    sget-object p0, Lcom/navipilot/obf/WideVariant;->host:Ljava/lang/ref/WeakReference;

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/Activity;

    return-object p0

    .line 112
    :cond_1f
    move-object p0, v0

    goto :goto_1
.end method

.method public static displayName()Ljava/lang/String;
    .registers 1

    .line 63
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    iget-object v0, v0, Lcom/navipilot/obf/WideVariant$Navigation;->displayName:Ljava/lang/String;

    return-object v0
.end method

.method public static init(Landroid/app/Activity;)V
    .registers 1

    .line 57
    invoke-static {p0}, Lcom/navipilot/obf/WideCamera;->init(Landroid/content/Context;)V

    return-void
.end method

.method private static installed(Landroid/content/Context;Ljava/lang/String;)Z
    .registers 3

    .line 100
    const/4 v0, 0x0

    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    invoke-virtual {p0, p1, v0}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;
    :try_end_8
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start_1 .. :try_end_8} :catch_a

    .line 101
    const/4 p0, 0x1

    return p0

    .line 102
    :catch_a
    move-exception p0

    .line 103
    return v0
.end method

.method public static isPhone()Z
    .registers 2

    .line 60
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    sget-object v1, Lcom/navipilot/obf/WideVariant$Navigation;->PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

    if-ne v0, v1, :cond_8

    const/4 v0, 0x1

    return v0

    :cond_8
    const/4 v0, 0x0

    return v0
.end method

.method public static mapName()Ljava/lang/String;
    .registers 1

    .line 62
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    iget-object v0, v0, Lcom/navipilot/obf/WideVariant$Navigation;->label:Ljava/lang/String;

    return-object v0
.end method

.method static navigation()Lcom/navipilot/obf/WideVariant$Navigation;
    .registers 1

    .line 59
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    return-object v0
.end method

.method public static packageName()Ljava/lang/String;
    .registers 1

    .line 61
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    iget-object v0, v0, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    return-object v0
.end method

.method public static prepare(Landroid/app/Activity;)V
    .registers 5

    .line 46
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideVariant;->host:Ljava/lang/ref/WeakReference;

    .line 47
    invoke-static {p0}, Lcom/navipilot/obf/WideGoogleNav;->init(Landroid/content/Context;)V

    .line 48
    const-string v0, "copilot_tw_projection"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 49
    nop

    .line 50
    sget-object v2, Lcom/navipilot/obf/WideVariant$Navigation;->CAR:Lcom/navipilot/obf/WideVariant$Navigation;

    iget-object v2, v2, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    invoke-static {p0, v2}, Lcom/navipilot/obf/WideVariant;->installed(Landroid/content/Context;Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_28

    sget-object v2, Lcom/navipilot/obf/WideVariant$Navigation;->PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

    iget-object v2, v2, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    invoke-static {p0, v2}, Lcom/navipilot/obf/WideVariant;->installed(Landroid/content/Context;Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_28

    const/4 p0, 0x1

    goto :goto_29

    :cond_28
    move p0, v1

    .line 49
    :goto_29
    const-string v2, "phone_amap"

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    .line 51
    const-string v2, "navigation_package"

    const/4 v3, 0x0

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2, p0}, Lcom/navipilot/obf/WideVariant$Navigation;->restore(Ljava/lang/String;Z)Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 52
    const-string p0, "shield_panel"

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    sput-boolean p0, Lcom/navipilot/obf/WideVariant;->shield:Z

    .line 53
    const-string p0, "tesla_shield"

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    sput-boolean p0, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    .line 54
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->packageName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->select(Ljava/lang/String;)V

    .line 55
    return-void
.end method

.method static select(Landroid/app/Activity;Lcom/navipilot/obf/WideVariant$Navigation;)V
    .registers 4

    .line 66
    sget-object v0, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    if-ne v0, p1, :cond_5

    return-void

    .line 67
    :cond_5
    sput-object p1, Lcom/navipilot/obf/WideVariant;->navigation:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 68
    const-string v0, "copilot_tw_projection"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 69
    const-string v0, "navigation_package"

    iget-object v1, p1, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 68
    nop

    .line 70
    sget-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->GOOGLE:Lcom/navipilot/obf/WideVariant$Navigation;

    if-eq p1, v0, :cond_28

    const-string p1, "phone_amap"

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->isPhone()Z

    move-result v0

    invoke-interface {p0, p1, v0}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 71
    :cond_28
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 72
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->packageName()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->select(Ljava/lang/String;)V

    .line 73
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->changeMap()V

    .line 74
    return-void
.end method

.method static shieldPanel()Z
    .registers 1

    .line 76
    sget-boolean v0, Lcom/navipilot/obf/WideVariant;->shield:Z

    return v0
.end method

.method static teslaShield()Z
    .registers 1

    .line 77
    sget-boolean v0, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    return v0
.end method

.method static togglePanel(Landroid/app/Activity;)V
    .registers 4

    .line 80
    sget-boolean v0, Lcom/navipilot/obf/WideVariant;->shield:Z

    xor-int/lit8 v0, v0, 0x1

    sput-boolean v0, Lcom/navipilot/obf/WideVariant;->shield:Z

    .line 81
    const-string v0, "copilot_tw_projection"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 82
    const-string v1, "shield_panel"

    sget-boolean v2, Lcom/navipilot/obf/WideVariant;->shield:Z

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 83
    invoke-virtual {p0}, Landroid/app/Activity;->recreate()V

    .line 84
    return-void
.end method

.method static toggleTeslaShield(Landroid/app/Activity;)V
    .registers 5

    .line 87
    invoke-static {}, Lcom/navipilot/obf/WideTeslaProjection;->isActive()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_11

    .line 88
    const-string v0, "\u8acb\u5148\u505c\u6b62 Amap2Tesla \u6295\u5c4f"

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 89
    return-void

    .line 91
    :cond_11
    sget-boolean v0, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    xor-int/lit8 v0, v0, 0x1

    sput-boolean v0, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    .line 92
    const-string v0, "copilot_tw_projection"

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 93
    const-string v2, "tesla_shield"

    sget-boolean v3, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 94
    sget-boolean v0, Lcom/navipilot/obf/WideVariant;->teslaShield:Z

    if-eqz v0, :cond_33

    const-string v0, "\u4e0b\u6b21 Amap2Tesla \u50c5\u6295\u795e\u76fe"

    goto :goto_35

    :cond_33
    const-string v0, "\u5df2\u95dc\u9589 Tesla \u55ae\u6295\u795e\u76fe"

    .line 95
    :goto_35
    nop

    .line 94
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    .line 95
    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 96
    return-void
.end method
