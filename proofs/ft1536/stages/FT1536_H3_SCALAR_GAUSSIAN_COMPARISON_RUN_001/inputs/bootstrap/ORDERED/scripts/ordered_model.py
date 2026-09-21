"""Source ordered sampling recursion with initialized-memory and scripted outcome observations."""
import json
from fractions import Fraction as F
from pathlib import Path
from backend import add,sub,mul,div,neg,of,half,ca,cs,cm,cq,conj,scalar
from root_model import tables
from fp_literal import floor as oldfloor
from dyadic import value
N=1536;T=10752;K=18432;MARK=0x5a5a5a5a5a5a5a5a;IW=0x3ff279a74590331c
COE=[0x3fb999999999999a,0x3f9999999999999a,0x3f7999999999999a,0x3f5999999999999a,0x3f45555555555555];SUP=[29,59,118,235,365]
def at(p,n):return p[0],p[1]+n
def size(k,f):return (1+2*f)*2**(k-f)
def numeric(w):return ((w>>52)&2047)<2047 and -2147483283<=value(w)<2147483282
def sigma_bank(w):
 dss=div(of(1),mul(mul(w,w),of(2)))
 if w>>63 or value(w)<=0:raise ValueError('STOP_WIDTH_DOMAIN')
 return next((i for i,c in enumerate(COE) if dss>=c),None)
class Stop(Exception):pass
class Machine:
 def __init__(self,root,tree,t0,t1,tape,mutation=None):
  self.tab=tables(root);self.mem={'K':list(tree),'T':[MARK]*T};self.init={'K':[True]*K,'T':[False]*T};self.events=[];self.high=3072;self.call=0;self.fault=0;self.tape=tape;self.mutation=mutation;self.calls=[];self.repeated=[]
  self.write(('T',0),t0);self.write(('T',N),t1)
 def read(self,p,n):
  tag,i=p
  if tag not in self.mem or i<0 or i+n>len(self.mem[tag]) or not all(self.init[tag][i:i+n]):raise ValueError('STOP_UNINITIALIZED_OR_BOUNDS')
  return self.mem[tag][i:i+n]
 def write(self,p,x):
  tag,i=p
  if tag!='T' or i<0 or i+len(x)>T:raise ValueError('STOP_WRITE_FRAME')
  self.mem[tag][i:i+len(x)]=x;self.init[tag][i:i+len(x)]=[True]*len(x);self.high=max(self.high,i+len(x))
 def emit(self,name,k,f,ps,outs):
  self.events.append(f'P {name} {k} {f} {len(ps)} '+' '.join(f'{p[0]} {p[1]}' for p in ps)+f' {len(outs)}')
  for out in outs:self.events.append('V '+str(len(out))+' '+' '.join(f'{x:016x}' for x in out))
 def copy(self,a,b,n):x=self.read(b,n);self.write(a,x);self.emit('COPY',n,0,[a,b],[x])
 def op(self,name,a,b,k,f):
  n=size(k,f);x=self.read(a,n);y=self.read(b,n);hn=n//2
  if name in ['ADD','SUB']:z=[(add if name=='ADD' else sub)(v,w) for v,w in zip(x,y)]
  elif name=='MUL':
   p=[cm((x[i],x[i+hn]),(y[i],y[i+hn])) for i in range(hn)];z=[a for a,b in p]+[b for a,b in p]
  else:raise ValueError(name)
  self.write(a,z);self.emit(name,k,f,[a,b],[z])
 def split(self,a,b,v,k,c=None):
  full=c is not None;n=size(k,full);x=self.read(v,n);hn=n//2
  if full:
   _,cub,(_,w2,w4)=self.tab;re=[[],[],[]];im=[[],[],[]];third=div(of(1),of(3))
   for j in range(256):
    A,B,C=[(x[3*j+i],x[768+3*j+i]) for i in range(3)];phase=conj(cub[512+j]);B1=cm(B,w4);B2=cm(B,w2);C1=cm(C,w4);C2=cm(C,w2)
    r=[ca(A,ca(B,C)),cm(phase,ca(ca(B1,C2),A)),cm(cq(phase),ca(ca(B2,C1),A))]
    for h,p in enumerate(r):re[h].append(mul(p[0],third));im[h].append(mul(p[1],third))
   outs=[r+i for r,i in zip(re,im)];ps=[a,b,c,v];dest=[a,b,c]
  elif k==1:
   xx=mul(IW,x[1]);outs=[[sub(x[0],half(xx))],[xx]]
   if self.mutation=='omit_split1':outs=[[x[0]],[x[1]]]
   ps=[a,b,v];dest=[a,b]
  else:
   sq,_,_=self.tab;re=[[],[]];im=[[],[]]
   for i in range(n//4):
    A=(x[2*i],x[2*i+hn]);B=(x[2*i+1],x[2*i+1+hn]);s=ca(A,B);d=cm(cs(A,B),conj(sq[hn+i]))
    for j,p in enumerate([s,d]):re[j].append(half(p[0]));im[j].append(half(p[1]))
   outs=[r+i for r,i in zip(re,im)];ps=[a,b,v];dest=[a,b]
  for p,x in zip(dest,outs):self.write(p,x)
  self.emit('TOPSPLIT' if full else 'SPLIT',k,int(full),ps,outs)
 def merge(self,out,a,b,k,c=None):
  full=c is not None;n=size(k,full);hn=n//2
  if full:
   A=self.read(a,512);B=self.read(b,512);C=self.read(c,512);_,cub,(_,w2,w4)=self.tab;z=[0]*n
   for j in range(256):
    x=cub[512+j];av=(A[j],A[j+256]);bv=(B[j],B[j+256]);cv=(C[j],C[j+256]);b0=cm(bv,x);b1=cm(b0,w2);b2=cm(b0,w4);c0=cm(cv,cq(x));c1=cm(c0,w2);c2=cm(c0,w4)
    for h,(bv,cv) in enumerate([(b0,c0),(b1,c2),(b2,c1)]):p=ca(av,ca(bv,cv));z[3*j+h]=p[0];z[3*j+h+768]=p[1]
   ps=[out,a,b,c]
  elif k==1:
   x=self.read(a,1)[0];y=self.read(b,1)[0];w1=self.tab[2][0];z=[add(x,mul(y,w1[0])),mul(y,w1[1])];ps=[out,a,b]
  else:
   A=self.read(a,hn);B=self.read(b,hn);sq,_,_=self.tab;z=[0]*n
   for i in range(n//4):
    av=(A[i],A[i+n//4]);bv=(B[i],B[i+n//4]);p=cm(bv,sq[hn+i]);x=ca(av,p);y=cs(av,p);z[2*i],z[2*i+hn]=x;z[2*i+1],z[2*i+1+hn]=y
   ps=[out,a,b]
  self.write(out,z);self.emit('TOPMERGE' if full else 'MERGE',k,int(full),ps,[z])
 def scalarop(self,name,x,y=0):
  z={'A':lambda:add(x,y),'S':lambda:sub(x,y),'M':lambda:mul(x,y),'H':lambda:half(x),'O':lambda:of(x)}[name]()
  self.events.append(f'Q {name} {x if name=="O" else format(x,"016x")} {y:016x} {z:016x}');return z
 def callback(self,mu,sigma):
  i=self.call;self.call+=1;tag,k,b,stutters=self.tape[i]
  self.events.append(f'C {i} {mu:016x} {sigma:016x} {self.fault}')
  row=dict(index=i,mu=f'{mu:016x}',sigma=f'{sigma:016x}',fault_before=self.fault,tag=tag,k=k,b=b,stutters=stutters)
  if self.fault:row['outcome']='STICKY_FAULT_RETURN';self.events.append(f'R {i} B 0');self.calls.append(row);return 0
  if not numeric(mu):row['outcome']='PRE_FLOOR_DOMAIN_STOP';self.calls.append(row);raise Stop('PRE_FLOOR_DOMAIN_STOP')
  bank=sigma_bank(sigma)
  if bank is None:raise ValueError('STOP_BANK_DOMAIN')
  row['bank']=bank
  for j in range(stutters):self.events.append(f'J {i} {j}')
  if tag=='S':
   row['outcome']='REJECTION_NONRETURN';self.calls.append(row);self.events.append(f'STOP {i}')
   if self.mutation=='nonreturn_as_zero':return 0
   raise Stop('REJECTION_NONRETURN')
  if tag=='F':
   self.fault=1;row['outcome']='FAULT_RETURN';self.calls.append(row);self.events.append(f'R {i} F 0')
   return oldfloor(mu) if self.mutation=='fault_as_close' else 0
  if tag!='N' or not 0<=k<=SUP[bank] or b not in [0,1]:raise ValueError('STOP_CALLBACK_RETURN_RELATION')
  sample=oldfloor(mu)+(1+k if b else -k);assert -2**31<=sample<2**31
  row.update(outcome='NORMAL_RETURN',sample=sample);self.calls.append(row);self.events.append(f'R {i} N {sample}');return sample
 def inner(self,z0,z1,tr,t0,t1,k,tmp):
  if k==0:
   sigma=self.read(tr,1)[0];old0=self.read(t0,1)[0];mu1=self.read(t1,1)[0]
   s1=self.scalarop('M',IW,sigma);v1=self.callback(mu1,s1);r1=self.scalarop('S',mu1,self.scalarop('O',v1));rx=self.scalarop('H',r1)
   if self.mutation=='late_snapshot':old0=r1
   mu0=self.scalarop('A',old0,rx);v0=self.callback(old0 if self.mutation=='stale_mu0' else mu0,sigma)
   r0=self.scalarop('S',mu0,self.scalarop('O',v0))
   if self.mutation!='omit_final_sub':r0=self.scalarop('S',r0,rx)
   self.write(z0,[r0]);self.write(z1,[r1]);return
  n=2**k;hn=n//2;y0=tmp;y1=at(tmp,hn);tree0=at(tr,n);tree1=at(tree0,k*2**(k-1))
  if self.mutation=='wrong_child_order':tree0,tree1=tree1,tree0
  self.split(z1,at(z1,hn),t1,k);self.inner(y0,y1,tree1,z1,at(z1,hn),k-1,at(tmp,n));self.merge(z1,y0,y1,k)
  self.copy(tmp,z1,n);self.op('MUL',tmp,tr,k,0);product=self.read(tmp,n);self.op('ADD',tmp,t0,k,0)
  self.split(z0,at(z0,hn),tmp,k);self.inner(y0,y1,tree0,z0,at(z0,hn),k-1,at(tmp,n));self.merge(z0,y0,y1,k)
  self.copy(tmp,z1,n);self.op('MUL',tmp,tr,k,0);assert product==self.read(tmp,n);self.repeated.append(dict(kind='inner',level=k,tree=tr[1],words=n));self.op('SUB',z0,tmp,k,0)
 def depth(self,z0,z1,z2,tr,t0,t1,t2,k,tmp):
  n=2**k;hn=n//2;y0=tmp;y1=at(tmp,hn);tree0=at(tr,3*n);tree1=at(tree0,k*2**(k-1));tree2=at(tree1,k*2**(k-1))
  self.split(z2,at(z2,hn),t2,k);self.inner(y0,y1,tree2,z2,at(z2,hn),k-1,at(tmp,n));self.merge(z2,y0,y1,k)
  self.copy(tmp,z2,n);self.op('MUL',tmp,at(tr,2*n),k,0);p21=self.read(tmp,n);self.op('ADD',tmp,t1,k,0)
  self.split(z1,at(z1,hn),tmp,k);self.inner(y0,y1,tree1,z1,at(z1,hn),k-1,at(tmp,n));self.merge(z1,y0,y1,k)
  self.copy(tmp,z2,n);self.op('MUL',tmp,at(tr,2*n),k,0);assert p21==self.read(tmp,n);self.op('SUB',z1,tmp,k,0)
  self.copy(z0,t0,n);self.copy(tmp,z1,n);self.op('MUL',tmp,tr,k,0);p10=self.read(tmp,n);self.op('ADD',z0,tmp,k,0)
  self.copy(tmp,z2,n);self.op('MUL',tmp,at(tr,n),k,0);p20=self.read(tmp,n);self.op('ADD',z0,tmp,k,0)
  self.copy(tmp,z0,n);self.split(z0,at(z0,hn),tmp,k);self.inner(y0,y1,tree0,z0,at(z0,hn),k-1,at(tmp,n));self.merge(z0,y0,y1,k)
  self.copy(tmp,z1,n);self.op('MUL',tmp,tr,k,0);assert p10==self.read(tmp,n);self.op('SUB',z0,tmp,k,0)
  self.copy(tmp,z2,n);self.op('MUL',tmp,at(tr,n),k,0);assert p20==self.read(tmp,n);self.op('SUB',z0,tmp,k,0);self.repeated.append(dict(kind='cubic_three',level=k,tree=tr[1],words=3*n))
 def top(self):
  z0=('T',3072);z1=('T',4608);t0=('T',0);t1=('T',1536);tmp=('T',6144);tr=('K',0)
  first_branch=9984;second_branch=1536
  if self.mutation=='wrong_root_order':z0,z1=z1,z0;t0,t1=t1,t0;first_branch,second_branch=second_branch,first_branch
  x=[at(z1,512*i) for i in range(3)];y=[at(tmp,512*i) for i in range(3)]
  self.split(x[0],x[1],t1,10,x[2]);self.depth(*y,at(tr,first_branch),*x,9,at(tmp,N));self.merge(z1,*y[:2],10,y[2])
  self.copy(tmp,z1,N);self.op('MUL',tmp,tr,10,1);product=self.read(tmp,N);self.op('ADD',tmp,t0,10,1)
  x=[at(z0,512*i) for i in range(3)];self.split(x[0],x[1],tmp,10,x[2]);self.depth(*y,at(tr,second_branch),*x,9,at(tmp,N));self.merge(z0,*y[:2],10,y[2])
  self.copy(tmp,z1,N);self.op('MUL',tmp,tr,10,1);assert product==self.read(tmp,N);self.repeated.append(dict(kind='root',level=10,tree=tr[1],words=N));self.op('SUB',z0,tmp,10,1)
 def run(self,mode='top'):
  stopped='COMPLETED'
  try:
   if mode=='top':self.top()
   else:self.inner(('T',3072),('T',4608),('K',0),('T',0),('T',1536),0,('T',6144))
  except Stop as e:stopped=str(e)
  return dict(status=stopped,calls=self.call,fault=self.fault,high_water=self.high,pre_floor=sum(r['fault_before']==0 for r in self.calls))
