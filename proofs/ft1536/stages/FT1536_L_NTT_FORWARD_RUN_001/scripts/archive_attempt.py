import hashlib,json,sys
from pathlib import Path
w=Path.cwd();src=w/sys.argv[1];dst=w/sys.argv[2]
assert src.is_relative_to(w) and dst.is_relative_to(w) and not src.is_symlink() and not dst.exists()
dst.parent.mkdir(parents=True,exist_ok=True);data=src.read_bytes()
with dst.open('xb') as f:f.write(data)
print(json.dumps(dict(source=sys.argv[1],archive=sys.argv[2],sha256=hashlib.sha256(data).hexdigest())))
