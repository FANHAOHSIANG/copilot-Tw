.class public final Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;
.super Ljava/lang/Object;
.source "WideGoogleAdapter.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideGoogleAdapter;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Snapshot"
.end annotation


# instance fields
.field public final age:J

.field public final current:Lorg/json/JSONObject;

.field public final next:Lorg/json/JSONObject;

.field public final reason:Ljava/lang/String;

.field public final received:J

.field public final route:Lorg/json/JSONObject;

.field public final status:Lorg/json/JSONObject;

.field public final vehicle:Lorg/json/JSONObject;


# direct methods
.method constructor <init>(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;JJLjava/lang/String;)V
    .registers 11

    .line 8
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->current:Lorg/json/JSONObject;

    iput-object p2, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->next:Lorg/json/JSONObject;

    iput-object p3, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->route:Lorg/json/JSONObject;

    iput-object p4, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->vehicle:Lorg/json/JSONObject;

    iput-object p5, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->status:Lorg/json/JSONObject;

    iput-wide p6, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->received:J

    iput-wide p8, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->age:J

    iput-object p10, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->reason:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public value(Ljava/lang/String;J)Lorg/json/JSONObject;
    .registers 8

    .line 10
    iget-wide v0, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->received:J

    cmp-long v0, p2, v0

    const/4 v1, 0x0

    if-ltz v0, :cond_4c

    iget-wide v2, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->received:J

    sub-long/2addr p2, v2

    iget-wide v2, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->age:J

    add-long/2addr p2, v2

    const-wide/16 v2, 0xbb8

    cmp-long p2, p2, v2

    if-lez p2, :cond_14

    goto :goto_4c

    .line 11
    :cond_14
    const-string p2, "guidance_current"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1f

    iget-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->current:Lorg/json/JSONObject;

    return-object p1

    :cond_1f
    const-string p2, "guidance_next"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_2a

    iget-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->next:Lorg/json/JSONObject;

    return-object p1

    .line 12
    :cond_2a
    const-string p2, "route"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_35

    iget-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->route:Lorg/json/JSONObject;

    return-object p1

    :cond_35
    const-string p2, "vehicle"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_40

    iget-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->vehicle:Lorg/json/JSONObject;

    return-object p1

    :cond_40
    const-string p2, "navigation_status"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4b

    iget-object p1, p0, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->status:Lorg/json/JSONObject;

    return-object p1

    :cond_4b
    return-object v1

    .line 10
    :cond_4c
    :goto_4c
    return-object v1
.end method
