"""Host route tests and real C4 receiver loopback. Needs Java, ECJ, org.json and aiohttp."""
import argparse, hashlib, json, os, re, subprocess, tempfile
from pathlib import Path
HERE=Path(__file__).resolve().parent
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--ecj',required=True,type=Path);p.add_argument('--json-jar',required=True,type=Path)
p.add_argument('--c4-source-dir',required=True,type=Path);p.add_argument('--report-dir',required=True,type=Path)
a=p.parse_args();a.report_dir.mkdir(parents=True,exist_ok=True)
def run(*args):
 r=subprocess.run([str(x) for x in args],capture_output=True,text=True)
 if r.returncode:raise RuntimeError(r.stdout+r.stderr)
 return r.stdout
with tempfile.TemporaryDirectory(prefix='wide56-check-') as tmp:
 w=Path(tmp);classes=w/'classes';classes.mkdir()
 run('java','-jar',a.ecj,'-8','-proc:none','-encoding','UTF-8','-cp',a.json_jar,'-d',classes,*sorted((HERE.parent/'src').glob('*.java')),HERE/'RouteChecks.java')
 cp=str(classes)+os.pathsep+str(a.json_jar)
 result=run('java','-cp',cp,'com.navipilot.obf.RouteChecks')
 count=int(re.search(r'(\d+) assertions',result).group(1))
 fixture=w/'fixture.json';fixture.write_text(run('java','-cp',cp,'com.navipilot.obf.RouteChecks','export'))
 (a.report_dir/'route-host.json').write_text(json.dumps(dict(result='passed',assertions=count,fixture='synthetic official-schema-shaped route, not a captured phone payload',androidRuntimeValidated=False),indent=2)+'\n')
 report=json.loads(run('python',HERE/'receiver_route.py',a.c4_source_dir,fixture))
 (a.report_dir/'route-receiver.json').write_text(json.dumps(report,indent=2)+'\n')
 (a.report_dir/'tested-source-hashes.json').write_text(json.dumps({name:hashlib.sha256((a.c4_source_dir/name).read_bytes()).hexdigest() for name in ['carrot_navi.py','carrot_navi_cereal.py','carrot_navi_control.py','carrot_serv.py','source.py']},indent=2)+'\n')
 print(result.strip());print('C4 receiver, next-turn distance, full-route preservation and withdrawal passed.')
