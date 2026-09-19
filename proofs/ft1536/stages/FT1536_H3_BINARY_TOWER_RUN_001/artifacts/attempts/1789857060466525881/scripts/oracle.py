"""Independent all-level QQ/RBF references and numerical mutation witnesses."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField,ComplexBallField
from backend import div,conj,cm,cs
from half_model import half
from tower_model import split
from root_model import tables
from node_model import slice_words as node3_slice
from node2_model import slice_words as level8_slice,dim2
from dyadic import value,rn
from replaylib import sha
W=Path.cwd();RBF=RealBallField(256);CB=ComplexBallField(256);pi=RBF.pi();U=QQ(1)/2**48
cert=json.loads((W/'artifacts/numeric_certificate.json').read_text());params={(r['branch'],r['diagonal'],r['path']):r for r in cert['nodes']}
nodes=json.loads((W/'checks/nodes_normal.json').read_text());lookup={(r['branch'],r['diagonal'],r['path']):r for r in nodes};assert set(lookup)==set(params)
def val(w):
 q=value(w);return QQ(q.numerator)/q.denominator
def pair(a,j):return val(a[j]),val(a[j+len(a)//2])
def norm2(z):return z[0]*z[0]+z[1]*z[1]
def bits(z):return [f'{w:016x}' for w in z]
def ref_step(v):
 a=[(v[2*j]+v[2*j+1])/2 for j in range(len(v)//2)]
 d=[2*v[2*j]*v[2*j+1]/(v[2*j]+v[2*j+1]) for j in range(len(v)//2)]
 return a,d
def br(j,b):return int(format(j,'0'+str(b)+'b')[::-1],2) if b else 0
reference={};source_base={};tab=tables(W)
for b in [0,1]:
 raw=[int(s,16) for s in (W/'checks'/f'root{b}_input.txt').read_text().split()];r3=[[],[],[]]
 for j in range(256):
  a,c,d=[val(raw[3*j+k]) for k in range(3)];e1=a+c+d;e2=a*c+a*d+c*d
  for k,z in enumerate([e1/3,e2/e1,3*a*c*d/e2]):r3[k].append(z)
 s3=node3_slice(raw,tab)
 for k in range(3):
  reference[(b,k,'')]=ref_step(r3[k]);s8=level8_slice(s3[[0,3,4][k]],tab);source_base[(b,k)]=(s8[0],s8[3])
  for depth in range(1,8):
   for n in range(2**depth):
    path=format(n,'0'+str(depth)+'b');parent=reference[(b,k,path[:-1])][int(path[-1])]
    reference[(b,k,path)]=ref_step(parent)
mut={};counts={l:0 for l in range(1,8)};maxRound={l:QQ(0) for l in range(1,8)}
def witness(kind,actual,bad,r,j):
 if actual!=bad and kind not in mut:mut[kind]=dict(branch=r['branch'],diagonal=r['diagonal'],path=r['path'],slot=j,actual=str(actual),mutant=str(bad))
for r in nodes:
 b,k,w,l=r['branch'],r['diagonal'],r['path'],r['level'];p=params[(b,k,w)];hn=2**(l-1)
 if len(w)==1:parent=source_base[(b,k)][int(w[-1])]
 else:upnode=lookup[(b,k,w[:-1])];parent=upnode['a' if w[-1]=='0' else 'D']
 Rp=reference[(b,k,w[:-1])][int(w[-1])];refs=reference[(b,k,w)]
 for j in range(hn):
  m,M,Im=[QQ(p['input'][key]) for key in ['m','M','I']]
  ra,rb=val(parent[2*j]),val(parent[2*j+1]);ta,tb=val(parent[2*j+len(parent)//2]),val(parent[2*j+1+len(parent)//2])
  assert m<=ra<=M and m<=rb<=M and abs(ta)<=Im and abs(tb)<=Im
  margin=ra*rb-(ta-tb)**2/4;assert margin>0
  a=pair(r['a'],j);c=pair(r['b'],j);lc=pair(r['L'],j);dc=pair(r['D'],j);h,tau=a
  eig=QQ(p['eigen_lower']);assert h>eig and norm2(c)<(h-eig)**2
  ideal=h-norm2(c)/h;er=abs(dc[0]-ideal);assert er<=64*U*h and abs(dc[1]-tau)<=64*U*h
  maxRound[l]=max(maxRound[l],er);assert norm2(lc)<4
  assert norm2((lc[0]-c[0]/h,lc[1]-c[1]/h))<=(2*U)**2
  for i,z in enumerate([a,dc]):
   o=p['outputs'][i];assert QQ(o['m'])<=z[0]<=QQ(o['M']) and abs(z[1])<=QQ(o['I'])
   assert norm2((z[0]-refs[i][j],z[1]))<=QQ(o['E'])**2
  e=1+6*br(j,l-1);angle=2*pi*e/(3*2**(l+1));x=CB(angle.cos(),angle.sin())
  Lref=x*(Rp[2*j]-Rp[2*j+1])/(Rp[2*j]+Rp[2*j+1])
  assert abs(CB(*lc)-Lref)<RBF(QQ(p['L_error_to_exact']))
  counts[l]+=1
  witness('omit_imaginary_difference',margin,ra*rb,r,j)
  witness('omit_rounding',dc[0],ideal,r,j)
  witness('ideal_harmonic_pivot',r['D'][j],rn(2*ra*rb/(ra+rb)),r,j)
  actual=(r['L'][j],r['L'][j+hn]);bad=(div(r['b'][j],r['a'][j]),div(r['b'][j+hn]^(1<<63),r['a'][j]))
  witness('wrong_Adj',bits(actual),bits(bad),r,j)
  if h>2**23:mut.setdefault('old_ROOT_div_domain',dict(actual_h=str(h),old_upper='8388608',new_proved_upper='2^35'))
  if hn>1 and 'wrong_twiddle_or_packed_index' not in mut:
   pa=(parent[2*j],parent[2*j+len(parent)//2]);pb=(parent[2*j+1],parent[2*j+1+len(parent)//2])
   rot=cm(cs(pa,pb),conj(tab[0][2**l+(j+1)%hn]));badc=conj((half(rot[0]),half(rot[1])))
   badL=(div(badc[0],r['a'][j]),div(badc[1],r['a'][j]));witness('wrong_twiddle_or_packed_index',bits(actual),bits(badL),r,j)
assert all(c==768 for c in counts.values())
assert {'omit_imaginary_difference','omit_rounding','ideal_harmonic_pivot','wrong_Adj','old_ROOT_div_domain','wrong_twiddle_or_packed_index'}<=set(mut)
out=dict(status='PASS_ALL_LEVEL_QQ_RBF_ORACLE',positions_per_level=counts,total_positions=sum(counts.values()),nodes=len(nodes),max_source_round_error={str(k):str(v) for k,v in maxRound.items()},
 numerical_mutations=mut,reference='Independent exact Node3 diagonals, then recursively exact binary arithmetic; never source projected words.',
 host_double_used=False,scope='Finite binding controls, not key membership or the universal induction by themselves.',input_sha256=sha(W/'checks/nodes_normal.json'))
(W/'artifacts/oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='numerical_mutations'},indent=2))
