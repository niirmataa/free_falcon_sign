"""Literal integer FFT/complex/scalar target model, explicit snapshot order."""
from backend import of,div,mul,neg,cm,scalar
from root_model import fft,tables
N=1536;Q=18433
def canonical(c):
 if len(c)!=N or any(not isinstance(x,int) or not 0<=x<Q for x in c):raise ValueError('STOP_CANONICAL_CHALLENGE')
def basis(root,polys):
 if len(polys)!=4 or any(len(p)!=N for p in polys):raise ValueError('STOP_BASIS_LENGTH')
 for k,p in enumerate(polys):
  if any(abs(x)>(1 if k<2 else 2047) for x in p):raise ValueError('STOP_COEFFICIENT_CAP')
 f,g,F,G=[fft([of(x) for x in p],tables(root)) for p in polys]
 return g+[neg(x) for x in f]+G+[neg(x) for x in F]
def complex_mul(a,b):
 assert len(a)==len(b)==N
 out=[cm((a[i],a[i+768]),(b[i],b[i+768])) for i in range(768)]
 return [z[0] for z in out]+[z[1] for z in out]
def scale(a,c):return [mul(x,c) for x in a]
def target(root,c,sk,mutation=None):
 canonical(c)
 if len(sk)!=24576:raise ValueError('STOP_SK_LENGTH')
 # Stronger local domain of the finite controls. Universal provenance is separate.
 for idx,cap in [(1536,2048),(4608,2**22)]:
  for x in sk[idx:idx+N]:
   if abs(scalar(x))>=cap:raise ValueError('STOP_BASIS_DOMAIN')
 if mutation=='centered':c=[x-Q if x>Q//2 else x for x in c]
 events=[];conv=[of(x) for x in c]
 for i,(x,w) in enumerate(zip(c,conv)):events.append(f'O {i} {x} {w:016x}')
 C=fft(conv,tables(root));events+=['F','V '+' '.join(f'{x:016x}' for x in C)]
 ni=div(of(1),of(Q));events.append(f'I {ni:016x}')
 copied=list(C)
 if mutation=='copy_zero':copied=[0]*N
 early=None
 if mutation=='copy_late':
  ep=complex_mul(C,sk[4608:6144]);et=scale(ep,ni);copied=list(et);early=(ep,et)
  events+=['M 0 4608','V '+' '.join(f'{x:016x}' for x in ep),f'S 0 {ni:016x}','V '+' '.join(f'{x:016x}' for x in et)]
 b01=sk[1536:3072];b11=sk[4608:6144]
 if mutation=='wrong_column':b01,b11=b11,b01
 if mutation=='wrong_alias':b01=C
 if mutation=='wrong_packing':b01=b01[768:]+b01[:768]
 events+=['C','V '+' '.join(f'{x:016x}' for x in copied)]
 p1=complex_mul(copied,b01);s1=neg(of(1)) if mutation=='missing_1q' else ni if mutation=='wrong_sign' else neg(ni);t1=scale(p1,s1)
 p0=complex_mul(C,b11) if early is None else early[0];s0=of(1) if mutation=='missing_1q' else ni;t0=scale(p0,s0) if early is None else early[1]
 steps=[('M 1536 1536',p1),(f'S 1536 {s1:016x}',t1)]
 if early is None:steps += [('M 0 4608',p0),(f'S 0 {s0:016x}',t0)]
 for label,x in steps:events +=[label,'V '+' '.join(f'{v:016x}' for v in x)]
 snapshots=dict(converted=conv,fft_c=C,copy_t1=copied,product_t1=p1,t1=t1,product_t0=p0,t0=t0,ni=ni)
 return snapshots,events
