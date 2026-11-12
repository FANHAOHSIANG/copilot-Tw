"""Restore signed wide.44 from the verified wide.43 APK; no signing secrets."""
import pathlib,json,hashlib,subprocess,sys,bsdiff4
HERE=pathlib.Path(__file__).resolve().parent
ROOT=HERE.parents[1]
meta=json.loads((HERE/'manifest.json').read_text())
base=ROOT/'release-output'/meta['base_name']
if not base.exists():subprocess.run([sys.executable,str(ROOT/'release/wide43/publish.py')],check=True)
h=lambda b:hashlib.sha256(b).hexdigest()
b=base.read_bytes();p=(HERE/'patch.bin').read_bytes()
assert h(b)==meta['base_sha256'] and h(p)==meta['patch_sha256']
out=bsdiff4.patch(b,p);assert h(out)==meta['apk_sha256']
path=base.parent/meta['apk_name'];path.write_bytes(out)
print('Verified APK:',path.name,meta['apk_sha256'])
