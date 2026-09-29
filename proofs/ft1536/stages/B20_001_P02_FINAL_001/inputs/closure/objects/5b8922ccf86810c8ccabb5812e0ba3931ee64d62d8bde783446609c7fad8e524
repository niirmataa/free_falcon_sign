"""Independent QQ/RBF references, all 2*3*128 positions; no host double."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField,ComplexBallField
from dyadic import value
from replaylib import sha
W=Path.cwd();R=RealBallField(256);C=ComplexBallField(256);pi=R.pi();u=QQ(1)/2**48
cert=json.loads((W/'artifacts/numeric_certificate.json').read_text())
def v(w):
 q=value(w);return QQ(q.numerator)/q.denominator
def pair(rows,f,k):return (v(rows[f][k]),v(rows[f+128][k]))
def cn(q):return C(q[0],q[1])
def norm2(q):return q[0]*q[0]+q[1]*q[1]
summaries=[]
for branch in [0,1]:
 root=[int(x,16) for x in (W/'checks'/f'root{branch}_input.txt').read_text().split()]
 ref=[[] for _ in range(3)]
 for j in range(256):
  a,b,c=[v(root[3*j+i]) for i in range(3)];e1=a+b+c;e2=a*b+a*c+b*c
  for k,x in enumerate([e1/3,e2/e1,3*a*b*c/e2]):ref[k].append(x)
 for k in range(3):
  row=cert['constants'][3*branch+k];m=QQ(row['input_real_lower']);I=QQ(row['input_imag_abs_upper']);lam=QQ(row['comparison_eigen_lower']);ds=QQ(row['split_rounding_norm_error'])
  src=[int(x,16) for x in (W/'checks'/f'parent_{branch}_{k}.txt').read_text().split()]
  out=[[int(x,16) for x in l.split()] for l in (W/'checks'/f'node_{branch}_{k}_normal.txt').read_text().splitlines()]
  maxround=QQ(0);maximag=QQ(0);minpair=None
  for f in range(128):
   ra,rb=v(src[2*f]),v(src[2*f+1]);ta,tb=v(src[2*f+256]),v(src[2*f+257])
   assert ra>=m and rb>=m and abs(ta)<=I and abs(tb)<=I
   margin=ra*rb-(ta-tb)**2/4;assert margin>=m*m-I*I>0
   minpair=margin if minpair is None else min(minpair,margin)
   e=cert['map']['child_exponents'][f];theta=2*pi*e/1536;z=C(theta.cos(),theta.sin())
   s0exact=(C(ra,ta)+C(rb,tb))/2;s1exact=(C(ra,ta)-C(rb,tb))*z.conjugate()/2
   a=pair(out,f,0);b=pair(out,f,1);l=pair(out,f,2);d=pair(out,f,3);h,tau=a
   assert abs(cn(a)-s0exact)<R(ds) and abs(cn(b)-s1exact.conjugate())<R(ds)
   assert h>lam and norm2(b)<(h-lam)**2
   ideal=h-norm2(b)/h;lr=(b[0]/h,b[1]/h)
   assert norm2((l[0]-lr[0],l[1]-lr[1]))<=(2*u)**2
   err=abs(d[0]-ideal);assert err<=64*u*h and abs(d[1]-tau)<=64*u*h
   assert QQ(row['d11_real_lower'])<d[0]<QQ(row['d11_real_upper']) and norm2(l)<4
   assert abs(tau)<=QQ(row['s0_imag_abs_upper']) and abs(d[1])<=QQ(row['d11_imag_abs_upper'])
   maxround=max(maxround,err);maximag=max(maximag,abs(d[1]))
   A,B=ref[k][2*f],ref[k][2*f+1];href=(A+B)/2;Lref=z*(A-B)/(A+B);Dref=2*A*B/(A+B)
   assert abs(cn(a)-C(href))<R(QQ(row['split_error_to_exact_reference']))
   assert abs(cn(l)-Lref)<R(QQ(row['L_error_norm'])) and abs(cn(d)-C(Dref))<R(QQ(row['d11_error_norm']))
  summaries.append(dict(branch=branch,diagonal=k,frequencies=128,exact_pair_margin_min=str(minpair),max_real_round_error=str(maxround),max_imag=str(maximag)))
out=dict(status='PASS_INDEPENDENT_QQ_RBF_ORACLE',frequency_cases=768,complex_outputs=3072,cases=summaries,host_double_used=False,
 scope='Synthetic refined-envelope instances; not P_key or emitted membership. Independent exact Node3 diagonal references and actual half/split pairs checked.',
 inputs={f'checks/node_{b}_{k}_normal.txt':sha(W/'checks'/f'node_{b}_{k}_normal.txt') for b in [0,1] for k in range(3)})
(W/'artifacts/oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
