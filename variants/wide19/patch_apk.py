from pathlib import Path
import re
import shutil
import sys

SMALI = "smali/com/navipilot/obf"
MAIN_ACTIVITY = "smali/com/jixiexiaoge/drivingassist/MainActivity.smali"
SERVICE = "smali/com/navipilot/amap2tesla/projection/ProjectionService.smali"
P = "Lcom/navipilot/obf/"
CLASS_PREFIXES = (
    "WideCamera", "WideTaiwanSettings", "WideCameraCard", "WideCameraFace",
    "WideDirect", "WideVariant", "WideAmapSource", "WideProjectionHelp", "WideTeslaProjection",
)
VERSION_CODE = "26110731"
LABEL = "Copilot tw"


def version_name(_):
    return "9.3.1-wide.19-unified"


def replace_once(source, original, replacement):
    assert source.count(original) == 1, original
    return source.replace(original, replacement, 1)


def applies(filename, prefixes=CLASS_PREFIXES):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


def hook_activity(s):
    hook = f"    invoke-static/range {{p0 .. p0}}, {P}WideStatusBorder;->install(Landroid/app/Activity;)V\n"
    return replace_once(s, hook, hook + f"\n    invoke-static/range {{p0 .. p0}}, {P}WideProjectionHelp;->onOpen(Landroid/app/Activity;)V\n")


def receiver_filter(s):
    start = f"    iget-object v0, p0, {P}e4;->b:Ljava/lang/Object;"
    gate = f"""    iget v0, p0, {P}e4;->a:I
    if-nez v0, :wide_amap_receiver_continue
    invoke-static {{p0, p2}}, {P}WideAmapSource;->accept(Landroid/content/BroadcastReceiver;Landroid/content/Intent;)Z
    move-result v0
    if-nez v0, :wide_amap_receiver_continue
    return-void
    :wide_amap_receiver_continue
"""
    return replace_once(s, start, gate + start)


def hook_parser(s):
    end = f"    iput-object p1, p0, {P}h4;->u:{P}e4;\n"
    return replace_once(s, end, end + f"\n    iget-object p1, p0, {P}h4;->d:{P}IG;\n    invoke-static {{p1}}, {P}WideAmapSource;->attach({P}IG;)V\n")


def hook_dispatch(s):
    original = f"{P}h4;->a({P}h4;Landroid/content/Intent;I)V"
    return replace_once(s, original, f"{P}WideAmapSource;->dispatch({P}h4;Landroid/content/Intent;I)V")


def hook_wire(s):
    anchor = f"    invoke-static {{v8, v9, v1}}, {P}WideBridge;->merge(Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;"
    gate = f"""    invoke-static {{v0, v8, v9, v1}}, {P}WideAmapSource;->filter({P}MG;Ljava/lang/String;Lorg/json/JSONObject;Ljava/util/Map;)Lorg/json/JSONObject;
    move-result-object v9

"""
    return replace_once(s, anchor, gate + anchor)


def hook_tesla(s):
    start = f"    invoke-static {{p1}}, {P}WideDirect;->connected({P}Mt;)V"
    signature = f".method public final c({P}Mt;III)V\n    .locals 1\n\n"
    target = signature + start
    service = "Lcom/navipilot/amap2tesla/projection/ProjectionService;"
    s = replace_once(s, target, signature
            + f"    invoke-static/range {{p0 .. p4}}, {P}WideTeslaProjection;->start({service}{P}Mt;III)V\n\n"
            + start)
    a = s.index(".method public final onDestroy()V")
    b = s.index(".end method", a)
    destroy = s[a:b]
    stop = f"    iput-boolean v0, p0, {service}->n:Z\n"
    destroy = replace_once(destroy, stop,
        stop + f"\n    invoke-static/range {{p0 .. p0}}, {P}WideTeslaProjection;->stopped({service})V\n")
    return s[:a] + destroy + s[b:]


def hook_watchdog(s):
    return replace_once(s, '    const-string v5, "com.google.android.apps.maps"',
                        '    const-string v5, "tw.com.ainvest.outpack"')


def manifest(s):
    return replace_once(s, "    <queries>\n",
        '    <queries>\n        <package android:name="moe.shizuku.privileged.api"/>\n'
        '        <package android:name="roro.stellar.manager"/>\n')


HOOKS = {
    MAIN_ACTIVITY: hook_activity, SERVICE: hook_tesla,
    f"{SMALI}/e4.smali": receiver_filter, f"{SMALI}/h4.smali": hook_parser,
    f"{SMALI}/f4.smali": hook_dispatch, f"{SMALI}/MG.smali": hook_wire,
    f"{SMALI}/Rg.smali": hook_watchdog, "AndroidManifest.xml": manifest,
}


def patch(root):
    build = root / "build" / "taiwan"
    target = build / "patched"
    assert not target.exists(), target
    shutil.copytree(build / "baseline", target)
    for path in (target / SMALI).glob("*.smali"):
        if applies(path.name):
            path.unlink()
    for path in (root / "build/helper" / SMALI).glob("*.smali"):
        if applies(path.name):
            shutil.copyfile(path, target / SMALI / path.name)
    for name, edit in HOOKS.items():
        path = target / name
        path.write_text(edit(path.read_text()))
    version = target / "apktool.yml"
    value = re.sub(r'(?m)^(\s*versionCode:\s*)\S+', rf'\g<1>{VERSION_CODE}', version.read_text())
    version.write_text(re.sub(r'(?m)^(\s*versionName:\s*)[^\n]+', rf'\g<1>{version_name(None)}', value))


if __name__ == "__main__":
    assert sys.argv[1] == "taiwan"
    patch(Path(__file__).resolve().parent)
