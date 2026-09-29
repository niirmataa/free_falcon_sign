import json,struct
from fractions import Fraction as Q
from pathlib import Path
from backend import of
from target_model import basis,target,canonical
from replaylib import sha
W=Path.cwd();D=W/'checks/data';D.mkdir(parents=True,exist_ok=True);N=1536;q=18433
def make_polys(kind):
 p=[[0]*N for _ in range(4)]
 if kind=='sparse':p[0][0]=1;p[0][768]=-1;p[2][1]=2047;p[2][1535]=-31
 elif kind=='dense':
  p[0]=[1 if i%3==0 else -1 if i%3==1 else 0 for i in range(N)]
  p[2]=[((i*7919+23)%4095)-2047 for i in range(N)]
 elif kind=='extreme':p[0]=[1]*N;p[2]=[2047]*N
 elif kind=='cancel':p[2][0]=1
 else:raise ValueError(kind)
 # g=G=0 in every coefficient fixture: determinant0, provably not an emitted key.
 return p
cs={
 'zero':[0]*N,'max':[q-1]*N,'alternating':[0 if i%2==0 else q-1 for i in range(N)],
 'dense':[(i*7919+i*i*17+12345)%q for i in range(N)],
 'sparse_edges':[q-1 if i in [0,767,768,1535] else 0 for i in range(N)]}
for index in [0,767,768,1535]:c=[0]*N;c[index]=q-1;cs['unit_'+str(index)]=c
schedule=[('zero','sparse'),('max','extreme'),('alternating','dense'),('dense','dense'),('sparse_edges','sparse')]+[(f'unit_{j}','sparse') for j in [0,767,768,1535]]+[('dense','cancel')]
cache={};rows=[]
for challenge,bkind in schedule:
 name=challenge+'_'+bkind;c=cs[challenge];canonical(c);p=make_polys(bkind)
 if bkind not in cache:cache[bkind]=basis(W,p)
 bw=cache[bkind];sk=[0x3ff0000000000000+(i*65537)%2**52 for i in range(24576)];sk[:6144]=bw
 snapshots,events=target(W,c,sk)
 payload=''.join(str(x)+'\n' for x in c)+''.join(str(x)+'\n' for v in p for x in v)
 metadata=dict(mode='coeff',canonical_challenge=c,coefficients=p,basis_words=bw,membership='g=G=0 => fG-gF=0, not q; synthetic basis/tree, not normalized emitted key')
 tail='B '+' '.join(f'{x:016x}' for x in bw)+'\nT0 '+' '.join(f'{x:016x}' for x in snapshots['t0'])+'\nT1 '+' '.join(f'{x:016x}' for x in snapshots['t1'])+f"\nNI {snapshots['ni']:016x}\nEND 3072 24576 1536 OUTPUTS_CTX_CANARIES_FRAME_PASS\n"
 (D/(name+'.input')).write_text(payload);(D/(name+'.expected')).write_text('\n'.join(events)+'\n'+tail);(D/(name+'.meta.json')).write_text(json.dumps(metadata,indent=2)+'\n');(D/(name+'.snapshots.json')).write_text(json.dumps(snapshots,indent=2)+'\n')
 (D/(name+'.targets.bin')).write_bytes(struct.pack('<3072Q',*(snapshots['t0']+snapshots['t1'])))
 rows.append(dict(name=name,mode='coeff',preflight='PASS_ALL_CANONICAL_AND_SOURCE_OPERAND_DOMAINS',input_sha256=sha(D/(name+'.input')),expected_sha256=sha(D/(name+'.expected')),target_sha256=sha(D/(name+'.targets.bin')),membership=metadata['membership']))
# Explicit raw +/-0 source-class fixture, no coefficient provenance asserted.
c=cs['dense'];bw=[0]*6144
for i in range(N):bw[1536+i]=(1<<63) if i%2 else 0;bw[4608+i]=(1<<63) if i%3 else 0
sk=[0x3ff0000000000000+(i*65537)%2**52 for i in range(24576)];sk[:6144]=bw;snapshots,events=target(W,c,sk);name='signed_zero_words'
payload=''.join(str(x)+'\n' for x in c)+''.join(f'{x:016x}\n' for x in bw)
tail='B '+' '.join(f'{x:016x}' for x in bw)+'\nT0 '+' '.join(f'{x:016x}' for x in snapshots['t0'])+'\nT1 '+' '.join(f'{x:016x}' for x in snapshots['t1'])+f"\nNI {snapshots['ni']:016x}\nEND 3072 24576 1536 OUTPUTS_CTX_CANARIES_FRAME_PASS\n"
(D/(name+'.input')).write_text(payload);(D/(name+'.expected')).write_text('\n'.join(events)+'\n'+tail)
(D/(name+'.meta.json')).write_text(json.dumps(dict(mode='words',canonical_challenge=c,basis_words=bw,coefficients=None,membership='Raw signed-zero basis words; rounding-only reference, no emitted provenance'),indent=2)+'\n')
(D/(name+'.snapshots.json')).write_text(json.dumps(snapshots,indent=2)+'\n');(D/(name+'.targets.bin')).write_bytes(struct.pack('<3072Q',*(snapshots['t0']+snapshots['t1'])))
rows.append(dict(name=name,mode='words',preflight='PASS_ALL_CANONICAL_AND_SOURCE_OPERAND_DOMAINS',input_sha256=sha(D/(name+'.input')),expected_sha256=sha(D/(name+'.expected')),target_sha256=sha(D/(name+'.targets.bin')),membership='Raw word fixture, not emitted'))
out=dict(status='PASS_LITERAL_TARGET_PREFLIGHT',fixtures=rows,canonical_values=['0','18432','alternating','sparse edges','units0/767/768/1535','deterministic dense'],basis_types=list(cache)+['raw signed zeros'],private_keys_generated=False,source_prefix_only=True)
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],fixtures=len(rows),all_outputs_per_target=1536),indent=2))
