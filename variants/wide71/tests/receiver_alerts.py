"""Replay emitted Link countdowns and synthetic Auto SDI through the C4 receiver."""
import argparse
import asyncio
import json
import sys
from pathlib import Path

from aiohttp import ClientSession
from aiohttp.test_utils import TestServer


async def verify(root, fixture):
    sys.path.insert(0, str(root))
    from openpilot.selfdrive.carrot.carrot_navi import CATALOG, CarrotNaviReceiver, create_app, now_ms
    from openpilot.selfdrive.carrot.carrot_navi_cereal import build_carrot_navi_payload
    from openpilot.selfdrive.carrot.carrot_navi_control import parse_carrot_navi_control

    receiver = CarrotNaviReceiver()
    async with TestServer(create_app(receiver), host="127.0.0.1") as server, ClientSession() as client:
        async with client.ws_connect(server.make_url("/api/navi/ws/v2/control/wide71-loopback")) as control:
            await control.send_json({
                "type": "requirements_query", "protocol_version": 2, "catalog_revision": 1,
                "streams": [{"kind": kind, "name": name, "schema_version": 1} for kind, name in CATALOG],
            })
            manifest = await control.receive_json(timeout=3)
            assert manifest["type"] == "subscription_manifest"
            session = manifest["session_id"]
            handles = {entry["name"]: entry["stream_handle"] for entry in manifest["streams"] if entry["kind"] == "json"}

            async def update(socket, name, sequence, value):
                stamp = now_ms()
                envelope = {
                    "type": "item_update", "protocol_version": 2, "session_id": session,
                    "manifest_revision": manifest["revision"], "kind": "json", "name": name,
                    "stream_handle": handles[name], "schema_version": 1, "sequence": sequence,
                    "source_timestamp_ms": stamp, "sent_at_ms": stamp, "present": value is not None, "value": value,
                }
                if value is None:
                    envelope["reason"] = "source_absent"
                await socket.send_json(envelope)
                for _ in range(100):
                    snapshot = receiver.cereal_snapshot()
                    if snapshot["items"].get(name, {}).get("sequence") == sequence:
                        parsed = parse_carrot_navi_control(build_carrot_navi_payload(snapshot))
                        assert parsed is not None
                        return parsed
                    await asyncio.sleep(0.01)
                raise AssertionError(f"Receiver did not store {name} sequence {sequence}")

            base = f"/api/navi/ws/v2/json/{session}"
            async with client.ws_connect(server.make_url(f"{base}/traffic_signal")) as traffic, \
                    client.ws_connect(server.make_url(f"{base}/speed")) as speed:
                phone = await update(traffic, "traffic_signal", 1, fixture["traffic_signal"])
                assert phone.traffic.source == "amap_link" and phone.traffic.lamp == "countdown"
                assert phone.traffic.remain_sec == fixture["traffic_signal"]["ui_counter"]["remain_sec"]
                assert phone.traffic.received_mono_time_ns > 0 and not phone.speed.sdi_present

                withdrawn = await update(traffic, "traffic_signal", 2, None)
                assert not withdrawn.traffic.present and not withdrawn.traffic.lamp
                for sequence, invalid in enumerate((True, "18", 0, -1, 1000), start=3):
                    malformed = {**fixture["traffic_signal"], "ui_counter": {"remain_sec": invalid}}
                    result = await update(traffic, "traffic_signal", sequence, malformed)
                    assert not result.traffic.lamp

                auto = await update(traffic, "traffic_signal", 8, {
                    "source": "amap_auto", "visible": True, "lights": {"red": {"on": True, "remain_sec": 17}},
                })
                assert (auto.traffic.lamp, auto.traffic.remain_sec) == ("red", 17)

                camera = await update(speed, "speed", 1, {
                    "road_limit_kph": 80, "sdi": {"type": 0, "distance_m": 346, "speed_limit_kph": 60},
                })
                assert camera.speed.sdi_present and camera.speed.sdi_type == 0
                assert (camera.speed.road_limit_kph, camera.speed.sdi_speed_limit_kph) == (80, 60)
                assert camera.speed.sdi_distance_m == 346 and camera.traffic.lamp == "red"

                no_camera = await update(speed, "speed", 2, {"road_limit_kph": 80})
                assert no_camera.speed.road_limit_kph == 80 and not no_camera.speed.sdi_present
    print("C4 Navi v2: countdown, withdrawal, five malformed values, Auto lamp, camera and road limit passed")


if __name__ == "__main__":
    args = argparse.ArgumentParser(description=__doc__)
    args.add_argument("c4_checkout", type=Path)
    args.add_argument("fixture", type=Path)
    parsed = args.parse_args()
    asyncio.run(verify(parsed.c4_checkout.resolve(), json.loads(parsed.fixture.read_text())))
