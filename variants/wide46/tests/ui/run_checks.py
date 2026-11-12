#!/usr/bin/env python3
"""Production painter preview + semantic/geometry checks; no Android runtime or vehicle claim."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import subprocess
import tempfile

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--javac',default='javac')
    parser.add_argument('--java',default='java')
    parser.add_argument('--json-jar',type=Path,required=True)
    parser.add_argument('--output-dir',type=Path,help='Directory for reports and previews; defaults to variants/wide46/verification')
    parser.add_argument('--strict-layout',action='store_true')
    args=parser.parse_args()
    here=Path(__file__).resolve().parent
    repo=here.parents[3]
    output=args.output_dir.resolve() if args.output_dir else repo/'variants/wide46/verification'
    sources=[repo/'variants/wide46/src/WideDashboardFace.java',repo/'variants/wide46/src/WideEnforcementLabels.java',
        repo/'variants/enforcement-alert/src/WideEnforcementEngine.java',repo/'variants/wide30/src/WideCameraFace.java',
        repo/'variants/wide37/compat/WideCameraEngine.java',repo/'variants/hcop-tw/work/src/WideHcopRoad.java',
        repo/'variants/hcop-tw/work/src/WideRoad.java',here/'BoundaryStubs.java',here/'DashboardUiChecks.java']
    hashes={str(p.relative_to(repo)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    with tempfile.TemporaryDirectory(prefix='copilot-ui-checks-') as temporary:
        subprocess.run([args.javac,'-encoding','UTF-8','-cp',str(args.json_jar),'-d',temporary,*map(str,sources)],check=True)
        cmd=[args.java,'-Djava.awt.headless=true','-cp',temporary+os.pathsep+str(args.json_jar),'com.navipilot.obf.DashboardUiChecks',str(output)]
        subprocess.run(cmd+(['--strict-layout'] if args.strict_layout else []),check=True)
    after={str(p.relative_to(repo)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sources}
    if hashes!=after:
        raise RuntimeError('Source changed during run; rerun against the final painter')
    report_path=output/'ui-checks.json'
    report=json.loads(report_path.read_text(encoding='utf-8'))
    report['source_sha256']=hashes
    report['validation']='Production painter and engine host execution; approximate typography; no device screenshot, GPS or C4 test.'
    report_path.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    if report.get('font')!='Noto Sans CJK TC':
        raise RuntimeError('UI checks require Noto Sans CJK TC; install fonts-noto-cjk instead of validating fallback font metrics')
    print(report_path)

if __name__=='__main__': main()
