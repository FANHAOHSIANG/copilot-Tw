"""Apply the Google NOO layouts from source to an apktool-decoded wide.68."""

import argparse
from pathlib import Path
import xml.etree.ElementTree as ET


ANDROID = 'http://schemas.android.com/apk/res/android'
APP = 'http://schemas.android.com/apk/res-auto'
ID = f'{{{ANDROID}}}id'
VISIBILITY = f'{{{ANDROID}}}visibility'
SOURCE = Path(__file__).resolve().parents[1] / 'google-navdash/app/src/main/res'
FILES = (
    'layout/activity_main.xml',
    'layout/item_place.xml',
    'layout/guidance_controls.xml',
    'drawable/guidance_icon_bg.xml',
    'drawable/guidance_icon_bg_stop.xml',
)


def views(root):
    return {node.attrib[ID].split('/')[-1]: node for node in root.iter() if ID in node.attrib}


def apply(decoded):
    ET.register_namespace('android', ANDROID)
    ET.register_namespace('app', APP)

    pending = {}
    for name in FILES:
        path = decoded / 'res' / name
        old = ET.parse(path).getroot()
        design = ET.parse(SOURCE / name).getroot()
        old_views = views(old)
        new_views = views(design)
        if (old.tag != design.tag or old_views.keys() != new_views.keys()
                or any(old_views[key].tag != view.tag for key, view in new_views.items())):
            raise ValueError(f'Existing view bindings do not match the Google NOO design in {name}')

        for key, view in new_views.items():
            original = old_views[key]
            view.set(ID, original.attrib[ID])
            if VISIBILITY in original.attrib:
                view.set(VISIBILITY, original.attrib[VISIBILITY])
            else:
                view.attrib.pop(VISIBILITY, None)

        pending[path] = ET.tostring(design, encoding='utf-8', xml_declaration=True)

    for path, resource in pending.items():
        path.write_bytes(resource)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('decoded', type=Path, help='Directory from an apktool resource-only decode')
    apply(parser.parse_args().decoded)
