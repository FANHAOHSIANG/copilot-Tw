.method synthetic lambda$13$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;Lcom/navipilot/obf/WideDirect$LayoutStamp;)V
    .locals 5

    iget-boolean v0, p1, Lcom/navipilot/obf/WideDirect$Session;->closed:Z
    if-nez v0, :done

    :try_start
    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->api:Lcom/navipilot/obf/Mt;
    iget v1, p1, Lcom/navipilot/obf/WideDirect$Session;->id:I
    iget v2, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->width:I
    iget v3, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->height:I
    iget v4, p2, Lcom/navipilot/obf/WideDirect$RenderSize;->density:I
    invoke-static {v0, v1, v2, v3, v4}, Lcom/navipilot/obf/WideDisplayResize;->send(Lcom/navipilot/obf/Mt;IIII)Z
    move-result v0
    :try_end
    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_resize

    if-eqz v0, :rejected
    iput-object p3, p1, Lcom/navipilot/obf/WideDirect$Session;->layout:Lcom/navipilot/obf/WideDirect$LayoutStamp;
    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda13;
    invoke-direct {v1, p0, p1, p2}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda13;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;)V
    goto :post

    :catch_resize
    move-exception v0

    :rejected
    new-instance v1, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda11;
    invoke-direct {v1, p0, p1}, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda11;-><init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;)V

    :post
    invoke-static {}, Lcom/navipilot/obf/WideDirect;->access$7()Landroid/os/Handler;
    move-result-object v0
    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :done
    return-void
.end method
