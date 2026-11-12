.class final Lcom/navipilot/obf/WideForwardRoads$Step;
.super Ljava/lang/Object;
.source "WideForwardRoads.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideForwardRoads;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x18
    name = "Step"
.end annotation


# instance fields
.field final depth:I

.field final direction:I

.field final entryDistance:D

.field final length:D

.field final penalty:D

.field final road:Lcom/navipilot/obf/WideHcopRoad$Road;

.field final visited:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideHcopRoad$Road;IDDILjava/util/Set;)V
    .registers 11
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/WideHcopRoad$Road;",
            "IDDI",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)V"
        }
    .end annotation

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 12
    iput-object p1, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iput p2, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->direction:I

    iput-wide p3, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    iput-wide p5, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->penalty:D

    iput p7, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->depth:I

    iput-object p8, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->visited:Ljava/util/Set;

    .line 13
    move-object p2, p1

    iget-object p1, p2, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-object p3, p2, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    const/4 p4, 0x0

    aget-object p3, p3, p4

    const/4 p5, 0x1

    aget-wide p5, p3, p5

    iget-object p2, p2, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object p2, p2, p4

    aget-wide p3, p2, p4

    move-wide v0, p5

    move-wide p4, p3

    move-wide p2, v0

    const-wide/16 p6, 0x0

    invoke-static/range {p1 .. p7}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object p1

    iget-wide p1, p1, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    iput-wide p1, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->length:D

    .line 14
    return-void
.end method


# virtual methods
.method exit()J
    .registers 3

    .line 15
    iget v0, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->direction:I

    if-lez v0, :cond_9

    iget-object v0, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    goto :goto_d

    :cond_9
    iget-object v0, p0, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    :goto_d
    return-wide v0
.end method
