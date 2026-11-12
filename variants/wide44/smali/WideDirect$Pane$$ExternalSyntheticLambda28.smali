.class public final synthetic Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda28;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideDirect$Session;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideDirect$Session;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda28;->f$0:Lcom/navipilot/obf/WideDirect$Session;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 2

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda28;->f$0:Lcom/navipilot/obf/WideDirect$Session;

    invoke-virtual {v0}, Lcom/navipilot/obf/WideDirect$Session;->close()V

    return-void
.end method
