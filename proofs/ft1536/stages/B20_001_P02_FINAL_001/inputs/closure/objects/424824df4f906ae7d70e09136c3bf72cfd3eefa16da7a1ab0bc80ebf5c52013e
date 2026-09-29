"""Literal source order split_top/Adj/LDL_dim3. Imaginary words remain present."""
from backend import add,sub,mul,div,neg,of,ca,cs,cm,cq,conj
from root_model import tables
from dyadic import value,rn
INV3=div(of(1),of(3))
def split_point(v,j,tab,ideal_third=False):
 _,cubic,(_,w2,w4)=tab;A,B,C=v;x=conj(cubic[512+j])
 B1=cm(B,w4);B2=cm(B,w2);C1=cm(C,w4);C2=cm(C,w2)
 t0=ca(A,ca(B,C));t1=cm(x,ca(ca(B1,C2),A));x=cq(x);t2=cm(x,ca(ca(B2,C1),A))
 if ideal_third:return [tuple(rn(value(z)/3,zero_sign=z>>63) for z in t) for t in [t0,t1,t2]]
 return [tuple(mul(z,INV3) for z in t) for t in [t0,t1,t2]]
def dc(z,a):return div(z[0],a[0]),div(z[1],a[0])
def cn(z):return neg(z[0]),neg(z[1])
def node_point(t,trace=False):
 a,b,c=t[0],conj(t[1]),conj(t[2]);h=value(a[0])
 if not 0<h:raise ValueError('STOP_BEFORE_FIRST_DIVISOR')
 if not (1<=16*h and h<=2**35):raise ValueError('STOP_BEFORE_FIRST_DIVISOR_DOMAIN')
 L10=dc(b,a);p11=cm(b,conj(L10));D11=ca(cn(p11),a)
 if not 0<value(D11[0]):raise ValueError('STOP_BEFORE_SECOND_DIVISOR')
 if not (1<=16*value(D11[0]) and value(D11[0])<=2**35):raise ValueError('STOP_BEFORE_SECOND_DIVISOR_DOMAIN')
 L20=dc(c,a);p21=cm(c,conj(b));q21=dc(p21,a);n21=ca(cn(q21),b);L21=dc(n21,D11)
 p20=cm(L20,conj(c));q2=ca(cn(p20),a)
 norm=(add(mul(L21[0],L21[0]),mul(L21[1],L21[1])),of(0))
 tmp=(mul(norm[0],D11[0]),mul(norm[1],D11[0]));D22=cs(q2,tmp)
 out=[a,b,c,D11,D22,L10,L20,L21]
 if trace:return out,dict(p11=p11,p21=p21,q21=q21,n21=n21,p20=p20,q2=q2,norm=norm,tmp=tmp)
 return out
def slice_words(v,tab):
 assert len(v)==1536;out=[[] for _ in range(8)];imag=[[] for _ in range(8)]
 for j in range(256):
  triple=[(v[3*j+k],v[768+3*j+k]) for k in range(3)]
  vals=node_point(split_point(triple,j,tab))
  for k,z in enumerate(vals):out[k].append(z[0]);imag[k].append(z[1])
 return [a+b for a,b in zip(out,imag)]
