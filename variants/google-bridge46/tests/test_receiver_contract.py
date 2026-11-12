#!/usr/bin/env python3
"""Replay actual mapper output through pinned Carrot receiver and conversion code.

No C4 connection or device access. Supply the five unmodified source files named
in verification/receiver-sources.json; Git blob hashes are verified before import.
carrot_serv's two guidance methods are extracted unchanged with Python's AST so
the unrelated hardware, cereal daemon, and driving loop are never initialized.
"""
import argparse
import ast
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
from types import SimpleNamespace

HERE = Path(__file__).resolve().parent.parent


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    value = importlib.util.module_from_spec(spec)
    sys.modules[name] = value
    spec.loader.exec_module(value)
    return value


def service_methods(path):
    source = ast.parse(path.read_text())
    names = {"_update_tbt", "_apply_carrot_navi_guidance"}
    methods = [method for node in source.body if isinstance(node, ast.ClassDef)
               for method in node.body if isinstance(method, ast.FunctionDef) and method.name in names]
    if {method.name for method in methods} != names:
        raise AssertionError("Pinned carrot_serv guidance methods missing")
    subset = ast.Module(body=[ast.ImportFrom(module="__future__", names=[ast.alias(name="annotations")], level=0),
        ast.ClassDef(name="GuidanceService", bases=[], keywords=[], body=methods, decorator_list=[])], type_ignores=[])
    namespace = {}
    exec(compile(ast.fix_missing_locations(subset), str(path), "exec"), namespace)
    return namespace["GuidanceService"], ast.dump(ast.Module(body=methods, type_ignores=[]), include_attributes=False)


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--receiver-dir", type=Path, required=True)
    p.add_argument("--fixture", type=Path, required=True)
    p.add_argument("--historical-fixture", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    a = p.parse_args()
    provenance = json.loads((HERE / "verification/receiver-sources.json").read_text())
    for name, info in provenance["files"].items():
        raw = (a.receiver_dir / (name + ".py")).read_bytes()
        blob = hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()
        assert blob == info["gitBlobSha"], "Source differs from pinned GitHub blob: " + name
    receiver_module = module("pinned_receiver", a.receiver_dir / "user_navi.py")
    cereal = module("pinned_cereal", a.receiver_dir / "user_cereal.py")
    control = module("pinned_control", a.receiver_dir / "user_control.py")
    service, user_ast = service_methods(a.receiver_dir / "user_serv.py")
    _, upstream_ast = service_methods(a.receiver_dir / "up_serv.py")
    assert user_ast == upstream_ast, "Pinned upstream and user guidance calculations diverged"
    assertions = 1

    def check(condition, detail):
        nonlocal assertions
        assertions += 1
        if not condition:
            raise AssertionError(detail)

    def replay(fixture):
        receiver = receiver_module.CarrotNaviReceiver()
        manifest = receiver.negotiate({"type": "requirements_query", "protocol_version": 2,
            "catalog_revision": 1, "streams": [{"kind": kind, "name": name, "schema_version": 1}
                for kind, name in receiver_module.CATALOG]}, "host-contract-test")
        receiver.control_connected()
        session = manifest["session_id"]
        for name, value in fixture.items():
            stream = next(item for item in manifest["streams"] if item["kind"] == "json" and item["name"] == name)
            receiver.record_json(session, name, {"type": "item_update", "protocol_version": 2,
                "session_id": session, "kind": "json", "name": name, "sequence": 1,
                "manifest_revision": manifest["revision"], "stream_handle": stream["stream_handle"],
                "source_timestamp_ms": 1000, "sent_at_ms": 1000, "present": True, "value": value}, "host")
        snapshot = receiver.cereal_snapshot()
        payload = cereal.build_carrot_navi_payload(snapshot)
        parsed = control.parse_carrot_navi_control(payload)
        check(parsed is not None, "connected pinned receiver control exists")
        original_next = fixture["guidance_next"]["distance_m"]
        check(snapshot["items"]["guidance_next"]["value"]["distance_m"] == original_next,
              "wire receiver preserves next distance")
        check(payload["guidanceNext"]["distanceM"] == original_next, "cereal conversion preserves next")
        check(parsed.next.distance_m == original_next, "control parser preserves next")
        serv = service()
        serv.carrot_navi_current_sequence = serv.carrot_navi_next_sequence = -1
        serv.xDistToTurn = serv.xDistToTurnNext = 0
        serv._apply_carrot_navi_guidance(parsed, force=True)
        check(serv.nTBTDistNext == original_next, "service receives gap unchanged")
        return serv, parsed

    current = json.loads(a.fixture.read_text())
    historical = json.loads(a.historical_fixture.read_text())
    fixed, parsed = replay(current)
    check(fixed.xDistToTurn == 180, "current distance remains 180m")
    check(fixed.xDistToTurnNext == 440, "180m current + 260m gap = 440m next")
    old, _ = replay(historical)
    check(old.xDistToTurnNext == 620, "historical summed next reproduces the 620m double-add")
    unknown = json.loads(a.fixture.read_text())
    unknown["guidance_current"]["turn_type"] = -1
    unknown["guidance_next"]["turn_type"] = -1
    invalid, _ = replay(unknown)
    check(invalid.xTurnInfo == invalid.xTurnInfoNext == -1, "unknown is invalid, never an actionable turn")
    check(invalid.navType == invalid.navTypeNext == "invalid", "unknown receiver navigation type")
    report = {"result": "PASS", "assertions": assertions,
        "currentDistanceM": fixed.xDistToTurn, "nextGapM": parsed.next.distance_m,
        "receiverNextDistanceM": fixed.xDistToTurnNext, "historicalReceiverNextDistanceM": old.xDistToTurnNext,
        "userAndUpstreamGuidanceMethodsIdentical": True, "deviceTest": False,
        "fixtureSha256": hashlib.sha256(a.fixture.read_bytes()).hexdigest(),
        "sourceProvenance": "receiver-sources.json"}
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
