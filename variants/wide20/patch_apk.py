from pathlib import Path
import re
import shutil
import sys

SMALI = "smali/com/navipilot/obf"
SERVICE = "smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali"
CLASS_PREFIXES = ("WideDirect", "WideAmapIme")
VERSION_CODE = "26110732"
LABEL = "Copilot tw"


def version_name(_):
    return "9.3.1-wide.20-keyboard"


def applies(filename, prefixes=CLASS_PREFIXES):
    return any(filename == f"{prefix}.smali" or filename.startswith(prefix + "$") for prefix in prefixes)


def hook_ime(source):
    start = source.index(".method public final f(Ljava/lang/String;IIIFLandroid/view/Surface;)I\n")
    end = source.index(".end method", start)
    method = source[start:end]
    anchor = (
        "    invoke-virtual {v5, v3, v4}, Ljava/util/concurrent/ConcurrentHashMap;"
        "->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;\n\n"
        "    return v0"
    )
    assert method.count(anchor) == 1
    hook = (
        "    move-object/from16 v1, p1\n\n"
        "    invoke-static {v1, v0}, Lcom/navipilot/obf/WideAmapIme;"
        "->configure(Ljava/lang/String;I)V\n\n"
    )
    return source[:start] + method.replace(anchor, anchor.replace("    return v0", hook + "    return v0")) + source[end:]


HOOKS = {SERVICE: hook_ime}


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
