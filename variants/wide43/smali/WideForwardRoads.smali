.class final Lcom/navipilot/obf/WideForwardRoads;
.super Ljava/lang/Object;
.source "WideForwardRoads.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideForwardRoads$Step;
    }
.end annotation


# static fields
.field static final HORIZON_METERS:D = 2000.0

.field static final MAX_BRANCHES:I = 0x3

.field static final MAX_STATES:I = 0x100


# direct methods
.method constructor <init>()V
    .registers 1

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static add(Ljava/util/Map;JLcom/navipilot/obf/WideHcopRoad$Road;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/Map<",
            "Ljava/lang/Long;",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideHcopRoad$Road;",
            ">;>;J",
            "Lcom/navipilot/obf/WideHcopRoad$Road;",
            ")V"
        }
    .end annotation

    .line 70
    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-interface {p0, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/List;

    if-nez v0, :cond_18

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {p0, p1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_18
    invoke-interface {v0, p3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 71
    return-void
.end method

.method static explore(Lcom/navipilot/obf/WideHcopRoad$Data;Lcom/navipilot/obf/WideHcopRoad$Road;ID)Ljava/util/List;
    .registers 30
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/WideHcopRoad$Data;",
            "Lcom/navipilot/obf/WideHcopRoad$Road;",
            "ID)",
            "Ljava/util/List<",
            "Lcom/navipilot/obf/WideForwardRoads$Step;",
            ">;"
        }
    .end annotation

    .line 28
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    new-instance v9, Ljava/util/ArrayList;

    invoke-direct {v9}, Ljava/util/ArrayList;-><init>()V

    .line 29
    if-eqz v0, :cond_22e

    iget-boolean v2, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->expired:Z

    if-nez v2, :cond_22e

    if-eqz v1, :cond_22e

    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    if-eqz v2, :cond_22e

    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    array-length v2, v2

    const/4 v10, 0x2

    if-ge v2, v10, :cond_1e

    move-object v10, v9

    goto/16 :goto_22f

    .line 30
    :cond_1e
    new-instance v11, Ljava/util/HashMap;

    invoke-direct {v11}, Ljava/util/HashMap;-><init>()V

    .line 31
    iget-object v0, v0, Lcom/navipilot/obf/WideHcopRoad$Data;->roads:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_29
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-nez v2, :cond_1ef

    .line 36
    new-instance v12, Lcom/navipilot/obf/WideForwardRoads$1;

    invoke-direct {v12}, Lcom/navipilot/obf/WideForwardRoads$1;-><init>()V

    .line 40
    new-instance v13, Ljava/util/PriorityQueue;

    const/16 v0, 0x10

    invoke-direct {v13, v0, v12}, Ljava/util/PriorityQueue;-><init>(ILjava/util/Comparator;)V

    .line 41
    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    iget-object v0, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    const/4 v14, 0x0

    aget-object v0, v0, v14

    const/4 v15, 0x1

    aget-wide v3, v0, v15

    iget-object v0, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object v0, v0, v14

    aget-wide v5, v0, v14

    const-wide/16 v7, 0x0

    invoke-static/range {v2 .. v8}, Lcom/navipilot/obf/WideRoad;->project([[DDDD)Lcom/navipilot/obf/WideRoad$Projection;

    move-result-object v0

    iget-wide v2, v0, Lcom/navipilot/obf/WideRoad$Projection;->length:D

    .line 42
    new-instance v0, Lcom/navipilot/obf/WideForwardRoads$Step;

    if-lez p2, :cond_5a

    move-wide/from16 v2, p3

    goto :goto_5c

    :cond_5a
    sub-double v2, v2, p3

    :goto_5c
    neg-double v3, v2

    new-instance v8, Ljava/util/HashSet;

    invoke-direct {v8}, Ljava/util/HashSet;-><init>()V

    const-wide/16 v5, 0x0

    const/4 v7, 0x0

    move/from16 v2, p2

    invoke-direct/range {v0 .. v8}, Lcom/navipilot/obf/WideForwardRoads$Step;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;IDDILjava/util/Set;)V

    invoke-virtual {v13, v0}, Ljava/util/PriorityQueue;->add(Ljava/lang/Object;)Z

    .line 43
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    .line 44
    nop

    :goto_73
    invoke-virtual {v13}, Ljava/util/PriorityQueue;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_1ed

    invoke-interface {v9}, Ljava/util/List;->size()I

    move-result v2

    const/16 v3, 0x100

    if-lt v2, v3, :cond_84

    move-object v10, v9

    goto/16 :goto_1ee

    .line 45
    :cond_84
    invoke-virtual {v13}, Ljava/util/PriorityQueue;->remove()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/navipilot/obf/WideForwardRoads$Step;

    new-instance v3, Ljava/lang/StringBuilder;

    iget-object v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v4, v4, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v4, ":"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    iget v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->direction:I

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 46
    iget-object v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->visited:Ljava/util/Set;

    invoke-interface {v4, v3}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_1e4

    iget-wide v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    const-wide v6, 0x409f400000000000L    # 2000.0

    cmpl-double v4, v4, v6

    if-gtz v4, :cond_1e4

    invoke-interface {v0, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_c1

    goto :goto_73

    .line 47
    :cond_c1
    invoke-interface {v9, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 48
    iget v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->depth:I

    const/16 v5, 0x40

    if-ge v4, v5, :cond_1db

    iget-wide v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->length:D

    const-wide v16, 0x3fb999999999999aL    # 0.1

    cmpg-double v4, v4, v16

    if-lez v4, :cond_1db

    iget-wide v4, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    move-wide/from16 p2, v6

    iget-wide v6, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->length:D

    add-double/2addr v4, v6

    cmpl-double v4, v4, p2

    if-lez v4, :cond_e1

    goto :goto_73

    .line 49
    :cond_e1
    invoke-virtual {v2}, Lcom/navipilot/obf/WideForwardRoads$Step;->exit()J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-interface {v11, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/List;

    if-nez v4, :cond_f2

    goto :goto_73

    .line 50
    :cond_f2
    new-instance v5, Ljava/util/ArrayList;

    invoke-direct {v5}, Ljava/util/ArrayList;-><init>()V

    .line 51
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :goto_fb
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-nez v6, :cond_126

    .line 64
    invoke-static {v5, v12}, Ljava/util/Collections;->sort(Ljava/util/List;Ljava/util/Comparator;)V

    .line 65
    move v2, v14

    :goto_105
    const/4 v3, 0x3

    invoke-interface {v5}, Ljava/util/List;->size()I

    move-result v4

    invoke-static {v3, v4}, Ljava/lang/Math;->min(II)I

    move-result v3

    if-lt v2, v3, :cond_112

    goto/16 :goto_73

    :cond_112
    invoke-virtual {v13}, Ljava/util/PriorityQueue;->size()I

    move-result v3

    const/16 v4, 0x300

    if-ge v3, v4, :cond_123

    invoke-interface {v5, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/WideForwardRoads$Step;

    invoke-virtual {v13, v3}, Ljava/util/PriorityQueue;->add(Ljava/lang/Object;)Z

    :cond_123
    add-int/lit8 v2, v2, 0x1

    goto :goto_105

    .line 51
    :cond_126
    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 52
    iget-object v7, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    iget-object v8, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget-object v8, v8, Lcom/navipilot/obf/WideHcopRoad$Road;->id:Ljava/lang/String;

    invoke-virtual {v7, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_139

    goto :goto_fb

    .line 55
    :cond_139
    iget v7, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->depth:I

    if-lez v7, :cond_14c

    invoke-static {v1, v6}, Lcom/navipilot/obf/WideForwardRoads;->sameName(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z

    move-result v7

    if-eqz v7, :cond_14c

    iget-object v7, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    invoke-static {v1, v7}, Lcom/navipilot/obf/WideForwardRoads;->sameName(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z

    move-result v7

    if-nez v7, :cond_14c

    goto :goto_fb

    .line 56
    :cond_14c
    iget-wide v7, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    invoke-virtual {v2}, Lcom/navipilot/obf/WideForwardRoads$Step;->exit()J

    move-result-wide v16

    cmp-long v7, v7, v16

    if-nez v7, :cond_15c

    iget v7, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-ltz v7, :cond_15c

    move v7, v15

    goto :goto_16d

    :cond_15c
    iget-wide v7, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    invoke-virtual {v2}, Lcom/navipilot/obf/WideForwardRoads$Step;->exit()J

    move-result-wide v16

    cmp-long v7, v7, v16

    if-nez v7, :cond_16c

    iget v7, v6, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-gtz v7, :cond_16c

    const/4 v7, -0x1

    goto :goto_16d

    :cond_16c
    move v7, v14

    .line 57
    :goto_16d
    if-nez v7, :cond_170

    goto :goto_fb

    .line 58
    :cond_170
    iget-object v8, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    iget v10, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->direction:I

    move-object/from16 p0, v0

    invoke-static {v8, v10, v15}, Lcom/navipilot/obf/WideForwardRoads;->tangent(Lcom/navipilot/obf/WideHcopRoad$Road;IZ)D

    move-result-wide v0

    move-object v10, v9

    invoke-static {v6, v7, v14}, Lcom/navipilot/obf/WideForwardRoads;->tangent(Lcom/navipilot/obf/WideHcopRoad$Road;IZ)D

    move-result-wide v8

    invoke-static {v0, v1, v8, v9}, Lcom/navipilot/obf/WideCameraEngine;->difference(DD)D

    move-result-wide v0

    .line 59
    const-wide v8, 0x405b800000000000L    # 110.0

    cmpl-double v8, v0, v8

    if-lez v8, :cond_194

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object v9, v10

    const/4 v10, 0x2

    goto/16 :goto_fb

    .line 60
    :cond_194
    iget-wide v8, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->penalty:D

    iget-object v14, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->road:Lcom/navipilot/obf/WideHcopRoad$Road;

    invoke-static {v14, v6}, Lcom/navipilot/obf/WideForwardRoads;->sameName(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z

    move-result v14

    if-eqz v14, :cond_1a0

    const/4 v14, 0x0

    goto :goto_1a1

    :cond_1a0
    const/4 v14, 0x2

    :goto_1a1
    move-wide/from16 p2, v0

    int-to-double v0, v14

    add-double/2addr v8, v0

    const-wide v0, 0x4056800000000000L    # 90.0

    div-double v0, p2, v0

    add-double v21, v8, v0

    .line 61
    new-instance v0, Ljava/util/HashSet;

    iget-object v1, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->visited:Ljava/util/Set;

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    invoke-interface {v0, v3}, Ljava/util/Set;->add(Ljava/lang/Object;)Z

    .line 62
    new-instance v16, Lcom/navipilot/obf/WideForwardRoads$Step;

    iget-wide v8, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->entryDistance:D

    move-object/from16 v24, v0

    iget-wide v0, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->length:D

    add-double v19, v8, v0

    iget v0, v2, Lcom/navipilot/obf/WideForwardRoads$Step;->depth:I

    add-int/lit8 v23, v0, 0x1

    move-object/from16 v17, v6

    move/from16 v18, v7

    invoke-direct/range {v16 .. v24}, Lcom/navipilot/obf/WideForwardRoads$Step;-><init>(Lcom/navipilot/obf/WideHcopRoad$Road;IDDILjava/util/Set;)V

    move-object/from16 v0, v16

    invoke-interface {v5, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    move-object v9, v10

    const/4 v10, 0x2

    const/4 v14, 0x0

    goto/16 :goto_fb

    .line 48
    :cond_1db
    move-object/from16 p0, v0

    move-object v10, v9

    move-object/from16 v1, p1

    const/4 v10, 0x2

    const/4 v14, 0x0

    goto/16 :goto_73

    .line 46
    :cond_1e4
    move-object/from16 p0, v0

    move-object v10, v9

    move-object/from16 v1, p1

    const/4 v10, 0x2

    const/4 v14, 0x0

    goto/16 :goto_73

    .line 44
    :cond_1ed
    move-object v10, v9

    .line 67
    :goto_1ee
    return-object v10

    .line 31
    :cond_1ef
    move-object v10, v9

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideHcopRoad$Road;

    .line 32
    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    if-eqz v2, :cond_227

    iget-object v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    array-length v2, v2

    const/4 v3, 0x2

    if-ge v2, v3, :cond_201

    goto :goto_228

    .line 33
    :cond_201
    iget v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    const-wide/16 v4, 0x0

    if-ltz v2, :cond_212

    iget-wide v6, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    cmp-long v2, v6, v4

    if-eqz v2, :cond_212

    iget-wide v6, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->start:J

    invoke-static {v11, v6, v7, v1}, Lcom/navipilot/obf/WideForwardRoads;->add(Ljava/util/Map;JLcom/navipilot/obf/WideHcopRoad$Road;)V

    .line 34
    :cond_212
    iget v2, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->dir:I

    if-gtz v2, :cond_221

    iget-wide v6, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    cmp-long v2, v6, v4

    if-eqz v2, :cond_221

    iget-wide v4, v1, Lcom/navipilot/obf/WideHcopRoad$Road;->end:J

    invoke-static {v11, v4, v5, v1}, Lcom/navipilot/obf/WideForwardRoads;->add(Ljava/util/Map;JLcom/navipilot/obf/WideHcopRoad$Road;)V

    :cond_221
    move-object/from16 v1, p1

    move-object v9, v10

    move v10, v3

    goto/16 :goto_29

    .line 32
    :cond_227
    const/4 v3, 0x2

    :goto_228
    move-object/from16 v1, p1

    move-object v9, v10

    move v10, v3

    goto/16 :goto_29

    .line 29
    :cond_22e
    move-object v10, v9

    :goto_22f
    return-object v10
.end method

.method static sameName(Lcom/navipilot/obf/WideHcopRoad$Road;Lcom/navipilot/obf/WideHcopRoad$Road;)Z
    .registers 11

    .line 18
    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    const/4 v1, 0x0

    if-eqz v0, :cond_39

    iget-object v0, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    if-nez v0, :cond_a

    goto :goto_39

    .line 19
    :cond_a
    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    array-length v0, p0

    move v2, v1

    :goto_e
    if-lt v2, v0, :cond_11

    .line 20
    return v1

    .line 19
    :cond_11
    aget-object v3, p0, v2

    iget-object v4, p1, Lcom/navipilot/obf/WideHcopRoad$Road;->names:[Ljava/lang/String;

    array-length v5, v4

    move v6, v1

    :goto_17
    if-lt v6, v5, :cond_1c

    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    :cond_1c
    aget-object v7, v4, v6

    if-eqz v3, :cond_36

    invoke-virtual {v3, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_36

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v7

    const/4 v8, 0x1

    if-le v7, v8, :cond_36

    const-string v7, "[0-9]+"

    invoke-virtual {v3, v7}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v7

    if-nez v7, :cond_36

    return v8

    :cond_36
    add-int/lit8 v6, v6, 0x1

    goto :goto_17

    .line 18
    :cond_39
    :goto_39
    return v1
.end method

.method static tangent(Lcom/navipilot/obf/WideHcopRoad$Road;IZ)D
    .registers 14

    .line 23
    iget-object v0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    array-length v0, v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-lez p1, :cond_9

    move v3, v1

    goto :goto_a

    :cond_9
    move v3, v2

    :goto_a
    if-ne p2, v3, :cond_f

    add-int/lit8 v0, v0, -0x2

    goto :goto_10

    :cond_f
    move v0, v2

    .line 24
    :goto_10
    iget-object p2, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object p2, p2, v0

    aget-wide v3, p2, v1

    iget-object p2, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object p2, p2, v0

    aget-wide v5, p2, v2

    iget-object p2, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    add-int/2addr v0, v1

    aget-object p2, p2, v0

    aget-wide v7, p2, v1

    iget-object p0, p0, Lcom/navipilot/obf/WideHcopRoad$Road;->xy:[[D

    aget-object p0, p0, v0

    aget-wide v9, p0, v2

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideCameraEngine;->bearing(DDDD)D

    move-result-wide v0

    .line 25
    if-gez p1, :cond_31

    const/16 v2, 0xb4

    :cond_31
    int-to-double p0, v2

    add-double/2addr v0, p0

    const-wide p0, 0x4076800000000000L    # 360.0

    rem-double/2addr v0, p0

    return-wide v0
.end method
