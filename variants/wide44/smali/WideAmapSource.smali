.class public final Lcom/navipilot/obf/WideAmapSource;
.super Ljava/lang/Object;
.source "WideAmapSource.java"


# static fields
.field private static final AUTO:Ljava/lang/String; = "com.autonavi.amapauto"

.field private static final PHONE:Ljava/lang/String; = "com.autonavi.minimap"

.field private static final STREAMS:[Ljava/lang/String;

.field private static volatile bridge:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Lcom/navipilot/obf/MG;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile generation:J

.field private static volatile inputStatus:Ljava/lang/String;

.field private static volatile parser:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Lcom/navipilot/obf/IG;",
            ">;"
        }
    .end annotation
.end field

.field private static final pending:Ljava/util/WeakHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/WeakHashMap<",
            "Landroid/content/Intent;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private static volatile ready:Z

.field private static volatile selected:Ljava/lang/String;

.field private static volatile selectedSince:J


# direct methods
.method static constructor <clinit>()V
    .locals 10

    .line 15
    nop

    .line 16
    nop

    .line 17
    const-string v8, "traffic_signal"

    const-string v9, "ui_route_changed"

    const-string v0, "guidance_current"

    const-string v1, "guidance_next"

    const-string v2, "route"

    const-string v3, "speed"

    const-string v4, "navigation_status"

    const-string v5, "vehicle"

    const-string v6, "lane_current"

    const-string v7, "road_category"

    filled-new-array/range {v0 .. v9}, [Ljava/lang/String;

    move-result-object v0

    .line 15
    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->STREAMS:[Ljava/lang/String;

    .line 19
    new-instance v0, Ljava/util/WeakHashMap;

    invoke-direct {v0}, Ljava/util/WeakHashMap;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->pending:Ljava/util/WeakHashMap;

    .line 20
    const-string v0, "com.autonavi.amapauto"

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    .line 24
    new-instance v0, Ljava/lang/ref/WeakReference;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->parser:Ljava/lang/ref/WeakReference;

    .line 25
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, v1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->bridge:Ljava/lang/ref/WeakReference;

    .line 26
    const-string v0, "\u7b49\u5f85\u6240\u9078\u9ad8\u5fb7\u7684\u65b0\u8cc7\u6599"

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->inputStatus:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static declared-synchronized accept(Landroid/content/BroadcastReceiver;Landroid/content/Intent;)Z
    .locals 4

    const-class v0, Lcom/navipilot/obf/WideAmapSource;

    monitor-enter v0

    .line 43
    const/4 v1, 0x0

    if-eqz p1, :cond_3

    :try_start_0
    sget-object v2, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    invoke-static {v2}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_0

    goto :goto_1

    .line 44
    :cond_0
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x22

    if-lt v2, v3, :cond_1

    invoke-virtual {p0}, Landroid/content/BroadcastReceiver;->getSentFromPackage()Ljava/lang/String;

    move-result-object p0

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    .line 45
    :goto_0
    sget-object v2, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, p0, v3}, Lcom/navipilot/obf/WideAmapSource;->matches(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v1

    invoke-static {v2, p0, v3, v1}, Lcom/navipilot/obf/WideAmapInput;->observed(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V

    move p0, v1

    const/4 v1, 0x0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-nez p0, :cond_2

    monitor-exit v0

    return v1

    .line 46
    :cond_2
    :try_start_1
    sget-object p0, Lcom/navipilot/obf/WideAmapSource;->pending:Ljava/util/WeakHashMap;

    sget-wide v1, Lcom/navipilot/obf/WideAmapSource;->generation:J

    invoke-static {v1, v2}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {p0, p1, v1}, Ljava/util/WeakHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 47
    monitor-exit v0

    const/4 p0, 0x1

    return p0

    .line 42
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw p0

    .line 43
    :cond_3
    :goto_1
    monitor-exit v0

    return v1
.end method

.method public static attach(Lcom/navipilot/obf/IG;)V
    .locals 1

    .line 51
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->parser:Ljava/lang/ref/WeakReference;

    .line 52
    return-void
.end method

.method static currentCamera(J)Lcom/navipilot/obf/WideAmapCamera$Notice;
    .locals 12

    .line 93
    sget-wide v0, Lcom/navipilot/obf/WideAmapSource;->generation:J

    .line 94
    sget-object v2, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    .line 95
    sget-wide v5, Lcom/navipilot/obf/WideAmapSource;->selectedSince:J

    .line 96
    sget-object v3, Lcom/navipilot/obf/WideAmapSource;->parser:Ljava/lang/ref/WeakReference;

    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/navipilot/obf/IG;

    .line 97
    sget-boolean v4, Lcom/navipilot/obf/WideAmapSource;->ready:Z

    const/4 v7, 0x0

    if-eqz v4, :cond_4

    invoke-static {v2}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_4

    if-nez v3, :cond_0

    goto :goto_2

    .line 99
    :cond_0
    monitor-enter v3

    .line 100
    move-object v4, v3

    :try_start_0
    iget-object v3, v4, Lcom/navipilot/obf/IG;->z:Lcom/navipilot/obf/T4;

    .line 101
    iget-object v11, v4, Lcom/navipilot/obf/IG;->A:Lcom/navipilot/obf/T4;

    .line 99
    monitor-exit v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 103
    sget-boolean v8, Lcom/navipilot/obf/WideAmapSource;->ready:Z

    if-eqz v8, :cond_3

    sget-wide v8, Lcom/navipilot/obf/WideAmapSource;->generation:J

    cmp-long v0, v0, v8

    if-nez v0, :cond_3

    sget-object v0, Lcom/navipilot/obf/WideAmapSource;->parser:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-eq v4, v0, :cond_1

    goto :goto_1

    .line 104
    :cond_1
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    .line 105
    const-string v0, "com.autonavi.amapauto"

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "\u9ad8\u5fb7\u8eca\u6a5f"

    goto :goto_0

    :cond_2
    const-string v0, "\u9ad8\u5fb7\u4e00\u822c\u7248"

    :goto_0
    move-object v4, v0

    .line 106
    move-wide v9, p0

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideAmapCamera;->read(Lcom/navipilot/obf/T4;Ljava/lang/String;JJJ)Lcom/navipilot/obf/WideAmapCamera$Notice;

    move-result-object p0

    .line 107
    move-object v3, v11

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideAmapCamera;->read(Lcom/navipilot/obf/T4;Ljava/lang/String;JJJ)Lcom/navipilot/obf/WideAmapCamera$Notice;

    move-result-object p1

    .line 106
    invoke-static {p0, p1}, Lcom/navipilot/obf/WideAmapCamera;->preferred(Lcom/navipilot/obf/WideAmapCamera$Notice;Lcom/navipilot/obf/WideAmapCamera$Notice;)Lcom/navipilot/obf/WideAmapCamera$Notice;

    move-result-object p0

    return-object p0

    .line 103
    :cond_3
    :goto_1
    return-object v7

    .line 99
    :catchall_0
    move-exception v0

    move-object p0, v0

    :try_start_1
    monitor-exit v4
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0

    .line 97
    :cond_4
    :goto_2
    return-object v7
.end method

.method public static declared-synchronized dispatch(Lcom/navipilot/obf/h4;Landroid/content/Intent;I)V
    .locals 5

    const-class v0, Lcom/navipilot/obf/WideAmapSource;

    monitor-enter v0

    .line 55
    :try_start_0
    sget-object v1, Lcom/navipilot/obf/WideAmapSource;->pending:Ljava/util/WeakHashMap;

    invoke-virtual {v1, p1}, Ljava/util/WeakHashMap;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/Long;

    .line 56
    if-eqz v1, :cond_1

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v1

    sget-wide v3, Lcom/navipilot/obf/WideAmapSource;->generation:J

    cmp-long v1, v1, v3

    if-eqz v1, :cond_0

    goto :goto_0

    .line 57
    :cond_0
    const-string v1, "\u5df2\u6536\u5230\u6240\u9078\u9ad8\u5fb7\u5ee3\u64ad\uff0c\u7b49\u5f85\u53ef\u7528\u5c0e\u822a\u6b04\u4f4d"

    sput-object v1, Lcom/navipilot/obf/WideAmapSource;->inputStatus:Ljava/lang/String;

    .line 58
    const/4 v1, 0x1

    sput-boolean v1, Lcom/navipilot/obf/WideAmapSource;->ready:Z

    .line 59
    invoke-static {p2}, Lcom/navipilot/obf/WideAmapInput;->parsed(I)V

    invoke-static {p0, p1, p2}, Lcom/navipilot/obf/h4;->a(Lcom/navipilot/obf/h4;Landroid/content/Intent;I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 60
    monitor-exit v0

    return-void

    .line 56
    :cond_1
    :goto_0
    monitor-exit v0

    return-void

    .line 54
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static filter(Lcom/navipilot/obf/MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    .locals 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Lcom/navipilot/obf/MG;",
            "Ljava/lang/String;",
            "Lorg/json/JSONObject;",
            "Ljava/util/Map<",
            "**>;)",
            "Lorg/json/JSONObject;"
        }
    .end annotation

    move-object v3, p1

    .line 82
    sget-object v0, Lcom/navipilot/obf/WideAmapSource;->bridge:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-eq v0, p0, :cond_0

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/navipilot/obf/WideAmapSource;->bridge:Ljava/lang/ref/WeakReference;

    .line 83
    :cond_0
    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->selected()Z
    move-result v0
    if-eqz v0, :google_filter_end
    invoke-static {p1, p2, p3}, Lcom/navipilot/obf/WideGoogleNav;->filter(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    move-result-object v0
    return-object v0
    :google_filter_end

    if-eqz p2, :cond_6

    const-string p0, "app_status"

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_1

    goto :goto_2

    .line 84
    :cond_1
    sget-boolean p0, Lcom/navipilot/obf/WideAmapSource;->ready:Z

    const/4 v0, 0x0

    if-eqz p0, :cond_5

    sget-object p0, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result p0

    if-nez p0, :cond_2

    goto :goto_1

    .line 85
    :cond_2
    invoke-interface {p3, p1}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 86
    instance-of p1, p0, Ljava/lang/Number;

    if-eqz p1, :cond_4

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide p0

    sget-wide v1, Lcom/navipilot/obf/WideAmapSource;->selectedSince:J

    cmp-long p0, p0, v1

    if-gez p0, :cond_3

    goto :goto_0

    .line 87
    :cond_3
    invoke-static {v3}, Lcom/navipilot/obf/WideAmapInput;->forwarded(Ljava/lang/String;)V

    return-object p2

    .line 86
    :cond_4
    :goto_0
    return-object v0

    .line 84
    :cond_5
    :goto_1
    return-object v0

    .line 83
    :cond_6
    :goto_2
    return-object p2
.end method

.method static generation()J
    .locals 2

    .line 90
    sget-wide v0, Lcom/navipilot/obf/WideAmapSource;->generation:J

    return-wide v0
.end method

.method private static isAmap(Ljava/lang/String;)Z
    .locals 1

    .line 29
    const-string v0, "com.autonavi.amapauto"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "com.autonavi.minimap"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x0

    return p0

    :cond_0
    const/4 p0, 0x1

    return p0
.end method

.method static matches(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .locals 2

    .line 33
    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 34
    :cond_0
    if-eqz p1, :cond_1

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_1

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    return p0

    .line 35
    :cond_1
    const-string p1, "com.autonavi.minimap"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    const/4 v0, 0x1

    if-eqz p1, :cond_3

    .line 36
    const-string p0, "com.autonavi.minimap.broadcast"

    invoke-virtual {p0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    .line 37
    const-string p0, "com.autonavi.minimap.navigation.broadcast"

    invoke-virtual {p0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_2

    .line 36
    return v1

    :cond_2
    return v0

    .line 39
    :cond_3
    const-string p1, "com.autonavi.amapauto"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_4

    const-string p0, "AUTONAVI_STANDARD_BROADCAST_SEND"

    invoke-virtual {p0, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_4

    return v0

    :cond_4
    return v1
.end method

.method static declared-synchronized select(Ljava/lang/String;)V
    .locals 7

    invoke-static {p0}, Lcom/navipilot/obf/WideGoogleNav;->select(Ljava/lang/String;)V

    const-class v0, Lcom/navipilot/obf/WideAmapSource;

    monitor-enter v0

    .line 63
    :try_start_0
    const-string v1, "com.copilottw.googlenav"
    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-nez v1, :cond_0

    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    const-string v1, "com.google.android.apps.maps"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-nez v1, :cond_0

    monitor-exit v0

    return-void

    .line 64
    :cond_0
    :try_start_1
    sget-wide v1, Lcom/navipilot/obf/WideAmapSource;->selectedSince:J

    const-wide/16 v3, 0x0

    cmp-long v1, v1, v3

    if-eqz v1, :cond_1

    sget-object v1, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-eqz v1, :cond_1

    monitor-exit v0

    return-void

    .line 65
    :cond_1
    const/4 v1, 0x0

    :try_start_2
    invoke-static {}, Lcom/navipilot/obf/WideAmapInput;->reset()V

    sput-boolean v1, Lcom/navipilot/obf/WideAmapSource;->ready:Z

    .line 66
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/navipilot/obf/WideAmapSource;->selectedSince:J

    .line 67
    sput-object p0, Lcom/navipilot/obf/WideAmapSource;->selected:Ljava/lang/String;

    .line 68
    sget-wide v2, Lcom/navipilot/obf/WideAmapSource;->generation:J

    const-wide/16 v4, 0x1

    add-long/2addr v2, v4

    sput-wide v2, Lcom/navipilot/obf/WideAmapSource;->generation:J

    .line 69
    sget-object v2, Lcom/navipilot/obf/WideAmapSource;->pending:Ljava/util/WeakHashMap;

    invoke-virtual {v2}, Ljava/util/WeakHashMap;->clear()V

    .line 70
    invoke-static {p0}, Lcom/navipilot/obf/WideAmapSource;->isAmap(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_2

    const-string p0, "\u7b49\u5f85\u6240\u9078\u9ad8\u5fb7\u7684\u65b0\u8cc7\u6599"

    goto :goto_0

    :cond_2
    const-string p0, "Google \u5730\u5716\u50c5\u6295\u5c4f\uff0c\u9ad8\u5fb7\u8cc7\u6599\u5df2\u505c\u7528"

    :goto_0
    sput-object p0, Lcom/navipilot/obf/WideAmapSource;->inputStatus:Ljava/lang/String;

    .line 71
    sget-object p0, Lcom/navipilot/obf/WideAmapSource;->parser:Ljava/lang/ref/WeakReference;

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/navipilot/obf/IG;

    .line 72
    if-eqz p0, :cond_3

    sget-wide v2, Lcom/navipilot/obf/WideAmapSource;->selectedSince:J

    invoke-virtual {p0, v2, v3}, Lcom/navipilot/obf/IG;->f(J)V

    .line 73
    :cond_3
    sget-object p0, Lcom/navipilot/obf/WideAmapSource;->bridge:Ljava/lang/ref/WeakReference;

    invoke-virtual {p0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Lcom/navipilot/obf/MG;

    .line 74
    if-eqz p0, :cond_5

    .line 75
    monitor-enter p0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    .line 76
    :try_start_3
    sget-object v2, Lcom/navipilot/obf/WideAmapSource;->STREAMS:[Ljava/lang/String;

    array-length v3, v2

    :goto_1
    if-lt v1, v3, :cond_4

    .line 75
    monitor-exit p0

    goto :goto_2

    .line 76
    :cond_4
    aget-object v4, v2, v1

    const-string v5, "amap_source_changed"

    const/4 v6, 0x0

    invoke-virtual {p0, v4, v6, v5}, Lcom/navipilot/obf/MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    .line 75
    :catchall_0
    move-exception v1

    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    :try_start_4
    throw v1
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 79
    :cond_5
    :goto_2
    monitor-exit v0

    return-void

    .line 62
    :catchall_1
    move-exception p0

    :try_start_5
    monitor-exit v0
    :try_end_5
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    throw p0
.end method

.method static status()Ljava/lang/String;
    .locals 1

    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->selected()Z
    move-result v0
    if-eqz v0, :google_status_end
    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->status()Ljava/lang/String;
    move-result-object v0
    return-object v0
    :google_status_end

    .line 110
    sget-object v0, Lcom/navipilot/obf/WideAmapSource;->inputStatus:Ljava/lang/String;

    invoke-static {v0}, Lcom/navipilot/obf/WideAmapInput;->status(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
