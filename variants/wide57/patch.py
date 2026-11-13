"""Apply the Google search-return and OpenAI settings overlay to wide56."""
import json
import re
import sys
from pathlib import Path


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError(f"Expected exactly one occurrence of {old!r}")
    return text.replace(old, new, 1)


def change_method(text, signature, edit):
    pattern = re.compile(r"(?ms)^\.method [^\n]* " + re.escape(signature) + r"\n.*?^\.end method")
    matches = list(pattern.finditer(text))
    if len(matches) != 1:
        raise ValueError(f"Expected one method: {signature}")
    match = matches[0]
    return text[:match.start()] + edit(match.group()) + text[match.end():]


def patch_guidance(path):
    text = path.read_text()
    finish = "    invoke-virtual {p0}, Lcom/navdashn/GuidanceActivity;->finish()V\n"
    open_search = "    invoke-static {p0}, Lcom/navdashn/GuidanceReturn;->openSearch(Landroid/app/Activity;)V\n"
    for signature, replacement in (
        ("onStart$lambda$0(Lcom/navdashn/GuidanceActivity;Landroid/view/View;)V", open_search),
        ("onStart$lambda$3(Lcom/navdashn/GuidanceActivity;Landroid/view/View;)V", ""),
    ):
        text = change_method(text, signature, lambda method: replace_once(method, finish, replacement))
    text = change_method(text, "onResume()V", lambda _: """.method protected onResume()V
    .locals 0
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onResume()V
    invoke-static {p0}, Lcom/navdashn/GuidanceReturn;->resume(Landroid/app/Activity;)V
    return-void
.end method""")
    if re.search(r"(?m)^\.method .* onPause\(\)V", text):
        raise ValueError("Expected no existing onPause override")
    text += """
.method protected onPause()V
    .locals 0
    invoke-static {p0}, Lcom/navdashn/GuidanceReturn;->pause(Landroid/app/Activity;)V
    invoke-super {p0}, Landroidx/appcompat/app/AppCompatActivity;->onPause()V
    return-void
.end method
"""
    path.write_text(text)


def patch_controller(path):
    def add_notification(method):
        old = "    :cond_1\n    return-void"
        new = """    :cond_1
    invoke-static {p1}, Lcom/navdashn/GuidanceReturn;->onNavigationStateChanged(Lcom/navdashn/navigation/NavState;)V
    return-void"""
        return replace_once(method, old, new)

    path.write_text(change_method(path.read_text(), "setState(Lcom/navdashn/navigation/NavState;)V", add_notification))


def patch_labels(directory):
    # Keep persisted provider/credential values and the command dispatcher.
    replacements = {
        "MD": {"AI": "ChatGPT"},
        "m3": {
            "首次使用：填入 DeepSeek API Key": "首次使用：填入服務商的 API Key",
            "DeepSeek 接入": "ChatGPT／AI 串接",
            "），會隨請求發往 api.deepseek.com。": "），請求會送到目前設定的 API 位址。",
            "① 點這裡開啟 platform.deepseek.com → API keys 建立  →  ② 把 sk-… 粘到下面":
                "OpenAI 設定：建立 API Key，展開高階設定，填入模型和 https://api.openai.com/v1。",
            "deepseek-chat": "gpt-4o-mini",
            "https://api.deepseek.com": "https://api.openai.com/v1",
        },
        "D2": {"https://platform.deepseek.com/api_keys": "https://platform.openai.com/api-keys"},
        "F2": {"輸入 DeepSeek API Key": "輸入服務商的 API Key"},
        "G2": {"模型名（如 deepseek-chat）": "模型名稱（如 gpt-4o-mini）"},
        "Lk": {
            "DeepSeek 服務暫時不可用": "AI 服務暫時不可用",
            "賬戶餘額不足，去 platform.deepseek.com 充值": "請檢查目前 API 服務的帳務與用量",
        },
    }
    literal = re.compile(r'(?m)(^\s*const-string(?:/jumbo)? \w+, )("(?:\\.|[^"\\])*")$')
    for name, mapping in replacements.items():
        path = directory / (name + ".smali")
        changed = []

        def apply(match):
            try:
                value = json.loads(match[2])
            except json.JSONDecodeError:
                return match[0]
            if value not in mapping:
                return match[0]
            changed.append(value)
            return match[1] + json.dumps(mapping[value])

        result = literal.sub(apply, path.read_text())
        if sorted(changed) != sorted(mapping):
            raise ValueError(f"Unexpected label matches in {name}: {changed}")
        path.write_text(result)



def patch_openai_request(path):
    text = path.read_text()
    start = '    new-instance v1, Ljava/lang/Double;\n'
    end = '    sget-object v1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;'
    if text.count(start) != 1 or text.count(end) != 1:
        raise ValueError("Unexpected Chat Completions request builder")
    a, b = text.index(start), text.index(end)
    original = text[a:b]
    new = """    invoke-virtual {v3}, Lcom/navipilot/obf/o3;->b()Ljava/lang/String;
    move-result-object v1
    const-string v4, "https://api.openai.com/v1"
    invoke-virtual {v4, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :wide57_existing_provider

    new-instance v1, Ljava/lang/Integer;
    const/16 v4, 0x1000
    invoke-direct {v1, v4}, Ljava/lang/Integer;-><init>(I)V
    const-string v4, "max_completion_tokens"
    invoke-virtual {v2, v4, v1}, Lcom/navipilot/obf/nw;->l(Ljava/lang/String;Ljava/lang/Number;)V
    goto :wide57_request_options_done

    :wide57_existing_provider
""" + original + "    :wide57_request_options_done\n"
    path.write_text(text[:a] + new + text[b:])


def patch(root):
    google = root / "smali_classes5/com/navdashn"
    patch_guidance(google / "GuidanceActivity.smali")
    patch_controller(google / "navigation/NavController.smali")
    obfuscated = root / "smali/com/navipilot/obf"
    patch_labels(obfuscated)
    patch_openai_request(obfuscated / "Ik.smali")
    metadata = root / "apktool.yml"
    text = metadata.read_text()
    text, count = re.subn(r"(?m)^  versionCode: .*", "  versionCode: 26110769", text)
    if count != 1:
        raise ValueError("Missing version code")
    text, count = re.subn(r"(?m)^  versionName: .*", "  versionName: 9.3.1-wide.57-nav-fixes", text)
    if count != 1:
        raise ValueError("Missing version name")
    metadata.write_text(text)


if __name__ == "__main__":
    patch(Path(sys.argv[1]))
