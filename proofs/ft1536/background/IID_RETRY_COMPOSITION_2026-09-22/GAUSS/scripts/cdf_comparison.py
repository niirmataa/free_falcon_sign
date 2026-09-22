"""Literal dyadic half-line Gaussian, rigorous infinite tails and CDF/chi2 errors."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from kernel_model import constants
from dyadic import value
from replaylib import sha
W=Path.cwd();RB=RealBallField(384);T,coefs,C=constants(W);R=QQ(2)**128;rows=[]
def up(x):return QQ((QQ(x)*2**256).ceil())/2**256
def powup(x):
 p=QQ(1)
 while p/2>=x:p/=2
 return p
for j,ts in enumerate(T):
 v=value(coefs[j]);a=QQ(v.numerator)/v.denominator;M=1024
 terms=[(-RB(a)*k*k).exp() for k in range(M+1)];tail=(-RB(a)*(M+1)**2).exp()/(1-(-RB(a)*(2*M+3)).exp())
 H=sum(terms);hl=QQ(H.lower());hu=QQ((H+tail).upper());assert hl>1
 cumul=[RB(0)]*(M+2)
 for k in range(M,-1,-1):cumul[k]=cumul[k+1]+terms[k]
 threshold_errors=[]
 for k,threshold in enumerate(ts):
  qlo=QQ(cumul[k+1].lower())/hu;qhi=QQ((cumul[k+1]+tail).upper())/hl
  err=max(abs(QQ(threshold)/R-qlo),abs(QQ(threshold)/R-qhi));assert err<=1/R,(j,k,str(err*R));threshold_errors.append(str(up(err)))
 masses=[u-v for u,v in zip([2**128]+ts,ts+[0])];K=max(k for k,m in enumerate(masses) if m)
 tailK=up(QQ((cumul[K+1]+tail).upper())/hl);l1=tailK;chi=tailK;ratio=QQ(0);atoms=[]
 for k in range(K+1):
  p=QQ(masses[k])/R;lo=QQ(terms[k].lower())/hu;hi=QQ(terms[k].upper())/hl;err=up(max(abs(p-lo),abs(p-hi)))
  cc=up(err**2/lo) if p else up(hi);l1+=err;chi+=cc;ratio=max(ratio,up(p/lo));atoms.append(dict(k=k,p=str(p),q_lower=str(lo),q_upper=str(hi),absolute_error=str(err),chi2_term_upper=str(cc)))
 row=dict(bank=j,dyadic_a=str(a),nominal_variance=[5,20,80,320,768][j],H_lower=str(hl),H_upper=str(hu),sum_limit=M,infinite_tail_bound=str(up(QQ(tail.upper()))),tail_beyond_source_support=str(tailK),threshold_error_bound='1/2^128',all_512_threshold_errors=threshold_errors,L1_bound=str(up(l1)),TV_bound=str(up(l1/2)),chi2_from='literal p_j on nonnegative integers',chi2_to='q_j(k)=exp(-a_j*k^2)/H_j on all nonnegative integers',chi2_bound=str(up(chi)),likelihood_ratio_upper=str(ratio),atoms=atoms)
 rows.append(row);print('CDF_BANK',j,'L1',str(powup(l1)),'chi2',str(powup(chi)),flush=True)
out=dict(schema='SCALAR_CDF_COMPARISON_V1',game='IID_BUFFER',status='PASS_LITERAL_CDF_VS_DYADIC_HALF_GAUSSIAN_INFINITE_TAIL',banks=rows,L1_uniform=str(max(QQ(r['L1_bound']) for r in rows)),chi2_uniform=str(max(QQ(r['chi2_bound']) for r in rows)),likelihood_uniform=str(max(QQ(r['likelihood_ratio_upper']) for r in rows)),reverse_chi2='infinity: q_j positive beyond finite p_j support',precision_bits=384,threshold_source_sha256=sha(W/'source/ft1536-adaptive-cdf-tables.h'))
(W/'CDF_COMPARISON.json').write_text(json.dumps(out,indent=2)+'\n')
