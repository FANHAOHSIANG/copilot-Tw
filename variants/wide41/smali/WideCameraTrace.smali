.class final Lcom/navipilot/obf/WideCameraTrace;
.super Ljava/lang/Object;
.source "WideCameraTrace.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideCameraTrace$Candidate;,
        Lcom/navipilot/obf/WideCameraTrace$Frame;
    }
.end annotation


# static fields
.field private static final MAX_CANDIDATES:I = 0xc

.field private static final MIN_MARGIN:D = 2.5

.field private static final motion:Lcom/navipilot/obf/WideAlertMotion;

.field private static volatile published:Lcom/navipilot/obf/WideCameraTrace$Frame;

.field private static final shared:Lcom/navipilot/obf/WideCameraTrace;


# instance fields
.field private last:Lcom/navipilot/obf/WideCameraEngine$Fix;

.field private previous:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraTrace$Candidate;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 12
    new-instance v0, Lcom/navipilot/obf/WideCameraTrace;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraTrace;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraTrace;->shared:Lcom/navipilot/obf/WideCameraTrace;

    .line 14
    new-instance v0, Lcom/navipilot/obf/WideAlertMotion;

    invoke-direct {v0}, Lcom/navipilot/obf/WideAlertMotion;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraTrace;->motion:Lcom/navipilot/obf/WideAlertMotion;

    return-void
.end method

.method constructor <init>()V
    .locals 1

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 22
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    .line 9
    return-void
.end method

.method private static advance(Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Data;D)D
    .locals 8

    .line 182
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v1, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v1, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-wide/high16 v1, 0x7ff8000000000000L    # Double.NaN

    if-eqz v0, :cond_1

    .line 183
    iget p2, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    iget p3, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-ne p2, p3, :cond_0

    invoke-virtual {p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide p1

    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide p3

    sub-double v1, p1, p3

    :cond_0
    return-wide v1

    .line 185
    :cond_1
    nop

    .line 186
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v3, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide v5

    sub-double/2addr v3, v5

    .line 187
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 188
    const/4 v5, 0x0

    :goto_0
    const/16 v6, 0x20

    if-ge v5, v6, :cond_6

    cmpg-double v6, v3, p3

    if-lez v6, :cond_2

    goto :goto_1

    .line 189
    :cond_2
    iget-object v6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v6, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-interface {v0, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 190
    invoke-static {p2, p0, v0}, Lcom/navipilot/obf/WideCameraTrace;->next(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Ljava/util/Set;)Lcom/navipilot/obf/WideCameraTrace$Candidate;

    move-result-object p0

    .line 191
    if-nez p0, :cond_3

    return-wide v1

    .line 192
    :cond_3
    iget-object v6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v6, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v7, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v7, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_5

    iget p0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    iget p2, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-ne p0, p2, :cond_4

    invoke-virtual {p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide p0

    add-double v1, v3, p0

    :cond_4
    return-wide v1

    .line 193
    :cond_5
    iget-object v6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v6, v6, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    add-double/2addr v3, v6

    .line 188
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 195
    :cond_6
    :goto_1
    return-wide v1
.end method

.method private static ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraEngine$Fix;)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 12

    .line 258
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u540c\u5411\u9053\u8def\u5019\u9078 \u00b7 \u4e0d\u5340\u5206\u672c\u8eca\u9ad8\u67b6\uff0f\u5e73\u9762 \u00b7 \u50c5\u63d0\u9192"

    iget-wide v2, p2, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-direct {v0, v1, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    .line 259
    nop

    .line 260
    invoke-virtual {p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide v1

    neg-double v1, v1

    .line 261
    new-instance v6, Ljava/util/HashSet;

    invoke-direct {v6}, Ljava/util/HashSet;-><init>()V

    .line 262
    const/4 v7, 0x0

    move-wide v3, v1

    move v8, v7

    move-object v1, p1

    :goto_0
    const/16 v2, 0x80

    if-ge v8, v2, :cond_4

    const-wide v9, 0x4097700000000000L    # 1500.0

    cmpg-double v2, v3, v9

    if-lez v2, :cond_0

    goto :goto_3

    .line 263
    :cond_0
    iget-object v2, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-interface {v6, v2}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 264
    iget-object v2, p0, Lcom/navipilot/obf/WideHcopRoad$Data;->cameras:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_1
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-nez v2, :cond_3

    .line 265
    sget-object v10, Lcom/navipilot/obf/WideHighwayAlertData;->CAMERAS:[Lcom/navipilot/obf/WideHcopRoad$Camera;

    array-length v11, v10

    move v9, v7

    :goto_2
    if-lt v9, v11, :cond_2

    .line 266
    iget-object v2, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v9, v2, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    add-double/2addr v3, v9

    .line 267
    invoke-static {p0, v1, v6}, Lcom/navipilot/obf/WideCameraTrace;->next(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Ljava/util/Set;)Lcom/navipilot/obf/WideCameraTrace$Candidate;

    move-result-object v1

    .line 268
    if-nez v1, :cond_1

    goto :goto_3

    .line 269
    :cond_1
    nop

    .line 262
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 265
    :cond_2
    aget-object v2, v10, v9

    move-object v5, p2

    invoke-static/range {v0 .. v5}, Lcom/navipilot/obf/WideCameraTrace;->consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;DLcom/navipilot/obf/WideCameraEngine$Fix;)V

    add-int/lit8 v9, v9, 0x1

    goto :goto_2

    .line 264
    :cond_3
    move-object v5, p2

    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p2

    move-object v2, p2

    check-cast v2, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-static/range {v0 .. v5}, Lcom/navipilot/obf/WideCameraTrace;->consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;DLcom/navipilot/obf/WideCameraEngine$Fix;)V

    move-object p2, v5

    goto :goto_1

    .line 271
    :cond_4
    :goto_3
    iget-object p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iput-object p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    iput p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    .line 272
    iget-object p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide p0, p0, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    iput-wide p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->offset:D

    const/4 p0, 0x1

    iput-boolean p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    .line 273
    return-object v0
.end method

.method static clear()V
    .locals 1

    .line 53
    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 54
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->shared:Lcom/navipilot/obf/WideCameraTrace;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 55
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideAlertMotion;->clear()V

    .line 56
    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->clear()V

    .line 57
    return-void
.end method

.method private static consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;DLcom/navipilot/obf/WideCameraEngine$Fix;)V
    .locals 10

    .line 222
    iget-object v0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v1, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 223
    :cond_0
    nop

    .line 224
    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    :goto_0
    if-lt v3, v1, :cond_7

    .line 225
    if-nez v4, :cond_1

    return-void

    .line 226
    :cond_1
    iget-object v0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-wide v4, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-wide v6, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    const-wide/16 v8, 0x0

    invoke-static/range {v3 .. v9}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v0

    .line 227
    iget-wide v3, v0, Lcom/navipilot/obf/WideRoad$Projection;->heading:D

    iget v1, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-gez v1, :cond_2

    const/16 v2, 0xb4

    :cond_2
    int-to-double v1, v2

    add-double/2addr v3, v1

    const-wide v1, 0x4076800000000000L    # 360.0

    rem-double/2addr v3, v1

    .line 228
    iget-wide v1, p5, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v1, v2, v3, v4}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v1

    const-wide v3, 0x4056800000000000L    # 90.0

    cmpl-double p5, v1, v3

    if-lez p5, :cond_3

    return-void

    .line 229
    :cond_3
    iget p5, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-lez p5, :cond_4

    iget-wide v1, v0, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    goto :goto_1

    :cond_4
    iget-wide v1, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    iget-wide v3, v0, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    sub-double/2addr v1, v3

    .line 230
    :goto_1
    add-double/2addr p3, v1

    .line 231
    iget-boolean p5, v0, Lcom/navipilot/obf/WideRoad$Projection;->ambiguous:Z

    if-nez p5, :cond_6

    const-wide/high16 v0, 0x4034000000000000L    # 20.0

    cmpl-double p5, p3, v0

    if-lez p5, :cond_6

    const-wide v0, 0x4097700000000000L    # 1500.0

    cmpg-double p5, p3, v0

    if-gtz p5, :cond_6

    .line 232
    iget-object p5, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz p5, :cond_5

    iget-wide v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    cmpg-double p5, p3, v0

    if-gez p5, :cond_6

    .line 233
    :cond_5
    new-instance p5, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-direct {p5}, Lcom/navipilot/obf/WideHcopRoad$Camera;-><init>()V

    .line 234
    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iput-object v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    iput-object v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    iget v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iput v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iget-wide v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iput-wide v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-wide v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    iput-wide v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    iput-object v0, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    .line 235
    iget-object p1, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object p1, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->grade:Ljava/lang/String;

    invoke-static {p1}, Lcom/navipilot/obf/WideCameraTrace;->level(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v1, " \u00b7 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object p2, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    iput-object p2, p5, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    .line 236
    iput-object p5, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iput-wide p3, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iput-object p1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    .line 238
    :cond_6
    return-void

    .line 224
    :cond_7
    aget v5, v0, v3

    iget v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-ne v5, v6, :cond_8

    const/4 v5, 0x1

    goto :goto_2

    :cond_8
    move v5, v2

    :goto_2
    or-int/2addr v4, v5

    add-int/lit8 v3, v3, 0x1

    goto/16 :goto_0
.end method

.method private continueFromHistory(Lcom/navipilot/obf/WideCameraTrace$Candidate;DDLcom/navipilot/obf/WideHcopRoad$Data;)V
    .locals 13

    .line 165
    move-wide/from16 v0, p4

    iget-wide v2, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 166
    iget-object v4, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_0

    return-void

    .line 167
    :cond_0
    const-wide/high16 v4, 0x4014000000000000L    # 5.0

    add-double/2addr v4, v2

    iput-wide v4, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 168
    iget-object v4, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_1
    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_2

    .line 179
    return-void

    .line 168
    :cond_2
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 169
    add-double v6, p2, v0

    move-object/from16 v8, p6

    invoke-static {v5, p1, v8, v6, v7}, Lcom/navipilot/obf/WideCameraTrace;->advance(Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Data;D)D

    move-result-wide v9

    .line 170
    invoke-static {v9, v10}, Ljava/lang/Double;->isFinite(D)Z

    move-result v11

    if-eqz v11, :cond_1

    neg-double v11, v0

    cmpg-double v11, v9, v11

    if-ltz v11, :cond_1

    cmpl-double v6, v9, v6

    if-lez v6, :cond_3

    goto :goto_0

    .line 171
    :cond_3
    sub-double/2addr v9, p2

    div-double/2addr v9, v0

    .line 172
    iget-wide v6, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    const-wide/high16 v11, 0x3fe8000000000000L    # 0.75

    mul-double/2addr v6, v11

    add-double/2addr v6, v2

    mul-double/2addr v9, v9

    add-double/2addr v6, v9

    .line 173
    iget-wide v9, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpg-double v9, v6, v9

    if-gez v9, :cond_1

    .line 174
    iput-wide v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 175
    iget v6, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    add-int/lit8 v6, v6, 0x1

    const/16 v7, 0xa

    invoke-static {v7, v6}, Ljava/lang/Math;->min(II)I

    move-result v6

    iput v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    .line 176
    iget-wide v5, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    iput-wide v5, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    goto :goto_0
.end method

.method private static copy(Lcom/navipilot/obf/WideHcopRoad$Decision;)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 4

    .line 89
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    iget-object v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    iget-wide v2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    invoke-direct {v0, v1, v2, v3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    .line 90
    iget-object v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    iput v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    iget v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    iput v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    .line 91
    iget-wide v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iput-wide v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iget-wide v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->offset:D

    iput-wide v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->offset:D

    iget-object v1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    iput-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    iget-boolean p0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    iput-boolean p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    return-object v0
.end method

.method static display(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 10

    .line 62
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 63
    invoke-static {p1, p2, p3}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v1

    if-eqz v1, :cond_9

    iget-boolean v1, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speedValid:Z

    if-eqz v1, :cond_0

    iget-wide v1, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 v3, 0x3ff8000000000000L    # 1.5

    cmpg-double v1, v1, v3

    if-gez v1, :cond_0

    goto/16 :goto_2

    .line 65
    :cond_0
    nop

    .line 66
    if-eqz v0, :cond_2

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    if-eqz v1, :cond_2

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    iget-boolean v1, v1, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-nez v1, :cond_2

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-eqz v1, :cond_2

    .line 67
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    if-eqz v1, :cond_2

    iget-wide v1, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v3, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    cmp-long v1, v1, v3

    if-ltz v1, :cond_2

    iget-wide v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    sub-long v1, p2, v1

    const-wide/16 v3, 0xbb8

    cmp-long v1, v1, v3

    if-gtz v1, :cond_2

    .line 68
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v6, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v8, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    invoke-static/range {v2 .. v9}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v1

    iget-object v3, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v3, v3, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 v5, 0x4008000000000000L    # 3.0

    mul-double/2addr v3, v5

    iget-wide v5, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    add-double/2addr v3, v5

    const-wide/high16 v5, 0x403e000000000000L    # 30.0

    invoke-static {v5, v6, v3, v4}, Ljava/lang/Math;->max(DD)D

    move-result-wide v3

    cmpg-double v1, v1, v3

    if-gtz v1, :cond_2

    .line 69
    iget-boolean v1, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->headingValid:Z

    if-eqz v1, :cond_1

    iget-wide v1, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    iget-object v3, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v3, v3, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v1, v2, v3, v4}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v1

    const-wide v3, 0x4041800000000000L    # 35.0

    cmpg-double v1, v1, v3

    if-gtz v1, :cond_2

    .line 70
    :cond_1
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    .line 72
    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-nez v2, :cond_3

    if-eqz p0, :cond_3

    iget-boolean v2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v2, :cond_3

    iget-object v2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-nez v2, :cond_2

    goto :goto_0

    .line 74
    :cond_2
    move-object v1, p0

    :cond_3
    :goto_0
    if-nez v1, :cond_4

    new-instance p0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string p1, "\u7b49\u5f85\u5b9a\u4f4d\u8ecc\u8de1"

    invoke-direct {p0, p1, p2, p3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    return-object p0

    .line 75
    :cond_4
    invoke-static {v1}, Lcom/navipilot/obf/WideCameraTrace;->copy(Lcom/navipilot/obf/WideHcopRoad$Decision;)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object p2

    .line 76
    const/4 p3, 0x0

    if-nez v0, :cond_5

    move-object v2, p3

    goto :goto_1

    :cond_5
    iget-object v2, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    :goto_1
    if-ne v1, v2, :cond_6

    iget-wide v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    iget-wide v3, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v1, v1, v3

    if-gez v1, :cond_6

    iget-object v1, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v1, :cond_6

    .line 77
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-object v0, v0, Lcom/navipilot/obf/WideCameraTrace$Frame;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v4, v0, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v6, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v8, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    invoke-static/range {v2 .. v9}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v0

    .line 78
    iget-wide v2, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    sub-double/2addr v2, v0

    iput-wide v2, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    .line 79
    iget-wide v0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    const-wide/high16 v2, 0x4034000000000000L    # 20.0

    cmpg-double v0, v0, v2

    if-gtz v0, :cond_6

    iput-object p3, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    const-string v0, "\u5df2\u63a5\u8fd1\u6216\u901a\u904e\u6e2c\u901f\u9ede"

    iput-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    .line 81
    :cond_6
    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v0, :cond_7

    iget-boolean v0, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->headingValid:Z

    if-eqz v0, :cond_7

    iget-wide v0, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    .line 82
    iget-wide v2, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v4, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-object p1, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-wide v6, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-object p1, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-wide v8, p1, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    invoke-static/range {v2 .. v9}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v2

    .line 81
    invoke-static {v0, v1, v2, v3}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v0

    .line 82
    const-wide v2, 0x4056800000000000L    # 90.0

    cmpl-double p1, v0, v2

    if-lez p1, :cond_7

    .line 83
    iput-object p3, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    const-string p1, "\u6e2c\u901f\u9ede\u4f4d\u65bc\u884c\u9032\u65b9\u5411\u5f8c\u65b9\uff0c\u4e0d\u63d0\u9192"

    iput-object p1, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    .line 85
    :cond_7
    if-eqz p0, :cond_8

    iget-boolean p1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz p1, :cond_8

    iget p0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    iput p0, p2, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    .line 86
    :cond_8
    return-object p2

    .line 64
    :cond_9
    :goto_2
    new-instance p0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string p1, "\u5b9a\u4f4d\u7121\u6548\u6216\u505c\u8eca\uff0c\u66ab\u505c\u524d\u65b9\u63d0\u9192"

    invoke-direct {p0, p1, p2, p3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    return-object p0
.end method

.method public static displayPoints(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;JLjava/util/List;)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/WideHcopRoad$Decision;",
            "Lcom/navipilot/obf/WideCameraEngine$Fix;",
            "J",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideCameraEngine$Point;",
            ">;)",
            "Lcom/navipilot/obf/WideHcopRoad$Decision;"
        }
    .end annotation

    .line 94
    invoke-static {p0, p1, p2, p3}, Lcom/navipilot/obf/WideCameraTrace;->display(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    .line 95
    invoke-static {p4, p1, p2, p3}, Lcom/navipilot/obf/WideCameraFallback;->match(Ljava/util/List;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object p1

    .line 96
    iget-object p2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz p2, :cond_0

    iget-boolean p2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz p2, :cond_0

    return-object v0

    .line 97
    :cond_0
    if-eqz p1, :cond_2

    if-eqz p0, :cond_1

    iget-boolean p2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz p2, :cond_1

    iget p0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    iput p0, p1, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    :cond_1
    return-object p1

    .line 98
    :cond_2
    iget-boolean p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-nez p0, :cond_3

    invoke-static {}, Lcom/navipilot/obf/WideCameraFallback;->status()Ljava/lang/String;

    move-result-object p0

    iput-object p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->reason:Ljava/lang/String;

    .line 99
    :cond_3
    return-object v0
.end method

.method public static eligible(Lcom/navipilot/obf/WideCameraEngine$Fix;)Z
    .locals 2

    .line 59
    if-nez p0, :cond_0

    const-wide/16 v0, 0x0

    goto :goto_0

    :cond_0
    iget-wide v0, p0, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    :goto_0
    invoke-static {p0, v0, v1}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result p0

    return p0
.end method

.method static level(Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    .line 247
    const-string v0, "\u9053\u8def\u5c64\u7d1a\u672a\u6a19\u660e"

    if-nez p0, :cond_0

    return-object v0

    .line 248
    :cond_0
    const-string v1, "\\|"

    const/4 v2, -0x1

    invoke-virtual {p0, v1, v2}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object p0

    .line 249
    array-length v1, p0

    const/4 v2, 0x3

    if-ne v1, v2, :cond_5

    const/4 v1, 0x2

    aget-object v1, p0, v1

    const-string v2, "no"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_1

    goto :goto_1

    .line 251
    :cond_1
    const/4 v1, 0x0

    :try_start_0
    aget-object v1, p0, v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    .line 252
    if-gtz v1, :cond_3

    const-string v3, "yes"

    const/4 v4, 0x1

    aget-object v5, p0, v4

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_3

    const-string v3, "viaduct"

    aget-object v5, p0, v4

    invoke-virtual {v3, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_2

    goto :goto_0

    .line 253
    :cond_2
    if-nez v1, :cond_4

    aget-object p0, p0, v4

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_0
    .catch Ljava/lang/NumberFormatException; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz p0, :cond_4

    const-string p0, "\u5e73\u9762\u9053\u8def"

    return-object p0

    .line 252
    :cond_3
    :goto_0
    const-string p0, "\u9ad8\u67b6\u9053\u8def"

    return-object p0

    .line 254
    :catch_0
    move-exception p0

    .line 255
    :cond_4
    return-object v0

    .line 249
    :cond_5
    :goto_1
    return-object v0
.end method

.method private static next(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Ljava/util/Set;)Lcom/navipilot/obf/WideCameraTrace$Candidate;
    .locals 22
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/WideHcopRoad$Data;",
            "Lcom/navipilot/obf/WideCameraTrace$Candidate;",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;)",
            "Lcom/navipilot/obf/WideCameraTrace$Candidate;"
        }
    .end annotation

    .line 207
    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->exit()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    const/4 v3, 0x0

    if-nez v2, :cond_0

    return-object v3

    .line 208
    :cond_0
    nop

    .line 209
    move-object/from16 v2, p0

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move-object v4, v3

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_1

    .line 218
    return-object v4

    .line 209
    :cond_1
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    move-object v7, v5

    check-cast v7, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 210
    iget-object v5, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    move-object/from16 v14, p2

    invoke-interface {v14, v5}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_8

    move-object/from16 v5, p1

    iget-object v6, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    invoke-static {v6, v7}, Lcom/navipilot/obf/WideCameraTrace;->sameRoute(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z

    move-result v6

    if-nez v6, :cond_2

    goto :goto_0

    .line 211
    :cond_2
    iget-wide v8, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    cmp-long v6, v8, v0

    const/4 v8, 0x1

    const/4 v9, 0x0

    if-nez v6, :cond_3

    iget v6, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-ltz v6, :cond_3

    move v6, v8

    goto :goto_1

    :cond_3
    iget-wide v10, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    cmp-long v6, v10, v0

    if-nez v6, :cond_4

    iget v6, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-gtz v6, :cond_4

    const/4 v6, -0x1

    goto :goto_1

    :cond_4
    move v6, v9

    .line 212
    :goto_1
    if-nez v6, :cond_5

    goto :goto_0

    .line 213
    :cond_5
    if-eqz v4, :cond_6

    return-object v3

    .line 214
    :cond_6
    iget-object v15, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-object v4, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object v4, v4, v9

    aget-wide v16, v4, v8

    iget-object v4, v7, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object v4, v4, v9

    aget-wide v18, v4, v9

    const-wide/16 v20, 0x0

    invoke-static/range {v15 .. v21}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v8

    .line 215
    if-lez v6, :cond_7

    const-wide/16 v9, 0x0

    goto :goto_2

    :cond_7
    iget-wide v9, v8, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    :goto_2
    iput-wide v9, v8, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    .line 216
    move v9, v6

    new-instance v6, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    const-wide/16 v10, 0x0

    const-wide/16 v12, 0x0

    invoke-direct/range {v6 .. v13}, Lcom/navipilot/obf/WideCameraTrace$Candidate;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V

    move-object v4, v6

    goto :goto_0

    .line 210
    :cond_8
    move-object/from16 v5, p1

    goto :goto_0
.end method

.method private reset()V
    .locals 1

    .line 103
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 104
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 105
    return-void
.end method

.method private static sameRoute(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z
    .locals 9

    .line 201
    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    iget-object v0, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    if-nez v0, :cond_0

    goto :goto_2

    .line 202
    :cond_0
    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    array-length v0, p0

    move v2, v1

    :goto_0
    if-lt v2, v0, :cond_1

    .line 204
    return v1

    .line 202
    :cond_1
    aget-object v3, p0, v2

    iget-object v4, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    array-length v5, v4

    move v6, v1

    :goto_1
    if-lt v6, v5, :cond_2

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    :cond_2
    aget-object v7, v4, v6

    .line 203
    invoke-virtual {v3, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_3

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v7

    const/4 v8, 0x1

    if-le v7, v8, :cond_3

    const-string v7, "[0-9]+"

    invoke-virtual {v3, v7}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_3

    return v8

    .line 202
    :cond_3
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 201
    :cond_4
    :goto_2
    return v1
.end method

.method static update(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V
    .locals 1

    .line 47
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->motion:Lcom/navipilot/obf/WideAlertMotion;

    invoke-virtual {v0, p1, p2, p3}, Lcom/navipilot/obf/WideAlertMotion;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideCameraEngine$Fix;

    move-result-object p1

    .line 48
    if-nez p1, :cond_0

    const/4 p2, 0x0

    goto :goto_0

    :cond_0
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->shared:Lcom/navipilot/obf/WideCameraTrace;

    invoke-virtual {v0, p0, p1, p2, p3}, Lcom/navipilot/obf/WideCameraTrace;->accept(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object p2

    .line 49
    :goto_0
    new-instance p3, Lcom/navipilot/obf/WideCameraTrace$Frame;

    invoke-direct {p3, p0, p1, p2}, Lcom/navipilot/obf/WideCameraTrace$Frame;-><init>(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;Lcom/navipilot/obf/WideHcopRoad$Decision;)V

    sput-object p3, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 50
    return-void
.end method

.method public static voiceAsset(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    .line 244
    if-eqz p0, :cond_0

    const-string v0, "flat:"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string p0, "tw_camera_flat.mp3"

    goto :goto_0

    :cond_0
    if-eqz p0, :cond_1

    const-string v0, "elev:"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_1

    const-string p0, "tw_camera_elevated.mp3"

    goto :goto_0

    :cond_1
    const-string p0, "tw_camera_voice_a.mp3"

    :goto_0
    return-object p0
.end method

.method public static voiceKey(Lcom/navipilot/obf/WideHcopRoad$Decision;)Ljava/lang/String;
    .locals 3

    .line 240
    if-eqz p0, :cond_3

    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-nez v0, :cond_0

    goto :goto_1

    .line 241
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u9ad8\u67b6\u9053\u8def"

    iget-object v2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "elev:"

    goto :goto_0

    :cond_1
    const-string v1, "\u5e73\u9762\u9053\u8def"

    iget-object v2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_2

    const-string v1, "flat:"

    goto :goto_0

    :cond_2
    const-string v1, "other:"

    :goto_0
    invoke-static {v1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    .line 240
    :cond_3
    :goto_1
    const/4 p0, 0x0

    return-object p0
.end method


# virtual methods
.method accept(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 33

    .line 108
    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-object/from16 v7, p2

    if-eqz v6, :cond_1e

    iget-boolean v1, v6, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-nez v1, :cond_1e

    invoke-static/range {p2 .. p4}, Lcom/navipilot/obf/WideAlertMotion;->position(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Z

    move-result v1

    if-eqz v1, :cond_1e

    iget-boolean v1, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->headingValid:Z

    if-eqz v1, :cond_1e

    iget-wide v1, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/high16 v9, 0x3ff8000000000000L    # 1.5

    cmpg-double v1, v1, v9

    if-gez v1, :cond_0

    const/16 v21, 0x0

    goto/16 :goto_c

    .line 112
    :cond_0
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-nez v1, :cond_1

    const-wide/16 v4, 0x0

    goto :goto_0

    :cond_1
    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v11, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v4, v11

    long-to-double v4, v4

    const-wide v11, 0x408f400000000000L    # 1000.0

    div-double/2addr v4, v11

    .line 113
    :goto_0
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    const-wide/high16 v11, 0x4000000000000000L    # 2.0

    if-nez v1, :cond_2

    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/16 p3, 0x0

    goto :goto_1

    :cond_2
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v13, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    const-wide/16 p3, 0x0

    iget-wide v2, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    add-double/2addr v13, v2

    div-double/2addr v13, v11

    :goto_1
    mul-double v2, v4, v13

    .line 114
    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    mul-double/2addr v13, v11

    move-wide/from16 v16, v9

    const/4 v15, 0x0

    const-wide/high16 v8, 0x4028000000000000L    # 12.0

    invoke-static {v8, v9, v13, v14}, Ljava/lang/Math;->max(DD)D

    move-result-wide v23

    .line 115
    cmpg-double v1, v4, p3

    const-wide/high16 v8, 0x4008000000000000L    # 3.0

    if-lez v1, :cond_4

    cmpl-double v1, v4, v8

    if-gtz v1, :cond_4

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-eqz v1, :cond_3

    .line 116
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v4, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v13, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 p3, v8

    iget-wide v8, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 v18, v11

    iget-wide v11, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v25, v4

    move-wide/from16 v29, v8

    move-wide/from16 v31, v11

    move-wide/from16 v27, v13

    invoke-static/range {v25 .. v32}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v4

    mul-double v11, v23, v18

    add-double/2addr v11, v2

    cmpl-double v1, v4, v11

    if-lez v1, :cond_5

    goto :goto_2

    .line 115
    :cond_3
    move-wide/from16 p3, v8

    goto :goto_3

    :cond_4
    move-wide/from16 p3, v8

    .line 117
    :goto_2
    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 119
    :cond_5
    :goto_3
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    .line 120
    iget-object v1, v6, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :cond_6
    :goto_4
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-nez v1, :cond_14

    .line 139
    iput-object v8, v0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    .line 140
    iput-object v7, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 141
    nop

    .line 142
    nop

    .line 143
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const-wide/high16 v2, 0x7ff0000000000000L    # Double.POSITIVE_INFINITY

    move-object v0, v15

    :goto_5
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-nez v4, :cond_10

    .line 149
    if-nez v0, :cond_7

    return-object v15

    .line 150
    :cond_7
    iget-wide v4, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 151
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :goto_6
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-nez v1, :cond_f

    .line 152
    nop

    .line 153
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    move-object v2, v15

    :cond_8
    :goto_7
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    const-wide/16 v4, 0x3e8

    const/4 v8, 0x2

    if-nez v3, :cond_c

    .line 159
    if-eqz v2, :cond_9

    return-object v2

    .line 160
    :cond_9
    iget v1, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    if-lt v1, v8, :cond_b

    iget-wide v1, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v8, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    sub-long/2addr v1, v8

    cmp-long v1, v1, v4

    if-gez v1, :cond_a

    goto :goto_8

    .line 161
    :cond_a
    invoke-static {v6, v0, v7}, Lcom/navipilot/obf/WideCameraTrace;->ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraEngine$Fix;)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    return-object v0

    .line 160
    :cond_b
    :goto_8
    return-object v15

    .line 153
    :cond_c
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 154
    iget v9, v3, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    if-lt v9, v8, :cond_8

    iget-wide v8, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v10, v3, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    sub-long/2addr v8, v10

    cmp-long v4, v8, v4

    if-ltz v4, :cond_8

    iget-wide v4, v3, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpl-double v4, v4, p3

    if-lez v4, :cond_d

    goto :goto_7

    .line 156
    :cond_d
    invoke-static {v6, v3, v7}, Lcom/navipilot/obf/WideCameraTrace;->ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraEngine$Fix;)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v3

    .line 157
    iget-object v4, v3, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz v4, :cond_8

    if-eqz v2, :cond_e

    iget-wide v4, v3, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    iget-wide v8, v2, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    cmpg-double v4, v4, v8

    if-gez v4, :cond_8

    :cond_e
    move-object v2, v3

    goto :goto_7

    .line 151
    :cond_f
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    iget-wide v2, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    sub-double/2addr v2, v4

    iput-wide v2, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    goto :goto_6

    .line 143
    :cond_10
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 144
    if-eqz v0, :cond_12

    iget-wide v9, v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    iget-wide v11, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpg-double v5, v9, v11

    if-gez v5, :cond_11

    goto :goto_9

    .line 147
    :cond_11
    iget-wide v4, v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    invoke-static {v2, v3, v4, v5}, Ljava/lang/Math;->min(DD)D

    move-result-wide v2

    goto/16 :goto_5

    .line 145
    :cond_12
    :goto_9
    if-eqz v0, :cond_13

    iget-wide v2, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 146
    :cond_13
    nop

    .line 147
    move-object v0, v4

    goto/16 :goto_5

    .line 120
    :cond_14
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 121
    iget-boolean v4, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->bounded:Z

    if-eqz v4, :cond_15

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->minLon:D

    const-wide v12, 0x3f40624dd2f1a9fcL    # 5.0E-4

    sub-double/2addr v10, v12

    cmpg-double v4, v4, v10

    if-ltz v4, :cond_6

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLon:D

    add-double/2addr v10, v12

    cmpl-double v4, v4, v10

    if-gtz v4, :cond_6

    .line 122
    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->minLat:D

    sub-double/2addr v10, v12

    cmpg-double v4, v4, v10

    if-ltz v4, :cond_6

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLat:D

    add-double/2addr v10, v12

    cmpl-double v4, v4, v10

    if-lez v4, :cond_15

    goto/16 :goto_4

    .line 123
    :cond_15
    iget-object v4, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-wide v10, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v12, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-object/from16 v18, v4

    move-wide/from16 v19, v10

    move-wide/from16 v21, v12

    invoke-static/range {v18 .. v24}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v4

    .line 124
    iget-boolean v5, v4, Lcom/navipilot/obf/WideRoad$Projection;->ambiguous:Z

    if-nez v5, :cond_1d

    iget-wide v10, v4, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    iget-wide v12, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    mul-double v12, v12, v16

    move-wide/from16 v18, v2

    const-wide/high16 v2, 0x402e000000000000L    # 15.0

    invoke-static {v2, v3, v12, v13}, Ljava/lang/Math;->max(DD)D

    move-result-wide v2

    const-wide v12, 0x4041800000000000L    # 35.0

    invoke-static {v12, v13, v2, v3}, Ljava/lang/Math;->min(DD)D

    move-result-wide v2

    cmpl-double v2, v10, v2

    if-lez v2, :cond_16

    move-wide/from16 v2, v18

    goto/16 :goto_4

    .line 125
    :cond_16
    iget-wide v2, v4, Lcom/navipilot/obf/WideRoad$Projection;->heading:D

    iget-wide v10, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v2, v3, v10, v11}, Lcom/navipilot/obf/WideRoad;->delta(DD)D

    move-result-wide v2

    .line 126
    cmpg-double v5, v2, v12

    if-gtz v5, :cond_17

    iget v5, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-ltz v5, :cond_17

    const/16 v28, 0x1

    goto :goto_a

    :cond_17
    const-wide v12, 0x4062200000000000L    # 145.0

    cmpl-double v5, v2, v12

    if-ltz v5, :cond_18

    iget v5, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-gtz v5, :cond_18

    const/4 v5, -0x1

    move/from16 v28, v5

    goto :goto_a

    :cond_18
    const/16 v28, 0x0

    .line 127
    :goto_a
    if-nez v28, :cond_19

    move-wide/from16 v2, v18

    goto/16 :goto_4

    .line 128
    :cond_19
    iget-wide v12, v4, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    const-wide/high16 v10, 0x4010000000000000L    # 4.0

    move-object/from16 v21, v15

    iget-wide v14, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-static {v10, v11, v14, v15}, Ljava/lang/Math;->max(DD)D

    move-result-wide v10

    div-double/2addr v12, v10

    .line 129
    const-wide v10, 0x4066800000000000L    # 180.0

    sub-double/2addr v10, v2

    invoke-static {v2, v3, v10, v11}, Ljava/lang/Math;->min(DD)D

    move-result-wide v2

    const-wide/high16 v10, 0x4039000000000000L    # 25.0

    div-double/2addr v2, v10

    .line 130
    new-instance v25, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 131
    mul-double/2addr v12, v12

    mul-double/2addr v2, v2

    add-double v29, v12, v2

    iget-wide v2, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    .line 130
    move-object/from16 v26, v1

    move-wide/from16 v31, v2

    move-object/from16 v27, v4

    invoke-direct/range {v25 .. v32}, Lcom/navipilot/obf/WideCameraTrace$Candidate;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V

    .line 132
    move-object/from16 v1, v25

    move-wide/from16 v2, v18

    move-wide/from16 v4, v23

    invoke-direct/range {v0 .. v6}, Lcom/navipilot/obf/WideCameraTrace;->continueFromHistory(Lcom/navipilot/obf/WideCameraTrace$Candidate;DDLcom/navipilot/obf/WideHcopRoad$Data;)V

    .line 133
    invoke-interface {v8, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 134
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v0

    const/16 v1, 0xc

    if-le v0, v1, :cond_1c

    .line 135
    const/4 v10, 0x0

    const/4 v11, 0x1

    :goto_b
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v0

    if-lt v11, v0, :cond_1a

    .line 136
    invoke-interface {v8, v10}, Ljava/util/List;->remove(I)Ljava/lang/Object;

    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-object/from16 v15, v21

    goto/16 :goto_4

    .line 135
    :cond_1a
    invoke-interface {v8, v11}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    iget-wide v0, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    invoke-interface {v8, v10}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    iget-wide v4, v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpl-double v0, v0, v4

    if-lez v0, :cond_1b

    move v10, v11

    :cond_1b
    add-int/lit8 v11, v11, 0x1

    goto :goto_b

    .line 134
    :cond_1c
    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-object/from16 v15, v21

    goto/16 :goto_4

    .line 124
    :cond_1d
    move-object/from16 v21, v15

    move-object/from16 v0, p0

    move-object/from16 v6, p1

    goto/16 :goto_4

    .line 108
    :cond_1e
    const/16 v21, 0x0

    .line 109
    :goto_c
    invoke-direct/range {p0 .. p0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 110
    return-object v21
.end method
