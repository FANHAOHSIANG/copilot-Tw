.class final Lcom/navipilot/obf/WideCameraTrace$Frame;
.super Ljava/lang/Object;
.source "WideCameraTrace.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideCameraTrace;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Frame"
.end annotation


# instance fields
.field final data:Lcom/navipilot/obf/WideHcopRoad$Data;

.field final decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

.field final fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

.field final time:J


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;Lcom/navipilot/obf/WideHcopRoad$Decision;)V
    .registers 4

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    iput-object p2, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-nez p2, :cond_c

    const-wide/16 p1, 0x0

    goto :goto_e

    :cond_c
    iget-wide p1, p2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    :goto_e
    iput-wide p1, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    iput-object p3, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    return-void
.end method
