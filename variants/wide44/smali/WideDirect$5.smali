.class Lcom/navipilot/obf/WideDirect$5;
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


# direct methods
.method constructor <init>()V
    .registers 1

    .line 93
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public j(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 2

    .line 93
    check-cast p1, Lcom/navipilot/obf/WideDirect$Pane;

    invoke-virtual {p1}, Lcom/navipilot/obf/WideDirect$Pane;->dispose()V

    sget-object p1, Lcom/navipilot/obf/J10;->a:Lcom/navipilot/obf/J10;

    return-object p1
.end method
