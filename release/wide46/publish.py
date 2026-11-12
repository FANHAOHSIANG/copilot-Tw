#!/usr/bin/env python3
"""Prepare already-signed verified artifacts and the exact release commit's sources."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
from restore import restore

HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--google-base',required=True,type=Path)
    p.add_argument('--google-build-info',required=True,type=Path);p.add_argument('--main-base',type=Path)
    p.add_argument('--output-dir',type=Path,default=ROOT/'release-output');p.add_argument('--skip-source-archive',action='store_true')
    a=p.parse_args();out=a.output_dir.resolve();out.mkdir(parents=True,exist_ok=True)
    if not a.skip_source_archive:
        state=subprocess.check_output(['git','status','--porcelain','--untracked-files=normal'],cwd=ROOT,text=True)
        if state.strip():raise SystemExit('Source archive requires a clean committed checkout; commit or remove unrelated files first')
        required=['release/wide46/restore.py','release/wide46/publish.py','release/wide46/main-manifest.json',
                  'release/wide46/google-manifest.json','variants/wide46/verification/build.json',
                  'variants/wide46/verification/apk-scope.json','variants/google-navdash/verification/build-011.json',
                  'docs/GOOGLE_SDK_zh-TW.md','docs/DEVICE_ACCEPTANCE_zh-TW.md']
        subprocess.run(['git','ls-files','--error-unmatch',*required],cwd=ROOT,check=True,stdout=subprocess.DEVNULL)
    main_m=json.loads((HERE/'main-manifest.json').read_text());google_m=json.loads((HERE/'google-manifest.json').read_text())
    build_info=json.loads(a.google_build_info.read_text())
    if (build_info['sourceCommit']!=google_m['ciSourceCommit'] or str(build_info['runId'])!=str(google_m['ciRunId'])
        or build_info['buildOutcome']!='success' or build_info['apkSha256']!=google_m['baseSha256']):
        raise SystemExit('Google CI artifact provenance does not match the release manifest')
    google_build=json.loads((ROOT/'variants/google-navdash/verification/build-011.json').read_text())
    for name,digest in google_build['sourceSha256'].items():
        if sha(ROOT/'variants/google-navdash'/name)!=digest:raise SystemExit('Google source changed since the verified build: '+name)
    scope=json.loads((ROOT/'variants/wide46/verification/apk-scope.json').read_text())
    if not scope['passed'] or scope['apkSha256']!=main_m['apkSha256']:raise SystemExit('Main APK scope evidence does not match')
    build=json.loads((ROOT/'variants/wide46/verification/build.json').read_text())
    for name,digest in build['sourceSha256'].items():
        if sha(ROOT/name)!=digest:raise SystemExit('Main source changed since the verified build: '+name)
    main_apk=restore(HERE/'main-manifest.json',out,a.main_base)
    google_apk=restore(HERE/'google-manifest.json',out,a.google_base)
    # Preserve the exact CI unsigned input after Actions retention expires. This is
    # explicitly named .bin, not an installable APK; users install the signed file.
    unsigned_name='CP-Google-Navigation-0.1.1-unsigned-build-input.bin'
    if sha(a.google_base)!=google_m['baseSha256']:raise SystemExit('Google base changed after verification')
    shutil.copyfile(a.google_base,out/unsigned_name)
    shutil.copyfile(ROOT/'docs/GOOGLE_SDK_zh-TW.md',out/'CP-Google-Navigation-Complete-Guide-zh-TW.md')
    acceptance=(ROOT/'docs/DEVICE_ACCEPTANCE_zh-TW.md').read_text()
    (out/'Device-Acceptance-zh-TW.md').write_text(acceptance.replace('(GOOGLE_SDK_zh-TW.md)',
        '(CP-Google-Navigation-Complete-Guide-zh-TW.md)'))
    source_commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=ROOT,text=True).strip()
    if not a.skip_source_archive:
        subprocess.run(['git','archive','--format=zip','--prefix=Copilot-tw-wide.46/',
                        '--output',str(out/'Copilot-tw-wide.46-source.zip'),'HEAD'],cwd=ROOT,check=True)
    manifest={'sourceCommit':source_commit,'main':main_m,'google':google_m,
              'unsignedInputFile':unsigned_name,'deviceTest':False,'googleAuthorizationAndBillingVerified':False,
              'c4ReceptionVerified':False,'signingSecretsIncluded':False}
    (out/'RELEASE_MANIFEST.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    files=sorted(f for f in out.iterdir() if f.is_file() and f.name!='SHA256SUMS.txt')
    (out/'SHA256SUMS.txt').write_text(''.join(sha(f)+'  '+f.name+'\n' for f in files))
    print(json.dumps({'output':str(out),'main':main_apk.name,'google':google_apk.name,'files':len(files)+1,'deviceTest':False}))
if __name__=='__main__':main()
