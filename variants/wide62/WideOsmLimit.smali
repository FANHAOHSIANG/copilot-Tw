.class public final Lcom/navipilot/obf/WideOsmLimit;
.super Ljava/lang/Object;

.method public static filter(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    .locals 7

    const-string v0, "speed"
    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-eqz v0, :unchanged

    :try_start
    new-instance v0, Lorg/json/JSONObject;
    if-eqz p1, :empty
    invoke-virtual {p1}, Lorg/json/JSONObject;->toString()Ljava/lang/String;
    move-result-object v1
    invoke-direct {v0, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    goto :strip

    :empty
    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    :strip
    const-string v1, "_copilot_amap_pre_adjust"
    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;
    const-string v1, "road_limit_kph"
    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->remove(Ljava/lang/String;)Ljava/lang/Object;

    invoke-static {}, Lcom/navipilot/obf/WideOsmLocation;->sendLimitToC4()Z
    move-result v2
    if-eqz v2, :done

    # current() checks GPS state, fix validity, and the decision's monotonic age.
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;
    move-result-object v2
    invoke-static {v2}, Lcom/navipilot/obf/WideOsmLimit;->value(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    move-result v4
    if-lez v4, :done
    invoke-virtual {v0, v1, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J
    move-result-wide v3
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J
    move-result-wide v5
    sub-long/2addr v3, v5
    iget-wide v5, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J
    add-long/2addr v3, v5
    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;
    move-result-object v2
    invoke-interface {p2, p0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :done
    invoke-virtual {v0}, Lorg/json/JSONObject;->length()I
    move-result v1
    if-eqz v1, :absent
    :try_end
    .catch Lorg/json/JSONException; {:try_start .. :try_end} :invalid

    return-object v0

    :invalid
    move-exception v0

    :absent
    const/4 v0, 0x0
    return-object v0

    :unchanged
    return-object p1
.end method


.method private static value(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    .locals 6

    move-object v2, p0
    iget-boolean v3, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z
    if-eqz v3, :missing
    iget-object v3, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;
    if-eqz v3, :missing
    iget v4, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I
    const/4 v5, 0x1
    if-eq v4, v5, :forward
    const/4 v5, -0x1
    if-ne v4, v5, :missing
    iget v4, v3, Lcom/navipilot/obf/WideHcopRoad$Road;->backward:I
    goto :validate

    :forward
    iget v4, v3, Lcom/navipilot/obf/WideHcopRoad$Road;->forward:I

    :validate
    # Use the C4 protocol's existing validation, with no rounding or fallback.
    invoke-static {v4}, Lcom/navipilot/obf/WideAmapPreAdjust;->valid(I)Z
    move-result v3
    if-eqz v3, :missing
    return v4

    :missing
    const/4 v0, 0x0
    return v0
.end method

.method static currentValue()I
    .locals 1

    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;
    move-result-object v0
    invoke-static {v0}, Lcom/navipilot/obf/WideOsmLimit;->value(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    move-result v0
    return v0
.end method

.method static status()Ljava/lang/String;
    .locals 3

    invoke-static {}, Lcom/navipilot/obf/WideOsmLimit;->currentValue()I
    move-result v0
    if-lez v0, :unknown
    new-instance v1, Ljava/lang/StringBuilder;
    const-string v2, "\nOSM 道路速限："
    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, " km/h"
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-static {v1}, Lcom/navipilot/obf/WideOsmLimit;->appendOfficial(Ljava/lang/StringBuilder;)V
    const-string v2, ""
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :unknown
    const-string v0, "\nOSM 道路速限：未知"
    return-object v0
.end method

.method private static appendOfficial(Ljava/lang/StringBuilder;)V
    .locals 3
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;
    move-result-object v0
    iget-boolean v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z
    if-eqz v1, :done
    const-string v1, "TDX"
    iget-object v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;
    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    const-string v1, "\nTDX 同路段速限參考："
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    iget v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v1, " km/h"
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :done
    return-void
.end method
