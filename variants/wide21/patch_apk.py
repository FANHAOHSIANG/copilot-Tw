from pathlib import Path
import re
import shutil
import sys

SMALI = "smali/com/navipilot/obf"
BINDER = f"{SMALI}/Lt.smali"
CLASS_PREFIXES = (
    "WideDirect", "WideAmapIme", "WideDisplayResize", "WideInsets",
    "WideUi", "WideCameraPanel", "WideSettings",
)
VERSION_CODE = "26110733"
LABEL = "Copilot tw"


def version_name(_):
    return "9.3.1-wide.21-stable-display"


def applies(filename, prefixes=CLASS_PREFIXES):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


def hook_resize(source):
    anchor = "    :cond_0\n    const v2, 0x5f4e5446\n"
    assert source.count(anchor) == 1
    extra = """
    const/16 v2, 0x31

    if-ne p1, v2, :wide_original_transaction

    check-cast p0, Lcom/navipilot/amap2tesla/privileged/PrivilegedDisplayService;

    iget-object v2, p0, Lcom/navipilot/amap2tesla/privileged/PrivilegedDisplayService;->b:Ljava/util/concurrent/ConcurrentHashMap;

    invoke-static {v2, p2, p3}, Lcom/navipilot/obf/WideDisplayResize;->receive(Ljava/util/concurrent/ConcurrentHashMap;Landroid/os/Parcel;Landroid/os/Parcel;)V

    return v1

    :wide_original_transaction
"""
    return source.replace(anchor, "    :cond_0\n" + extra + "    const v2, 0x5f4e5446\n")


HOOKS = {BINDER: hook_resize}


def patch(root):
    build = root / "build/taiwan"
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
