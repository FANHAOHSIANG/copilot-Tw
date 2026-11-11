.class final Lcom/navipilot/obf/WideCameraVoice;
.super Ljava/lang/Object;
.source "WideCameraVoice.java"


# static fields
.field private static lastStatus:Ljava/lang/String; = "尚未收到語音目標"
.field private static final ASSET:Ljava/lang/String; = "tw_camera_voice_a.mp3"

.field private static final PREF:Ljava/lang/String; = "taiwan_camera_voice"

.field private static final REARM_MS:J = 0x1d4c0L

.field private static active:Landroid/media/MediaPlayer;

.field private static selectedAsset:Ljava/lang/String;

.field private static final spoken:Ljava/util/HashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashMap<",
            "Ljava/lang/String;",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method public static synthetic $r8$lambda$msCB6TCaTMuEALMrIVO1xHyXo9I(Landroid/media/MediaPlayer;)V
    .locals 0

    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    .line 16
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->spoken:Ljava/util/HashMap;

    .line 17
    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static enabled(Landroid/content/Context;)Z
    .locals 2

    .line 20
    const-string v0, "taiwan_camera_voice"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "enabled"

    const/4 v1, 0x1

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method static synthetic lambda$0(JLjava/lang/Long;)Z
    .locals 2

    .line 31
    invoke-virtual {p2}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    sub-long/2addr p0, v0

    const-wide/32 v0, 0x1d4c0

    cmp-long p0, p0, v0

    if-ltz p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method static synthetic lambda$1(Landroid/content/Context;ZLandroid/media/MediaPlayer;)V
    .locals 1

    .line 50
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-eq v0, p2, :cond_0

    return-void

    .line 52
    :cond_0
    :try_start_0
    invoke-virtual {p2}, Landroid/media/MediaPlayer;->start()V
    :try_end_0
    .catch Ljava/lang/IllegalStateException; {:try_start_0 .. :try_end_0} :catch_0

    .line 53
    goto :goto_0

    :catch_0
    move-exception v0

    .line 54
    invoke-static {p2}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    .line 55
    invoke-static {p0, p1}, Lcom/navipilot/obf/WideCameraVoice;->reportFailure(Landroid/content/Context;Z)V

    .line 57
    :goto_0
    return-void
.end method

.method static synthetic lambda$3(Landroid/content/Context;ZLandroid/media/MediaPlayer;II)Z
    .locals 0

    .line 60
    invoke-static {p2}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    .line 61
    invoke-static {p0, p1}, Lcom/navipilot/obf/WideCameraVoice;->reportFailure(Landroid/content/Context;Z)V

    .line 62
    const/4 p0, 0x1

    return p0
.end method

.method static observe(Landroid/content/Context;Ljava/lang/String;J)V
    .locals 2

    .line 30
    if-eqz p1, :cond_4

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_4

    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->enabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    const-string v0, "語音已關閉"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    return-void

    .line 31
    :cond_0
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->spoken:Ljava/util/HashMap;

    invoke-virtual {v0}, Ljava/util/HashMap;->values()Ljava/util/Collection;

    move-result-object v0

    new-instance v1, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda0;

    invoke-direct {v1, p2, p3}, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda0;-><init>(J)V

    invoke-interface {v0, v1}, Ljava/util/Collection;->removeIf(Ljava/util/function/Predicate;)Z

    .line 32
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->spoken:Ljava/util/HashMap;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v0, p1, v1}, Ljava/util/HashMap;->replace(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_3

    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_1

    const-string v0, "正在播放其他語音，等待重試"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    goto :goto_0

    .line 33
    :cond_1
    const/4 v0, 0x0

    invoke-static {p1}, Lcom/navipilot/obf/WideCameraTrace;->voiceAsset(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/navipilot/obf/WideCameraVoice;->selectedAsset:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideCameraVoice;->play(Landroid/content/Context;Z)Z

    move-result p0

    const-string v0, "播放請求失敗，等待重試"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    if-eqz p0, :cond_2
    const-string v0, "已提交播放請求；不代表已聽到聲音"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;

    sget-object p0, Lcom/navipilot/obf/WideCameraVoice;->spoken:Ljava/util/HashMap;

    invoke-static {p2, p3}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object p2

    invoke-virtual {p0, p1, p2}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 34
    :cond_2
    return-void

    .line 32
    :cond_3
    const-string v0, "同一測速點重複提醒抑制中"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    :goto_0
    return-void

    .line 30
    :cond_4
    :goto_1
    const-string v0, "目前無 1 公里內語音目標"
    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    return-void
.end method

.method private static play(Landroid/content/Context;Z)Z
    .locals 10

    .line 42
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 43
    new-instance v1, Landroid/media/MediaPlayer;

    invoke-direct {v1}, Landroid/media/MediaPlayer;-><init>()V

    .line 44
    const/4 v7, 0x0

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    sget-object v2, Lcom/navipilot/obf/WideCameraVoice;->selectedAsset:Ljava/lang/String;

    invoke-virtual {v0, v2}, Landroid/content/res/AssetManager;->openFd(Ljava/lang/String;)Landroid/content/res/AssetFileDescriptor;

    move-result-object v8
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 45
    :try_start_1
    new-instance v0, Landroid/media/AudioAttributes$Builder;

    invoke-direct {v0}, Landroid/media/AudioAttributes$Builder;-><init>()V

    .line 46
    const/16 v2, 0xc

    invoke-virtual {v0, v2}, Landroid/media/AudioAttributes$Builder;->setUsage(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v0

    .line 47
    const/4 v9, 0x1

    invoke-virtual {v0, v9}, Landroid/media/AudioAttributes$Builder;->setContentType(I)Landroid/media/AudioAttributes$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/media/AudioAttributes$Builder;->build()Landroid/media/AudioAttributes;

    move-result-object v0

    .line 45
    invoke-virtual {v1, v0}, Landroid/media/MediaPlayer;->setAudioAttributes(Landroid/media/AudioAttributes;)V

    .line 48
    invoke-virtual {v8}, Landroid/content/res/AssetFileDescriptor;->getFileDescriptor()Ljava/io/FileDescriptor;

    move-result-object v2

    invoke-virtual {v8}, Landroid/content/res/AssetFileDescriptor;->getStartOffset()J

    move-result-wide v3

    invoke-virtual {v8}, Landroid/content/res/AssetFileDescriptor;->getLength()J

    move-result-wide v5

    invoke-virtual/range {v1 .. v6}, Landroid/media/MediaPlayer;->setDataSource(Ljava/io/FileDescriptor;JJ)V

    .line 49
    new-instance v0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;

    invoke-direct {v0, p0, p1}, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;-><init>(Landroid/content/Context;Z)V

    invoke-virtual {v1, v0}, Landroid/media/MediaPlayer;->setOnPreparedListener(Landroid/media/MediaPlayer$OnPreparedListener;)V

    .line 58
    new-instance v0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda2;

    invoke-direct {v0}, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda2;-><init>()V

    invoke-virtual {v1, v0}, Landroid/media/MediaPlayer;->setOnCompletionListener(Landroid/media/MediaPlayer$OnCompletionListener;)V

    .line 59
    new-instance v0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;

    invoke-direct {v0, p0, p1}, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;-><init>(Landroid/content/Context;Z)V

    invoke-virtual {v1, v0}, Landroid/media/MediaPlayer;->setOnErrorListener(Landroid/media/MediaPlayer$OnErrorListener;)V

    .line 64
    sput-object v1, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    .line 65
    invoke-virtual {v1}, Landroid/media/MediaPlayer;->prepareAsync()V
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 67
    if-eqz v8, :cond_0

    :try_start_2
    invoke-virtual {v8}, Landroid/content/res/AssetFileDescriptor;->close()V

    .line 66
    :cond_0
    return v9

    :catchall_0
    move-exception v0

    move-object v7, v0

    .line 67
    if-eqz v8, :cond_1

    invoke-virtual {v8}, Landroid/content/res/AssetFileDescriptor;->close()V

    :cond_1
    throw v7
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    :catchall_1
    move-exception v0

    if-eqz v7, :cond_3

    if-eq v7, v0, :cond_2

    :try_start_3
    invoke-virtual {v7, v0}, Ljava/lang/Throwable;->addSuppressed(Ljava/lang/Throwable;)V

    :cond_2
    move-object v0, v7

    :cond_3
    throw v0
    :try_end_3
    .catch Ljava/io/IOException; {:try_start_3 .. :try_end_3} :catch_0
    .catch Ljava/lang/RuntimeException; {:try_start_3 .. :try_end_3} :catch_0

    :catch_0
    move-exception v0

    .line 68
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-ne v0, v1, :cond_4

    invoke-static {v1}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    goto :goto_0

    .line 69
    :cond_4
    invoke-virtual {v1}, Landroid/media/MediaPlayer;->release()V

    .line 70
    :goto_0
    invoke-static {p0, p1}, Lcom/navipilot/obf/WideCameraVoice;->reportFailure(Landroid/content/Context;Z)V

    .line 71
    const/4 p0, 0x0

    return p0
.end method

.method static preview(Landroid/content/Context;)V
    .locals 1

    const-string v0, "tw_camera_voice_a.mp3"

    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->selectedAsset:Ljava/lang/String;

    .line 37
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    invoke-static {v0}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    .line 38
    :cond_0
    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideCameraVoice;->play(Landroid/content/Context;Z)Z

    .line 39
    return-void
.end method

.method private static release(Landroid/media/MediaPlayer;)V
    .locals 1

    .line 76
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-eq v0, p0, :cond_0

    return-void

    .line 77
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    .line 78
    invoke-virtual {p0}, Landroid/media/MediaPlayer;->release()V

    .line 79
    return-void
.end method

.method private static reportFailure(Landroid/content/Context;Z)V
    .locals 1

    .line 82
    if-eqz p1, :cond_0

    const-string p1, "\u6e2c\u901f\u8a9e\u97f3\u64ad\u653e\u5931\u6557"

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    .line 83
    :cond_0
    return-void
.end method

.method static toggle(Landroid/content/Context;)V
    .locals 4

    .line 24
    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->enabled(Landroid/content/Context;)Z

    move-result v0

    .line 25
    xor-int/lit8 v1, v0, 0x1

    const-string v2, "taiwan_camera_voice"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v2, "enabled"

    invoke-interface {p0, v2, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 26
    if-eqz v0, :cond_0

    sget-object p0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    if-eqz p0, :cond_0

    sget-object p0, Lcom/navipilot/obf/WideCameraVoice;->active:Landroid/media/MediaPlayer;

    invoke-static {p0}, Lcom/navipilot/obf/WideCameraVoice;->release(Landroid/media/MediaPlayer;)V

    .line 27
    :cond_0
    return-void
.end method

.method static status()Ljava/lang/String;
    .locals 1
    sget-object v0, Lcom/navipilot/obf/WideCameraVoice;->lastStatus:Ljava/lang/String;
    return-object v0
.end method
