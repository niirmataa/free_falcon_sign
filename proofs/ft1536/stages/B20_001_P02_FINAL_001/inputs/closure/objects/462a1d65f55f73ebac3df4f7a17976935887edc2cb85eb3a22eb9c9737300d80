"""Source-order recursive inner model, including its real base leaf stores."""
from backend import ca,cs,cm,conj
from half_model import half
from node2_model import dim2
def split(v,q,tab):
 assert 2<=q<=9 and len(v)==2**q
 square,_,_=tab;hn=len(v)//2;qn=hn//2;a=[];ai=[];b=[];bi=[]
 for j in range(qn):
  x=(v[2*j],v[2*j+hn]);y=(v[2*j+1],v[2*j+1+hn]);s=ca(x,y);d=cm(cs(x,y),conj(square[hn+j]))
  z0=(half(s[0]),half(s[1]));z1=conj((half(d[0]),half(d[1])))
  a.append(z0[0]);ai.append(z0[1]);b.append(z1[0]);bi.append(z1[1])
 return a+ai,b+bi
def local(a,b):
 assert len(a)==len(b);hn=len(a)//2;L=[];Li=[];D=[];Di=[]
 for j in range(hn):
  out=dim2((a[j],a[j+hn]),(b[j],b[j+hn]));L.append(out[2][0]);Li.append(out[2][1]);D.append(out[3][0]);Di.append(out[3][1])
 return L+Li,D+Di
def tree_size(k):return (k+1)*2**k
def build(k,a,b,tab,offset=0,tmp=0,aref=('A',0),bref=('B',0),path=''):
 assert 1<=k<=7 and len(a)==len(b)==2**k
 n=2**k;events=[];nodes=[]
 if k>1:
  events.append(['S',k,'S',tmp,'S',tmp+n//2,aref[0],aref[1]])
  x,y=split(a,k,tab)
  first,e0,n0=build(k-1,x,y,tab,offset+n,tmp+n,('S',tmp),('S',tmp+n//2),path+'0')
  events+=e0;nodes+=n0
 # The local operation is deliberately after the first recursive call.
 L,D=local(a,b);events.append(['N',k,offset])
 nodes.append(dict(level=k,path=path,offset=offset,a=a,b=b,L=L,D=D))
 if k==1:
  events.append(['B',offset,a[0],D[0]])
  return L+[a[0],D[0]],events,nodes
 events.append(['S',k,'S',tmp,'S',tmp+n//2,'S',tmp+n])
 x,y=split(D,k,tab);second,e1,n1=build(k-1,x,y,tab,offset+n+tree_size(k-1),tmp+n,('S',tmp),('S',tmp+n//2),path+'1')
 return L+first+second,events+e1,nodes+n1
