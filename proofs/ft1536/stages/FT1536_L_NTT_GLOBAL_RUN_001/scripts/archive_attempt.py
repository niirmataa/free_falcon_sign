import hashlib,json,sys
from pathlib import Path
W=Path.cwd();a=W/sys.argv[1];b=W/sys.argv[2]
assert a.is_relative_to(W) and b.is_relative_to(W) and not b.exists()
b.parent.mkdir(parents=True,exist_ok=True)
with b.open('xb') as f:f.write(a.read_bytes())
print(json.dumps(dict(source=str(a.relative_to(W)),archive=str(b.relative_to(W)),sha256=hashlib.sha256(b.read_bytes()).hexdigest())))
