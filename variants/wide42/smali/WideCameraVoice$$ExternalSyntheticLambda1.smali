.class public final synthetic Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/media/MediaPlayer$OnPreparedListener;


# instance fields
.field public final synthetic f$0:Landroid/content/Context;

.field public final synthetic f$1:Z


# direct methods
.method public synthetic constructor <init>(Landroid/content/Context;Z)V
    .locals 0

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;->f$0:Landroid/content/Context;

    iput-boolean p2, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;->f$1:Z

    return-void
.end method


# virtual methods
.method public final onPrepared(Landroid/media/MediaPlayer;)V
    .locals 2

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;->f$0:Landroid/content/Context;

    iget-boolean v1, p0, Lcom/navipilot/obf/WideCameraVoice$$ExternalSyntheticLambda1;->f$1:Z

    invoke-static {v0, v1, p1}, Lcom/navipilot/obf/WideCameraVoice;->lambda$1(Landroid/content/Context;ZLandroid/media/MediaPlayer;)V

    return-void
.end method
