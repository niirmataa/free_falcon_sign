import hashlib,json,sys
from pathlib import Path
W=Path.cwd();source=W/sys.argv[1];target=W/sys.argv[2]
assert source.is_relative_to(W) and target.is_relative_to(W) and not target.exists()
target.parent.mkdir(parents=True,exist_ok=True)
with target.open('xb') as f:f.write(source.read_bytes())
print(json.dumps(dict(source=str(source.relative_to(W)),archive=str(target.relative_to(W)),sha256=hashlib.sha256(target.read_bytes()).hexdigest())))
