"""Run wide55 host delivery and pinned receiver tests. Requires aiohttp for loopback."""
import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent


def run(*args):
    r = subprocess.run([str(x) for x in args], capture_output=True, text=True)
    if r.returncode:
        raise RuntimeError(r.stdout + r.stderr)
    return r.stdout


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--ecj', type=Path, required=True)
    p.add_argument('--json-jar', type=Path, required=True)
    p.add_argument('--c4-source-dir', type=Path, required=True)
    p.add_argument('--report-dir', type=Path, required=True)
    a = p.parse_args()
    a.report_dir.mkdir(parents=True, exist_ok=True)
    sources = sorted((HERE / 'stubs').rglob('*.java')) + [
        HERE.parent / 'src/WideLinkDelivery.java', HERE / 'DeliveryChecks.java',
        HERE / 'ExportGuidance.java', HERE.parents[1] / 'amap-link1/src/WideAmapLinkNavigation.java']
    with tempfile.TemporaryDirectory(prefix='wide55-tests-') as tmp:
        classes = Path(tmp) / 'classes'
        classes.mkdir()
        run('java', '-jar', a.ecj, '-8', '-proc:none', '-encoding', 'UTF-8',
            '-cp', a.json_jar, '-d', classes, *sources)
        cp = str(classes) + os.pathsep + str(a.json_jar)
        result = run('java', '-XX:-UsePerfData', '-cp', cp, 'com.navipilot.obf.DeliveryChecks')
        count = int(re.search(r'DeliveryChecks: (\d+) assertions passed', result).group(1))
        report = dict(result='passed', assertions=count, androidRuntimeValidated=False,
                      sourceSha256=hashlib.sha256((HERE.parent / 'src/WideLinkDelivery.java').read_bytes()).hexdigest(),
                      boundary='Host doubles replace Android clock, source gate, Link snapshot and MG sender')
        (a.report_dir / 'delivery.json').write_text(json.dumps(report, indent=2) + '\n')
        fixtures = Path(tmp) / 'fixtures.jsonl'
        fixtures.write_text(run('java', '-XX:-UsePerfData', '-cp', cp, 'com.navipilot.obf.ExportGuidance'))
        for script, filename in [('check_c4.py', 'c4-compatibility.json'),
                                 ('receiver_loopback.py', 'receiver-loopback.json')]:
            report = json.loads(run(sys.executable, HERE / script, a.c4_source_dir, fixtures))
            assert report['result'] == 'passed'
            (a.report_dir / filename).write_text(json.dumps(report, indent=2) + '\n')
        print(f'Passed: {count} host assertions; 6 C4 conversion cases; 6 loopback deliveries and duplicate rejection.')


if __name__ == '__main__':
    main()
