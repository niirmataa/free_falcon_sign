"""Additional literal active-C FPEMU transducers; no host float arithmetic."""
from fp_literal import add,sub,of,pack,u64,u32
from dyadic import value
def neg(x):return x^(1<<63)
def double(x):return u64(x+(((((x>>52)&2047)+2047)>>11)<<52))
def mul(x,y):
 xu=(x&((1<<52)-1))|(1<<52);yu=(y&((1<<52)-1))|(1<<52)
 x0=xu&0x1ffffff;x1=xu>>25;y0=yu&0x1ffffff;y1=yu>>25
 w=x0*y0;z0=w&0x1ffffff;z1=w>>25
 w=x0*y1;z1+=w&0x1ffffff;z2=w>>25
 w=x1*y0;z1+=w&0x1ffffff;z2+=w>>25
 zu=x1*y1;z2+=z1>>25;z1&=0x1ffffff;zu+=z2
 zu|=((z0|z1)+0x1ffffff)>>25
 zv=(zu>>1)|(zu&1);w=zu>>55;zu^=(zu^zv)&u64(-w)
 ex=(x>>52)&2047;ey=(y>>52)&2047;e=ex+ey-2100+w;s=(x^y)>>63
 d=((ex+2047)&(ey+2047))>>11;zu&=u64(-d)
 return pack(s,e,zu)
def div(x,y):
 xu=(x&((1<<52)-1))|(1<<52);yu=(y&((1<<52)-1))|(1<<52);q=0
 for _ in range(55):
  b=u64((u64(xu-yu)>>63)-1);xu-=b&yu;q|=b&1;xu<<=1;q<<=1
 q|=(xu|u64(-xu))>>63;q2=(q>>1)|(q&1);w=q>>55;q^=(q^q2)&u64(-w)
 ex=(x>>52)&2047;ey=(y>>52)&2047;e=ex-ey-55+w;s=(x^y)>>63;d=(ex+2047)>>11
 return pack(s&d,e&-d,q&u64(-d))
def ca(a,b):return add(a[0],b[0]),add(a[1],b[1])
def cs(a,b):return sub(a[0],b[0]),sub(a[1],b[1])
def cm(a,b):return sub(mul(a[0],b[0]),mul(a[1],b[1])),add(mul(a[0],b[1]),mul(a[1],b[0]))
def cq(a):return sub(mul(a[0],a[0]),mul(a[1],a[1])),double(mul(a[0],a[1]))
def conj(a):return a[0],neg(a[1])
def cv(a):return value(a[0]),value(a[1])
