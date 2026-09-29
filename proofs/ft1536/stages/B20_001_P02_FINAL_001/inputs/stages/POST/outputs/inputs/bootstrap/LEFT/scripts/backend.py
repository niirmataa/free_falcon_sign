"""Literal active FPEMU with source-domain preflight and the portable sqrt54 loop."""
from fractions import Fraction as Q
import literal_backend as raw
from fp_literal import u64,pack
from dyadic import value
from half_model import half
U=Q(1,2**48);ETA=Q(1,2**900)
def finite(x):
 if not isinstance(x,int) or not 0<=x<2**64 or ((x>>52)&2047)==2047:raise ValueError('STOP_NONFINITE_WORD')
 return value(x)
def scalar(x):
 v=finite(x)
 if abs(v)>2**100:raise ValueError('STOP_OPERAND_CAP')
 return v
def op(name,x,y):
 scalar(x);v=scalar(y)
 if name=='div' and not Q(1,2**16)<=v<=2**80:raise ValueError('STOP_EXTENDED_DIV_DOMAIN')
 z=getattr(raw,name)(x,y);finite(z);return z
def add(x,y):return op('add',x,y)
def sub(x,y):return op('sub',x,y)
def mul(x,y):return op('mul',x,y)
def div(x,y):return op('div',x,y)
def neg(x):finite(x);return raw.neg(x)
def of(x):
 if not -2**31<=x<2**31:raise ValueError('STOP_OF_INT32')
 return raw.of(x)
def double(x):
 v=scalar(x);z=raw.double(x);finite(z)
 if v and not ((x>>52)&2047):raise ValueError('STOP_DOUBLE_SUBNORMAL')
 return z
def sqrt(x,trace=False):
 v=finite(x);ex=(x>>52)&2047
 if v<0 or (ex==0 and v!=0):raise ValueError('STOP_SQRT_NORMAL_DOMAIN')
 xu=(x&((1<<52)-1))|(1<<52);e=ex-1023;xu+=xu&u64(-(e&1));e>>=1;xu<<=1
 target=xu*(1<<53);q=s=0;r=1<<53;states=[]
 for i in range(54):
  assert s==2*q and target==q*q+r*xu and q*q<=target<(q+2*r)**2
  assert q+2*r<=2**54 and xu<2**56 and s+r<2**56
  t=s+r;b=u64((u64(xu-t)>>63)-1)
  assert (b==2**64-1)==(xu>=t)
  s+=(r<<1)&b;xu-=t&b;q+=r&b;xu<<=1;r>>=1
  if trace:states.append(dict(i=i,q=q,s=s,r=r,xu=xu))
 assert q*q<=target<(q+1)**2 and xu==2*(target-q*q) and 2**53<=q<2**54
 mant=(q<<1)|((xu|u64(-xu))>>63);mant&=u64(-((ex+2047)>>11));z=pack(0,e-54,mant);finite(z)
 if trace:return z,dict(target=target,q=q,residual=xu,packed_mantissa=mant,e=e-54,states=states)
 return z
def ca(a,b):return add(a[0],b[0]),add(a[1],b[1])
def cs(a,b):return sub(a[0],b[0]),sub(a[1],b[1])
def cm(a,b):return sub(mul(a[0],b[0]),mul(a[1],b[1])),add(mul(a[0],b[1]),mul(a[1],b[0]))
def cq(a):return sub(mul(a[0],a[0]),mul(a[1],a[1])),double(mul(a[0],a[1]))
def conj(a):return a[0],neg(a[1])
def cv(a):return value(a[0]),value(a[1])
