"""Source-instantiated variance/error + conditional Gaussian MGF and joint root tail."""
import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,ZZ,RealBallField,matrix
from replaylib import sha
W=Path.cwd();I=W/'inputs/bootstrap';RB=RealBallField(512);U=QQ(1)/2**48;eta=QQ(1)/2**900;SIG=QQ(768);M=3072
def read(p):return json.loads((I/p).read_text())
def write(p,obj):(W/p).write_text(json.dumps(obj,indent=2)+'\n')
def up(x,bits=256):return QQ((QQ(x)*2**bits).ceil())/2**bits
def rbup(x):return up(QQ(x.upper()))
def sqrtup(x):return rbup(RB(x).sqrt())
def powup(x):
 p=QQ(1)
 while p/2>=x:p/=2
 return p
metric=read('LEFT/artifacts/metric_bounds.json');width=read('NORMALIZED/WIDTH_BOUNDS.json');root=read('ROOT/artifacts/numeric_certificate.json');left=read('LEFT/artifacts/energy_transfer.json');post=read('POST/artifacts/numeric_certificate.json');joint=read('JOINT/ERROR_LEDGER.json')
k0,k1=[QQ(r['metric_to_stable_factor']) for r in metric['products']];assert 1<k0<2 and 1<k1<6
aMax=QQ(root['derived']['ahatmax']);jMax=QQ(root['derived']['jhatmax']);dc=QQ(root['derived']['det_error']);q=QQ(18433)
gamma=8*U;beta=256*U*jMax*aMax/(q-dc)**2;alpha=QQ(1)
c0=(1+alpha)/(1-gamma);c1=(1+(1+1/alpha)*(32*U)**2*jMax*aMax/(q-dc)**2)/(1-beta)
image_factor=max(k0*c0,k1*c1);assert 0<beta<1 and image_factor<8
sqerr=QQ(width['sqrt_relative_error_bound']);Dmax=QQ(width['gate']['D_max']);assert Dmax<SIG**2
iw=QQ(width['IW1I']['value']);s0fac=(1+U)/(1-sqerr)+eta
width0=s0fac**2;width1=QQ(3)/4*((1+U)*iw*s0fac+eta)**2;cw=max(width0,width1);assert cw<1+QQ(1)/2**45
V=up(QQ(4)/3*image_factor*cw*SIG**2);Vceil=ZZ(V.ceil())
# Terminal A2: T [xi0,xi1] = [xi0-xi1/2,xi1].
A2=matrix(QQ,[[1,QQ(1)/2],[QQ(1)/2,1]]);T=matrix(QQ,[[1,-QQ(1)/2],[0,1]])
assert T.transpose()*A2*T==matrix(QQ,[[1,0],[0,QQ(3)/4]]) and A2.inverse()[0,0]==QQ(4)/3 and A2.inverse()[1,1]==QQ(4)/3
var=dict(schema='H6P_SOURCE_VARIANCE_BRIDGE_V1',game='IID_BUFFER',reference='Q_S',status='PASS_UNIFORM_COEFFICIENTWISE_SOURCE_PROXY',scope='every required emitted/canonical normalized root entry; each coefficient of BOTH 1536-vectors; no actual covariance/independence assertion',scalar_order='3072 source calls; within each leaf paired xi1 first, stored xi0 second',stable_metric_factors=[str(k0),str(k1)],integer_ceil_factors=[2,6],root_basis_factors=[str(c0),str(c1)],full_image_factor=str(image_factor),full_image_factor_integer_upper=8,root_G00_relative_error=str(gamma),root_Schur_relative_error=str(beta),actual_basis_det_error=str(dc),source_width_energy_factors=[str(width0),str(width1)],width_common_factor=str(cw),sigma_sign=768,terminal_A2_diagonal=['1','3/4'],inverse_A2_coordinate_diagonal='4/3',variance_proxy_exact_outward=str(V),variance_proxy_integer_upper=int(Vceil),inequality='for every r<3072: sum_i a[e,r,i]^2 * val(sigma_i)^2 <= V',coefficients_entry_measurable=True,history_independent_coefficients=True,raw_L_equal_ideal_assumed=False,raw_pivots_equal_stable_D_assumed=False,global_lattice_Gaussian_assumed=False,dependencies={p:sha(I/p) for p in ['LEFT/artifacts/metric_bounds.json','ROOT/artifacts/numeric_certificate.json','NORMALIZED/WIDTH_BOUNDS.json']})
write('VARIANCE_BRIDGE.json',var)
# Actual terminal residuals -> innovations; use old proven ZERO2^-20, not empirical closeness.
Er=QQ(1)/2**20;Eh=QQ(1)/2**1023;last_terminal=U*(367+184)+2*eta
noise0=Er+Eh+last_terminal;noise1=Er
vstored=QQ(width['stored']['real_square_lower']);vpaired=QQ(width['paired']['real_square_lower']);assert vstored>1 and vpaired>1
terminal_dual_norm_sq=1536*(noise0**2/vstored+noise1**2/vpaired)
terminal_error=sqrtup(V*terminal_dual_norm_sq)
# Reconstruction/source CM/sub/basis defect in triangular (u,y) coordinates.
delta=QQ(left['reconstruction']['actual_to_exact_source_L_reconstruction_norm_error'])
root_def=QQ(post['sampling_return']['root_last_CM_error'])+QQ(post['sampling_return']['root_last_sub_error'])
du=delta+root_def;dy=delta
amin=QQ(1)/2/(1+gamma);perp=(q+dc)**2/amin+(32*U)**2*jMax
cross=32*U*sqrtup(aMax*jMax)
image_defect=up(aMax*du**2+2*cross*du*dy+perp*dy**2)
graph_error=sqrtup(QQ(4)/3*image_defect)
post_round=QQ(post['suffix']['each_source_CM_add_error']);post_error=sqrtup(QQ(8)/3)*post_round
ifft_error=QQ(post['ifft']['source_error_outward']);assert ifft_error==QQ(1)/128
E=up(terminal_error+graph_error+post_error+ifft_error);Eceil=ZZ(E.ceil());assert E<32767
error=dict(schema='H6P_SOURCE_ROUNDOFF_V1',game='IID_BUFFER',reference='Q_S',source_innovation='xi_i=val(actual_mu_i(prefix))-Y_i',d_e_r='0',terminal_source_sub_error=str(Er),terminal_half_error=str(Eh),terminal_last_sub_error=str(last_terminal),equivalent_innovation_error_bounds=[str(noise0),str(noise1)],terminal_dual_norm_sq=str(terminal_dual_norm_sq),terminal_transport_error=str(terminal_error),both_branch_reconstruction_delta=str(delta),root_CM_plus_sub_error=str(root_def),actual_basis_a_lower=str(amin),actual_basis_a_upper=str(aMax),orthogonal_residual_row_norm_squared_cap=str(perp),nonorthogonal_cross_cap=str(cross),joint_image_defect_energy=str(image_defect),graph_basis_coefficient_error=str(graph_error),post_CM_add_coefficient_error=str(post_error),source_iFFT_error=str(ifft_error),total_source_error_exact_outward=str(E),total_source_error_integer_upper=int(Eceil),map='val(t_r)=sum_i a[e,r,i]*xi_i + delta_r(history), abs(delta_r)<=E',targets_absorbed_in_actual_adaptive_mu=True,not_reference_integer_recovery=True,dependencies={p:sha(I/p) for p in ['LEFT/artifacts/energy_transfer.json','POST/artifacts/numeric_certificate.json','ZERO/ANALYTIC_PROOF.md','TARGETS/INITIAL_TARGET_CERTIFICATE.json']})
write('ERROR_LEDGER.json',error)
# Poisson normalizer bound uniform for ALL shifted means, no mean-zero assumption.
vmin=min(vstored,vpaired);cc=2*RB.pi()**2*RB(vmin)
rho=rbup(2*(-cc).exp()/(1-(-3*cc).exp()));assert rho<QQ(1)/2**48
tau=QQ(joint['tau']);assert 0<tau<QQ(1)/2**61
factor=up((1+rho)/(1-rho)/(1-tau));logfactor=rbup(RB(factor).log());joint_factor=rbup((M*RB(logfactor)).exp())
mgf=dict(schema='H6P_CONDITIONAL_MGF_V1',game='IID_BUFFER',reference='Q_S',conditioning='legal value prefix and entry PAST, never future/unread buffer or whole-call survival',status='PASS_UNIFORM_CONDITIONAL_EXPONENTIAL_MOMENT',minimum_variance_parameter=str(vmin),poisson_nonzero_modes_upper=str(rho),poisson_tail_proof='2 sum_n>=1 exp(-2*pi^2*v*n^2) <=2exp(-c)/(1-exp(-3c)) for v>=vmin',normalizer_ratio_bound=str((1+rho)/(1-rho)),local_support_tau=str(tau),local_conditioning_factor=str(1/(1-tau)),local_MGF_factor=str(factor),local_MGF='E_QS[exp(t*(mu-Y)) | prefix] <= C exp(t^2 sigma_word_value^2/2), all real t',full_scalar_calls=M,joint_prefactor_upper=str(joint_factor),joint_log_prefactor_upper=str(M*logfactor),joint_MGF='E_QS exp(theta*sum_i a_i xi_i) <= C^3072 exp(theta^2 V/2)',independence_assumed=False,exact_mean_zero_assumed=False,source_sigma_words_fixed_by_entry=True,dependencies={'JOINT/ERROR_LEDGER.json':sha(I/'JOINT/ERROR_LEDGER.json'),'NORMALIZED/WIDTH_BOUNDS.json':sha(I/'NORMALIZED/WIDTH_BOUNDS.json')})
write('CONDITIONAL_MGF.json',mgf)
# Correct asymmetric rint interval implies conservative symmetric threshold.
threshold=QQ(65535)/2;margin=threshold-E;theta=margin/V
qbound=rbup(6144*(M*RB(logfactor)-RB(margin)**2/(2*RB(V))).exp());assert 0<qbound<QQ(1)/2
Delta=rbup((1+RB(QQ(1)/2**60))**M-1);assert Delta<=QQ(3)/(2**50-3)
transfer=rbup((RB(Delta*qbound*(1-qbound))).sqrt());pbound=up(qbound+min(QQ(1)/2**25,transfer));assert pbound<1
tail=dict(schema='H6P_JOINT_REFERENCE_TAIL_V1',game='IID_BUFFER',reference='Q_S',event='Live and NOT Safe16(Phi_e(Y).w1,Phi_e(Y).w2), both1536 pre-narrow int64 vectors',conditioning='each required emitted/canonical normalized root entry and legal entry PAST',status='PASS_UNIFORM_NONTRIVIAL_REFERENCE_AND_IID_BOUND',coefficients=3072,signed_tail_events=6144,drift='0',variance_proxy=str(V),roundoff=str(E),rint_safe_lower='-65537/2 inclusive',rint_safe_upper='65535/2 exclusive',conservative_symmetric_bad_threshold=str(threshold),effective_margin=str(margin),chernoff_theta=str(theta),reference_bound_expression='6144*C_MGF^3072*exp(-(32767.5-E)^2/(2V))',reference_q_upper=str(qbound),reference_q_power2=str(powup(qbound)),Delta_expression='(1+2^-60)^3072-1',Delta_exact_expression_outward=str(Delta),Delta_received_rational_upper='3/(2^50-3)',IID_transfer_expression='beta+min(2^-25,sqrt(Delta*beta*(1-beta))) because q<=beta<1/2',IID_upper=str(pbound),IID_power2=str(powup(pbound)),transfer_from='Q_S(B_e|entry PAST) upper beta',transfer_to='P_IID(B_e|entry PAST)',metric_direction='received forward chi2(P_IID||Q_S)',scope='ONE_ROOT_ONLY',Q_stop_live_bad_also_bounded='Q_stop(B)<=Q_S(B) by subprobability domination, no extra exit cost',EXIT_is_BadPrecast=False,universal_Safe16_proved=False,real_PRNG_bridge_proved=False,retry_composition_proved=False,new_M0_eta_pre=None)
write('JOINT_TAIL_BOUND.json',tail)
print(json.dumps(dict(status=tail['status'],kappa_integer_ceil=[2,6],image_factor_RBF=str(RB(image_factor)),V_ceil=int(Vceil),E_ceil=int(Eceil),terminal_error_RBF=str(RB(terminal_error)),reference_bound_power2=tail['reference_q_power2'],one_root_IID_power2=tail['IID_power2'],Q='Q_S',both_vectors=True),indent=2))
