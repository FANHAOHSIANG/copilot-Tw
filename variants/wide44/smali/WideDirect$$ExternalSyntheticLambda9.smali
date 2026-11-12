.class public final synthetic Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda9;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/Mt;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/Mt;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda9;->f$0:Lcom/navipilot/obf/Mt;

    return-void
.end method


# virtual methods
.method public final run()V
    .registers 2

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda9;->f$0:Lcom/navipilot/obf/Mt;

    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->lambda$0(Lcom/navipilot/obf/Mt;)V

    return-void
.end method
