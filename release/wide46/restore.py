#!/usr/bin/env python3
"""Restore an exact signed APK from a public, hash-pinned binary base and patch.

No signing key is used. bsdiff4==1.4.2 is required. Every input and final output is
checked before an atomic write. The same command can restore the wide45 build base.
"""
import argparse
import hashlib
import json
from pathlib import Path
import tempfile
import urllib.request
import bsdiff4

LIMIT=160*1024*1024
def digest(data):return hashlib.sha256(data).hexdigest()
def filename(value):
    if not isinstance(value,str) or not value or Path(value).name!=value or value in ('.','..'):
        raise ValueError('Expected a plain file name in the release manifest')
    return value
def restore(manifest,output_dir,base_file=None):
    manifest=Path(manifest).resolve();m=json.loads(manifest.read_text())
    output_dir=Path(output_dir).resolve();output_dir.mkdir(parents=True,exist_ok=True)
    target=output_dir/filename(m['apk'])
    if target.exists():
        if target.stat().st_size==m['apkBytes'] and digest(target.read_bytes())==m['apkSha256']:return target
        raise ValueError('Output already exists with different content; it was not changed')
    patch=(manifest.parent/filename(m['patch'])).read_bytes()
    if len(patch)!=m['patchBytes'] or digest(patch)!=m['patchSha256']:raise ValueError('Patch hash/size mismatch')
    if base_file:
        base_file=Path(base_file)
        if base_file.stat().st_size>LIMIT:raise ValueError('Base exceeds size limit')
        base=base_file.read_bytes()
    else:
        url=m['baseUrl']
        if not url.startswith('https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/'):
            raise ValueError('Base URL is outside the expected public release source')
        with urllib.request.urlopen(url,timeout=60) as response:base=response.read(LIMIT+1)
        if len(base)>LIMIT:raise ValueError('Base exceeds size limit')
    if digest(base)!=m['baseSha256']:raise ValueError('Base SHA-256 mismatch')
    result=bsdiff4.patch(base,patch)
    if len(result)!=m['apkBytes'] or digest(result)!=m['apkSha256']:raise ValueError('Restored APK hash/size mismatch')
    temp=None
    try:
        with tempfile.NamedTemporaryFile(dir=output_dir,prefix=target.name+'.',suffix='.tmp',delete=False) as f:
            temp=Path(f.name);f.write(result)
        temp.replace(target)
    finally:
        if temp is not None:temp.unlink(missing_ok=True)
    return target
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--manifest',required=True,type=Path)
    p.add_argument('--output-dir',required=True,type=Path);p.add_argument('--base-file',type=Path)
    a=p.parse_args();out=restore(a.manifest,a.output_dir,a.base_file)
    print(json.dumps({'apk':str(out),'sha256':digest(out.read_bytes())}))
