.class public final synthetic Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideDirect$Pane;

.field public final synthetic f$1:I

.field public final synthetic f$2:Lcom/navipilot/obf/WideDirect$Session;

.field public final synthetic f$3:Ljava/lang/String;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideDirect$Pane;ILcom/navipilot/obf/WideDirect$Session;Ljava/lang/String;)V
    .registers 5

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    iput p2, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$1:I

    iput-object p3, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$2:Lcom/navipilot/obf/WideDirect$Session;

    iput-object p4, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$3:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 5

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    iget v1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$1:I

    iget-object v2, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$2:Lcom/navipilot/obf/WideDirect$Session;

    iget-object v3, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda22;->f$3:Ljava/lang/String;

    invoke-virtual {v0, v1, v2, v3}, Lcom/navipilot/obf/WideDirect$Pane;->lambda$10$com-navipilot-obf-WideDirect$Pane(ILcom/navipilot/obf/WideDirect$Session;Ljava/lang/String;)V

    return-void
.end method
