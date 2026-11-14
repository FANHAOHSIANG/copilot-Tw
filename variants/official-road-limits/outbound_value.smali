.method private static outboundValue(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    .locals 2

    iget-boolean v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z
    if-eqz v0, :missing

    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;
    const-string v1, "TDX"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :tdx

    const-string v1, "OSM"
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :missing

    invoke-static {p0}, Lcom/navipilot/obf/WideOsmLimit;->value(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    move-result v0
    return v0

    :tdx
    iget v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I
    invoke-static {v0}, Lcom/navipilot/obf/WideAmapPreAdjust;->valid(I)Z
    move-result v1
    if-eqz v1, :missing
    return v0

    :missing
    const/4 v0, 0x0
    return v0
.end method

.method static status()Ljava/lang/String;
    .locals 4

    invoke-static {}, Lcom/navipilot/obf/WideOsmLocation;->sendLimitToC4()Z
    move-result v0
    if-eqz v0, :off

    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;
    move-result-object v0
    invoke-static {v0}, Lcom/navipilot/obf/WideOsmLimit;->outboundValue(Lcom/navipilot/obf/WideHcopRoad$Decision;)I
    move-result v1
    if-lez v1, :unknown

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;
    const-string v2, "TDX"
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v0
    if-nez v0, :format
    const-string v2, "OSM"

    :format
    new-instance v0, Ljava/lang/StringBuilder;
    const-string v3, "\nC4 道路速限候選："
    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v2, " "
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v2, " km/h"
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :off
    const-string v0, "\nC4 道路速限傳送：關閉"
    return-object v0

    :unknown
    const-string v0, "\nC4 道路速限候選：未確認"
    return-object v0
.end method
