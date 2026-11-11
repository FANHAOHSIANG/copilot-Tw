.class Lcom/navipilot/obf/WideCameraFallback$Track;
.super Ljava/lang/Object;
.source "WideCameraFallback.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideCameraFallback;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0xa
    name = "Track"
.end annotation


# instance fields
.field distance:D

.field first:J

.field samples:I

.field start:D

.field time:J


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method synthetic constructor <init>(Lcom/navipilot/obf/WideCameraFallback-IA;)V
    .locals 0

    invoke-direct {p0}, Lcom/navipilot/obf/WideCameraFallback$Track;-><init>()V

    return-void
.end method
