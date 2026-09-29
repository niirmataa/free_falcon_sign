import json,shutil,sys
from pathlib import Path
from fractions import Fraction as Q
from backend import of,mul,div,sqrt,add,sub
from dyadic import rn,value
from ordered_model import Machine,MARK
from kernel_model import constants,entry,iteration
from post_model import suffix,rint_word,rint_oracle,narrow16
from replaylib import sha
W=Path.cwd();assert shutil.disk_usage(W).free>2*1024**3;D=W/'artifacts/fixtures';C=W/'artifacts/controls';D.mkdir(exist_ok=True);C.mkdir(exist_ok=True);which=int(sys.argv[1]);assert which in [0,1,2,3];N=1536;K=18432;tr=[0]*K;leaves=[]
def fill(k,off,branch):
 if k==0:
  if which==0:d=of(5120) if branch==0 else div(of(339775489),of(5120))
  else:d=of([331776,36864,9216,2304,1600][off%5])
  tr[off]=div(of(768),sqrt(d));leaves.append(dict(word=off,D=d,branch=branch));return
 n=2**k
 if which==1:
  for i in range(n//2):tr[off+i]=rn(Q(i%5-2,32));tr[off+n//2+i]=rn(Q(i%3-1,64))
 fill(k-1,off+n,branch);fill(k-1,off+n+k*2**(k-1),branch)
for branch in [0,1]:
 off=1536+8448*branch
 if which==1:
  for j in range(3):
   for i in range(256):tr[off+512*j+i]=rn(Q(i%5-2,16));tr[off+512*j+256+i]=rn(Q(i%3-1,32))
 for j in range(3):fill(8,off+1536+2304*j,branch)
def constant(x):return [rn(x)]*768+[0]*768
if which==0:
 vals=[Q(64),Q(32),Q(200),Q(24833,64)];basis=sum([constant(x) for x in vals],[])
 A=add(mul(rn(vals[0]),rn(vals[0])),mul(rn(vals[1]),rn(vals[1])));Cc=add(mul(rn(vals[2]),rn(vals[0])),mul(rn(vals[3]),rn(vals[1])));L=div(Cc,A);tr[:1536]=[L]*768+[0]*768
 assert vals[0]*vals[3]-vals[1]*vals[2]==18433
else:
 basis=constant(Q(1))+constant(Q(1,4))+constant(Q(-1,2))+constant(Q(2))
 tr[:1536]=[rn(Q(i%5-2,4)) for i in range(768)]+[rn(Q(i%3-1,8)) for i in range(768)]
a=[rn(Q((i*79)%2001-1000,8)) for i in range(N)];b=[rn(Q((i*137)%4001-2000,16)) for i in range(N)];a[0]=1<<63;b[0]=0
mode='top';name=['constant_basis','nonzero_complex_tree','terminal_plus_zero','terminal_minus_zero'][which]
if which>=2:mode='base';tr[0]=rn(Q(4,3));a=[0]*N;b=[0]*N;a[0]=b[0]=1<<63 if which==3 else 0
tape=[('N',i%3,i%2,0) for i in range(3072)];m=Machine(W,tr,a,b,tape);res=m.run(mode);assert res['status']=='COMPLETED' and m.fault==0
# Each programmed normal return is in the actual positive scalar source support.
tables=constants(W)[0]
for r in m.calls:
 en=entry(W,int(r['mu'],16),int(r['sigma'],16));point=iteration(W,en,tables[en['bank']][r['k']],r['b'],0,0);assert point['ber']['accepted']==1 and point['output']==r['sample']
expected='\n'.join(m.events)+'\nT '+' '.join(f'{x:016x}' for x in m.mem['T'])+'\n'+f"END COMPLETED {res['calls']} 0 {res['high_water']} {res['calls']} FRAME_CANARIES_PASS\n"
inp='\n'.join(f'{x:016x}' for x in tr+a+b)+'\n'+''.join(f'{t} {k} {bb} {s}\n' for t,k,bb,s in tape)
cases=[]
def save(label,exe,mode,inp,out=None,model=None):
 p=D/(label+'.input');p.write_text(inp);row=dict(name=label,exe=exe,mode=mode,input=p.relative_to(W).as_posix(),input_sha256=sha(p),scope='SYNTHETIC_LOCAL_PUBLIC_MAP_FIXTURE; no Emitted/canonical-key membership',preflight=True)
 if out is not None:p=D/(label+'.expected');p.write_text(out);row.update(expected=p.relative_to(W).as_posix(),expected_sha256=sha(p))
 if model is not None:p=C/(label+'.json');p.write_text(json.dumps(model,separators=(',',':'))+'\n');row.update(model=p.relative_to(W).as_posix(),model_sha256=sha(p))
 cases.append(row)
save(name,'map',mode,inp,expected)
record=dict(name=name,scope='LOCAL_SOURCE_POSITIVE_SCRIPTED_HISTORY, no P_key/Emitted membership',tree=tr,basis=basis,targets=[a,b],leaves=leaves,calls=m.calls,stats=res,source_outputs=[m.mem['T'][3072:4608],m.mem['T'][4608:6144]],products=m.repeated)
if which<2:
 x,y=record['source_outputs'];post=suffix(W,basis,x,y);record['post']=post
 save(name+'_post','post','suffix',' '.join(f'{w:016x}' for w in basis+x+y)+'\n',model=post)
else:record['terminal_outputs']=[m.mem['T'][3072],m.mem['T'][4608]]
(C/(name+'_data.json')).write_text(json.dumps(record,separators=(',',':'))+'\n')
if which==0:
 words=set([0,1<<63,1,(1<<63)|1])
 for q in [Q(-65537,2),Q(65535,2),Q(-1,2),Q(1,2),Q(3,2),Q(65536),Q(-32768),Q(32767)]:
  w=rn(q);words.update([w-1,w,w+1])
 words=sorted(w for w in words if 0<=w<2**64 and ((w>>52)&2047)<=1072);out=''
 for w in words:
  r=rint_word(w);assert r==rint_oracle(w);out+=f'{w:016x} {r} {narrow16(r)}\n'
 assert rint_word(rn(Q(-65537,2)))==-32768 and rint_word(rn(Q(65535,2)))==32768
 save('rint_event_boundaries','post','rint',''.join(f'{w:016x}\n' for w in words),out)
(W/'artifacts'/('fixtures_'+str(which)+'.json')).write_text(json.dumps(dict(cases=cases,fixture=name,source_calls=m.call,all_returns_in_actual_local_support=True),indent=2)+'\n');print('PASS_H6P_PREFLIGHT',name,m.call)
