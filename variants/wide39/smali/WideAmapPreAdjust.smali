.class public final Lcom/navipilot/obf/WideAmapPreAdjust;
.super Ljava/lang/Object;
.source "WideAmapPreAdjust.java"


# static fields
.field static final KEY:Ljava/lang/String; = "_copilot_amap_pre_adjust"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static finish(Lorg/json/JSONObject;Lorg/json/JSONObject;JJ)Lorg/json/JSONObject;
    .locals 6

    .line 31
    const-string v0, "_copilot_amap_pre_adjust"

    const-string v1, "road_limit_kph"

    const/4 v2, 0x0

    if-nez p1, :cond_0

    return-object v2

    .line 33
    :cond_0
    :try_start_0
    new-instance v3, Lorg/json/JSONObject;

    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v3, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 34
    invoke-virtual {v3, v0}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;

    .line 35
    const/4 p1, -0x1

    if-nez p0, :cond_1

    move v0, p1

    goto :goto_0

    :cond_1
    invoke-virtual {p0, v0, p1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v0

    .line 36
    :goto_0
    const-wide/16 v4, 0x0

    cmp-long v4, p2, v4

    if-lez v4, :cond_3

    cmp-long v4, p4, p2

    if-ltz v4, :cond_3

    sub-long/2addr p4, p2

    const-wide/16 p2, 0x7d0

    cmp-long p2, p4, p2

    if-gtz p2, :cond_3

    invoke-static {v0}, Lcom/navipilot/obf/WideAmapPreAdjust;->valid(I)Z

    move-result p2

    if-eqz p2, :cond_3

    .line 37
    invoke-virtual {p0, v1, p1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    if-ne p0, v0, :cond_3

    .line 38
    invoke-virtual {v3, v1, p1}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    .line 39
    if-lez p0, :cond_2

    invoke-static {p0, v0}, Ljava/lang/Math;->min(II)I

    move-result v0

    :cond_2
    invoke-virtual {v3, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 41
    :cond_3
    invoke-virtual {v3}, Lorg/json/JSONObject;->length()I

    move-result p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    if-nez p0, :cond_4

    goto :goto_1

    :cond_4
    move-object v2, v3

    :goto_1
    return-object v2

    .line 42
    :catch_0
    move-exception p0

    return-object v2
.end method

.method public static mark(Lorg/json/JSONObject;Ljava/lang/Integer;)Lorg/json/JSONObject;
    .locals 4

    .line 12
    const-string v0, "_copilot_amap_pre_adjust"

    const/4 v1, 0x0

    if-nez p0, :cond_0

    return-object v1

    .line 14
    :cond_0
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-virtual {p0}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 15
    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;

    .line 16
    if-eqz p1, :cond_1

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-static {p0}, Lcom/navipilot/obf/WideAmapPreAdjust;->valid(I)Z

    move-result p0

    if-eqz p0, :cond_1

    const-string p0, "road_limit_kph"

    const/4 v3, -0x1

    invoke-virtual {v2, p0, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result p0

    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result v3

    if-ne p0, v3, :cond_1

    .line 17
    invoke-virtual {p1}, Ljava/lang/Integer;->intValue()I

    move-result p0

    invoke-virtual {v2, v0, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 18
    :cond_1
    return-object v2

    .line 19
    :catch_0
    move-exception p0

    return-object v1
.end method

.method public static merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    .locals 6

    .line 23
    invoke-static {p0, p1, p2}, Lcom/navipilot/obf/WideBridge;->merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;

    move-result-object v1

    .line 24
    const-string v0, "speed"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    return-object v1

    .line 25
    :cond_0
    invoke-interface {p2, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 26
    instance-of p2, p0, Ljava/lang/Number;

    if-eqz p2, :cond_1

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide v2

    goto :goto_0

    :cond_1
    const-wide/16 v2, 0x0

    .line 27
    :goto_0
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    move-object v0, p1

    invoke-static/range {v0 .. v5}, Lcom/navipilot/obf/WideAmapPreAdjust;->finish(Lorg/json/JSONObject;Lorg/json/JSONObject;JJ)Lorg/json/JSONObject;

    move-result-object p0

    return-object p0
.end method

.method static valid(I)Z
    .locals 2

    .line 9
    const/16 v0, 0xa

    if-lt p0, v0, :cond_0

    const/16 v1, 0xc8

    if-gt p0, v1, :cond_0

    rem-int/2addr p0, v0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method
