.class public final synthetic Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideDirect$Pane;

.field public final synthetic f$1:Lcom/navipilot/obf/WideDirect$Session;

.field public final synthetic f$2:Lcom/navipilot/obf/WideDirect$RenderSize;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideDirect$Pane;Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;)V
    .registers 4

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$1:Lcom/navipilot/obf/WideDirect$Session;

    iput-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$2:Lcom/navipilot/obf/WideDirect$RenderSize;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 4

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    iget-object v1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$1:Lcom/navipilot/obf/WideDirect$Session;

    iget-object v2, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda26;->f$2:Lcom/navipilot/obf/WideDirect$RenderSize;

    invoke-virtual {v0, v1, v2}, Lcom/navipilot/obf/WideDirect$Pane;->lambda$13$com-navipilot-obf-WideDirect$Pane(Lcom/navipilot/obf/WideDirect$Session;Lcom/navipilot/obf/WideDirect$RenderSize;)V

    return-void
.end method
