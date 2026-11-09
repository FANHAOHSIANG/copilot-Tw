"""Targeted fix for the original single-display eviction in the dual-pane app.

Only display creation, build version, and diagnostic version label change.
The display-id-specific release method and all navigation code are retained.
"""
from pathlib import Path
import argparse
import re
import shutil

SERVICE = 'smali/com/navipilot/amap2tesla/privileged/PrivilegedDisplayService.smali'
REPORT = 'smali/com/navipilot/obf/WideDirect.smali'
CREATE = 'f(Ljava/lang/String;IIIFLandroid/view/Surface;)I'
OLD = {'auto': ('9.3.1-wide.8-auto', 26110719),
       'probe': ('9.3.1-wide.9-probe', 26110720)}
VERSION_CODE = 26110722


def method(text, signature):
    result = re.search(r'^\.method [^\n]* ' + re.escape(signature)
                       + r'\n.*?^\.end method', text, re.M | re.S)
    if result is None:
        raise ValueError('Missing method: ' + signature)
    return result.group(0)


def fix_creation(original):
    # Keep v5: it is used later to register the newly created display.
    begin = '    invoke-virtual {v5}, Ljava/util/concurrent/ConcurrentHashMap;->keySet()Ljava/util/Set;'
    end = '    :cond_0\n'
    start = original.index(begin)
    stop = original.index(end, start) + len(end)
    removed = original[start:stop]
    expected = '    invoke-virtual {v0, v7}, Lcom/navipilot/amap2tesla/privileged/PrivilegedDisplayService;->a(I)V'
    assert removed.count(expected) == 1
    assert '    goto :goto_0' in removed
    assert '    if-eqz v7, :cond_0' in removed
    fixed = original[:start] + original[stop:]
    assert '->a(I)V' not in fixed
    assert 'ConcurrentHashMap;->keySet()' not in fixed
    assert ':goto_0' not in fixed and ':cond_0' not in fixed
    return fixed


def patch(base, out, flavor):
    if out.exists():
        raise FileExistsError('Use an empty output directory: ' + str(out))
    shutil.copytree(base, out, ignore=lambda d, names:
                    [n for n in names if Path(d) == base and n in ('build', 'dist')])
    target = out / SERVICE
    original = target.read_text()
    before = method(original, CREATE)
    target.write_text(original.replace(before, fix_creation(before), 1))
    old_version, old_code = OLD[flavor]
    new_version = '9.3.1-wide.10-' + flavor + '-dualfix'
    metadata = out / 'apktool.yml'
    contents = metadata.read_text()
    assert 'versionCode: ' + str(old_code) in contents
    assert 'versionName: ' + old_version in contents
    metadata.write_text(contents.replace('versionCode: ' + str(old_code),
                                        'versionCode: ' + str(VERSION_CODE))
                        .replace('versionName: ' + old_version,
                                 'versionName: ' + new_version))
    report = out / REPORT
    contents = report.read_text()
    assert contents.count(old_version.removeprefix('9.3.1-')) == 1
    report.write_text(contents.replace(old_version.removeprefix('9.3.1-'),
                                      new_version.removeprefix('9.3.1-')))
    print('Patched', flavor, ': create preserves existing displays; release remains per display ID.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    parser.add_argument('flavor', choices=OLD)
    args = parser.parse_args()
    patch(args.base, args.out, args.flavor)
