"""Repair the exact wide58 build while preserving all resources and secondary DEX files."""
import argparse
import hashlib
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import zipfile


HERE = Path(__file__).resolve().parent
WIDE58 = HERE.parent / "wide58"
BASE_SHA256 = "ed5b1ee8c779b564ad5f6569fb8b23b9382ec150f93fed5a4fab5d700033c828"


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def replace_once(source, old, new):
    if source.count(old) != 1:
        raise ValueError(f"Expected one occurrence of {old!r}")
    return source.replace(old, new, 1)


def patch_main_dex(smali):
    app = smali / "com/navipilot/obf"

    grid = app / "MD.smali"
    grid.write_text(replace_once(grid.read_text(), "    move/from16 v45, v14",
                                 "    const/16 v45, 0x9"))

    bridge_log = app / "WideBridgeLog.smali"
    code = bridge_log.read_text()
    share_start = code.index(".method public static share(Landroid/app/Activity;)V")
    code = code[:share_start] + replace_once(code[share_start:],
        "    .line 36\n    sget-object v0, Lcom/navipilot/obf/WideBridgeLog;->worker:Landroid/os/Handler;",
        "    invoke-static {p0}, Lcom/navipilot/obf/WideBridgeLog;->init(Landroid/content/Context;)V\n\n"
        "    .line 36\n    sget-object v0, Lcom/navipilot/obf/WideBridgeLog;->worker:Landroid/os/Handler;")
    code = replace_once(code,
        "    sget-object v1, Lcom/navipilot/obf/WideBridgeLog;->worker:Landroid/os/Handler;\n\n"
        "    invoke-static {}, Lcom/navipilot/obf/WideDiagnosticActions;->report()Ljava/lang/String;",
        "    invoke-static {}, Lcom/navipilot/obf/WideDiagnosticActions;->report()Ljava/lang/String;")
    bridge_log.write_text(replace_once(code,
        "    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z\n\n"
        "    .line 51",
        "    sget-object v1, Lcom/navipilot/obf/WideBridgeLog;->worker:Landroid/os/Handler;\n\n"
        "    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z\n\n"
        "    .line 51"))

    diagnostic_click = app / "WideDiagnosticActions$1.smali"
    diagnostic_click.write_text(replace_once(diagnostic_click.read_text(),
        "    invoke-static {}, Lcom/navipilot/obf/WideBridgeLog;->toggle()V\n\n"
        "    .line 36\n    iget-object p1, p0, Lcom/navipilot/obf/WideDiagnosticActions$1;->val$activity:Landroid/app/Activity;",
        "    iget-object p1, p0, Lcom/navipilot/obf/WideDiagnosticActions$1;->val$activity:Landroid/app/Activity;\n\n"
        "    invoke-static {p1}, Lcom/navipilot/obf/WideBridgeLog;->init(Landroid/content/Context;)V\n\n"
        "    invoke-static {}, Lcom/navipilot/obf/WideBridgeLog;->toggle()V"))

    projection = app / "WideDirect.smali"
    projection.write_text(replace_once(projection.read_text(), r"Carrot Bridge wide.54\n",
                                       r"Carrot Bridge wide.59\n"))

    # This composable exclusively owns the legacy About dialog and its saved state.
    intro = app / "QD.smali"
    code = intro.read_text()
    method = (".method public final a(Landroid/content/Context;ILcom/navipilot/obf/tr;"
              "Lcom/navipilot/obf/Hh;I)V\n")
    start = code.index(method) + len(method)
    end = code.index(".end method", start)
    intro.write_text(code[:start] + "    .locals 0\n\n    return-void\n" + code[end:])

    # The realtime details page has a separate manual button for the same dialog.
    details = app / "uN.smali"
    code = details.read_text()
    entry = code.index('    const-string v1, "about-entry"')
    start = code.rindex("    invoke-static {v12, v8}", 0, entry)
    end = code.index("    const/4 v1, 0x1\n\n    invoke-virtual {v0, v1}", entry)
    details.write_text(code[:start] + "    move-object v0, v15\n\n" + code[end:])

    activity = smali / "com/jixiexiaoge/drivingassist/MainActivity.smali"
    code = activity.read_text()
    show = "    invoke-static {p0}, Lcom/navipilot/obf/WideFirstRun;->show(Landroid/app/Activity;)V"
    dismiss = "    invoke-static {p0}, Lcom/navipilot/obf/WideFirstRun;->dismiss(Landroid/app/Activity;)V"
    on_destroy = "    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V"
    code = replace_once(code, show + "\n\n", "")
    code = replace_once(code, on_destroy + "\n\n" + dismiss, dismiss + "\n\n" + on_destroy)
    start = code.index(".method public final onWindowFocusChanged(Z)V")
    update_insets = "    invoke-virtual {p0}, Lcom/jixiexiaoge/drivingassist/MainActivity;->j()V"
    activity.write_text(code[:start] + replace_once(code[start:], update_insets,
                                                   update_insets + "\n\n" + show))


def build(base, tools, output, work):
    build_tools = tools / "android-15"
    deps = tools / "deps"
    classpath = str(deps / "*")
    base_dex = work / "base.dex"
    with zipfile.ZipFile(base) as source:
        base_dex.write_bytes(source.read("classes.dex"))
    smali = work / "smali"
    run("java", "-cp", classpath, "org.jf.baksmali.Main", "disassemble", base_dex, "-o", smali)
    patch_main_dex(smali)

    compiled = work / "compiled"
    run("java", "-jar", tools / "ecj.jar", "-8", "-proc:none", "-encoding", "UTF-8",
        "-cp", tools / "android.jar", "-d", compiled,
        WIDE58 / "stubs/com/navipilot/obf/Signatures.java", HERE / "WideFirstRun.java")
    helper = work / "helper"
    helper.mkdir()
    run("java", "-cp", build_tools / "lib/d8.jar", "com.android.tools.r8.D8", "--min-api", "31",
        "--no-desugaring", "--output", helper,
        *sorted(compiled.rglob("WideFirstRun*.class")))
    disassembly = work / "helper-smali"
    run("java", "-cp", classpath, "org.jf.baksmali.Main", "disassemble",
        helper / "classes.dex", "-o", disassembly)
    for item in disassembly.rglob("*.smali"):
        shutil.copyfile(item, smali / item.relative_to(disassembly))

    dex = work / "classes.dex"
    run("java", "-cp", classpath, "org.jf.smali.Main", "assemble", "--api", "31", smali, "-o", dex)
    dex_bytes = dex.read_bytes()
    if not dex_bytes.startswith(b"dex\n039\0"):
        raise ValueError("Unexpected main DEX format")
    unaligned = work / "unaligned.apk"
    with zipfile.ZipFile(base) as source, zipfile.ZipFile(unaligned, "w") as target:
        manifest = replace_once(source.read("AndroidManifest.xml"),
            "9.3.1-wide.58-ui".encode("utf-16le"), "9.3.1-wide.59-ui".encode("utf-16le"))
        manifest = replace_once(manifest, struct.pack("<I", 26110770), struct.pack("<I", 26110771))
        updates = {"classes.dex": dex_bytes, "AndroidManifest.xml": manifest}
        for entry in source.infolist():
            name = entry.filename
            target.writestr(entry, updates[name] if name in updates else source.read(name))
    align = build_tools / "zipalign"
    run(align, "-P", "16", "-f", "4", unaligned, output)
    run(align, "-c", "-P", "16", "4", output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("base", type=Path)
    parser.add_argument("tools", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    with args.base.open("rb") as handle:
        if hashlib.file_digest(handle, "sha256").hexdigest() != BASE_SHA256:
            parser.error("Expected the exact wide58 unsigned APK")
    if args.output.exists() or "UNSIGNED" not in args.output.name:
        parser.error("Use a new output filename containing UNSIGNED")
    with tempfile.TemporaryDirectory(prefix="wide59-") as temp:
        build(args.base, args.tools, args.output, Path(temp))


if __name__ == "__main__":
    main()
