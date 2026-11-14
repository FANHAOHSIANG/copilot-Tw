"""Keep the embedded Google NOO search activity visible after ending guidance."""

import argparse
from pathlib import Path
import re
import xml.etree.ElementTree as ET

SIGNATURE = '.method private final exitApp()V'
BODY = """    .locals 1

    invoke-direct {p0}, Lcom/navdashn/MainActivity;->cancelDestinationRequest()V

    sget-object v0, Lcom/navdashn/navigation/NavController;->INSTANCE:Lcom/navdashn/navigation/NavController;
    invoke-virtual {v0}, Lcom/navdashn/navigation/NavController;->stopNavigation()V

    invoke-direct {p0}, Lcom/navdashn/MainActivity;->updateStatus()V
    return-void
"""


def apply(decoded):
    activity = decoded / 'smali_classes5/com/navdashn/MainActivity.smali'
    source = activity.read_text(encoding='utf-8')
    pattern = re.compile(r'^' + re.escape(SIGNATURE) + r'\n(.*?)^\.end method$', re.M | re.S)
    matches = list(pattern.finditer(source))
    if len(matches) != 1 or '->finishAndRemoveTask()V' not in matches[0][1]:
        raise ValueError('Expected the original wide.68 Google NOO exit method')
    for signature in ('cancelDestinationRequest()V', 'updateStatus()V'):
        if f'.method private final {signature}' not in source:
            raise ValueError(f'Missing activity method: {signature}')

    strings = decoded / 'res/values/strings.xml'
    resources = strings.read_text(encoding='utf-8')
    old_message = '導航中，要結束導航並關閉 Google 導航 NOO嗎？'
    message = ET.fromstring(resources).find("./string[@name='exit_confirm']")
    if message is None or message.text != old_message or resources.count(old_message) != 1:
        raise ValueError('Expected the original wide.68 Google NOO exit confirmation')

    start, end = matches[0].span(1)
    activity.write_text(source[:start] + BODY + source[end:], encoding='utf-8')
    strings.write_text(resources.replace(old_message, '要結束目前導航並回到搜尋頁嗎？'), encoding='utf-8')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('decoded', type=Path, help='Directory from an apktool decode of wide.68')
    apply(parser.parse_args().decoded)
