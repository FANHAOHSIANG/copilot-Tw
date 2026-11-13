"""Pinned C4 WebSocket receiver on localhost with synthetic Link-derived guidance.

This runs the actual receiver, converter and navigation consumer methods. The
sender is a Python fixture client, NOT the Android APK. No vehicle is contacted.
"""
import ast
import asyncio
import contextlib
import hashlib
import importlib.util
import io
import json
import sys
import time
from pathlib import Path
from aiohttp import ClientSession
from aiohttp.test_utils import TestServer

c4, fixture_path = map(Path, sys.argv[1:3])
pinned = json.loads((Path(__file__).parents[1] / 'verification/c4-source.json').read_text())
for filename, expected in pinned['sourceFiles'].items():
    assert hashlib.sha256((c4 / filename).read_bytes()).hexdigest() == expected, filename


def module(name, filename):
    spec = importlib.util.spec_from_file_location(name, c4 / filename)
    m = importlib.util.module_from_spec(spec)
    sys.modules[name] = m
    spec.loader.exec_module(m)
    return m


receiver = module('test_receiver', 'carrot_navi.py')
cereal = module('test_cereal', 'carrot_navi_cereal.py')
control = module('test_control', 'carrot_navi_control.py')
tree = ast.parse((c4 / 'carrot_serv.py').read_text())
methods = [n for n in ast.walk(tree) if isinstance(n, ast.FunctionDef)
           and n.name in ['_update_tbt', '_apply_carrot_navi_guidance']]
assert len(methods) == 2
space = {'CarrotNaviControl': control.CarrotNaviControl}
exec(compile(ast.Module(body=methods, type_ignores=[]), '<pinned consumer>', 'exec'), space)


class State:
    _update_tbt = space['_update_tbt']
    apply = space['_apply_carrot_navi_guidance']


async def main():
    model = receiver.CarrotNaviReceiver()
    rows = []
    async with TestServer(receiver.create_app(model), host='127.0.0.1') as server, ClientSession() as client:
        ctrl = await client.ws_connect(server.make_url('/api/navi/ws/v2/control/wide55-loopback'))
        query = dict(type='requirements_query', protocol_version=2, catalog_revision=1,
                     streams=[dict(kind=k, name=n, schema_version=1) for k, n in receiver.CATALOG])
        await ctrl.send_json(query)
        manifest = await ctrl.receive_json(timeout=3)
        session = manifest['session_id']
        streams = {s['name']: s for s in manifest['streams'] if s['kind'] == 'json'}
        sockets = {n: await client.ws_connect(server.make_url(f'/api/navi/ws/v2/json/{session}/{n}'))
                   for n in ['guidance_current', 'navigation_status']}
        expected_turn = {3: 2, 2: 1, 8: 7, 9: 0, 999: -1, 100: -1}
        envelope = None
        for sequence, line in enumerate(fixture_path.read_text().splitlines(), 1):
            fixture = json.loads(line)
            for name, value in [('guidance_current', fixture['guidance']), ('navigation_status', fixture['status'])]:
                envelope = dict(type='item_update', protocol_version=2, session_id=session,
                                manifest_revision=manifest['revision'], kind='json', name=name,
                                stream_handle=streams[name]['stream_handle'], schema_version=1,
                                sequence=sequence, source_timestamp_ms=receiver.now_ms(),
                                sent_at_ms=receiver.now_ms(), present=value is not None, value=value)
                if value is None:
                    envelope['reason'] = 'source_absent'
                await sockets[name].send_json(envelope)
            for attempt in range(100):
                snap = model.cereal_snapshot()
                if all(snap['items'].get(n, {}).get('sequence') == sequence for n in sockets):
                    break
                await asyncio.sleep(0.01)
            else:
                raise AssertionError('Receiver did not ingest both streams')
            payload = cereal.build_carrot_navi_payload(snap, time.monotonic_ns())
            parsed = control.parse_carrot_navi_control(payload)
            assert parsed is not None
            state = State()
            state.carrot_navi_current_sequence = state.carrot_navi_next_sequence = -1
            state.xDistToTurn = state.xDistToTurnNext = 0
            state.apply(parsed, force=True)
            assert state.xTurnInfo == expected_turn[fixture['icon']]
            if fixture['icon'] in (3, 2, 8):
                assert state.xDistToTurn == fixture['guidance']['distance_m']
            assert not parsed.route.present and not parsed.speed.present
            rows.append(dict(icon=fixture['icon'], received=True, carrotTurn=state.xTurnInfo,
                             distance=state.xDistToTurn, guidancePresent=parsed.current.present))
        # A duplicate sequence must be rejected, never revive a stale cue.
        await sockets['navigation_status'].send_json(envelope)
        error = await sockets['navigation_status'].receive_json(timeout=3)
        assert error['type'] == 'protocol_error' and 'sequence' in error['message']
        await asyncio.gather(*(s.close() for s in sockets.values()))
        await ctrl.close()
    return dict(result='passed', c4Commit=pinned['commit'], cases=rows,
                duplicateSequenceRejected=True, physicalDeviceValidated=False,
                androidSenderValidated=False,
                boundary='Actual pinned receiver over localhost WebSockets; synthetic sender and data; no vehicle control')


with contextlib.redirect_stdout(io.StringIO()):
    report = asyncio.run(main())
print(json.dumps(report, indent=2))
