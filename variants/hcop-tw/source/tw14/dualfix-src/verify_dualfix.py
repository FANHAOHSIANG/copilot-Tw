"""Offline regression guards; does not claim an Android runtime test."""
from pathlib import Path
import argparse
import hashlib
import json
import re
from patch_dualfix import SERVICE, REPORT, CREATE, OLD, VERSION_CODE, method, fix_creation


def normalize_smali(text):
    # Apktool emits different label numbers after deleting a block; retain the
    # label topology by assigning each label an ordinal in definition order.
    text = re.sub(r'\\u([0-9a-fA-F]{4})', lambda m: chr(int(m[1], 16)), text)
    def method_labels(match):
        block = match[0]
        labels = re.findall(r'^\s*(:\w+)\s*$', block, re.M)
        mapping = {label: ':L' + str(i) for i, label in enumerate(labels)}
        return re.sub(r'(?<![\w])(:\w+)', lambda m: mapping.get(m[0], m[0]), block)
    text = re.sub(r'^\.method .*?^\.end method', method_labels, text, flags=re.M | re.S)
    return '\n'.join(line.strip() for line in text.splitlines()
                     if line.strip() and not line.lstrip().startswith('#')
                     and line.strip() != 'nop')


def files(root):
    return {str(p.relative_to(root)): p for p in root.rglob('*')
            if p.is_file() and p.relative_to(root).parts[0] not in ('build', 'dist')}


def verify(base, out, flavor, final=None, apk=None):
    a, b = files(base), files(out)
    assert a.keys() == b.keys(), 'Unexpected added/deleted file'
    changes = sorted(k for k in a if a[k].read_bytes() != b[k].read_bytes())
    assert changes == sorted([SERVICE, REPORT, 'apktool.yml']), changes
    before = a[SERVICE].read_text()
    after = b[SERVICE].read_text()
    old_create, new_create = method(before, CREATE), method(after, CREATE)
    assert after == before.replace(old_create, fix_creation(old_create), 1)
    assert method(before, 'a(I)V') == method(after, 'a(I)V')
    # Per-ID cleanup still removes only the supplied display and its pointers.
    release = method(after, 'a(I)V')
    assert 'Integer;->valueOf(I)' in release and 'if-ne v2, p1' in release
    assert 'ConcurrentHashMap;->remove(Ljava/lang/Object;)' in release
    assert 'VirtualDisplay;->release()V' in release
    assert 'ConcurrentHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)' in new_create
    assert '->a(I)V' not in new_create and '->release()V' not in new_create
    assert 'ConcurrentHashMap;->keySet()' not in new_create
    # Verify navigation, layout, and the pane-specific close lifecycle are all
    # byte-for-byte identical. The whitelist above also covers every other file.
    preserved = ['h4', 'Od', 'WideDivider', 'WideDirect$Pane', 'WideDirect$Session']
    hashes = {}
    for name in preserved:
        key = 'smali/com/navipilot/obf/' + name + '.smali'
        assert a[key].read_bytes() == b[key].read_bytes()
        hashes[name] = hashlib.sha256(b[key].read_bytes()).hexdigest()
    nav_sender = method(b['smali/com/navipilot/obf/Od.smali'].read_text(),
                        'k(Ljava/lang/Object;)Ljava/lang/Object;')
    if flavor == 'probe':
        assert 'WideNavProbe;->packet' in nav_sender
        assert 'DatagramSocket' not in nav_sender
    assert 'versionCode: ' + str(VERSION_CODE) in b['apktool.yml'].read_text()
    checked = 0
    if final:
        for p in out.glob('smali*/**/*.smali'):
            q = final / p.relative_to(out)
            assert q.is_file(), q
            assert normalize_smali(p.read_text()) == normalize_smali(q.read_text()), str(q)
            checked += 1
    result = {'status': 'PASS', 'flavor': flavor, 'version_code': VERSION_CODE,
              'changed_files': changes, 'original_cross_display_eviction_present': True,
              'cross_display_eviction_removed': True, 'per_display_release_preserved': True,
              'navigation_and_layout_hashes': hashes,
              'packaged_smali_files_verified': checked,
              'android_runtime': 'NOT RUN; device confirmation required'}
    if apk:
        result['apk_sha256'] = hashlib.sha256(apk.read_bytes()).hexdigest()
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    parser.add_argument('flavor', choices=OLD)
    parser.add_argument('--final', type=Path)
    parser.add_argument('--apk', type=Path)
    args = parser.parse_args()
    print(json.dumps(verify(args.base, args.out, args.flavor, args.final, args.apk),
                     ensure_ascii=False, indent=2))
