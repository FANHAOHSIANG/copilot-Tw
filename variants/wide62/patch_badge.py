"""Install the speed badge into decoded main and Google DEX trees without packaging an APK."""
import argparse
from pathlib import Path
import re

import patch_location
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
PACKAGE = Path("com/navipilot/obf")
BADGE = "Lcom/navipilot/obf/WideSpeedBadge;"


def insert(source, signature, anchor, addition, before=False):
    start = source.index(signature)
    end = source.index(".end method", start)
    method = source[start:end]
    if method.count(anchor) != 1 or BADGE in method:
        raise ValueError(f"Unexpected layout or already patched: {signature}")
    replacement = addition + anchor if before else anchor + addition
    return source[:start] + method.replace(anchor, replacement) + source[end:]


def hooks(main, google):
    pane = main / PACKAGE / "WideDirect$Pane.smali"
    divider = main / PACKAGE / "WideDivider.smali"
    guidance = google / "com/navdashn/GuidanceActivity.smali"
    if ".field public static guidanceRoot:I" not in guidance.with_name("R$id.smali").read_text():
        raise ValueError("Missing Google guidance map container ID")
    pane_source = pane.read_text()
    start = pane_source.index(".method private resizeDisplay()V")
    end = pane_source.index(".end method", start)
    resize = pane_source[start:end]
    if ("WideDisplayResize" in resize or "->layoutStamp()" not in resize
            or "->startIfNeeded()" not in resize):
        raise ValueError("Unexpected projection resize path")
    pane_source = pane_source[:start] + (
        ".method private resizeDisplay()V\n"
        "    .locals 1\n"
        "    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->surfaceReady()Z\n"
        "    move-result v0\n"
        "    if-eqz v0, :done\n"
        "    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->session:Lcom/navipilot/obf/WideDirect$Session;\n"
        "    if-nez v0, :fit\n"
        "    invoke-direct {p0}, Lcom/navipilot/obf/WideDirect$Pane;->startIfNeeded()V\n"
        "    return-void\n"
        "    :fit\n"
        "    iget-object v0, v0, Lcom/navipilot/obf/WideDirect$Session;->size:Lcom/navipilot/obf/WideDirect$RenderSize;\n"
        "    invoke-direct {p0, v0}, Lcom/navipilot/obf/WideDirect$Pane;->fitBuffer(Lcom/navipilot/obf/WideDirect$RenderSize;)V\n"
        "    :done\n"
        "    return-void\n"
    ) + pane_source[end:]
    pane_source = insert(pane_source, ".method public onSurfaceTextureUpdated(",
        "    return-void\n",
        "    iget-boolean p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z\n"
        "    if-eqz p1, :wide_shield_sample_done\n"
        "    iget-object p1, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;\n"
        "    invoke-static {p1}, Lcom/navipilot/obf/WideShieldSample;->sample(Landroid/view/TextureView;)V\n"
        "    :wide_shield_sample_done\n", before=True)
    return {
        divider: insert(divider.read_text(), ".method public onTouchEvent(",
            "    invoke-static {v0, p1}, Lcom/navipilot/obf/WideSettings;->preview(II)V\n",
            "    invoke-static {v0, p1}, Lcom/navipilot/obf/WideShieldSize;->allow(II)Z\n"
            "    move-result v3\n"
            "    if-nez v3, :wide_shield_resize_allowed\n"
            "    return v1\n"
            "    :wide_shield_resize_allowed\n", before=True),
        pane: insert(
            pane_source,
            ".method constructor <init>(Landroid/content/Context;ZLcom/navipilot/obf/tr;)V",
            "    return-void\n",
            "    iget-boolean v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->shield:Z\n"
            "    if-eqz v0, :wide_osm_badge_map\n"
            "    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->texture:Landroid/view/TextureView;\n"
            "    invoke-static {v0}, Lcom/navipilot/obf/WideShieldSize;->attach(Landroid/view/TextureView;)V\n"
            "    goto :wide_osm_badge_done\n"
            "    :wide_osm_badge_map\n"
            "    iget-object v0, p0, Lcom/navipilot/obf/WideDirect$Pane;->body:Landroid/widget/FrameLayout;\n"
            f"    invoke-static {{v0}}, {BADGE}->attach(Landroid/widget/FrameLayout;)V\n"
            "    :wide_osm_badge_done\n",
            before=True,
        ),
        guidance: insert(
            guidance.read_text(),
            ".method protected onCreate(Landroid/os/Bundle;)V",
            "    invoke-virtual {p0, p1}, Lcom/navdashn/GuidanceActivity;->setContentView(I)V\n",
            "    sget v0, Lcom/navdashn/R$id;->guidanceRoot:I\n"
            f"    invoke-static {{p0, v0}}, {BADGE}->attachGoogle(Landroid/app/Activity;I)V\n",
        ),
    }


def run(*args):
    subprocess.run([str(arg) for arg in args], check=True)


def apply(main, google, tools, work):
    edits = {**hooks(main, google), **patch_location.hooks(main)}
    osm = main / PACKAGE / "WideOsmLimit.smali"
    if not osm.is_file() or "currentValue()I" not in osm.read_text():
        raise ValueError("Apply the wide.62 OSM patch first")

    stubs = work / "stubs"
    compiled = work / "compiled"
    dex = work / "dex"
    dex.mkdir()
    android = tools / "android.jar"
    compiler = ("java", "-jar", tools / "ecj.jar", "-8", "-proc:none", "-encoding", "UTF-8")
    run(*compiler, "-cp", android, "-d", stubs,
        HERE / "stubs/com/navipilot/obf/Signatures.java")
    run(*compiler, "-cp", f"{android}:{stubs}", "-d", compiled,
        *sorted((HERE / "src").glob("*.java")))
    run("java", "-cp", tools / "android-15/lib/d8.jar", "com.android.tools.r8.D8",
        "--min-api", "31", "--lib", android, "--classpath", stubs, "--output", dex,
        *sorted((compiled / PACKAGE).glob("*.class")))
    smali = work / "smali"
    run("java", "-cp", tools / "deps/*", "org.jf.baksmali.Main",
        "d", dex / "classes.dex", "-o", smali)

    helpers = {main / path.relative_to(smali): path.read_text()
               for path in (smali / PACKAGE).glob("Wide*.smali")
               if re.match(r"Wide(?:SpeedBadge|OsmLocation|ShieldSize|ShieldSample)(?:\$|\.)", path.name)}
    if main / PACKAGE / "WideSpeedBadge.smali" not in helpers or any(p.exists() for p in helpers):
        raise ValueError("Missing generated badge or badge already installed")
    for path, source in {**helpers, **edits}.items():
        path.write_text(source)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ("main", "google", "tools"):
        parser.add_argument(name, type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="wide62-badge-") as work:
        apply(args.main, args.google, args.tools, Path(work))
