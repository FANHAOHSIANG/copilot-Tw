from pathlib import Path
import hashlib
import json
import os
import re
import subprocess
import sys
import zipfile

from patch_apk import (
    LABEL, SMALI, CLASS_PREFIXES, HOOKS, VERSION_CODE, applies, version_name,
)


def file_map(root):
    return {
        str(path.relative_to(root)): path
        for path in root.rglob('*')
        if path.is_file() and path.relative_to(root).parts[0] not in ('build', 'dist')
    }


def canonical(text):
    text = re.sub(r'\\u([0-9a-fA-F]{4})', lambda m: chr(int(m[1], 16)), text)
    text = re.sub(r'(^\.field .*?:Z) = false$', r'\1', text, flags=re.M)

    def labels(match):
        block = match[0]
        mapping = {
            label: f':label{index}'
            for index, label in enumerate(re.findall(r'^\s*(:\w+)\s*$', block, re.M))
        }
        return re.sub(r'(?<![\w])(:\w+)', lambda m: mapping.get(m[0], m[0]), block)

    text = re.sub(r'^\.method .*?^\.end method', labels, text, flags=re.M | re.S)
    return '\n'.join(line.strip() for line in text.splitlines()
                     if line.strip() and not line.lstrip().startswith('#') and line.strip() != 'nop')


def verify(flavor):
    stage = Path('build') / flavor
    base = file_map(stage / 'baseline')
    patched = file_map(stage / 'patched')
    apk = Path('deliverables') / 'Copilot-tw-9.3.1-wide.19-unified.apk'
    base_apk = Path('inputs') / f'{flavor}.apk'
    prefixes = CLASS_PREFIXES
    hooks = HOOKS
    changes = set(base) ^ set(patched)
    changes |= {k for k in base.keys() & patched.keys() if base[k].read_bytes() != patched[k].read_bytes()}
    for key in changes:
        if key in hooks:
            assert patched[key].read_text() == hooks[key](base[key].read_text()), key
        elif key.startswith('res/values') and key.endswith('/strings.xml'):
            expected = re.sub(r'(<string name="app_name">).*?(</string>)', rf'\g<1>{LABEL}\2', base[key].read_text())
            assert patched[key].read_text() == expected, key
        else:
            assert key == 'apktool.yml' or (key.startswith(SMALI + '/') and applies(Path(key).name, prefixes)), key
    assert (set(hooks) | {'apktool.yml'}) <= changes
    final = file_map(stage / 'final-check')
    expected_smali = {key for key in patched if key.endswith('.smali')}
    assert expected_smali == {key for key in final if key.endswith('.smali')}
    definitions = {}
    for key in expected_smali:
        source = patched[key].read_text()
        assert canonical(source) == canonical(final[key].read_text()), key
        owner = re.search(r'^\.class[^\n]*? (L[^;]+;)$', source, re.M)[1]
        assert owner not in definitions, owner
        definitions[owner] = (
            re.findall(r'^\.(?:super|implements) (L[^;]+;)$', source, re.M),
            set(re.findall(r'^\.method .*? (\S+\(\S*)$', source, re.M)),
            set(re.findall(r'^\.field .*? (\S+:\S+?)(?: = .*|)$', source, re.M)),
        )

    def resolves(owner, name, method, seen):
        if owner in seen:
            return False
        seen.add(owner)
        if owner not in definitions:
            return owner.startswith(('Landroid/', 'Ljava/', 'Lorg/json/'))
        parents, methods, fields = definitions[owner]
        return name in (methods if method else fields) or any(
            resolves(parent, name, method, seen) for parent in parents)

    refs = 0
    for key in changes & expected_smali:
        for owner, name in re.findall(r'(L[^\s;]+;)->([^\s,]+)', final[key].read_text()):
            if owner in definitions:
                assert resolves(owner, name, '(' in name, set()), (key, owner, name)
                refs += 1

    with zipfile.ZipFile(base_apk) as original, zipfile.ZipFile(apk) as built:
        binary_assets = {name for name in original.namelist() if name.startswith(('lib/', 'assets/'))}
        assert binary_assets == {name for name in built.namelist() if name.startswith(('lib/', 'assets/'))}
        for name in binary_assets:
            assert original.read(name) == built.read(name), name

    tools = Path(os.environ['COPILOT_ANDROID_TOOLS']) / 'android-16'

    def cert(path):
        output = subprocess.check_output(['bash', str(tools / 'apksigner'), 'verify', '--print-certs', str(path)], text=True)
        return re.search(r'Signer #1 certificate SHA-256 digest: (.*)', output)[1]

    assert cert(apk) == cert(base_apk)
    badging = subprocess.check_output([tools / 'aapt2', 'dump', 'badging', apk], text=True)
    assert f"versionCode='{VERSION_CODE}'" in badging and f"versionName='{version_name(flavor)}'" in badging
    assert "name='com.jixiexiaoge.drivingassist.wide'" in badging
    labels = re.findall(r"^application-label(?:-[^:]+)?:'(.*?)'$", badging, re.M)
    assert labels and set(labels) == {LABEL}, labels
    report = {
        'status': 'PASS', 'variant': flavor, 'version': version_name(flavor),
        'launcherLabel': LABEL, 'signatureMatchesBaseline': True, 'aligned16KiB': True,
        'smaliClassesRoundTrip': len(expected_smali), 'appReferencesResolved': refs,
        'preservedAssetAndLibraryEntries': len(binary_assets),
        'sha256': hashlib.sha256(apk.read_bytes()).hexdigest(), 'androidDeviceRun': False,
    }
    output = json.dumps(report, indent=2)
    (stage / 'verification.json').write_text(output + '\n')
    print(output)


if __name__ == '__main__':
    verify(sys.argv[1])
