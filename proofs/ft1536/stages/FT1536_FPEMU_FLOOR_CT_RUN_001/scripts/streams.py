"""Lossless <=32MiB storage parts, whole-stream hashes and streaming reconstruction."""
import hashlib,io,json
from pathlib import Path
LIMIT=32*1024*1024
def digest(p):
 with Path(p).open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def seal_stream(folder,name,archive):
 folder=Path(folder);p=folder/name;size=p.stat().st_size;whole=digest(p);parts=[]
 if size<=LIMIT:parts=[dict(path=name,bytes=size,sha256=whole)]
 else:
  target=folder/'streams';target.mkdir(exist_ok=True)
  with p.open('rb') as f:
   i=0
   while data:=f.read(LIMIT):
    q=target/(name+f'.part{i:04d}');assert not q.exists();q.write_bytes(data)
    parts.append(dict(path=q.relative_to(folder).as_posix(),bytes=len(data),sha256=hashlib.sha256(data).hexdigest()));i+=1
  # Retain the original under excluded tmp only after complete part verification.
  h=hashlib.sha256()
  for r in parts:
   with (folder/r['path']).open('rb') as f:
    while data:=f.read(1<<20):h.update(data)
  assert h.hexdigest()==whole
  q=Path(archive)/name;q.parent.mkdir(parents=True,exist_ok=True);assert not q.exists();p.rename(q)
 return dict(name=name,bytes=size,sha256=whole,parts=parts)
class PartsReader(io.RawIOBase):
 def __init__(self,folder,record):
  self.folder=Path(folder);self.record=record;self.index=0;self.file=None;self.hash=hashlib.sha256();self.total=0
 def readable(self):return True
 def readinto(self,b):
  while True:
   if self.file is None:
    if self.index==len(self.record['parts']):
     assert self.total==self.record['bytes'] and self.hash.hexdigest()==self.record['sha256'];return 0
    r=self.record['parts'][self.index];p=self.folder/r['path']
    assert p.is_file() and not p.is_symlink() and p.stat().st_size==r['bytes'] and digest(p)==r['sha256']
    self.file=p.open('rb');self.index+=1
   n=self.file.readinto(b)
   if n:self.hash.update(memoryview(b)[:n]);self.total+=n;return n
   self.file.close();self.file=None
 def close(self):
  if self.file is not None:self.file.close();self.file=None
  super().close()
def open_stream(folder,name):
 records=json.loads((Path(folder)/'STREAMS.json').read_text());return io.BufferedReader(PartsReader(folder,records[name]),1<<20)
