.class Lcom/navipilot/obf/WideDirect$6;
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
.field private final synthetic val$controls:Z

.field private final synthetic val$portrait:Z

.field private final synthetic val$start:Lcom/navipilot/obf/tr;


# direct methods
.method constructor <init>(Lcom/navipilot/obf/tr;ZZ)V
    .registers 4

    .line 94
    iput-object p1, p0, Lcom/navipilot/obf/WideDirect$6;->val$start:Lcom/navipilot/obf/tr;

    iput-boolean p2, p0, Lcom/navipilot/obf/WideDirect$6;->val$portrait:Z

    iput-boolean p3, p0, Lcom/navipilot/obf/WideDirect$6;->val$controls:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 4

    .line 94
    check-cast p1, Lcom/navipilot/obf/WideDirect$Pane;

    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$6;->val$start:Lcom/navipilot/obf/tr;

    iput-object v0, p1, Lcom/navipilot/obf/WideDirect$Pane;->start:Lcom/navipilot/obf/tr;

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$6;->val$portrait:Z

    iget-boolean v1, p0, Lcom/navipilot/obf/WideDirect$6;->val$controls:Z

    invoke-virtual {p1, v0, v1}, Lcom/navipilot/obf/WideDirect$Pane;->adapt(ZZ)V

    sget-object p1, Lcom/navipilot/obf/J10;->a:Lcom/navipilot/obf/J10;

    return-object p1
.end method
