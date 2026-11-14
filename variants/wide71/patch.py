"""Add the phone Link countdown and alert diagnostics to the wide.70 primary DEX."""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))
from wide70.patch import method, replace

VERSION = "wide.71"
OBF = "Lcom/navipilot/obf/"
INTEGRATION = OBF + "WideAmapLinkIntegration;"
SIGNAL = OBF + "WideAmapLinkSignal;"
LOGGER = OBF + "WideAmapAlertLog;"
SIGNAL_FIELD = f"{INTEGRATION}->signal:{SIGNAL}"
SEND = f"{OBF}MG;->b(Ljava/lang/String;Lorg/json/JSONObject;Ljava/lang/String;)V"


def patch_integration(data):
    data = replace(data, f".field private final navigation:{OBF}WideAmapLinkNavigation;\n",
                   f".field private final navigation:{OBF}WideAmapLinkNavigation;\n\n"
                   f".field private final signal:{SIGNAL}\n")
    data = method(data, ".method private constructor <init>(", lambda body: replace(
        body, "    .line 29\n", f"    new-instance v0, {SIGNAL}\n\n"
        f"    invoke-direct {{v0}}, {SIGNAL}-><init>()V\n\n"
        f"    iput-object v0, p0, {SIGNAL_FIELD}\n\n    .line 29\n"))

    # The per-instance epoch check in onData has already admitted this callback.
    data = method(data, ".method public onData(", lambda body: replace(
        body, "    .line 244\n", "    move-object/from16 v5, p4\n\n"
        f"    iget-object v3, v0, {SIGNAL_FIELD}\n\n"
        f"    invoke-virtual/range {{v3 .. v9}}, {SIGNAL}->accept(ILorg/json/JSONObject;JJ)Z\n\n"
        "    move-result v1\n\n    if-eqz v1, :link_navigation\n\n"
        f"    invoke-direct {{v0}}, {INTEGRATION}->publishTraffic()V\n\n"
        "    return-void\n\n    :link_navigation\n    .line 244\n"))
    data = method(data, ".method public onInvalidated(", lambda body: replace(
        body, "    .line 224\n", f"    iget-object p3, p0, {SIGNAL_FIELD}\n\n"
        f"    invoke-virtual {{p3}}, {SIGNAL}->reset()V\n\n    .line 224\n"))
    data = method(data, ".method private dispose()", lambda body: replace(
        body, "    .line 186\n", f"    iget-object v0, p0, {SIGNAL_FIELD}\n\n"
        f"    invoke-virtual {{v0}}, {SIGNAL}->reset()V\n\n    .line 186\n"))

    data = method(data, ".method public static filter(", lambda body: replace(
        body, "    :cond_22\n", '    :cond_22\n    const-string v0, "traffic_signal"\n\n'
        "    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n\n"
        "    move-result v0\n\n    if-eqz v0, :link_navigation_stream\n\n"
        f"    iget-object v0, v2, {SIGNAL_FIELD}\n\n"
        "    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J\n\n"
        "    move-result-wide v3\n\n"
        f"    invoke-virtual {{v0, p3, v3, v4}}, {SIGNAL}->filter(Ljava/util/Map;J)Lorg/json/JSONObject;\n\n"
        "    move-result-object v0\n\n    return-object v0\n\n    :link_navigation_stream\n"))
    data = method(data, ".method private publish()", lambda body: replace(
        body, '    const-string v2, "route"\n', '    const-string v2, "traffic_signal"\n\n'
        f"    invoke-virtual {{v0, v2, v3, v1}}, {SEND}\n\n"
        '    const-string v2, "route"\n'))
    return data + f"""
.method private publishTraffic()V
    .locals 4

    sget-object v0, {INTEGRATION}->bridge:Ljava/lang/ref/WeakReference;
    invoke-virtual {{v0}}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, {OBF}MG;
    if-eqz v0, :done

    monitor-enter v0
    :try_start
    invoke-direct {{p0}}, {INTEGRATION}->active()Z
    move-result v1
    if-eqz v1, :unlock
    iget-boolean v1, v0, {OBF}MG;->j:Z
    if-eqz v1, :unlock

    const-string v1, "traffic_signal"
    const/4 v2, 0x0
    const-string v3, "link_signal_absent"
    invoke-virtual {{v0, v1, v2, v3}}, {SEND}

    :unlock
    monitor-exit v0
    :try_end
    .catchall {{:try_start .. :try_end}} :error
    :done
    return-void

    :error
    move-exception v1
    monitor-exit v0
    throw v1
.end method
"""


def apply(primary):
    integration = primary / "WideAmapLinkIntegration.smali"
    integration.write_text(patch_integration(integration.read_text()), encoding="utf-8")

    stopped = primary / "WideAmapLinkIntegration$6.smali"
    stopped.write_text(replace(stopped.read_text(), '    const-string v1, "navigation_status"\n',
                               '    const-string v1, "traffic_signal"\n\n'
                               f"    invoke-virtual {{v0, v1, v3, v2}}, {SEND}\n\n"
                               '    const-string v1, "navigation_status"\n'), encoding="utf-8")

    auto = primary / "WideAmapSource.smali"
    dispatch = f"    invoke-static {{p0, p1, p2}}, {OBF}h4;->a({OBF}h4;Landroid/content/Intent;I)V\n"
    auto.write_text(replace(auto.read_text(), dispatch,
                            f"    invoke-static {{p1, p2}}, {LOGGER}->autoInput(Landroid/content/Intent;I)V\n\n"
                            + dispatch), encoding="utf-8")

    bridge = primary / "WideBridge.smali"
    bridge.write_text(method(bridge.read_text(), ".method public static queued(", lambda body: replace(
        body, "    .locals 8\n", f"    .locals 8\n\n    invoke-static {{p0, p1, p2}}, {LOGGER}"
        "->queued(Ljava/lang/String;Ljava/lang/String;Z)V\n")), encoding="utf-8")

    for path in primary.glob("*.smali"):
        data = path.read_text(encoding="utf-8")
        if "wide.70" in data:
            path.write_text(data.replace("wide.70", VERSION), encoding="utf-8")
