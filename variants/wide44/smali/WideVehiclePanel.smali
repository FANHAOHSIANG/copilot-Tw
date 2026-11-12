.class public final Lcom/navipilot/obf/WideVehiclePanel;
.super Ljava/lang/Object;
.source "WideVehiclePanel.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideVehiclePanel$State;
    }
.end annotation


# static fields
.field private static volatile latest:Lcom/navipilot/obf/WideVehiclePanel$State;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    .line 6
    new-instance v0, Lcom/navipilot/obf/WideVehiclePanel$State;

    invoke-direct {v0}, Lcom/navipilot/obf/WideVehiclePanel$State;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideVehiclePanel;->latest:Lcom/navipilot/obf/WideVehiclePanel$State;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static current()Lcom/navipilot/obf/WideVehiclePanel$State;
    .registers 6

    .line 15
    sget-object v0, Lcom/navipilot/obf/WideVehiclePanel;->latest:Lcom/navipilot/obf/WideVehiclePanel$State;

    new-instance v1, Lcom/navipilot/obf/WideVehiclePanel$State;

    invoke-direct {v1}, Lcom/navipilot/obf/WideVehiclePanel$State;-><init>()V

    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v2

    const-wide/32 v4, 0xf4240

    div-long/2addr v2, v4

    iget-wide v4, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->speedExpiry:J

    cmp-long v4, v2, v4

    if-gez v4, :cond_19

    iget-wide v4, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    iput-wide v4, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    :cond_19
    iget-wide v4, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->cruiseExpiry:J

    cmp-long v4, v2, v4

    if-gez v4, :cond_23

    iget-wide v4, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->cruise:D

    iput-wide v4, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->cruise:D

    :cond_23
    iget-wide v4, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->controlExpiry:J

    cmp-long v2, v2, v4

    if-gez v2, :cond_31

    iget-object v2, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->lateral:Ljava/lang/Boolean;

    iput-object v2, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->lateral:Ljava/lang/Boolean;

    iget-object v0, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->longitudinal:Ljava/lang/Boolean;

    iput-object v0, v1, Lcom/navipilot/obf/WideVehiclePanel$State;->longitudinal:Ljava/lang/Boolean;

    :cond_31
    return-object v1
.end method

.method static number(Ljava/lang/Object;D)D
    .registers 8

    .line 7
    instance-of v0, p0, Ljava/lang/Number;

    const-wide/high16 v1, 0x7ff8000000000000L    # Double.NaN

    if-nez v0, :cond_7

    return-wide v1

    :cond_7
    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->doubleValue()D

    move-result-wide v3

    mul-double/2addr v3, p1

    invoke-static {v3, v4}, Ljava/lang/Double;->isFinite(D)Z

    move-result p0

    if-eqz p0, :cond_24

    const-wide/16 p0, 0x0

    cmpl-double p0, v3, p0

    if-ltz p0, :cond_24

    const-wide p0, 0x4076800000000000L    # 360.0

    cmpg-double p0, v3, p0

    if-gtz p0, :cond_24

    move-wide v1, v3

    :cond_24
    return-wide v1
.end method

.method public static update(Lcom/navipilot/obf/zg;)V
    .registers 12

    .line 8
    new-instance v0, Lcom/navipilot/obf/WideVehiclePanel$State;

    invoke-direct {v0}, Lcom/navipilot/obf/WideVehiclePanel$State;-><init>()V

    invoke-static {}, Ljava/lang/System;->nanoTime()J

    move-result-wide v1

    const-wide/32 v3, 0xf4240

    div-long/2addr v1, v3

    .line 9
    if-eqz p0, :cond_af

    const-string v3, "carState"

    invoke-virtual {p0, v3}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object v3

    const-string v4, "carControl"

    invoke-virtual {p0, v4}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object v4

    const-string v5, "selfdriveState"

    invoke-virtual {p0, v5}, Lcom/navipilot/obf/zg;->b(Ljava/lang/String;)Lcom/navipilot/obf/vg;

    move-result-object p0

    .line 10
    const-wide/16 v5, 0xbb8

    if-eqz v3, :cond_4e

    iget-object v7, v3, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    if-eqz v7, :cond_4e

    iget-object v7, v3, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v7, v7, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    if-eqz v7, :cond_4e

    iget-object v7, v3, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v7, v7, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    const-string v8, "vEgo"

    invoke-virtual {v7, v8}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    const-wide v8, 0x400ccccccccccccdL    # 3.6

    invoke-static {v7, v8, v9}, Lcom/navipilot/obf/WideVehiclePanel;->number(Ljava/lang/Object;D)D

    move-result-wide v7

    iput-wide v7, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->speed:D

    iget-wide v7, v3, Lcom/navipilot/obf/vg;->c:J

    add-long v9, v1, v5

    invoke-static {v7, v8, v9, v10}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v7

    iput-wide v7, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->speedExpiry:J

    .line 11
    :cond_4e
    if-eqz v4, :cond_88

    iget-object v3, v4, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    if-eqz v3, :cond_88

    iget-object v3, v4, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v3, v3, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    if-eqz v3, :cond_88

    iget-object v3, v4, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v3, v3, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    const-string v7, "latActive"

    invoke-interface {v3, v7}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    const-string v8, "longActive"

    invoke-interface {v3, v8}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    instance-of v8, v7, Ljava/lang/Boolean;

    const/4 v9, 0x0

    if-eqz v8, :cond_72

    check-cast v7, Ljava/lang/Boolean;

    goto :goto_73

    :cond_72
    move-object v7, v9

    :goto_73
    iput-object v7, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->lateral:Ljava/lang/Boolean;

    instance-of v7, v3, Ljava/lang/Boolean;

    if-eqz v7, :cond_7c

    move-object v9, v3

    check-cast v9, Ljava/lang/Boolean;

    :cond_7c
    iput-object v9, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->longitudinal:Ljava/lang/Boolean;

    iget-wide v3, v4, Lcom/navipilot/obf/vg;->c:J

    add-long v7, v1, v5

    invoke-static {v3, v4, v7, v8}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v3

    iput-wide v3, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->controlExpiry:J

    .line 12
    :cond_88
    if-eqz p0, :cond_af

    iget-object v3, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    if-eqz v3, :cond_af

    iget-object v3, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v3, v3, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    if-eqz v3, :cond_af

    iget-object v3, p0, Lcom/navipilot/obf/vg;->a:Lcom/navipilot/obf/tg;

    iget-object v3, v3, Lcom/navipilot/obf/tg;->c:Ljava/util/LinkedHashMap;

    const-string v4, "vCruise"

    invoke-virtual {v3, v4}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    const-wide/high16 v7, 0x3ff0000000000000L    # 1.0

    invoke-static {v3, v7, v8}, Lcom/navipilot/obf/WideVehiclePanel;->number(Ljava/lang/Object;D)D

    move-result-wide v3

    iput-wide v3, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->cruise:D

    iget-wide v3, p0, Lcom/navipilot/obf/vg;->c:J

    add-long/2addr v1, v5

    invoke-static {v3, v4, v1, v2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    iput-wide v1, v0, Lcom/navipilot/obf/WideVehiclePanel$State;->cruiseExpiry:J

    .line 13
    :cond_af
    sput-object v0, Lcom/navipilot/obf/WideVehiclePanel;->latest:Lcom/navipilot/obf/WideVehiclePanel$State;

    .line 14
    return-void
.end method
