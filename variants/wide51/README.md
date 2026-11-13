# wide.51 camera advisory candidate

This is a signed **test candidate**, not road-validated or a guarantee of complete camera coverage. Base: delivered wide.50; Google companion 0.1.2 remains separate and unchanged.

## Changes

- Treat camera `bb3c86d11fbe09e8` (公道路616號前) as direction-disputed for UI/audio only. Original NPA asset is unchanged. Its stored direction is east-to-west, while public secondary listings conflict; the county's 115.6.10 list confirms speed camera/50 km/h but does not specify direction. This is not a verified bidirectional camera correction.
- Missing/disputed bearings can produce qualified advisories after consecutive approaching fixes. Unconfirmed road gives a nearby advisory, without a numeric countdown. These do not write C4 speed/control packets.
- GPS fallback now requires a unique road attachment and unique forward connected chain before promoting a known-direction candidate to the large camera panel. Clearly different roads are rejected. Missing/ambiguous/expired graph evidence gives only an explicitly qualified nearby advisory. This can reduce large countdown coverage relative to wide.50.
- Fixed-camera voice observation moves from the visible border draw callback to a 500 ms clock in the existing location foreground service. Qualified advisories use installed offline Chinese TTS, honor the existing camera voice toggle, deduplicate completed speech, retry errors after five seconds, and stop on lost target. Actual playback depends on device TTS/media routing and foreground-service survival.
- Google turn card retains a camera/GPS status row. Confirmed near-camera priority is preserved. Active enforcement secondary strips take precedence over the extra status row when space is limited; narrow legacy layouts remain unchanged.
- Recorder emits `camera_alert` decision and voice state changes for investigation.

## Evidence and limitations

16 camera checks, 10 mocked service/TTS checks, 115 host painter checks passed. Signed APK compiled and aligned; certificate matches wide.50; existing assets/resources/native libraries unchanged. Exact smali change allowlist verified. See verification/*.json.

No Android device, audible-output, actual missed-trip replay or C4 driving-control test was performed. Prior 15 tolerance and 17 scenario tests assumed all geometrically eligible fallback candidates become large warnings; that expectation is intentionally changed, so those historical passes are not claimed for this build. Curved/branched roads, ambiguous parallel/elevated geometry and absent map coverage can still produce only a qualified nearby advisory or no candidate. Navigation route geometry is not used by the new road gate.

Install over wide.50 with the same signature; keep the previous APK for comparison. Do not uninstall to update. Google companion does not need reinstalling for this camera change. At rest, verify precise location permission and the existing camera voice switch; offline Chinese TTS must be available for qualified spoken advisories. Export the new diagnostic log after a normally driven trip if checking the reported miss; no special maneuver is required.

Official listing: https://www.hchpb.gov.tw/Tw/Common/SinglePageDownload?SiteID=416763f8-a1f7-48fd-bfbf-9327913efad7&filter=BE5D668F-5B8B-4305-ABA5-4F233091B0B8
Conflicting secondary examples: https://speed.ioi.tw/city/%E6%96%B0%E7%AB%B9%E7%B8%A3 and https://speedcamera.moreptt.com/273/
