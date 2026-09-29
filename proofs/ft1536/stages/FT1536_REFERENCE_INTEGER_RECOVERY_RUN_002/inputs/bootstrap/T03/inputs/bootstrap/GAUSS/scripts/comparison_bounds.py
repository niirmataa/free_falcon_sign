"""Uniform original/machine Gaussian normalization, TV, directional chi2 and tails."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from dyadic import value
from replaylib import sha
W=Path.cwd();RB=RealBallField(384)
dom=json.loads((W/'REDUCTION_DOMAIN.json').read_text());ex=json.loads((W/'EXPM_ACCURACY.json').read_text());cdf=json.loads((W/'CDF_COMPARISON.json').read_text())
def up(x):return QQ((QQ(x)*2**256).ceil())/2**256
def powup(x):
 p=QQ(1)
 while p/2>=x:p/=2
 return p
ec=max(QQ(r['correction_abs_error']) for r in dom['width_classes']);ep=max(QQ(r['parameter_quadratic_abs_error']) for r in dom['width_classes']);ed=QQ(dom['dss_relative_error_to_true_precision']);eb=QQ(ex['Beta_relative_error_noncutoff'])
eh=up(QQ(((1+RB(eb))*RB(ec).exp()-1).upper()));eg=up(QQ(((1+RB(eb))*RB(ec+ep).exp()-1).upper()))
L1=QQ(cdf['L1_uniform']);chi=QQ(cdf['chi2_uniform']);normalizers=[];tails=[]
for row in dom['width_classes']:
 j=row['bank'];a=QQ(row['a']);du=QQ(row['dss_upper']);dtrue_upper=du/(1-ed);dtrue_lower=a/(1+ed);K=row['K']
 Hhi=QQ(cdf['banks'][j]['H_upper']);Chatlo=(RB.pi()/RB(du)).sqrt()-1;Chatlo/=2*RB(Hhi)
 Cphyslo=(RB.pi()/RB(dtrue_upper)).sqrt()-1;Cphyslo/=2*RB(Hhi)
 assert Chatlo>RB(QQ(1)/4) and Cphyslo>RB(QQ(1)/4)
 tailnum=2*(-RB(dtrue_lower)*(K+1)**2).exp()/(1-(-RB(dtrue_lower)*(2*K+3)).exp());tailU=up(QQ(tailnum.upper())/(2*QQ(cdf['banks'][j]['H_lower'])))
 tails.append(tailU);normalizers.append(dict(width_class=row['width_class'],bank=j,C_hat_lower=str(QQ(Chatlo.lower())),C_original_lower=str(QQ(Cphyslo.lower())),reference_unnormalized_tail_outside_proposal_window=str(tailU),true_precision_lower=str(dtrue_lower),true_precision_upper=str(dtrue_upper)))
x64=value(int(dom['buckets'][64]['x_first'],16));x64=QQ(x64.numerator)/x64.denominator
cut=up(QQ((-RB(x64)+RB(ec+ep)).exp().upper()));tail=max(tails)+cut
# rho(y)=G_unnormalized(y)/(2H_j), C=sum rho>=1/4.
eta=up(4*L1+eg+4*tail);tv=up(eta/(1-eta))
l2=up(8*QQ((RB(ep).exp()*(1+RB(eh))**2).upper())*chi+2*eg**2+8*tail);chi_forward=up(l2/(1-eta)**2)
normalizer_source_lower=(1-eta)/4;assert normalizer_source_lower>QQ(1)/8
supporttail=up(4*tail+4*QQ(RB(ep).exp().upper())*L1)
transport_tv=up(QQ((RB(2*ep).exp()-1).upper())+8*max(tails))
likelihood=up(QQ(cdf['likelihood_uniform'])*(1+eg)/(1-eta))
# Pure machine-parameter comparison retains its own ledger/target.
cut_hat=up(QQ((-RB(x64)+RB(ec)).exp().upper()));tail_hat=max(tails)+cut_hat
eta_hat=up(4*L1+eh+4*tail_hat);tv_hat=up(eta_hat/(1-eta_hat))
assert tv<QQ(1)/2**30 and chi_forward<QQ(1)/2**58
ledger=dict(schema='SCALAR_GAUSSIAN_ERROR_LEDGER_V1',game='IID_BUFFER',conditioning='legal PAST only, no unread buffer/future acceptance conditioning',entries=dict(CDF_L1=str(L1),CDF_forward_chi2=str(chi),correction_absolute= str(ec),machine_to_original_quadratic_absolute_on_proposal_window=str(ep),BerExp_relative_noncutoff=str(eb),accepted_relative_vs_Ghat_on_F=str(eh),accepted_relative_vs_G_on_F=str(eg),source_x_cutoff_first=str(x64),unnormalized_cutoff_tail=str(cut),unnormalized_proposal_tail=str(max(tails)),combined_unnormalized_tail=str(tail),normalizer_relative_error=str(eta),source_normalizer_lower=str(normalizer_source_lower),normalizer_lower_export='1/8',TV_to_original=str(tv),TV_to_original_power2=str(powup(tv)),TV_to_machine=str(tv_hat),forward_chi2_to_original=str(chi_forward),forward_chi2_power2=str(powup(chi_forward)),G_mass_outside_positive_K_support_upper=str(supporttail)),normalizer_rows=normalizers,positive_support='S={s_C+z(k,b):n_j,k>0 and e_C(k,b)<64}; Z>0 on derived domain',metrics=[dict(from_law='K_C',to_law='G_(val(mu),val(sigma)^2) on Z',metric='TV',upper=str(powup(tv)),uniform=True),dict(from_law='K_C',to_law='G_(val(mu),val(sigma)^2) on Z',metric='chi2',upper=str(powup(chi_forward)),uniform=True,absolute_continuity=True),dict(from_law='G_(val(mu),val(sigma)^2) on Z',to_law='K_C',metric='chi2',value='infinity',reason='G(s_C+367)>0, K_C(s_C+367)=0 for every entry',absolute_continuity=False)],conditioning_losses=dict(optional_G_S='TV(G conditioned on S,G)=G(S^c)',tail_upper=str(supporttail),main_reference_not_conditioned=True),dependencies={p:sha(W/p) for p in ['REDUCTION_DOMAIN.json','EXPM_ACCURACY.json','CDF_COMPARISON.json']},fully_kernelized=False)
ledger['entries']['TV_Ghat_to_G']=str(transport_tv);ledger['entries']['likelihood_K_over_G_upper']=str(likelihood)
(W/'ERROR_LEDGER.json').write_text(json.dumps(ledger,indent=2)+'\n');print(json.dumps(dict(status='PASS_UNIFORM_NORMALIZATION_TV_AND_DIRECTIONAL_CHI2',game='IID_BUFFER',TV=ledger['entries']['TV_to_original_power2'],chi2_K_to_G=ledger['entries']['forward_chi2_power2'],chi2_G_to_K='infinity',A_lower='1/8',source_expm_scope='nonnegative actual remainder; 63 nominal-domain overrun buckets covered'),indent=2))
