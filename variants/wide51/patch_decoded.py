from pathlib import Path
import sys
root=Path(sys.argv[1])/"smali/com/navipilot/obf"
p=root/"WideBridgeLog$1.smali"
s=p.read_text();assert s.count("wide.50")==1;p.write_text(s.replace("wide.50","wide.51"))
# The GPS foreground service now owns audio. Keep the border purely visual.
p=root/'WideStatusBorder.smali';s=p.read_text()
line='    invoke-static {v4, v5, p1, p2}, Lcom/navipilot/obf/WideCameraVoice;->observe(Landroid/content/Context;Ljava/lang/String;J)V'
assert s.count(line)==1;s=s.replace(line,'    # Audio handled by WideCameraAlerts in the location service.')
p.write_text(s)
