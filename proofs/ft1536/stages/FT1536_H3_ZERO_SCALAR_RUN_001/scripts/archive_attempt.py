import hashlib,json,sys
from pathlib import Path
W=Path.cwd();p=W/sys.argv[1];q=W/sys.argv[2]
assert p.is_relative_to(W) and q.is_relative_to(W) and not p.is_symlink() and not q.exists()
q.parent.mkdir(parents=True,exist_ok=True);data=p.read_bytes()
with q.open('xb') as f:f.write(data)
print(json.dumps(dict(source=sys.argv[1],archive=sys.argv[2],sha256=hashlib.sha256(data).hexdigest())))
