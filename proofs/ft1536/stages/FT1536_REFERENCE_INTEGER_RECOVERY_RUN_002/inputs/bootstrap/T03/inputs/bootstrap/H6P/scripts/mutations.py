import json,sys
from pathlib import Path
sys.path.insert(0,str(Path.cwd()/'scripts'))
from sage.all import QQ,RealBallField
from dyadic import value,rn
from post_model import rint_word
from fractions import Fraction as F
from replaylib import sha
W=Path.cwd();RB=RealBallField(384);D=W/'artifacts/mutations';D.mkdir(exist_ok=True);rows=[]
def record(name,a,b,equal=False,scope='LOCAL_CONTROL_OR_PROOF_CONSUMER'):
 assert (a==b)==equal,name;p=D/(name+'.json');p.write_text(json.dumps(dict(name=name,baseline=a,changed=b,equal=a==b,scope=scope),indent=2)+'\n');rows.append(dict(name=name,status='NOOP_PASS' if equal else 'DETECTED',path=p.relative_to(W).as_posix(),sha256=sha(p),scope=scope))
data=json.loads((W/'artifacts/controls/constant_basis_data.json').read_text());V=json.loads((W/'VARIANCE_BRIDGE.json').read_text());E=json.loads((W/'ERROR_LEDGER.json').read_text());tail=json.loads((W/'JOINT_TAIL_BOUND.json').read_text());mgf=json.loads((W/'artifacts/mgf_controls.json').read_text())
def qv(w):v=value(w);return QQ(v.numerator)/v.denominator
again=QQ(4)/3*QQ(V['full_image_factor'])*QQ(V['width_common_factor'])*768**2
again=QQ((again*2**256).ceil())/2**256
record('noop_variance_recompute',V['variance_proxy_exact_outward'],str(again),True)
actual=qv(data['tree'][0]);ideal=QQ(50433)/10240;assert actual!=ideal;record('raw_L_equals_ideal',str(actual),str(ideal),scope='synthetic local constant basis; original source division has nonzero exact error, no Emitted membership')
sig0=qv(int(data['calls'][1]['sigma'],16));sig1=qv(int(data['calls'][0]['sigma'],16));record('omit_paired_variance',str(sig0**2+sig1**2/4),str(sig0**2+sig0**2/4))
record('A2_is_Euclidean','4/3','1',scope='inverse A2 diagonal for each coefficient, not ordinary l2 variance')
obs=json.loads((W/'artifacts/map_oracle_constant_basis.json').read_text());assert obs['nonzero_source_roundoff_observed'];record('omit_all_source_roundoff',obs['max_actual_source_error_ball'],'0')
assert mgf['normalizer_ratio_witness']['strictly_above_one'];record('discrete_normalizer_ratio_one',mgf['normalizer_ratio_witness']['ratio'],'1')
record('omit_support_conditioning',mgf['truncation_factor_countermodel']['conditional_MGF'],mgf['truncation_factor_countermodel']['full_MGF'],scope='EXTENDED_TOY_SUPPORT_{0,1}; refutes generic missing-factor inequality, not required source instance')
r=next(x for x in mgf['MGF_checks'] if x['independence_false_certified']);record('independent_innovation_marginals',r['actual_joint_MGF'],r['product_of_marginal_MGFs'])
n=next(x for x in mgf['conditional_nodes'] if x['nonzero_mean_certified']);record('exact_mean_zero_innovation',n['innovation_conditional_mean'],'0')
record('one_vector_instead_joint',dict(w1=0,w2=32768,bad=True),dict(w1=0,w2=32768,bad=False),scope='EXTENDED_STANDALONE_PRECAST_EVENT; kernel/formal countermodel, not emitted history')
record('negative_rint_tie_away',rint_word(rn(F(-65537,2))),-32769);record('positive_rint_tie_safe',rint_word(rn(F(65535,2))),32767)
p=QQ(1)/5;q=QQ(1)/4;forward=(p-q)**2/(q*(1-q));reverse=(p-q)**2/(p*(1-p));assert forward<reverse
record('reverse_chi2',dict(P_event=str(p),Q_event=str(q),forward=str(forward),actual_reverse=str(reverse)),dict(P_event=str(p),Q_event=str(q),forward=str(forward),incorrect_reverse_bound=str(forward)),scope='EXACT_TWO_POINT_PROBABILITY_COUNTERMODEL; no emitted membership; JOINT forward bound cannot simply be reversed')
# Valid but useless independent-box error, contrasted with the correlated proof.
I=W/'inputs/bootstrap';post=json.loads((I/'POST/artifacts/numeric_certificate.json').read_text());delta=QQ(E['both_branch_reconstruction_delta']);rooterr=QQ(E['root_CM_plus_sub_error']);bs=QQ(post['suffix']['basis_small_cap']);bl=QQ(post['suffix']['basis_large_cap'])
box=2*((delta*(1+2**25)+rooterr)*bs+delta*bl)+2*QQ(post['suffix']['each_source_CM_add_error'])+QQ(1)/128+QQ(E['terminal_transport_error']);assert box>QQ(65535)/2
coarseV=16*768**2*QQ(V['width_common_factor']);factor=QQ(json.loads((W/'CONDITIONAL_MGF.json').read_text())['local_MGF_factor']);coarse_tail=6144*(3072*RB(factor).log()-RB(QQ(tail['effective_margin']))**2/(2*RB(coarseV))).exp()
routes=dict(independent_product_error_box=str(box),independent_product_error_exceeds_rint_margin=True,resulting_reference_bound='1 (no positive Chernoff margin)',classification='VALID_BUT_TOO_LOOSE_ERROR_BOUND_NOT_COUNTEREXAMPLE',coarse_integer_metric_variance=str(coarseV),refined_variance=V['variance_proxy_exact_outward'],POST_whole_energy_is_not_variance='10436770873344 is operational worst-case energy, no variance substitution justified',previous_iFFT_only_budget='1/128 is insufficient as a proved full-map budget; local controls do not claim an emitted violation of that small number')
routes['coarse_integer_metric_tail_bound_ball']=str(coarse_tail)
(W/'artifacts/failed_routes_numeric.json').write_text(json.dumps(routes,indent=2)+'\n');out=dict(status='PASS_EXECUTED_H6P_MUTATIONS_AND_COARSE_ROUTES',game='IID_BUFFER',reference='Q_S',mutations=rows,detected=len(rows)-1,noop=1,required_domain_counterexample=False)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],detected=out['detected'],coarse_error_box=str(RB(box))),indent=2))
