.class final Lcom/navipilot/obf/WideDirect$RenderSize;
.super Ljava/lang/Object;
.source "WideDirect.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideDirect;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "RenderSize"
.end annotation


# instance fields
.field final density:I

.field final height:I

.field final width:I


# direct methods
.method constructor <init>(III)V
    .registers 4

    .line 474
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 475
    iput p1, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    .line 476
    iput p2, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    .line 477
    iput p3, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I

    .line 478
    return-void
.end method


# virtual methods
.method same(Lcom/navipilot/obf/WideDirect$RenderSize;)Z
    .registers 4

    .line 481
    iget v0, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    iget v1, p1, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I

    if-ne v0, v1, :cond_14

    iget v0, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    iget v1, p1, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I

    if-ne v0, v1, :cond_14

    iget v0, p0, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I

    iget p1, p1, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I

    if-ne v0, p1, :cond_14

    const/4 p1, 0x1

    return p1

    :cond_14
    const/4 p1, 0x0

    return p1
.end method
