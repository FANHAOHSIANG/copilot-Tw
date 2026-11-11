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

    .line 13
    return-void
.end method

.method constructor <init>()V
    .locals 1

    .line 9
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 20
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    .line 9
    return-void
.end method

.method private static advance(Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Data;D)D
    .locals 8

    .line 142
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v1, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v1, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-wide/high16 v1, 0x7ff8000000000000L    # Double.NaN

    if-eqz v0, :cond_1

    .line 143
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

    .line 145
    :cond_1
    nop

    .line 146
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v3, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    invoke-virtual {p0}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide v5

    sub-double/2addr v3, v5

    .line 147
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 148
    const/4 v5, 0x0

    :goto_0
    const/16 v6, 0x20

    if-ge v5, v6, :cond_6

    cmpg-double v6, v3, p3

    if-lez v6, :cond_2

    goto :goto_1

    .line 149
    :cond_2
    iget-object v6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v6, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-interface {v0, v6}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 150
    invoke-static {p2, p0, v0}, Lcom/navipilot/obf/WideCameraTrace;->next(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Ljava/util/Set;)Lcom/navipilot/obf/WideCameraTrace$Candidate;

    move-result-object p0

    .line 151
    if-nez p0, :cond_3

    return-wide v1

    .line 152
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

    .line 153
    :cond_5
    iget-object v6, p0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v6, v6, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    add-double/2addr v3, v6

    .line 148
    add-int/lit8 v5, v5, 0x1

    goto :goto_0

    .line 155
    :cond_6
    :goto_1
    return-wide v1
.end method

.method private static ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 9

    .line 195
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Decision;

    const-string v1, "\u540c\u5411\u9023\u7e8c\u9053\u8def\u6e2c\u901f\u63d0\u9192"

    invoke-direct {v0, v1, p2, p3}, Lcom/navipilot/obf/WideHcopRoad$Decision;-><init>(Ljava/lang/String;J)V

    .line 196
    nop

    .line 197
    invoke-virtual {p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide p2

    neg-double p2, p2

    .line 198
    new-instance v1, Ljava/util/HashSet;

    invoke-direct {v1}, Ljava/util/HashSet;-><init>()V

    .line 199
    const/4 v2, 0x0

    move-object v4, p1

    move v3, v2

    :goto_0
    const/16 v5, 0x80

    if-ge v3, v5, :cond_4

    const-wide v5, 0x4097700000000000L    # 1500.0

    cmpg-double v5, p2, v5

    if-lez v5, :cond_0

    goto :goto_3

    .line 200
    :cond_0
    iget-object v5, v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v5, v5, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-interface {v1, v5}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 201
    iget-object v5, p0, Lcom/navipilot/obf/WideHcopRoad$Data;->cameras:Ljava/util/List;

    invoke-interface {v5}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :goto_1
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-nez v6, :cond_3

    .line 202
    sget-object v6, Lcom/navipilot/obf/WideHighwayAlertData;->CAMERAS:[Lcom/navipilot/obf/WideHcopRoad$Camera;

    array-length v7, v6

    move v5, v2

    :goto_2
    if-lt v5, v7, :cond_2

    .line 203
    iget-object v5, v4, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v5, v5, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    add-double/2addr p2, v5

    .line 204
    invoke-static {p0, v4, v1}, Lcom/navipilot/obf/WideCameraTrace;->next(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;Ljava/util/Set;)Lcom/navipilot/obf/WideCameraTrace$Candidate;

    move-result-object v4

    .line 205
    if-nez v4, :cond_1

    goto :goto_3

    .line 206
    :cond_1
    nop

    .line 199
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 202
    :cond_2
    aget-object v8, v6, v5

    invoke-static {v0, v4, v8, p2, p3}, Lcom/navipilot/obf/WideCameraTrace;->consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;D)V

    add-int/lit8 v5, v5, 0x1

    goto :goto_2

    .line 201
    :cond_3
    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-static {v0, v4, v6, p2, p3}, Lcom/navipilot/obf/WideCameraTrace;->consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;D)V

    goto :goto_1

    .line 208
    :cond_4
    :goto_3
    iget-object p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iput-object p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    iput p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    .line 209
    iget-object p0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide p0, p0, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    iput-wide p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->offset:D

    const/4 p0, 0x1

    iput-boolean p0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    .line 210
    return-object v0
.end method

.method static clear()V
    .locals 1

    .line 50
    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 51
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->shared:Lcom/navipilot/obf/WideCameraTrace;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 52
    return-void
.end method

.method private static consider(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Camera;D)V
    .locals 8

    .line 182
    iget-object v0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v1, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 183
    :cond_0
    nop

    .line 184
    iget-object v0, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    :goto_0
    if-lt v3, v1, :cond_5

    .line 185
    if-nez v4, :cond_1

    return-void

    .line 186
    :cond_1
    iget-object v0, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v1, v0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-wide v2, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iget-wide v4, p2, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    const-wide/16 v6, 0x0

    invoke-static/range {v1 .. v7}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v0

    .line 187
    iget p1, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-lez p1, :cond_2

    iget-wide v1, v0, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    goto :goto_1

    :cond_2
    iget-wide v1, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    iget-wide v3, v0, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    sub-double/2addr v1, v3

    .line 188
    :goto_1
    add-double/2addr p3, v1

    .line 189
    iget-boolean p1, v0, Lcom/navipilot/obf/WideRoad$Projection;->ambiguous:Z

    if-nez p1, :cond_4

    const-wide/high16 v0, 0x4034000000000000L    # 20.0

    cmpl-double p1, p3, v0

    if-lez p1, :cond_4

    const-wide v0, 0x4097700000000000L    # 1500.0

    cmpg-double p1, p3, v0

    if-gtz p1, :cond_4

    .line 190
    iget-object p1, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    if-eqz p1, :cond_3

    iget-wide v0, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    cmpg-double p1, p3, v0

    if-gez p1, :cond_4

    .line 191
    :cond_3
    iput-object p2, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->camera:Lcom/navipilot/obf/WideHcopRoad$Camera;

    iput-wide p3, p0, Lcom/navipilot/obf/WideHcopRoad$Decision;->distance:D

    .line 193
    :cond_4
    return-void

    .line 184
    :cond_5
    aget v5, v0, v3

    iget v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->direction:I

    if-ne v5, v6, :cond_6

    const/4 v5, 0x1

    goto :goto_2

    :cond_6
    move v5, v2

    :goto_2
    or-int/2addr v4, v5

    add-int/lit8 v3, v3, 0x1

    goto :goto_0
.end method

.method private continueFromHistory(Lcom/navipilot/obf/WideCameraTrace$Candidate;DDLcom/navipilot/obf/WideHcopRoad$Data;)V
    .locals 13

    .line 125
    move-wide/from16 v0, p4

    iget-wide v2, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 126
    iget-object v4, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_0

    return-void

    .line 127
    :cond_0
    const-wide/high16 v4, 0x4014000000000000L    # 5.0

    add-double/2addr v4, v2

    iput-wide v4, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 128
    iget-object v4, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_1
    :goto_0
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_2

    .line 139
    return-void

    .line 128
    :cond_2
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 129
    add-double v6, p2, v0

    move-object/from16 v8, p6

    invoke-static {v5, p1, v8, v6, v7}, Lcom/navipilot/obf/WideCameraTrace;->advance(Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideCameraTrace$Candidate;Lcom/navipilot/obf/WideHcopRoad$Data;D)D

    move-result-wide v9

    .line 130
    invoke-static {v9, v10}, Ljava/lang/Double;->isFinite(D)Z

    move-result v11

    if-eqz v11, :cond_1

    neg-double v11, v0

    cmpg-double v11, v9, v11

    if-ltz v11, :cond_1

    cmpl-double v6, v9, v6

    if-lez v6, :cond_3

    goto :goto_0

    .line 131
    :cond_3
    sub-double/2addr v9, p2

    div-double/2addr v9, v0

    .line 132
    iget-wide v6, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    const-wide/high16 v11, 0x3fe8000000000000L    # 0.75

    mul-double/2addr v6, v11

    add-double/2addr v6, v2

    mul-double/2addr v9, v9

    add-double/2addr v6, v9

    .line 133
    iget-wide v9, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpg-double v9, v6, v9

    if-gez v9, :cond_1

    .line 134
    iput-wide v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 135
    iget v6, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    add-int/lit8 v6, v6, 0x1

    const/16 v7, 0xa

    invoke-static {v7, v6}, Ljava/lang/Math;->min(II)I

    move-result v6

    iput v6, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    .line 136
    iget-wide v5, v5, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    iput-wide v5, p1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    goto :goto_0
.end method

.method static display(Lcom/navipilot/obf/WideHcopRoad$Decision;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 19

    .line 55
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    sget-object v2, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 56
    if-eqz v2, :cond_3

    iget-object v3, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    if-eqz v3, :cond_3

    iget-object v3, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    iget-boolean v3, v3, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-nez v3, :cond_3

    if-eqz v1, :cond_3

    .line 57
    iget-wide v3, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->time:J

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v3, v3, v5

    if-nez v3, :cond_3

    invoke-static/range {p1 .. p3}, Lcom/navipilot/obf/WideHcopRoad;->invalid(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_0

    goto :goto_1

    .line 59
    :cond_0
    iget-boolean v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->confirmed:Z

    if-eqz v3, :cond_1

    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    if-eqz v3, :cond_1

    iget-wide v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->time:J

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    cmp-long v3, v3, v5

    if-nez v3, :cond_1

    .line 60
    iget-object v3, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v4, v3, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-wide v5, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v7, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    const-wide/16 v9, 0x0

    invoke-static/range {v4 .. v10}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v13

    .line 61
    new-instance v11, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    iget-object v12, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget v14, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->direction:I

    const-wide/16 v15, 0x0

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    move-wide/from16 v17, v3

    invoke-direct/range {v11 .. v18}, Lcom/navipilot/obf/WideCameraTrace$Candidate;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V

    .line 62
    iget-object v2, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->data:Lcom/navipilot/obf/WideHcopRoad$Data;

    iget-wide v3, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-static {v2, v11, v3, v4}, Lcom/navipilot/obf/WideCameraTrace;->ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v1

    .line 63
    iget v2, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    iput v2, v1, Lcom/navipilot/obf/WideHcopRoad$Decision;->limit:I

    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    iput-object v0, v1, Lcom/navipilot/obf/WideHcopRoad$Decision;->source:Ljava/lang/String;

    .line 64
    return-object v1

    .line 66
    :cond_1
    iget-object v1, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    if-nez v1, :cond_2

    goto :goto_0

    :cond_2
    iget-object v0, v2, Lcom/navipilot/obf/WideCameraTrace$Frame;->decision:Lcom/navipilot/obf/WideHcopRoad$Decision;

    :goto_0
    return-object v0

    .line 57
    :cond_3
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

    .line 167
    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->exit()J

    move-result-wide v0

    const-wide/16 v2, 0x0

    cmp-long v2, v0, v2

    const/4 v3, 0x0

    if-nez v2, :cond_0

    return-object v3

    .line 168
    :cond_0
    nop

    .line 169
    move-object/from16 v2, p0

    iget-object v2, v2, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    move-object v4, v3

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-nez v5, :cond_1

    .line 178
    return-object v4

    .line 169
    :cond_1
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    move-object v7, v5

    check-cast v7, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 170
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

    .line 171
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

    .line 172
    :goto_1
    if-nez v6, :cond_5

    goto :goto_0

    .line 173
    :cond_5
    if-eqz v4, :cond_6

    return-object v3

    .line 174
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

    .line 175
    if-lez v6, :cond_7

    const-wide/16 v9, 0x0

    goto :goto_2

    :cond_7
    iget-wide v9, v8, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    :goto_2
    iput-wide v9, v8, Lcom/navipilot/obf/WideRoad$Projection;->station:D

    .line 176
    move v9, v6

    new-instance v6, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    const-wide/16 v10, 0x0

    const-wide/16 v12, 0x0

    invoke-direct/range {v6 .. v13}, Lcom/navipilot/obf/WideCameraTrace$Candidate;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V

    move-object v4, v6

    goto :goto_0

    .line 170
    :cond_8
    move-object/from16 v5, p1

    goto :goto_0
.end method

.method private reset()V
    .locals 1

    .line 70
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 71
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 72
    return-void
.end method

.method private static sameRoute(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z
    .locals 9

    .line 161
    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    iget-object v0, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    if-nez v0, :cond_0

    goto :goto_2

    .line 162
    :cond_0
    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    array-length v0, p0

    move v2, v1

    :goto_0
    if-lt v2, v0, :cond_1

    .line 164
    return v1

    .line 162
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

    .line 163
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

    .line 162
    :cond_3
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 161
    :cond_4
    :goto_2
    return v1
.end method

.method static update(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)V
    .locals 2

    .line 45
    sget-object v0, Lcom/navipilot/obf/WideCameraTrace;->shared:Lcom/navipilot/obf/WideCameraTrace;

    invoke-virtual {v0, p0, p1, p2, p3}, Lcom/navipilot/obf/WideCameraTrace;->accept(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object p2

    .line 46
    new-instance p3, Lcom/navipilot/obf/WideCameraTrace$Frame;

    if-nez p1, :cond_0

    const-wide/16 v0, 0x0

    goto :goto_0

    :cond_0
    iget-wide v0, p1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    :goto_0
    invoke-direct {p3, p0, v0, v1, p2}, Lcom/navipilot/obf/WideCameraTrace$Frame;-><init>(Lcom/navipilot/obf/WideHcopRoad$Data;JLcom/navipilot/obf/WideHcopRoad$Decision;)V

    sput-object p3, Lcom/navipilot/obf/WideCameraTrace;->published:Lcom/navipilot/obf/WideCameraTrace$Frame;

    .line 47
    return-void
.end method


# virtual methods
.method accept(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraEngine$Fix;J)Lcom/navipilot/obf/WideHcopRoad$Decision;
    .locals 31

    .line 75
    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-object/from16 v7, p2

    if-eqz v6, :cond_17

    iget-boolean v1, v6, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-nez v1, :cond_17

    invoke-static/range {p2 .. p4}, Lcom/navipilot/obf/WideHcopRoad;->invalid(Lcom/navipilot/obf/WideCameraEngine$Fix;J)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_0

    const/16 v30, 0x0

    goto/16 :goto_b

    .line 79
    :cond_0
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-nez v1, :cond_1

    const-wide/16 v4, 0x0

    goto :goto_0

    :cond_1
    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v9, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    sub-long/2addr v4, v9

    long-to-double v4, v4

    const-wide v9, 0x408f400000000000L    # 1000.0

    div-double/2addr v4, v9

    .line 80
    :goto_0
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    const-wide/high16 v9, 0x4000000000000000L    # 2.0

    if-nez v1, :cond_2

    iget-wide v11, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    goto :goto_1

    :cond_2
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v11, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->speed:D

    add-double/2addr v11, v13

    div-double/2addr v11, v9

    :goto_1
    mul-double/2addr v11, v4

    .line 81
    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    mul-double/2addr v13, v9

    const-wide/16 p3, 0x0

    const-wide/high16 v2, 0x4028000000000000L    # 12.0

    invoke-static {v2, v3, v13, v14}, Ljava/lang/Math;->max(DD)D

    move-result-wide v20

    .line 82
    cmpg-double v1, v4, p3

    if-lez v1, :cond_4

    const-wide/high16 v1, 0x4008000000000000L    # 3.0

    cmpl-double v1, v4, v1

    if-gtz v1, :cond_4

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    if-eqz v1, :cond_3

    .line 83
    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v1, v1, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-object v3, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    iget-wide v3, v3, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    move-wide/from16 p3, v9

    const/16 v30, 0x0

    iget-wide v8, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v22, v1

    move-wide/from16 v24, v3

    move-wide/from16 v28, v8

    move-wide/from16 v26, v13

    invoke-static/range {v22 .. v29}, Lcom/navipilot/obf/WideCameraEngine;->distance(DDDD)D

    move-result-wide v1

    mul-double v9, v20, p3

    add-double/2addr v9, v11

    cmpl-double v1, v1, v9

    if-lez v1, :cond_5

    goto :goto_2

    .line 82
    :cond_3
    const/16 v30, 0x0

    goto :goto_3

    :cond_4
    const/16 v30, 0x0

    .line 84
    :goto_2
    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 86
    :cond_5
    :goto_3
    new-instance v8, Ljava/util/ArrayList;

    invoke-direct {v8}, Ljava/util/ArrayList;-><init>()V

    .line 87
    iget-object v1, v6, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v9

    :cond_6
    :goto_4
    invoke-interface {v9}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const-wide/high16 v2, 0x4020000000000000L    # 8.0

    if-nez v1, :cond_f

    .line 106
    iput-object v8, v0, Lcom/navipilot/obf/WideCameraTrace;->previous:Ljava/util/List;

    .line 107
    iput-object v7, v0, Lcom/navipilot/obf/WideCameraTrace;->last:Lcom/navipilot/obf/WideCameraEngine$Fix;

    .line 108
    nop

    .line 109
    nop

    .line 110
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const-wide/high16 v4, 0x7ff0000000000000L    # Double.POSITIVE_INFINITY

    move-object/from16 v0, v30

    :goto_5
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v9

    if-nez v9, :cond_b

    .line 116
    if-nez v0, :cond_7

    return-object v30

    .line 117
    :cond_7
    iget-wide v9, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 118
    invoke-interface {v8}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v11

    :goto_6
    invoke-interface {v11}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-nez v1, :cond_a

    .line 119
    iget v1, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->samples:I

    const/4 v8, 0x3

    if-lt v1, v8, :cond_9

    iget-wide v11, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    iget-wide v13, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->since:J

    sub-long/2addr v11, v13

    const-wide/16 v13, 0x5dc

    cmp-long v1, v11, v13

    if-ltz v1, :cond_9

    sub-double/2addr v4, v9

    const-wide/high16 v8, 0x4004000000000000L    # 2.5

    cmpg-double v1, v4, v8

    if-ltz v1, :cond_9

    .line 120
    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide v4

    cmpg-double v1, v4, v2

    if-ltz v1, :cond_9

    iget-object v1, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->point:Lcom/navipilot/obf/WideRoad$Projection;

    iget-wide v4, v1, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraTrace$Candidate;->progress()D

    move-result-wide v8

    sub-double/2addr v4, v8

    cmpg-double v1, v4, v2

    if-gez v1, :cond_8

    goto :goto_7

    .line 121
    :cond_8
    iget-wide v1, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    invoke-static {v6, v0, v1, v2}, Lcom/navipilot/obf/WideCameraTrace;->ahead(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideCameraTrace$Candidate;J)Lcom/navipilot/obf/WideHcopRoad$Decision;

    move-result-object v0

    return-object v0

    .line 120
    :cond_9
    :goto_7
    return-object v30

    .line 118
    :cond_a
    invoke-interface {v11}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    iget-wide v12, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    sub-double/2addr v12, v9

    iput-wide v12, v1, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    goto :goto_6

    .line 110
    :cond_b
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v9

    check-cast v9, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 111
    if-eqz v0, :cond_d

    iget-wide v10, v9, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    iget-wide v12, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    cmpg-double v10, v10, v12

    if-gez v10, :cond_c

    goto :goto_8

    .line 114
    :cond_c
    iget-wide v9, v9, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    invoke-static {v4, v5, v9, v10}, Ljava/lang/Math;->min(DD)D

    move-result-wide v4

    goto :goto_5

    .line 112
    :cond_d
    :goto_8
    if-eqz v0, :cond_e

    iget-wide v4, v0, Lcom/navipilot/obf/WideCameraTrace$Candidate;->cost:D

    .line 113
    :cond_e
    nop

    .line 114
    move-object v0, v9

    goto :goto_5

    .line 87
    :cond_f
    invoke-interface {v9}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 88
    iget-boolean v4, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->bounded:Z

    if-eqz v4, :cond_10

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->minLon:D

    const-wide v15, 0x3f40624dd2f1a9fcL    # 5.0E-4

    sub-double/2addr v13, v15

    cmpg-double v4, v4, v13

    if-ltz v4, :cond_6

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLon:D

    add-double/2addr v13, v15

    cmpl-double v4, v4, v13

    if-gtz v4, :cond_6

    .line 89
    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->minLat:D

    sub-double/2addr v13, v15

    cmpg-double v4, v4, v13

    if-ltz v4, :cond_6

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v13, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->maxLat:D

    add-double/2addr v13, v15

    cmpl-double v4, v4, v13

    if-lez v4, :cond_10

    goto/16 :goto_4

    .line 90
    :cond_10
    iget-object v15, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-wide v4, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lat:D

    iget-wide v13, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->lon:D

    move-wide/from16 v16, v4

    move-wide/from16 v18, v13

    invoke-static/range {v15 .. v21}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v4

    .line 91
    iget-boolean v5, v4, Lcom/navipilot/obf/WideRoad$Projection;->ambiguous:Z

    if-nez v5, :cond_16

    iget-wide v13, v4, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    iget-wide v5, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-static {v2, v3, v5, v6}, Ljava/lang/Math;->max(DD)D

    move-result-wide v2

    const-wide/high16 v5, 0x4032000000000000L    # 18.0

    invoke-static {v5, v6, v2, v3}, Ljava/lang/Math;->min(DD)D

    move-result-wide v2

    cmpl-double v2, v13, v2

    if-lez v2, :cond_11

    goto/16 :goto_a

    .line 92
    :cond_11
    iget-wide v2, v4, Lcom/navipilot/obf/WideRoad$Projection;->heading:D

    iget-wide v5, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->heading:D

    invoke-static {v2, v3, v5, v6}, Lcom/navipilot/obf/WideRoad;->delta(DD)D

    move-result-wide v2

    .line 93
    const-wide/high16 v5, 0x4039000000000000L    # 25.0

    cmpg-double v10, v2, v5

    if-gtz v10, :cond_12

    iget v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-ltz v10, :cond_12

    const/4 v10, 0x1

    goto :goto_9

    :cond_12
    const-wide v13, 0x4063600000000000L    # 155.0

    cmpl-double v10, v2, v13

    if-ltz v10, :cond_13

    iget v10, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-gtz v10, :cond_13

    const/4 v10, -0x1

    goto :goto_9

    :cond_13
    const/4 v10, 0x0

    :goto_9
    move/from16 v25, v10

    .line 94
    if-nez v25, :cond_14

    move-object/from16 v6, p1

    goto/16 :goto_4

    .line 95
    :cond_14
    iget-wide v13, v4, Lcom/navipilot/obf/WideRoad$Projection;->offset:D

    move-wide/from16 p3, v5

    const-wide/high16 v5, 0x4010000000000000L    # 4.0

    move-object/from16 v23, v1

    iget-wide v0, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->accuracy:D

    invoke-static {v5, v6, v0, v1}, Ljava/lang/Math;->max(DD)D

    move-result-wide v0

    div-double/2addr v13, v0

    .line 96
    const-wide v0, 0x4066800000000000L    # 180.0

    sub-double/2addr v0, v2

    invoke-static {v2, v3, v0, v1}, Ljava/lang/Math;->min(DD)D

    move-result-wide v0

    div-double v0, v0, p3

    .line 97
    new-instance v22, Lcom/navipilot/obf/WideCameraTrace$Candidate;

    .line 98
    mul-double/2addr v13, v13

    mul-double/2addr v0, v0

    add-double v26, v13, v0

    iget-wide v0, v7, Lcom/navipilot/obf/WideCameraEngine$Fix;->time:J

    .line 97
    move-wide/from16 v28, v0

    move-object/from16 v24, v4

    invoke-direct/range {v22 .. v29}, Lcom/navipilot/obf/WideCameraTrace$Candidate;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideRoad$Projection;IDJ)V

    .line 99
    move-object/from16 v1, v22

    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-wide v2, v11

    move-wide/from16 v4, v20

    invoke-direct/range {v0 .. v6}, Lcom/navipilot/obf/WideCameraTrace;->continueFromHistory(Lcom/navipilot/obf/WideCameraTrace$Candidate;DDLcom/navipilot/obf/WideHcopRoad$Data;)V

    .line 100
    invoke-interface {v8, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 101
    invoke-interface {v8}, Ljava/util/List;->size()I

    move-result v0

    const/16 v1, 0xc

    if-le v0, v1, :cond_15

    .line 102
    invoke-direct/range {p0 .. p0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 103
    return-object v30

    .line 101
    :cond_15
    move-object/from16 v0, p0

    move-object/from16 v6, p1

    move-wide v11, v2

    goto/16 :goto_4

    .line 91
    :cond_16
    move-wide v2, v11

    move-object/from16 v0, p0

    :goto_a
    move-object/from16 v6, p1

    goto/16 :goto_4

    .line 75
    :cond_17
    const/16 v30, 0x0

    .line 76
    :goto_b
    invoke-direct/range {p0 .. p0}, Lcom/navipilot/obf/WideCameraTrace;->reset()V

    .line 77
    return-object v30
.end method
