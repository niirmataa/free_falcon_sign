"""Source-order FFT3/Gram/root dim2, all 1536 physical slots."""
import re
from pathlib import Path
from backend import add,sub,mul,div,neg,of,ca,cs,cm,cq,conj
def tables(root):
 text=(Path(root)/'source/fpr-emulated.h').read_text()
 def arr(n):
  block=re.search(r'static const fpr '+n+r'\[\] = \{(.*?)\n\};',text,re.S).group(1)
  return [(int(a,16),int(b,16)) for a,b in re.findall(r'FPC\(0x([0-9a-fA-F]{16})ULL,\s*0x([0-9a-fA-F]{16})ULL\)',block)]
 def c(n):return int(re.search(r'static const fpr '+n+r' = 0x([0-9a-fA-F]{16})ULL;',text).group(1),16)
 return arr('fpr_gm3_square'),arr('fpr_gm3_cubic'),[(c('fpr_W'+s+'R'),c('fpr_W'+s+'I')) for s in ['1','2','4']]
def fft(a,tab):
 square,cubic,(w1,w2,w4)=tab;n=len(a);assert n==1536;hn=n//2;a=list(a)
 for i in range(hn):
  x,y=a[i],a[i+hn];a[i]=add(x,mul(y,w1[0]));a[i+hn]=mul(y,w1[1])
 def get(i):return a[i],a[i+hn]
 def put(i,v):a[i],a[i+hn]=v
 t=hn;m=2
 while t>3:
  ht=t//2
  for j in range(m//2):
   for i in range(j*t,j*t+ht):
    x=get(i);y=cm(get(i+ht),square[m+j]);put(i,ca(x,y));put(i+ht,cs(x,y))
  t=ht;m*=2
 for i in range(0,hn,3):
  A,B,C=get(i),get(i+1),get(i+2);x=cubic[512+i//3]
  B0=cm(B,x);B1=cm(B0,w2);B2=cm(B0,w4);x=cq(x)
  C0=cm(C,x);C1=cm(C0,w2);C2=cm(C0,w4)
  for k,b,c in [(0,B0,C0),(1,B1,C2),(2,B2,C1)]:put(i+k,ca(A,ca(b,c)))
 return a
def root_point(a,c_re,c_im,j,j_im=0):
 L=(div(c_re,a),div(c_im,a));p=cm((c_re,c_im),conj(L));D=(add(neg(p[0]),j),add(neg(p[1]),j_im))
 return L,D
def gram_root(polys,tab):
 f,g,F,G=[fft([of(int(x)) for x in p],tab) for p in polys];n=1536;hn=768
 b=[g,[neg(x) for x in f],G,[neg(x) for x in F]]
 gram=[[],[],[]];imag=[[],[],[]];Lr=[];Li=[];Dr=[];Di=[]
 for i in range(hn):
  a0,a1,b0,b1=[(p[i],p[i+hn]) for p in b]
  norm=lambda x:add(mul(x[0],x[0]),mul(x[1],x[1]))
  A=add(norm(a0),norm(a1));C=ca(cm(b0,conj(a0)),cm(b1,conj(a1)));J=add(norm(b0),norm(b1))
  for k,v in enumerate([(A,0),C,(J,0)]):gram[k].append(v[0]);imag[k].append(v[1])
  l,d=root_point(A,*C,J);Lr.append(l[0]);Li.append(l[1]);Dr.append(d[0]);Di.append(d[1])
 return b+[x+y for x,y in zip(gram,imag)]+[Lr+Li,Dr+Di]
