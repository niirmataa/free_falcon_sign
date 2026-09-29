"""Independent QQ projected-H checks and rigorous complex-ball exact split/LDL."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField,ComplexBallField
from dyadic import value
from node_model import split_point,node_point
from root_model import tables
from replaylib import sha
W=Path.cwd();R=RealBallField(256);C=ComplexBallField(256);pi=R.pi();u=QQ(1)/2**48
cert=json.loads((W/'artifacts/numeric_certificate.json').read_text());tab=tables(W)
def val(w):
 z=value(w);return QQ(z.numerator)/z.denominator
def pair(z):return val(z[0]),val(z[1])
def cm(a,b):return a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0]
def conj(a):return a[0],-a[1]
def norm2(a):return a[0]**2+a[1]**2
def norm_le(a,E):return norm2(a)<=E*E
def diff(a,b):return a[0]-b[0],a[1]-b[1]
def exact_split(v,j):
 e=cert['split_map']['child_exponents'][j];t=2*pi*e/4608;x=C(t.cos(),t.sin());w=C(-R(1)/2,R(3).sqrt()/2)
 A,B,D=v
 return [(A+B+D)/3,(A+w*w*B+w*D)*x.conjugate()/3,(A+w*B+w*w*D)*(x.conjugate()**2)/3]
def exact_ldl(t):
 h=t[0].real();b=t[1].conjugate();c=t[2].conjugate();l10=b/h;l20=c/h
 d1=h-(b*b.conjugate()).real()/h;n=b-c*b.conjugate()/h;l21=n/d1
 d2=h-(c*c.conjugate()).real()/h-(l21*l21.conjugate()).real()*d1
 return [t[0],b,c,C(d1),C(d2),l10,l20,l21]
summaries=[]
for branch in [0,1]:
 c=cert['constants'][branch];lam=QQ(c['comparison_eigen_lower']);s=QQ(c['comparison_entry_error']);ds=QQ(c['split_rounding_norm_error'])
 v=[int(x,16) for x in (W/'checks'/f'branch{branch}_input.txt').read_text().split()]
 rows=[[int(x,16) for x in l.split()] for l in (W/'checks'/f'branch{branch}_normal.txt').read_text().splitlines()]
 maxD1=QQ(0);maxD2=QQ(0);maxIm=QQ(0)
 for j in range(256):
  tri=[(v[3*j+k],v[768+3*j+k]) for k in range(3)];t=split_point(tri,j,tab);out=node_point(t)
  assert out==[(rows[j][k],rows[j+256][k]) for k in range(8)]
  # Exact scalar references of the native input words, independent of bit transducers.
  h,tau=pair(out[0]);b=pair(out[1]);z=pair(out[2]);B2=norm2(b);Z2=norm2(z)
  d1=h-B2/h;q2=h-Z2/h;cb=cm(z,conj(b));n=(b[0]-cb[0]/h,b[1]-cb[1]/h)
  ell=(n[0]/d1,n[1]/d1);d2=q2-norm2(n)/d1
  assert h>lam and d1>lam and d2>lam
  assert B2<=h*h and Z2<=h*h and norm2(ell)<9
  assert abs(q2-d1)<=4*s
  l10=(b[0]/h,b[1]/h);l20=(z[0]/h,z[1]/h)
  assert norm_le(diff(pair(out[5]),l10),2*u) and norm_le(diff(pair(out[6]),l20),2*u)
  assert norm_le(diff(pair(out[7]),ell),1024*u*h/d1)
  er1=abs(val(out[3][0])-d1);er2=abs(val(out[4][0])-d2)
  assert er1<=64*u*h and er2<=65536*u*h
  assert abs(val(out[3][1]))<=abs(tau)+64*u*h and abs(val(out[4][1]))<=abs(tau)+65536*u*h
  maxD1=max(maxD1,er1);maxD2=max(maxD2,er2);maxIm=max(maxIm,abs(val(out[3][1])),abs(val(out[4][1])))
  sourcev=[C(*pair(z)) for z in tri];realv=[C(val(z[0])) for z in tri]
  split_source_exact=exact_split(sourcev,j);split_real_exact=exact_split(realv,j);reference=exact_ldl(split_real_exact)
  for a,e in zip(t,split_source_exact):assert abs(C(*pair(a))-e)<R(ds)
  errorFields=['t0_error_norm','split_to_exact_reference_error','split_to_exact_reference_error','d11_error_norm','d22_error_norm','L10_L20_error_norm','L10_L20_error_norm','L21_error_norm']
  for a,e,k in zip(out,reference,errorFields):assert abs(C(*pair(a))-e)<R(QQ(c[k]))
  assert val(out[0][0])>=QQ(c['t0_real_lower'])
  for k in [3,4]:assert QQ(c['d11_real_lower'])<=val(out[k][0])<QQ(c['diagonal_real_upper'])
  for k,cap in [(5,2),(6,2),(7,4)]:assert norm2(pair(out[k]))<cap*cap
 summaries.append(dict(branch=branch,all_frequencies=256,projected_H_pivots_checked=True,split_and_independent_reference_checked=True,
  max_real_D11_round_error=str(maxD1),max_real_D22_round_error=str(maxD2),max_imag_observed=str(maxIm)))
out=dict(status='PASS_QQ_RBF_ORACLE_CONTROLS',branches=summaries,frequency_cases=512,output_complex_values=4096,host_double_used=False,
 scope='Public synthetic envelope instances, not emitted/P_key witnesses. Universal proof is analytic plus exact parameter certificate.',
 inputs={f'checks/branch{b}_normal.txt':sha(W/'checks'/f'branch{b}_normal.txt') for b in [0,1]})
(W/'artifacts/oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
