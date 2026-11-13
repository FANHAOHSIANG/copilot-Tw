"""Wire foreground GPS to the existing OSM matcher and settings list."""
from pathlib import Path
from xml.etree import ElementTree

PACKAGE = Path("com/navipilot/obf")
LOCATION = "Lcom/navipilot/obf/WideOsmLocation;"
ANDROID = "{http://schemas.android.com/apk/res/android}"


def replace_method(source, signature, old, new):
    start = source.index(signature)
    end = source.index(".end method", start)
    body = source[start:end]
    if body.count(old) != 1 or new in body:
        raise ValueError(f"Unexpected body: {signature}")
    return source[:start] + body.replace(old, new, 1) + source[end:]


def hooks(main):
    activity = main / "com/jixiexiaoge/drivingassist/MainActivity.smali"
    settings = main / PACKAGE / "WideSettings.smali"
    service = main / PACKAGE / "WideCameraService.smali"
    camera = main / PACKAGE / "WideCamera.smali"
    hcop = main / PACKAGE / "WideHcop.smali"
    on_resume = "    invoke-super {p0}, Landroid/app/Activity;->onResume()V\n"
    scroll = "    invoke-virtual {v0, v15}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V\n"
    fix_store = "    sput-object v4, Lcom/navipilot/obf/WideCamera;->fix:Lcom/navipilot/obf/WideCameraEngine$Fix;\n"
    init = "    invoke-static {p0}, Lcom/navipilot/obf/WideHcop;->init(Landroid/content/Context;)V\n"
    code = service.read_text()
    start = code.index("    iget-object p1, v7, Lcom/navipilot/obf/WideCameraService;->alerts:")
    end = code.index("    iget-object p1, v7, Lcom/navipilot/obf/WideCameraService;->manager:", start)
    code = code[:start] + init + code[end:]
    code = code.replace(r"\u81fa\u7063\u6e2c\u901f GPS \u5b9a\u4f4d", "OSM 道路速限定位")
    if ".method public static declared-synchronized init(Landroid/content/Context;)V" not in hcop.read_text():
        raise ValueError("Missing OSM matcher initializer")
    main_activity = replace_method(activity.read_text(), ".method public final onResume()", on_resume,
        on_resume + f"    invoke-static/range {{p0 .. p0}}, {LOCATION}->onResume(Landroid/app/Activity;)V\n")
    callback = "onRequestPermissionsResult(I[Ljava/lang/String;[I)V"
    if f".method public {callback}" in main_activity or f".method public final {callback}" in main_activity:
        raise ValueError("Activity already declares a permission callback")
    main_activity += (
        f"\n.method public {callback}\n"
        "    .locals 0\n"
        f"    invoke-super {{p0, p1, p2, p3}}, Lcom/navipilot/obf/Ug;->{callback}\n"
        f"    invoke-static {{p0, p1}}, {LOCATION}->onPermissionResult(Landroid/app/Activity;I)V\n"
        "    return-void\n"
        ".end method\n"
    )
    camera_source = camera.read_text()
    accept = ".method public static accept(Landroid/location/Location;)V"
    start = camera_source.index(accept)
    end = camera_source.index(".end method", start)
    method = camera_source[start:end]
    if method.count(fix_store) != 1:
        raise ValueError("Missing GPS fix storage")
    camera_source = camera_source[:start] + method[:method.index(fix_store)] + fix_store + (
        "    invoke-static {v4}, Lcom/navipilot/obf/WideHcop;->accept(Lcom/navipilot/obf/WideCameraEngine$Fix;)V\n"
        "    return-void\n"
    ) + camera_source[end:]
    return {
        activity: main_activity,
        settings: replace_method(settings.read_text(), ".method public static show(", scroll,
            f"    invoke-static {{v1, v15}}, {LOCATION}->addSetting(Landroid/app/Activity;Landroid/widget/LinearLayout;)V\n" + scroll),
        camera: camera_source,
        service: code,
    }


def add_service(manifest):
    tree = ElementTree.parse(manifest)
    app = tree.getroot().find("application")
    name = "com.navipilot.obf.WideCameraService"
    if any(s.get(ANDROID + "name") == name for s in app.findall("service")):
        raise ValueError("OSM location service already registered")
    ElementTree.SubElement(app, "service", {
        ANDROID + "name": name,
        ANDROID + "exported": "false",
        ANDROID + "foregroundServiceType": "location",
    })
    ElementTree.register_namespace("android", ANDROID[1:-1])
    tree.write(manifest, encoding="utf-8", xml_declaration=True)
