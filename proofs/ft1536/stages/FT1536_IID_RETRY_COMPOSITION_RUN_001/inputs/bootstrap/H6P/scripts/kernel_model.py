"""Literal scalar/getter/expm model; probability is separately counted, not exp()."""
import re
from pathlib import Path
from fractions import Fraction as Q
from functools import lru_cache
from backend import add,sub,mul,div,of
from fp_literal import floor,u64
from dyadic import value
MASK=2**64-1;B=2**32;H=2**55
@lru_cache(maxsize=2)
def constants(root):
 text=(Path(root)/'source/ft1536-adaptive-cdf-tables.h').read_text();pairs=[tuple(map(int,x)) for x in re.findall(r'\{\s*(\d+)u,\s*(\d+)u\s*\}',text.split('ft_adaptive_cdf[',1)[1])];assert len(pairs)==2560
 banks=[[hi*2**64+lo for hi,lo in pairs[j*512:(j+1)*512]] for j in range(5)]
 h=(Path(root)/'source/fpr-emulated.h').read_text();coeff=[int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)ULL',h.split('fpr_expm_p63_coefficients[13]',1)[1].split('};',1)[0])];assert len(coeff)==13
 coefs=[int(s,16) for s in re.findall(r'UINT64_C\(0x([0-9a-f]+)\)',text.split('ft_adaptive_cdf_inv_2sigma0_sq_bits[',1)[1].split('};',1)[0])];assert len(coefs)==5
 return banks,coefs,coeff
def high_limb(x,y):
 x0=x%B;x1=x//B;y0=y%B;y1=y//B;a=x0*y1+(x0*y0)//B;b=x1*y0
 assert 0<=a<2**64 and 0<=b<2**64
 c=a//B+b//B+(a%B+b%B)//B+x1*y1;assert c<2**64 and c==(x*y)//2**64
 return c
def trunc_bits(x):
 ex=(x>>52)&2047;s=x>>63;cc=1085-ex;m=((u64(x<<10)|2**62)&(2**63-1));m>>=cc&63;m&=u64(-(((cc-64)&0xffffffff)>>31));return u64((m^u64(-s))+s)
def expword(root,r):
 coeff=constants(root)[2];scaled=mul(r,0x43e0000000000000);z=u64(trunc_bits(scaled)<<1);y=coeff[0];steps=[y]
 for c in coeff[1:]:y=u64(c-high_limb(z,y));steps.append(y)
 return y,dict(scaled=scaled,z=z,steps=steps)
def ber(root,x,w0=0,w1=0):
 assert 0<=value(x)<2**19 and x>>63==0
 e=floor(mul(x,0x3ff71547652b82fe));r=sub(x,mul(of(e),0x3fe62e42fefa39ef));assert 0<=e<2**20 and abs(value(r))<2**21
 y,horner=expword(root,r);Z=y>>8;safe=min(e,63);over=int(e>=64);masked=w0^((w0>>safe)<<safe)
 accepted=int(masked==0)*(1-over)*int((u64((w1&(H-1))-Z)>>63))
 beta=Q(0) if over else Q(min(Z,H),2**(e+55));assert Z<2**56
 return dict(e=e,rB=r,expm=y,Z=Z,safe_s=safe,over=over,accepted=accepted,beta=str(beta),beta_game='IID_BUFFER',**horner)
def numeric(mu):
 return ((mu>>52)&2047)<2047 and -2147483283<=value(mu)<2147483282
def entry(root,mu,sigma):
 assert numeric(mu) and 0<value(sigma)<32
 banks,coefs,_=constants(root);s=floor(mu);r=sub(mu,of(s));dss=div(of(1),mul(mul(sigma,sigma),of(2)))
 assert 0<value(dss)<1 and value(r)>=0 and value(r)<=1 and r>>63==0
 j=next((j for j,a in enumerate(coefs) if dss>=a),None)
 if j is None:raise ValueError('STOP_NO_BANK')
 gap=sub(dss,coefs[j]);assert gap>>63==0 and 0<=value(gap)<2
 return dict(mu=mu,sigma=sigma,s=s,r=r,dss=dss,bank=j,coefficient=coefs[j],gap=gap)
def iteration(root,en,U,b,w0=0,w1=0):
 banks=constants(root)[0];samples=[sum(U<t for t in ts) for ts in banks];k=samples[en['bank']];assert k<366 and b in [0,1]
 delta=sub(of(1),en['r']) if b else en['r'];assert delta>>63==0 and 0<=value(delta)<=1
 kk=k*k;tail=add(mul(of(2*k),delta),mul(delta,delta));x=add(mul(of(kk),en['gap']),mul(tail,en['dss']));out=en['s']+(1+k if b else -k)
 assert -2**31<=out<2**31
 return dict(**en,k=k,b=b,samples=samples,delta=delta,tail=tail,x=x,output=out,ber=ber(root,x,w0,w1))
class Buffer:
 def __init__(self,blocks,ptr=0):
  assert blocks and all(len(b)==4096 for b in blocks) and 0<=ptr<4096
  self.blocks=blocks;self.block=0;self.ptr=ptr;self.returned=0;self.dropped=0;self.events=[]
 def refill(self):
  if self.block+1==len(self.blocks):raise EOFError('HARNESS_TAPE_EXHAUSTED_NOT_SOURCE_ABORT')
  self.block+=1;self.ptr=0
 def get(self,n):
  assert n in [1,8];old=[self.block,self.ptr];drop=0
  if n==8 and self.ptr>=4087:drop=4096-self.ptr;self.refill();self.dropped+=drop
  block=self.block;start=self.ptr;data=self.blocks[block][start:start+n];assert len(data)==n;self.ptr+=n;self.returned+=n
  if n==1 and self.ptr==4096:self.refill()
  value=int.from_bytes(data,'little');self.events.append(dict(n=n,old=old,read=[block,start],after=[self.block,self.ptr],discard=drop,value=value));return value
 def proposal(self):return [self.get(n) for n in [8,8,1,8,8]]
def schedule(ptr,n=1):
 p=ptr;R=D=0;events=[]
 for _ in range(n):
  for k in [8,8,1,8,8]:
   before=p;drop=0
   if k==8 and p>=4087:drop=4096-p;D+=drop;R+=1;p=0
   start=p;p+=k
   if k==1 and p==4096:R+=1;p=0
   events.append(dict(n=k,before=before,read_start=start,after=p,discard=drop))
 return dict(start=ptr,proposals=n,end=p,refills=R,discarded=D,returned=33*n,events=events)
