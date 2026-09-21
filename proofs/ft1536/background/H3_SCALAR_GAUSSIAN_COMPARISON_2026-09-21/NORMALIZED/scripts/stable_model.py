"""Source-ordered stable computation, sticky flags, raw sequence and leaf-only writes."""
import json
from pathlib import Path
from backend import add,mul,div,half,double,sqrt,neg,of,scalar
from dyadic import value
from root_model import fft,tables
MIN=0x4090000053700377;MAX=0x4114444d1a037d50;ONE=0x3ff0000000000000
IW1I=0x3ff279a74590331c;Q2=339775489;SIGMA=0x4088000000000000
def positive(x):return (x>>63)==0 and ((x>>52)&2047)!=2047 and (x&0x7fffffffffffffff)!=0
class Stable:
 def __init__(self,mutation=None):self.bad=0;self.events=[];self.mutation=mutation
 def pos(self,x):
  ok=positive(x);self.bad|=int(not ok);return x if ok else ONE
 def op(self,name,x,y=0):
  fn={'+':add,'*':mul,'/':div,'h':half,'d':double,'s':sqrt}[name]
  z=fn(x) if name in ['h','d','s'] else fn(x,y)
  self.events.append(f'{name} {x:016x} {y:016x} {z:016x}');return z
 def binary(self,values):
  n=len(values)
  if n==1:return [self.pos(values[0])]
  assert n in [2,4,8,16,32,64,128,256];a=[];b=[]
  for i in range(0,n,2):
   x=self.pos(values[i]);y=self.pos(values[i+1]);s=self.pos(self.op('+',x,y));p=self.pos(self.op('*',x,y))
   a.append(self.pos(self.op('h',s)));b.append(self.pos(self.op('/',self.op('d',p),s)))
  return self.binary(a)+self.binary(b)
 def roots(self,roots):
  assert len(roots)==1536;v=list(roots);top=[[],[],[]]
  for i in range(768):
   ok=positive(v[i]) and v[i]>=0x3fe0000000000000;self.bad|=int(not ok);v[i]=v[i] if ok else ONE
   if value(v[i])>2**23:raise ValueError('STOP_ROOT_UPPER_DOMAIN')
  three=of(3)
  for i in range(0,768,3):
   a,b,c=[self.pos(z) for z in v[i:i+3]]
   e1=self.pos(self.op('+',self.op('+',a,b),c));ab=self.pos(self.op('*',a,b));ac=self.pos(self.op('*',a,c));bc=self.pos(self.op('*',b,c))
   e2=self.pos(self.op('+',self.op('+',ab,ac),bc));abc=self.pos(self.op('*',ab,c))
   top[0].append(self.pos(self.op('/',e1,three)));top[1].append(self.pos(self.op('/',e2,e1)));top[2].append(self.pos(self.op('/',self.op('*',three,abc),e2)))
  leaves=[]
  for row in top:leaves+=self.binary(row)
  primary=list(leaves);leaves += [0]*768
  for i in range(768):
   dest=768+i if self.mutation=='reciprocal_forward' else 1535-i
   leaves[dest]=self.pos(self.op('/',of(Q2),leaves[i]))
  for i in range(1536):
   leaves[i]=self.pos(leaves[i]);ok=MIN<=leaves[i]<=MAX
   if self.mutation=='gate_off_by_one':ok=MIN<leaves[i]<=MAX
   self.bad|=int(not ok)
  return leaves,self.bad==0,primary
def recompute_roots(root,polys,keygen=False):
 if len(polys)!=2 or any(len(p)!=1536 for p in polys):raise ValueError('STOP_COEFFICIENT_LENGTH')
 if any(not -2047<=x<=2047 for p in polys for x in p):raise ValueError('STOP_COEFFICIENT_CAP')
 f,g=[fft([of(x) for x in p],tables(root)) for p in polys]
 if keygen:f=[neg(x) for x in f]
 def norm(v):return [add(mul(v[i],v[i]),mul(v[i+768],v[i+768])) for i in range(768)]+[0]*768
 f,g=norm(f),norm(g)
 return [add(x,y) for x,y in zip(g,f)] if keygen else [add(x,y) for x,y in zip(f,g)]
def normalize(leaves,sk,model,root,permutation=False):
 mapping=json.loads((Path(root)/'inputs/bootstrap/RAW/LEAF_MAP.json').read_text())['entries'];assert len(mapping)==len(leaves)==1536
 out=list(sk);reads=[]
 for i,r in enumerate(mapping):
  d=leaves[i];z=model.op('/',SIGMA,model.op('s',d));where=mapping[1535-i]['sk_index'] if permutation else r['sk_index'];out[where]=z;reads.append([i,where,d,z])
 return out,reads
def sigma_only(s):
 pair=mul(IW1I,s)
 d0=div(ONE,mul(mul(s,s),of(2)));d1=div(ONE,mul(mul(pair,pair),of(2)))
 return s,pair,d0,d1
def initial_sk():return [0x3ff0000000000000+(i*104729)%2**52 for i in range(24576)]
def gate_single(x,bad=0,strict=False,reset=False):
 ok=positive(x);bad|=int(not ok);y=x if ok else ONE
 if reset:bad=0
 bad|=int(not ((MIN<y if strict else MIN<=y) and y<=MAX));return y,bad,int(bad==0)
