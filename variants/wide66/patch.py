"""Update the wide.65 More menu and move projection settings to a dedicated dialog."""
import argparse
from pathlib import Path

PACKAGE = Path("com/navipilot/obf")
HERE = Path(__file__).resolve().parent
OSM = "Lcom/navipilot/obf/WideOsmLocation;"


def once(source, old, new):
    if source.count(old) != 1:
        raise ValueError(f"Unexpected wide.65 hook: {old!r}")
    return source.replace(old, new, 1)


def apply(root):
    package = root / PACKAGE
    settings = package / "WideSettings.smali"
    pane = package / "WideDirect$Pane.smali"
    osm = package / "WideOsmLocation.smali"

    show = f"    invoke-static {{v1, v15}}, {OSM}->addSetting(Landroid/app/Activity;Landroid/widget/LinearLayout;)V\n"
    settings_code = once(settings.read_text(), show, "")
    source = pane.read_text()
    start = source.index(".method private resizeDisplay()V")
    end = source.index(".end method", start) + len(".end method")
    if "->fitBuffer(" not in source[start:end] or "->layoutStamp()" in source[start:end]:
        raise ValueError("Expected the wide.65 fit-only resize path")
    source = source[:start] + (HERE / "resize.smali").read_text().rstrip() + source[end:]
    for failure in (14, 15):
        start = source.index(f".method synthetic lambda${failure}$com-navipilot-obf-WideDirect$Pane(")
        end = source.index(".end method", start)
        body = once(source[start:end],
            "    invoke-virtual {p0}, Lcom/navipilot/obf/WideDirect$Pane;->restart()V",
            "    iget-object v0, p1, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;\n"
            "    invoke-direct {p0, v0}, Lcom/navipilot/obf/WideDirect$Pane;->fitBuffer(Lcom/navipilot/obf/WideDirect$RenderSize;)V")
        source = source[:start] + body + source[end:]
    # Item identity stays tied to the enum ordinal. Only its menu order changes.
    order = "    move-result v13\n\n    iget-object v10, v10, Lcom/navipilot/obf/WideVariant$Navigation;->label:Ljava/lang/String;"
    source = once(source, order,
        "    move-result v13\n"
        "    sget-object v14, Lcom/navipilot/obf/WideVariant$Navigation;->SDK:Lcom/navipilot/obf/WideVariant$Navigation;\n"
        "    if-ne v10, v14, :wide_menu_navigation_order\n"
        "    const/4 v13, 0x7\n"
        "    :wide_menu_navigation_order\n\n"
        + order.split("\n\n")[1])
    panel = r'    const-string v5, "\u5373\u6642\u8a3a\u65b7\uff0f\u64cd\u4f5c\u9762\u677f"'
    add_panel = "    invoke-interface {p1, v7, v2, v9, v5}, Landroid/view/Menu;->add(IIILjava/lang/CharSequence;)Landroid/view/MenuItem;"
    source = once(source, panel + "\n\n" + add_panel,
        panel + "\n\n    const/4 v8, 0x3\n" + add_panel.replace("v2, v9", "v2, v8")
        + "\n\n    const/16 v2, 0xf\n"
        '    const-string v5, "設定"\n'
        "    const/16 v8, 0xc\n"
        + add_panel.replace("v2, v9", "v2, v8"))
    dispatch = "    :cond_35\n    if-ne v1, v3, :cond_44"
    source = once(source, dispatch,
        "    :cond_35\n"
        "    const/16 v2, 0xf\n"
        "    if-ne v1, v2, :wide_menu_layout\n"
        f"    invoke-static {{v0}}, {OSM}->showSettings(Landroid/app/Activity;)V\n"
        "    goto/16 :goto_81\n"
        "    :wide_menu_layout\n"
        "    if-ne v1, v3, :cond_44")
    osm_code = osm.read_text()
    start = osm_code.index(".method private static setting(")
    end = osm_code.index(".end method", start)
    method = osm_code[start:end]
    color = "    invoke-virtual {v0, p1}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V\n"
    method = once(method, color, color +
        "    const v1, -0x90906\n"
        "    invoke-virtual {v0, v1}, Landroid/widget/Switch;->setTextColor(I)V\n")
    method = once(method, "    .registers 4\n", "    .registers 5\n")
    osm_code = osm_code[:start] + method + osm_code[end:]
    # The three existing rows insert at indices 1..3. A title occupies index 0.
    osm_code += f"""
.method public static showSettings(Landroid/app/Activity;)V
    .locals 4

    new-instance v0, Landroid/widget/LinearLayout;
    invoke-direct {{v0, p0}}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v1, 0x1
    invoke-virtual {{v0, v1}}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const v1, -0xe9e3d9
    invoke-virtual {{v0, v1}}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V
    const/16 v1, 0x18
    invoke-virtual {{v0, v1, v1, v1, v1}}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v1, Landroid/widget/TextView;
    invoke-direct {{v1, p0}}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    const-string v2, "設定"
    invoke-virtual {{v1, v2}}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v2, -0x90906
    invoke-virtual {{v1, v2}}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v2, 0x41a00000
    invoke-virtual {{v1, v2}}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {{v0, v1}}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    invoke-static {{p0, v0}}, {OSM}->addSetting(Landroid/app/Activity;Landroid/widget/LinearLayout;)V

    new-instance v1, Landroid/widget/ScrollView;
    invoke-direct {{v1, p0}}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V
    invoke-virtual {{v1, v0}}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V
    new-instance v0, Landroid/app/AlertDialog$Builder;
    invoke-direct {{v0, p0}}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V
    invoke-virtual {{v0, v1}}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;
    const-string v2, "關閉"
    const/4 v3, 0x0
    invoke-virtual {{v0, v2, v3}}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;
    invoke-virtual {{v0}}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    return-void
.end method
"""
    for path, code in ((settings, settings_code), (pane, source), (osm, osm_code)):
        path.write_text(code)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("smali", type=Path)
    apply(parser.parse_args().smali)
