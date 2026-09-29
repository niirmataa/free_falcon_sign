"""Program real source-positive returns/rejections through literal byte positions."""
import json,sys
from fractions import Fraction as Q
from pathlib import Path
from ordered_model import Machine,K,N,MARK,numeric
from kernel_model import constants,entry,iteration,ber,Buffer,schedule
from dyadic import rn,value
from backend import of
from post_model import suffix,Qnorm
from codec_model import encode,literal_encode,decode
from replaylib import sha
W=Path.cwd();D=W/'artifacts/fixtures';D.mkdir(exist_ok=True);C=W/'artifacts/controls';C.mkdir(exist_ok=True);which=int(sys.argv[1]);banks=constants(W)[0]
def tree():
 t=[0]*K
 def L(off,n,scale):
  for i in range(n//2):t[off+i]=rn(scale*Q((i%5)-2,32));t[off+n//2+i]=rn(scale*Q((i%3)-1,64))
 def inner(k,off):
  if not k:t[off]=rn([Q(4,3),Q(4),Q(8),Q(16),Q(24)][off%5]);return
  n=2**k;L(off,n,Q(1));inner(k-1,off+n);inner(k-1,off+n+k*2**(k-1))
 L(0,N,Q(8))
 for b in range(2):
  B=1536+b*8448
  for j in range(3):L(B+512*j,512,Q(2));inner(8,B+1536+j*2304)
 return t
def gf(e):return f"G {e['n']} {e['old'][0]} {e['old'][1]} {e['read'][0]} {e['read'][1]} {e['after'][0]} {e['after'][1]} {e['discard']} {e['value']:016x}"
class Joint(Machine):
 def __init__(self,tr,a,b,ptr,variant=0):
  super().__init__(W,tr,a,b,[]);self.raw=[bytearray([0xa5]*4096) for _ in range(128)];self.buf=Buffer(self.raw,ptr);self.start=ptr;self.variant=variant;self.proposals=0;self.cutoffs=0;self.atoms=[]
 def get(self,n,v):
  self.buf.get(n);e=self.buf.events[-1];j,off=e['read'];self.raw[j][off:off+n]=int(v).to_bytes(n,'little');e['value']=v;self.events.append(gf(e));return v
 def callback(self,mu,sigma):
  i=self.call;self.call+=1;assert numeric(mu);en=entry(W,mu,sigma);j=en['bank'];ts=banks[j];self.events.append(f'C {i} {mu:016x} {sigma:016x} 0');self.events.append(f"ENTRY {en['s']} {en['r']:016x} {en['dss']:016x}")
  before=self.proposals;rejects=(3 if i%127==0 else 0)+self.variant
  for step in range(rejects+1):
   accept=step==rejects;k=i%3 if accept else max(k for k in range(512) if ([2**128]+ts)[k]>ts[k]);bit=i%2 if accept else 0;U=ts[k]
   w0=0 if accept else 2**64-1;w1=0 if accept else 2**55-1;m=iteration(W,en,U,bit,w0,w1);assert m['ber']['accepted']==int(accept)
   self.get(8,U>>64);self.get(8,U%(2**64));self.get(1,bit|(0x80 if i%3 else 0))
   self.events.append(f"IT {k} {bit} {j} {m['delta']:016x} {m['gap']:016x} {m['x']:016x}");self.get(8,w0);self.get(8,w1);z=m['ber'];self.proposals+=1;self.cutoffs+=z['over']
   self.events.append(f"BE {m['x']:016x} {z['e']} {z['rB']:016x} {z['expm']:016x} {z['Z']:016x} {z['safe_s']} {z['over']} {z['accepted']}")
   self.atoms.append(dict(call=i,k=k,b=bit,U=str(U),x=f"{m['x']:016x}",e=z['e'],accepted=bool(accept),source_support=accept))
  self.events.append(f"R {i} N {m['output']}");self.calls.append(dict(index=i,mu=f'{mu:016x}',sigma=f'{sigma:016x}',bank=j,sample=m['output'],N=self.proposals-before,fault_before=0,ptr=self.buf.ptr));return m['output']
def save(name,exe,mode,inp,expected=None,model=None):
 p=D/(name+'.input');p.write_text(inp);row=dict(name=name,exe=exe,mode=mode,input=p.relative_to(W).as_posix(),input_sha256=sha(p),preflight=True,classification='SYNTHETIC_LOCAL_TREE_TARGETS_PUBLIC_WORD_TAPE_NO_EMITTED_MEMBERSHIP')
 if expected is not None:q=D/(name+'.expected');q.write_text(expected);row.update(expected=q.relative_to(W).as_posix(),expected_sha256=sha(q))
 if model is not None:q=C/(name+'.json');q.write_text(json.dumps(model,separators=(',',':'))+'\n');row.update(model=q.relative_to(W).as_posix(),model_sha256=sha(q))
 return row
configs=[('root_boundary','top',4087,0),('root_extra_rejections','top',4086,1),('terminal_plus_zero','base',4095,0),('terminal_minus_zero','base',4087,0)]
name,mode,ptr,variant=configs[which];tr=tree();a=[rn(Q((i*7919)%100001-50000,4)) for i in range(N)];b=[rn(Q((i*137)%4001-2000,8)) for i in range(N)];a[0]=1<<63;b[0]=0
if mode=='base':tr[0]=rn(Q(4,3));a=[0]*N;b=[0]*N;a[0]=b[0]=(1<<63 if 'minus' in name else 0)
m=Joint(tr,a,b,ptr,variant);res=m.run(mode);assert res['status']=='COMPLETED' and res['calls']==(3072 if mode=='top' else 2)
assert m.mem['K']==tr and m.mem['T'][:3072]==a+b and all(x==MARK for x in m.mem['T'][res['high_water']:])
raw=m.raw[:m.buf.block+1];inp='\n'.join(f'{x:016x}' for x in tr+a+b)+f'\n{ptr} {len(raw)}\n'+''.join(x.hex()+'\n' for x in raw)
expected='\n'.join(m.events)+'\nT '+' '.join(f'{x:016x}' for x in m.mem['T'])+f'\nRESOURCE {m.buf.ptr} {m.buf.block} {m.buf.dropped} {m.buf.returned}\n'+f"END COMPLETED {res['calls']} 0 {res['high_water']} {res['calls']} FRAME_CANARIES_PASS\n"
rows=[save(name,'joint',mode,inp,expected)];stat=dict(name=name,**res,start_ptr=ptr,proposals=m.proposals,cutoff_rejections=m.cutoffs,returned_bytes=m.buf.returned,refills=m.buf.block,discarded=m.buf.dropped,end_ptr=m.buf.ptr,calls_data=m.calls,atoms=m.atoms,products=m.repeated)
assert 33*m.proposals==m.buf.returned and schedule(ptr,m.proposals)['end']==m.buf.ptr
(C/(name+'_trace.json')).write_text(json.dumps(stat,separators=(',',':'))+'\n')
if mode=='top':
 basis=([of(1)]*768+[0]*768)+[0]*(2*N)+([of(1)]*768+[0]*768);x=m.mem['T'][3072:4608];y=m.mem['T'][4608:6144];post=suffix(W,basis,x,y)
 assert max(abs(w) for w in post['w1']+post['w2'])<2**23
 rows.append(save(name+'_suffix','post','suffix',' '.join(f'{w:016x}' for w in basis+x+y)+'\n',model=post))
 bs=encode(post['s2']);assert literal_encode(post['s2'])==(len(bs),bs) and decode(bs)==(post['s2'],len(bs));q=Qnorm(post['s1'],post['s2'])
 rows.append(save(name+'_codec','post','codec',' '.join(map(str,post['s1']+post['s2']))+'\n',model=dict(s1=post['s1'],s2=post['s2'],bytes=bs.hex(),length=len(bs),norm=q,short=q<2093922385)))
(W/'artifacts'/('fixtures_'+str(which)+'.json')).write_text(json.dumps(dict(cases=rows,stats={k:v for k,v in stat.items() if k not in ['calls_data','atoms','products']}),indent=2)+'\n');print(json.dumps({k:v for k,v in stat.items() if k not in ['calls_data','atoms','products']},indent=2))
