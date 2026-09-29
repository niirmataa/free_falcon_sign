"""Independent RBF384 Gaussian on all Z, with analytic two infinite-tail enclosures."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from dyadic import value
from replaylib import sha
W=Path.cwd();RB=RealBallField(384);catalog=json.loads((W/'artifacts/kernel_examples.json').read_text());group=int(sys.argv[1]);chosen=catalog['cases'][group*40:(group+1)*40];assert chosen;D=W/'artifacts/gaussian';D.mkdir(exist_ok=True)
ledger=json.loads((W/'ERROR_LEDGER.json').read_text());TV=QQ(ledger['entries']['TV_to_original_power2']);CHI=QQ(ledger['entries']['forward_chi2_power2']);summaries=[]
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
def bounds(x):return dict(lower=str(max(QQ(0),QQ(x.lower()))),upper=str(QQ(x.upper())),ball=str(x))
def reference(rho,d,K,prob):
 M=1024;terms={n:(-RB(d)*(RB(n)-RB(rho))**2).exp() for n in range(-M,M+1)}
 tail=2*(-RB(d)*M*M).exp()/(1-(-RB(d)*(2*M+1)).exp())
 finite=sum(terms.values());Z=finite.add_error(QQ(tail.upper()));assert Z>0
 outside=sum(v for n,v in terms.items() if n< -K or n>K+1);outside=outside.add_error(QQ(tail.upper()))/Z
 tv=outside/2;chi=outside;missing=outside;values=[]
 for n in range(-K,K+2):
  g=terms[n]/Z;w=QQ(prob.get(n,0));diff=RB(w)-g;tv+=abs(diff)/2;chi+=diff**2/g
  if not w:missing+=g
  values.append(dict(offset=n,K=str(w),G=str(g)))
 positive_outside=terms[K+2]/Z;assert positive_outside>0
 return dict(normalizer=str(Z),finite_sum=str(finite),sum_window=[-M,M],infinite_unnormalized_tail=str(tail),TV=bounds(tv),chi2_K_to_reference=bounds(chi),reference_mass_outside_positive_K_support=bounds(missing),positive_zero_K_witness=dict(offset=K+2,K='0',G=str(positive_outside),G_positive=True),values=values)
for case in chosen:
 data=json.loads((W/case['path']).read_text());mu=int(data['mu'],16);sigma=int(data['sigma'],16);s=data['s_C'];m=qv(mu);v=qv(sigma)**2;d=1/(2*v);rho=m-s;assert 0<=rho<=1
 rhat=qv(int(data['r_C'],16));dhat=qv(int(data['dss_C'],16));assert 0<=rhat<=1
 A=QQ(data['normalizer_numerator']);prob={a['y']-s:QQ(a['weight_numerator'])/A for a in data['atoms']};assert sum(prob.values())==1
 K=max(a['k'] for a in data['atoms']);main=reference(rho,d,K,prob);machine=reference(rhat,dhat,K,prob)
 assert QQ(main['TV']['upper'])<TV and QQ(main['chi2_K_to_reference']['upper'])<CHI
 result=dict(game='IID_BUFFER',domain='D_env',source_case=case['path'],source_case_sha256=sha(W/case['path']),origin=case['origin'],mu=data['mu'],sigma=data['sigma'],m=str(m),v=str(v),machine_mean=str(s+rhat),machine_precision=str(dhat),main_reference='G_(val(mu),val(sigma)^2), untruncated on Z, independent of K weights',original=main,machine=machine,chi2_G_to_K='infinity',samples_not_uniform_proof=True,Emitted_membership_proved=False)
 p=D/Path(case['path']).name;p.write_text(json.dumps(result,indent=2)+'\n');summaries.append(dict(path=p.relative_to(W).as_posix(),sha256=sha(p),TV=main['TV'],chi2_K_to_G=main['chi2_K_to_reference'],origin=case['origin']));print('PASS_GAUSSIAN',p.name,flush=True)
(W/'artifacts'/('gaussian_oracle_'+str(group)+'.json')).write_text(json.dumps(dict(status='PASS_RIGOROUS_GAUSSIAN_POINT_CONTROLS',game='IID_BUFFER',group=group,cases=summaries,precision_bits=384,infinite_tail_proved=True),indent=2)+'\n')
