"""Literal active suffix/iFFT/rint/narrowing; no host libm oracle."""
from backend import add,sub,mul,div,neg,of,half,ca,cs,cm,cq,conj,scalar
from fp_literal import u64
from root_model import tables
from dyadic import value,roundint
N=1536
def narrow16(w):return (w+32768)%65536-32768
def rint_word(x):
 if not 0<=x<2**64 or ((x>>52)&2047)>1072:raise ValueError('STOP_RINT_PROVED_EXPONENT_DOMAIN')
 m=((u64(x<<10)|2**62)&(2**63-1));e=1085-((x>>52)&2047);m&=u64(-(((e-64)&0xffffffff)>>31));e&=63
 d=u64(m<<(63-e));dd=(d&0xffffffff)|((d>>32)&0x1fffffff);f=(d>>61)|int(dd!=0);mag=(m>>e)+((0xc8>>f)&1)
 assert mag<=2**50
 return -mag if x>>63 else mag
def rint_oracle(x):
 v=value(x);return -roundint(-v) if v<0 else roundint(v)
def ifft(root,words,mutation=None):
 if len(words)!=N:raise ValueError('STOP_IFFT_LENGTH')
 for w in words:scalar(w)
 a=list(words);sq,cub,(_,w2,w4)=tables(root);hn=768;snap=[]
 if mutation=='wrong_order':a[0],a[1],a[hn],a[hn+1]=a[1],a[0],a[hn+1],a[hn]
 phase_conj=(lambda z:z) if mutation=='wrong_conjugation' else conj
 def get(i):return a[i],a[i+hn]
 def put(i,z):a[i],a[i+hn]=z
 for i in range(0,hn,3):
  A,B,C=get(i),get(i+1),get(i+2);x=phase_conj(cub[512+i//3]);B1=cm(B,w4);B2=cm(B,w2);C1=cm(C,w4);C2=cm(C,w2)
  put(i,ca(A,ca(B,C)));put(i+1,cm(x,ca(ca(B1,C2),A)));put(i+2,cm(cq(x),ca(ca(B2,C1),A)))
 snap.append(('cubic',0,list(a)));t=6;m=256
 while t<N:
  ht=t//2
  for j in range(m//2):
   phase=phase_conj(sq[m+j])
   for i in range(j*t,j*t+ht):
    A,B=get(i),get(i+ht);put(i,ca(A,B));put(i+ht,cm(cs(A,B),phase))
  snap.append(('binary',t,list(a)));t*=2;m//=2
 iw=0x3ff279a74590331c
 for i in range(hn):
  re,im=get(i);b=mul(im,iw);a[i]=sub(re,half(b));a[i+hn]=b
 snap.append(('terminal',0,list(a)));ni=div(of(1),of(512 if mutation=='wrong_scale' else 768));a=[mul(ni,x) for x in a];snap.append(('scale',0,list(a)))
 return a,snap
def cmvec(a,b):
 pairs=[cm((a[i],a[i+768]),(b[i],b[i+768])) for i in range(768)];return [r for r,i in pairs]+[i for r,i in pairs]
def suffix(root,basis,x,y,mutation=None):
 if len(basis)!=6144 or len(x)!=N or len(y)!=N:raise ValueError('STOP_SUFFIX_LENGTH')
 for w in basis+x+y:scalar(w)
 b00,b01,b10,b11=[basis[k*N:(k+1)*N] for k in range(4)];events=[]
 def record(name,vec):events.append((name,list(vec)))
 t0=list(x);t1=list(y);record('copy_t0_tx',t0);record('copy_t1_ty',t1)
 tx=cmvec(x,b00);ty=cmvec(y,b10);record('mul_tx_b00',tx);record('mul_ty_b10',ty);tx=[add(a,b) for a,b in zip(tx,ty)];record('add_tx_ty',tx)
 if mutation=='stale_copy':t0=list(tx)
 ty=list(t0);record('copy_ty_t0',ty);ty=cmvec(ty,b01);record('mul_ty_b01',ty);t0=list(tx);record('copy_t0_tx',t0);t1=cmvec(t1,b11);record('mul_t1_b11',t1);t1=[add(a,b) for a,b in zip(t1,ty)];record('add_t1_ty',t1)
 p0=list(t0);p1=list(t1);t0,a=ifft(root,t0);t1,b=ifft(root,t1)
 if mutation=='wrong_scale':t0=[mul(z,of(2)) for z in t0];t1=[mul(z,of(2)) for z in t1]
 w1=[rint_word(z) for z in t0];w2=[rint_word(z) for z in t1]
 assert w1==[rint_oracle(z) for z in t0] and w2==[rint_oracle(z) for z in t1]
 if mutation=='binary_sign':w1=[-w for w in w1];w2=[-w for w in w2]
 s1=[narrow16(w) for w in w1];s2=[narrow16(w) for w in w2]
 return dict(events=events,ifft0=a,ifft1=b,post_frequency=[p0,p1],t0=t0,t1=t1,tx=tx,ty=ty,w1=w1,w2=w2,s1=s1,s2=s2,Safe16=all(-32768<=w<=32767 for w in w1+w2))
def Qnorm(s1,s2):
 return sum(x*x for x in s1+s2)+sum(v[i]*v[i+768] for v in [s1,s2] for i in range(768))
