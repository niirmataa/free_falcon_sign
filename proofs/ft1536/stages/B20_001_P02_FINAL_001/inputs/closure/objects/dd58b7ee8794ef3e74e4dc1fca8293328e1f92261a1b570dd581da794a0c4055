"""Strict manifest verification shared by the public replay and protocol tests."""
import hashlib,re
from pathlib import Path,PurePosixPath

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()
def member(root,rel):
    path=PurePosixPath(rel)
    if path.is_absolute() or '..' in path.parts or str(path)!=rel or not path.parts:
        raise ValueError('unsafe member path: '+rel)
    p=Path(root)
    for part in path.parts:
        p=p/part
        if p.is_symlink():raise ValueError('symlink member: '+rel)
    if not p.is_file():raise ValueError('missing regular member: '+rel)
    return p
def verify_manifest(root,name,expected):
    if re.fullmatch(r'[0-9a-f]{64}',expected) is None:raise ValueError('external SHA-256 required')
    manifest=member(root,name)
    if sha(manifest)!=expected:raise ValueError('manifest external pin mismatch')
    rows={}
    for line in manifest.read_text().splitlines():
        h,rel=line.split('  ',1)
        if re.fullmatch(r'[0-9a-f]{64}',h) is None or rel in rows:raise ValueError('invalid/duplicate manifest row')
        p=member(root,rel)
        if sha(p)!=h:raise ValueError('member hash mismatch: '+rel)
        rows[rel]=h
    if not rows:raise ValueError('empty manifest')
    return rows
