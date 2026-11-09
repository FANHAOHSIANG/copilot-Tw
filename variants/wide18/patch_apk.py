from pathlib import Path
import re
import shutil
import sys

PACKAGE = "com/navipilot/obf"
MAIN_ACTIVITY = "smali/com/jixiexiaoge/drivingassist/MainActivity.smali"
SMALI = f"smali/{PACKAGE}"
TAIWAN_CLASSES = (
    "WideCameraCard", "WideCameraFace", "WideCameraPanel",
    "WideDirect", "WideSettings", "WideVariant",
)
FLAVORS = ("auto", "phone", "taiwan")
VERSION_CODE = "26110730"
LABEL = "Copilot tw"


def version_name(flavor):
    return f"9.3.1-wide.18-{flavor}-adaptive"


def replace_once(source, original, replacement):
    assert source.count(original) == 1, original
    return source.replace(original, replacement, 1)


def hook_updates(source):
    pattern = r'(\.method public final f\(Lcom/navipilot/obf/zg;\)V\n    \.locals 28\n\n    move-object/from16 v0, p0\n\n    move-object/from16 v1, p1\n)'
    updated, count = re.subn(pattern, r'\1\n    invoke-static {v1}, Lcom/navipilot/obf/WideStatusBorder;->update(Lcom/navipilot/obf/zg;)V\n', source)
    assert count == 1
    # Reset for device changes before an old session can leave an active color.
    target = "    iput-object p2, p0, Lcom/navipilot/obf/Ae;->m:Ljava/lang/String;\n"
    return replace_once(updated, target, target + "\n    invoke-static {}, Lcom/navipilot/obf/WideStatusBorder;->clear()V\n")


def hook_activity(source, flavor):
    end = "    invoke-static/range {p0 .. p0}, Lcom/navipilot/obf/WideSettings;->install(Landroid/app/Activity;)V\n"
    updated = replace_once(source, end, end + "\n    invoke-static/range {p0 .. p0}, Lcom/navipilot/obf/WideStatusBorder;->install(Landroid/app/Activity;)V\n")
    if flavor == "taiwan":
        start = "    invoke-super/range {p0 .. p1}, Lcom/navipilot/obf/Ug;->onCreate(Landroid/os/Bundle;)V\n"
        updated = replace_once(updated, start, start + "\n    invoke-static/range {p0 .. p0}, Lcom/navipilot/obf/WideVariant;->prepare(Landroid/app/Activity;)V\n")
    return updated


def map_check(source):
    updated, count = re.subn(
        r'^    const-string (v\d+), "com\.autonavi\.amapauto"\s*$',
        r'    invoke-static {}, Lcom/navipilot/obf/WideVariant;->packageName()Ljava/lang/String;\n\n    move-result-object \1\n',
        source, flags=re.M,
    )
    assert count == 1
    return updated


def applies(filename, prefixes):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


def patch(root, flavor):
    build = root / "build" / flavor
    original = build / "baseline"
    target = build / "patched"
    assert not target.exists(), f"Remove old build output first: {target}"
    shutil.copytree(original, target)
    prefixes = ("WideStatusBorder",) + (TAIWAN_CLASSES if flavor == "taiwan" else ())
    for path in (target / SMALI).glob("*.smali"):
        if applies(path.name, prefixes):
            path.unlink()
    for path in (root / "build/helper" / SMALI).glob("*.smali"):
        if applies(path.name, prefixes):
            shutil.copyfile(path, target / SMALI / path.name)
    activity = target / MAIN_ACTIVITY
    activity.write_text(hook_activity(activity.read_text(), flavor))
    ae = target / SMALI / "Ae.smali"
    ae.write_text(hook_updates(ae.read_text()))
    if flavor == "taiwan":
        for name in ("S3.smali", "VC.smali"):
            path = target / SMALI / name
            path.write_text(map_check(path.read_text()))
    version = target / "apktool.yml"
    value = re.sub(r'(?m)^(\s*versionCode:\s*)\S+', rf'\g<1>{VERSION_CODE}', version.read_text())
    version.write_text(re.sub(r'(?m)^(\s*versionName:\s*)[^\n]+', rf'\g<1>{version_name(flavor)}', value))
    labels = 0
    for path in (target / "res").glob("values*/strings.xml"):
        updated, count = re.subn(r'(<string name="app_name">).*?(</string>)', rf'\g<1>{LABEL}\2', path.read_text())
        if count:
            path.write_text(updated)
            labels += count
    assert labels > 0
    print(f"Patched {flavor}: {labels} launcher labels, C4 status border")


if __name__ == "__main__":
    flavor = sys.argv[1]
    assert flavor in FLAVORS
    patch(Path(__file__).resolve().parent, flavor)
