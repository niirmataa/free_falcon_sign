"""Guarded literal transducers: finite controls stop before out-of-certificate C domains."""
from fractions import Fraction as Q
import literal_backend as raw
from dyadic import value
counts={}
def scalar(x):
 if not isinstance(x,int) or not 0<=x<2**64 or ((x>>52)&2047)==2047:raise ValueError('STOP_NONFINITE_WORD')
 v=value(x)
 if abs(v)>2**100:raise ValueError('STOP_SCALAR_CAP')
 return v
def binary(name,x,y):
 scalar(x);v=scalar(y)
 if name=='div' and not Q(1,16)<=v<=2**35:raise ValueError('STOP_BEFORE_DIV_DOMAIN')
 z=getattr(raw,name)(x,y)
 if ((z>>52)&2047)==2047:raise ValueError('STOP_NONFINITE_OUTPUT')
 counts[name]=counts.get(name,0)+1
 return z
def add(x,y):return binary('add',x,y)
def sub(x,y):return binary('sub',x,y)
def mul(x,y):return binary('mul',x,y)
def div(x,y):return binary('div',x,y)
def neg(x):scalar(x);return raw.neg(x)
def of(x):
 if not -2**31<=x<2**31:raise ValueError('STOP_OF_INT32')
 return raw.of(x)
def double(x):
 scalar(x);z=raw.double(x);scalar(z);return z
def ca(a,b):return add(a[0],b[0]),add(a[1],b[1])
def cs(a,b):return sub(a[0],b[0]),sub(a[1],b[1])
def cm(a,b):return sub(mul(a[0],b[0]),mul(a[1],b[1])),add(mul(a[0],b[1]),mul(a[1],b[0]))
def cq(a):return sub(mul(a[0],a[0]),mul(a[1],a[1])),double(mul(a[0],a[1]))
def conj(a):return a[0],neg(a[1])
def cv(a):return value(a[0]),value(a[1])
