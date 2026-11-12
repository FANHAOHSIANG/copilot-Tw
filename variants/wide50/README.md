# wide.50 Taiwan GPS autostart

Manual Taiwan source selection no longer marks GPS startup completed. Preserve the manually selected control source while independently starting the GPS service if automatic startup is enabled and permission is granted. Explicit opt-out and existing completed startup/stop behavior remain unchanged.

Original LaunchGate permission/opt-out/restart transition host checks passed against compiled production classes. APK compilation, same certificate and alignment checks passed. No Android device runtime validation.

Google companion fixes are separate: guarded stop, withdrawal before SDK cleanup, simulation cleanup once, failed server startup leaves no false running object, initialization-failed guidance activity does not bind missing views. No crash stack was supplied, so the reported crash root cause is not established.
