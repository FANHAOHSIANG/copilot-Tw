.class public final Lcom/navipilot/obf/WideDirect;
.super Ljava/lang/Object;
.source "WideDirect.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/navipilot/obf/WideDirect$LayoutStamp;,
        Lcom/navipilot/obf/WideDirect$Pane;,
        Lcom/navipilot/obf/WideDirect$RenderSize;,
        Lcom/navipilot/obf/WideDirect$Session;
    }
.end annotation


# static fields
.field private static final KEYBOARD_LOCAL:Ljava/lang/String; = "phone_keyboard_in_pane"

.field private static final MAIN:Landroid/os/Handler;

.field private static final PANES:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/ref/WeakReference<",
            "Lcom/navipilot/obf/WideDirect$Pane;",
            ">;>;"
        }
    .end annotation
.end field

.field private static final PREFS:Ljava/lang/String; = "copilot_tw_projection"

.field private static final WORK:Ljava/util/concurrent/ExecutorService;

.field private static binder:Lcom/navipilot/obf/Mt;

.field private static volatile mapStatus:Ljava/lang/String;

.field private static volatile shieldStatus:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 20
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;

    .line 21
    invoke-static {}, Ljava/util/concurrent/Executors;->newSingleThreadExecutor()Ljava/util/concurrent/ExecutorService;

    move-result-object v0

    sput-object v0, Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;

    .line 22
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    .line 26
    const-string v0, "\u5c1a\u672a\u6295\u5c4f"

    sput-object v0, Lcom/navipilot/obf/WideDirect;->mapStatus:Ljava/lang/String;

    sput-object v0, Lcom/navipilot/obf/WideDirect;->shieldStatus:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$0()Ljava/util/concurrent/ExecutorService;
    .registers 1

    .line 21
    sget-object v0, Lcom/navipilot/obf/WideDirect;->WORK:Ljava/util/concurrent/ExecutorService;

    return-object v0
.end method

.method static synthetic access$1(Landroid/content/Context;)Landroid/app/Activity;
    .registers 1

    .line 96
    invoke-static {p0}, Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2()Lcom/navipilot/obf/Mt;
    .registers 1

    .line 23
    sget-object v0, Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;

    return-object v0
.end method

.method static synthetic access$3()Ljava/util/ArrayList;
    .registers 1

    .line 22
    sget-object v0, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    return-object v0
.end method

.method static synthetic access$4(Ljava/lang/String;)V
    .registers 1

    .line 26
    sput-object p0, Lcom/navipilot/obf/WideDirect;->shieldStatus:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$5(Ljava/lang/String;)V
    .registers 1

    .line 26
    sput-object p0, Lcom/navipilot/obf/WideDirect;->mapStatus:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$6(Landroid/app/Activity;)V
    .registers 1

    .line 65
    invoke-static {p0}, Lcom/navipilot/obf/WideDirect;->refreshWindow(Landroid/app/Activity;)V

    return-void
.end method

.method static synthetic access$7()Landroid/os/Handler;
    .registers 1

    .line 20
    sget-object v0, Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;

    return-object v0
.end method

.method private static activity(Landroid/content/Context;)Landroid/app/Activity;
    .registers 1

    .line 96
    invoke-static {p0}, Lcom/navipilot/obf/WideVariant;->activity(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object p0

    return-object p0
.end method

.method static adaptShieldPane(Landroid/view/View;ZZ)V
    .registers 4

    .line 87
    instance-of v0, p0, Lcom/navipilot/obf/WideDirect$Pane;

    if-eqz v0, :cond_9

    check-cast p0, Lcom/navipilot/obf/WideDirect$Pane;

    invoke-virtual {p0, p1, p2}, Lcom/navipilot/obf/WideDirect$Pane;->adapt(ZZ)V

    .line 88
    :cond_9
    return-void
.end method

.method static changeMap()V
    .registers 2

    .line 51
    sget-object v0, Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda7;

    invoke-direct {v1}, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda7;-><init>()V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 55
    return-void
.end method

.method private static compose(Lcom/navipilot/obf/VE;Lcom/navipilot/obf/Hh;ZLcom/navipilot/obf/tr;)V
    .registers 13

    .line 91
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result v0

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v1

    .line 92
    new-instance v2, Lcom/navipilot/obf/WideDirect$4;

    invoke-direct {v2, p2, p3}, Lcom/navipilot/obf/WideDirect$4;-><init>(ZLcom/navipilot/obf/tr;)V

    .line 93
    new-instance v5, Lcom/navipilot/obf/WideDirect$5;

    invoke-direct {v5}, Lcom/navipilot/obf/WideDirect$5;-><init>()V

    .line 94
    new-instance v6, Lcom/navipilot/obf/WideDirect$6;

    invoke-direct {v6, p3, v0, v1}, Lcom/navipilot/obf/WideDirect$6;-><init>(Lcom/navipilot/obf/tr;ZZ)V

    .line 92
    const/4 v4, 0x0

    const/4 v8, 0x0

    move-object v3, p0

    move-object v7, p1

    invoke-static/range {v2 .. v8}, Landroidx/compose/ui/viewinterop/a;->a(Lcom/navipilot/obf/vr;Lcom/navipilot/obf/VE;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/Hh;I)V

    .line 95
    return-void
.end method

.method public static connected(Lcom/navipilot/obf/Mt;)V
    .registers 3

    .line 35
    sget-object v0, Lcom/navipilot/obf/WideDirect;->MAIN:Landroid/os/Handler;

    new-instance v1, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda9;

    invoke-direct {v1, p0}, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda9;-><init>(Lcom/navipilot/obf/Mt;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    .line 46
    return-void
.end method

.method public static disconnected()V
    .registers 1

    .line 48
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/navipilot/obf/WideDirect;->connected(Lcom/navipilot/obf/Mt;)V

    return-void
.end method

.method static disposeShieldPane(Landroid/view/View;)V
    .registers 2

    .line 85
    instance-of v0, p0, Lcom/navipilot/obf/WideDirect$Pane;

    if-eqz v0, :cond_9

    check-cast p0, Lcom/navipilot/obf/WideDirect$Pane;

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->dispose()V

    :cond_9
    return-void
.end method

.method private static forEachPane(ZLjava/util/function/Consumer;)V
    .registers 5
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(Z",
            "Ljava/util/function/Consumer<",
            "Lcom/navipilot/obf/WideDirect$Pane;",
            ">;)V"
        }
    .end annotation

    .line 58
    sget-object v0, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    :goto_8
    if-gez v0, :cond_b

    .line 63
    return-void

    .line 59
    :cond_b
    sget-object v1, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideDirect$Pane;

    .line 60
    if-eqz v1, :cond_2e

    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z

    if-eqz v2, :cond_20

    goto :goto_2e

    .line 61
    :cond_20
    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    if-eqz v2, :cond_33

    if-eqz p0, :cond_2a

    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-nez v2, :cond_33

    :cond_2a
    invoke-interface {p1, v1}, Ljava/util/function/Consumer;->accept(Ljava/lang/Object;)V

    goto :goto_33

    .line 60
    :cond_2e
    :goto_2e
    sget-object v1, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    invoke-virtual {v1, v0}, Ljava/util/ArrayList;->remove(I)Ljava/lang/Object;

    .line 58
    :cond_33
    :goto_33
    add-int/lit8 v0, v0, -0x1

    goto :goto_8
.end method

.method static synthetic lambda$0(Lcom/navipilot/obf/Mt;)V
    .registers 4

    .line 36
    sget-object v0, Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;

    const/4 v1, 0x0

    if-eqz v0, :cond_20

    if-eqz p0, :cond_20

    sget-object v0, Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;

    invoke-interface {v0}, Lcom/navipilot/obf/Mt;->asBinder()Landroid/os/IBinder;

    move-result-object v0

    invoke-interface {p0}, Lcom/navipilot/obf/Mt;->asBinder()Landroid/os/IBinder;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_20

    .line 37
    new-instance p0, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda5;

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda5;-><init>()V

    invoke-static {v1, p0}, Lcom/navipilot/obf/WideDirect;->forEachPane(ZLjava/util/function/Consumer;)V

    .line 40
    return-void

    .line 42
    :cond_20
    sget-object v0, Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;

    if-ne v0, p0, :cond_25

    return-void

    .line 43
    :cond_25
    sput-object p0, Lcom/navipilot/obf/WideDirect;->binder:Lcom/navipilot/obf/Mt;

    .line 44
    new-instance p0, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda6;

    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda6;-><init>()V

    invoke-static {v1, p0}, Lcom/navipilot/obf/WideDirect;->forEachPane(ZLjava/util/function/Consumer;)V

    .line 45
    return-void
.end method

.method static synthetic lambda$1(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 3

    .line 38
    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-eqz v0, :cond_f

    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->teslaSuppressed:Z

    invoke-static {}, Lcom/navipilot/obf/WideTeslaProjection;->isActive()Z

    move-result v1

    if-eq v0, v1, :cond_f

    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V

    .line 39
    :cond_f
    return-void
.end method

.method static synthetic lambda$3()V
    .registers 2

    .line 51
    new-instance v0, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda8;

    invoke-direct {v0}, Lcom/navipilot/obf/WideDirect$$ExternalSyntheticLambda8;-><init>()V

    const/4 v1, 0x1

    invoke-static {v1, v0}, Lcom/navipilot/obf/WideDirect;->forEachPane(ZLjava/util/function/Consumer;)V

    .line 54
    return-void
.end method

.method static synthetic lambda$4(Lcom/navipilot/obf/WideDirect$Pane;)V
    .registers 1

    .line 52
    # invokes: Lcom/navipilot/obf/WideDirect$Pane;->updateHeader()V
    invoke-static {p0}, Lcom/navipilot/obf/WideDirect$Pane;->access$0(Lcom/navipilot/obf/WideDirect$Pane;)V

    .line 53
    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V

    .line 54
    return-void
.end method

.method public static map(Lcom/navipilot/obf/VE;Lcom/navipilot/obf/tr;Lcom/navipilot/obf/Hh;)V
    .registers 4

    .line 89
    const/4 v0, 0x0

    invoke-static {p0, p2, v0, p1}, Lcom/navipilot/obf/WideDirect;->compose(Lcom/navipilot/obf/VE;Lcom/navipilot/obf/Hh;ZLcom/navipilot/obf/tr;)V

    return-void
.end method

.method static newShieldPane(Landroid/content/Context;)Landroid/view/View;
    .registers 4

    .line 84
    new-instance v0, Lcom/navipilot/obf/WideDirect$Pane;

    const/4 v1, 0x1

    const/4 v2, 0x0

    invoke-direct {v0, p0, v1, v2}, Lcom/navipilot/obf/WideDirect$Pane;-><init>(Landroid/content/Context;ZLcom/navipilot/obf/tr;)V

    return-object v0
.end method

.method private static refreshWindow(Landroid/app/Activity;)V
    .registers 4

    .line 66
    if-eqz p0, :cond_43

    invoke-virtual {p0}, Landroid/app/Activity;->isDestroyed()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_43

    .line 67
    :cond_9
    sget-object v0, Lcom/navipilot/obf/WideDirect;->PANES:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_f
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-nez v1, :cond_1a

    .line 74
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideInsets;->projection(Landroid/app/Activity;Z)V

    .line 75
    return-void

    .line 67
    :cond_1a
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/ref/WeakReference;

    .line 68
    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/navipilot/obf/WideDirect$Pane;

    .line 69
    if-eqz v1, :cond_f

    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z

    if-nez v2, :cond_f

    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->attached:Z

    if-eqz v2, :cond_f

    iget-boolean v2, v1, Lcom/navipilot/obf/WideDirect$Pane;->disposed:Z

    if-nez v2, :cond_f

    invoke-virtual {v1}, Lcom/navipilot/obf/WideDirect$Pane;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/navipilot/obf/WideDirect;->activity(Landroid/content/Context;)Landroid/app/Activity;

    move-result-object v1

    if-ne v1, p0, :cond_f

    .line 70
    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/navipilot/obf/WideInsets;->projection(Landroid/app/Activity;Z)V

    .line 71
    return-void

    .line 66
    :cond_43
    :goto_43
    return-void
.end method

.method public static report()Ljava/lang/String;
    .registers 3

    .line 29
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Copilot tw wide.25\n"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Lcom/navipilot/obf/WideVariant;->mapName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    sget-object v1, Lcom/navipilot/obf/WideDirect;->mapStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 30
    const-string v1, "\nCarrot \u5c0e\u822a\u8cc7\u6599\uff1a"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {}, Lcom/navipilot/obf/WideAmapSource;->status()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, "\n"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 31
    invoke-static {}, Lcom/navipilot/obf/WideVariant;->shieldPanel()Z

    move-result v1

    if-eqz v1, :cond_47

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u795e\u76fe\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v2, Lcom/navipilot/obf/WideDirect;->shieldStatus:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    goto :goto_49

    :cond_47
    const-string v1, "\u53f0\u7063\u6e2c\u901f\uff1a\u5167\u5efa\u9762\u677f"

    :goto_49
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 29
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static shield(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 11

    .line 78
    invoke-static {}, Lcom/navipilot/obf/WideLayout;->portrait()Z

    move-result p2

    invoke-static {}, Lcom/navipilot/obf/WideSettings;->controlsVisible()Z

    move-result v0

    .line 79
    new-instance v1, Lcom/navipilot/obf/WideDirect$1;

    invoke-direct {v1}, Lcom/navipilot/obf/WideDirect$1;-><init>()V

    move-object v2, p0

    check-cast v2, Lcom/navipilot/obf/VE;

    .line 80
    new-instance v4, Lcom/navipilot/obf/WideDirect$2;

    invoke-direct {v4}, Lcom/navipilot/obf/WideDirect$2;-><init>()V

    .line 81
    new-instance v5, Lcom/navipilot/obf/WideDirect$3;

    invoke-direct {v5, p2, v0}, Lcom/navipilot/obf/WideDirect$3;-><init>(ZZ)V

    move-object v6, p1

    check-cast v6, Lcom/navipilot/obf/Hh;

    .line 79
    const/4 v3, 0x0

    const/4 v7, 0x0

    invoke-static/range {v1 .. v7}, Landroidx/compose/ui/viewinterop/a;->a(Lcom/navipilot/obf/vr;Lcom/navipilot/obf/VE;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/vr;Lcom/navipilot/obf/Hh;I)V

    .line 82
    sget-object p0, Lcom/navipilot/obf/J10;->a:Lcom/navipilot/obf/J10;

    return-object p0
.end method
