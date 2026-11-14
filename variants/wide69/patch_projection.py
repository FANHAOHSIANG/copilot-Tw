"""Install the compact projection controls and the Shield alert on wide.68."""
from pathlib import Path

HERE = Path(__file__).resolve().parent
PACKAGE = Path("com/navipilot/obf")
PANE = "Lcom/navipilot/obf/WideDirect$Pane;"
CONTROLS = "Lcom/navipilot/obf/WideProjectionControls;"
SAMPLE = "Lcom/navipilot/obf/Wide69Shield;"


def replace_once(data, old, new):
    if data.count(old) != 1:
        raise ValueError(f"Expected one occurrence: {old}")
    return data.replace(old, new, 1)


def section(data, header, func):
    start = data.index(header)
    end = data.index(".end method", start)
    return data[:start] + func(data[start:end]) + data[end:]


def remove_header(body):
    # Keep the accent and foreground registers used by the waiting-state card.
    start = body.index("    .line 133\n")
    end = body.index("    .line 149\n", start)
    label = next((line for line in body[start:].splitlines()[1:2] if line.strip().startswith(":")), "")
    body = body[:start] + label + "\n" + """    const/4 v2, 0x0
    iput-object v2, p0, Lcom/navipilot/obf/WideDirect$Pane;->title:Landroid/widget/TextView;

    const v4, -0xd0904
    const/4 v5, -0x1

""" + body[end:]
    anchor = "    .line 207\n"
    return replace_once(body, anchor, f"    invoke-static {{p0}}, {CONTROLS}->install({PANE})V\n\n" + anchor)


def apply(decoded):
    main = decoded / "smali" / PACKAGE
    pane = main / "WideDirect$Pane.smali"
    data = section(pane.read_text(), ".method constructor <init>", remove_header)
    data = replace_once(data, "lambda$2$com-navipilot-obf-WideDirect$Pane(Landroid/view/View;)V",
                        "back(Landroid/view/View;)V")
    data = replace_once(data, "    .line 274\n    iget-object",
        f"    iget-object v0, p0, {PANE}->body:Landroid/widget/FrameLayout;\n"
        f"    invoke-static {{v0, p2}}, {CONTROLS}->update(Landroid/widget/FrameLayout;Z)V\n\n"
        "    .line 274\n    iget-object")
    menu_anchor = "    .line 250\n    new-instance p1"
    data = replace_once(data, menu_anchor, """
    invoke-virtual {v0}, Landroid/widget/PopupMenu;->getMenu()Landroid/view/Menu;
    move-result-object p1
    const/16 v2, 0x10
    const-string v5, "返回投屏 App"
    invoke-interface {p1, v7, v2, v7, v5}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;

""" + menu_anchor)
    callback_anchor = "    .line 253\n    const/4 v2, 0x2"
    data = replace_once(data, callback_anchor, f"""
    const/16 v2, 0x10
    if-ne v1, v2, :handle_existing
    const/4 v2, 0x0
    invoke-virtual {{p0, v2}}, {PANE}->back(Landroid/view/View;)V
    const/4 v2, 0x1
    return v2

    :handle_existing
""" + callback_anchor)
    data = section(data, ".method public onSurfaceTextureUpdated(", lambda body: (
        ".method public onSurfaceTextureUpdated(Landroid/graphics/SurfaceTexture;)V\n"
        "    .locals 1\n"
        f"    iget-boolean v0, p0, {PANE}->shield:Z\n"
        "    if-eqz v0, :done\n"
        f"    iget-object v0, p0, {PANE}->session:Lcom/navipilot/obf/WideDirect$Session;\n"
        "    if-eqz v0, :done\n"
        f"    iget-object v0, p0, {PANE}->texture:Landroid/view/TextureView;\n"
        f"    invoke-static {{v0}}, {SAMPLE}->sample(Landroid/view/TextureView;)V\n"
        "    :done\n"
        "    return-void\n"
    ))
    data = section(data, ".method private stop()V", lambda body: replace_once(
        body, "    .locals 2\n",
        f"    .locals 2\n\n    iget-boolean v0, p0, {PANE}->shield:Z\n"
        "    if-eqz v0, :clear_done\n"
        f"    iget-object v0, p0, {PANE}->texture:Landroid/view/TextureView;\n"
        f"    invoke-static {{v0}}, {SAMPLE}->clear(Landroid/view/TextureView;)V\n"
        "    :clear_done\n",
    ))
    pane.write_text(data)
    # A legacy listener still references the handler. Keep linkage consistent.
    listener = pane.with_name("WideDirect$Pane$$ExternalSyntheticLambda4.smali")
    listener.write_text(replace_once(listener.read_text(),
        "->lambda$2$com-navipilot-obf-WideDirect$Pane(", "->back("))
    direct = main / "WideDirect.smali"
    direct.write_text(replace_once(direct.read_text(), "Carrot Bridge wide.68", "Carrot Bridge wide.69")
        + "\n" + (HERE / "pane_for.smali").read_text())

    log = main / "WideBridgeLog$1.smali"
    log.write_text(replace_once(log.read_text(), "wide.51", "wide.69"))
    border = main / "WideStatusBorder.smali"
    border.write_text(section(border.read_text(), ".method private cameraGlow(J)I", lambda body: (
        ".method private cameraGlow(J)I\n"
        "    .locals 1\n"
        f"    invoke-static {{p1, p2}}, {SAMPLE}->glow(J)I\n"
        "    move-result v0\n"
        "    return v0\n"
    )))

    settings = main / "WideOsmLocation.smali"
    settings.write_text(replace_once(settings.read_text(),
        r"\u795e\u76fe\u53d6\u6a23\u8a3a\u65b7\u8207\u5c3a\u5bf8\u4fdd\u8b77",
        "神盾紅光提醒、取樣與尺寸保護"))
