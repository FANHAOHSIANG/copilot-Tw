#!/usr/bin/env python3
"""Independent final APK comparison; does not trust the build or patch reports.

Reuses only binary-manifest parsing and smali normalization from the wide46 verifier.
Does not establish Android/AMap/C4 runtime behavior.
"""
import argparse
from concurrent.futures import ThreadPoolExecutor
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import zipfile

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("prior_verifier", HERE.parent / "wide46/verify_apk.py")
prior = importlib.util.module_from_spec(spec)
spec.loader.exec_module(prior)
BASE_HASH = "6b388d7a6a39a3dd0e026dd47c452e231433d7030c0fe87ecfe5dd014364b696"
BASE_VERSION, BASE_CODE = "9.3.1-wide.46-enforcement-google", 26110758
VERSION, CODE = "9.3.1-wide.47-amap-diagnostics", 26110759
PREFIX = "com/navipilot/obf/"

def main():
    p = argparse.ArgumentParser(description=__doc__)
    for arg in ["base-apk", "apk", "toolchain", "build-tools", "output-dir", "report"]:
        p.add_argument("--" + arg, type=Path, required=True)
    a = p.parse_args()
    base, apk, tools, bt, work = [x.resolve() for x in [a.base_apk,a.apk,a.toolchain,a.build_tools,a.output_dir]]
    if prior.file_hash(base) != BASE_HASH: raise SystemExit("Unexpected base hash")
    work.mkdir(parents=True, exist_ok=False)
    errors = []
    def require(ok, why):
        if not ok: errors.append(why)
    def run(label, command, allowed=(0,)):
        r = subprocess.run(list(map(str,command)),text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        (work/(label+".txt")).write_text(r.stdout)
        if r.returncode not in allowed: raise SystemExit(label+" failed; inspect verifier output")
        return r.stdout
    digest = prior.file_hash(apk)
    a.report.parent.mkdir(parents=True, exist_ok=True)
    a.report.write_text(json.dumps({"passed":False,"verificationComplete":False,"apkSha256":digest})+"\n")
    with zipfile.ZipFile(base) as old, zipfile.ZipFile(apk) as new:
        oldnames,newnames=[{n for n in z.namelist() if not n.endswith('/')} for z in [old,new]]
        require(all(len(z.namelist())==len(set(z.namelist())) for z in [old,new]),"Duplicate ZIP entries")
        added_entries,removed_entries=sorted(newnames-oldnames),sorted(oldnames-newnames)
        changed_entries=sorted(n for n in oldnames&newnames if old.read(n)!=new.read(n))
        require(all(prior.signing_metadata(n) for n in added_entries+removed_entries),"Unexpected added/removed payload")
        require(all(n in {'classes.dex','AndroidManifest.xml'} or prior.signing_metadata(n) for n in changed_entries),"Unexpected changed payload")
        protected=[n for n in oldnames if n.startswith(('assets/','lib/','res/'))]
        require(all(n in newnames and old.read(n)==new.read(n) for n in protected),"Protected APK bytes changed")
        for label,z in [('base',old),('final',new)]:
            (work/label).mkdir(); (work/label/'classes.dex').write_bytes(z.read('classes.dex'))
    jars=sorted((tools/'baksmali').glob('*.jar')); cp=os.pathsep.join(map(str,jars))
    def disassemble(label):
        run('smali-'+label,['java','-cp',cp,'org.jf.baksmali.Main','disassemble','--api','35','--jobs','2',
            '--sequential-labels','--use-locals','--accessor-comments','false','--debug-info','true',
            '--output',work/label/'smali',work/label/'classes.dex'])
    with ThreadPoolExecutor(max_workers=2) as pool: list(pool.map(disassemble,['base','final']))
    def load(label):
        folder=work/label/'smali'
        return {str(f.relative_to(folder)):prior.normalize(f.read_text()) for f in folder.rglob('*.smali')}
    before,after=load('base'),load('final')
    added,removed=sorted(after.keys()-before.keys()),sorted(before.keys()-after.keys())
    changed=sorted(n for n in before.keys()&after.keys() if before[n]!=after[n])
    family=lambda n:n.startswith(PREFIX+'WideAmapLink')
    log,record,version=[PREFIX+n+'.smali' for n in ['WideBridgeLog','WideBridgeLog$1','Yg']]
    require(all(family(n) for n in added),"Unrelated class added")
    require(all(family(n) and '$' in n for n in removed),"Unrelated/root class removed")
    require(all(family(n) or n in [log,record,version] for n in changed),"Unrelated class changed")
    require(all(n in changed for n in [log,record,version,PREFIX+'WideAmapLink.smali',PREFIX+'WideAmapLinkIntegration.smali']),"Required change missing")
    require(PREFIX+'WideAmapLinkTrace.smali' in added,"Capture implementation missing")
    invoke='invoke-static {v1}, Lcom/navipilot/obf/WideAmapLinkIntegration;->extendReport(Ljava/lang/String;)Ljava/lang/String;'
    lines=prior.nonempty(after[log]); positions=[i for i,l in enumerate(lines) if l.strip()==invoke]
    require(len(positions)==1,"Export hook must be unique")
    exact_hook=False
    if len(positions)==1:
        i=positions[0]
        anchor='invoke-static {}, Lcom/navipilot/obf/WideTelemetry;->report()Ljava/lang/String;'
        exact_hook=(lines[i-2].strip()==anchor and lines[i-1].strip()=='move-result-object v1'
            and lines[i+1].strip()=='move-result-object v1'
            and lines[:i]+lines[i+2:]==prior.nonempty(before[log]))
    require(exact_hook,"Export hook changed unrelated instructions")
    require(before[record].count('wide.16')==1 and before[record].replace('wide.16','wide.47')==after[record],"Recorder label changed beyond literal")
    require(before[version].replace(BASE_VERSION,VERSION).replace(str(BASE_CODE),str(CODE))==after[version],"Version UI changed beyond literals")
    removed_types=['L'+n[:-6]+';' for n in removed]
    stale=[n for n,t in after.items() if any(d in t for d in removed_types)]
    require(not stale,"Removed synthetic still referenced")
    manifests={}
    certificates={}
    for label,file,v,c in [('base',base,BASE_VERSION,BASE_CODE),('final',apk,VERSION,CODE)]:
        manifests[label]=prior.xml_tree(run('manifest-'+label,[bt/'aapt2','dump','xmltree','--file','AndroidManifest.xml',file]))
        prior.manifest_version(manifests[label],v,c)
        certificate=run('certificate-'+label,['java','-jar',bt/'lib/apksigner.jar','verify','--verbose','--print-certs',file])
        certificates[label]=re.findall(r'certificate SHA-256 digest: ([a-f0-9]+)',certificate)
    require(manifests['base']==manifests['final'],"Manifest changed beyond version")
    require(bool(certificates['base']) and certificates['base']==certificates['final'],"Signing identity changed")
    run('alignment',[bt/'zipalign','-c','-P','16','4',apk])
    consumers=[n for n,t in after.items() if re.search(r'Lcom/navipilot/obf/WideAmapLink[^;]*;->',t)]
    selected=sorted(set(changed+added+consumers+[n for n in after if family(n)]))
    targets=work/'targets.txt'; targets.write_text(''.join('L'+n[:-6]+';\n' for n in selected))
    checker=HERE.parent/'amap-link1/tooling/CheckReferences.java'
    checker_cp=str(tools/'asm.jar')+os.pathsep+cp
    (work/'checker').mkdir()
    run('compile-checker',['java','-jar',tools/'ecj.jar','-8','-proc:none','-nowarn','-cp',checker_cp,'-d',work/'checker',checker])
    references=json.loads(run('references',['java','-cp',str(work/'checker')+os.pathsep+checker_cp,'CheckReferences',apk,targets,tools/'platform/android-35/android.jar'],(0,1)))
    require(not references['unresolved'] and references['selectedClassCount']==len(selected),"Unresolved/missing internal reference checks")
    require(prior.file_hash(apk)==digest and prior.file_hash(base)==BASE_HASH,"APK changed during verification")
    unchanged=sorted(n for n in before.keys()&after.keys() if before[n]==after[n])
    report={'passed':not errors,'verificationComplete':True,'version':VERSION,'apkSha256':digest,
        'baseSha256':BASE_HASH,'apkBytes':apk.stat().st_size,'verifierSha256':prior.file_hash(Path(__file__)),
        'helperSha256':prior.file_hash(HERE.parent/'wide46/verify_apk.py'),'independentOfBuildReport':True,
        'classes':{'unchangedCount':len(unchanged),'changed':changed,'added':added,'removed':removed},
        'apkEntries':{'changed':changed_entries,'added':added_entries,'removed':removed_entries},
        'unchangedAssetsLibrariesResources':len(protected),'manifestVersionOnly':manifests['base']==manifests['final'],
        'exactExportHook':exact_hook,'sameSigningCertificate':certificates['base']==certificates['final'],
        'certificatesSha256':certificates,'alignment16KiB':True,'references':references,'errors':errors,
        'limitations':['Host/static verification only; Android Binder and C4 runtime not tested.',
            'No complete-route or next-turn parser added.','External platform references are skipped by the member checker.']}
    a.report.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps({'passed':not errors,'unchangedClasses':len(unchanged),'changed':changed,'added':added,'errors':errors},ensure_ascii=False))
    if errors: raise SystemExit(1)

if __name__=='__main__': main()
