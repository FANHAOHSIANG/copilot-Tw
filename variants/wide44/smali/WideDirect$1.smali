.class Lcom/navipilot/obf/WideDirect$1;
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


# direct methods
.method constructor <init>()V
    .registers 1

    .line 79
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 3

    .line 79
    new-instance v0, Lcom/navipilot/obf/WideSpeedHost;

    check-cast p1, Landroid/content/Context;

    invoke-direct {v0, p1}, Lcom/navipilot/obf/WideSpeedHost;-><init>(Landroid/content/Context;)V

    return-object v0
.end method
