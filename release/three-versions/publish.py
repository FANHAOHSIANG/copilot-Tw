#!/usr/bin/env python3
"""Restore the exact three previously delivered signed APKs. No signing key needed."""
import base64,hashlib,io,json,struct,subprocess,urllib.request,zipfile,zlib
from pathlib import Path
import bsdiff4
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
OUT=ROOT/'release-output'
def sha(b):return hashlib.sha256(b).hexdigest()
def pieces(data):
 with zipfile.ZipFile(io.BytesIO(data)) as z:
  es=sorted(z.infolist(),key=lambda x:x.header_offset)
  return {e.filename:data[e.header_offset:(es[i+1].header_offset if i+1<len(es) else z.start_dir)] for i,e in enumerate(es)}
def fetch(name,digest):
 with urllib.request.urlopen('https://github.com/FANHAOHSIANG/copilot-Tw/releases/download/wide.46/'+name,timeout=120) as r:b=r.read(170*1024*1024)
 assert sha(b)==digest,'Public base hash mismatch';return b
B={}
def restore(payload):
 m=json.loads(zlib.decompress(base64.b64decode((HERE/payload).read_text())));records={}
 for k,h in m['baseHashes'].items():
  assert sha(B[k])==h,'Base SHA-256 mismatch';records[k]=pieces(B[k])
 chunks=[]
 rawbases={k:zipfile.ZipFile(io.BytesIO(B[k])) for k in m['baseHashes']}
 for r in m['records']:
  if 'level' in r:
   if 'rawliteral' in r:raw=zlib.decompress(base64.b64decode(r['rawliteral']))
   else:
    raw=rawbases[r['base']].read(r['entry'])
    if 'rawpatch' in r:raw=bsdiff4.patch(raw,base64.b64decode(r['rawpatch']))
   if r['level']:
    co=zlib.compressobj(r['level'],zlib.DEFLATED,-15);raw=co.compress(raw)+co.flush()
   chunk=base64.b64decode(r['header'])+raw+base64.b64decode(r['footer'])
  elif 'literal' in r:chunk=base64.b64decode(r['literal'])
  else:
   chunk=records[r['base']][r['entry']]
   if 'patch' in r:chunk=bsdiff4.patch(chunk,base64.b64decode(r['patch']))
  chunks.append(chunk)
 for z in rawbases.values():z.close()
 result=b''.join(chunks)+zlib.decompress(base64.b64decode(m['tailz']))
 assert len(result)==m['bytes'] and sha(result)==m['sha256'],'Restored APK mismatch'
 return m,result

def main():
 B['wide46']=fetch('Copilot-tw-9.3.1-wide.46-enforcement-google.apk','6b388d7a6a39a3dd0e026dd47c452e231433d7030c0fe87ecfe5dd014364b696')
 B['google011']=fetch('CP-Google-Navigation-0.1.1.apk','9baa3cccd387a4632650c42c3006e55dbd64a352bba72b4ee2072a8b19c57ff1')
 jobs=[('wide.51','wide51','db0c8f2e1be13674db98de340a674c1cfec8b9bf'),('google.0.1.2','google012','775bf9b56dffcab95882b6cd7aa0aaaf3944b01b'),('wide.52','wide52','f2e60a59bf7d6a1b11c8c3fd14d51301ab39b482')]
 for payload,key,source in jobs:
  m,result=restore(payload+'.payload.b64');B[key]=result
  out=OUT/payload;out.mkdir(parents=True,exist_ok=True);(out/m['apk']).write_bytes(result)
  # Source commit contains exact version-specific source plus inherited inputs.
  subprocess.run(['git','archive','--format=zip','--prefix='+payload+'/','--output',str(out/(payload+'-source.zip')),source],cwd=ROOT,check=True)
  evidence={'apk':m['apk'],'sha256':m['sha256'],'bytes':m['bytes'],'sourceCommit':source,'exactPreviouslyDeliveredBytes':True,'signingSecretsIncluded':False,'deviceAcceptanceComplete':False}
  (out/'RELEASE_MANIFEST.json').write_text(json.dumps(evidence,indent=2)+'\n')
  (out/'SHA256SUMS.txt').write_text(''.join(sha(p.read_bytes())+'  '+p.name+'\n' for p in sorted(out.iterdir()) if p.name!='SHA256SUMS.txt'))
  print(payload,m['apk'],m['sha256'],flush=True)
if __name__=='__main__':main()
