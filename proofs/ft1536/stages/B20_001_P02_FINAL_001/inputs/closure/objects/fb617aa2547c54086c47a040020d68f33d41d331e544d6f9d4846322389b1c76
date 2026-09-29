import hashlib,json,struct
from fractions import Fraction as Q
from pathlib import Path
from dyadic import rn,value
from replaylib import sha
from raw_model import Machine,leaf_map,N
W=Path.cwd();D=W/'checks/data';D.mkdir(parents=True,exist_ok=True);rows=[]
def gram(kind):
 if kind==0:return [rn(2)]*768+[0]*768+[0]*1536+[rn(3)]*768+[0]*768
 if kind==1:
  A=[rn(Q(2)+Q(i%17,128)) for i in range(768)]+[0]*768
  C=[rn(Q((i%5)-2,32)) for i in range(768)]+[rn(Q((i%7)-3,64)) for i in range(768)]
  J=[rn(Q(3)+Q(i%11,64)) for i in range(768)]+[0]*768
  return A+C+J
 A=[rn(2)]*768+[0]*768;C=[rn(Q(1,8))]*768+[0]*768;return A+C+A
def polys(kind):
 p=[[0]*N for _ in range(4)];p[0][0]=1
 if kind==0:p[3][0]=2
 elif kind==1:p[0][1]=1;p[1][2]=1;p[2][0]=1;p[3][0]=2;p[3][1]=-1
 else:p[3][0]=1
 return p
def raw_output(m):return ('\n'.join(m.events)+'\nK '+' '.join(f'{x:016x}' for x in m.mem['K'])+'\nEND 18432 8192 24576 1536 FRAME_CANARIES_PASS\n').encode()
mapping=leaf_map();(W/'LEAF_MAP.json').write_text(json.dumps(dict(schema='FT1536_RAW_LEAF_POSITIONS_V1',count=1536,tree_words=18432,
 order='b,k,entry_edge,lower_path lexical,base side; increasing physical leaf positions',entries=mapping,
 sequence='For each entry in order: literal source base g00[0] if side0, d11[0] if side1, at that base return; not stable/normalized widths.'),indent=2)+'\n')
for family in ['gram','prefix']:
 for kind in range(3):
  name=f'{family}_{kind}';mode=('alias' if kind==2 else 'gram') if family=='gram' else ('prefix_alias' if kind==2 else 'prefix')
  m=Machine(W)
  if family=='gram':data=gram(kind);payload=''.join(f'{x:016x}\n' for x in data).encode();m.write(('S',0),data);count=m.top(kind==2)
  else:
   data=polys(kind);payload=''.join(str(v)+'\n' for p in data for v in p).encode();count=m.prefix(data)
  assert count==18432 and all(((x>>52)&2047)!=2047 for x in m.mem['K'][6144:])
  leaves=[m.mem['K'][r['sk_index']] for r in mapping];assert all(value(x)>0 for x in leaves)
  (D/(name+'.input')).write_bytes(payload);(D/(name+'.expected')).write_bytes(raw_output(m));(D/(name+'.words.bin')).write_bytes(struct.pack('<24576Q',*m.mem['K']))
  (D/(name+'.snapshots.json')).write_text(json.dumps(m.snapshots,indent=2)+'\n')
  (D/(name+'.leaves.json')).write_text(json.dumps([f'{x:016x}' for x in leaves],indent=2)+'\n')
  rows.append(dict(name=name,mode=mode,preflight='PASS_ALL_CONSUMED_PRIMITIVE_DOMAINS',input_sha256=sha(D/(name+'.input')),expected_sha256=sha(D/(name+'.expected')),
   words_sha256=sha(D/(name+'.words.bin')),snapshots_sha256=sha(D/(name+'.snapshots.json')),leaf_sequence_sha256=sha(D/(name+'.leaves.json')),
   poly_events=sum(s.startswith('E ') for s in m.events),base_stores=sum(s.startswith('B ') for s in m.events),conversion_events=sum(s.startswith('O ') for s in m.events),
   scratch_high_water=8192,tree_words=18432,basis_words_checked=6144,positive_raw_leaves=1536,
   membership='No coefficient witness for synthetic Gram' if family=='gram' else f'Not P_key: constant coefficient of fG-gF is {[2,2,1][kind]}, not18433',
   emitted_witness=False))
 print(json.dumps(dict(family=family,completed=3)),flush=True)
out=dict(status='PASS_PUBLIC_FIXTURE_PREFLIGHT',fixtures=rows,leaf_map_sha256=sha(W/'LEAF_MAP.json'),P_key_or_emitted_witnesses_claimed=False,
 backend='Guarded literal integer FPEMU plus independent flat-memory/call-order model; no host-float oracle or second C execution')
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],fixtures=len(rows))))
