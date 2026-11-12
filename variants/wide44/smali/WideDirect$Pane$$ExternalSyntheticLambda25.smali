.class public final synthetic Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda25;
.super Ljava/lang/Object;
.source "D8$$SyntheticClass"

# interfaces
.implements Landroid/widget/PopupMenu$OnMenuItemClickListener;


# instance fields
.field public final synthetic f$0:Lcom/navipilot/obf/WideDirect$Pane;


# direct methods
.method public synthetic constructor <init>(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 2

    .line 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda25;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    return-void
.end method


# virtual methods
.method public final onMenuItemClick(Landroid/view/MenuItem;)Z
    .registers 3

    .line 0
    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane$$ExternalSyntheticLambda25;->f$0:Lcom/navipilot/obf/WideDirect$Pane;

    invoke-virtual {v0, p1}, Lcom/navipilot/obf/WideDirect$Pane;->lambda$6$com-navipilot-obf-WideDirect$Pane(Landroid/view/MenuItem;)Z

    move-result p1

    return p1
.end method
