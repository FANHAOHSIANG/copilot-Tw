"""Update the projection labels and visible branding in the wide.69 DEX files."""
import json


PANE = "Lcom/navipilot/obf/WideDirect$Pane;"
STATUS = "Lcom/navipilot/obf/WideProjectionStatus;"
VERSION = "wide.70"


def replace(data, old, new, count=1):
    if data.count(old) != count:
        raise ValueError(f"Expected {count} occurrence(s) of {old!r}")
    return data.replace(old, new)


def literal(value):
    return json.dumps(value, ensure_ascii=True)[1:-1]


def apply_labels(path, labels):
    data = path.read_text(encoding="utf-8")
    for old, new, *count in labels:
        data = replace(data, literal(old), literal(new), *count)
    path.write_text(data, encoding="utf-8")


def method(data, signature, edit):
    start = data.index(signature)
    end = data.index(".end method", start)
    return data[:start] + edit(data[start:end]) + data[end:]


def status(body):
    # Keep the diagnostic status updates and replace the old visibility logic.
    end = body.index("    iget-object v0, p0, " + PANE + "->stateTitle:")
    return (body[:end] + f"    invoke-static {{p0, p1, p2, p3}}, {STATUS}"
            f"->show({PANE}Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V\n\n"
            "    return-void\n")


def menu(body):
    # MenuBuilder keeps insertion order when two entries have the same order.
    # Add Back before the first navigation source, which also has order zero.
    old = ("    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;\n\n"
           "    move-result-object p1\n\n"
           "    const/16 v2, 0x10\n\n"
           f'    const-string v5, "{literal("返回投屏 App")}"\n\n'
           "    invoke-interface {p1, v7, v2, v7, v5}, "
           "Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;\n\n")
    body = replace(body, old, "")
    new = ("    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;\n\n"
           "    move-result-object p1\n\n"
           "    const/4 v1, 0x0\n\n"
           "    const/16 v2, 0x10\n\n"
           f'    const-string v3, "{literal("返回投屏 App")}"\n\n'
           "    invoke-interface {p1, v1, v2, v1, v3}, "
           "Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;\n\n")
    return replace(body, "    .line 229\n", new + "    .line 229\n")


def patch_pane(path):
    data = path.read_text(encoding="utf-8")
    data = replace(data, ".field starting:Z\n", ".field starting:Z\n\n.field frameShown:Z\n\n.field waitingForFrame:Z\n")
    data = method(data, ".method private status(", status)
    data = method(data, ".method menu(", menu)

    clear_session = f"    iput-object v0, p0, {PANE}->session:Lcom/navipilot/obf/WideDirect$Session;\n"
    data = method(data, ".method private stop()V", lambda body: replace(
        body, clear_session, clear_session + f"\n    invoke-static {{p0}}, {STATUS}->reset({PANE})V\n"))
    data = method(data, ".method private startIfNeeded()V", lambda body: replace(
        body, "    .line 403\n", f"    invoke-static {{p0}}, {STATUS}->reset({PANE})V\n\n    .line 403\n"))
    data = method(data, ".method public onSurfaceTextureUpdated(", lambda body: replace(
        body, "    .locals 1\n", f"    .locals 1\n\n    invoke-static {{p0}}, {STATUS}->onFrame({PANE})V\n"))
    path.write_text(data, encoding="utf-8")


def patch_telemetry(path):
    data = path.read_text(encoding="utf-8")

    def init(body):
        start = body.index("    .line 18\n")
        end = body.index("    :try_end_32", start)
        return (body[:start] + "    iget-object p0, p0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;\n\n"
                "    sput-object p0, Lcom/navipilot/obf/WideTelemetry;->version:Ljava/lang/String;\n" + body[end:])

    data = method(data, ".method public static init(", init)
    path.write_text(data, encoding="utf-8")


def apply(primary, extras):
    patch_pane(primary / "WideDirect$Pane.smali")
    patch_telemetry(primary / "WideTelemetry.smali")
    label_changes = {
        "WideDirect": [("Carrot Bridge wide.69\n", f"Carrot Bridge {VERSION}\n分區二 · "),
                       ("投屏：", "分區一：")],
        "WideDivider": [("拖曳調整左右畫面比例", "拖曳調整分區一與分區二比例"),
                        ("拖曳調整上下畫面比例", "拖曳調整分區一與分區二比例"),
                        ("拖曳調整臺灣測速與快捷鍵比例", "拖曳調整分區一與操作面板比例")],
        "WideFirstRun": [("在「地圖投屏」選擇導航來源", "在「分區二 ⋯」選擇導航來源")],
        "WidePanels": [("右上畫面", "分區一")],
        "WideSettings": [("右側投屏", "分區一投屏"), ("CARROT BRIDGE", "Carrot Bridge")],
        "WideSettings$1": [("左側導航 ", "分區二 "), ("上方導航 ", "分區二 "),
                           ("% ｜其餘 ", "% ｜分區一 ")],
        "WideIdle": [("CARROT BRIDGE", "分區一"), ("Carrot Bridge 靜謐時鐘，非連線狀態指示", "分區一 · 靜謐時鐘")],
        "WideLinkDiagnostics": [("Navipilot ", "Carrot Bridge ")],
        "WideBridge": [("Navipilot wide.16-hcop-tw-test\n來源：", f"Carrot Bridge {VERSION}\n來源：")],
        "WideCamera": [("Carrot Bridge wide.42\n", f"Carrot Bridge {VERSION}\n")],
        "WideBridgeLog$3": [("Navipilot-TW-log-", "Carrot-Bridge-log-")],
        "WideAmapLinkIntegration": [("CoPilot 服務已停止", "Carrot Bridge 服務已停止"), ("wide.56", VERSION)],
        "Yg": [("9.3.1-wide.58-ui (26110770)", VERSION), ("CP搭子", "Carrot Bridge"),
               ("🚗 ", "")],
        "jh": [("CP搭子", "Carrot Bridge", 2)],
        "e3": [("CP搭子", "Carrot Bridge", 2)],
    }
    for name, labels in label_changes.items():
        apply_labels(primary / f"{name}.smali", labels)

    logger = primary / "WideBridgeLog$1.smali"
    data = logger.read_text(encoding="utf-8")
    logger.write_text(replace(data, r'\"version\":\"wide.69\"',
                              rf'\"version\":\"{VERSION}\"'), encoding="utf-8")

    apply_labels(extras / "WideProjectionControls.smali", [
        ("左側 ⋯", "分區二 ⋯"), ("右側 ⋯", "分區一 ⋯"),
        ("左側地圖更多選項", "分區二地圖更多選項"), ("右側投屏更多選項", "分區一投屏更多選項"),
        ("收起右下面板", "收起面板"),
        ("重啟左側地圖", "重啟分區二地圖"), ("重啟右側 App", "重啟分區一 App"),
        ("左側地圖選項", "分區二地圖選項"), ("右側投屏選項", "分區一投屏選項"),
    ])
