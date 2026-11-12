#!/usr/bin/env python3
"""Build wide.47 diagnostics from its hash-pinned signed wide.46 base, with signing credentials kept external."""
import argparse
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import zipfile

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
VERSION = "9.3.1-wide.50-gps-autostart"
VERSION_CODE = 26110762
BASE_VERSION = "9.3.1-wide.49-camera-baseline"
BASE_CODE = 26110761
BASE_HASH = "10eb66199eb320d47feb700a1ddf56699f4296a1b1bd089e798d53dd0d9e7770"
PREFIXES = ("WideAutoStart",)

def sha256(path):
    h = hashlib.sha256()
    with Path(path).open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--base-apk", required=True, type=Path)
    p.add_argument("--output-dir", required=True, type=Path)
    p.add_argument("--toolchain", required=True, type=Path)
    p.add_argument("--build-tools", required=True, type=Path)
    p.add_argument("--unsigned", action="store_true")
    a = p.parse_args()
    base, tools, bt, work = (x.expanduser().resolve() for x in [a.base_apk,a.toolchain,a.build_tools,a.output_dir])
    if sha256(base) != BASE_HASH: raise SystemExit("Unrecognized base APK; expected the delivered wide.46")
    paths = {"apktool":tools/"apktool.jar","ecj":tools/"ecj.jar","asm":tools/"asm.jar",
             "android":tools/"platform/android-35/android.jar","d8":bt/"lib/d8.jar",
             "signer":bt/"lib/apksigner.jar","zipalign":bt/"zipalign"}
    for name,path in paths.items():
        if not path.is_file(): raise SystemExit("Missing build tool: " + name)
    jars = sorted((tools/"baksmali").glob("*.jar"))
    if not jars: raise SystemExit("Missing baksmali dependency JARs")
    original = HERE.parent/"wide46"
    sources = sorted((HERE/"src").glob("*.java"))
    hashed = sources + [HERE/"patch_decoded.py",HERE/"build.py",original/"tooling/ApiSignatures.java"]
    source_hashes = {str(f.relative_to(ROOT)):sha256(f) for f in hashed}
    work.mkdir(parents=True,exist_ok=False); (work/"logs").mkdir()
    def run(label, command, private=False):
        print(label,flush=True)
        r = subprocess.run(list(map(str,command)),stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        if not private: (work/"logs"/(label.lower().replace(" ","-")+".txt")).write_text(r.stdout)
        if r.returncode: raise SystemExit(label+" failed; "+("private signing diagnostics suppressed" if private else "see build logs"))
        return r.stdout
    decoded=work/"decoded"
    run("Decode wide46",["java","-jar",paths["apktool"],"d","-f",base,"-o",decoded])
    with zipfile.ZipFile(base) as z: (work/"base.dex").write_bytes(z.read("classes.dex"))
    api_classes=work/"api-classes";api_classes.mkdir()
    cp=os.pathsep.join(map(str,[paths["asm"],*jars]))
    tooling=original/"tooling"
    run("Compile signature reader",["java","-jar",paths["ecj"],"-8","-proc:none","-cp",cp,"-d",api_classes,tooling/"ApiSignatures.java"])
    api=work/"base-api.jar"
    run("Read base compiler signatures",["java","-cp",str(api_classes)+os.pathsep+cp,"ApiSignatures",work/"base.dex",api])
    classes=work/"classes";classes.mkdir()
    run("Compile wide47 sources",["java","-jar",paths["ecj"],"-8","-proc:none","-nowarn","-cp",str(paths["android"])+os.pathsep+str(api),"-d",classes,*sources])
    dex=work/"dex";dex.mkdir()
    run("Build wide47 dex",["java","-cp",paths["d8"],"com.android.tools.r8.D8","--min-api","31","--lib",paths["android"],"--classpath",api,"--output",dex,*sorted(classes.rglob("*.class"))])
    generated=work/"generated-smali"
    run("Disassemble compiled classes",["java","-cp",os.pathsep.join(map(str,jars)),"org.jf.baksmali.Main","d",dex/"classes.dex","-o",generated])
    generated_files=sorted((generated/"com/navipilot/obf").glob("*.smali"))
    if not generated_files or any(not f.name.startswith(PREFIXES) for f in generated_files): raise SystemExit("Unexpected compiled class scope")
    destination=decoded/"smali/com/navipilot/obf"
    # Remove stale synthetic helpers belonging to exactly the recompiled production classes.
    for f in destination.glob("*.smali"):
        if f.name.startswith(PREFIXES): f.unlink()
    for f in generated_files: shutil.copyfile(f,destination/f.name)
    run("Apply diagnostic export hook",[sys.executable,HERE/"patch_decoded.py",decoded])
    config=decoded/"apktool.yml"; text=config.read_text()
    text,n=re.subn(r"(?m)^(  versionCode:) .*",r"\g<1> "+str(VERSION_CODE),text)
    text,k=re.subn(r"(?m)^(  versionName:) .*",r"\g<1> "+VERSION,text)
    if (n,k)!=(1,1): raise SystemExit("Unexpected version metadata")
    config.write_text(text)
    version_ui=destination/"Yg.smali";text=version_ui.read_text()
    if BASE_VERSION not in text: raise SystemExit("Unexpected in-app version label")
    version_ui.write_text(text.replace(BASE_VERSION,VERSION).replace(str(BASE_CODE),str(VERSION_CODE)))
    run("Build APK",["java","-jar",paths["apktool"],"b",decoded,"-o",work/"unsigned.apk"])
    aligned=work/("Copilot-tw-"+VERSION+"-unsigned-aligned.apk")
    run("Align APK",[paths["zipalign"],"-P","16","-f","4",work/"unsigned.apk",aligned])
    final=aligned;certificate_match=None
    if not a.unsigned:
        key=os.environ.get("COPILOT_SIGNING_KEY","");alias=os.environ.get("COPILOT_KEY_ALIAS","")
        if not Path(key).is_file() or not alias or not os.environ.get("COPILOT_STORE_PASSWORD"):
            raise SystemExit("External signing variables missing; use --unsigned only for an unsigned build")
        final=work/("Copilot-tw-"+VERSION+".apk")
        command=["java","-jar",paths["signer"],"sign","--ks",key,"--ks-key-alias",alias,"--ks-pass","env:COPILOT_STORE_PASSWORD"]
        if os.environ.get("COPILOT_KEY_PASSWORD"): command += ["--key-pass","env:COPILOT_KEY_PASSWORD"]
        run("Sign APK",command+["--out",final,aligned],private=True)
        original=run("Verify original certificate",["java","-jar",paths["signer"],"verify","--print-certs",base])
        signed=run("Verify new certificate",["java","-jar",paths["signer"],"verify","--verbose","--print-certs",final])
        pattern=r"certificate SHA-256 digest: ([a-f0-9]+)"
        before,after=re.findall(pattern,original),re.findall(pattern,signed)
        certificate_match=bool(before) and before==after
        if not certificate_match: raise SystemExit("Signing certificate differs from the installed base")
    run("Verify 16KiB alignment",[paths["zipalign"],"-c","-P","16","4",final])
    with zipfile.ZipFile(base) as old,zipfile.ZipFile(final) as new:
        protected=[n for n in old.namelist() if n.startswith(("assets/","lib/","res/")) and not n.endswith("/")]
        if any(old.read(n)!=new.read(n) for n in protected): raise SystemExit("An existing asset/library/resource changed")
    if any(sha256(ROOT/n)!=h for n,h in source_hashes.items()): raise SystemExit("Sources changed during build; rebuild from a stable snapshot")
    result={"version":VERSION,"versionCode":VERSION_CODE,"baseVersion":BASE_VERSION,"baseSha256":BASE_HASH,
        "apk":final.name,"apkSha256":sha256(final),"apkBytes":final.stat().st_size,
        "sameSigningCertificate":certificate_match,"alignment16KiB":True,"unchangedAssetsLibrariesResources":len(protected),
        "compiledClasses":[f.name for f in generated_files],"sourceSha256":source_hashes,
        "deviceTest":False,"c4ReceptionVerified":False,"routeForwardingAdded":False,
        "nextTurnForwardingAdded":False,"diagnosticCaptureOnly":True}
    (work/"build-verification.json").write_text(json.dumps(result,ensure_ascii=False,indent=2)+"\n")
    print(final);print("SHA-256: "+result["apkSha256"])

if __name__=="__main__": main()
