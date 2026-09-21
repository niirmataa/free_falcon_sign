from backend import add,sub,mul,div,neg,ca,cs,cm,conj
from half_model import half
from dyadic import value,rn
def split_pair(a,b,f,tab,ideal_half=False):
 square,_,_=tab;total=ca(a,b);diff=cs(a,b);rot=cm(diff,conj(square[256+f]))
 op=(lambda x:rn(value(x)/2,zero_sign=x>>63)) if ideal_half else half
 return tuple(op(x) for x in total),tuple(op(x) for x in rot)
def dim2(a,b,trace=False):
 h=value(a[0])
 if not (1<=16*h and h<=2**35):raise ValueError('STOP_BEFORE_DIV_DOMAIN')
 L=(div(b[0],a[0]),div(b[1],a[0]));prod=cm(b,conj(L));D=ca((neg(prod[0]),neg(prod[1])),a)
 if trace:return [a,b,L,D],dict(product=prod)
 return [a,b,L,D]
def point(a,b,f,tab):
 s0,s1=split_pair(a,b,f,tab);return dim2(s0,conj(s1))
def slice_words(v,tab):
 assert len(v)==512;out=[[] for _ in range(4)];imag=[[] for _ in range(4)]
 for f in range(128):
  a=(v[2*f],v[2*f+256]);b=(v[2*f+1],v[2*f+1+256])
  for i,z in enumerate(point(a,b,f,tab)):out[i].append(z[0]);imag[i].append(z[1])
 return [x+y for x,y in zip(out,imag)]
