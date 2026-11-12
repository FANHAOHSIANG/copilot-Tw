.class Lcom/navipilot/obf/WideForwardRoads$1;
.super Ljava/lang/Object;
.source "WideForwardRoads.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/navipilot/obf/WideForwardRoads;->explore(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideHcopRoad$Road;ID)Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Lcom/navipilot/obf/WideForwardRoads$Step;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Lcom/navipilot/obf/WideForwardRoads$Step;Lcom/navipilot/obf/WideForwardRoads$Step;)I
    .registers 7

    .line 37
    iget-wide v0, p1, Lcom/navipilot/obf/WideForwardRoads$Step;->penalty:D

    iget-wide v2, p2, Lcom/navipilot/obf/WideForwardRoads$Step;->penalty:D

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Double;->compare(DD)I

    move-result v0

    if-nez v0, :cond_12

    iget-wide v0, p1, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    iget-wide v2, p2, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    invoke-static {v0, v1, v2, v3}, Ljava/lang/Double;->compare(DD)I

    move-result v0

    .line 38
    :cond_12
    if-nez v0, :cond_20

    iget-object p1, p1, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object p1, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object p2, p2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object p2, p2, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v0

    :cond_20
    return v0
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .registers 3

    .line 1
    check-cast p1, Lcom/navipilot/obf/WideForwardRoads$Step;

    check-cast p2, Lcom/navipilot/obf/WideForwardRoads$Step;

    invoke-virtual {p0, p1, p2}, Lcom/navipilot/obf/WideForwardRoads$1;->compare(Lcom/navipilot/obf/WideForwardRoads$Step;Lcom/navipilot/obf/WideForwardRoads$Step;)I

    move-result p1

    return p1
.end method
