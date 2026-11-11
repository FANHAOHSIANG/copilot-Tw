.class final Lcom/navipilot/obf/WideCameraTrace$Candidate;
.super Ljava/lang/Object;
.source "WideCameraTrace.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideCameraTrace;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Candidate"
.end annotation


# instance fields
.field cost:D

.field final direction:I

.field final point:Lcom/navipilot/obf/WideRoad$Projection;

.field final road:Lcom/navipilot/obf/WideHcopRoad$Road;

.field samples:I

.field since:J


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V
    .locals 1

    .line 33
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 30
    const/4 v0, 0x1

    iput v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    .line 34
    iput-object p1, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 35
    iput-object p2, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    .line 36
    iput p3, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    .line 37
    iput-wide p4, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 38
    iput-wide p6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    .line 39
    return-void
.end method


# virtual methods
.method entry()J
    .locals 2

    .line 41
    iget v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-lez v0, :cond_0

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    :goto_0
    return-wide v0
.end method

.method exit()J
    .locals 2

    .line 42
    iget v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-lez v0, :cond_0

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-wide v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    :goto_0
    return-wide v0
.end method

.method progress()D
    .locals 4

    .line 43
    iget v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-lez v0, :cond_0

    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v0, v0, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    goto :goto_0

    :cond_0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v0, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    iget-object v2, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v2, v2, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    sub-double/2addr v0, v2

    :goto_0
    return-wide v0
.end method
