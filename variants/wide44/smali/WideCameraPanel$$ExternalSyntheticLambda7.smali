.class public final synthetic Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda7;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideCameraPanel;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideCameraPanel;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda7;->f$0:Lcom/navipilot/obf/WideCameraPanel;

    return-void
.end method


# virtual methods
.method public final onClick(Landroid/view/View;)V
    .registers 3

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda7;->f$0:Lcom/navipilot/obf/WideCameraPanel;

    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideCameraPanel;->openMenu(Landroid/view/View;)V

    return-void
.end method
