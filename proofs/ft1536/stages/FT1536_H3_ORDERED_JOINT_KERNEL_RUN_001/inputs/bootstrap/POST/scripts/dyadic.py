"""Independent exact IEEE dyadic interpretation and integer RN-even oracle."""
from fractions import Fraction as F
from math import isqrt
MASK=(1<<64)-1
def value(bits):
 s=bits>>63;e=(bits>>52)&2047;f=bits&((1<<52)-1)
 if e==2047:raise ValueError('nonfinite')
 if e==0:return (-1 if s else 1)*F(f,1<<1074)
 m=(1<<52)+f;k=e-1075
 return (-1 if s else 1)*F(m*(1<<k),1) if k>=0 else (-1 if s else 1)*F(m,1<<(-k))
def floorlog(v):
 assert v>0
 k=v.numerator.bit_length()-v.denominator.bit_length()
 if v<(F(1<<k) if k>=0 else F(1,1<<-k)):k-=1
 return k
def roundint(v):
 n,r=divmod(v.numerator,v.denominator)
 return n+int(2*r>v.denominator or (2*r==v.denominator and n%2))
def rn(v,zero_sign=0):
 v=F(v)
 if v==0:return zero_sign<<63
 s=int(v<0);v=abs(v);k=floorlog(v);shift=max(k-52,-1074)
 scaled=v/(F(1<<shift) if shift>=0 else F(1,1<<-shift));m=roundint(scaled)
 if m==0:return s<<63
 if k< -1022:
  return (s<<63)+m
 if m==(1<<53):m>>=1;k+=1
 if k>1023:return (s<<63)|(2047<<52)
 return (s<<63)|((k+1023)<<52)|(m-(1<<52))
def sqrt_rn(v):
 v=F(v);assert v>=0
 if not v:return 0
 k=floorlog(v)//2;shift=max(k-52,-1074)
 scale=F(1<<(2*shift)) if shift>=0 else F(1,1<<(-2*shift));w=v/scale
 m=isqrt(w.numerator//w.denominator)
 midpoint=F((2*m+1)**2,4)
 if w>midpoint or (w==midpoint and m%2):m+=1
 if k< -1022:return m
 if m==(1<<53):m>>=1;k+=1
 return ((k+1023)<<52)|(m-(1<<52))
def floor_bits(x):
 e=(x>>52)&2047;t=x>>63
 xi=(((x<<10)&MASK)|(1<<62))&((1<<63)-1)
 xi=-xi if t else xi;cc=1085-e
 xi >>= cc&63
 return -t if ((63-cc)&0xffffffff)>>31 else xi
def floor_parts(x):
 e=(x>>52)&2047;f=x&((1<<52)-1);s=x>>63;assert e<=1053
 cc=1085-e;m=(1<<62)+(f<<10)
 return -s if cc>=64 else (-m if s else m)//(1<<cc)
def fraction_json(v):return dict(n=str(v.numerator),d=str(v.denominator))
