.class final Lcom/navipilot/obf/WideHighwayAlertData;
.super Ljava/lang/Object;
.source "WideHighwayAlertData.java"


# static fields
.field static final CAMERAS:[Lcom/navipilot/obf/WideHcopRoad$Camera;


# direct methods
.method static constructor <clinit>()V
    .locals 11

    .line 3
    const/4 v0, 0x6

    new-array v0, v0, [Lcom/navipilot/obf/WideHcopRoad$Camera;

    .line 4
    const-wide v5, 0x4038e0661ae70c13L    # 24.876558

    const-wide v7, 0x405e42f32378ab0dL    # 121.04609

    const-string v1, "36d864c7458c5701"

    const-string v2, "321812671:35:42"

    const-string v3, "\u570b\u9053\u4e00\u865f\u5317\u541182.1\u516c\u91cc"

    const/16 v4, 0x64

    invoke-static/range {v1 .. v8}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x0

    aput-object v1, v0, v2

    .line 5
    const-wide v7, 0x4038e04102ff8ec1L    # 24.875992

    const-wide v9, 0x405e4391819d2392L    # 121.055756

    const-string v3, "11a75d89c57c8655"

    const-string v4, "327353908:0:24"

    const-string v5, "\u570b\u9053\u4e00\u865f\u5317\u541181.1\u516c\u91cc"

    const/16 v6, 0x64

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x1

    aput-object v1, v0, v2

    .line 6
    const-wide v7, 0x4038f0e746cb966cL    # 24.941029

    const-wide v9, 0x405e4c62cba732dfL    # 121.19353

    const-string v3, "def62ebfa6e74199"

    const-string v4, "534195519:0:72"

    const-string v5, "\u570b\u9053\u4e00\u865f\u4e94\u694a\u9ad8\u67b6\u5317\u541164.3\u516c\u91cc"

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x2

    aput-object v1, v0, v2

    .line 7
    const-wide v7, 0x4038f2221c8a7a42L    # 24.945833

    const-wide v9, 0x405e4c771c970f7cL    # 121.19477

    const-string v3, "04bfc4ca4b167e17"

    const-string v4, "820453965:0:11"

    const-string v5, "\u570b\u9053\u4e00\u865f\u5317\u541163.7\u516c\u91cc"

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x3

    aput-object v1, v0, v2

    .line 8
    const-wide v7, 0x403910a3f8982cb2L    # 25.065002

    const-wide v9, 0x405e58917d6b65aaL    # 121.38388

    const-string v3, "12d383bfafe70f16"

    const-string v4, "700888091:0:43"

    const-string v5, "\u570b\u9053\u4e00\u865f\u4e94\u694a\u9ad8\u67b6\u5317\u541138.8\u516c\u91cc"

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x4

    aput-object v1, v0, v2

    .line 9
    const-wide v7, 0x40390e2a80064a9dL    # 25.055336

    const-wide v9, 0x405e59c39ffd60e9L    # 121.402565

    const-string v3, "6ada24e51a883ee1"

    const-string v4, "971255324:0:11"

    const-string v5, "\u570b\u9053\u4e00\u865f\u5317\u541137\u516c\u91cc"

    invoke-static/range {v3 .. v10}, Lcom/navipilot/obf/WideHighwayAlertData;->make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;

    move-result-object v1

    const/4 v2, 0x5

    aput-object v1, v0, v2

    .line 3
    sput-object v0, Lcom/navipilot/obf/WideHighwayAlertData;->CAMERAS:[Lcom/navipilot/obf/WideHcopRoad$Camera;

    .line 10
    return-void
.end method

.method constructor <init>()V
    .locals 0

    .line 2
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static make(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;IDD)Lcom/navipilot/obf/WideHcopRoad$Camera;
    .locals 1

    .line 12
    new-instance v0, Lcom/navipilot/obf/WideHcopRoad$Camera;

    invoke-direct {v0}, Lcom/navipilot/obf/WideHcopRoad$Camera;-><init>()V

    iput-object p0, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->id:Ljava/lang/String;

    iput-object p1, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->edge:Ljava/lang/String;

    iput-object p2, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->road:Ljava/lang/String;

    iput p3, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->limit:I

    iput-wide p4, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->lat:D

    iput-wide p6, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->lon:D

    const/4 p0, 0x1

    filled-new-array {p0}, [I

    move-result-object p0

    iput-object p0, v0, Lcom/navipilot/obf/WideHcopRoad$Camera;->dirs:[I

    return-object v0
.end method
