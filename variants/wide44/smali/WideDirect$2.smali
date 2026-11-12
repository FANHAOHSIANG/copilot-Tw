.class Lcom/navipilot/obf/WideDirect$2;
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

    .line 80
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 2

    .line 80
    check-cast p1, Lcom/navipilot/obf/WideSpeedHost;

    invoke-virtual {p1}, Lcom/navipilot/obf/WideSpeedHost;->dispose()V

    sget-object p1, Lcom/navipilot/obf/J10;->a:Lcom/navipilot/obf/J10;

    return-object p1
.end method
