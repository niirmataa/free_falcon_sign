"""Independent exact inequalities and higher-precision direct tail evaluation."""
import json
from pathlib import Path
import sys
from fractions import Fraction as F
from sage.all import QQ, RealBallField

child = Path(sys.argv[1]); R = RealBallField(768)
def load(p): return json.loads((child/p).read_text())
def read(p): return load('inputs/bootstrap/'+p)
def up(x): return F(-(-x.numerator*2**256//x.denominator), 2**256)
def rb(x): return R(QQ(x.numerator)/x.denominator)
var = load('VARIANCE_BRIDGE.json'); err = load('ERROR_LEDGER.json')
mgf = load('CONDITIONAL_MGF.json'); tail = load('JOINT_TAIL_BOUND.json')
root = read('ROOT/artifacts/numeric_certificate.json')['derived']
metric = read('LEFT/artifacts/metric_bounds.json'); widths = read('NORMALIZED/WIDTH_BOUNDS.json')
post = read('POST/artifacts/numeric_certificate.json'); left = read('LEFT/artifacts/energy_transfer.json')
U = F(1, 2**48); eta = F(1, 2**900); q = F(18433)
a = F(root['ahatmax']); j = F(root['jhatmax']); dc = F(root['det_error'])
k0, k1 = [F(r['metric_to_stable_factor']) for r in metric['products']]
beta_root = 256*U*j*a/(q-dc)**2
c0 = 2/(1-8*U); c1 = (1+2*(32*U)**2*j*a/(q-dc)**2)/(1-beta_root)
image = max(k0*c0, k1*c1)
assert 0 < beta_root < 1 and image == F(var['full_image_factor']) < 8
s0 = (1+U)/(1-F(widths['sqrt_relative_error_bound']))+eta
cw = max(s0*s0, F(3, 4)*((1+U)*F(widths['IW1I']['value'])*s0+eta)**2)
V = F(tail['variance_proxy']); assert V == up(F(4, 3)*image*cw*768**2) < 5462457
e0 = F(1, 2**20)+F(1, 2**1023)+U*(367+184)+2*eta; e1 = F(1, 2**20)
dual = 1536*(e0*e0/F(widths['stored']['real_square_lower'])+e1*e1/F(widths['paired']['real_square_lower']))
terminal = F(err['terminal_transport_error']); assert terminal**2 >= V*dual
delta = F(left['reconstruction']['actual_to_exact_source_L_reconstruction_norm_error'])
root_error = F(post['sampling_return']['root_last_CM_error'])+F(post['sampling_return']['root_last_sub_error'])
assert delta == F(err['both_branch_reconstruction_delta']) and root_error == F(err['root_CM_plus_sub_error'])
amin = F(1, 2)/(1+8*U); perp = (q+dc)**2/amin+(32*U)**2*j
cross = F(err['nonorthogonal_cross_cap']); assert cross**2 >= (32*U)**2*a*j
image_error = up(a*(delta+root_error)**2+2*cross*(delta+root_error)*delta+perp*delta**2)
assert image_error == F(err['joint_image_defect_energy'])
graph = F(err['graph_basis_coefficient_error']); assert graph**2 >= F(4, 3)*image_error
post_error = F(err['post_CM_add_coefficient_error'])
assert post_error**2 >= F(8, 3)*F(post['suffix']['each_source_CM_add_error'])**2
assert F(post['ifft']['source_error_outward']) == F(1, 128)
E = F(tail['roundoff']); assert E == up(terminal+graph+post_error+F(1, 128)) < 1095
margin = F(65535, 2)-E
assert margin > 0 and margin == F(tail['effective_margin']) and margin/V == F(tail['chernoff_theta'])
vmin = min(F(widths['stored']['real_square_lower']), F(widths['paired']['real_square_lower']))
c = 2*R.pi()**2*rb(vmin); rho_direct = 2*(-c).exp()/(1-(-3*c).exp())
rho = F(mgf['poisson_nonzero_modes_upper']); tau = F(mgf['local_support_tau'])
assert rho_direct <= rb(rho) and 0 < rho < F(1, 2**48)
assert tau == F(read('JOINT/ERROR_LEDGER.json')['tau'])
factor = F(mgf['local_MGF_factor'])
assert factor == up((1+rho)/(1-rho)/(1-tau))
q_upper = F(tail['reference_q_upper']); p_upper = F(tail['IID_upper'])
# Direct power, independently avoiding the producer's outward-log route.
reference_direct = 6144*rb(factor)**3072*(-rb(margin)**2/(2*rb(V))).exp()
assert reference_direct <= rb(q_upper) and 0 < q_upper <= F(1, 2**119) < F(1, 2)
Delta_exact = (1+F(1, 2**60))**3072-1
Delta = F(tail['Delta_exact_expression_outward'])
assert 0 < Delta_exact <= Delta <= F(3, 2**50-3)
radicand = Delta*q_upper*(1-q_upper)
assert 0 < radicand < F(1, 2**50)
assert p_upper > q_upper and (p_upper-q_upper)**2 >= radicand and p_upper <= F(1, 2**84)
assert F(tail['reference_q_power2']) == F(1, 2**119) and F(tail['IID_power2']) == F(1, 2**84)
# Published power-of-two summaries alone would not yield the stronger final exponent.
coarse_q = F(1, 2**119)
coarse_q_insufficient = (F(1, 2**84)-coarse_q)**2 < Delta_exact*coarse_q*(1-coarse_q)
assert coarse_q_insufficient
result = dict(status='PASS_INDEPENDENT_RATIONAL_AND_RBF768_H6P_CHECKS',
    variance_RBF=str(rb(V)), error_RBF=str(rb(E)), reference_direct_RBF=str(reference_direct),
    exact_Delta_checked=True, rational_IID_sqrt_comparison_pass=True,
    reference_power2='2^-119', IID_one_root_power2='2^-84',
    premature_reference_rounding_to_power2_loses_final_exponent=True,
    fully_source_kernelized=False, scope='Arithmetic verification of the reviewed source/analytical certificates')
print(json.dumps(result, indent=2))
