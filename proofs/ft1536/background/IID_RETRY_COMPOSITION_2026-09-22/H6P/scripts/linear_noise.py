"""Exact-real source-L operator, RBF-enclosed; independent forward and transposed maps."""
from sage.all import QQ,RealBallField,ComplexBallField
from dyadic import value
class NoiseMap:
 def __init__(self,tree,basis,precision=256):
  self.R=RealBallField(precision);self.C=ComplexBallField(precision);self.tree=tree;self.basis=basis;self.pi=self.R.pi();self.s3=self.R(3).sqrt();self.cache={};self.pos=0;self.leaves=[]
  self.roots=[1+6*self.rev(j,8)+1536*k for j in range(256) for k in range(3)]
 def rev(self,x,k):return int(format(x,'0'+str(k)+'b')[::-1],2) if k else 0
 def real(self,w):q=value(w);return self.R(QQ(q.numerator)/q.denominator)
 def phase(self,den,num):
  key=(den,num%den)
  if key not in self.cache:
   a=2*self.pi*key[1]/den;self.cache[key]=self.C(a.cos(),a.sin())
  return self.cache[key]
 def L(self,off,n):return [self.C(self.real(self.tree[off+j]),self.real(self.tree[off+n//2+j])) for j in range(n//2)]
 def B(self,col):
  off=1536*col;return [self.C(self.real(self.basis[off+j]),self.real(self.basis[off+768+j])) for j in range(768)]
 def merge(self,a,b,k):
  n=2**k
  if k==1:return [a[0]+self.phase(6,1)*b[0]]
  out=[]
  for j in range(n//4):
   p=self.phase(3*n,1+6*self.rev(j,k-2));out += [a[j]+p*b[j],a[j]-p*b[j]]
  return out
 def merge_adjoint(self,row,k):
  n=2**k
  if k==1:return [row[0].real()],[(row[0]*self.phase(6,1)).real()]
  a=[];b=[]
  for j in range(n//4):
   p=self.phase(3*n,1+6*self.rev(j,k-2));a.append(row[2*j]+row[2*j+1]);b.append(p*(row[2*j]-row[2*j+1]))
  return a,b
 def topmerge(self,a,b,c):
  out=[]
  for j in range(256):
   for k in range(3):
    p=self.phase(4608,1+6*self.rev(j,8)+1536*k);out.append(a[j]+p*b[j]+p*p*c[j])
  return out
 def top_adjoint(self,row):
  a=[];b=[];c=[]
  for j in range(256):
   pp=[self.phase(4608,1+6*self.rev(j,8)+1536*k) for k in range(3)];rr=row[3*j:3*j+3]
   a.append(sum(rr));b.append(sum(rr[k]*pp[k] for k in range(3)));c.append(sum(rr[k]*pp[k]*pp[k] for k in range(3)))
  return [a,b,c]
 def inner(self,k,tr,xi):
  if not k:
   paired,stored=xi[self.pos:self.pos+2];self.leaves.append((self.pos,tr));self.pos+=2
   return [self.C(stored-paired/2)],[self.C(paired)]
  n=2**k;right=self.inner(k-1,tr+n+k*2**(k-1),xi);r1=self.merge(*right,k);left=self.inner(k-1,tr+n,xi);u0=self.merge(*left,k)
  return [a-b*l for a,b,l in zip(u0,r1,self.L(tr,n))],r1
 def depth(self,tr,xi):
  u={}
  for j in [2,1,0]:u[j]=self.merge(*self.inner(8,tr+1536+2304*j,xi),9)
  r2=u[2];r1=[a-b*l for a,b,l in zip(u[1],r2,self.L(tr+1024,512))]
  r0=[a-b*l-c*m for a,b,c,l,m in zip(u[0],r1,r2,self.L(tr,512),self.L(tr+512,512))]
  return r0,r1,r2
 def forward(self,xi):
  assert len(xi)==3072;xi=[self.R(x) for x in xi];self.pos=0;self.leaves=[]
  y=self.topmerge(*self.depth(9984,xi));u=self.topmerge(*self.depth(1536,xi));x=[a-b*l for a,b,l in zip(u,y,self.L(0,1536))];assert self.pos==3072
  return [[a*c+b*d for a,b,c,d in zip(x,y,self.B(j),self.B(j+2))] for j in range(2)]
 def inner_adjoint(self,k,tr,row0,row1):
  if not k:return [(row1[0]-row0[0]/2).real(),row0[0].real()]
  n=2**k;right=[b-a*l for a,b,l in zip(row0,row1,self.L(tr,n))]
  return self.inner_adjoint(k-1,tr+n+k*2**(k-1),*self.merge_adjoint(right,k))+self.inner_adjoint(k-1,tr+n,*self.merge_adjoint(row0,k))
 def depth_adjoint(self,tr,rows):
  a,b,c=rows;e0=a;e1=[bb-aa*l for aa,bb,l in zip(a,b,self.L(tr,512))]
  e2=[cc-aa*l-bb*m for aa,bb,cc,l,m in zip(a,e1,c,self.L(tr+512,512),self.L(tr+1024,512))];ee=[e0,e1,e2]
  out=[]
  for j in [2,1,0]:out += self.inner_adjoint(8,tr+1536+2304*j,*self.merge_adjoint(ee[j],9))
  return out
 def inverse_row(self,r):
  k=r%768;factor=self.C(1,1/self.s3)/768 if r<768 else self.C(0,-2/self.s3)/768
  return [factor*self.phase(4608,-p*k) for p in self.roots]
 def row(self,component,r):
  f=self.inverse_row(r);a=self.B(component);b=self.B(component+2);L=self.L(0,1536)
  u=[w*x for w,x in zip(f,a)];y=[w*(yy-l*xx) for w,xx,yy,l in zip(f,a,b,L)]
  return self.depth_adjoint(9984,self.top_adjoint(y))+self.depth_adjoint(1536,self.top_adjoint(u))
 def inverse_direct(self,f,r):return sum(w*x for w,x in zip(self.inverse_row(r),f)).real()
 def inverse_fast(self,f):
  a=list(f)
  for j in range(256):
   A,B,C=a[3*j:3*j+3];p=self.phase(4608,-(1+6*self.rev(j,8)));w=self.phase(3,1)
   a[3*j:3*j+3]=[A+B+C,p*(A+w*w*B+w*C),p*p*(A+w*B+w*w*C)]
  t=6;m=256
  while t<1536:
   for j in range(m//2):
    p=self.phase(6*m,-(1+6*self.rev(j,m.bit_length()-2)))
    for k in range(j*t,j*t+t//2):A=a[k];B=a[k+t//2];a[k]=A+B;a[k+t//2]=p*(A-B)
   t*=2;m//=2
  return [(z.real()-z.imag()/self.s3)/768 for z in a]+[(2*z.imag()/self.s3)/768 for z in a]
