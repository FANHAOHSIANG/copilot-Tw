"""Build a narrowly scoped, UNSIGNED wide56 overlay from the exact wide54 APK.

Tool directory: apktool.jar (2.11.1), ecj.jar (3.40.0), json.jar (20240303),
deps/*.jar (smali/baksmali 2.5.2 and dependencies), android-15/lib/d8.jar
and android-15/zipalign (Android build tools 35.0.0).
Compilation stubs are never inputs to D8 or packaged in the APK.
"""
import argparse
import hashlib
import json
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

BASE_SHA256 = '7254813300d14223c835bf32fe469ea6713fa8d2b42f82fc4bdb926f4b5c9bd4'
HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def run(*args):
    subprocess.run([str(x) for x in args], check=True)


def signature_entry(name):
    return bool(re.fullmatch(r'META-INF/(MANIFEST\.MF|[^/]+\.(SF|RSA|DSA|EC))', name, re.I))


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('--base-apk', required=True, type=Path)
    p.add_argument('--tools', required=True, type=Path)
    p.add_argument('--output', required=True, type=Path)
    a = p.parse_args()
    if sha(a.base_apk) != BASE_SHA256:
        raise SystemExit('Wrong base APK; refusing to patch an unverified version.')
    if 'UNSIGNED' not in a.output.name:
        raise SystemExit('Output filename must contain UNSIGNED.')
    if a.output.exists():
        raise SystemExit('Output already exists; use a new filename.')
    a.output.parent.mkdir(parents=True, exist_ok=True)
    cp = ':'.join(str(x) for x in sorted((a.tools / 'deps').glob('*.jar')))
    with tempfile.TemporaryDirectory(prefix='wide56-build-') as tmp:
        w = Path(tmp)
        decoded = w / 'decoded'
        run('java', '-jar', a.tools / 'apktool.jar', 'd', '-f', a.base_apk, '-o', decoded)
        before = {str(x.relative_to(decoded)): sha(x) for x in decoded.glob('smali*/**/*.smali')}
        classes = w / 'classes'
        classes.mkdir()
        # These types only describe signatures for the one new helper class.
        stubs = sorted((HERE.parent / 'wide55/tests/stubs').rglob('*.java'))
        run('java', '-jar', a.tools / 'ecj.jar', '-8', '-proc:none',
            '-cp', a.tools / 'json.jar', '-d', classes,
            *stubs, HERE.parent / 'wide55/src/WideLinkDelivery.java', *sorted((HERE/'src').glob('*.java')))
        dex = w / 'dex'
        dex.mkdir()
        run('java', '-cp', a.tools / 'android-15/lib/d8.jar', 'com.android.tools.r8.D8',
            '--min-api', '31', '--no-desugaring', '--output', dex,
            *sorted((classes / 'com/navipilot/obf').glob('WideAmapLinkNavigation*.class')),
            classes / 'com/navipilot/obf/WideAmapLinkRoute.class', classes / 'com/navipilot/obf/WideLinkDelivery.class')
        helper = w / 'helper'
        run('java', '-cp', cp, 'org.jf.baksmali.Main', 'd', dex / 'classes.dex', '-o', helper)
        emitted = list(helper.rglob('*.smali'))
        expected_helpers = {'WideLinkDelivery.smali', 'WideAmapLinkNavigation.smali', 'WideAmapLinkNavigation$Snapshot.smali', 'WideAmapLinkRoute.smali'}
        if {x.name for x in emitted} != expected_helpers:
            raise RuntimeError('Unexpected compiled classes')
        for item in emitted:
            shutil.copyfile(item, decoded / 'smali/com/navipilot/obf' / item.name)
        run(sys.executable, HERE / 'patch.py', decoded)
        after = {str(x.relative_to(decoded)): sha(x) for x in decoded.glob('smali*/**/*.smali')}
        changed = sorted(k for k in before.keys() | after.keys() if before.get(k) != after.get(k))
        expected = sorted('smali/com/navipilot/obf/' + n + '.smali' for n in
                          ['MG', 'TB', 'Yg', 'WideAmapLinkIntegration', 'WideAmapLinkIntegration$6', 'WideLinkDelivery', 'WideAmapLinkNavigation', 'WideAmapLinkNavigation$Snapshot', 'WideAmapLinkRoute'])
        if changed != expected:
            raise RuntimeError('Unexpected smali changes: ' + repr(changed))
        # Assemble main dex explicitly as 039. Apktool 2.11.1 otherwise emits 040
        # for targetSdk 35, despite this app supporting Android API 31.
        main_dex = w / 'main.dex'
        run('java', '-cp', cp, 'org.jf.smali.Main', 'assemble', '--api', '31',
            decoded / 'smali', '-o', main_dex)
        if main_dex.read_bytes()[:8] != b'dex\n039\0':
            raise RuntimeError('Unexpected dex format.')
        rebuilt = w / 'rebuilt.apk'
        run('java', '-jar', a.tools / 'apktool.jar', 'b', decoded, '-o', rebuilt)
        # Preserve all original resources, native libraries and secondary dex.
        # Only the version-bearing manifest and patched main dex are replaced.
        unaligned = w / 'unaligned.apk'
        with zipfile.ZipFile(a.base_apk) as original, zipfile.ZipFile(rebuilt) as built, \
                zipfile.ZipFile(unaligned, 'w') as out:
            for info in original.infolist():
                if signature_entry(info.filename):
                    continue
                data = original.read(info.filename)
                if info.filename == 'classes.dex':
                    data = main_dex.read_bytes()
                elif info.filename == 'AndroidManifest.xml':
                    data = built.read(info.filename)
                out.writestr(info, data)
        align = a.tools / 'android-15/zipalign'
        run(align, '-P', '16', '-f', '4', unaligned, a.output)
        run(align, '-c', '-P', '16', '4', a.output)
        with zipfile.ZipFile(a.base_apk) as original, zipfile.ZipFile(a.output) as result:
            altered = sorted(n for n in result.namelist() if result.read(n) != original.read(n))
            if altered != ['AndroidManifest.xml', 'classes.dex']:
                raise RuntimeError('Unexpected APK payload change: ' + repr(altered))
        report = dict(baseSha256=BASE_SHA256, outputSha256=sha(a.output), signed=False,
                      changedClasses=changed, changedEntries=altered,
                      secondaryDexResourcesNativeLibrariesPreserved=True,
                      dexVersion='039', androidRuntimeValidated=False, c4ReceiptValidated=False)
        a.output.with_suffix('.build.json').write_text(json.dumps(report, indent=2) + '\n')
        print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
