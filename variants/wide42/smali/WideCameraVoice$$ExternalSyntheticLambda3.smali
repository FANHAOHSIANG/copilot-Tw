.class public final synthetic Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/media/MediaPlayer$OnErrorListener;


# instance fields
.field public final synthetic f$0:Landroid/content/Context;

.field public final synthetic f$1:Z


# direct methods
.method public synthetic constructor <init>(Landroid/content/Context;Z)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;->f$0:Landroid/content/Context;

    iput-boolean p2, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;->f$1:Z

    return-void
.end method


# virtual methods
.method public final onError(Landroid/media/MediaPlayer;II)Z
    .locals 2

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;->f$0:Landroid/content/Context;

    iget-boolean v1, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda3;->f$1:Z

    invoke-static {v0, v1, p1, p2, p3}, Lcom/navipilot/obf/WideCameraVoice;->lambda$3(Landroid/content/Context;ZLandroid/media/MediaPlayer;II)Z

    move-result p1

    return p1
.end method
