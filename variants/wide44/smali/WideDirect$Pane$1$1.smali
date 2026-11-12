.class Lcom/navipilot/obf/WideDirect$Pane$1$1;
.super Ljava/lang/Object;
.source "WideDirect.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/navipilot/obf/WideDirect$Pane$1;->onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$2:Lcom/navipilot/obf/WideDirect$Pane$1;

.field private final synthetic val$a:I

.field private final synthetic val$pointer:I

.field private final synthetic val$s:Lcom/navipilot/obf/WideDirect$Session;

.field private final synthetic val$x:F

.field private final synthetic val$y:F


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideDirect$Pane$1;Lcom/navipilot/obf/WideDirect$Session;IFFI)V
    .registers 7

    .line 177
    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->this$2:Lcom/navipilot/obf/WideDirect$Pane$1;

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$s:Lcom/navipilot/obf/WideDirect$Session;

    iput p3, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$a:I

    iput p4, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$x:F

    iput p5, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$y:F

    iput p6, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$pointer:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 9

    .line 177
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$s:Lcom/navipilot/obf/WideDirect$Session;

    iget-boolean v0, v0, Lcom/navipilot/obf/WideDirect$Session;->closed:Z

    if-eqz v0, :cond_7

    return-void

    :cond_7
    :try_start_7
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$s:Lcom/navipilot/obf/WideDirect$Session;

    iget-object v1, v0, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$s:Lcom/navipilot/obf/WideDirect$Session;

    iget v2, v0, Lcom/navipilot/obf/WideDirect$Session;->id:I

    iget v4, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$a:I

    iget v5, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$x:F

    iget v6, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$y:F

    iget v7, p0, Lcom/navipilot/obf/WideDirect$Pane$1$1;->val$pointer:I

    const/16 v3, 0x4d

    invoke-interface/range {v1 .. v7}, Lcom/navipilot/obf/Mt;->h(IIIFFI)Z
    :try_end_1c
    .catch Ljava/lang/Exception; {:try_start_7 .. :try_end_1c} :catch_1d

    goto :goto_1e

    :catch_1d
    move-exception v0

    :goto_1e
    return-void
.end method
