.class public final Lcom/navipilot/obf/WideGoogleAdapter;
.super Ljava/lang/Object;
.source "WideGoogleAdapter.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;
    }
.end annotation


# static fields
.field public static final TTL:J = 0xbb8L


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 4
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static coordinate(DD)Z
    .registers 6

    .line 57
    invoke-static {p0, p1}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_28

    invoke-static {p2, p3}, Ljava/lang/Double;->isFinite(D)Z

    move-result v0

    if-eqz v0, :cond_28

    invoke-static {p0, p1}, Ljava/lang/Math;->abs(D)D

    move-result-wide p0

    const-wide v0, 0x4056800000000000L    # 90.0

    cmpg-double p0, p0, v0

    if-gtz p0, :cond_28

    invoke-static {p2, p3}, Ljava/lang/Math;->abs(D)D

    move-result-wide p0

    const-wide p2, 0x4066800000000000L    # 180.0

    cmpg-double p0, p0, p2

    if-gtz p0, :cond_28

    const/4 p0, 0x1

    return p0

    :cond_28
    const/4 p0, 0x0

    return p0
.end method

.method static guidance(Lorg/json/JSONObject;I)Lorg/json/JSONObject;
    .registers 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 27
    if-eqz p0, :cond_5c

    if-ltz p1, :cond_5c

    const v0, 0x186a0

    if-le p1, v0, :cond_a

    goto :goto_5c

    .line 28
    :cond_a
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "distance_m"

    invoke-virtual {v0, v1, p1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object p1

    const-string v0, "maneuver"

    invoke-virtual {p0, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "modifier"

    invoke-virtual {p0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Lcom/navipilot/obf/WideGoogleAdapter;->turn(Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    const-string v2, "turn_type"

    invoke-virtual {p1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object p1

    .line 29
    const-string v0, "road"

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideGoogleAdapter;->text(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "road_name"

    invoke-virtual {p1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    const-string v0, "instruction"

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideGoogleAdapter;->text(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v2, "main_text"

    invoke-virtual {p1, v2, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p1

    const-string v0, "near_direction"

    invoke-static {p0, v1}, Lcom/navipilot/obf/WideGoogleAdapter;->text(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, v0, p0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p0

    const-string p1, "mid_direction"

    const-string v0, ""

    invoke-virtual {p0, p1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p0

    const-string p1, "far_direction"

    invoke-virtual {p0, p1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object p0

    .line 28
    return-object p0

    .line 27
    :cond_5c
    :goto_5c
    const/4 p0, 0x0

    return-object p0
.end method

.method static num(Lorg/json/JSONObject;Ljava/lang/String;I)I
    .registers 6

    .line 15
    const/4 v0, -0x1

    if-eqz p0, :cond_28

    invoke-virtual {p0, p1}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    instance-of v1, v1, Ljava/lang/Number;

    if-nez v1, :cond_c

    goto :goto_28

    :cond_c
    const-wide/high16 v1, 0x7ff8000000000000L    # Double.NaN

    invoke-virtual {p0, p1, v1, v2}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide p0

    invoke-static {p0, p1}, Ljava/lang/Double;->isFinite(D)Z

    move-result v1

    if-eqz v1, :cond_28

    const-wide/16 v1, 0x0

    cmpl-double v1, p0, v1

    if-ltz v1, :cond_28

    int-to-double v1, p2

    cmpg-double p2, p0, v1

    if-gtz p2, :cond_28

    invoke-static {p0, p1}, Ljava/lang/Math;->round(D)J

    move-result-wide p0

    long-to-int v0, p0

    :cond_28
    :goto_28
    return v0
.end method

.method public static parse(Lorg/json/JSONObject;Lorg/json/JSONObject;J)Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;
    .registers 39
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 32
    move-object/from16 v0, p0

    move-object/from16 v1, p1

    if-eqz v0, :cond_24a

    const-string v2, "v"

    const/4 v3, -0x1

    invoke-virtual {v0, v2, v3}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v2

    const/4 v3, 0x1

    if-ne v2, v3, :cond_24a

    .line 33
    const-string v2, "state"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 34
    const-string v4, "sessionId"

    const-string v5, ""

    invoke-virtual {v0, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_242

    .line 35
    sget-object v6, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    const-string v7, "simulated"

    invoke-virtual {v0, v7}, Lorg/json/JSONObject;->opt(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/Boolean;->equals(Ljava/lang/Object;)Z

    move-result v6

    const-string v7, "route_present"

    const-string v8, "guidance_active"

    const-string v9, "mode"

    if-eqz v6, :cond_21b

    const-string v6, "navigating"

    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_45

    move-object v1, v7

    move-object v4, v8

    move-object v3, v9

    goto/16 :goto_21e

    .line 36
    :cond_45
    const-string v2, "navAgeMs"

    const/16 v6, 0xbb8

    invoke-static {v0, v2, v6}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v2

    const-string v11, "loc"

    invoke-virtual {v0, v11}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v11

    const-string v12, "ageMs"

    invoke-static {v11, v12, v6}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v6

    .line 37
    if-ltz v2, :cond_213

    if-ltz v6, :cond_213

    .line 38
    const-string v12, "lat"

    const-wide/high16 v13, 0x7ff8000000000000L    # Double.NaN

    move-object/from16 v16, v4

    invoke-virtual {v11, v12, v13, v14}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v3

    const-string v15, "lng"

    move-object/from16 v17, v5

    move/from16 v18, v6

    invoke-virtual {v11, v15, v13, v14}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v5

    const-string v15, "acc"

    invoke-virtual {v11, v15, v13, v14}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v19

    .line 39
    invoke-static {v3, v4, v5, v6}, Lcom/navipilot/obf/WideGoogleAdapter;->coordinate(DD)Z

    move-result v15

    if-eqz v15, :cond_20b

    invoke-static/range {v19 .. v20}, Ljava/lang/Double;->isFinite(D)Z

    move-result v15

    if-eqz v15, :cond_20b

    const-wide/16 v21, 0x0

    cmpg-double v15, v19, v21

    if-ltz v15, :cond_20b

    const-wide/high16 v23, 0x4049000000000000L    # 50.0

    cmpl-double v15, v19, v23

    if-gtz v15, :cond_20b

    .line 40
    const-string v15, "step"

    invoke-virtual {v0, v15}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v15

    const-string v13, "dist"

    const v14, 0x186a0

    invoke-static {v15, v13, v14}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v10

    invoke-static {v15, v10}, Lcom/navipilot/obf/WideGoogleAdapter;->guidance(Lorg/json/JSONObject;I)Lorg/json/JSONObject;

    move-result-object v14

    .line 41
    move/from16 v25, v10

    const-string v10, "time"

    if-eqz v14, :cond_bb

    move/from16 v26, v2

    const v2, 0x15180

    invoke-static {v15, v10, v2}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v2

    if-ltz v2, :cond_bd

    move-object/from16 v27, v7

    const-string v7, "time_sec"

    invoke-virtual {v14, v7, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    goto :goto_bf

    :cond_bb
    move/from16 v26, v2

    :cond_bd
    move-object/from16 v27, v7

    .line 42
    :goto_bf
    const-string v2, "next"

    invoke-virtual {v0, v2}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v2

    .line 43
    if-eqz v14, :cond_e8

    if-eqz v2, :cond_e8

    invoke-virtual {v2}, Lorg/json/JSONArray;->length()I

    move-result v28

    if-lez v28, :cond_e8

    const/4 v7, 0x0

    invoke-virtual {v2, v7}, Lorg/json/JSONArray;->optJSONObject(I)Lorg/json/JSONObject;

    move-result-object v2

    const-string v7, "distFromPrev"

    move-object/from16 v29, v14

    const v14, 0x186a0

    invoke-static {v2, v7, v14}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v7

    if-ltz v7, :cond_ea

    add-int v7, v25, v7

    invoke-static {v2, v7}, Lcom/navipilot/obf/WideGoogleAdapter;->guidance(Lorg/json/JSONObject;I)Lorg/json/JSONObject;

    move-result-object v2

    goto :goto_eb

    :cond_e8
    move-object/from16 v29, v14

    .line 44
    :cond_ea
    const/4 v2, 0x0

    :goto_eb
    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V

    invoke-virtual {v7, v12, v3, v4}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    move-result-object v7

    const-string v12, "lon"

    invoke-virtual {v7, v12, v5, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    move-result-object v7

    const-string v12, "virtual_gps"

    const/4 v14, 0x0

    invoke-virtual {v7, v12, v14}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v7

    if-nez v15, :cond_106

    move-object/from16 v12, v17

    goto :goto_10c

    :cond_106
    const-string v12, "road"

    invoke-static {v15, v12}, Lcom/navipilot/obf/WideGoogleAdapter;->text(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    :goto_10c
    const-string v14, "road_name"

    invoke-virtual {v7, v14, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v7

    .line 45
    const-string v12, "bearing"

    move-object/from16 v17, v8

    move-object/from16 v19, v9

    const-wide/high16 v14, 0x7ff8000000000000L    # Double.NaN

    invoke-virtual {v11, v12, v14, v15}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v8

    const-string v12, "speed"

    invoke-virtual {v11, v12, v14, v15}, Lorg/json/JSONObject;->optDouble(Ljava/lang/String;D)D

    move-result-wide v11

    .line 46
    invoke-static {v8, v9}, Ljava/lang/Double;->isFinite(D)Z

    move-result v14

    if-eqz v14, :cond_13c

    cmpl-double v14, v8, v21

    if-ltz v14, :cond_13c

    const-wide v14, 0x4076800000000000L    # 360.0

    cmpg-double v14, v8, v14

    if-gez v14, :cond_13c

    const-string v14, "heading_deg"

    invoke-virtual {v7, v14, v8, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 47
    :cond_13c
    invoke-static {v11, v12}, Ljava/lang/Double;->isFinite(D)Z

    move-result v8

    if-eqz v8, :cond_157

    cmpl-double v8, v11, v21

    if-ltz v8, :cond_157

    const-wide/high16 v8, 0x4059000000000000L    # 100.0

    cmpg-double v8, v11, v8

    if-gtz v8, :cond_157

    const-wide v8, 0x400ccccccccccccdL    # 3.6

    mul-double/2addr v11, v8

    const-string v8, "speed_kph"

    invoke-virtual {v7, v8, v11, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    .line 48
    :cond_157
    const-string v8, "remain"

    invoke-virtual {v0, v8}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v8

    const v9, 0x1312d00

    invoke-static {v8, v13, v9}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v9

    const v11, 0x93a80

    invoke-static {v8, v10, v11}, Lcom/navipilot/obf/WideGoogleAdapter;->num(Lorg/json/JSONObject;Ljava/lang/String;I)I

    move-result v8

    .line 49
    if-ltz v9, :cond_1c0

    if-ltz v8, :cond_1c0

    new-instance v10, Lorg/json/JSONObject;

    invoke-direct {v10}, Lorg/json/JSONObject;-><init>()V

    const-string v11, "remain_distance_m"

    invoke-virtual {v10, v11, v9}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v9

    const-string v10, "remain_time_sec"

    invoke-virtual {v9, v10, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    move-result-object v8

    .line 50
    if-eqz v1, :cond_1bd

    move-object/from16 v9, v16

    invoke-virtual {v0, v9}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v1, v9}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v10, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_1bd

    const-string v9, "routeVer"

    invoke-virtual {v0, v9}, Lorg/json/JSONObject;->has(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_1bd

    const-string v10, "ver"

    const-wide/16 v11, -0x2

    invoke-virtual {v1, v10, v11, v12}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v10

    const-wide/16 v12, -0x1

    invoke-virtual {v0, v9, v12, v13}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v12

    cmp-long v0, v10, v12

    if-nez v0, :cond_1bd

    .line 51
    const-string v0, "pts"

    invoke-virtual {v1, v0}, Lorg/json/JSONObject;->optJSONArray(Ljava/lang/String;)Lorg/json/JSONArray;

    move-result-object v0

    invoke-static {v0, v3, v4, v5, v6}, Lcom/navipilot/obf/WideGoogleAdapter;->polyline(Lorg/json/JSONArray;DD)Lorg/json/JSONArray;

    move-result-object v0

    if-eqz v0, :cond_1bd

    const-string v1, "polyline"

    invoke-virtual {v8, v1, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 54
    :cond_1bd
    move-object/from16 v28, v8

    goto :goto_1c2

    :cond_1c0
    const/16 v28, 0x0

    :goto_1c2
    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v1, "guiding"

    move-object/from16 v3, v19

    invoke-virtual {v0, v3, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v29, :cond_1d3

    const/4 v1, 0x1

    goto :goto_1d4

    :cond_1d3
    const/4 v1, 0x0

    :goto_1d4
    move-object/from16 v4, v17

    invoke-virtual {v0, v4, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v0

    const-string v1, "off_route"

    const/4 v14, 0x0

    invoke-virtual {v0, v1, v14}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v0

    if-eqz v28, :cond_1e5

    const/4 v3, 0x1

    goto :goto_1e6

    :cond_1e5
    const/4 v3, 0x0

    :goto_1e6
    move-object/from16 v1, v27

    invoke-virtual {v0, v1, v3}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v0

    .line 55
    new-instance v24, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    move/from16 v3, v18

    move/from16 v1, v26

    invoke-static {v1, v3}, Ljava/lang/Math;->max(II)I

    move-result v1

    int-to-long v3, v1

    const-string v34, "Google SDK \u8cc7\u6599\u6709\u6548"

    move-wide/from16 v30, p2

    move-object/from16 v26, v2

    move-wide/from16 v32, v3

    move-object/from16 v27, v28

    move-object/from16 v25, v29

    move-object/from16 v29, v0

    move-object/from16 v28, v7

    invoke-direct/range {v24 .. v34}, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;-><init>(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;JJLjava/lang/String;)V

    return-object v24

    .line 39
    :cond_20b
    new-instance v0, Lorg/json/JSONException;

    const-string v1, "Invalid snapped location"

    invoke-direct {v0, v1}, Lorg/json/JSONException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 37
    :cond_213
    new-instance v0, Lorg/json/JSONException;

    const-string v1, "SDK guidance/location missing or stale"

    invoke-direct {v0, v1}, Lorg/json/JSONException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 35
    :cond_21b
    move-object v1, v7

    move-object v4, v8

    move-object v3, v9

    :goto_21e
    new-instance v2, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    new-instance v0, Lorg/json/JSONObject;

    invoke-direct {v0}, Lorg/json/JSONObject;-><init>()V

    const-string v5, "idle"

    invoke-virtual {v0, v3, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    move-result-object v0

    const/4 v14, 0x0

    invoke-virtual {v0, v4, v14}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v0

    invoke-virtual {v0, v1, v14}, Lorg/json/JSONObject;->put(Ljava/lang/String;Z)Lorg/json/JSONObject;

    move-result-object v7

    const-wide/16 v10, 0x0

    const-string v12, "\u672a\u5c0e\u822a\uff0f\u91cd\u65b0\u898f\u5283\uff0f\u6a21\u64ec\uff0c\u64a4\u92b7\u8cc7\u6599"

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    move-wide/from16 v8, p2

    invoke-direct/range {v2 .. v12}, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;-><init>(Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;Lorg/json/JSONObject;JJLjava/lang/String;)V

    return-object v2

    .line 34
    :cond_242
    new-instance v0, Lorg/json/JSONException;

    const-string v1, "Missing producer session"

    invoke-direct {v0, v1}, Lorg/json/JSONException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 32
    :cond_24a
    new-instance v0, Lorg/json/JSONException;

    const-string v1, "Unsupported NavDash snapshot"

    invoke-direct {v0, v1}, Lorg/json/JSONException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method static polyline(Lorg/json/JSONArray;DD)Lorg/json/JSONArray;
    .registers 39
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Lorg/json/JSONException;
        }
    .end annotation

    .line 59
    move-object/from16 v0, p0

    const/4 v1, 0x0

    if-eqz v0, :cond_125

    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v2

    const/4 v3, 0x2

    if-lt v2, v3, :cond_125

    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v2

    const v4, 0x186a0

    if-le v2, v4, :cond_17

    goto/16 :goto_125

    .line 60
    :cond_17
    invoke-static/range {p1 .. p2}, Ljava/lang/Math;->toRadians(D)D

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Math;->cos(D)D

    move-result-wide v4

    const-wide v6, 0x40fb2d8000000000L    # 111320.0

    mul-double/2addr v4, v6

    .line 61
    const/4 v2, 0x0

    move v8, v2

    :goto_27
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v9

    const/4 v10, 0x1

    if-lt v8, v9, :cond_fd

    .line 62
    const/4 v8, -0x1

    const-wide/high16 v11, 0x7ff0000000000000L    # Double.POSITIVE_INFINITY

    move v9, v2

    :goto_32
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v13

    sub-int/2addr v13, v10

    if-lt v9, v13, :cond_86

    .line 65
    const-wide v4, 0x40c3880000000000L    # 10000.0

    cmpl-double v4, v11, v4

    if-lez v4, :cond_43

    return-object v1

    .line 66
    :cond_43
    new-instance v4, Lorg/json/JSONArray;

    invoke-direct {v4}, Lorg/json/JSONArray;-><init>()V

    invoke-static {v2, v8}, Ljava/lang/Math;->max(II)I

    move-result v5

    :goto_4c
    invoke-virtual {v0}, Lorg/json/JSONArray;->length()I

    move-result v6

    if-ge v5, v6, :cond_7e

    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I

    move-result v6

    const/16 v7, 0x100

    if-lt v6, v7, :cond_5b

    goto :goto_7e

    :cond_5b
    invoke-virtual {v0, v5}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v6

    new-instance v7, Lorg/json/JSONObject;

    invoke-direct {v7}, Lorg/json/JSONObject;-><init>()V

    const-string v8, "lat"

    invoke-virtual {v6, v2}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v11

    invoke-virtual {v7, v8, v11, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    move-result-object v7

    const-string v8, "lon"

    invoke-virtual {v6, v10}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v11

    invoke-virtual {v7, v8, v11, v12}, Lorg/json/JSONObject;->put(Ljava/lang/String;D)Lorg/json/JSONObject;

    move-result-object v6

    invoke-virtual {v4, v6}, Lorg/json/JSONArray;->put(Ljava/lang/Object;)Lorg/json/JSONArray;

    add-int/lit8 v5, v5, 0x1

    goto :goto_4c

    .line 67
    :cond_7e
    :goto_7e
    invoke-virtual {v4}, Lorg/json/JSONArray;->length()I

    move-result v0

    if-lt v0, v3, :cond_85

    move-object v1, v4

    :cond_85
    return-object v1

    .line 62
    :cond_86
    invoke-virtual {v0, v9}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v13

    add-int/lit8 v14, v9, 0x1

    invoke-virtual {v0, v14}, Lorg/json/JSONArray;->getJSONArray(I)Lorg/json/JSONArray;

    move-result-object v15

    .line 63
    invoke-virtual {v13, v10}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v16

    sub-double v16, v16, p3

    mul-double v16, v16, v4

    invoke-virtual {v13, v2}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v18

    sub-double v18, v18, p1

    mul-double v18, v18, v6

    invoke-virtual {v15, v10}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v20

    sub-double v20, v20, p3

    mul-double v20, v20, v4

    invoke-virtual {v15, v2}, Lorg/json/JSONArray;->getDouble(I)D

    move-result-wide v22

    sub-double v22, v22, p1

    mul-double v22, v22, v6

    sub-double v20, v20, v16

    sub-double v22, v22, v18

    mul-double v24, v20, v20

    mul-double v26, v22, v22

    add-double v24, v24, v26

    .line 64
    const-wide/16 v6, 0x0

    cmpl-double v13, v24, v6

    if-lez v13, :cond_d6

    mul-double v28, v16, v20

    mul-double v30, v18, v22

    move-wide/from16 v32, v11

    add-double v10, v28, v30

    neg-double v10, v10

    div-double v10, v10, v24

    const-wide/high16 v12, 0x3ff0000000000000L    # 1.0

    invoke-static {v12, v13, v10, v11}, Ljava/lang/Math;->min(DD)D

    move-result-wide v10

    invoke-static {v6, v7, v10, v11}, Ljava/lang/Math;->max(DD)D

    move-result-wide v6

    goto :goto_d8

    :cond_d6
    move-wide/from16 v32, v11

    :goto_d8
    mul-double v20, v20, v6

    add-double v10, v16, v20

    const-wide/high16 v12, 0x4000000000000000L    # 2.0

    invoke-static {v10, v11, v12, v13}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v10

    mul-double v6, v6, v22

    add-double v6, v18, v6

    invoke-static {v6, v7, v12, v13}, Ljava/lang/Math;->pow(DD)D

    move-result-wide v6

    add-double/2addr v10, v6

    cmpg-double v6, v10, v32

    if-gez v6, :cond_f2

    move v8, v9

    move-wide v11, v10

    goto :goto_f4

    :cond_f2
    move-wide/from16 v11, v32

    .line 62
    :goto_f4
    move v9, v14

    const-wide v6, 0x40fb2d8000000000L    # 111320.0

    const/4 v10, 0x1

    goto/16 :goto_32

    .line 61
    :cond_fd
    invoke-virtual {v0, v8}, Lorg/json/JSONArray;->optJSONArray(I)Lorg/json/JSONArray;

    move-result-object v6

    if-eqz v6, :cond_124

    invoke-virtual {v6}, Lorg/json/JSONArray;->length()I

    move-result v7

    if-ne v7, v3, :cond_124

    const-wide/high16 v9, 0x7ff8000000000000L    # Double.NaN

    invoke-virtual {v6, v2, v9, v10}, Lorg/json/JSONArray;->optDouble(ID)D

    move-result-wide v11

    const/4 v15, 0x1

    invoke-virtual {v6, v15, v9, v10}, Lorg/json/JSONArray;->optDouble(ID)D

    move-result-wide v6

    invoke-static {v11, v12, v6, v7}, Lcom/navipilot/obf/WideGoogleAdapter;->coordinate(DD)Z

    move-result v6

    if-nez v6, :cond_11b

    goto :goto_124

    :cond_11b
    add-int/lit8 v8, v8, 0x1

    const-wide v6, 0x40fb2d8000000000L    # 111320.0

    goto/16 :goto_27

    :cond_124
    :goto_124
    return-object v1

    .line 59
    :cond_125
    :goto_125
    return-object v1
.end method

.method static text(Lorg/json/JSONObject;Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 16
    const-string v0, ""

    invoke-virtual {p0, p1, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p1

    const/16 v0, 0xf0

    if-le p1, v0, :cond_13

    const/4 p1, 0x0

    invoke-virtual {p0, p1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    :cond_13
    return-object p0
.end method

.method public static turn(Ljava/lang/String;Ljava/lang/String;)I
    .registers 5

    .line 18
    const-string v0, "arrive"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    const/16 p0, 0xc9

    return p0

    .line 19
    :cond_b
    const-string v0, "turn"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "right"

    const-string v2, "left"

    if-eqz v0, :cond_4a

    const-string v0, "uturn"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_22

    const/16 p0, 0xe

    return p0

    :cond_22
    invoke-virtual {v2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2b

    const/16 p0, 0xc

    return p0

    :cond_2b
    invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_34

    const/16 p0, 0xd

    return p0

    :cond_34
    const-string v0, "sharp_left"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3f

    const/16 p0, 0x10

    return p0

    :cond_3f
    const-string v0, "sharp_right"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4a

    const/16 p0, 0x13

    return p0

    .line 20
    :cond_4a
    const-string v0, "fork"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_62

    invoke-virtual {p1, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_5a

    const/4 p0, 0x7

    return p0

    :cond_5a
    invoke-virtual {p1, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_62

    const/4 p0, 0x6

    return p0

    .line 21
    :cond_62
    const-string v0, "off_ramp"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7c

    invoke-virtual {p1, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_73

    const/16 p0, 0x66

    return p0

    :cond_73
    invoke-virtual {p1, v1}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result p1

    if-eqz p1, :cond_7c

    const/16 p0, 0x65

    return p0

    .line 22
    :cond_7c
    const-string p1, "roundabout"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_87

    const/16 p0, 0x8e

    return p0

    .line 23
    :cond_87
    const-string p1, "straight"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_9a

    const-string p1, "continue"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_98

    goto :goto_9a

    .line 24
    :cond_98
    const/4 p0, -0x1

    return p0

    .line 23
    :cond_9a
    :goto_9a
    const/16 p0, 0x33

    return p0
.end method
