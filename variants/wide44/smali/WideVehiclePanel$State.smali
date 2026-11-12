.class public final Lcom/navipilot/obf/WideVehiclePanel$State;
.super Ljava/lang/Object;
.source "WideVehiclePanel.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideVehiclePanel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "State"
.end annotation


# instance fields
.field controlExpiry:J

.field public cruise:D

.field cruiseExpiry:J

.field public lateral:Ljava/lang/Boolean;

.field public longitudinal:Ljava/lang/Boolean;

.field public speed:D

.field speedExpiry:J


# direct methods
.method public constructor <init>()V
    .registers 3

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const-wide/high16 v0, 0x7ff8000000000000L    # Double.NaN

    iput-wide v0, p0, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    iput-wide v0, p0, Lcom/navipilot/obf/WideVehiclePanel$State;->cruise:D

    return-void
.end method
