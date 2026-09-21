"""Independent rigorous complex-ball polynomial evaluations and exact dyadic stage checks."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField,ComplexBallField
from dyadic import value
from replaylib import sha
W=Path.cwd();R=RealBallField(256);C=ComplexBallField(256);pi=R.pi();cert=json.loads((W/'artifacts/numeric_certificate.json').read_text())
def ball(w):
 x=value(w);return R(QQ(x.numerator)/x.denominator)
maxerr=R(0);count=0;witness=None
unit_roots={}
def at(e):
 e%=4608
 if e not in unit_roots:
  t=2*pi*e/4608;unit_roots[e]=C(t.cos(),t.sin())
 return unit_roots[e]
for case,slots in [(0,list(range(768))),(1,[0,1,2,7,31,255,511,767])]:
 polys=[list(map(int,s.split())) for s in (W/'checks'/f'polys_{case}.txt').read_text().splitlines()]
 rows=[[int(x,16) for x in s.split()] for s in (W/'checks'/f'polys_{case}_normal.txt').read_text().splitlines()]
 for i in slots:
  e=cert['fft_map']['roots'][i];theta=2*pi*e/4608;z=C(theta.cos(),theta.sin());vals=[]
  for k,p in enumerate(polys):
   if case==0:exact=sum((int(v)*z**j for j,v in enumerate(p) if v),C(0))
   else:exact=sum((int(v)*at(e*j) for j,v in enumerate(p) if v),C(0))
   idx=[1,0,3,2][k];sign=-1 if k in [0,2] else 1
   actual=C(sign*ball(rows[i][idx]),sign*ball(rows[i+768][idx]));delta=actual-exact
   allowance=R(QQ(1)/2**(26 if k<2 else 15))
   assert abs(delta.real())<allowance and abs(delta.imag())<allowance,dict(case=case,slot=i,poly=k,root=e,actual=str(actual),exact=str(exact),error=str(delta),allowance=str(allowance))
   maxerr=max(maxerr,abs(delta.real()),abs(delta.imag()));count+=2;vals.append(exact)
   if witness is None and (not delta.real().contains_zero() or not delta.imag().contains_zero()):
    witness=dict(kind='omit_FFT_error',case=case,slot=i,polynomial=k,real_error=str(delta.real()),imaginary_error=str(delta.imag()),mutated_allowance='0')
  f,g,F,G=vals;A=(f*f.conjugate()+g*g.conjugate()).real();J=(F*F.conjugate()+G*G.conjugate()).real();X=G*g.conjugate()+F*f.conjugate()
  assert abs(ball(rows[i][4])-A)<R(QQ(1)/1024)
  assert abs(ball(rows[i][6])-J)<1024
  c=C(ball(rows[i][5]),ball(rows[i+768][5]));err=c-X
  assert abs(err)<1
assert witness is not None
out=dict(status='PASS_RIGOROUS_ORACLE_CONTROLS',checked_FFT_components=count,full_sparse_slots=768,dense_slots=8,
 max_component_error_RBF256=str(maxerr),mutation=witness,host_double_used=False,
 scope='Finite binding controls; full-domain bounds follow the universal analytic proof and symbolic all-coefficient map.',
 inputs={f'checks/polys_{k}_normal.txt':sha(W/'checks'/f'polys_{k}_normal.txt') for k in [0,1]})
(W/'artifacts/oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
