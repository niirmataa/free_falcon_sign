import json,struct
from fractions import Fraction as F
from pathlib import Path
from backend import of,add,mul,div
from dyadic import rn,value
from tree_model import raw_tree,stable,normalized
from ordered_model import Machine,sigma_bank,SUP,IW
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';D=W/'checks/data';D.mkdir(parents=True,exist_ok=True);mapping=json.loads((I/'RAW/LEAF_MAP.json').read_text())['entries'];rows=[]
def make(kind):
 A=[];C=[];Ci=[];J=[]
 for i in range(768):
  a=rn(2048 if kind=='flat' else 1536+32*(i%37));c=rn(0 if kind=='flat' else F(512+i%13,8) if kind=='vary' else F(100000000+i*7919,8));ci=rn(0 if kind=='flat' else F((i%19)-9,16) if kind=='vary' else F((i%137)-68,16)*10000)
  j=div(add(of(18433**2),add(mul(c,c),mul(ci,ci))),a);A.append(a);C.append(c);Ci.append(ci);J.append(j)
 return [A+[0]*768,C+Ci,J+[0]*768]
for kind in ['flat','vary','tilted']:
 gram=make(kind);raw,rootD,records=raw_tree(W,gram);stableD=stable(gram[0]);assert len(raw)==18432 and all(0x4090000053700377<=x<=0x4114444d1a037d50 for x in stableD)
 tree=normalized(raw,stableD,mapping)
 (D/(kind+'.gram.input')).write_text(''.join(f'{w:016x}\n' for v in gram for w in v))
 expected='RAW '+' '.join(f'{x:016x}' for x in raw)+'\nSTABLE '+' '.join(f'{x:016x}' for x in stableD)+'\nNORMALIZED '+' '.join(f'{x:016x}' for x in tree)+'\nEND 0 18432 1536 FRAME_CANARIES_PASS\n'
 (D/(kind+'.build.expected')).write_text(expected);(D/(kind+'.tree.json')).write_text(json.dumps(dict(gram=gram,raw=raw,rootD=rootD,stable=stableD,tree=tree,records=records),indent=2)+'\n')
 a=[rn(F((i*7919)%200001-100000,16)) for i in range(1536)];b=[rn(F((i*733)%4001-2000,16)) for i in range(1536)];a[0]=1<<63;b[0]=0
 tape=[]
 for j,r in enumerate(reversed(mapping)):
  s=tree[r['tree_index']]
  for variant,width in enumerate([mul(IW,s),s]):
   bank=sigma_bank(width);assert bank is not None;k=SUP[bank] if j%3 else 0;tape.append(['N',k,(j+variant)%2,0])
 modes=[('normal',tape)]
 if kind=='vary':
  t=[r[:] for r in tape];t[17]=['S',0,0,4096];modes.append(('nonreturn',t))
  t=[r[:] for r in tape];t[1]=['F',0,0,0];modes.append(('fault',t))
 for scope,t in modes:
  name=kind+'_'+scope;m=Machine(W,tree,a,b,t);res=m.run();assert res['status']=='REJECTION_NONRETURN' if scope=='nonreturn' else res['status']=='COMPLETED'
  payload=''.join(f'{w:016x}\n' for w in tree+a+b)+''.join(f'{tag} {k} {bb} {st}\n' for tag,k,bb,st in t)
  exp='\n'.join(m.events)+'\nT '+' '.join(f'{w:016x}' for w in m.mem['T'])+f"\nEND {res['status']} {res['calls']} {res['fault']} {res['high_water']} {res['pre_floor']} FRAME_CANARIES_PASS\n"
  (D/(name+'.input')).write_text(payload);(D/(name+'.expected')).write_text(exp);(D/(name+'.calls.json')).write_text(json.dumps(m.calls,indent=2)+'\n');(D/(name+'.products.json')).write_text(json.dumps(m.repeated,indent=2)+'\n')
  (D/(name+'.memory.bin')).write_bytes(struct.pack('<10752Q',*m.mem['T']));(D/(name+'.meta.json')).write_text(json.dumps(dict(kind=kind,scope=scope,t0=a,t1=b,tape=t,result=res),indent=2)+'\n')
  rows.append(dict(name=name,kind=kind,scope=scope,result=res,input_sha256=sha(D/(name+'.input')),expected_sha256=sha(D/(name+'.expected')),
   preflight='PASS_SOURCE_BUILD_STABLE_WIDTH_AND_CALLBACK_DOMAINS',membership='Public Gram/root arrays and abstract response tapes; no coefficient/P_key/emitted witness or generated key'))
  print(json.dumps(dict(fixture=name,**res)),flush=True)
out=dict(status='PASS_NEW_SOURCE_METRIC_FIXTURE_PREFLIGHT',fixtures=rows,public_Gram_cases=3,all_built_with_raw_source_models=True,source_return_relation_checked=True,
 input_member_pins={k:sha(D/(k+'.gram.input')) for k in ['flat','vary','tilted']},whole_Sign_or_KeyGen_executed=False)
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n')
