.class final enum Lcom/navipilot/obf/WideVariant$Navigation;
.super Ljava/lang/Enum;
.source "WideVariant.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideVariant;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x4018
    name = "Navigation"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/navipilot/obf/WideVariant$Navigation;",
        ">;"
    }
.end annotation


# static fields
.field public static final enum CAR:Lcom/navipilot/obf/WideVariant$Navigation;

.field private static final synthetic ENUM$VALUES:[Lcom/navipilot/obf/WideVariant$Navigation;

.field public static final enum GOOGLE:Lcom/navipilot/obf/WideVariant$Navigation;

.field public static final enum PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

.field public static final enum SDK:Lcom/navipilot/obf/WideVariant$Navigation;


# instance fields
.field final compactLabel:Ljava/lang/String;

.field final displayName:Ljava/lang/String;

.field final label:Ljava/lang/String;

.field final packageName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 10

    .line 18
    new-instance v0, Lcom/navipilot/obf/WideVariant$Navigation;

    const-string v5, "\u9ad8\u5fb7\u8eca\u6a5f"

    const-string v6, "WideAmapAuto"

    const-string v1, "CAR"

    const/4 v2, 0x0

    const-string v3, "com.autonavi.amapauto"

    const-string v4, "\u9ad8\u5fb7\u8eca\u6a5f\u7248"

    invoke-direct/range {v0 .. v6}, Lcom/navipilot/obf/WideVariant$Navigation;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->CAR:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 19
    new-instance v1, Lcom/navipilot/obf/WideVariant$Navigation;

    const-string v6, "\u9ad8\u5fb7\u4e00\u822c"

    const-string v7, "WideAmapPhone"

    const-string v2, "PHONE"

    const/4 v3, 0x1

    const-string v4, "com.autonavi.minimap"

    const-string v5, "\u9ad8\u5fb7\u4e00\u822c\u7248"

    invoke-direct/range {v1 .. v7}, Lcom/navipilot/obf/WideVariant$Navigation;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v1, Lcom/navipilot/obf/WideVariant$Navigation;->PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 20
    new-instance v2, Lcom/navipilot/obf/WideVariant$Navigation;

    const-string v7, "Google \u5730\u5716"

    const-string v8, "WideGoogleMaps"

    const-string v3, "GOOGLE"

    const/4 v4, 0x2

    const-string v5, "com.google.android.apps.maps"

    const-string v6, "Google \u5730\u5716"

    invoke-direct/range {v2 .. v8}, Lcom/navipilot/obf/WideVariant$Navigation;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v2, Lcom/navipilot/obf/WideVariant$Navigation;->GOOGLE:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 21
    new-instance v3, Lcom/navipilot/obf/WideVariant$Navigation;

    const-string v8, "Google SDK"

    const-string v9, "WideGoogleSdk"

    const-string v4, "SDK"

    const/4 v5, 0x3

    const-string v6, "com.copilottw.googlenav"

    const-string v7, "CP Google \u5c0e\u822a"

    invoke-direct/range {v3 .. v9}, Lcom/navipilot/obf/WideVariant$Navigation;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v3, Lcom/navipilot/obf/WideVariant$Navigation;->SDK:Lcom/navipilot/obf/WideVariant$Navigation;

    .line 17
    sget-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->CAR:Lcom/navipilot/obf/WideVariant$Navigation;

    sget-object v1, Lcom/navipilot/obf/WideVariant$Navigation;->PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

    sget-object v2, Lcom/navipilot/obf/WideVariant$Navigation;->GOOGLE:Lcom/navipilot/obf/WideVariant$Navigation;

    sget-object v3, Lcom/navipilot/obf/WideVariant$Navigation;->SDK:Lcom/navipilot/obf/WideVariant$Navigation;

    filled-new-array {v0, v1, v2, v3}, [Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->ENUM$VALUES:[Lcom/navipilot/obf/WideVariant$Navigation;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 7

    .line 25
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 26
    iput-object p3, p0, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    .line 27
    iput-object p4, p0, Lcom/navipilot/obf/WideVariant$Navigation;->label:Ljava/lang/String;

    .line 28
    iput-object p5, p0, Lcom/navipilot/obf/WideVariant$Navigation;->compactLabel:Ljava/lang/String;

    .line 29
    iput-object p6, p0, Lcom/navipilot/obf/WideVariant$Navigation;->displayName:Ljava/lang/String;

    .line 30
    return-void
.end method

.method static restore(Ljava/lang/String;Z)Lcom/navipilot/obf/WideVariant$Navigation;
    .registers 7

    .line 33
    invoke-static {}, Lcom/navipilot/obf/WideVariant$Navigation;->values()[Lcom/navipilot/obf/WideVariant$Navigation;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_6
    if-lt v2, v1, :cond_10

    .line 36
    if-eqz p1, :cond_d

    sget-object p0, Lcom/navipilot/obf/WideVariant$Navigation;->PHONE:Lcom/navipilot/obf/WideVariant$Navigation;

    goto :goto_f

    :cond_d
    sget-object p0, Lcom/navipilot/obf/WideVariant$Navigation;->CAR:Lcom/navipilot/obf/WideVariant$Navigation;

    :goto_f
    return-object p0

    .line 33
    :cond_10
    aget-object v3, v0, v2

    .line 34
    iget-object v4, v3, Lcom/navipilot/obf/WideVariant$Navigation;->packageName:Ljava/lang/String;

    invoke-virtual {v4, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1b

    return-object v3

    .line 33
    :cond_1b
    add-int/lit8 v2, v2, 0x1

    goto :goto_6
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/navipilot/obf/WideVariant$Navigation;
    .registers 2

    .line 1
    const-class v0, Lcom/navipilot/obf/WideVariant$Navigation;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/navipilot/obf/WideVariant$Navigation;

    return-object p0
.end method

.method public static values()[Lcom/navipilot/obf/WideVariant$Navigation;
    .registers 4

    .line 1
    sget-object v0, Lcom/navipilot/obf/WideVariant$Navigation;->ENUM$VALUES:[Lcom/navipilot/obf/WideVariant$Navigation;

    array-length v1, v0

    new-array v2, v1, [Lcom/navipilot/obf/WideVariant$Navigation;

    const/4 v3, 0x0

    invoke-static {v0, v3, v2, v3, v1}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    return-object v2
.end method
