import json,subprocess,sys
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','sanitized'];lines=[];rows=[]
for case,(start,n) in enumerate([(0,8),(4086,8),(4087,8),(4094,8),(4095,8),(4095,1)]):
 blocks=extra=drops=abandoned=returned=shake=ptr=0;counter=2**64-64;lines.append(f'CASE {case} {start} {n}\n')
 def refill(initial=False):
  global blocks,extra,drops,ptr,counter
  if not initial:extra+=1;drops+=4096-ptr
  counter=(counter+64)%2**64;blocks+=1;ptr=0
 def init(j):
  global counter,abandoned,shake
  if j>1:abandoned+=4096-ptr
  counter=2**64-64;shake+=56;lines.append(f'SHAKE {j} 56 {counter:016x}\n');id=blocks;refill(True);lines.append(f'INIT {j} {id} {counter:016x} 1 {ptr}\n')
 def get(size,emit=False):
  global ptr,returned
  before=ptr
  if size==8 and ptr>=4087:refill()
  block_id=blocks-1;data=bytes((block_id*101+i*29+(i>>4))%256 for i in range(ptr,ptr+size));w=int.from_bytes(data,'little');ptr+=size;returned+=size
  if size==1 and ptr==4096:refill()
  if emit:lines.append(f'GET {size} {before} {ptr} {w:016x}\n')
 init(1)
 for _ in range(start):get(1)
 get(n,True);init(2);get(8,True);unused=4096-ptr;assert 4096*blocks==returned+drops+abandoned+unused
 lines.append(f'ACCOUNT {blocks} {extra} {returned} {drops} {abandoned} {unused} {shake}\n');rows.append(dict(start=start,first_getter=n,blocks=blocks,getter_drops=drops,reinit_abandonment=abandoned,initial_blocks=2))
expected=''.join(lines).encode();(W/'artifacts/reset.expected').write_bytes(expected);p=subprocess.run(['bin/reset-'+mode],capture_output=True,timeout=30)
for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/('reset_'+mode+'.'+s)).write_bytes(b)
assert p.returncode==0 and not p.stderr and p.stdout==expected,(p.returncode,p.stderr.decode())
(W/'artifacts'/('reset_'+mode+'.json')).write_text(json.dumps(dict(status='PASS_ORIGINAL_INIT_AND_GETTER_RESET_PROJECTION',mode=mode,cases=rows,expected_sha256=sha(W/'artifacts/reset.expected'),stdout_sha256=sha(W/'logs'/('reset_'+mode+'.stdout')),u8_boundary_scope='generic getter control, not complete-root/proposal endpoint'),indent=2)+'\n');print('PASS_RESET',mode,len(rows))
