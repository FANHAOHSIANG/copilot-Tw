.class Lcom/navipilot/obf/WideDirect$Pane$1;
.super Ljava/lang/Object;
.source "WideDirect.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/navipilot/obf/WideDirect$Pane;-><init>(Landroid/content/Context;ZLcom/navipilot/obf/tr;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/navipilot/obf/WideDirect$Pane;


# direct methods
.method constructor <init>(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 2

    .line 165
    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$1;->this$1:Lcom/navipilot/obf/WideDirect$Pane;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 15

    .line 166
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$1;->this$1:Lcom/navipilot/obf/WideDirect$Pane;

    iget-object v3, v0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    const/4 v0, 0x1

    if-nez v3, :cond_8

    return v0

    .line 167
    :cond_8
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionIndex()I

    move-result v2

    .line 168
    const/4 v4, 0x5

    const/4 v5, 0x0

    if-ne v1, v4, :cond_15

    move v1, v5

    .line 169
    :cond_15
    const/4 v4, 0x6

    if-ne v1, v4, :cond_1a

    move v4, v0

    goto :goto_1b

    :cond_1a
    move v4, v1

    .line 170
    :goto_1b
    const/4 v1, 0x2

    if-eqz v4, :cond_26

    if-eq v4, v0, :cond_26

    if-eq v4, v1, :cond_26

    const/4 v6, 0x3

    if-eq v4, v6, :cond_26

    return v0

    .line 171
    :cond_26
    if-ne v4, v1, :cond_3d

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v6

    iget-object v8, p0, Lcom/navipilot/obf/WideDirect$Pane$1;->this$1:Lcom/navipilot/obf/WideDirect$Pane;

    iget-wide v8, v8, Lcom/navipilot/obf/WideDirect$Pane;->lastMove:J

    sub-long v8, v6, v8

    const-wide/16 v10, 0x20

    cmp-long v8, v8, v10

    if-gez v8, :cond_39

    return v0

    :cond_39
    iget-object v8, p0, Lcom/navipilot/obf/WideDirect$Pane$1;->this$1:Lcom/navipilot/obf/WideDirect$Pane;

    iput-wide v6, v8, Lcom/navipilot/obf/WideDirect$Pane;->lastMove:J

    .line 172
    :cond_3d
    iget-object v6, p0, Lcom/navipilot/obf/WideDirect$Pane$1;->this$1:Lcom/navipilot/obf/WideDirect$Pane;

    invoke-virtual {v6}, Lcom/navipilot/obf/WideDirect$Pane;->getParent()Landroid/view/ViewParent;

    move-result-object v6

    invoke-interface {v6, v0}, Landroid/view/ViewParent;->requestDisallowInterceptTouchEvent(Z)V

    .line 173
    if-ne v4, v1, :cond_49

    goto :goto_4a

    :cond_49
    move v5, v2

    :goto_4a
    if-ne v4, v1, :cond_51

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v1

    goto :goto_53

    :cond_51
    add-int/lit8 v1, v2, 0x1

    :goto_53
    move v8, v1

    .line 174
    move v9, v5

    :goto_55
    if-lt v9, v8, :cond_58

    .line 179
    return v0

    .line 175
    :cond_58
    invoke-virtual {p2, v9}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v7

    if-le v7, v0, :cond_5f

    goto :goto_9c

    .line 176
    :cond_5f
    invoke-virtual {p2, v9}, Landroid/view/MotionEvent;->getX(I)F

    move-result v1

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    invoke-static {v0, v2}, Ljava/lang/Math;->max(II)I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v1, v2

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-static {v2, v1}, Ljava/lang/Math;->min(FF)F

    move-result v1

    const/4 v5, 0x0

    invoke-static {v5, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    invoke-virtual {p2, v9}, Landroid/view/MotionEvent;->getY(I)F

    move-result v6

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v10

    invoke-static {v0, v10}, Ljava/lang/Math;->max(II)I

    move-result v10

    int-to-float v10, v10

    div-float/2addr v6, v10

    invoke-static {v2, v6}, Ljava/lang/Math;->min(FF)F

    move-result v2

    invoke-static {v5, v2}, Ljava/lang/Math;->max(FF)F

    move-result v6

    .line 177
    # getter for: Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v10

    move v5, v1

    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$1$1;

    move-object v2, p0

    invoke-direct/range {v1 .. v7}, Lcom/navipilot/obf/WideDirect$Pane$1$1;-><init>(Lcom/navipilot/obf/WideDirect$Pane$1;Lcom/navipilot/obf/WideDirect$Session;IFFI)V

    invoke-interface {v10, v1}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 174
    :goto_9c
    add-int/lit8 v9, v9, 0x1

    goto :goto_55
.end method
