.method static paneFor(Landroid/view/View;Z)Lcom/navipilot/obf/WideDirect$Pane;
    .locals 5

    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v0
    sget-object v1, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    add-int/lit8 v2, v2, -1

    :next
    if-ltz v2, :missing
    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Ljava/lang/ref/WeakReference;
    invoke-virtual {v3}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v3
    check-cast v3, Lcom/navipilot/obf/WideDirect$Pane;
    if-eqz v3, :skip
    iget-boolean v4, v3, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z
    if-eqz v4, :skip
    iget-boolean v4, v3, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z
    if-nez v4, :skip
    iget-boolean v4, v3, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z
    if-ne v4, p1, :skip
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v4
    if-ne v0, v4, :skip
    return-object v3

    :skip
    add-int/lit8 v2, v2, -1
    goto :next

    :missing
    const/4 v3, 0x0
    return-object v3
.end method
