# wide.48 dashboard correction

Based on signed wide.47; preserves AMap diagnostics.

- Place C4/GPS speed source above the actual vehicle speed. Label the red ring 道路速限.
- Reduce the speed-limit numeral size to fit three digits inside the ring.
- Keep unconfirmed/historical/nearby enforcement references in the secondary strip, without a large numerical countdown. Only confirmed AHEAD enforcement can take the primary reminder.
- Label idle camera search explicitly: 測速搜尋中 / 無已確認目標.

The pictured 1945 m value was the straight-line distance to a REFERENCE enforcement record, not a confirmed approaching speed camera. Its distance can increase when travelling away. This change does not alter camera detection gates or claim to repair the reported missed warning. That requires the corresponding GPS/camera trace and location/direction.

Build and original signing certificate verification are recorded in verification/build.json. Android/device validation is pending.
