from pathlib import Path
import argparse
import hashlib
import json
import re
import sys
from patch_telemetry import HOOKS
sys.path.insert(0, str(Path(__file__).resolve().parent.parent / 'dualfix-src'))
from verify_dualfix import normalize_smali, files, method, SERVICE


def verify(base, out, final, apk, flavor):
    a, b = files(base), files(out)
    allowed = {'apktool.yml'} | {'smali/com/navipilot/obf/' + x + '.smali'
        for x in ['Ae', 'xe', 'WideSettings', 'WideDirect', 'WideTelemetry']}
    changed = sorted(k for k in a if k not in b or a[k].read_bytes() != b[k].read_bytes())
    assert set(changed) == allowed, changed
    added = sorted(set(b) - set(a))
    assert added and all(k.startswith('smali/com/navipilot/obf/WideLinkDiagnostics') for k in added), added
    for name, (before, addition) in HOOKS.items():
        k = 'smali/com/navipilot/obf/' + name + '.smali'
        assert b[k].read_text() == a[k].read_text().replace(before, before + addition)
    create = method(b[SERVICE].read_text(), 'f(Ljava/lang/String;IIIFLandroid/view/Surface;)I')
    assert '->a(I)V' not in create, 'Dual display fix regressed'
    protected = [SERVICE] + ['smali/com/navipilot/obf/' + n + '.smali'
                            for n in ['Od', 'h4', 'WideGeometry', 'WideDivider', 'ye', 'ze', 'WideDirect$Pane']]
    for k in protected:
        assert a[k].read_bytes() == b[k].read_bytes(), k
    telemetry = b['smali/com/navipilot/obf/WideTelemetry.smali'].read_text()
    assert 'PackageManager;->getPackageInfo' in telemetry
    assert 'PackageInfo;->getLongVersionCode()J' in telemetry
    assert 'wide.9-probe' not in telemetry and 'wide.8-auto' not in telemetry
    assert 'WideGeometry;->reconnect(ZZJJJZ)Z' in telemetry
    assert telemetry.count('Ae;->c(JLjava/lang/String;Ljava/lang/Integer;)V') == 1
    # Resolve every app-owned reference in the replacement helpers against the actual APK.
    classes = {}
    for p in out.glob('smali*/**/*.smali'):
        s = p.read_text()
        owner = re.search(r'^\.class[^\n]*? (L[^;]+;)$', s, re.M)[1]
        classes[owner] = (re.findall(r'^\.(?:super|implements) (L[^;]+;)$', s, re.M),
            set(re.findall(r'^\.method .*? (\S+\(\S*)$', s, re.M)),
            set(re.findall(r'^\.field .*? (\S+:\S+?)(?: = .*|)$', s, re.M)))
    def resolve(owner, name, is_method, seen=None):
        seen = set() if seen is None else seen
        if owner in seen: return False
        seen.add(owner)
        if owner not in classes: return owner.startswith(('Landroid/', 'Ljava/'))
        parents, methods, fields = classes[owner]
        return name in (methods if is_method else fields) or any(resolve(p, name, is_method, seen) for p in parents)
    refs = 0
    for p in out.glob('smali/com/navipilot/obf/Wide*.smali'):
        if not p.name.startswith(('WideTelemetry', 'WideLinkDiagnostics')): continue
        for owner, name in re.findall(r'(L[^\s;]+;)->([^\s,]+)', p.read_text()):
            if owner in classes:
                assert resolve(owner, name, '(' in name), (p.name, owner, name)
                refs += 1
    count = 0
    if final:
        expected = {str(p.relative_to(out)) for p in out.glob('smali*/**/*.smali')}
        actual = {str(p.relative_to(final)) for p in final.glob('smali*/**/*.smali')}
        assert actual == expected
        for k in expected:
            assert normalize_smali((out/k).read_text()) == normalize_smali((final/k).read_text()), k
            count += 1
    report = {'status': 'PASS', 'flavor': flavor, 'version_code': 26110723,
        'changed_files': changed, 'added_files': added, 'helper_references_checked': refs,
        'packaged_smali_files_verified': count,
        'dual_display_fix_navigation_and_retry_schedule': 'PRESERVED',
        'android_runtime': 'NOT RUN', 'server_timeout_fix': 'NOT CLAIMED'}
    if apk: report['apk_sha256'] = hashlib.sha256(apk.read_bytes()).hexdigest()
    return report


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('base', type=Path)
    p.add_argument('out', type=Path)
    p.add_argument('flavor', choices=['auto', 'probe'])
    p.add_argument('--final', type=Path)
    p.add_argument('--apk', type=Path)
    a = p.parse_args()
    print(json.dumps(verify(a.base, a.out, a.final, a.apk, a.flavor), ensure_ascii=False, indent=2))
