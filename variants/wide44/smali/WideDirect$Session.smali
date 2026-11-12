.class final Lcom/navipilot/obf/WideDirect$Session;
.super Ljava/lang/Object;
.source "WideDirect.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideDirect;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "Session"
.end annotation


# instance fields
.field final api:Lcom/navipilot/obf/Mt;

.field volatile closed:Z

.field final id:I

.field volatile layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

.field volatile size:Lcom/navipilot/obf/WideDirect$RenderSize;

.field final surface:Landroid/view/Surface;


# direct methods
.method constructor <init>(Lcom/navipilot/obf/Mt;ILandroid/view/Surface;Lcom/navipilot/obf/WideDirect$RenderSize;Lcom/navipilot/obf/WideDirect$LayoutStamp;)V
    .registers 6

    .line 509
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 510
    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;

    .line 511
    iput p2, p0, Lcom/navipilot/obf/WideDirect$Session;->id:I

    .line 512
    iput-object p3, p0, Lcom/navipilot/obf/WideDirect$Session;->surface:Landroid/view/Surface;

    .line 513
    iput-object p4, p0, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    .line 514
    iput-object p5, p0, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

    .line 515
    return-void
.end method


# virtual methods
.method close()V
    .registers 3

    .line 518
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Session;->closed:Z

    if-eqz v0, :cond_5

    return-void

    .line 519
    :cond_5
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Session;->closed:Z

    .line 520
    :try_start_8
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;

    iget v1, p0, Lcom/navipilot/obf/WideDirect$Session;->id:I

    invoke-interface {v0, v1}, Lcom/navipilot/obf/Mt;->a(I)V
    :try_end_f
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_f} :catch_17
    .catchall {:try_start_8 .. :try_end_f} :catchall_10

    goto :goto_18

    .line 522
    :catchall_10
    move-exception v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Session;->surface:Landroid/view/Surface;

    invoke-virtual {v1}, Landroid/view/Surface;->release()V

    throw v0

    .line 521
    :catch_17
    move-exception v0

    .line 522
    :goto_18
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Session;->surface:Landroid/view/Surface;

    invoke-virtual {v0}, Landroid/view/Surface;->release()V

    .line 523
    return-void
.end method
