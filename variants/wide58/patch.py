"""UI changes for the exact wide57 integrated build."""
import json
import re
import sys
from pathlib import Path


def once(text, before, after):
    if text.count(before) != 1:
        raise ValueError(f"Expected one occurrence of {before!r}")
    return text.replace(before, after, 1)


def block(text, first, end, replacement):
    start = text.index(first)
    stop = text.index(end, start)
    return text[:start] + replacement + text[stop:]


def edit(path, transform):
    path.write_text(transform(path.read_text()))


def labels(path, mapping):
    counts = {key: 0 for key in mapping}
    pattern = re.compile(r'(?m)(^\s*const-string(?:/jumbo)? \w+, )("(?:\\.|[^"\\])*")$')

    def replace(match):
        try:
            old = json.loads(match[2])
        except json.JSONDecodeError:
            return match[0]
        if old not in mapping:
            return match[0]
        counts[old] += 1
        return match[1] + json.dumps(mapping[old])

    edit(path, lambda text: pattern.sub(replace, text))
    if any(count == 0 for count in counts.values()):
        raise ValueError(f"Missing labels in {path.name}: {counts}")


def projection(text):
    text = block(text, "    .line 200\n    iget-boolean", "    .line 201\n    :cond_4", "")
    text = block(text, "    .line 248\n    invoke-virtual {v0}", "    .line 249\n    invoke-virtual {v0}", "")
    return block(text, '    const/16 p1, 0xf\n\n    if-ne v1, p1, :cond_8\n',
                 '    .line 264\n    :cond_8', "")


def destination(text):
    first = '    invoke-virtual {v13}, Lcom/navipilot/obf/Ad;->X1()Ljava/lang/String;'
    tail = '    invoke-virtual/range {p2 .. p2}, Lcom/navipilot/obf/Hh;->s()V\n\n    move/from16 v45, v14'
    # Maintain weight, height and spacing, with no button, icon or click semantics.
    spacer = """    move-object/from16 v13, v66

    invoke-static {v13, v4}, Lcom/navipilot/obf/TQ;->b(Lcom/navipilot/obf/TQ;F)Lcom/navipilot/obf/VE;
    move-result-object v1
    invoke-static {v1}, Landroidx/compose/foundation/layout/c;->b(Lcom/navipilot/obf/VE;)Lcom/navipilot/obf/VE;
    move-result-object v1
    const/4 v2, 0x0
    const/4 v12, 0x2
    invoke-static {v1, v11, v2, v12}, Landroidx/compose/foundation/layout/c;->g(Lcom/navipilot/obf/VE;FFI)Lcom/navipilot/obf/VE;
    move-result-object v1
    const/4 v2, 0x0
    invoke-static {v1, v15, v2}, Lcom/navipilot/obf/ub;->a(Lcom/navipilot/obf/VE;Lcom/navipilot/obf/Hh;I)V
    move/from16 v44, v53
    move-object v0, v13

"""
    start = text.index('    const v1, 0x1a75c757')
    return text[:start] + block(text[start:], first, tail, spacer)


def diagnostics(text):
    anchor = "    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;"
    # Add to the same toolbar in both the docked and dialog presentations.
    after_tool = ('    invoke-static {v1, v3, v4, v2}, Lcom/navipilot/obf/WideUi;->tool'
                  '(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;')
    addition = """
    new-instance v2, Lcom/navipilot/obf/WideDiagnosticActions;
    invoke-direct {v2}, Lcom/navipilot/obf/WideDiagnosticActions;-><init>()V
    const-string v3, "\\u5831\\u544a"
    invoke-static {v1, v3, v4, v2}, Lcom/navipilot/obf/WideUi;->tool(Landroid/widget/LinearLayout;Ljava/lang/String;ILandroid/view/View$OnClickListener;)Landroid/widget/Button;
"""
    return once(text, after_tool + "\n\n" + anchor, after_tool + "\n" + addition + "\n" + anchor)


def extend_zip(text):
    line = '    new-instance v2, Lcom/navipilot/obf/WideBridgeLog$3;'
    return once(text, line, """    invoke-static {}, Lcom/navipilot/obf/WideDiagnosticActions;->report()Ljava/lang/String;
    move-result-object v2
    const-string v1, "\\n\\n"
    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v0, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0

""" + line)


def patch_resources(root):
    styles = root / 'res/values/styles.xml'
    def clean(text):
        for old, new in (
            ('name="android:windowBackground">@drawable/bridge_splash', 'name="android:windowBackground">#ff0b1018'),
            ('name="android:windowSplashScreenAnimatedIcon">@drawable/bridge_mark', 'name="android:windowSplashScreenAnimatedIcon">@android:color/transparent'),
        ):
            if text.count(old) != 3:
                raise ValueError(f"Unexpected splash style count: {old}")
            text = text.replace(old, new)
        return text
    edit(styles, clean)
    edit(root / 'res/layout/activity_main.xml', lambda text: once(text,
         ' android:hint="搜尋地點，連結下一段旅程" android:maxLines="1"', ' android:singleLine="true"'))
    edit(root / 'res/values/strings.xml', lambda text: re.sub(
        r'(<string name="search_hint">)[^<]+(</string>)',
        r'\g<1>搜尋地址或地點\2', text).replace('CP Google 導航', 'Google 導航 NOO'))


def main(root):
    smali = root / 'smali/com'
    app = smali / 'navipilot/obf'
    edit(app / 'WideDirect$Pane.smali', projection)
    edit(app / 'MD.smali', lambda text: once(destination(text),
        '    invoke-static {p2}, Lcom/navipilot/obf/WidePlaces;->showContext(Landroid/content/Context;)V\n', ''))
    def single_hint(text):
        line = '    invoke-virtual {v0, v1}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V'
        start = text.rindex('    const-string v1, ', 0, text.index(line))
        return text[:start] + text[text.index(line) + len(line) + 2:]
    edit(app / 'WideGoogleUi.smali', single_hint)
    edit(app / 'WideDiagnostics.smali', diagnostics)
    edit(app / 'WideBridgeLog.smali', extend_zip)
    for name, mapping in {
        'WideVariant$Navigation': {
            'Google 地圖': 'Google地圖（僅投屏）',
            'CP Google 導航': 'Google 導航 NOO',
            'Google SDK': 'Google 導航 NOO',
        },
        'WideDirect$Pane': {'右上投屏': '投屏', '右下：即時診斷／九宮格': '即時診斷／操作面板'},
        'WidePanels': {'右下畫面': '切換面板', '九宮格快捷鍵': '操作面板', '即時引數與連線診斷': '即時診斷'},
        'WideDiagnostics': {'comma 診斷': '即時診斷'},
        'WideDirect': {'右上投屏：': '投屏：'},
        'WideGoogleNav': {
            '尚未選擇 CP Google 導航': '尚未選擇 Google 導航 NOO',
            '等待 CP Google 導航資料': '等待 Google 導航 NOO 資料',
            '未選擇 CP Google 導航': '未選擇 Google 導航 NOO',
            '\n來源：CP Google 導航 SDK（本機）\n': '\n來源：Google 導航 NOO（本機 SDK）\n',
        },
    }.items():
        labels(app / (name + '.smali'), mapping)
    def launch(text):
        for lifecycle, action in [('onResume', 'show'), ('onDestroy', 'dismiss')]:
            call = f'    invoke-super {{p0}}, Landroid/app/Activity;->{lifecycle}()V'
            text = once(text, call, call + f'\n    invoke-static {{p0}}, Lcom/navipilot/obf/WideFirstRun;->{action}(Landroid/app/Activity;)V')
        return text
    edit(smali / 'jixiexiaoge/drivingassist/MainActivity.smali', launch)
    edit(app / 'Yg.smali', lambda text: re.sub(
        r'9\.3\.1-wide\.\d+[-a-z0-9.]* \(261107\d{2}\)',
        '9.3.1-wide.58-ui (26110770)', text))
    google = root / 'smali_classes5/com/navdashn'
    google_main = google / 'MainActivity.smali'
    search_hook = '    const-string v0, "Places autocomplete rejected: status="'
    def search_diagnostics(text):
        start = text.index('.method private static final performAutocomplete$lambda$37(')
        end = text.index('.end method', start)
        failed = once(text[start:end], search_hook,
            '    invoke-static {p0}, Lcom/navipilot/obf/WideDiagnosticActions;->searchFailed(I)V\n\n' + search_hook)
        text = text[:start] + failed + text[end:]
        first = '.method private final showSearchResults(Ljava/util/List;)V'
        start = text.index(first)
        code_start = text.index('    .line ', start)
        return text[:code_start] + '    invoke-static {}, Lcom/navipilot/obf/WideDiagnosticActions;->searchSucceeded()V\n\n' + text[code_start:]
    edit(google_main, search_diagnostics)
    edit(google / 'KeyEntryActivity.smali', lambda text: text.replace(
        r'CP Google \u5c0e\u822a', r'Google \u5c0e\u822a NOO'))
    patch_resources(root)
    edit(root / 'apktool.yml', lambda text: re.sub(
        r'(?m)^  versionName: .*', '  versionName: 9.3.1-wide.58-ui',
        re.sub(r'(?m)^  versionCode: .*', '  versionCode: 26110770', text)))


if __name__ == '__main__':
    main(Path(sys.argv[1]))
