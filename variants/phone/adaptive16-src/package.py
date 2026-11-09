from pathlib import Path
import zipfile,hashlib,json
root=Path(__file__).resolve().parent.parent
common=set()
for pattern in ('adaptive16-src/**/*','phone15-src/**/*','resize-src/stubs/**/*','dual-src/stubs/**/*','bridge-src/stubs/**/*'):
 common.update(p for p in root.glob(pattern) if p.is_file() and '__pycache__' not in p.parts)
for name in ('auto-src/WideApps.java','telemetry-src/WideTelemetry.java','telemetry-src/WideLinkDiagnostics.java','dualfix-src/patch_dualfix.py','dualfix-src/verify_dualfix.py','project/wide-build/signing/navipilot-wide-test.jks','deliverables/Navipilot-9.3.1-wide.11-auto-diagnostic.apk','deliverables/Navipilot-9.3.1-wide.15-phone-bridge.apk','adaptive16-build/geometry-tests.txt','adaptive16-build/preference-tests.txt','adaptive16-build/notification-tests.txt','adaptive16-build/layouts.json','adaptive16-build/layout-preview.png'):
 common.add(root/name)
report=[]
for flavor,version in [('auto','11'),('phone','15')]:
 baseline=root/'deliverables'/('Navipilot-9.3.1-wide.'+version+'-'+flavor+'-modifications.zip')
 output=root/'deliverables'/('Navipilot-9.3.1-wide.16-'+flavor+'-modifications.zip')
 selected=set(common)
 for name in ('verification.json','signature.txt','restore-verification.json'):
  selected.add(root/'adaptive16-build'/flavor/name)
 for pattern in ('helper-decoded/smali/**/*.smali','generated/*.java'):
  selected.update((root/'adaptive16-build'/flavor).glob(pattern))
 selected.add(root/'deliverables'/('Navipilot-9.3.1-wide.16-'+flavor+'-adaptive.apk'))
 selected.add(root/'deliverables'/('Navipilot-'+flavor+'-previous-layout-restore-build28.apk'))
 replacement={str(p.relative_to(root)):p for p in selected}
 with zipfile.ZipFile(baseline) as old,zipfile.ZipFile(output,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as new:
  for entry in old.infolist():
   if entry.filename not in replacement:new.writestr(entry,old.read(entry))
  for name,p in sorted(replacement.items()):new.write(p,name)
 with zipfile.ZipFile(output) as check:
  assert check.testzip() is None
  assert len(check.namelist())==len(set(check.namelist()))
  for name,p in replacement.items():assert check.read(name)==p.read_bytes(),name
  with zipfile.ZipFile(baseline) as old:
   for name in old.namelist():
    if name not in replacement:assert check.read(name)==old.read(name),name
 report.append({'flavor':flavor,'path':str(output),'bytes':output.stat().st_size,'sha256':hashlib.sha256(output.read_bytes()).hexdigest(),'entries':len(check.namelist())})
(root/'adaptive16-build/package-verification.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
