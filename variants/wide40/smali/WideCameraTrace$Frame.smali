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

.field final time:J


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideHcopRoad$Data;JLcom/navipilot/obf/WideHcopRoad$Decision;)V
    .locals 0

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    iput-wide p2, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    iput-object p4, p0, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    return-void
.end method
