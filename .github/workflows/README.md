# CoPilot workflows

## Pull request and main-branch checks

`clojure.yml` now runs **CoPilot host checks** on pushes to `main` and pull requests targeting `main`. The filename and job ID `build` are retained so an existing required-job configuration can keep using `build`; the unrelated Clojure/Leiningen template is gone. The workflow grants only `contents: read`, checks out without persisted Git credentials, and does not publish packages or APKs.

The job uses JDK 21, Python 3.12 and Ubuntu 24.04. `fonts-noto-cjk` supplies the Traditional Chinese font used by the UI geometry tests; the runner rejects AWT's silent fallback to another font. Python runners use the standard library, with no `pip` dependencies.

| Suite | Current assertions | What is exercised |
| --- | ---: | --- |
| Enforcement core | 67 | Production decision engine, same-road/direction/grade rules, freshness, speech ownership and the checked-in 2,148-record catalog |
| Enforcement lifecycle | 46 | Production runtime and voice code, with deterministic clock/Handler/TTS/audio-focus boundaries |
| Dashboard UI | 316 | Production painter and engine, semantic checks and strict text geometry, plus labelled host previews |
| Google mapper | 38 | Current `google-bridge46` adapter: expiry, sessions, route versions, stop/simulation handling and maneuver mapping |
| **Total** | **467** | **Host assertions; no device or road-test claim** |

The shared entry point, `.github/scripts/run_host_checks.py`, downloads `org.json:json:20240303` directly from its fixed [Maven Central artifact URL](https://repo.maven.apache.org/maven2/org/json/json/20240303/json-20240303.jar). It checks SHA-256 `3cf6cd6892e32e2b4c1c39e0f52f5248a2f5b37646fdfbb79a66b46b618414ed` before invoking Java. A missing dependency, checksum mismatch, failing suite, missing expected success output or reduced assertion count fails the job. All four independent suites run after setup, so one failing suite does not conceal another suite's results.

Each run saves logs, a JSON summary, source hashes from the lifecycle/UI/mapper runners and labelled UI previews as an Actions artifact. Generated files go under `RUNNER_TEMP`, not the source tree. No existing `/tmp` JAR, old checkout, private base APK, Android SDK, Google API key or attached device is needed. Full OSM replay, APK patch/signature inspection, Android scheduling/audio and real navigation/vehicle tests remain separate validation activities.

### Run the same checks locally

Install a full JDK 21 and Python 3, make `java` and `javac` available on `PATH`, and install Noto Sans CJK TC (on Debian/Ubuntu: `sudo apt-get install fonts-noto-cjk`). From the repository root:

```sh
python3 .github/scripts/run_host_checks.py --output-dir /path/to/new/copilot-host-results
```

The output directory must be new or empty. The runner downloads and verifies its own JSON JAR on every run. When Java is outside `PATH`, use `--java /path/to/jdk21/bin/java --javac /path/to/jdk21/bin/javac`. Individual test runners also accept these options plus an explicit `--json-jar`; the UI runner accepts `--output-dir` and `--strict-layout`.

## APK builds and release publication

- `google-companion-build.yml` builds and tests the actual standalone Android project in `variants/google-navdash`, then retains an **unsigned** APK for the controlled signing process.
- `release-wide46.yml` publishes the reviewed wide.46 release through its dedicated release process. Host checks do not assemble the patched CoPilot APK, sign it or publish it.
- The retained earlier `release-wide39.yml` through `release-wide42.yml` cover their corresponding historical releases.

The old `gradle-publish.yml` starter template has been removed. It attempted `./gradlew build` and `./gradlew publish` at the repository root, where no Gradle wrapper or package-publication project exists. The actual Google companion build and wide.46 release workflows replace that inapplicable template.
