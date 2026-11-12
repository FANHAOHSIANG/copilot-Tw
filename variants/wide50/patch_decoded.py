from pathlib import Path
import sys
p=Path(sys.argv[1])/"smali/com/navipilot/obf/WideBridgeLog$1.smali"
s=p.read_text(); assert s.count("wide.49")==1; p.write_text(s.replace("wide.49","wide.50"))
