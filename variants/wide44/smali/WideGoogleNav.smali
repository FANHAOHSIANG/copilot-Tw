.class public final Lcom/navipilot/obf/WideGoogleNav;
.super Ljava/lang/Object;
.source "WideGoogleNav.java"


# static fields
.field public static final PACKAGE:Ljava/lang/String; = "com.copilottw.googlenav"

.field private static volatile generation:J

.field private static geometry:Lorg/json/JSONObject;

.field private static geometrySession:Ljava/lang/String;

.field private static geometryVersion:J

.field private static initialized:Z

.field private static volatile selected:Z

.field private static volatile snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

.field private static volatile state:Ljava/lang/String;

.field private static volatile suppliedAt:J


# direct methods
.method public static synthetic $r8$lambda$C3javyvxdkd5Jm1WcIqhaUUdAcI()V
    .registers 0

    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->poll()V

    return-void
.end method

.method static constructor <clinit>()V
    .registers 2

    .line 7
    const-string v0, "\u5c1a\u672a\u9078\u64c7 CP Google \u5c0e\u822a"

    sput-object v0, Lcom/navipilot/obf/WideGoogleNav;->state:Ljava/lang/String;

    .line 8
    const-string v0, ""

    sput-object v0, Lcom/navipilot/obf/WideGoogleNav;->geometrySession:Ljava/lang/String;

    const-wide/16 v0, -0x1

    sput-wide v0, Lcom/navipilot/obf/WideGoogleNav;->geometryVersion:J

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 36
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static filter(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    .registers 13

    .line 25
    sget-boolean v0, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    const/4 v1, 0x0

    if-nez v0, :cond_6

    return-object v1

    .line 26
    :cond_6
    const-string v0, "app_status"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_f

    return-object p1

    .line 27
    :cond_f
    sget-object p1, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    if-nez p1, :cond_18

    goto :goto_1c

    :cond_18
    invoke-virtual {p1, p0, v2, v3}, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->value(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v1

    .line 28
    :goto_1c
    if-eqz v1, :cond_3a

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v4

    iget-wide v6, p1, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->received:J

    sub-long v6, v2, v6

    iget-wide v8, p1, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->age:J

    add-long/2addr v6, v8

    const-wide/16 v8, 0x0

    invoke-static {v8, v9, v6, v7}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v6

    sub-long/2addr v4, v6

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p1

    invoke-interface {p2, p0, p1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    sput-wide v2, Lcom/navipilot/obf/WideGoogleNav;->suppliedAt:J

    goto :goto_3d

    :cond_3a
    invoke-interface {p2, p0}, Ljava/util/Map;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 29
    :goto_3d
    return-object v1
.end method

.method private static get(Ljava/lang/String;)Lorg/json/JSONObject;
    .registers 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 13
    new-instance v0, Ljava/net/URL;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "http://127.0.0.1:5002"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    const/16 v0, 0x2bc

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v0, 0x384

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setUseCaches(Z)V

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setInstanceFollowRedirects(Z)V

    .line 14
    :try_start_2b
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v1
    :try_end_2f
    .catchall {:try_start_2b .. :try_end_2f} :catchall_9c

    const/16 v2, 0xc8

    if-ne v1, v2, :cond_94

    const/4 v1, 0x0

    :try_start_34
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2
    :try_end_38
    .catchall {:try_start_34 .. :try_end_38} :catchall_8a

    :try_start_38
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V
    :try_end_3d
    .catchall {:try_start_38 .. :try_end_3d} :catchall_7a

    const/16 v4, 0x2000

    :try_start_3f
    new-array v4, v4, [B

    :goto_41
    invoke-virtual {v2, v4}, Ljava/io/InputStream;->read([B)I

    move-result v5

    const/4 v6, -0x1

    if-ne v5, v6, :cond_5f

    new-instance v0, Lorg/json/JSONObject;

    const-string v4, "UTF-8"

    invoke-virtual {v3, v4}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-direct {v0, v4}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_53
    .catchall {:try_start_3f .. :try_end_53} :catchall_74

    :try_start_53
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->close()V
    :try_end_56
    .catchall {:try_start_53 .. :try_end_56} :catchall_7a

    if-eqz v2, :cond_5b

    :try_start_58
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V
    :try_end_5b
    .catchall {:try_start_58 .. :try_end_5b} :catchall_8a

    :cond_5b
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    return-object v0

    :cond_5f
    :try_start_5f
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->size()I

    move-result v6

    add-int/2addr v6, v5

    const/high16 v7, 0x400000

    if-gt v6, v7, :cond_6c

    invoke-virtual {v3, v4, v0, v5}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_41

    :cond_6c
    new-instance v0, Ljava/io/IOException;

    const-string v1, "response too large"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    throw v0
    :try_end_74
    .catchall {:try_start_5f .. :try_end_74} :catchall_74

    :catchall_74
    move-exception v0

    move-object v1, v0

    :try_start_76
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->close()V

    throw v1
    :try_end_7a
    .catchall {:try_start_76 .. :try_end_7a} :catchall_7a

    :catchall_7a
    move-exception v0

    if-nez v1, :cond_7f

    move-object v1, v0

    goto :goto_84

    :cond_7f
    if-eq v1, v0, :cond_84

    :try_start_81
    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_84
    :goto_84
    if-eqz v2, :cond_89

    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    :cond_89
    throw v1
    :try_end_8a
    .catchall {:try_start_81 .. :try_end_8a} :catchall_8a

    :catchall_8a
    move-exception v0

    if-eqz v1, :cond_93

    if-eq v1, v0, :cond_92

    :try_start_8f
    invoke-virtual {v1, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_92
    move-object v0, v1

    :cond_93
    :goto_93
    throw v0

    :cond_94
    new-instance v0, Ljava/io/IOException;

    const-string v1, "source unavailable"

    invoke-direct {v0, v1}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V
    :try_end_9b
    .catchall {:try_start_8f .. :try_end_9b} :catchall_9c

    goto :goto_93

    :catchall_9c
    move-exception v0

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    throw v0
.end method

.method public static guidance()Lorg/json/JSONObject;
    .registers 4

    .line 31
    sget-object v0, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    sget-boolean v1, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    if-eqz v1, :cond_13

    if-eqz v0, :cond_13

    const-string v1, "guidance_current"

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    invoke-virtual {v0, v1, v2, v3}, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->value(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    goto :goto_14

    :cond_13
    const/4 v0, 0x0

    :goto_14
    return-object v0
.end method

.method public static declared-synchronized init(Landroid/content/Context;)V
    .registers 9

    const-class p0, Lcom/navipilot/obf/WideGoogleNav;

    monitor-enter p0

    .line 9
    :try_start_3
    sget-boolean v0, Lcom/navipilot/obf/WideGoogleNav;->initialized:Z
    :try_end_5
    .catchall {:try_start_3 .. :try_end_5} :catchall_24

    if-eqz v0, :cond_9

    :goto_7
    monitor-exit p0

    return-void

    :cond_9
    const/4 v0, 0x1

    :try_start_a
    sput-boolean v0, Lcom/navipilot/obf/WideGoogleNav;->initialized:Z

    new-instance v0, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda0;

    invoke-direct {v0}, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda0;-><init>()V

    invoke-static {v0}, Ljava/util/concurrent/Executors;->newSingleThreadScheduledExecutor(Ljava/util/concurrent/ThreadFactory;)Ljava/util/concurrent/ScheduledExecutorService;

    move-result-object v1

    new-instance v2, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda1;

    invoke-direct {v2}, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda1;-><init>()V

    sget-object v7, Ljava/util/concurrent/TimeUnit;->MILLISECONDS:Ljava/util/concurrent/TimeUnit;

    const-wide/16 v3, 0x0

    const-wide/16 v5, 0x2bc

    invoke-interface/range {v1 .. v7}, Ljava/util/concurrent/ScheduledExecutorService;->scheduleWithFixedDelay(Ljava/lang/Runnable;JJLjava/util/concurrent/TimeUnit;)Ljava/util/concurrent/ScheduledFuture;

    goto :goto_7

    .line 9
    :catchall_24
    move-exception v0

    monitor-exit p0
    :try_end_26
    .catchall {:try_start_a .. :try_end_26} :catchall_24

    throw v0
.end method

.method static synthetic lambda$0(Ljava/lang/Runnable;)Ljava/lang/Thread;
    .registers 3

    .line 9
    new-instance v0, Ljava/lang/Thread;

    const-string v1, "GoogleNavInput"

    invoke-direct {v0, p0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    const/4 p0, 0x1

    invoke-virtual {v0, p0}, Ljava/lang/Thread;->setDaemon(Z)V

    return-object v0
.end method

.method static synthetic lambda$2(Landroid/app/Activity;Landroid/content/DialogInterface;I)V
    .registers 3

    .line 35
    :try_start_0
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p1

    const-string p2, "com.copilottw.googlenav"

    invoke-virtual {p1, p2}, Landroid/content/pm/PackageManager;->getLaunchIntentForPackage(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object p1

    if-eqz p1, :cond_10

    invoke-virtual {p0, p1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    goto :goto_2c

    :cond_10
    new-instance p1, Ljava/lang/IllegalStateException;

    invoke-direct {p1}, Ljava/lang/IllegalStateException;-><init>()V

    throw p1
    :try_end_16
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_16} :catch_16

    :catch_16
    move-exception p1

    new-instance p1, Landroid/app/AlertDialog$Builder;

    invoke-direct {p1, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string p0, "\u8acb\u5148\u5b89\u88dd\u914d\u5957\u7684 CP Google \u5c0e\u822a APK\u3002"

    invoke-virtual {p1, p0}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    const-string p1, "\u95dc\u9589"

    const/4 p2, 0x0

    invoke-virtual {p0, p1, p2}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :goto_2c
    return-void
.end method

.method private static poll()V
    .registers 15

    .line 16
    sget-boolean v0, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    if-nez v0, :cond_5

    return-void

    :cond_5
    sget-wide v0, Lcom/navipilot/obf/WideGoogleNav;->generation:J

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v2

    .line 17
    const-wide/16 v4, -0x1

    const/4 v6, 0x0

    :try_start_e
    const-string v7, "/nav"

    invoke-static {v7}, Lcom/navipilot/obf/WideGoogleNav;->get(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v7

    const-string v8, "routeVer"

    invoke-virtual {v7, v8, v4, v5}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v8

    .line 18
    const-class v10, Lcom/navipilot/obf/WideGoogleNav;

    monitor-enter v10
    :try_end_1d
    .catch Ljava/lang/Exception; {:try_start_e .. :try_end_1d} :catch_87

    :try_start_1d
    sget-wide v11, Lcom/navipilot/obf/WideGoogleNav;->geometryVersion:J

    cmp-long v11, v11, v8

    if-nez v11, :cond_34

    sget-object v11, Lcom/navipilot/obf/WideGoogleNav;->geometrySession:Ljava/lang/String;

    const-string v12, "sessionId"

    invoke-virtual {v7, v12}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v11, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_34

    sget-object v11, Lcom/navipilot/obf/WideGoogleNav;->geometry:Lorg/json/JSONObject;

    goto :goto_35

    :cond_34
    move-object v11, v6

    :goto_35
    monitor-exit v10
    :try_end_36
    .catchall {:try_start_1d .. :try_end_36} :catchall_84

    .line 19
    :try_start_36
    const-string v10, "navigating"

    const-string v12, "state"

    invoke-virtual {v7, v12}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v10, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_59

    if-nez v11, :cond_59

    const-string v10, "/route"

    invoke-static {v10}, Lcom/navipilot/obf/WideGoogleNav;->get(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v10

    const-string v12, "ver"

    const-wide/16 v13, -0x2

    invoke-virtual {v10, v12, v13, v14}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v12

    cmp-long v12, v12, v8

    if-nez v12, :cond_59

    move-object v11, v10

    .line 21
    :cond_59
    invoke-static {v7, v11, v2, v3}, Lcom/navipilot/obf/WideGoogleAdapter;->parse(Lorg/json/JSONObject;Lorg/json/JSONObject;J)Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    move-result-object v2

    .line 22
    const-class v3, Lcom/navipilot/obf/WideGoogleNav;

    monitor-enter v3
    :try_end_60
    .catch Ljava/lang/Exception; {:try_start_36 .. :try_end_60} :catch_87

    :try_start_60
    sget-boolean v10, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    if-eqz v10, :cond_7f

    sget-wide v12, Lcom/navipilot/obf/WideGoogleNav;->generation:J

    cmp-long v10, v12, v0

    if-eqz v10, :cond_6b

    goto :goto_7f

    :cond_6b
    sput-object v2, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    sput-object v11, Lcom/navipilot/obf/WideGoogleNav;->geometry:Lorg/json/JSONObject;

    sput-wide v8, Lcom/navipilot/obf/WideGoogleNav;->geometryVersion:J

    const-string v8, "sessionId"

    invoke-virtual {v7, v8}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    sput-object v7, Lcom/navipilot/obf/WideGoogleNav;->geometrySession:Ljava/lang/String;

    iget-object v2, v2, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->reason:Ljava/lang/String;

    sput-object v2, Lcom/navipilot/obf/WideGoogleNav;->state:Ljava/lang/String;

    monitor-exit v3

    goto :goto_9e

    :cond_7f
    :goto_7f
    monitor-exit v3

    return-void

    :catchall_81
    move-exception v2

    monitor-exit v3
    :try_end_83
    .catchall {:try_start_60 .. :try_end_83} :catchall_81

    :try_start_83
    throw v2
    :try_end_84
    .catch Ljava/lang/Exception; {:try_start_83 .. :try_end_84} :catch_87

    .line 18
    :catchall_84
    move-exception v2

    :try_start_85
    monitor-exit v10
    :try_end_86
    .catchall {:try_start_85 .. :try_end_86} :catchall_84

    :try_start_86
    throw v2
    :try_end_87
    .catch Ljava/lang/Exception; {:try_start_86 .. :try_end_87} :catch_87

    .line 23
    :catch_87
    move-exception v2

    const-class v2, Lcom/navipilot/obf/WideGoogleNav;

    monitor-enter v2

    :try_start_8b
    sget-wide v7, Lcom/navipilot/obf/WideGoogleNav;->generation:J

    cmp-long v0, v7, v0

    if-eqz v0, :cond_93

    monitor-exit v2

    return-void

    :cond_93
    sput-object v6, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    sput-object v6, Lcom/navipilot/obf/WideGoogleNav;->geometry:Lorg/json/JSONObject;

    sput-wide v4, Lcom/navipilot/obf/WideGoogleNav;->geometryVersion:J

    const-string v0, "Google \u5c0e\u822a\u8cc7\u6599\u672a\u5c31\u7dd2\uff0f\u904e\u671f\uff0c\u5df2\u64a4\u92b7"

    sput-object v0, Lcom/navipilot/obf/WideGoogleNav;->state:Ljava/lang/String;

    monitor-exit v2

    :goto_9e
    return-void

    :catchall_9f
    move-exception v0

    monitor-exit v2
    :try_end_a1
    .catchall {:try_start_8b .. :try_end_a1} :catchall_9f

    throw v0
.end method

.method public static declared-synchronized select(Ljava/lang/String;)V
    .registers 6

    const-class v0, Lcom/navipilot/obf/WideGoogleNav;

    monitor-enter v0

    .line 10
    :try_start_3
    const-string v1, "com.copilottw.googlenav"

    invoke-virtual {v1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    sget-boolean v1, Lcom/navipilot/obf/WideGoogleNav;->selected:Z
    :try_end_b
    .catchall {:try_start_3 .. :try_end_b} :catchall_2f

    if-ne v1, p0, :cond_f

    :goto_d
    monitor-exit v0

    return-void

    :cond_f
    :try_start_f
    sput-boolean p0, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    sget-wide v1, Lcom/navipilot/obf/WideGoogleNav;->generation:J

    const-wide/16 v3, 0x1

    add-long/2addr v1, v3

    sput-wide v1, Lcom/navipilot/obf/WideGoogleNav;->generation:J

    const/4 v1, 0x0

    sput-object v1, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    sput-object v1, Lcom/navipilot/obf/WideGoogleNav;->geometry:Lorg/json/JSONObject;

    const-wide/16 v1, -0x1

    sput-wide v1, Lcom/navipilot/obf/WideGoogleNav;->geometryVersion:J

    const-wide/16 v1, 0x0

    sput-wide v1, Lcom/navipilot/obf/WideGoogleNav;->suppliedAt:J

    if-eqz p0, :cond_2a

    const-string p0, "\u7b49\u5f85 CP Google \u5c0e\u822a\u8cc7\u6599"

    goto :goto_2c

    :cond_2a
    const-string p0, "\u672a\u9078\u64c7 CP Google \u5c0e\u822a"

    :goto_2c
    sput-object p0, Lcom/navipilot/obf/WideGoogleNav;->state:Ljava/lang/String;

    goto :goto_d

    .line 10
    :catchall_2f
    move-exception p0

    monitor-exit v0
    :try_end_31
    .catchall {:try_start_f .. :try_end_31} :catchall_2f

    throw p0
.end method

.method public static selected()Z
    .registers 1

    .line 11
    sget-boolean v0, Lcom/navipilot/obf/WideGoogleNav;->selected:Z

    return v0
.end method

.method public static show(Landroid/app/Activity;)V
    .registers 4

    .line 35
    new-instance v0, Landroid/app/AlertDialog$Builder;

    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "Google \u5c0e\u822a\u4e32\u63a5"

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-static {}, Lcom/navipilot/obf/WideGoogleNav;->status()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v2, "\n\n\u5728\u5c0e\u822a\u4f86\u6e90\u9078\u300eCP Google \u5c0e\u822a\u300f\uff0c\u65bc\u8a72\u756b\u9762\u8a2d\u5b9a\u81ea\u5df1\u7684\u91d1\u9470\u4e26\u958b\u59cb\u5c0e\u822a\u3002\u539f\u6709 Google Maps \u6295\u5c4f\u4ecd\u7368\u7acb\u4fdd\u7559\u3002"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setMessage(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    move-result-object v0

    new-instance v1, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda2;

    invoke-direct {v1, p0}, Lcom/navipilot/obf/WideGoogleNav$$ExternalSyntheticLambda2;-><init>(Landroid/app/Activity;)V

    const-string p0, "\u958b\u555f Google \u91d1\u9470\uff0f\u5c0e\u822a"

    invoke-virtual {v0, p0, v1}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    const-string v0, "\u95dc\u9589"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    move-result-object p0

    invoke-virtual {p0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method

.method public static status()Ljava/lang/String;
    .registers 7

    .line 32
    sget-object v0, Lcom/navipilot/obf/WideGoogleNav;->snapshot:Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;

    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v1

    if-eqz v0, :cond_14

    const-string v3, "navigation_status"

    invoke-virtual {v0, v3, v1, v2}, Lcom/navipilot/obf/WideGoogleAdapter$Snapshot;->value(Ljava/lang/String;J)Lorg/json/JSONObject;

    move-result-object v0

    if-nez v0, :cond_11

    goto :goto_14

    :cond_11
    sget-object v0, Lcom/navipilot/obf/WideGoogleNav;->state:Ljava/lang/String;

    goto :goto_16

    :cond_14
    :goto_14
    const-string v0, "\u76ee\u524d\u7121\u6709\u6548\u5c0e\u822a\u8cc7\u6599"

    .line 33
    :goto_16
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-static {v0}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v0, "\n\u4f86\u6e90\uff1aCP Google \u5c0e\u822a SDK\uff08\u672c\u6a5f\uff09\n"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-wide v3, Lcom/navipilot/obf/WideGoogleNav;->suppliedAt:J

    const-wide/16 v5, 0x0

    cmp-long v3, v3, v5

    if-lez v3, :cond_39

    sget-wide v3, Lcom/navipilot/obf/WideGoogleNav;->suppliedAt:J

    sub-long/2addr v1, v3

    const-wide/16 v3, 0xbb8

    cmp-long v1, v1, v3

    if-gez v1, :cond_39

    const-string v1, "\u5df2\u4ea4\u7d66\u539f\u6709 Navi v2 \u50b3\u9001\u6d41\u7a0b"

    goto :goto_3b

    :cond_39
    const-string v1, "\u7b49\u5f85\u539f\u6709 Navi v2 \u901a\u9053"

    :goto_3b
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n\u5c1a\u4e0d\u4ee3\u8868 C4 \u5df2\u63a5\u6536\uff1b\u5b98\u65b9 Google Maps \u6295\u5c4f\u4e0d\u63d0\u4f9b\u6b64\u8cc7\u6599\u3002"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
