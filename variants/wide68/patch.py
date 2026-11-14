"""Update the menu and virtual display resizing in the wide.67 DEX."""
from pathlib import Path
import re

HERE = Path(__file__).resolve().parent
PACKAGE = Path("com/navipilot/obf")
PANE = "Lcom/navipilot/obf/WideDirect$Pane;"
SESSION = "Lcom/navipilot/obf/WideDirect$Session;"
SIZE = "Lcom/navipilot/obf/WideDirect$RenderSize;"
STAMP = "Lcom/navipilot/obf/WideDirect$LayoutStamp;"
VIEWPORT = "Lcom/navipilot/obf/WideViewport;"


def once(code, old, new):
    if code.count(old) != 1:
        raise ValueError(f"Unexpected wide.67 hook: {old!r}")
    return code.replace(old, new, 1)


def method(code, signature, edit):
    matches = list(re.finditer(r"(?m)^\.method (?:\S+ )*" + re.escape(signature) + "$", code))
    if len(matches) != 1:
        raise ValueError(f"Expected one method: {signature}")
    start = matches[0].start()
    end = code.index(".end method", start) + len(".end method")
    return code[:start] + edit(code[start:end]) + code[end:]


def update_menu(code):
    # Keep ordinal as the order as well as the basis of the checked item ID.
    code = once(code, "    if-ne v13, v1, :cond_6f\n\n    const/4 v13, 0x7\n\n    :cond_6f\n", "")
    panel = r'    const-string v5, "\u5373\u6642\u8a3a\u65b7\uff0f\u64cd\u4f5c\u9762\u677f"'
    code = once(code, panel + "\n\n    const/4 v8, 0x3", panel + "\n\n    const/16 v8, 0x9")
    diagnostics = r'    const-string v5, "\u8a3a\u65b7\u8207\u9023\u7dda"'
    add = "    invoke-interface {p1, v7, v2, v1, v5}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;"
    return once(code, diagnostics + "\n\n" + add,
                diagnostics + "\n\n    const/16 v8, 0xa\n\n" + add.replace("v2, v1", "v2, v8"))


def queue_resize(code):
    size_call = f"    invoke-direct {{p0}}, {PANE}->renderSize(){SIZE}"
    code = once(code, size_call,
        f"    iget-object v3, v0, {SESSION}->pendingSize:{SIZE}\n"
        "    if-eqz v3, :measure\n\n"
        "    return-void\n\n"
        "    :measure\n"
        + size_call)
    code = once(code,
        f"    iget-object v3, v0, {SESSION}->layout:{STAMP}\n\n"
        f"    invoke-virtual {{v1, v3}}, {STAMP}->same({STAMP})Z\n\n"
        "    move-result v3\n\n"
        "    if-eqz v3, :cond_56\n\n", "")
    code = once(code, "    if-eqz v3, :cond_56\n\n    return-void",
        "    if-eqz v3, :cond_56\n\n"
        f"    iput-object v1, v0, {SESSION}->layout:{STAMP}\n"
        f"    invoke-direct {{p0, v2}}, {PANE}->fitBuffer({SIZE})V\n"
        "    return-void")
    return once(code, "    :cond_56\n", "    :cond_56\n"
        f"    iput-object v2, v0, {SESSION}->pendingSize:{SIZE}\n\n")


def resize_result(code, accepted):
    header = code.splitlines()[0]
    flag = "0x1" if accepted else "0x0"
    return (
        header + "\n    .locals 1\n\n"
        f"    const/4 v0, {flag}\n"
        f"    invoke-direct {{p0, p1, v0}}, {PANE}->finishResize({SESSION}Z)V\n"
        "    return-void\n.end method"
    )


def apply(root):
    package = root / PACKAGE
    pane = package / "WideDirect$Pane.smali"
    code = method(pane.read_text(), "menu(Landroid/view/View;)V", update_menu)
    code = method(code, "resizeDisplay()V", queue_resize)
    callback = "com-navipilot-obf-WideDirect$Pane"
    code = method(code, f"lambda$13${callback}({SESSION}{SIZE}{STAMP})V",
                  lambda _: (HERE / "resize_worker.smali").read_text().rstrip())
    for number in (14, 15):
        code = method(code, f"lambda${number}${callback}({SESSION})V",
                      lambda block: resize_result(block, False))
    code = method(code, f"lambda$16${callback}({SESSION}{SIZE})V",
                  lambda block: resize_result(block, True))
    pane.write_text(code + "\n" + (HERE / "finish_resize.smali").read_text())

    session = package / "WideDirect$Session.smali"
    field = f".field volatile size:{SIZE}\n"
    session.write_text(once(session.read_text(), field, field + f"\n.field pendingSize:{SIZE}\n"))

    # Rendering and input use the same center-fill scale with pixel aspect preserved.
    viewport = package / "WideViewport.smali"
    code = once(viewport.read_text(), "    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F",
                f"    invoke-static {{v1, v2}}, {VIEWPORT}->fillScale(FF)F")
    viewport.write_text(code + """
.method static fillScale(FF)F
    .locals 0
    invoke-static {p0, p1}, Ljava/lang/Math;->max(FF)F
    move-result p0
    return p0
.end method
""")
    touch = package / "WideDirect$Pane$1.smali"
    touch.write_text(once(touch.read_text(), "    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F",
                          f"    invoke-static {{v1, v2}}, {VIEWPORT}->fillScale(FF)F"))

    # Every named wide projection, including Google NOO, supports the same resize transaction.
    service = package / "WideDisplayResize.smali"
    marker = '    const-string v1, "WideShield"'
    service.write_text(once(service.read_text(), marker,
        '    const-string v1, "WideGoogleSdk"\n'
        "    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n"
        "    move-result v1\n"
        "    if-nez v1, :cond_29\n\n" + marker))
