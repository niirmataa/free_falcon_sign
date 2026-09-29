"""Independent exact dyadic products and direct polynomial/root RBF evaluations."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,PolynomialRing,RealBallField,ComplexBallField
from dyadic import value
from replaylib import sha
W=Path.cwd();D=W/'checks/data';cert=json.loads((W/'artifacts/numeric_certificate.json').read_text());fixtures=json.loads((W/'artifacts/fixtures.json').read_text())['fixtures']
R=RealBallField(256);C=ComplexBallField(256);P=PolynomialRing(ZZ,'X');X=P.gen();phi=X**1536-X**768+1;roots=cert['map']['roots'];pi=R.pi()
zs=[C((2*pi*r/4608).cos(),(2*pi*r/4608).sin()) for r in roots];cache={};results=[]
def ev(coeff):
 key=tuple(coeff)
 if key not in cache:
  p=P(coeff);cache[key]=[p(z) for z in zs]
 return cache[key]
def qv(w):
 v=value(w);return QQ(v.numerator)/v.denominator
def pair(words,i):return qv(words[i]),qv(words[i+768])
def product(a,b):return a[0]*b[0]-a[1]*b[1],a[0]*b[1]+a[1]*b[0]
for f in fixtures:
 name=f['name'];meta=json.loads((D/(name+'.meta.json')).read_text());sn=json.loads((D/(name+'.snapshots.json')).read_text());c=meta['canonical_challenge'];bw=meta['basis_words'];assert len(c)==1536 and all(0<=x<=18432 for x in c)
 ec=ev(c);p=meta['coefficients'];ef=ev(p[0]) if p else None;eF=ev(p[2]) if p else None
 # Exact coefficient product/remainder; these fixtures explicitly have determinant0.
 coefs={}
 if p:
  coefs['t0']=list((-(P(c)*P(p[2]))).mod(phi));coefs['t1']=list((P(c)*P(p[0])).mod(phi))
  for key in coefs:coefs[key]+=[0]*(1536-len(coefs[key]));assert len(coefs[key])==1536
 vals=[];observed={'fft':R(0),'rounding_t0':QQ(0),'rounding_t1':QQ(0),'ideal_t0':R(0),'ideal_t1':R(0)}
 for i in range(768):
  cv=pair(sn['fft_c'],i);ce=C(*cv)-ec[i];EC=QQ(cert['fft']['challenge_component_error_outward']);assert abs(ce.real())<R(EC) and abs(ce.imag())<R(EC)
  observed['fft']=max(observed['fft'],abs(ce.real()),abs(ce.imag()));row=dict(slot=i,root=roots[i],fft_error_real=str(ce.real()),fft_error_imag=str(ce.imag()))
  for rec in cert['targets']:
   key=rec['target'];off=4608 if key=='t0' else 1536;bv=pair(bw[off:off+1536],i);z=product(cv,bv);sg=1 if key=='t0' else -1;reference=(sg*z[0]/18433,sg*z[1]/18433);actual=pair(sn[key],i)
   dr,di=actual[0]-reference[0],actual[1]-reference[1];error2=dr*dr+di*di;er=QQ(rec['rounding_only_error_outward']);assert error2<er*er
   observed['rounding_'+key]=max(observed['rounding_'+key],error2)
   assert actual[0]**2+actual[1]**2<QQ(rec['source_modulus_and_component_upper'])**2
   row[key]=dict(rounded_reference_real=str(reference[0]),rounded_reference_imag=str(reference[1]),rounding_error_squared=str(error2))
   if p:
    ref=-ec[i]*eF[i]/18433 if key=='t0' else ec[i]*ef[i]/18433;err=C(*actual)-ref;bound=R(QQ(rec['ideal_reference_error_outward']));assert abs(err)<bound
    be=C(*bv)-(-eF[i] if key=='t0' else -ef[i]);eb=R(QQ(cert['fft']['basis_error_F' if key=='t0' else 'basis_error_f']));assert abs(be.real())<eb and abs(be.imag())<eb
    observed['ideal_'+key]=max(observed['ideal_'+key],abs(err));row[key].update(ideal_reference_real=str(ref.real()),ideal_reference_imag=str(ref.imag()),ideal_error_norm=str(abs(err)))
  vals.append(row)
 norms={}
 if p:
  for rec in cert['targets']:
   key=rec['target'];v=[QQ(x)/18433 for x in coefs[key]];B=QQ(rec['exact_coefficient_abs_upper']);assert all(abs(x)<=B for x in v)
   l2=sum(x*x for x in v);Qphi=l2+sum(v[j]*v[j+768] for j in range(768));assert l2<=1536*B*B and 0<=Qphi<=2304*B*B
   # Different reference route: evaluate actual Phi remainder at every physical root.
   rp=P(coefs[key]);refs=[rp(z)/18433 for z in zs]
   for i,ref in enumerate(refs):
    direct=-ec[i]*eF[i]/18433 if key=='t0' else ec[i]*ef[i]/18433;gap=ref-direct;assert gap.real().contains_zero() and gap.imag().contains_zero()
   norms[key]=dict(coefficient_linf=str(max(abs(x) for x in v)),l2_squared=str(l2),Phi_quadratic=str(Qphi))
 out=D/(name+'.oracle.json');out.write_text(json.dumps(dict(name=name,slots=vals,coefficient_norms=norms,observed_maxima={k:str(v) for k,v in observed.items()},membership=meta['membership']),indent=2)+'\n')
 results.append(dict(name=name,positions=768,rounding_reference_exact_dyadic=True,ideal_direct_polynomial_reference=bool(p),oracle_sha256=sha(out),observed_maxima={k:str(v) for k,v in observed.items()}));print(json.dumps(dict(oracle_case=name,status='PASS')),flush=True)
out=dict(status='PASS_INDEPENDENT_DYADIC_AND_DIRECT_ROOT_ORACLES',fixtures=results,precision=256,all_positions=True,rounded_FFT_linearity_assumed=False,source_iFFT_executed=False,
 interpretation='Finite controls of both independent reference layers; universal bounds are the analytical recurrence/error proof plus exact numeric certificate, not these fixtures.')
(W/'artifacts/oracle.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],fixtures=len(results),complex_positions=len(results)*768),indent=2))
