.class Lcom/navipilot/obf/WideDirect$4;
.super Ljava/lang/Object;
.source "WideDirect.java"

# interfaces
.implements Lcom/navipilot/obf/vr;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/navipilot/obf/WideDirect;->compose(Lcom/navipilot/obf/VE;Lcom/navipilot/obf/Hh;ZLcom/navipilot/obf/tr;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$shield:Z

.field private final synthetic val$start:Lcom/navipilot/obf/tr;


# direct methods
.method constructor <init>(ZLcom/navipilot/obf/tr;)V
    .registers 3

    .line 92
    iput-boolean p1, p0, Lcom/navipilot/obf/WideDirect$4;->val$shield:Z

    iput-object p2, p0, Lcom/navipilot/obf/WideDirect$4;->val$start:Lcom/navipilot/obf/tr;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 5

    .line 92
    new-instance v0, Lcom/navipilot/obf/WideDirect$Pane;

    check-cast p1, Landroid/content/Context;

    iget-boolean v1, p0, Lcom/navipilot/obf/WideDirect$4;->val$shield:Z

    iget-object v2, p0, Lcom/navipilot/obf/WideDirect$4;->val$start:Lcom/navipilot/obf/tr;

    invoke-direct {v0, p1, v1, v2}, Lcom/navipilot/obf/WideDirect$Pane;-><init>(Landroid/content/Context;ZLcom/navipilot/obf/tr;)V

    return-object v0
.end method
