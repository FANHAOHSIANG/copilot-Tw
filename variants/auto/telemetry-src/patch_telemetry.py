from pathlib import Path
import argparse
import shutil

HOOKS = {
    'Ae': (
        '    invoke-virtual {p4, p3}, Lcom/navipilot/obf/yW;->h(Ljava/lang/Object;)V',
        '\n\n    invoke-static {p0, p3}, Lcom/navipilot/obf/WideTelemetry;->failure(Lcom/navipilot/obf/Ae;Ljava/lang/String;)V'),
    'xe': (
        '    invoke-virtual {p0, v3}, Lcom/navipilot/obf/yW;->h(Ljava/lang/Object;)V',
        '\n\n    invoke-static {v0}, Lcom/navipilot/obf/WideTelemetry;->hello(Lcom/navipilot/obf/Ae;)V'),
    'WideSettings': (
        '.method public static install(Landroid/app/Activity;)V\n    .locals 4',
        '\n\n    invoke-static/range {p0 .. p0}, Lcom/navipilot/obf/WideTelemetry;->init(Landroid/content/Context;)V'),
}


def patch(base, out, helper, flavor):
    if out.exists():
        raise FileExistsError(out)
    shutil.copytree(base, out, ignore=lambda d, names:
                    [n for n in names if Path(d) == base and n in ('build', 'dist')])
    sm = out / 'smali/com/navipilot/obf'
    for name, (before, addition) in HOOKS.items():
        file = sm / (name + '.smali')
        text = file.read_text()
        assert text.count(before) == 1, (name, before)
        file.write_text(text.replace(before, before + addition))
    for p in helper.glob('Wide*.smali'):
        assert p.name.startswith(('WideTelemetry', 'WideLinkDiagnostics')), p
        shutil.copy(p, sm / p.name)
    p = sm / 'WideDirect.smali'
    text = p.read_text()
    old = 'wide.10-' + flavor + '-dualfix'
    assert text.count(old) == 1
    p.write_text(text.replace(old, 'wide.11-' + flavor + '-diagnostic'))
    p = out / 'apktool.yml'
    text = p.read_text()
    assert 'versionCode: 26110722' in text and 'versionName: 9.3.1-' + old in text
    p.write_text(text.replace('versionCode: 26110722', 'versionCode: 26110723')
                .replace('versionName: 9.3.1-' + old,
                         'versionName: 9.3.1-wide.11-' + flavor + '-diagnostic'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('base', type=Path)
    parser.add_argument('out', type=Path)
    parser.add_argument('helper', type=Path)
    parser.add_argument('flavor', choices=['auto', 'probe'])
    args = parser.parse_args()
    patch(args.base, args.out, args.helper, args.flavor)
