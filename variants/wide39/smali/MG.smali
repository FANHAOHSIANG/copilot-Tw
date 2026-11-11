.class public final Lcom/navipilot/obf/MG;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field private wideAmapPreAdjust:Ljava/lang/Integer;
.field public final a:Lcom/navipilot/obf/XG;

.field public final b:Lcom/navipilot/obf/IG;

.field public final c:Lcom/navipilot/obf/tr;

.field public final d:Lcom/navipilot/obf/bT;

.field public final e:Lcom/navipilot/obf/tr;

.field public final f:Lcom/navipilot/obf/tr;

.field public final g:Ljava/util/LinkedHashMap;

.field public final h:Ljava/util/LinkedHashMap;

.field public final i:Ljava/util/LinkedHashMap;

.field public j:Z

.field public k:Z

.field public l:Ljava/lang/Integer;

.field public m:Lcom/navipilot/obf/EU;

.field public n:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/navipilot/obf/XG;Lcom/navipilot/obf/IG;Lcom/navipilot/obf/PB;)V
    .locals 3

    sget-object v0, Lcom/navipilot/obf/JG;->l:Lcom/navipilot/obf/JG;

    sget-object v1, Lcom/navipilot/obf/bT;->j:Lcom/navipilot/obf/bT;

    sget-object v2, Lcom/navipilot/obf/KG;->l:Lcom/navipilot/obf/KG;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    iput-object p2, p0, Lcom/navipilot/obf/MG;->b:Lcom/navipilot/obf/IG;

    iput-object v0, p0, Lcom/navipilot/obf/MG;->c:Lcom/navipilot/obf/tr;

    iput-object v1, p0, Lcom/navipilot/obf/MG;->d:Lcom/navipilot/obf/bT;

    iput-object p3, p0, Lcom/navipilot/obf/MG;->e:Lcom/navipilot/obf/tr;

    iput-object v2, p0, Lcom/navipilot/obf/MG;->f:Lcom/navipilot/obf/tr;

    new-instance p1, Ljava/util/LinkedHashMap;

    invoke-direct {p1}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/MG;->g:Ljava/util/LinkedHashMap;

    new-instance p1, Ljava/util/LinkedHashMap;

    invoke-direct {p1}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/MG;->h:Ljava/util/LinkedHashMap;

    new-instance p1, Ljava/util/LinkedHashMap;

    invoke-direct {p1}, Ljava/util/LinkedHashMap;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string p1, "none"

    iput-object p1, p0, Lcom/navipilot/obf/MG;->n:Ljava/lang/String;

    return-void
.end method

.method public static synthetic c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 1

    const-string v0, "source_absent_or_stale"

    invoke-virtual {p0, p1, p2, v0}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    return-void
.end method

.method public static d(Lcom/navipilot/obf/Ad;Z)Lorg/json/JSONObject;
    .locals 8

    if-eqz p1, :cond_0

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->F1()I

    move-result v0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->I1()I

    move-result v0

    :goto_0
    if-eqz p1, :cond_1

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->C1()I

    move-result v1

    goto :goto_1

    :cond_1
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->y1()I

    move-result v1

    :goto_1
    if-eqz p1, :cond_2

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->E1()I

    move-result v2

    goto :goto_2

    :cond_2
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->H1()I

    move-result v2

    :goto_2
    if-eqz p1, :cond_3

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->D1()I

    move-result v3

    goto :goto_3

    :cond_3
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->z1()I

    move-result v3

    :goto_3
    if-eqz p1, :cond_4

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->B1()I

    move-result v4

    goto :goto_4

    :cond_4
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->x1()I

    move-result v4

    :goto_4
    if-eqz p1, :cond_5

    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->A1()I

    move-result v5

    goto :goto_5

    :cond_5
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->w1()I

    move-result v5

    :goto_5
    if-gez v0, :cond_6

    if-gtz v2, :cond_6

    const/4 p0, 0x0

    return-object p0

    :cond_6
    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    const-string v7, "type"

    invoke-virtual {v6, v7, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const/4 v0, 0x0

    if-gez v3, :cond_7

    move v3, v0

    :cond_7
    const-string v7, "distance_m"

    invoke-virtual {v6, v7, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const/16 v3, 0x12c

    invoke-static {v2, v0, v3}, Lcom/navipilot/obf/NG;->J(III)I

    move-result v2

    const-string v7, "speed_limit_kph"

    invoke-virtual {v6, v7, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const/4 v2, -0x1

    if-eqz p1, :cond_8

    goto :goto_6

    :cond_8
    invoke-virtual {p0}, Lcom/navipilot/obf/Ad;->G1()I

    move-result p0

    if-ge p0, v2, :cond_9

    goto :goto_6

    :cond_9
    move v2, p0

    :goto_6
    const-string p0, "section_type"

    invoke-virtual {v6, p0, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string p0, "block_type"

    invoke-virtual {v6, p0, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string p0, "block_speed_kph"

    invoke-static {v4, v0, v3}, Lcom/navipilot/obf/NG;->J(III)I

    move-result p1

    invoke-virtual {v6, p0, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    if-gez v5, :cond_a

    move v5, v0

    :cond_a
    const-string p0, "block_distance_m"

    invoke-virtual {v6, p0, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    return-object v6
.end method

.method public static final i(ZLcom/navipilot/obf/O4;Lcom/navipilot/obf/MG;JLjava/lang/String;I)V
    .locals 1

    const/4 v0, 0x0

    invoke-static {p6, v0, p0}, Lcom/navipilot/obf/Iz;->a(ILcom/navipilot/obf/O4;Z)Z

    move-result p0

    if-eqz p0, :cond_1

    if-eqz p1, :cond_1

    iget-object p0, p2, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-virtual {p0, p5}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Ljava/lang/Long;

    if-eqz p2, :cond_0

    invoke-virtual {p2}, Ljava/lang/Long;->longValue()J

    move-result-wide p3

    :cond_0
    iget-wide p1, p1, Lcom/navipilot/obf/O4;->c:J

    invoke-static {p3, p4, p1, p2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide p1

    invoke-static {p1, p2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {p0, p5, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_1
    return-void
.end method

.method public static final j(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 6

    if-eqz p0, :cond_2

    invoke-virtual {p4, p6}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v4

    move-object v0, p1

    move-object v1, p5

    move-wide v2, p2

    invoke-virtual/range {v0 .. v5}, Lcom/navipilot/obf/HG;->h(Ljava/lang/String;JJ)Z

    move-result p0

    if-eqz p0, :cond_2

    iget-object p0, p1, Lcom/navipilot/obf/HG;->a:Ljava/util/Map;

    invoke-interface {p0, p5}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/lang/Long;

    const-wide/high16 p2, -0x8000000000000000L

    if-eqz p1, :cond_0

    invoke-virtual {p1}, Ljava/lang/Long;->longValue()J

    move-result-wide p4

    goto :goto_0

    :cond_0
    move-wide p4, p2

    :goto_0
    const-string p1, "ui_route_changed"

    invoke-interface {p0, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Long;

    if-eqz p0, :cond_1

    invoke-virtual {p0}, Ljava/lang/Long;->longValue()J

    move-result-wide p2

    :cond_1
    cmp-long p0, p4, p2

    if-ltz p0, :cond_2

    const/4 p0, 0x1

    goto :goto_1

    :cond_2
    const/4 p0, 0x0

    :goto_1
    return p0
.end method

.method public static synthetic k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z
    .locals 7

    move v0, p0

    move-object v1, p1

    move-wide v2, p2

    move-object v4, p4

    move-object v5, p5

    move-object v6, p5

    invoke-static/range {v0 .. v6}, Lcom/navipilot/obf/MG;->j(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method


# virtual methods
.method public final a(Ljava/lang/String;)Lcom/navipilot/obf/NW;
    .locals 2

    iget-object p0, p0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    iget-object v0, p0, Lcom/navipilot/obf/XG;->c:Ljava/lang/Object;

    monitor-enter v0

    :try_start_0
    iget-object p0, p0, Lcom/navipilot/obf/XG;->j:Lcom/navipilot/obf/QG;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    if-eqz p0, :cond_0

    iget-object p0, p0, Lcom/navipilot/obf/QG;->c:Ljava/util/LinkedHashMap;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "json:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/navipilot/obf/NW;

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return-object p0

    :catchall_0
    move-exception p0

    monitor-exit v0

    throw p0
.end method

.method public final b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V
    .locals 26

    move-object/from16 v0, p0

    move-object/from16 v8, p1

    move-object/from16 v9, p2

    iget-object v1, v0, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-static {v0, v8, v9, v1}, Lcom/navipilot/obf/WideAmapSource;->filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;

    move-result-object v9

    invoke-static {v8, v9, v1}, Lcom/navipilot/obf/WideAmapPreAdjust;->merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;

    move-result-object v9

    move-object/16 p2, v9

    invoke-virtual/range {p0 .. p1}, Lcom/navipilot/obf/MG;->a(Ljava/lang/String;)Lcom/navipilot/obf/NW;

    move-result-object v1

    if-eqz v1, :cond_15

    iget-boolean v2, v1, Lcom/navipilot/obf/NW;->e:Z

    if-eqz v2, :cond_0

    iget-object v2, v0, Lcom/navipilot/obf/MG;->h:Ljava/util/LinkedHashMap;

    invoke-virtual {v2, v8}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    sget-object v3, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-static {v2, v3}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_0

    move-object v11, v1

    goto :goto_0

    :cond_0
    const/4 v11, 0x0

    :goto_0
    if-nez v11, :cond_1

    goto/16 :goto_d

    :cond_1
    iget-object v1, v0, Lcom/navipilot/obf/MG;->c:Lcom/navipilot/obf/tr;

    invoke-interface {v1}, Lcom/navipilot/obf/tr;->c()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Number;

    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    move-result-wide v20

    const/16 v22, 0x0

    const/4 v15, 0x1

    if-eqz v9, :cond_2

    move v14, v15

    goto :goto_1

    :cond_2
    move/from16 v14, v22

    :goto_1
    if-eqz v9, :cond_3

    invoke-virtual/range {p2 .. p2}, Lorg/json/JSONObject;->toString()Ljava/lang/String;

    move-result-object v1

    move-object v13, v1

    goto :goto_2

    :cond_3
    const/4 v13, 0x0

    :goto_2
    const-string v12, "app_status"

    if-eqz v14, :cond_4

    invoke-virtual {v8, v12}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_4

    iget-object v1, v0, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-virtual {v1, v8}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Long;

    if-eqz v1, :cond_4

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    move-wide/from16 v23, v1

    goto :goto_3

    :cond_4
    move-wide/from16 v23, v20

    :goto_3
    move-wide/from16 v1, v23

    invoke-static {v8, v1, v2}, Lcom/navipilot/obf/WideBridge;->timestamp(Ljava/lang/String;J)J

    move-result-wide v23

    iget-object v6, v0, Lcom/navipilot/obf/MG;->g:Ljava/util/LinkedHashMap;

    invoke-virtual {v6, v8}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    move-object v7, v1

    check-cast v7, Lcom/navipilot/obf/LG;

    if-eqz v7, :cond_6

    iget-object v1, v7, Lcom/navipilot/obf/LG;->b:Ljava/lang/String;

    if-eqz v1, :cond_6

    if-eqz v14, :cond_6

    iget-boolean v2, v7, Lcom/navipilot/obf/LG;->a:Z

    if-eqz v2, :cond_6

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    invoke-static {v2, v9}, Lcom/navipilot/obf/NG;->S(Lorg/json/JSONObject;Lorg/json/JSONObject;)Z

    move-result v1

    if-eqz v1, :cond_6

    iget-object v1, v0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    const/4 v3, 0x0

    const/4 v4, 0x0

    const-string v5, "source_fields_withdrawn"

    move-object/from16 v2, p1

    move-object v10, v6

    move-object/from16 v25, v7

    move-wide/from16 v6, v20

    invoke-virtual/range {v1 .. v7}, Lcom/navipilot/obf/XG;->r(Ljava/lang/String;ZLorg/json/JSONObject;Ljava/lang/String;J)Z

    move-result v1

    if-nez v1, :cond_5

    return-void

    :cond_5
    new-instance v1, Lcom/navipilot/obf/LG;

    const-string v19, "source_fields_withdrawn"

    const/4 v2, 0x0

    const/4 v3, 0x0

    move-object v4, v12

    move-object v12, v1

    move-object v7, v13

    move v13, v2

    move v5, v14

    move-object v14, v3

    move v2, v15

    move-wide/from16 v15, v20

    move-wide/from16 v17, v20

    invoke-direct/range {v12 .. v19}, Lcom/navipilot/obf/LG;-><init>(ZLjava/lang/String;JJLjava/lang/String;)V

    invoke-interface {v10, v8, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_4

    :cond_6
    move-object v10, v6

    move-object/from16 v25, v7

    move-object v4, v12

    move-object v7, v13

    move v5, v14

    move v2, v15

    :goto_4
    invoke-virtual {v10, v8}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/LG;

    move-object/from16 v3, v25

    if-eqz v3, :cond_7

    iget-boolean v6, v3, Lcom/navipilot/obf/LG;->a:Z

    if-ne v6, v5, :cond_7

    iget-object v6, v3, Lcom/navipilot/obf/LG;->b:Ljava/lang/String;

    invoke-static {v6, v7}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_7

    if-eqz v5, :cond_8

    invoke-virtual {v8, v4}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_8

    iget-wide v12, v3, Lcom/navipilot/obf/LG;->d:J

    cmp-long v4, v12, v23

    if-nez v4, :cond_7

    goto :goto_5

    :cond_7
    move-object/from16 v12, p3

    goto :goto_6

    :cond_8
    :goto_5
    if-nez v5, :cond_9

    iget-object v4, v3, Lcom/navipilot/obf/LG;->e:Ljava/lang/String;

    move-object/from16 v12, p3

    invoke-static {v4, v12}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_a

    goto :goto_6

    :cond_9
    move-object/from16 v12, p3

    :cond_a
    move/from16 v15, v22

    goto :goto_7

    :goto_6
    move v15, v2

    :goto_7
    iget-object v4, v11, Lcom/navipilot/obf/NW;->f:Ljava/util/LinkedHashMap;

    const-string v6, "interval_ms"

    invoke-virtual {v4, v6}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    instance-of v11, v6, Ljava/lang/Number;

    if-eqz v11, :cond_b

    check-cast v6, Ljava/lang/Number;

    goto :goto_8

    :cond_b
    const/4 v6, 0x0

    :goto_8
    if-eqz v6, :cond_c

    invoke-virtual {v6}, Ljava/lang/Number;->longValue()J

    move-result-wide v13

    move-object/from16 v25, v3

    const-wide/16 v2, 0x0

    invoke-static {v13, v14, v2, v3}, Lcom/navipilot/obf/NG;->E(JJ)J

    move-result-wide v2

    goto :goto_9

    :cond_c
    move-object/from16 v25, v3

    const-wide/16 v2, 0x3e8

    :goto_9
    const-string v11, "delivery_mode"

    invoke-virtual {v4, v11}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    instance-of v11, v4, Ljava/lang/String;

    if-eqz v11, :cond_d

    check-cast v4, Ljava/lang/String;

    goto :goto_a

    :cond_d
    const/4 v4, 0x0

    :goto_a
    if-nez v4, :cond_e

    const-string v4, "on_change"

    :cond_e
    const-string v11, "lane_current"

    invoke-virtual {v8, v11}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_10

    const-string v11, "periodic"

    const-string v13, "on_change_with_heartbeat"

    filled-new-array {v11, v13}, [Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Lcom/navipilot/obf/eU;->k([Ljava/lang/Object;)Ljava/util/Set;

    move-result-object v11

    invoke-interface {v11, v4}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_10

    if-eqz v25, :cond_f

    move-object/from16 v4, v25

    iget-wide v13, v4, Lcom/navipilot/obf/LG;->c:J

    sub-long v13, v20, v13

    cmp-long v4, v13, v2

    if-ltz v4, :cond_10

    :cond_f
    const/16 v22, 0x1

    :cond_10
    if-nez v15, :cond_11

    if-nez v22, :cond_11

    return-void

    :cond_11
    if-eqz v5, :cond_12

    if-eqz v1, :cond_12

    iget-boolean v4, v1, Lcom/navipilot/obf/LG;->a:Z

    const/4 v6, 0x1

    if-ne v4, v6, :cond_12

    iget-wide v13, v1, Lcom/navipilot/obf/LG;->c:J

    sub-long v13, v20, v13

    cmp-long v1, v13, v2

    if-gez v1, :cond_12

    return-void

    :cond_12
    if-eqz v5, :cond_13

    const/4 v4, 0x0

    goto :goto_b

    :cond_13
    move-object v4, v12

    :goto_b
    iget-object v0, v0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    move-object/from16 v1, p1

    move v2, v5

    move-object/from16 v3, p2

    move v15, v5

    move-wide/from16 v5, v23

    invoke-virtual/range {v0 .. v6}, Lcom/navipilot/obf/XG;->r(Ljava/lang/String;ZLorg/json/JSONObject;Ljava/lang/String;J)Z

    move-result v0

    if-eqz v0, :cond_15

    if-nez v15, :cond_14

    move-object/from16 v19, v12

    goto :goto_c

    :cond_14
    const/16 v19, 0x0

    :goto_c
    new-instance v0, Lcom/navipilot/obf/LG;

    move-object v12, v0

    move v13, v15

    move-object v14, v7

    move-wide/from16 v15, v20

    move-wide/from16 v17, v23

    invoke-direct/range {v12 .. v19}, Lcom/navipilot/obf/LG;-><init>(ZLjava/lang/String;JJLjava/lang/String;)V

    invoke-interface {v10, v8, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_15
    :goto_d
    return-void
.end method

.method public final declared-synchronized e(Z)V
    .locals 3

    monitor-enter p0

    :try_start_0
    iput-boolean p1, p0, Lcom/navipilot/obf/MG;->k:Z

    iget-boolean v0, p0, Lcom/navipilot/obf/MG;->j:Z

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    invoke-virtual {v0}, Lcom/navipilot/obf/XG;->i()Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "app_status"

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1}, Lorg/json/JSONObject;-><init>()V

    const-string v2, "foreground"

    invoke-virtual {v1, v2, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string p1, "source_absent_or_stale"

    invoke-virtual {p0, v0, v1, p1}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :goto_0

    :catchall_0
    move-exception p1

    goto :goto_1

    :cond_0
    :goto_0
    monitor-exit p0

    return-void

    :goto_1
    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p1
.end method

.method public final f(Ljava/lang/String;)J
    .locals 2

    invoke-virtual {p0, p1}, Lcom/navipilot/obf/MG;->a(Ljava/lang/String;)Lcom/navipilot/obf/NW;

    move-result-object p0

    const/4 p1, 0x0

    if-eqz p0, :cond_0

    iget-object p0, p0, Lcom/navipilot/obf/NW;->f:Ljava/util/LinkedHashMap;

    const-string v0, "stale_timeout_ms"

    invoke-virtual {p0, v0}, Ljava/util/LinkedHashMap;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    goto :goto_0

    :cond_0
    move-object p0, p1

    :goto_0
    instance-of v0, p0, Ljava/lang/Number;

    if-eqz v0, :cond_1

    move-object p1, p0

    check-cast p1, Ljava/lang/Number;

    :cond_1
    if-eqz p1, :cond_2

    invoke-virtual {p1}, Ljava/lang/Number;->longValue()J

    move-result-wide p0

    const-wide/16 v0, 0x1

    invoke-static {p0, p1, v0, v1}, Lcom/navipilot/obf/NG;->E(JJ)J

    move-result-wide p0

    goto :goto_1

    :cond_2
    const-wide/16 p0, 0x2710

    :goto_1
    return-wide p0
.end method

.method public final declared-synchronized g()V
    .locals 10

    monitor-enter p0

    :try_start_0
    iget-boolean v0, p0, Lcom/navipilot/obf/MG;->j:Z

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    invoke-virtual {v0}, Lcom/navipilot/obf/XG;->i()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/navipilot/obf/MG;->c:Lcom/navipilot/obf/tr;

    invoke-interface {v0}, Lcom/navipilot/obf/tr;->c()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/Number;

    invoke-virtual {v0}, Ljava/lang/Number;->longValue()J

    move-result-wide v8

    iget-object v0, p0, Lcom/navipilot/obf/MG;->g:Ljava/util/LinkedHashMap;

    new-instance v1, Ljava/util/LinkedHashMap;

    invoke-direct {v1}, Ljava/util/LinkedHashMap;-><init>()V

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map$Entry;

    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/LG;

    iget-boolean v3, v3, Lcom/navipilot/obf/LG;->a:Z

    if-eqz v3, :cond_0

    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v3

    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    invoke-virtual {v1, v3, v2}, Ljava/util/AbstractMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    :catchall_0
    move-exception v0

    goto :goto_2

    :cond_1
    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->keySet()Ljava/util/Set;

    move-result-object v0

    check-cast v0, Ljava/lang/Iterable;

    invoke-interface {v0}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    move-object v2, v1

    check-cast v2, Ljava/lang/String;
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :try_start_1
    iget-object v1, p0, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    const-string v5, "stream_stopped"

    const/4 v3, 0x0

    const/4 v4, 0x0

    move-wide v6, v8

    invoke-virtual/range {v1 .. v7}, Lcom/navipilot/obf/XG;->r(Ljava/lang/String;ZLorg/json/JSONObject;Ljava/lang/String;J)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    goto :goto_1

    :catchall_1
    move-exception v1

    :try_start_2
    invoke-static {v1}, Lcom/navipilot/obf/pE;->u(Ljava/lang/Throwable;)Lcom/navipilot/obf/MP;

    goto :goto_1

    :cond_2
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/navipilot/obf/MG;->j:Z

    iget-object v0, p0, Lcom/navipilot/obf/MG;->g:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V

    iget-object v0, p0, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-virtual {v0}, Ljava/util/LinkedHashMap;->clear()V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    monitor-exit p0

    return-void

    :goto_2
    :try_start_3
    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw v0
.end method

.method public final declared-synchronized h(Lcom/navipilot/obf/Ad;Z)V
    .locals 36

    move-object/from16 v8, p0

    move-object/from16 v0, p1

    move/from16 v9, p2

    const-string v11, "carrot v2 \u4e0d\u652f\u6301\u9053\u8def\u9650\u901f "

    monitor-enter p0

    :try_start_0
    iget-boolean v1, v8, Lcom/navipilot/obf/MG;->j:Z

    if-eqz v1, :cond_62

    iget-object v1, v8, Lcom/navipilot/obf/MG;->a:Lcom/navipilot/obf/XG;

    invoke-virtual {v1}, Lcom/navipilot/obf/XG;->i()Z

    move-result v1

    if-nez v1, :cond_0

    goto/16 :goto_4f

    :cond_0
    iget-object v1, v8, Lcom/navipilot/obf/MG;->c:Lcom/navipilot/obf/tr;

    invoke-interface {v1}, Lcom/navipilot/obf/tr;->c()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Number;

    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    move-result-wide v12

    iget-object v1, v8, Lcom/navipilot/obf/MG;->b:Lcom/navipilot/obf/IG;

    invoke-virtual {v1, v12, v13, v9}, Lcom/navipilot/obf/IG;->c(JZ)Lcom/navipilot/obf/HG;

    move-result-object v14

    const-string v1, "vehicle"

    invoke-virtual {v8, v1}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v4

    move-object v1, v14

    move-wide v2, v12

    move/from16 v6, p2

    invoke-virtual/range {v1 .. v6}, Lcom/navipilot/obf/HG;->i(JJZ)Lcom/navipilot/obf/GG;

    move-result-object v15

    iget-object v1, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-virtual {v1}, Ljava/util/LinkedHashMap;->clear()V

    iget-object v1, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->g()Ljava/util/Map;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Map;->putAll(Ljava/util/Map;)V

    if-eqz v15, :cond_1

    iget-object v1, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string v2, "vehicle"

    iget-wide v3, v15, Lcom/navipilot/obf/GG;->e:J

    invoke-static {v3, v4}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    invoke-interface {v1, v2, v3}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_0

    :catchall_0
    move-exception v0

    goto/16 :goto_50

    :cond_1
    :goto_0
    iget-object v1, v14, Lcom/navipilot/obf/HG;->h:Lcom/navipilot/obf/o4;

    const-wide/16 v16, 0x0

    if-eqz v1, :cond_2

    iget-wide v2, v1, Lcom/navipilot/obf/o4;->b:J

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v4

    cmp-long v2, v2, v4

    if-nez v2, :cond_2

    const-string v2, "guidance_current"

    invoke-virtual {v8, v2}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v1}, Lcom/navipilot/obf/o4;->c()J

    move-result-wide v4

    sub-long v4, v12, v4

    cmp-long v6, v16, v4

    if-gtz v6, :cond_2

    cmp-long v2, v4, v2

    if-gtz v2, :cond_2

    move-object v6, v1

    goto :goto_1

    :cond_2
    const/4 v6, 0x0

    :goto_1
    const-string v1, "vehicle"

    if-eqz v15, :cond_5

    invoke-virtual {v15}, Lcom/navipilot/obf/GG;->a()D

    move-result-wide v2

    move-object/from16 v18, v11

    invoke-virtual {v15}, Lcom/navipilot/obf/GG;->b()D

    move-result-wide v10

    iget-object v4, v15, Lcom/navipilot/obf/GG;->d:Ljava/lang/Double;

    iget-object v7, v15, Lcom/navipilot/obf/GG;->c:Ljava/lang/Double;

    invoke-virtual {v15}, Lcom/navipilot/obf/GG;->c()Ljava/lang/String;

    move-result-object v5

    move-object/from16 v20, v6

    new-instance v6, Lorg/json/JSONObject;

    invoke-direct {v6}, Lorg/json/JSONObject;-><init>()V

    move-object/from16 v21, v15

    const-string v15, "lat"

    invoke-virtual {v6, v15, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    const-string v2, "lon"

    invoke-virtual {v6, v2, v10, v11}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    if-eqz v4, :cond_3

    invoke-virtual {v4}, Ljava/lang/Number;->doubleValue()D

    move-result-wide v2

    const-string v4, "heading_deg"

    invoke-virtual {v6, v4, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    :cond_3
    if-eqz v7, :cond_4

    invoke-virtual {v7}, Ljava/lang/Number;->doubleValue()D

    move-result-wide v2

    const-string v4, "speed_kph"

    invoke-virtual {v6, v4, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    :cond_4
    const-string v2, "road_name"

    invoke-virtual {v6, v2, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "virtual_gps"

    const/4 v5, 0x0

    invoke-virtual {v6, v2, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    goto :goto_2

    :cond_5
    move-object/from16 v20, v6

    move-object/from16 v18, v11

    move-object/from16 v21, v15

    const/4 v5, 0x0

    const/4 v6, 0x0

    :goto_2
    invoke-static {v8, v1, v6}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->c()Lcom/navipilot/obf/O4;

    move-result-object v10

    if-eqz v10, :cond_7

    if-eqz v9, :cond_7

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_7

    invoke-virtual {v10}, Lcom/navipilot/obf/O4;->b()J

    move-result-wide v1

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v3

    cmp-long v1, v1, v3

    if-nez v1, :cond_7

    const-string v6, "road_category"

    const-string v7, "lane_current"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v12

    move v11, v5

    move-object/from16 v5, p0

    move-object/from16 v15, v20

    const/4 v11, 0x0

    invoke-static/range {v1 .. v7}, Lcom/navipilot/obf/MG;->j(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_6

    const-string v1, "lane_current"

    invoke-virtual {v8, v1}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v1

    iget-wide v3, v10, Lcom/navipilot/obf/O4;->c:J

    sub-long v3, v12, v3

    cmp-long v5, v16, v3

    if-gtz v5, :cond_6

    cmp-long v1, v3, v1

    if-gtz v1, :cond_6

    goto :goto_4

    :cond_6
    :goto_3
    move-object v10, v11

    goto :goto_4

    :cond_7
    move-object/from16 v15, v20

    const/4 v11, 0x0

    goto :goto_3

    :goto_4
    iget-object v1, v8, Lcom/navipilot/obf/MG;->e:Lcom/navipilot/obf/tr;

    invoke-interface {v1}, Lcom/navipilot/obf/tr;->c()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Boolean;

    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v7

    sget-object v1, Lcom/navipilot/obf/Iz;->a:Ljava/util/Set;

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->M1()I

    move-result v1

    invoke-static {v1, v10, v7}, Lcom/navipilot/obf/Iz;->a(ILcom/navipilot/obf/O4;Z)Z

    move-result v19

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->N1()I

    move-result v1

    invoke-static {v1, v10, v7}, Lcom/navipilot/obf/Iz;->a(ILcom/navipilot/obf/O4;Z)Z

    move-result v20

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_8

    const-string v6, "guidance_current"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v12

    move-object/from16 v5, p0

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_8

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->M1()I

    move-result v1

    if-ltz v1, :cond_8

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->J1()I

    move-result v1

    if-ltz v1, :cond_8

    const/16 v22, 0x1

    goto :goto_5

    :cond_8
    const/16 v22, 0x0

    :goto_5
    if-eqz v22, :cond_9

    if-nez v19, :cond_9

    const/16 v23, 0x1

    goto :goto_6

    :cond_9
    const/16 v23, 0x0

    :goto_6
    if-nez v20, :cond_a

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_a

    const-string v6, "guidance_next"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v12

    move-object/from16 v5, p0

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_a

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->N1()I

    move-result v1

    if-ltz v1, :cond_a

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->K1()I

    move-result v1

    if-ltz v1, :cond_a

    const/16 v24, 0x1

    goto :goto_7

    :cond_a
    const/16 v24, 0x0

    :goto_7
    const-string v6, "guidance_current"

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->M1()I

    move-result v25

    move v1, v7

    move-object v2, v10

    move-object/from16 v3, p0

    move-wide v4, v12

    move/from16 v26, v7

    move/from16 v7, v25

    invoke-static/range {v1 .. v7}, Lcom/navipilot/obf/MG;->i(ZLcom/navipilot/obf/O4;Lcom/navipilot/obf/MG;JLjava/lang/String;I)V

    const-string v6, "guidance_next"

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->N1()I

    move-result v7

    move/from16 v1, v26

    move-object v2, v10

    move-object/from16 v3, p0

    move-wide v4, v12

    invoke-static/range {v1 .. v7}, Lcom/navipilot/obf/MG;->i(ZLcom/navipilot/obf/O4;Lcom/navipilot/obf/MG;JLjava/lang/String;I)V

    const-string v1, "guidance_current"

    if-eqz v23, :cond_e

    new-instance v2, Lcom/navipilot/obf/es;

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->J1()I

    move-result v26

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->M1()I

    move-result v27

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->a2()Ljava/lang/String;

    move-result-object v28

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Y1()Ljava/lang/String;

    move-result-object v29

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->W1()Ljava/lang/String;

    move-result-object v30

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Z1()Ljava/lang/String;

    move-result-object v31

    const-string v3, "guidance_current"

    if-eqz v15, :cond_b

    invoke-virtual {v15}, Lcom/navipilot/obf/o4;->a()Ljava/lang/Integer;

    move-result-object v7

    goto :goto_8

    :cond_b
    move-object v7, v11

    :goto_8
    if-eqz v7, :cond_d

    if-eqz v15, :cond_c

    iget-wide v4, v15, Lcom/navipilot/obf/o4;->a:J

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    goto :goto_9

    :cond_c
    move-object v4, v11

    :goto_9
    iget-object v5, v14, Lcom/navipilot/obf/HG;->a:Ljava/util/Map;

    invoke-interface {v5, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v4, v3}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_d

    move-object/from16 v32, v7

    goto :goto_a

    :cond_d
    move-object/from16 v32, v11

    :goto_a
    const/16 v33, 0x310

    move-object/from16 v25, v2

    invoke-direct/range {v25 .. v33}, Lcom/navipilot/obf/es;-><init>(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;I)V

    invoke-virtual {v2}, Lcom/navipilot/obf/es;->a()Lorg/json/JSONObject;

    move-result-object v7

    goto :goto_b

    :cond_e
    move-object v7, v11

    :goto_b
    if-eqz v19, :cond_f

    const-string v2, "left_guidance_filtered"

    goto :goto_c

    :cond_f
    const-string v2, "source_absent_or_stale"

    :goto_c
    invoke-virtual {v8, v1, v7, v2}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    const-string v1, "guidance_next"

    if-eqz v24, :cond_13

    new-instance v2, Lcom/navipilot/obf/es;

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->K1()I

    move-result v26

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->N1()I

    move-result v27

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->b2()Ljava/lang/String;

    move-result-object v28

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->W1()Ljava/lang/String;

    move-result-object v29

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Y1()Ljava/lang/String;

    move-result-object v31

    const-string v3, "guidance_next"

    if-eqz v15, :cond_10

    invoke-virtual {v15}, Lcom/navipilot/obf/o4;->b()Ljava/lang/Integer;

    move-result-object v7

    goto :goto_d

    :cond_10
    move-object v7, v11

    :goto_d
    if-eqz v7, :cond_12

    if-eqz v15, :cond_11

    iget-wide v4, v15, Lcom/navipilot/obf/o4;->a:J

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    goto :goto_e

    :cond_11
    move-object v4, v11

    :goto_e
    iget-object v5, v14, Lcom/navipilot/obf/HG;->a:Ljava/util/Map;

    invoke-interface {v5, v3}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    invoke-static {v4, v3}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_12

    move-object/from16 v32, v7

    goto :goto_f

    :cond_12
    move-object/from16 v32, v11

    :goto_f
    const/16 v33, 0x330

    const/16 v30, 0x0

    move-object/from16 v25, v2

    invoke-direct/range {v25 .. v33}, Lcom/navipilot/obf/es;-><init>(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;I)V

    invoke-virtual {v2}, Lcom/navipilot/obf/es;->a()Lorg/json/JSONObject;

    move-result-object v7

    goto :goto_10

    :cond_13
    move-object v7, v11

    :goto_10
    if-eqz v20, :cond_14

    const-string v2, "left_guidance_filtered"

    goto :goto_11

    :cond_14
    const-string v2, "source_absent_or_stale"

    :goto_11
    invoke-virtual {v8, v1, v7, v2}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->d()Lcom/navipilot/obf/S4;

    move-result-object v7

    if-eqz v7, :cond_15

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_15

    invoke-virtual {v7}, Lcom/navipilot/obf/S4;->a()J

    move-result-wide v1

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v3

    cmp-long v1, v1, v3

    if-nez v1, :cond_15

    const-string v6, "route"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v12

    move-object/from16 v5, p0

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_15

    iget-object v1, v7, Lcom/navipilot/obf/S4;->a:Ljava/lang/Integer;

    if-eqz v1, :cond_15

    iget-object v1, v7, Lcom/navipilot/obf/S4;->b:Ljava/lang/Integer;

    if-eqz v1, :cond_15

    goto :goto_12

    :cond_15
    move-object v7, v11

    :goto_12
    if-eqz v7, :cond_16

    const/4 v15, 0x1

    goto :goto_13

    :cond_16
    const/4 v15, 0x0

    :goto_13
    const-string v1, "route"

    if-eqz v7, :cond_1b

    iget-object v2, v7, Lcom/navipilot/obf/S4;->a:Ljava/lang/Integer;

    if-eqz v2, :cond_1a

    invoke-virtual {v2}, Ljava/lang/Number;->intValue()I

    move-result v2

    invoke-virtual {v7}, Lcom/navipilot/obf/S4;->b()Ljava/lang/Integer;

    move-result-object v3

    if-eqz v3, :cond_17

    invoke-virtual {v3}, Ljava/lang/Number;->intValue()I

    move-result v4

    if-lt v4, v2, :cond_17

    goto :goto_14

    :cond_17
    move-object v3, v11

    :goto_14
    iget-object v4, v7, Lcom/navipilot/obf/S4;->b:Ljava/lang/Integer;

    if-eqz v4, :cond_19

    invoke-virtual {v4}, Ljava/lang/Number;->intValue()I

    move-result v4

    if-eqz v3, :cond_18

    invoke-virtual {v3}, Ljava/lang/Integer;->intValue()I

    move-result v5

    sub-int/2addr v5, v2

    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v7

    goto :goto_15

    :cond_18
    move-object v7, v11

    :goto_15
    new-instance v5, Lcom/navipilot/obf/JQ;

    invoke-direct {v5, v2, v4, v7, v3}, Lcom/navipilot/obf/JQ;-><init>(IILjava/lang/Integer;Ljava/lang/Integer;)V

    invoke-virtual {v5}, Lcom/navipilot/obf/JQ;->a()Lorg/json/JSONObject;

    move-result-object v7

    goto :goto_16

    :cond_19
    const-string v0, "Required value was null."

    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_1a
    const-string v0, "Required value was null."

    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_1b
    move-object v7, v11

    :goto_16
    invoke-static {v8, v1, v7}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_1d

    if-nez v22, :cond_1c

    if-eqz v15, :cond_1d

    :cond_1c
    const-string v6, "navigation_status"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v12

    move-object/from16 v5, p0

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1d

    const/4 v7, 0x1

    goto :goto_17

    :cond_1d
    const/4 v7, 0x0

    :goto_17
    const-string v1, "navigation_status"

    if-eqz v7, :cond_1e

    const-string v2, "guiding"

    goto :goto_18

    :cond_1e
    const-string v2, "idle"

    :goto_18
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3}, Lorg/json/JSONObject;-><init>()V

    const-string v4, "mode"

    invoke-virtual {v3, v4, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "guidance_active"

    invoke-virtual {v3, v2, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v2, "route_present"

    invoke-virtual {v3, v2, v15}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    invoke-static {v8, v1, v3}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    iget-object v1, v14, Lcom/navipilot/obf/HG;->k:Lcom/navipilot/obf/R4;

    if-eqz v1, :cond_1f

    if-eqz v9, :cond_1f

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v2

    if-eqz v2, :cond_1f

    iget-wide v2, v1, Lcom/navipilot/obf/R4;->b:J

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v4

    cmp-long v2, v2, v4

    if-nez v2, :cond_1f

    const-string v2, "speed"

    invoke-virtual {v8, v2}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v2

    invoke-virtual {v1}, Lcom/navipilot/obf/R4;->b()J

    move-result-wide v4

    sub-long v4, v12, v4

    cmp-long v6, v16, v4

    if-gtz v6, :cond_1f

    cmp-long v2, v4, v2

    if-gtz v2, :cond_1f

    goto :goto_19

    :cond_1f
    move-object v1, v11

    :goto_19
    if-eqz v1, :cond_20

    invoke-virtual {v1}, Lcom/navipilot/obf/R4;->a()Ljava/lang/Integer;

    move-result-object v2

    if-eqz v2, :cond_20

    iget-object v3, v1, Lcom/navipilot/obf/R4;->e:Ljava/lang/Long;

    if-eqz v3, :cond_20

    invoke-virtual {v3}, Ljava/lang/Number;->longValue()J

    move-result-wide v3

    const-string v5, "speed"

    invoke-virtual {v8, v5}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v5

    sub-long v3, v12, v3

    cmp-long v15, v16, v3

    if-gtz v15, :cond_20

    cmp-long v3, v3, v5

    if-gtz v3, :cond_20

    goto :goto_1a

    :cond_20
    move-object v2, v11

    :goto_1a
    iput-object v2, v8, Lcom/navipilot/obf/MG;->wideAmapPreAdjust:Ljava/lang/Integer;

    if-nez v2, :cond_22

    if-eqz v1, :cond_21

    iget v3, v1, Lcom/navipilot/obf/R4;->a:I

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    goto :goto_1b

    :cond_21
    move-object v3, v11

    goto :goto_1b

    :cond_22
    move-object v3, v2

    :goto_1b
    if-eqz v3, :cond_23

    invoke-virtual {v3}, Ljava/lang/Number;->intValue()I

    move-result v4

    const/16 v5, 0xa

    if-gt v5, v4, :cond_23

    const/16 v6, 0xc9

    if-ge v4, v6, :cond_23

    rem-int/2addr v4, v5

    if-nez v4, :cond_23

    move-object v4, v3

    goto :goto_1c

    :cond_23
    move-object v4, v11

    :goto_1c
    if-eqz v3, :cond_25

    if-nez v4, :cond_25

    iget-object v5, v8, Lcom/navipilot/obf/MG;->l:Ljava/lang/Integer;

    invoke-static {v5, v3}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :cond_25

    const-string v5, "NaviStreamMgr"

    new-instance v6, Ljava/lang/StringBuilder;

    move-object/from16 v15, v18

    invoke-direct {v6, v15}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v15, "\uff0c\u64a4\u9500\u8be5\u5b57\u6bb5\u800c\u4e0d\u662f\u4f2a\u9020\u9650\u901f"

    invoke-virtual {v6, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    iput-object v3, v8, Lcom/navipilot/obf/MG;->l:Ljava/lang/Integer;

    :cond_24
    :goto_1d
    const/4 v3, 0x0

    goto :goto_1e

    :cond_25
    if-eqz v4, :cond_24

    iput-object v11, v8, Lcom/navipilot/obf/MG;->l:Ljava/lang/Integer;

    goto :goto_1d

    :goto_1e
    invoke-static {v0, v3}, Lcom/navipilot/obf/MG;->d(Lcom/navipilot/obf/Ad;Z)Lorg/json/JSONObject;

    move-result-object v5

    const/4 v3, 0x1

    invoke-static {v0, v3}, Lcom/navipilot/obf/MG;->d(Lcom/navipilot/obf/Ad;Z)Lorg/json/JSONObject;

    move-result-object v6

    if-eqz v21, :cond_26

    move-wide/from16 v18, v12

    move-object/from16 v15, v21

    iget-wide v11, v15, Lcom/navipilot/obf/GG;->e:J

    invoke-static {v11, v12}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v3

    goto :goto_1f

    :cond_26
    move-wide/from16 v18, v12

    move-object/from16 v15, v21

    const/4 v3, 0x0

    :goto_1f
    if-eqz v1, :cond_28

    if-eqz v2, :cond_27

    invoke-virtual {v1}, Lcom/navipilot/obf/R4;->b()J

    move-result-wide v11

    iget-object v1, v1, Lcom/navipilot/obf/R4;->e:Ljava/lang/Long;

    invoke-static {v1}, Lcom/navipilot/obf/tv;->r(Ljava/lang/Object;)V

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    invoke-static {v11, v12, v1, v2}, Ljava/lang/Math;->min(JJ)J

    move-result-wide v1

    goto :goto_20

    :cond_27
    invoke-virtual {v1}, Lcom/navipilot/obf/R4;->b()J

    move-result-wide v1

    :goto_20
    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    if-eqz v4, :cond_28

    goto :goto_21

    :cond_28
    const/4 v1, 0x0

    :goto_21
    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->e()Lcom/navipilot/obf/T4;

    move-result-object v2

    if-eqz v2, :cond_29

    invoke-virtual {v2}, Lcom/navipilot/obf/T4;->a()J

    move-result-wide v11

    invoke-static {v11, v12}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    if-eqz v5, :cond_29

    goto :goto_22

    :cond_29
    const/4 v2, 0x0

    :goto_22
    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->f()Lcom/navipilot/obf/W4;

    move-result-object v11

    if-eqz v11, :cond_2a

    invoke-virtual {v11}, Lcom/navipilot/obf/W4;->a()J

    move-result-wide v11

    invoke-static {v11, v12}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v11

    if-eqz v5, :cond_2a

    goto :goto_23

    :cond_2a
    const/4 v11, 0x0

    :goto_23
    filled-new-array {v3, v1, v2, v11}, [Ljava/lang/Long;

    move-result-object v1

    invoke-static {v1}, Lcom/navipilot/obf/r9;->i0([Ljava/lang/Object;)Ljava/util/ArrayList;

    move-result-object v1

    invoke-static {v1}, Lcom/navipilot/obf/If;->P0(Ljava/util/ArrayList;)Ljava/lang/Comparable;

    move-result-object v1

    check-cast v1, Ljava/lang/Long;

    if-eqz v1, :cond_2b

    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    iget-object v2, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string v3, "speed"

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_2b
    if-eqz v15, :cond_2c

    iget-object v1, v15, Lcom/navipilot/obf/GG;->c:Ljava/lang/Double;

    goto :goto_24

    :cond_2c
    const/4 v1, 0x0

    :goto_24
    new-instance v2, Lcom/navipilot/obf/iW;

    invoke-direct {v2, v1, v4, v6, v5}, Lcom/navipilot/obf/iW;-><init>(Ljava/lang/Double;Ljava/lang/Integer;Lorg/json/JSONObject;Lorg/json/JSONObject;)V

    const-string v1, "speed"

    if-nez v4, :cond_2e

    if-nez v5, :cond_2e

    if-eqz v6, :cond_2d

    goto :goto_25

    :cond_2d
    const/4 v2, 0x0

    goto :goto_26

    :cond_2e
    :goto_25
    invoke-virtual {v2}, Lcom/navipilot/obf/iW;->a()Lorg/json/JSONObject;

    move-result-object v2

    :goto_26
    iget-object v3, v8, Lcom/navipilot/obf/MG;->wideAmapPreAdjust:Ljava/lang/Integer;

    invoke-static {v2, v3}, Lcom/navipilot/obf/WideAmapPreAdjust;->mark(Lorg/json/JSONObject;Ljava/lang/Integer;)Lorg/json/JSONObject;

    move-result-object v2

    invoke-static {v8, v1, v2}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->b()Lcom/navipilot/obf/N4;

    move-result-object v1

    if-eqz v1, :cond_2f

    if-eqz v9, :cond_2f

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v2

    if-eqz v2, :cond_2f

    iget-wide v2, v1, Lcom/navipilot/obf/N4;->d:J

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v4

    cmp-long v2, v2, v4

    if-nez v2, :cond_2f

    const-string v2, "traffic_signal"

    invoke-virtual {v8, v2}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v2

    iget-wide v4, v1, Lcom/navipilot/obf/N4;->e:J

    sub-long v4, v18, v4

    cmp-long v6, v16, v4

    if-gtz v6, :cond_2f

    cmp-long v2, v4, v2

    if-gtz v2, :cond_2f

    goto :goto_27

    :cond_2f
    const/4 v1, 0x0

    :goto_27
    if-eqz v1, :cond_30

    iget-object v2, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string v3, "traffic_signal"

    iget-wide v4, v1, Lcom/navipilot/obf/N4;->e:J

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-interface {v2, v3, v4}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_30
    if-eqz v1, :cond_31

    move-wide/from16 v11, v18

    invoke-virtual {v1, v11, v12}, Lcom/navipilot/obf/N4;->a(J)Lcom/navipilot/obf/K00;

    move-result-object v1

    goto :goto_28

    :cond_31
    move-wide/from16 v11, v18

    const/4 v1, 0x0

    :goto_28
    iget-object v2, v8, Lcom/navipilot/obf/MG;->d:Lcom/navipilot/obf/bT;

    invoke-virtual {v2}, Lcom/navipilot/obf/bT;->t()Lcom/navipilot/obf/EU;

    move-result-object v2

    if-eqz v2, :cond_32

    iget-object v3, v2, Lcom/navipilot/obf/EU;->d:Ljava/lang/Long;

    invoke-virtual {v3}, Ljava/lang/Number;->longValue()J

    move-result-wide v3

    sub-long v3, v11, v3

    cmp-long v5, v16, v3

    if-gtz v5, :cond_32

    const-wide/16 v5, 0x5dd

    cmp-long v3, v3, v5

    if-gez v3, :cond_32

    goto :goto_29

    :cond_32
    const/4 v2, 0x0

    :goto_29
    iput-object v2, v8, Lcom/navipilot/obf/MG;->m:Lcom/navipilot/obf/EU;

    invoke-static {v1, v2}, Lcom/navipilot/obf/VQ;->h(Lcom/navipilot/obf/K00;Lcom/navipilot/obf/EU;)Ljava/lang/String;

    move-result-object v3

    iput-object v3, v8, Lcom/navipilot/obf/MG;->n:Ljava/lang/String;

    invoke-static {v1, v2}, Lcom/navipilot/obf/VQ;->i(Lcom/navipilot/obf/K00;Lcom/navipilot/obf/EU;)Lcom/navipilot/obf/K00;

    move-result-object v1

    iget-object v3, v8, Lcom/navipilot/obf/MG;->n:Ljava/lang/String;

    const-string v4, "car"

    invoke-static {v3, v4}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_34

    iget-object v3, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string v4, "traffic_signal"

    if-eqz v2, :cond_33

    iget-object v5, v2, Lcom/navipilot/obf/EU;->d:Ljava/lang/Long;

    invoke-virtual {v5}, Ljava/lang/Long;->longValue()J

    move-result-wide v5

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v5

    invoke-interface {v3, v4, v5}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    goto :goto_2a

    :cond_33
    const-string v0, "Required value was null."

    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_34
    :goto_2a
    const-string v3, "traffic_signal"

    if-eqz v1, :cond_35

    invoke-virtual {v1}, Lcom/navipilot/obf/K00;->b()Lorg/json/JSONObject;

    move-result-object v4

    goto :goto_2b

    :cond_35
    const/4 v4, 0x0

    :goto_2b
    if-eqz v1, :cond_36

    const-string v1, "source_absent_or_stale"

    goto :goto_2d

    :cond_36
    iget-object v1, v8, Lcom/navipilot/obf/MG;->n:Ljava/lang/String;

    const-string v5, "car_yellow_unsupported"

    invoke-static {v1, v5}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_37

    const-string v1, "car_yellow_not_representable"

    goto :goto_2d

    :cond_37
    if-eqz v2, :cond_39

    iget v1, v2, Lcom/navipilot/obf/EU;->b:I

    const/4 v5, 0x1

    if-gt v5, v1, :cond_38

    const/4 v6, 0x4

    if-ge v1, v6, :cond_38

    move v1, v5

    goto :goto_2c

    :cond_38
    const/4 v1, 0x0

    :goto_2c
    if-ne v1, v5, :cond_39

    invoke-virtual {v2}, Lcom/navipilot/obf/EU;->a()Z

    move-result v1

    if-nez v1, :cond_39

    const-string v1, "car_signal_distance_out_of_range"

    goto :goto_2d

    :cond_39
    const-string v1, "signal_source_missing_unverified_or_expired"

    :goto_2d
    invoke-virtual {v8, v3, v4, v1}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->a()Lcom/navipilot/obf/t4;

    move-result-object v6

    if-eqz v6, :cond_3a

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v1

    if-eqz v1, :cond_3a

    iget-wide v1, v6, Lcom/navipilot/obf/t4;->b:J

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v3

    cmp-long v1, v1, v3

    if-nez v1, :cond_3a

    const-string v18, "lane_current"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v11

    move-object/from16 v5, p0

    move-object v13, v6

    move-object/from16 v6, v18

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_3a

    const-string v1, "lane_current"

    invoke-virtual {v8, v1}, Lcom/navipilot/obf/MG;->f(Ljava/lang/String;)J

    move-result-wide v1

    iget-wide v3, v13, Lcom/navipilot/obf/t4;->c:J

    sub-long v3, v11, v3

    cmp-long v5, v16, v3

    if-gtz v5, :cond_3a

    cmp-long v1, v3, v1

    if-gtz v1, :cond_3a

    move-object v6, v13

    goto :goto_2e

    :cond_3a
    const/4 v6, 0x0

    :goto_2e
    if-eqz v6, :cond_3d

    invoke-virtual {v6}, Lcom/navipilot/obf/t4;->a()Ljava/util/List;

    move-result-object v1

    if-eqz v1, :cond_3d

    new-instance v2, Ljava/util/ArrayList;

    invoke-static {v1}, Lcom/navipilot/obf/Kf;->x0(Ljava/lang/Iterable;)I

    move-result v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :goto_2f
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_3b

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Lcom/navipilot/obf/Gx;

    iget v4, v4, Lcom/navipilot/obf/Gx;->c:I

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_2f

    :cond_3b
    invoke-static {v2}, Lcom/navipilot/obf/If;->S0(Ljava/lang/Iterable;)Ljava/util/List;

    move-result-object v2

    invoke-static {v1}, Lcom/navipilot/obf/Jf;->r0(Ljava/util/Collection;)Lcom/navipilot/obf/av;

    move-result-object v3

    invoke-static {v3}, Lcom/navipilot/obf/If;->W0(Ljava/lang/Iterable;)Ljava/util/List;

    move-result-object v3

    invoke-static {v2, v3}, Lcom/navipilot/obf/tv;->o(Ljava/lang/Object;Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3c

    goto :goto_30

    :cond_3c
    const/4 v1, 0x0

    :goto_30
    if-eqz v1, :cond_3d

    new-instance v2, Lcom/navipilot/obf/N5;

    const/16 v3, 0xc

    invoke-direct {v2, v3}, Lcom/navipilot/obf/N5;-><init>(I)V

    invoke-static {v1, v2}, Lcom/navipilot/obf/If;->T0(Ljava/util/List;Ljava/util/Comparator;)Ljava/util/List;

    move-result-object v1

    goto :goto_31

    :cond_3d
    const/4 v1, 0x0

    :goto_31
    if-nez v1, :cond_3e

    sget-object v1, Lcom/navipilot/obf/Jo;->d:Lcom/navipilot/obf/Jo;

    :cond_3e
    new-instance v5, Ljava/util/ArrayList;

    invoke-static {v1}, Lcom/navipilot/obf/Kf;->x0(Ljava/lang/Iterable;)I

    move-result v2

    invoke-direct {v5, v2}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/16 v25, 0x0

    :goto_32
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_40

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    const/4 v3, 0x1

    add-int/lit8 v4, v25, 0x1

    if-ltz v25, :cond_3f

    check-cast v2, Lcom/navipilot/obf/Gx;

    new-instance v3, Lcom/navipilot/obf/Hx;

    iget-object v13, v2, Lcom/navipilot/obf/Gx;->a:Ljava/lang/String;

    iget-boolean v0, v2, Lcom/navipilot/obf/Gx;->b:Z

    move-object/from16 v16, v1

    iget v1, v2, Lcom/navipilot/obf/Gx;->c:I

    invoke-virtual {v2}, Lcom/navipilot/obf/Gx;->a()Ljava/lang/String;

    move-result-object v29

    invoke-virtual {v2}, Lcom/navipilot/obf/Gx;->d()I

    move-result v30

    invoke-virtual {v2}, Lcom/navipilot/obf/Gx;->e()I

    move-result v31

    invoke-virtual {v2}, Lcom/navipilot/obf/Gx;->b()Ljava/lang/Integer;

    move-result-object v32

    invoke-virtual {v2}, Lcom/navipilot/obf/Gx;->c()Ljava/lang/Integer;

    move-result-object v33

    move-object/from16 v24, v3

    move-object/from16 v26, v13

    move/from16 v27, v0

    move/from16 v28, v1

    invoke-direct/range {v24 .. v33}, Lcom/navipilot/obf/Hx;-><init>(ILjava/lang/String;ZILjava/lang/String;IILjava/lang/Integer;Ljava/lang/Integer;)V

    invoke-virtual {v5, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    move-object/from16 v0, p1

    move/from16 v25, v4

    move-object/from16 v1, v16

    goto :goto_32

    :cond_3f
    invoke-static {}, Lcom/navipilot/obf/Jf;->w0()V

    const/4 v0, 0x0

    throw v0

    :cond_40
    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v0

    if-eqz v0, :cond_41

    const-string v0, "lane_current"

    move/from16 v1, p2

    move-object v2, v14

    move-wide v3, v11

    move-object v9, v5

    move-object/from16 v5, p0

    move-object v11, v6

    move-object v6, v0

    invoke-static/range {v1 .. v6}, Lcom/navipilot/obf/MG;->k(ZLcom/navipilot/obf/HG;JLcom/navipilot/obf/MG;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_42

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->i1()Z

    move-result v0

    if-nez v0, :cond_42

    invoke-virtual {v9}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_42

    const/4 v5, 0x1

    goto :goto_33

    :cond_41
    move-object v9, v5

    move-object v11, v6

    :cond_42
    const/4 v5, 0x0

    :goto_33
    if-eqz v10, :cond_43

    invoke-virtual {v10}, Lcom/navipilot/obf/O4;->a()Ljava/lang/Integer;

    move-result-object v0

    goto :goto_34

    :cond_43
    const/4 v0, 0x0

    :goto_34
    if-eqz v11, :cond_44

    iget-wide v1, v11, Lcom/navipilot/obf/t4;->c:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    if-eqz v5, :cond_44

    goto :goto_35

    :cond_44
    const/4 v1, 0x0

    :goto_35
    if-eqz v10, :cond_45

    iget-wide v2, v10, Lcom/navipilot/obf/O4;->c:J

    invoke-static {v2, v3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v2

    if-eqz v0, :cond_45

    goto :goto_36

    :cond_45
    const/4 v2, 0x0

    :goto_36
    invoke-virtual {v14}, Lcom/navipilot/obf/HG;->g()Ljava/util/Map;

    move-result-object v3

    const-string v4, "guidance_current"

    invoke-interface {v3, v4}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Long;

    if-eqz v3, :cond_46

    if-eqz v5, :cond_46

    if-eqz v23, :cond_46

    goto :goto_37

    :cond_46
    const/4 v3, 0x0

    :goto_37
    filled-new-array {v1, v2, v3}, [Ljava/lang/Long;

    move-result-object v1

    invoke-static {v1}, Lcom/navipilot/obf/r9;->i0([Ljava/lang/Object;)Ljava/util/ArrayList;

    move-result-object v1

    invoke-static {v1}, Lcom/navipilot/obf/If;->P0(Ljava/util/ArrayList;)Ljava/lang/Comparable;

    move-result-object v1

    check-cast v1, Ljava/lang/Long;

    if-eqz v1, :cond_47

    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    move-result-wide v1

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    iget-object v2, v8, Lcom/navipilot/obf/MG;->i:Ljava/util/LinkedHashMap;

    const-string v3, "lane_current"

    invoke-interface {v2, v3, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :cond_47
    if-eqz v5, :cond_48

    move-object/from16 v26, v9

    goto :goto_38

    :cond_48
    sget-object v1, Lcom/navipilot/obf/Jo;->d:Lcom/navipilot/obf/Jo;

    move-object/from16 v26, v1

    :goto_38
    if-eqz v5, :cond_4a

    new-instance v1, Ljava/util/ArrayList;

    invoke-static/range {v26 .. v26}, Lcom/navipilot/obf/Kf;->x0(Ljava/lang/Iterable;)I

    move-result v2

    invoke-direct {v1, v2}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface/range {v26 .. v26}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_39
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_49

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/Hx;

    invoke-virtual {v3}, Lcom/navipilot/obf/Hx;->a()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_39

    :cond_49
    invoke-static {v1}, Lcom/navipilot/obf/C40;->l(Ljava/util/ArrayList;)Ljava/util/ArrayList;

    move-result-object v1

    move-object/from16 v33, v1

    goto :goto_3a

    :cond_4a
    const/16 v33, 0x0

    :goto_3a
    new-instance v1, Ljava/util/ArrayList;

    invoke-static/range {v26 .. v26}, Lcom/navipilot/obf/Kf;->x0(Ljava/lang/Iterable;)I

    move-result v2

    invoke-direct {v1, v2}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface/range {v26 .. v26}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_3b
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4b

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/Hx;

    invoke-virtual {v3}, Lcom/navipilot/obf/Hx;->b()Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_3b

    :cond_4b
    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_4d

    invoke-virtual {v1}, Ljava/util/ArrayList;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_4c

    goto :goto_3d

    :cond_4c
    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_3c
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_4e

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    if-eqz v3, :cond_4d

    goto :goto_3c

    :cond_4d
    const/4 v1, 0x0

    :cond_4e
    :goto_3d
    if-eqz v1, :cond_51

    new-instance v2, Ljava/util/ArrayList;

    invoke-static {v1}, Lcom/navipilot/obf/Kf;->x0(Ljava/lang/Iterable;)I

    move-result v3

    invoke-direct {v2, v3}, Ljava/util/ArrayList;-><init>(I)V

    invoke-interface {v1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_3e
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_50

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Integer;

    if-eqz v3, :cond_4f

    invoke-virtual {v3}, Ljava/lang/Number;->intValue()I

    move-result v3

    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_3e

    :cond_4f
    const-string v0, "Required value was null."

    new-instance v1, Ljava/lang/IllegalArgumentException;

    invoke-direct {v1, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v1

    :cond_50
    move-object/from16 v34, v2

    goto :goto_3f

    :cond_51
    const/16 v34, 0x0

    :goto_3f
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    invoke-interface/range {v26 .. v26}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_52
    :goto_40
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_53

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/Hx;

    invoke-virtual {v3}, Lcom/navipilot/obf/Hx;->c()Ljava/lang/Integer;

    move-result-object v3

    if-eqz v3, :cond_52

    invoke-virtual {v1, v3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_40

    :cond_53
    invoke-static {v1}, Lcom/navipilot/obf/If;->C0(Ljava/util/ArrayList;)Ljava/util/List;

    move-result-object v1

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_54

    const/4 v2, 0x0

    invoke-interface {v1, v2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v1

    goto :goto_41

    :cond_54
    const/4 v1, 0x0

    :goto_41
    move-object/from16 v35, v1

    check-cast v35, Ljava/lang/Integer;

    invoke-interface/range {v26 .. v26}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    const/4 v2, 0x0

    :goto_42
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    const/4 v4, -0x1

    if-eqz v3, :cond_56

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/Hx;

    invoke-virtual {v3}, Lcom/navipilot/obf/Hx;->d()Z

    move-result v3

    if-eqz v3, :cond_55

    const/4 v3, 0x1

    goto :goto_43

    :cond_55
    const/4 v3, 0x1

    add-int/2addr v2, v3

    goto :goto_42

    :cond_56
    const/4 v3, 0x1

    move v2, v4

    :goto_43
    if-eqz v5, :cond_57

    if-ltz v2, :cond_57

    add-int/2addr v2, v3

    move/from16 v30, v2

    goto :goto_44

    :cond_57
    move/from16 v30, v4

    :goto_44
    const-string v1, "lane_current"

    if-eqz v0, :cond_5a

    invoke-interface/range {v26 .. v26}, Ljava/util/List;->size()I

    move-result v25

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->J1()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    if-eqz v5, :cond_58

    if-eqz v23, :cond_58

    move-object/from16 v27, v2

    goto :goto_45

    :cond_58
    const/16 v27, 0x0

    :goto_45
    if-eqz v5, :cond_59

    if-eqz v23, :cond_59

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->M1()I

    move-result v2

    move/from16 v31, v2

    goto :goto_46

    :cond_59
    move/from16 v31, v4

    :goto_46
    new-instance v2, Lcom/navipilot/obf/Bx;

    move-object/from16 v24, v2

    move/from16 v28, v5

    move/from16 v29, v5

    move-object/from16 v32, v0

    invoke-direct/range {v24 .. v35}, Lcom/navipilot/obf/Bx;-><init>(ILjava/util/List;Ljava/lang/Integer;ZZIILjava/lang/Integer;Ljava/util/ArrayList;Ljava/util/ArrayList;Ljava/lang/Integer;)V

    invoke-virtual {v2}, Lcom/navipilot/obf/Bx;->a()Lorg/json/JSONObject;

    move-result-object v2

    goto :goto_47

    :cond_5a
    const/4 v2, 0x0

    :goto_47
    if-eqz v5, :cond_5b

    if-nez v0, :cond_5b

    const-string v0, "unknown_road_category_receiver_compat"

    goto :goto_48

    :cond_5b
    const-string v0, "source_absent_or_stale"

    :goto_48
    invoke-virtual {v8, v1, v2, v0}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    const-string v0, "lane_ahead"

    const-string v1, "next_junction_lane_map_absent"

    const/4 v2, 0x0

    invoke-virtual {v8, v0, v2, v1}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->m2()Z

    move-result v0

    if-eqz v0, :cond_5c

    if-eqz v23, :cond_5c

    if-eqz v5, :cond_5c

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->J1()I

    move-result v0

    if-ltz v0, :cond_5c

    const/16 v1, 0x7d1

    if-ge v0, v1, :cond_5c

    const/4 v0, 0x1

    goto :goto_49

    :cond_5c
    const/4 v0, 0x0

    :goto_49
    const-string v1, "crossroad"

    if-eqz v0, :cond_5d

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->J1()I

    move-result v0

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "visible"

    const/4 v4, 0x1

    invoke-virtual {v2, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v3, "distance_m"

    invoke-virtual {v2, v3, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    goto :goto_4a

    :cond_5d
    const/4 v4, 0x1

    :goto_4a
    if-eqz v23, :cond_5e

    const-string v0, "crossroad_image_absent"

    goto :goto_4b

    :cond_5e
    const-string v0, "source_absent_or_stale"

    :goto_4b
    invoke-virtual {v8, v1, v2, v0}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    iget-object v0, v8, Lcom/navipilot/obf/MG;->f:Lcom/navipilot/obf/tr;

    invoke-interface {v0}, Lcom/navipilot/obf/tr;->c()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Lcom/navipilot/obf/DG;

    const-string v1, "camera_state"

    invoke-virtual {v0}, Lcom/navipilot/obf/DG;->c()Z

    move-result v2

    if-eqz v2, :cond_5f

    const-string v2, "mirror"

    goto :goto_4c

    :cond_5f
    const-string v2, "idle"

    :goto_4c
    invoke-virtual {v0}, Lcom/navipilot/obf/DG;->a()I

    move-result v3

    if-ltz v3, :cond_60

    move v10, v4

    goto :goto_4d

    :cond_60
    const/4 v10, 0x0

    :goto_4d
    if-eqz v15, :cond_61

    iget-object v3, v15, Lcom/navipilot/obf/GG;->d:Ljava/lang/Double;

    if-eqz v3, :cond_61

    invoke-virtual {v3}, Ljava/lang/Double;->doubleValue()D

    move-result-wide v3

    goto :goto_4e

    :cond_61
    const-wide/16 v3, 0x0

    :goto_4e
    invoke-static {v3, v4}, Lcom/navipilot/obf/pE;->Z(D)I

    move-result v3

    rem-int/lit16 v3, v3, 0x168

    add-int/lit16 v3, v3, 0x168

    rem-int/lit16 v3, v3, 0x168

    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "camera_mode"

    invoke-virtual {v4, v6, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    const-string v2, "view_level"

    invoke-virtual {v4, v2, v10}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "view_sub_level"

    const/4 v6, 0x0

    invoke-virtual {v4, v2, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "tilt"

    invoke-virtual {v4, v2, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    const-string v2, "bearing"

    invoke-virtual {v4, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    invoke-static {v8, v1, v4}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    const-string v1, "composition_state"

    invoke-virtual {v0}, Lcom/navipilot/obf/DG;->b()Z

    move-result v0

    invoke-virtual/range {p1 .. p1}, Lcom/navipilot/obf/Ad;->Q1()J

    move-result-wide v2

    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4}, Lorg/json/JSONObject;-><init>()V

    const-string v6, "map_active"

    invoke-virtual {v4, v6, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v0, "navi_active"

    invoke-virtual {v4, v0, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v0, "overlay_active"

    invoke-virtual {v4, v0, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    const-string v0, "generation"

    invoke-virtual {v4, v0, v2, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;J)Lorg/json/JSONObject;

    invoke-static {v8, v1, v4}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V

    const-string v0, "app_status"

    iget-boolean v1, v8, Lcom/navipilot/obf/MG;->k:Z

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2}, Lorg/json/JSONObject;-><init>()V

    const-string v3, "foreground"

    invoke-virtual {v2, v3, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    invoke-static {v8, v0, v2}, Lcom/navipilot/obf/MG;->c(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit p0

    return-void

    :cond_62
    :goto_4f
    monitor-exit p0

    return-void

    :goto_50
    :try_start_1
    monitor-exit p0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v0
.end method
