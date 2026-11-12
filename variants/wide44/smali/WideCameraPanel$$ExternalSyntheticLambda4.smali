.class public final synthetic Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda4;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/widget/PopupMenu$OnMenuItemClickListener;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideCameraPanel;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideCameraPanel;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda4;->f$0:Lcom/navipilot/obf/WideCameraPanel;

    return-void
.end method


# virtual methods
.method public final onMenuItemClick(Landroid/view/MenuItem;)Z
    .registers 3

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideCameraPanel$$ExternalSyntheticLambda4;->f$0:Lcom/navipilot/obf/WideCameraPanel;

    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideCameraPanel;->lambda$4$com-navipilot-obf-WideCameraPanel(Landroid/view/MenuItem;)Z

    move-result p1

    return p1
.end method
