import hashlib,re
from pathlib import Path,PurePosixPath
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def member(root,rel):
 q=PurePosixPath(rel)
 if q.is_absolute() or '..' in q.parts or str(q)!=rel or not q.parts:raise ValueError('unsafe member '+rel)
 p=Path(root)
 for x in q.parts:
  p=p/x
  if p.is_symlink():raise ValueError('symlink member '+rel)
 if not p.is_file():raise ValueError('missing member '+rel)
 return p
def verify_manifest(root,name,pin):
 if re.fullmatch('[0-9a-f]{64}',pin) is None:raise ValueError('external SHA256 required')
 p=member(root,name)
 if sha(p)!=pin:raise ValueError('manifest external pin mismatch')
 rows={}
 for line in p.read_text().splitlines():
  h,rel=line.split('  ',1)
  if rel in rows or re.fullmatch('[0-9a-f]{64}',h) is None:raise ValueError('duplicate/invalid row')
  if sha(member(root,rel))!=h:raise ValueError('member mismatch '+rel)
  rows[rel]=h
 if not rows:raise ValueError('empty manifest')
 return rows
