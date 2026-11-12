# AMap Link host checks

Run all checks with an existing JDK 11 or newer and an `org.json` JVM jar:

```sh
python3 variants/amap-link1/tests/run_checks.py \
  --jdk /path/to/jdk \
  --json-jar /path/to/json.jar \
  --report variants/amap-link1/verification/host-checks.json
```

`--jdk` can be omitted when both `java` and `javac` are on `PATH`. The equivalent
environment variables are `COPILOT_TEST_JDK` and `COPILOT_TEST_JSON_JAR`.
The runner downloads nothing, leaves class files only in a temporary directory,
and fails if a tested source changes during execution. Its optional JSON report
records assertion counts and hashes of the exact source and test files executed.

## Coverage

| Suite | Executed behavior |
| --- | --- |
| `CodecChecks` | Actual business wrappers; nested JSON/URI data; independently generated AES-GCM packets and tampering; bounded/out-of-order/duplicate chunk assembly; transfer expiry; size and UTF-8 bounds; begin-receipt provenance across delayed completion. |
| `PolicyChecks` | Finite automatic retries; bounded delays; authentication refusal cannot restart automatically; explicit retry; generation, stop and close barriers. |
| `NavigationChecks` | Confirmed maneuver mappings; unsupported/slight/roundabout icons; missing/malformed fields; segment distance versus destination distance; icon-only invalidation; stop/arrival; source generations; monotonic 3-second expiry; input and snapshot ownership. |
| `PipelineChecks` | Production decoder feeds production navigation model, including malformed type 4/5, null-data lifecycle items, same-batch type 7, wrong business channel and old-session replay. |
| `IntegrationChecks` | Production integration/filter/timers run against explicit host boundaries: cold service restoration, old Auto field withdrawal, timestamp removal, exact expiry without UI access, delayed receipt, publication identity, monotonic invalidation, source changes and foreground-service stop/restart. |

The integration doubles replace only Android framework scheduling, the source
gate's call boundary, Binder transport and MG/WebSocket. They are located under
`integration-stubs/` and are compiled into a separate temporary class directory;
they are never APK sources. The production `WideAmapLinkIntegration` and
`WideAmapLinkNavigation` files are compiled and executed unchanged.

The Auto and Google branches of the source gate are decoded smali. Preservation
of those branches and the final accepted `XG.r` publication hook is checked by
the APK patch/build verification, not by the host doubles. The phone filter
withdraws unobserved speed and route fields and removes their timestamps before
the existing Taiwan speed merge. That existing merge can still supply its own
independently obtained Taiwan data; these tests do not relabel it as phone data.

## Fixture and mapping provenance

All test distances, roads, encryption bytes and clock values are synthetic.
No test contains a user's route, credential, private key or phone capture.
The independently written fixtures use protocol field shapes and lifecycle
observations documented by:

- [AMap Android Link API](https://developer.amap.com/api/aiot-sdk/guide/strong-ties/amaplinkclient-api).
- [AMap data-type description](https://developer.amap.com/api/aiot-sdk/faq-old).
- [HyperCar navigation observations at commit e7d6e3acb1a60e0af28edabe80d522ebe0825ede](https://github.com/fw867/hypercar/blob/e7d6e3acb1a60e0af28edabe80d522ebe0825ede/docs/NAVIGATION.md), used as protocol observations, with no implementation copied or vendored.
- [Carrot navigation API at commit ffa5723eda259de6c3ef3962f687c5c8579c23ee](https://github.com/ajouatom/openpilot/blob/ffa5723eda259de6c3ef3962f687c5c8579c23ee/openpilot/selfdrive/carrot/carrot_navi_api.md) and [its actual `_update_tbt` consumer](https://github.com/ajouatom/openpilot/blob/ffa5723eda259de6c3ef3962f687c5c8579c23ee/openpilot/selfdrive/carrot/carrot_serv.py).

The 3-second expiry is this CoPilot integration's conservative local policy.
It is not claimed to be an AMap requirement, a calibrated vehicle-control
threshold, or evidence of safe automated vehicle behavior.

## What a passing result does not establish

A host pass does not prove that the installed phone version grants Link access,
that a particular Android device delivers the Binder/FD callbacks, that its
background-process policy permits operation, or that C4 receives or acts on an
instruction. Real service authorization, descriptor lifecycle, phone-version
compatibility and C4 receipt still require device verification. The tests do not
manufacture speed limits, cameras, route geometry or successful authentication.
