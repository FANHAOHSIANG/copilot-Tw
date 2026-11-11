.class public final Lcom/navipilot/obf/WideCamera;
.super Ljava/lang/Object;
.source "WideCamera.java"


# static fields
.field private static volatile dataStatus:Ljava/lang/String;

.field private static volatile date:Ljava/lang/String;

.field private static volatile displayCamera:Lcom/navipilot/obf/WideHcopRoad$Decision;

.field private static volatile fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

.field private static knownDirections:I

.field private static volatile lastError:Ljava/lang/String;

.field private static volatile loaded:Z

.field private static volatile loading:Z

.field private static metadata:Ljava/lang/String;

.field private static volatile points:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;"
        }
    .end annotation
.end field

.field public static volatile running:Z

.field private static sectionCount:I

.field private static volatile sectionNotices:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;"
        }
    .end annotation
.end field

.field private static final sectionTracker:Lcom/navipilot/obf/WideCameraSection;

.field private static volatile serviceStatus:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 16
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideCamera;->points:Ljava/util/List;

    .line 17
    invoke-static {}, Ljava/util/Collections;->emptyList()Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideCamera;->sectionNotices:Ljava/util/List;

    .line 20
    const-string v0, "\u6b63\u5728\u8f09\u5165\u5b98\u65b9\u8cc7\u6599"

    sput-object v0, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    const-string v0, "\u6309\u300cGPS\u300d\u958b\u59cb\u5b9a\u4f4d"

    sput-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideCamera;->date:Ljava/lang/String;

    const-string v1, "\u7121"

    sput-object v1, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    .line 22
    sput-object v0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    .line 24
    new-instance v0, Lcom/navipilot/obf/WideCameraSection;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraSection;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCamera;->sectionTracker:Lcom/navipilot/obf/WideCameraSection;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static accept(Landroid/location/Location;)V
    .locals 20

    .line 101
    const-string v0, "gps"

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getProvider()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 102
    :cond_0
    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getElapsedRealtimeNanos()J

    move-result-wide v0

    const-wide/32 v2, 0xf4240

    div-long v15, v0, v2

    .line 103
    sget-object v0, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-eqz v0, :cond_1

    iget-wide v0, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v0, v15, v0

    if-gtz v0, :cond_1

    return-void

    .line 104
    :cond_1
    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasBearing()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_2

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasSpeed()Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getSpeed()F

    move-result v0

    const/high16 v2, 0x3fc00000    # 1.5f

    cmpl-float v0, v0, v2

    if-ltz v0, :cond_2

    const/4 v0, 0x1

    goto :goto_0

    :cond_2
    move v0, v1

    .line 105
    :goto_0
    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasBearingAccuracy()Z

    move-result v2

    if-eqz v2, :cond_3

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getBearingAccuracyDegrees()F

    move-result v2

    const/high16 v3, 0x420c0000    # 35.0f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_3

    move/from16 v17, v1

    goto :goto_1

    .line 106
    :cond_3
    move/from16 v17, v0

    :goto_1
    new-instance v4, Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getLatitude()D

    move-result-wide v5

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getLongitude()D

    move-result-wide v7

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasAccuracy()Z

    move-result v0

    if-eqz v0, :cond_4

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getAccuracy()F

    move-result v0

    float-to-double v0, v0

    goto :goto_2

    :cond_4
    const-wide/high16 v0, 0x7ff8000000000000L    # Double.NaN

    :goto_2
    move-wide v9, v0

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getBearing()F

    move-result v0

    float-to-double v11, v0

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasSpeed()Z

    move-result v0

    if-eqz v0, :cond_5

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->getSpeed()F

    move-result v0

    goto :goto_3

    :cond_5
    const/4 v0, 0x0

    :goto_3
    float-to-double v13, v0

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->isMock()Z

    move-result v18

    invoke-virtual/range {p0 .. p0}, Landroid/location/Location;->hasSpeed()Z

    move-result v19

    invoke-direct/range {v4 .. v19}, Lcom/navipilot/obf/WideCameraEngine$Fix;-><init>(DDDDDJZZZ)V

    sput-object v4, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 107
    sget-object v0, Lcom/navipilot/obf/WideCamera;->sectionTracker:Lcom/navipilot/obf/WideCameraSection;

    sget-object v1, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Lcom/navipilot/obf/WideCameraSection;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)V

    .line 108
    sget-object v0, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {v0}, Lcom/navipilot/obf/WideBridge;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V

    .line 109
    return-void
.end method

.method static synthetic access$0(Z)V
    .locals 0

    .line 18
    sput-boolean p0, Lcom/navipilot/obf/WideCamera;->loading:Z

    return-void
.end method

.method static synthetic access$1(Ljava/lang/String;)V
    .locals 0

    .line 22
    sput-object p0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$10()I
    .locals 1

    .line 23
    sget v0, Lcom/navipilot/obf/WideCamera;->sectionCount:I

    return v0
.end method

.method static synthetic access$11()Ljava/util/List;
    .locals 1

    .line 17
    sget-object v0, Lcom/navipilot/obf/WideCamera;->sectionNotices:Ljava/util/List;

    return-object v0
.end method

.method static synthetic access$12()Ljava/lang/String;
    .locals 1

    .line 20
    sget-object v0, Lcom/navipilot/obf/WideCamera;->date:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$13(Ljava/lang/String;)V
    .locals 0

    .line 20
    sput-object p0, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$14(Z)V
    .locals 0

    .line 18
    sput-boolean p0, Lcom/navipilot/obf/WideCamera;->loaded:Z

    return-void
.end method

.method static synthetic access$15(Ljava/lang/String;)V
    .locals 0

    .line 20
    sput-object p0, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$2(I)V
    .locals 0

    .line 23
    sput p0, Lcom/navipilot/obf/WideCamera;->knownDirections:I

    return-void
.end method

.method static synthetic access$3(Ljava/lang/String;)V
    .locals 0

    .line 20
    sput-object p0, Lcom/navipilot/obf/WideCamera;->date:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$4(Ljava/util/List;)V
    .locals 0

    .line 16
    sput-object p0, Lcom/navipilot/obf/WideCamera;->points:Ljava/util/List;

    return-void
.end method

.method static synthetic access$5(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 25
    invoke-static {p0, p1}, Lcom/navipilot/obf/WideCamera;->readAsset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$6()Lcom/navipilot/obf/WideCameraSection;
    .locals 1

    .line 24
    sget-object v0, Lcom/navipilot/obf/WideCamera;->sectionTracker:Lcom/navipilot/obf/WideCameraSection;

    return-object v0
.end method

.method static synthetic access$7(I)V
    .locals 0

    .line 23
    sput p0, Lcom/navipilot/obf/WideCamera;->sectionCount:I

    return-void
.end method

.method static synthetic access$8()Ljava/lang/String;
    .locals 1

    .line 22
    sget-object v0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    return-object v0
.end method

.method static synthetic access$9(Landroid/content/Context;)V
    .locals 0

    .line 73
    invoke-static {p0}, Lcom/navipilot/obf/WideCamera;->loadSectionNotices(Landroid/content/Context;)V

    return-void
.end method

.method static applySectionNotice(Lcom/navipilot/obf/WideCameraFace$Model;Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V
    .locals 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/WideCameraFace$Model;",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;",
            "Lcom/navipilot/obf/WideCameraEngine$Fix;",
            "J)V"
        }
    .end annotation

    .line 128
    invoke-interface {p1}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 129
    :cond_0
    invoke-static {p1, p2, p3, p4}, Lcom/navipilot/obf/WideCameraEngine;->match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object p1

    .line 130
    iget-object p2, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    if-eqz p2, :cond_3

    iget-wide p2, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    const-wide v0, 0x407f400000000000L    # 500.0

    cmpl-double p2, p2, v0

    if-lez p2, :cond_1

    goto :goto_0

    .line 131
    :cond_1
    iget p2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    if-eqz p2, :cond_2

    .line 132
    new-instance p2, Ljava/lang/StringBuilder;

    const-string p3, "\u5340\u9593\u516c\u544a "

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide p3, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    invoke-static {p3, p4}, Ljava/lang/Math;->round(D)J

    move-result-wide p3

    invoke-virtual {p2, p3, p4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " m"

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->secondaryAlert:Ljava/lang/String;

    .line 133
    return-void

    .line 135
    :cond_2
    const/4 p2, 0x5

    iput p2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    .line 136
    const-string p2, "\u5340\u9593\u6e2c\u901f\u516c\u544a\u4f4d\u7f6e"

    iput-object p2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 137
    new-instance p2, Ljava/lang/StringBuilder;

    iget-object p3, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object p3, p3, Lcom/navipilot/obf/WideCameraEngine$Point;->city:Ljava/lang/String;

    invoke-static {p3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p3

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string p3, " \u00b7 "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    iget-object p3, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object p3, p3, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    iput-object p2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    .line 138
    const-string p2, "\u516c\u544a\u4f4d\u7f6e"

    iput-object p2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->badge:Ljava/lang/String;

    .line 139
    iget-wide p1, p1, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    iput-wide p1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    .line 140
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z

    .line 141
    return-void

    .line 130
    :cond_3
    :goto_0
    return-void
.end method

.method public static clearFix()V
    .locals 2

    .line 110
    invoke-static {}, Lcom/navipilot/obf/WideBridge;->clear()V

    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    sget-object v0, Lcom/navipilot/obf/WideCamera;->sectionTracker:Lcom/navipilot/obf/WideCameraSection;

    const-string v1, "\u5b9a\u4f4d\u5df2\u4e2d\u65b7\uff0c\u5340\u9593\u8a08\u6642\u5931\u6548"

    invoke-virtual {v0, v1}, Lcom/navipilot/obf/WideCameraSection;->reset(Ljava/lang/String;)V

    return-void
.end method

.method public static data()Ljava/lang/String;
    .locals 1

    .line 112
    sget-object v0, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    return-object v0
.end method

.method public static error(Ljava/lang/String;)V
    .locals 0

    .line 99
    sput-object p0, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    sput-object p0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    return-void
.end method

.method public static fix()Lcom/navipilot/obf/WideCameraEngine$Fix;
    .locals 1

    .line 111
    sget-object v0, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    return-object v0
.end method

.method public static gps()Ljava/lang/String;
    .locals 8

    .line 186
    sget-object v0, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 187
    if-nez v0, :cond_1

    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v0, :cond_0

    const-string v0, "GPS \u641c\u5c0b\u4e2d"

    goto :goto_0

    :cond_0
    const-string v0, "GPS \u672a\u555f\u52d5"

    :goto_0
    return-object v0

    .line 188
    :cond_1
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    iget-wide v3, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v1, v3

    const-wide/16 v3, 0x0

    invoke-static {v3, v4, v1, v2}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v1

    .line 189
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    invoke-static {v0, v3, v4}, Lcom/navipilot/obf/WideCameraEngine;->validSpeed(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v3

    if-eqz v3, :cond_2

    sget-object v3, Ljava/util/Locale;->TAIWAN:Ljava/util/Locale;

    iget-wide v4, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide v6, 0x400ccccccccccccdL    # 3.6

    mul-double/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v4

    filled-new-array {v4}, [Ljava/lang/Object;

    move-result-object v4

    const-string v5, "%.0f km/h"

    invoke-static {v3, v5, v4}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    :cond_2
    const-string v3, "\u6642\u901f\u672a\u77e5"

    .line 190
    :goto_1
    sget-object v4, Ljava/util/Locale;->TAIWAN:Ljava/util/Locale;

    iget-wide v5, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-static {v5, v6}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v0

    long-to-double v1, v1

    const-wide v5, 0x408f400000000000L    # 1000.0

    div-double/2addr v1, v5

    invoke-static {v1, v2}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v1

    filled-new-array {v0, v1, v3}, [Ljava/lang/Object;

    move-result-object v0

    const-string v1, "GPS \u00b1%.0f m \u00b7 %.1f \u79d2\u524d \u00b7 %s"

    invoke-static {v4, v1, v0}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static hasPermission(Landroid/content/Context;)Z
    .locals 1

    .line 82
    const-string v0, "android.permission.ACCESS_FINE_LOCATION"

    invoke-virtual {p0, v0}, Landroid/content/Context;->checkSelfPermission(Ljava/lang/String;)I

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    return p0

    :cond_0
    const/4 p0, 0x0

    return p0
.end method

.method public static declared-synchronized init(Landroid/content/Context;)V
    .locals 3

    const-class v0, Lcom/navipilot/obf/WideCamera;

    monitor-enter v0

    .line 31
    :try_start_0
    invoke-static {p0}, Lcom/navipilot/obf/WideBridge;->init(Landroid/content/Context;)V

    .line 32
    sget-boolean v1, Lcom/navipilot/obf/WideCamera;->loading:Z

    if-nez v1, :cond_1

    sget-boolean v1, Lcom/navipilot/obf/WideCamera;->loaded:Z

    if-eqz v1, :cond_0

    goto :goto_0

    :cond_0
    const/4 v1, 0x1

    sput-boolean v1, Lcom/navipilot/obf/WideCamera;->loading:Z

    .line 33
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 34
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/navipilot/obf/WideCamera$1;

    invoke-direct {v2, p0}, Lcom/navipilot/obf/WideCamera$1;-><init>(Landroid/content/Context;)V

    .line 52
    const-string p0, "WideCameraData"

    .line 34
    invoke-direct {v1, v2, p0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 52
    invoke-virtual {v1}, Ljava/lang/Thread;->start()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 53
    monitor-exit v0

    return-void

    .line 32
    :cond_1
    :goto_0
    monitor-exit v0

    return-void

    .line 30
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method private static keepCameraDisplay(Lcom/navipilot/obf/WideCameraFace$Model;Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z
    .locals 6

    sget-object v0, Lcom/navipilot/obf/WideCamera;->displayCamera:Lcom/navipilot/obf/WideHcopRoad$Decision;

    if-eqz v0, :cond_2

    sget-boolean v1, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v1, :cond_1

    iget-boolean v1, p1, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-nez v1, :cond_1

    iget-wide v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    sub-long v1, p3, v1

    const-wide/16 v3, 0x0

    cmp-long v5, v1, v3

    if-ltz v5, :cond_1

    const-wide/16 v3, 0x1388

    cmp-long v5, v1, v3

    if-gez v5, :cond_1

    if-eqz p2, :cond_0

    iget-boolean v1, p2, Lcom/navipilot/obf/WideCameraEngine$Fix;->mock:Z

    if-nez v1, :cond_1

    iget-wide v1, p2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long v1, p3, v1

    const-wide/16 v3, 0xbb8

    cmp-long v5, v1, v3

    if-gtz v5, :cond_0

    iget-wide v1, p2, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    const-wide/high16 v3, 0x402e000000000000L    # 15.0

    cmpl-double v5, v1, v3

    if-lez v5, :cond_1

    :cond_0
    const/4 v1, 0x1

    iput v1, p0, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    iget-wide v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iput-wide v2, p0, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-string v0, "\u5b9a\u4f4d\u66f4\u65b0\u4e2d"

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    return v1

    :cond_1
    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideCamera;->displayCamera:Lcom/navipilot/obf/WideHcopRoad$Decision;

    :cond_2
    const/4 v0, 0x0

    return v0
.end method

.method private static loadSectionNotices(Landroid/content/Context;)V
    .locals 2

    .line 75
    :try_start_0
    new-instance v0, Lorg/json/JSONObject;

    const-string v1, "tw_section_notices.json"

    invoke-static {p0, v1}, Lcom/navipilot/obf/WideCamera;->readAsset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 76
    invoke-static {v0}, Lcom/navipilot/obf/WideCamera;->sectionNoticePoints(Lorg/json/JSONObject;)Ljava/util/List;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideCamera;->sectionNotices:Ljava/util/List;

    .line 77
    sget-object p0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {p0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string p0, "\n\u5340\u9593\u516c\u544a\u4f4d\u7f6e\uff1a\n"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, "metadata"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    const/4 v1, 0x2

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->toString(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    .line 78
    goto :goto_0

    :catch_0
    move-exception p0

    .line 79
    sget-object v0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "\n\u5340\u9593\u516c\u544a\u4f4d\u7f6e\u8f09\u5165\u5931\u6557\uff1a"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    sput-object p0, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    .line 81
    :goto_0
    return-void
.end method

.method public static model()Lcom/navipilot/obf/WideCameraFace$Model;
    .locals 14

    .line 144
    invoke-static {}, Lcom/navipilot/obf/WideHcop;->current()Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    new-instance v1, Lcom/navipilot/obf/WideCameraFace$Model;

    invoke-direct {v1}, Lcom/navipilot/obf/WideCameraFace$Model;-><init>()V

    .line 145
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    sget-object v4, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    sget-object v9, Lcom/navipilot/obf/WideCamera;->points:Ljava/util/List;
    move-object v5, v0
    move-object v6, v4
    move-wide v7, v2
    invoke-static/range {v5 .. v9}, Lcom/navipilot/obf/WideCameraTrace;->displayPoints(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;JLjava/util/List;)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    .line 146
    sget-boolean v5, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v5, :cond_0

    invoke-static {v4, v2, v3}, Lcom/navipilot/obf/WideCameraEngine;->validSpeed(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v5

    if-eqz v5, :cond_0

    iget-wide v5, v4, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide v7, 0x400ccccccccccccdL    # 3.6

    mul-double/2addr v5, v7

    goto :goto_0

    :cond_0
    const-wide/high16 v5, 0x7ff8000000000000L    # Double.NaN

    :goto_0
    iput-wide v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->speedKph:D

    .line 147
    iget-boolean v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    const/4 v6, 0x0

    if-eqz v5, :cond_1

    iget v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    if-lez v5, :cond_1

    iget v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    goto :goto_1

    :cond_1
    move v5, v6

    :goto_1
    iput v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->roadLimit:I

    .line 148
    iget-boolean v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v5, :cond_2

    iget-wide v7, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    goto :goto_2

    :cond_2
    const-wide/16 v7, 0x0

    :goto_2
    iput-wide v7, v1, Lcom/navipilot/obf/WideCameraFace$Model;->limitObservedAt:J

    .line 149
    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    invoke-static {}, Lcom/navipilot/obf/WideCamera;->gps()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->footer:Ljava/lang/String;

    invoke-static {}, Lcom/navipilot/obf/WideBridge;->badge()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->badge:Ljava/lang/String;

    const-string v5, "\u524d\u65b9\u6e2c\u901f"

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideHcopRoad$Decision;->roadName()Ljava/lang/String;

    move-result-object v5

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->road:Ljava/lang/String;

    .line 150
    iget-boolean v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    const-wide/high16 v7, 0x3ff0000000000000L    # 1.0

    const/4 v9, 0x1

    if-eqz v5, :cond_4

    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v5, :cond_4

    .line 151
    iput v9, v1, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget v5, v5, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iput v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->limit:I

    iget-wide v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iput-wide v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->distance:D

    const-string v5, "\u524d\u65b9\u6e2c\u901f\u63d0\u9192"

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 152
    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-static {v0}, Lcom/navipilot/obf/WideCameraTrace;->voiceKey(Lcom/navipilot/obf/WideHcopRoad$Decision;)Ljava/lang/String;

    move-result-object v5

    sput-object v0, Lcom/navipilot/obf/WideCamera;->displayCamera:Lcom/navipilot/obf/WideHcopRoad$Decision;

    iget-wide v10, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    const-wide v12, 0x408f400000000000L    # 1000.0

    cmpg-double v10, v10, v12

    if-gtz v10, :cond_3

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->voiceCameraId:Ljava/lang/String;

    .line 153
    :cond_3
    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object v5, v5, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    iput-object v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->road:Ljava/lang/String;

    iget-wide v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    const-wide v10, 0x4097700000000000L    # 1500.0

    div-double/2addr v5, v10

    sub-double/2addr v7, v5

    iput-wide v7, v1, Lcom/navipilot/obf/WideCameraFace$Model;->progress:D

    iget-object v5, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;
    const-string v6, "candidate"
    invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v5
    iput-boolean v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->previewOnly:Z
    xor-int/lit8 v5, v5, 0x1
    iput-boolean v5, v1, Lcom/navipilot/obf/WideCameraFace$Model;->roadMatched:Z

    .line 154
    goto/16 :goto_5

    .line 155
    :cond_4
    invoke-static {v1, v0, v4, v2, v3}, Lcom/navipilot/obf/WideCamera;->keepCameraDisplay(Lcom/navipilot/obf/WideCameraFace$Model;Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v5

    if-nez v5, :cond_a

    iput v6, v1, Lcom/navipilot/obf/WideCameraFace$Model;->type:I

    .line 168
    sget-boolean v5, Lcom/navipilot/obf/WideCamera;->loaded:Z

    if-nez v5, :cond_6

    .line 169
    const-string v0, "\u8f09\u5165\u6e2c\u901f\u8cc7\u6599"

    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 170
    const-string v0, "\u7121"

    sget-object v5, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    invoke-virtual {v0, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    sget-object v0, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    goto :goto_3

    :cond_5
    sget-object v0, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    :goto_3
    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    .line 171
    goto :goto_5

    :cond_6
    sget-boolean v5, Lcom/navipilot/obf/WideCamera;->running:Z

    if-nez v5, :cond_7

    .line 172
    const-string v0, "GPS \u672a\u555f\u52d5"

    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 173
    sget-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    .line 174
    goto :goto_5

    :cond_7
    if-nez v4, :cond_8

    .line 175
    const-string v0, "\u7b49\u5f85 GPS \u5b9a\u4f4d"

    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 176
    sget-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->state:Ljava/lang/String;

    .line 177
    goto :goto_5

    .line 178
    :cond_8
    iget-boolean v0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v0, :cond_9

    const-string v0, "\u540c\u8def\u6bb5\u66ab\u7121\u6e2c\u901f\u9ede"

    goto :goto_4

    :cond_9
    const-string v0, "\u7b49\u5f85\u9053\u8def\u78ba\u8a8d"

    :goto_4
    iput-object v0, v1, Lcom/navipilot/obf/WideCameraFace$Model;->title:Ljava/lang/String;

    .line 182
    :cond_a
    :goto_5
    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->loaded:Z

    if-eqz v0, :cond_b

    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->running:Z

    if-eqz v0, :cond_b

    sget-object v0, Lcom/navipilot/obf/WideCamera;->sectionNotices:Ljava/util/List;

    invoke-static {v1, v0, v4, v2, v3}, Lcom/navipilot/obf/WideCamera;->applySectionNotice(Lcom/navipilot/obf/WideCameraFace$Model;Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V

    .line 183
    :cond_b
    return-object v1
.end method

.method public static preview()Ljava/lang/String;
    .locals 11

    .line 193
    invoke-static {}, Lcom/navipilot/obf/WideCamera;->result()Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 195
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "previewOnly"

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "sendEnabled"

    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "roadMatched"

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "reason"

    iget-object v5, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->state:Ljava/lang/String;

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "distanceType"

    const-string v5, "straight_line_candidate"

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 196
    sget-object v3, Lcom/navipilot/obf/WideCamera;->sectionTracker:Lcom/navipilot/obf/WideCameraSection;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v5

    invoke-virtual {v3, v1, v5, v6}, Lcom/navipilot/obf/WideCameraSection;->status(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraSection$Status;

    move-result-object v3

    .line 197
    const-string v5, "sectionState"

    iget-object v6, v3, Lcom/navipilot/obf/WideCameraSection$Status;->reason:Ljava/lang/String;

    invoke-virtual {v2, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 198
    iget-object v5, v3, Lcom/navipilot/obf/WideCameraSection$Status;->section:Lcom/navipilot/obf/WideCameraSection$Section;

    if-eqz v5, :cond_2

    new-instance v5, Lorg/json/JSONObject;

    invoke-direct {v5}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "id"

    iget-object v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->section:Lcom/navipilot/obf/WideCameraSection$Section;

    iget-object v7, v7, Lcom/navipilot/obf/WideCameraSection$Section;->id:Ljava/lang/String;

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "activeEstimate"

    iget-boolean v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->active:Z

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v6, "finishedEstimate"

    iget-boolean v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->finished:Z

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v6, "limit"

    iget-object v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->section:Lcom/navipilot/obf/WideCameraSection$Section;

    iget v7, v7, Lcom/navipilot/obf/WideCameraSection$Section;->limit:I

    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v6, "distanceM"

    iget-wide v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->distance:D

    invoke-static {v7, v8}, Ljava/lang/Math;->round(D)J

    move-result-wide v7

    invoke-virtual {v5, v6, v7, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    const-string v6, "remainingRequiredSeconds"

    iget-wide v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->seconds:D

    const-wide/16 v9, 0x0

    cmpl-double v7, v7, v9

    if-ltz v7, :cond_0

    iget-wide v7, v3, Lcom/navipilot/obf/WideCameraSection$Status;->seconds:D

    invoke-static {v7, v8}, Ljava/lang/Math;->round(D)J

    move-result-wide v7

    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    goto :goto_0

    :cond_0
    sget-object v7, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;

    :goto_0
    invoke-virtual {v5, v6, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v6, "distanceKind"

    iget-boolean v3, v3, Lcom/navipilot/obf/WideCameraSection$Status;->active:Z

    if-eqz v3, :cond_1

    const-string v3, "official_length_minus_gps_travel"

    goto :goto_1

    :cond_1
    const-string v3, "straight_to_start"

    :goto_1
    invoke-virtual {v5, v6, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "sectionPreview"

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 199
    :cond_2
    iget-object v3, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    if-eqz v3, :cond_5

    const-string v3, "cameraId"

    iget-object v5, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v5, v5, Lcom/navipilot/obf/WideCameraEngine$Point;->id:Ljava/lang/String;

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "source"

    const-string v5, "NPA Taiwan"

    invoke-virtual {v2, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "nSdiType"

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v3, "nSdiDist"

    iget-wide v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    invoke-static {v4, v5}, Ljava/lang/Math;->round(D)J

    move-result-wide v4

    invoke-virtual {v2, v3, v4, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    const-string v3, "nSdiSpeedLimit"

    iget-boolean v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->proximityOnly:Z

    if-nez v4, :cond_4

    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-boolean v4, v4, Lcom/navipilot/obf/WideCameraEngine$Point;->limitUncertain:Z

    if-eqz v4, :cond_3

    goto :goto_2

    :cond_3
    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget v4, v4, Lcom/navipilot/obf/WideCameraEngine$Point;->limit:I

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    goto :goto_3

    :cond_4
    :goto_2
    sget-object v4, Lorg/json/JSONObject;->NULL:Ljava/lang/Object;

    :goto_3
    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v3, "directionKnown"

    iget-boolean v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->directionKnown:Z

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "proximityOnly"

    iget-boolean v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->proximityOnly:Z

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "road"

    iget-object v0, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v0, v0, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 200
    :cond_5
    if-eqz v1, :cond_6

    const-string v0, "gpsAgeMs"

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v3, v5

    const-wide/16 v5, 0x0

    invoke-static {v5, v6, v3, v4}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v3

    invoke-virtual {v2, v0, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    .line 201
    :cond_6
    const/4 v0, 0x2

    invoke-virtual {v2, v0}, Lorg/json/JSONObject;->toString(I)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 202
    :catch_0
    move-exception v0

    const-string v0, "\u9810\u89bd\u7522\u751f\u5931\u6557"

    return-object v0
.end method

.method private static readAsset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 3
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 26
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object p0

    new-instance p1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {p1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 27
    const/16 v0, 0x2000

    :try_start_0
    new-array v0, v0, [B

    :goto_0
    invoke-virtual {p0, v0}, Ljava/io/InputStream;->read([B)I

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const/4 v2, -0x1

    if-ne v1, v2, :cond_0

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    .line 28
    new-instance p0, Ljava/lang/String;

    invoke-virtual {p1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p1

    const-string v0, "UTF-8"

    invoke-direct {p0, p1, v0}, Ljava/lang/String;-><init>([BLjava/lang/String;)V

    return-object p0

    .line 27
    :cond_0
    const/4 v2, 0x0

    :try_start_1
    invoke-virtual {p1, v0, v2, v1}, Ljava/io/ByteArrayOutputStream;->write([BII)V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    invoke-virtual {p0}, Ljava/io/InputStream;->close()V

    throw p1
.end method

.method public static report()Ljava/lang/String;
    .locals 9

    .line 205
    invoke-static {}, Lcom/navipilot/obf/WideCamera;->result()Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 206
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Copilot tw wide.34\n"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n\u53ef\u8fa8\u8b58\u65b9\u5411\uff1a"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget v3, Lcom/navipilot/obf/WideCamera;->knownDirections:I

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " \u7b46\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    sget-object v3, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-static {}, Lcom/navipilot/obf/WideCamera;->gps()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->state:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 207
    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    const-string v5, ""

    if-nez v4, :cond_0

    move-object v0, v5

    goto :goto_1

    :cond_0
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v3, v3, Lcom/navipilot/obf/WideCameraEngine$Point;->city:Ljava/lang/String;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v4, v4, Lcom/navipilot/obf/WideCameraEngine$Point;->road:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "\n\u4f86\u6e90\u65b9\u5411\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-object v4, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    iget-object v4, v4, Lcom/navipilot/obf/WideCameraEngine$Point;->direction:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "\n\u76f4\u7dda\u8ddd\u96e2\uff1a"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-wide v6, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->distance:D

    invoke-static {v6, v7}, Ljava/lang/Math;->round(D)J

    move-result-wide v6

    invoke-virtual {v3, v6, v7}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, " m"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget-boolean v6, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->proximityOnly:Z

    if-eqz v6, :cond_1

    const-string v0, "\uff1b\u65b9\u5411\u8207\u9053\u8def\u672a\u78ba\u8a8d"

    goto :goto_0

    :cond_1
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "\uff1b\u5074\u5411\u504f\u79fb\uff1a\u7d04 "

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-wide v7, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->lateral:D

    invoke-static {v7, v8}, Ljava/lang/Math;->round(D)J

    move-result-wide v7

    invoke-virtual {v6, v7, v8}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_0
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_1
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 208
    if-nez v1, :cond_2

    goto :goto_2

    :cond_2
    sget-object v2, Ljava/util/Locale;->US:Ljava/util/Locale;

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    invoke-static {v3, v4}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v3

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    invoke-static {v4, v5}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v4

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v5, v6}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v1

    filled-new-array {v3, v4, v1}, [Ljava/lang/Object;

    move-result-object v1

    const-string v3, "\nGPS: %.6f, %.6f; heading=%.1f"

    invoke-static {v2, v3, v1}, Ljava/lang/String;->format(Ljava/util/Locale;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    :goto_2
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 209
    const-string v1, "\n\n\u4ee5\u4e0b\u662f\u5bec\u9b06\u5019\u9078\u7684\u986f\u793a\u8a3a\u65b7\uff0c\u4e0d\u4ee3\u8868\u5df2\u4e32\u63a5\u3002\u5be6\u969b\u50b3\u9001\u63a1 WideBridge \u540c\u8def\u6bb5\u914d\u5c0d\uff0c\u8acb\u770b\u4e32\u63a5\u72c0\u614b\u8207 speed_wire \u7d00\u9304\u3002\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/navipilot/obf/WideCamera;->preview()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 210
    const-string v1, "\n\n\u8cc7\u6599\u5feb\u7167\uff1a\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideCamera;->metadata:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u6700\u8fd1\u932f\u8aa4\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideCamera;->lastError:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 206
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static result()Lcom/navipilot/obf/WideCameraEngine$Result;
    .locals 8

    .line 115
    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->loaded:Z

    if-nez v0, :cond_0

    new-instance v1, Lcom/navipilot/obf/WideCameraEngine$Result;

    const-wide/16 v5, 0x0

    sget-object v7, Lcom/navipilot/obf/WideCamera;->dataStatus:Ljava/lang/String;

    const/4 v2, 0x0

    const-wide/16 v3, 0x0

    invoke-direct/range {v1 .. v7}, Lcom/navipilot/obf/WideCameraEngine$Result;-><init>(Lcom/navipilot/obf/WideCameraEngine$Point;DDLjava/lang/String;)V

    return-object v1

    .line 116
    :cond_0
    sget-boolean v0, Lcom/navipilot/obf/WideCamera;->running:Z

    if-nez v0, :cond_1

    new-instance v1, Lcom/navipilot/obf/WideCameraEngine$Result;

    const-wide/16 v5, 0x0

    sget-object v7, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    const/4 v2, 0x0

    const-wide/16 v3, 0x0

    invoke-direct/range {v1 .. v7}, Lcom/navipilot/obf/WideCameraEngine$Result;-><init>(Lcom/navipilot/obf/WideCameraEngine$Point;DDLjava/lang/String;)V

    return-object v1

    .line 117
    :cond_1
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v0

    .line 118
    sget-object v2, Lcom/navipilot/obf/WideCamera;->points:Ljava/util/List;

    sget-object v3, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {v2, v3, v0, v1}, Lcom/navipilot/obf/WideCameraEngine;->match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object v2

    .line 119
    iget-object v3, v2, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    if-nez v3, :cond_3

    const-string v3, "\u4f4e\u901f\uff0f\u505c\u8eca\uff0c\u7b49\u5f85\u884c\u9032\u65b9\u5411"

    iget-object v4, v2, Lcom/navipilot/obf/WideCameraEngine$Result;->state:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_2

    const-string v3, "\u7b49\u5f85\u53ef\u9760\u884c\u9032\u65b9\u5411"

    iget-object v4, v2, Lcom/navipilot/obf/WideCameraEngine$Result;->state:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    .line 120
    :cond_2
    sget-object v3, Lcom/navipilot/obf/WideCamera;->points:Ljava/util/List;

    sget-object v4, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    invoke-static {v3, v4, v0, v1}, Lcom/navipilot/obf/WideCameraEngine;->nearby(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Result;

    move-result-object v0

    .line 121
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraEngine$Result;->point:Lcom/navipilot/obf/WideCameraEngine$Point;

    if-eqz v1, :cond_3

    return-object v0

    .line 123
    :cond_3
    return-object v2
.end method

.method static sectionNoticePoints(Lorg/json/JSONObject;)Ljava/util/List;
    .locals 19
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lorg/json/JSONObject;",
            ")",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;"
        }
    .end annotation

    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 56
    move-object/from16 v0, p0

    const-string v1, "points"

    invoke-virtual {v0, v1}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v1

    .line 57
    const-string v2, "metadata"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v0

    .line 58
    const-string v2, "schema"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_2

    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v2

    const-string v3, "locations"

    invoke-virtual {v0, v3}, Lorg/json/JSONObject;->getInt(Ljava/lang/String;)I

    move-result v0

    if-ne v2, v0, :cond_2

    .line 61
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 62
    const/4 v2, 0x0

    move v3, v2

    :goto_0
    invoke-virtual {v1}, Lorg/json/JSONArray;->length()I

    move-result v4

    if-lt v3, v4, :cond_0

    .line 70
    invoke-static {v0}, Ljava/util/Collections;->unmodifiableList(Ljava/util/List;)Ljava/util/List;

    move-result-object v0

    return-object v0

    .line 63
    :cond_0
    invoke-virtual {v1, v3}, Lorg/json/JSONArray;->getJSONObject(I)Lorg/json/JSONObject;

    move-result-object v4

    .line 64
    const-string v5, "bearings"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v5

    .line 65
    invoke-virtual {v5}, Lorg/json/JSONArray;->length()I

    move-result v6

    new-array v7, v6, [D

    .line 66
    move v8, v2

    :goto_1
    if-lt v8, v6, :cond_1

    .line 67
    move-object/from16 v17, v7

    new-instance v7, Lcom/navipilot/obf/WideCameraEngine$Point;

    const-string v5, "id"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    const-string v5, "road"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    .line 68
    const-string v5, "city"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    const-string v5, "lat"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v12

    const-string v5, "lon"

    invoke-virtual {v4, v5}, Lorg/json/JSONObject;->getDouble(Ljava/lang/String;)D

    move-result-wide v14

    const/16 v16, 0x0

    const/16 v18, 0x1

    const-string v11, ""

    invoke-direct/range {v7 .. v18}, Lcom/navipilot/obf/WideCameraEngine$Point;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;DDI[DZ)V

    .line 67
    invoke-interface {v0, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 62
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 66
    :cond_1
    move-object/from16 v17, v7

    invoke-virtual {v5, v8}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v9

    aput-wide v9, v17, v8

    add-int/lit8 v8, v8, 0x1

    goto :goto_1

    .line 59
    :cond_2
    new-instance v0, Lorg/json/JSONException;

    const-string v1, "\u5340\u9593\u516c\u544a\u8cc7\u6599\u7248\u672c\u6216\u7b46\u6578\u4e0d\u7b26"

    invoke-direct {v0, v1}, Lorg/json/JSONException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public static service()Ljava/lang/String;
    .locals 1

    .line 113
    sget-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    return-object v0
.end method

.method public static start(Landroid/app/Activity;)Z
    .locals 6

    .line 84
    invoke-static {p0}, Lcom/navipilot/obf/WideCamera;->init(Landroid/content/Context;)V

    .line 85
    invoke-static {p0}, Lcom/navipilot/obf/WideCamera;->hasPermission(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    const/16 v2, 0x21

    const/4 v3, 0x1

    const-string v4, "android.permission.POST_NOTIFICATIONS"

    if-nez v0, :cond_1

    .line 86
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    const-string v5, "android.permission.ACCESS_COARSE_LOCATION"

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    const-string v5, "android.permission.ACCESS_FINE_LOCATION"

    invoke-virtual {v0, v5}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 87
    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v5, v2, :cond_0

    invoke-virtual {p0, v4}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_0

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 88
    :cond_0
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    new-array v2, v2, [Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Ljava/lang/String;

    const/16 v2, 0x2078

    invoke-virtual {p0, v0, v2}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    .line 89
    const-string v0, "\u8acb\u5141\u8a31\u7cbe\u78ba\u5b9a\u4f4d\uff0c\u518d\u6309 GPS"

    sput-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    const-string v0, "\u8acb\u9078\u300c\u7cbe\u78ba\u4f4d\u7f6e\u300d\uff0c\u6388\u6b0a\u5f8c\u518d\u6309 GPS"

    invoke-static {p0, v0, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return v1

    .line 91
    :cond_1
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    if-lt v0, v2, :cond_2

    invoke-virtual {p0, v4}, Landroid/app/Activity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v0

    if-eqz v0, :cond_2

    .line 92
    filled-new-array {v4}, [Ljava/lang/String;

    move-result-object v0

    const/16 v2, 0x2079

    invoke-virtual {p0, v0, v2}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    .line 94
    :cond_2
    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-class v2, Lcom/navipilot/obf/WideCameraService;

    invoke-direct {v0, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    const-string v0, "\u6b63\u5728\u555f\u52d5 GPS"

    sput-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    return v3

    .line 95
    :catch_0
    move-exception v0

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v4, "\u7121\u6cd5\u555f\u52d5 GPS\uff1a"

    invoke-direct {v2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/navipilot/obf/WideCamera;->error(Ljava/lang/String;)V

    sget-object v0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    invoke-static {p0, v0, v3}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return v1
.end method

.method public static status(Ljava/lang/String;)V
    .locals 0

    .line 98
    sput-object p0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    return-void
.end method

.method public static stop(Landroid/content/Context;)V
    .locals 2

    .line 97
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/navipilot/obf/WideCameraService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, v0}, Landroid/content/Context;->stopService(Landroid/content/Intent;)Z

    const/4 p0, 0x0

    sput-boolean p0, Lcom/navipilot/obf/WideCamera;->running:Z

    invoke-static {}, Lcom/navipilot/obf/WideCamera;->clearFix()V

    const-string p0, "\u5b9a\u4f4d\u5df2\u505c\u6b62"

    sput-object p0, Lcom/navipilot/obf/WideCamera;->serviceStatus:Ljava/lang/String;

    return-void
.end method
