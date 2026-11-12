# wide.49 conservative camera baseline restoration

Restores the exact wide.42 WideCameraTrace source, with only the existing enforcement onRoadUpdate hook retained. Keeps wide.48 layout and wide.47 AMap diagnostics. The wide.43 branching forward-road search is no longer used for speed-camera display/audio. This is a baseline restoration, not proof that branching caused the reported miss.

Live dashboard displays only confirmed AHEAD enforcement; REFERENCE, NEARBY, CONDITIONAL and DIRECTION_UNKNOWN items do not appear in either main or secondary reminder. Catalog remains available in diagnostics. This removes the photographed misleading nearby/opposite reference from live driving UI. Existing enforcement voice policy and C4 speed-control arbitration are not changed.

Build/signing checks do not prove real-device detection or audio. User-provided wide.46 logs were recovered; they contain GPS/map-match events but not per-camera fallback decisions. Device validation of the restored baseline remains pending.
