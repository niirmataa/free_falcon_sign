"""Executable source-dataflow projection; primitive oracle exact dyadic RN on
the tested bounded normal domain, explicit signed zero and source half.
Synthetic tree execution does NOT assert emitted-KeyGen membership."""
from pathlib import Path
import re
from dyadic import value,rn,sqrt_rn,floor_bits
from fractions import Fraction as F
MASK=(1<<64)-1;SIGN=1<<63
def of(x):return rn(x)
def neg(x):return x^SIGN
def add(x,y):return rn(value(x)+value(y),int(x==SIGN and y==SIGN))
def sub(x,y):return add(x,neg(y))
def mul(x,y):return rn(value(x)*value(y),(x^y)>>63)
def half(x):
 t=(x-(1<<52))&MASK;k=(((t>>52)&2047)+1)>>11
 return t&((k-1)&MASK)
def cm(a,b):return (sub(mul(a[0],b[0]),mul(a[1],b[1])),add(mul(a[0],b[1]),mul(a[1],b[0])))
def ca(a,b):return (add(a[0],b[0]),add(a[1],b[1]))
def cs(a,b):return (sub(a[0],b[0]),sub(a[1],b[1]))
def sq(a):return (sub(mul(a[0],a[0]),mul(a[1],a[1])),rn(2*value(mul(a[0],a[1]))))
W1R=0x3fe0000000000000;W1I=0x3febb67ae8584caa;IW=0x3ff279a74590331c
W2=(0xbfe0000000000000,0x3febb67ae8584caa);W4=(0xbfe0000000000000,0xbfebb67ae8584caa)
class Machine:
 def __init__(self,source,name='baseline'):
  text=Path(source).read_text()
  def tab(label):return [int(x,16) for x in re.findall(r'0x([0-9a-fA-F]+)ULL',text.split('static const fpr '+label+'[] = {',1)[1].split('};',1)[0])]
  self.square=tab('fpr_gm3_square');self.cubic=tab('fpr_gm3_cubic');self.calls=[];self.name=name
 def deep_split(self,f):
  n=len(f)
  if n==2:
   xx=mul(IW,f[1]);return [sub(f[0],half(xx))],[xx]
  h=n//2;q=n//4;a=[0]*h;b=[0]*h
  for u in range(q):
   x=(f[2*u],f[2*u+h]);y=(f[2*u+1],f[2*u+1+h]);t=ca(x,y)
   a[u],a[u+q]=map(half,t)
   t=cm(cs(x,y),(self.square[2*(u+h)],neg(self.square[2*(u+h)+1])))
   b[u],b[u+q]=map(half,t)
  return a,b
 def deep_merge(self,a,b):
  if len(a)==1:return [add(a[0],mul(b[0],W1R)),mul(b[0],W1I)]
  h=len(a);q=h//2;n=2*h;f=[0]*n
  for u in range(q):
   t=cm((b[u],b[u+q]),(self.square[2*(u+h)],self.square[2*(u+h)+1]));v=ca((a[u],a[u+q]),t);w=cs((a[u],a[u+q]),t)
   f[2*u],f[2*u+h]=v;f[2*u+1],f[2*u+1+h]=w
  return f
 def top_split(self,f):
  n=len(f);h=n//2;q=n//6;out=[[0]*(n//3) for _ in range(3)];inv3=rn(F(1,3))
  for v in range(q):
   u=3*v;A=(f[u],f[u+h]);B=(f[u+1],f[u+1+h]);C=(f[u+2],f[u+2+h]);x=(self.cubic[2*v+2*n//3],neg(self.cubic[2*v+2*n//3+1]))
   b1=cm(B,W4);b2=cm(B,W2);c1=cm(C,W4);c2=cm(C,W2)
   t0=ca(A,ca(B,C));t1=cm(x,ca(ca(b1,c2),A));t2=cm(sq(x),ca(ca(b2,c1),A))
   for j,t in enumerate([t0,t1,t2]):out[j][v]=mul(t[0],inv3);out[j][v+q]=mul(t[1],inv3)
  return out
 def top_merge(self,a,b,c):
  n=3*len(a);h=n//2;q=n//6;out=[0]*n
  for v in range(q):
   x=(self.cubic[2*v+2*n//3],self.cubic[2*v+2*n//3+1]);A=(a[v],a[v+q]);b0=cm((b[v],b[v+q]),x);b1=cm(b0,W2);b2=cm(b0,W4)
   c0=cm((c[v],c[v+q]),sq(x));c1=cm(c0,W2);c2=cm(c0,W4)
   for j,t in enumerate([ca(A,ca(b0,c0)),ca(A,ca(b1,c2)),ca(A,ca(b2,c1))]):out[3*v+j],out[3*v+j+h]=t
  return out
 def polymul(self,a,b):
  n=len(a);h=n//2;out=[0]*n
  for u in range(h):out[u],out[u+h]=cm((a[u],a[u+h]),(b[u],b[u+h]))
  return out
 def sample(self,mu,sigma,path,slot):
  i=len(self.calls);active=self.name!='fault' or i<5;r=floor_bits(mu)+(i%7)-3 if active else 0
  assert not active or -2147483283<=floor_bits(mu)<=2147483281
  self.calls.append(dict(index=i,path=path,slot=slot,mu=mu,sigma=sigma,result=r,active=int(active)))
  return r
 def inner(self,tree,base,t0,t1,path):
  if len(t0)==1:
   sigma=tree[base];r1=sub(t1[0],of(self.sample(t1[0],mul(IW,sigma),path,1)));rx=half(r1)
   r0=add(t0[0],rx);r0=sub(r0,of(self.sample(r0,sigma,path,0)));r0=sub(r0,rx)
   return [r0],[r1]
  n=len(t0);lg=n.bit_length()-1;x0,x1=self.deep_split(t1)
  y0,y1=self.inner(tree,base+n+lg*(n//2),x0,x1,path+'R');z1=self.deep_merge(y0,y1)
  corr=self.polymul(z1,tree[base:base+n]);mid=list(map(add,corr,t0));x0,x1=self.deep_split(mid)
  y0,y1=self.inner(tree,base+n,x0,x1,path+'L');z0=self.deep_merge(y0,y1)
  return list(map(sub,z0,self.polymul(z1,tree[base:base+n]))),z1
 def depth1(self,tree,base,t0,t1,t2,path):
  n=len(t0);lg=n.bit_length()-1;size=lg*(n//2);start=base+3*n
  y0,y1=self.inner(tree,start+2*size,*self.deep_split(t2),path+'2');z2=self.deep_merge(y0,y1)
  mid=list(map(add,self.polymul(z2,tree[base+2*n:base+3*n]),t1))
  y0,y1=self.inner(tree,start+size,*self.deep_split(mid),path+'1');z1=self.deep_merge(y0,y1)
  z1=list(map(sub,z1,self.polymul(z2,tree[base+2*n:base+3*n])))
  mid=list(map(add,t0,self.polymul(z1,tree[base:base+n])));mid=list(map(add,mid,self.polymul(z2,tree[base+n:base+2*n])))
  y0,y1=self.inner(tree,start,*self.deep_split(mid),path+'0');z0=self.deep_merge(y0,y1)
  z0=list(map(sub,z0,self.polymul(z1,tree[base:base+n])));z0=list(map(sub,z0,self.polymul(z2,tree[base+n:base+2*n])))
  return z0,z1,z2
 def top(self,tree,t0,t1):
  n=len(t0);logn=(2*n//3).bit_length()-1;dsize=3*((logn+1)*(1<<(logn-2)))
  out=self.depth1(tree,n+dsize,*self.top_split(t1),'R');z1=self.top_merge(*out)
  mid=list(map(add,self.polymul(z1,tree[:n]),t0));out=self.depth1(tree,n,*self.top_split(mid),'L');z0=self.top_merge(*out)
  return list(map(sub,z0,self.polymul(z1,tree[:n]))),z1
def normalize_layout(logn=10):
 offsets=[]
 def inner(base,l):
  if l==1:offsets.extend([base+2,base+3]);return 4
  s=1<<l;s+=inner(base+s,l-1);s+=inner(base+s,l-1);return s
 def dep(base,l):
  s=3<<l
  for _ in range(3):s+=inner(base+s,l-1)
  return s
 s=3<<(logn-1)
 for _ in range(2):s+=dep(s,logn-1)
 return s,offsets
