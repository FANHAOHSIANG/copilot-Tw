#!/usr/bin/env python3
"""Restore exact signed public artifacts; fail closed on every byte mismatch."""
import hashlib,json,subprocess,sys,urllib.request,zipfile
from pathlib import Path
import bsdiff4
H=Path(__file__).resolve().parent;root=H.parents[1];m=json.loads((H/'manifest.json').read_text());out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
def verify(data,digest):
 assert hashlib.sha256(data).hexdigest()==digest,'Artifact checksum mismatch'
 return data
def download(url,digest):
 with urllib.request.urlopen(url,timeout=120) as r:return verify(r.read(),digest)
base=download(m['baseUrl'],m['baseSha256']);patch=b''.join(verify((H/c['file']).read_bytes(),c['sha256']) for c in m['chunks']);verify(patch,m['patchSha256']);apk=verify(bsdiff4.patch(base,patch),m['apkSha256']);assert len(apk)==m['apkBytes'];(out/m['apk']).write_bytes(apk)
for item in m['companions']:(out/item['name']).write_bytes(download(item['url'],item['sha256']))
# Whole source tree at this commit, not private local build/signing directories.
subprocess.run(['git','archive','--format=zip','--output',str((out/'wide.53-source.zip').resolve()),'HEAD'],cwd=root,check=True)
for name in ['SHIZUKU-LICENSE.txt','STELLAR-LICENSE.txt','README.md']:
 source=root/'third_party/projection'/name;(out/('THIRD-PARTY-'+name if name=='README.md' else name)).write_bytes(source.read_bytes())
(out/'RELEASE_MANIFEST.json').write_text(json.dumps(m,ensure_ascii=False,indent=2)+'\n')
files=sorted(f for f in out.iterdir() if f.is_file() and f.name!='SHA256SUMS.txt');(out/'SHA256SUMS.txt').write_text(''.join(hashlib.sha256(f.read_bytes()).hexdigest()+'  '+f.name+'\n' for f in files));print('Restored and verified',len(files),'files')
