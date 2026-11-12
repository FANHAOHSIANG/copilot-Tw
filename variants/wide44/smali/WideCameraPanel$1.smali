.class Lcom/navipilot/obf/WideCameraPanel$1;
.super Ljava/lang/Object;
.source "WideCameraPanel.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideCameraPanel;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/navipilot/obf/WideCameraPanel;


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideCameraPanel;)V
    .registers 2

    .line 26
    iput-object p1, p0, Lcom/navipilot/obf/WideCameraPanel$1;->this$0:Lcom/navipilot/obf/WideCameraPanel;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    .line 28
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$1;->this$0:Lcom/navipilot/obf/WideCameraPanel;

    # getter for: Lcom/navipilot/obf/WideCameraPanel;->disposed:Z
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraPanel;->access$0(Lcom/navipilot/obf/WideCameraPanel;)Z

    move-result v0

    if-eqz v0, :cond_9

    return-void

    .line 29
    :cond_9
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$1;->this$0:Lcom/navipilot/obf/WideCameraPanel;

    # invokes: Lcom/navipilot/obf/WideCameraPanel;->updateButtons()V
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraPanel;->access$1(Lcom/navipilot/obf/WideCameraPanel;)V

    .line 30
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$1;->this$0:Lcom/navipilot/obf/WideCameraPanel;

    # getter for: Lcom/navipilot/obf/WideCameraPanel;->dashboard:Lcom/navipilot/obf/WideCameraCard;
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraPanel;->access$2(Lcom/navipilot/obf/WideCameraPanel;)Lcom/navipilot/obf/WideCameraCard;

    move-result-object v0

    invoke-virtual {v0}, Lcom/navipilot/obf/WideCameraCard;->invalidate()V

    .line 31
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$1;->this$0:Lcom/navipilot/obf/WideCameraPanel;

    # getter for: Lcom/navipilot/obf/WideCameraPanel;->main:Landroid/os/Handler;
    invoke-static {v0}, Lcom/navipilot/obf/WideCameraPanel;->access$3(Lcom/navipilot/obf/WideCameraPanel;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x12c

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 32
    return-void
.end method
