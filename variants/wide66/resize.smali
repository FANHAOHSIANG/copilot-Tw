.method private resizeDisplay()V
    .locals 5

    .line 450
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->surfaceReady()Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 451
    :cond_0
    invoke-static {}, Lcom/navipilot/obf/WideDivider;->isDragging()Z

    move-result v0

    if-eqz v0, :cond_1

    .line 452
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    const-wide/16 v2, 0xc8

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 453
    return-void

    .line 455
    :cond_1
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->getRootWindowInsets()Landroid/view/WindowInsets;

    move-result-object v0

    .line 456
    if-eqz v0, :cond_2

    invoke-static {}, Landroid/view/WindowInsets$Type;->ime()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/WindowInsets;->isVisible(I)Z

    move-result v0

    if-eqz v0, :cond_2

    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;

    move-result-object v0

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->resize:Ljava/lang/Runnable;

    const-wide/16 v2, 0x1f4

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void

    .line 458
    :cond_2
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;

    .line 459
    if-nez v0, :cond_3

    .line 460
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V

    .line 461
    return-void

    .line 463
    :cond_3
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->layoutStamp()Lcom/navipilot/obf/WideDirect$LayoutStamp;

    move-result-object v1

    .line 464
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->renderSize()Lcom/navipilot/obf/WideDirect$RenderSize;

    move-result-object v2

    .line 465
    iget-object v3, v0, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;

    invoke-virtual {v1, v3}, Lcom/navipilot/obf/WideDirect$LayoutStamp;->same(Lcom/navipilot/obf/WideDirect$LayoutStamp;)Z

    move-result v3

    if-eqz v3, :cond_4

    iget-object v3, v0, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    invoke-virtual {v2, v3}, Lcom/navipilot/obf/WideDirect$RenderSize;->same(Lcom/navipilot/obf/WideDirect$RenderSize;)Z

    move-result v3

    if-eqz v3, :cond_4

    return-void

    .line 466
    :cond_4
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$0()Ljava/util/concurrent/ExecutorService;

    move-result-object v3

    new-instance v4, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda9;

    invoke-direct {v4, p0, v0, v2, v1}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda9;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;Lcom/navipilot/obf/WideDirect$LayoutStamp;)V

    invoke-interface {v3, v4}, Ljava/util/concurrent/ExecutorService;->execute(Ljava/lang/Runnable;)V

    .line 486
    return-void
.end method
