# Niirmata / FT1536 RUN_002. Rigorously checked ledger arithmetic, not a C bound.
# Run with SageMath10.9 standard preparser: sage check_bounds.sage
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
from sage.env import SAGE_VERSION
import json
import os
from pathlib import Path

assert SAGE_VERSION == '10.9'
W = Path(os.environ['RUN002_W'])
OUT = Path(os.environ['RUN002_DEST']) / 'build'
IN = W / 'inputs/bootstrap'
old = IN / 'T03/inputs/bootstrap'
ledger = json.loads((IN / 'T03/checks/gap_composition.json').read_text())
post = json.loads((old / 'POST/artifacts/numeric_certificate.json').read_text())
target = json.loads((old / 'TARGETS/INITIAL_TARGET_CERTIFICATE.json').read_text())
h6p = json.loads((IN / 'T03/checks/constants_extract.json').read_text())['H6P/ERROR_LEDGER.json']
RIF = RealIntervalField(256)

def rec(x):
    x = QQ(x)
    return {'exact': str(x), 'interval_display_only': str(RIF(x))}

def qval(x):
    return QQ(x['exact'] if isinstance(x, dict) else str(x))

def sqrt_up(x):
    assert x >= 0
    u = QQ(RIF(x).sqrt().upper().exact_rational())
    assert u >= 0 and u^2 >= x
    return u

terms = {k: QQ(v['exact']) for k, v in ledger['terms_per_coefficient'].items()}
names = ['A1_challenge_fft_words', 'A2_det_error_x_challenge', 'A3_target_rounding_layer',
         'A4_word_errors_x_target', 'B_word_residuals_x_Z', 'C1_tree_reconstruction_pinned',
         'C2_terminal_box', 'C3_defect_x_word_errors', 'D_suffix_CM_add', 'E_ifft']
assert len(set(names)) == 10
assert sum(terms[n] for n in names) == terms['TOTAL_gap_bound']
assert sum(terms[n] for n in names[:4]) == terms['A_total_refined']
remain = sum(terms[n] for n in ['A1_challenge_fft_words', 'A3_target_rounding_layer',
                               'D_suffix_CM_add', 'E_ifft'])
assert remain > 16 and terms['D_suffix_CM_add'] > 15
allocation = [1/1000, 1/10, 1/20, 1/10, 1/10, 1/1000, 1/20, 1/128]
assert sum(allocation) == 6557/16000 < 1/2
assert 1/2 - sum(allocation) == 1443/16000
assert sum(allocation) - 1/20 + terms['D_suffix_CM_add'] > 1/2
assert sum(allocation) - 1/20 + terms['A3_target_rounding_layer'] > 1/2

# B1: completely reproduce the old suffix formula before attempting a change.
U, eta = 2^-48, 2^-900
X = QQ(post['sampling_return']['returned_x_cap'])
Y = QQ(post['sampling_return']['right_y_cap'])
bs = QQ(post['suffix']['basis_small_cap'])
bL = QQ(post['suffix']['basis_large_cap'])
Ps = (1+6*U)*X*bs + 8*eta
PL = (1+6*U)*Y*bL + 8*eta
epost = 6*U*(X*bs+Y*bL)+16*eta+U*(Ps+PL)+2*eta
assert epost == QQ(post['suffix']['each_source_CM_add_error'])
assert X < 2^35 and Y < 2^27 and bs < 2^11 and bL < 2^22
assert Ps+PL < 2^49
# Same historical mixed A2 map: per-output Q<=epost^2 rather than joint 2epost^2.
# This is conditional arithmetic. The physical inverse/source premises remain open.
D_per_vector = sqrt_up(4/3)*epost
D_joint = sqrt_up(8/3)*epost
assert 11 < D_per_vector < 12 and D_joint < 16
assert abs(D_joint - terms['D_suffix_CM_add']) < 1/10^50
# Removing rounding-to-dyadic coarsening in TARGETS is also insufficient.
rho0 = QQ(target['targets'][0]['rounding_only_error_norm'])
rho1 = QQ(target['targets'][1]['rounding_only_error_norm'])
assert rho0 <= 1/8192 and rho1 <= 2^-24
A3_raw = sqrt_up(4/3)*(rho0*bs + rho1*bL)
assert A3_raw > 1/20
partial_residual = terms['A1_challenge_fft_words'] + A3_raw + D_per_vector + terms['E_ifft']
assert partial_residual > 11

delta, eroot = 33/10^7, 37/10^6
amax = qval(h6p['actual_basis_a_upper'])
cross = qval(h6p['nonorthogonal_cross_cap'])
perp = qval(h6p['orthogonal_residual_row_norm_squared_cap'])
energy = (4/3)*(amax*(delta+eroot)^2+2*cross*(delta+eroot)*delta+perp*delta^2)
assert energy > (1/10)^2
pair_bound = sqrt_up(energy)

# Exact polynomial controls independently verify the new algebra, not source C.
P = PolynomialRing(QQ, names=('t','z','p','pp','ea','ec','es','rx','dg','dG','t1','b'))
t,z,p,pp,ea,ec,es,rx,dg,dG,t1,b = P.gens()
assert ((t+p+ea-z+ec)-p+es)-(t-z) == ea+ec+es
assert ((t+p+ea-z+ec)-pp+es)-(t-z) == ea+ec+es+(p-pp)
assert ((t+rx+ea-z+ec)-rx+es)-(t-z) == ea+ec+es
assert (-t*dg-t1*dG)+((t-z)*dg+(t1-b)*dG) == -z*dg-b*dG
assert ea+ec+es != ec+es  # missing updated-mean addition is not an identity
assert p-pp != 0         # stale operand control
assert -z*dg-b*dG == -z*dg-b*dG  # no-op retained

def closes(xs):
    return all(v >= 0 for v in xs) and sum(xs) < 1/2

assert not closes([3/5]) and closes([])  # omitting a term can reverse the decision
assert not closes([1/2])
lower = QQ(RIF(4/3).sqrt().lower().exact_rational())
assert lower^2 < 4/3                    # inward endpoint must fail
assert (1^2+1^2) > 1^2                 # component bound is not modulus bound
assert sum(terms[n] for n in names)+terms['A_total_refined'] != terms['TOTAL_gap_bound']

result = {
 'schema': 'T03_RUN002_B0_B1_ARITHMETIC_V1', 'sage_version': SAGE_VERSION,
 'preparser': True, 'historical_terms': {n: rec(terms[n]) for n in names},
 'historical_majorant': rec(terms['TOTAL_gap_bound']),
 'three_family_ablation_majorant': rec(remain),
 'epost_recomputed_from_source_contract_formula': rec(epost),
 'D_joint_formula': rec(D_joint), 'D_per_vector_conditional': rec(D_per_vector),
 'A3_raw_conditional': rec(A3_raw),
 'A1_A3raw_Dpervector_E_conditional': rec(partial_residual),
 'quoted_delta_eroot': {'delta': rec(delta), 'eroot': rec(eroot), 'C1': rec(pair_bound)},
 'proposed_allocation_sum': rec(sum(allocation)),
 'proposed_margin': rec(1/2-sum(allocation)),
 'controls': {'missing_D': True, 'missing_A3': True, 'double_A_total': True,
              'component_vs_modulus': True, 'shrunken_endpoint': True,
              'stale_operand': True, 'omitted_terminal_update': True, 'noop': True},
 'source_refinement_proved': False, 'new_uniform_source_gap_bound': None,
 'required_domain_counterexample': False, 'B_gap_closed': False,
 'warning_scope': 'All improved numbers are conditional majorants. No source/kernel bridge for their premises is supplied.'}
(OUT / 'BUDGET_ANALYSIS.json').write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
for name in ['historical_majorant','three_family_ablation_majorant','D_per_vector_conditional',
             'A3_raw_conditional','A1_A3raw_Dpervector_E_conditional']:
    print(name, result[name]['interval_display_only'])
print('B0_B1_ARITHMETIC_PASS; SOURCE_GAP_OPEN')
