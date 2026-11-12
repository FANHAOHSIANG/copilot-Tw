.class final Lcom/navipilot/obf/WideDirect$LayoutStamp;
.super Ljava/lang/Object;
.source "WideDirect.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/navipilot/obf/WideDirect;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "LayoutStamp"
.end annotation


# instance fields
.field final density:I

.field final height:I

.field final preferences:I

.field final width:I


# direct methods
.method constructor <init>(IIII)V
    .registers 5

    .line 488
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 489
    iput p1, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->width:I

    .line 490
    iput p2, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->height:I

    .line 491
    iput p3, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->density:I

    .line 492
    iput p4, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->preferences:I

    .line 493
    return-void
.end method


# virtual methods
.method same(Lcom/navipilot/obf/WideDirect$LayoutStamp;)Z
    .registers 4

    .line 496
    iget v0, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->width:I

    iget v1, p1, Lcom/navipilot/obf/WideDirect$LayoutStamp;->width:I

    if-ne v0, v1, :cond_1a

    iget v0, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->height:I

    iget v1, p1, Lcom/navipilot/obf/WideDirect$LayoutStamp;->height:I

    if-ne v0, v1, :cond_1a

    iget v0, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->density:I

    iget v1, p1, Lcom/navipilot/obf/WideDirect$LayoutStamp;->density:I

    if-ne v0, v1, :cond_1a

    .line 497
    iget v0, p0, Lcom/navipilot/obf/WideDirect$LayoutStamp;->preferences:I

    iget p1, p1, Lcom/navipilot/obf/WideDirect$LayoutStamp;->preferences:I

    if-ne v0, p1, :cond_1a

    .line 496
    const/4 p1, 0x1

    return p1

    :cond_1a
    const/4 p1, 0x0

    return p1
.end method
