"""Raw source tree plus literal positive stable sequence on public Gram fixtures."""
from backend import add,sub,mul,div,neg,of,sqrt,half,double,cm,ca,conj
from root_model import tables
from node_model import slice_words
from tower_model import split,local
from dyadic import value
def words(z):return [x for x,y in z]+[y for x,y in z]
def dim2(a,c,j):
 n=len(a);hn=n//2;L=[];D=[]
 for i in range(hn):
  h=a[i];l=(div(c[i],h),div(c[i+hn],h));p=cm((c[i],c[i+hn]),conj(l));d=ca((neg(p[0]),neg(p[1])),(j[i],j[i+hn]));L.append(l);D.append(d)
 return words(L),words(D)
def raw_tree(root,gram):
 tab=tables(root);A,C,J=gram;records=[]
 def inner(k,a,b,off,path):
  n=2**k
  if k>1:
   x,y=split(a,k,tab);left=inner(k-1,x,y,off+n,path+'0')
  L,D=local(a,b);assert all(value(x)>0 for x in a[:n//2]+D[:n//2]);records.append(dict(kind='binary',level=k,offset=off,path=path,input0=a,input1=b,L=L,D=D))
  if k==1:return L+[a[0],D[0]]
  x,y=split(D,k,tab);right=inner(k-1,x,y,off+n+k*2**(k-1),path+'1');return L+left+right
 def depth(v,off,branch):
  z=slice_words(v,tab);a,b,c,d,e,l10,l20,l21=z
  records.append(dict(kind='cubic',offset=off,branch=branch,parent=v,a=a,b=b,c=c,d=d,e=e,L10=l10,L20=l20,L21=l21))
  out=l10+l20+l21
  for k,v in enumerate([a,d,e]):
   x,y=split(v,9,tab);out+=inner(8,x,y,off+1536+k*2304,f'{branch}{k}')
  return out
 left=depth(A,1536,0);L,D=dim2(A,C,J);right=depth(D,9984,1)
 return L+left+right,D,records
def stable(rootA):
 assert len(rootA)==1536 and all(value(x)>=value(of(1))/2 for x in rootA[:768]);three=of(3)
 def binary(v):
  if len(v)==1:return v
  a=[];b=[]
  for i in range(0,len(v),2):
   x,y=v[i:i+2];s=add(x,y);p=mul(x,y);a.append(half(s));b.append(div(double(p),s))
  return binary(a)+binary(b)
 blocks=[[],[],[]]
 for i in range(0,768,3):
  a,b,c=rootA[i:i+3];e1=add(add(a,b),c);ab=mul(a,b);ac=mul(a,c);bc=mul(b,c);e2=add(add(ab,ac),bc);abc=mul(ab,c)
  for dst,z in zip(blocks,[div(e1,three),div(e2,e1),div(mul(three,abc),e2)]):dst.append(z)
 out=sum([binary(b) for b in blocks],[]);return out+[div(of(18433**2),x) for x in reversed(out)]
def normalized(raw,D,mapping):
 tree=list(raw)
 for r,d in zip(mapping,D):tree[r['tree_index']]=div(of(768),sqrt(d))
 return tree
