import json,struct
from fractions import Fraction as F
from pathlib import Path
from dyadic import rn,value
from ordered_model import Machine,K,N,T,MARK
from replaylib import sha
W=Path.cwd();D=W/'checks/data';D.mkdir(parents=True,exist_ok=True)
def tree():
 t=[0]*K
 def L(off,n,scale):
  for i in range(n//2):t[off+i]=rn(scale*F((i%5)-2,32));t[off+n//2+i]=rn(scale*F((i%3)-1,64))
 def inner(k,off):
  if k==0:t[off]=rn(20+F(off%7,16));return 1
  n=2**k;L(off,n,F(1));size=(k+1)*n;child=k*2**(k-1);inner(k-1,off+n);inner(k-1,off+n+child);return size
 L(0,N,F(8))
 for b in range(2):
  B=1536+b*8448
  for j in range(3):L(B+512*j,512,F(2))
  for j in range(3):inner(8,B+1536+j*2304)
 return t
base_tree=tree();t0=[rn(F((i*7919)%100001-50000,4)) for i in range(N)];t1=[rn(F((i*137)%4001-2000,8)) for i in range(N)];t0[0]=1<<63;t1[0]=0
normal=[['N',[0,29,59,235,365][i%5],i%2,0] for i in range(3072)];rows=[]
cases=[('normal_endpoints','top',None,None),('stutter_then_return','top',33,'J'),('fault_first','top',0,'F'),('fault_between_pair','top',1,'F'),('fault_last','top',3071,'F'),('nonreturn_prefix','top',17,'S'),('base_signed_zero','base',None,None),('base_large_fault','base',0,'F')]
for name,mode,idx,tag in cases:
 tr=list(base_tree);a=list(t0);b=list(t1);tape=[list(x) for x in normal]
 if mode=='base':
  tr[0]=rn(20);a=[0]*N;b=[0]*N
  if name=='base_signed_zero':a[0]=1<<63;b[0]=1<<63;tape[0]=['N',0,1,0];tape[1]=['N',0,0,0]
  else:a[0]=rn(10000000);b[0]=rn(10000000)
 if tag=='J':tape[idx][3]=4096
 elif tag is not None:tape[idx]=[tag,0,0,4096 if tag=='S' else 0]
 m=Machine(W,tr,a,b,tape);res=m.run(mode);assert res['status'] in ['COMPLETED','REJECTION_NONRETURN']
 assert m.mem['K']==tr and m.mem['T'][:3072]==a+b
 assert all(x==MARK for x in m.mem['T'][res['high_water']:])
 if res['status']=='COMPLETED' and mode=='top':assert res['calls']==3072 and res['high_water']==8702
 for r in m.calls:
  if r['outcome']=='NORMAL_RETURN':
   mu=int(r['mu'],16);delta=value(mu)-r['sample'];assert abs(delta)<=366
 payload=''.join(f'{x:016x}\n' for x in tr+a+b)+''.join(f'{t} {k} {b} {j}\n' for t,k,b,j in tape)
 expected='\n'.join(m.events)+'\nT '+' '.join(f'{x:016x}' for x in m.mem['T'])+f"\nEND {res['status']} {res['calls']} {res['fault']} {res['high_water']} {res['pre_floor']} FRAME_CANARIES_PASS\n"
 (D/(name+'.input')).write_text(payload);(D/(name+'.expected')).write_text(expected);(D/(name+'.calls.json')).write_text(json.dumps(m.calls,indent=2)+'\n')
 (D/(name+'.memory.bin')).write_bytes(struct.pack('<10752Q',*m.mem['T']));(D/(name+'.meta.json')).write_text(json.dumps(dict(mode=mode,tree=tr,t0=a,t1=b,tape=tape,result=res),indent=2)+'\n')
 (D/(name+'.products.json')).write_text(json.dumps(m.repeated,indent=2)+'\n')
 rows.append(dict(name=name,mode=mode,result=res,preflight='PASS_ALL_CONSUMED_OPERANDS_AND_ACTIVE_CENTERS',input_sha256=sha(D/(name+'.input')),expected_sha256=sha(D/(name+'.expected')),calls_sha256=sha(D/(name+'.calls.json')),
  membership='Synthetic tree/targets and public abstract response tape. Normal returns checked against actual selected-bank support; injected faults/stutter do not claim source probabilistic reachability.'))
 print(json.dumps(dict(fixture=name,**res)),flush=True)
out=dict(status='PASS_ORDERED_FIXTURE_PREFLIGHT',fixtures=rows,whole_original_sampling_only=True,KeyGen_or_do_sign_or_Sign_executed=False,public_tapes_not_seeds=True)
(W/'artifacts/fixtures.json').write_text(json.dumps(out,indent=2)+'\n')
