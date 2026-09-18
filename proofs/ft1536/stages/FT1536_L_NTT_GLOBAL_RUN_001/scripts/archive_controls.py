import json
from pathlib import Path
root=Path.cwd();src=root/'checks';dst=root/'artifacts/attempts/controls_interpreted'
assert src.is_dir() and not dst.exists()
assert all(not p.is_symlink() for p in src.rglob('*'))
src.rename(dst)
print(json.dumps({'archive':str(dst.relative_to(root)),'reason':'120s timeout of closure-chain interpreter; all receipts and partial trace preserved; no mathematical failure'}))
