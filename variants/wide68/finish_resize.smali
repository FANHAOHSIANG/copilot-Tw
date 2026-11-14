.method private finishResize(Lcom/navipilot/obf/WideDirect$Session;Z)V
    .locals 4

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;
    if-ne v0, p1, :done

    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->pendingSize:Lcom/navipilot/obf/WideDirect$RenderSize;
    const/4 v1, 0x0
    iput-object v1, p1, Lcom/navipilot/obf/WideDirect$Session;->pendingSize:Lcom/navipilot/obf/WideDirect$RenderSize;
    if-eqz v0, :done

    if-eqz p2, :check_surface
    iput-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;

    :check_surface
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->surfaceReady()Z
    move-result v1
    if-eqz v1, :done
    if-eqz p2, :compare

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane;->source:Landroid/graphics/SurfaceTexture;
    iget v2, v0, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I
    iget v3, v0, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I
    invoke-virtual {v1, v2, v3}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V
    invoke-direct {p0, v0}, Lcom/navipilot/obf/WideDirect$Pane;->showConnected(Lcom/navipilot/obf/WideDirect$RenderSize;)V

    :compare
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->renderSize()Lcom/navipilot/obf/WideDirect$RenderSize;
    move-result-object v1
    invoke-virtual {v1, v0}, Lcom/navipilot/obf/WideDirect$RenderSize;->same(Lcom/navipilot/obf/WideDirect$RenderSize;)Z
    move-result v1
    if-nez v1, :done
    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->resizeDisplay()V

    :done
    return-void
.end method
