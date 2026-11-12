.class Lcom/navipilot/obf/WideDirect$3;
.super Ljava/lang/Object;
.source "WideDirect.java"

# interfaces
.implements Lcom/navipilot/obf/vr;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/navipilot/obf/WideDirect;->shield(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field private final synthetic val$controls:Z

.field private final synthetic val$portrait:Z


# direct methods
.method constructor <init>(ZZ)V
    .registers 3

    .line 81
    iput-boolean p1, p0, Lcom/navipilot/obf/WideDirect$3;->val$portrait:Z

    iput-boolean p2, p0, Lcom/navipilot/obf/WideDirect$3;->val$controls:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 4

    .line 81
    check-cast p1, Lcom/navipilot/obf/WideSpeedHost;

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$3;->val$portrait:Z

    iget-boolean v1, p0, Lcom/navipilot/obf/WideDirect$3;->val$controls:Z

    invoke-virtual {p1, v0, v1}, Lcom/navipilot/obf/WideSpeedHost;->adapt(ZZ)V

    sget-object p1, Lcom/navipilot/obf/J10;->a:Lcom/navipilot/obf/J10;

    return-object p1
.end method
