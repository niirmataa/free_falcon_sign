import json
from fractions import Fraction as Q
from pathlib import Path
from replaylib import sha
W=Path.cwd();n=json.loads((W/'artifacts/numeric_certificate.json').read_text());rows=[]
for r in n['targets']:
 B=Q(r['exact_coefficient_abs_upper']);E=Q(r['ideal_reference_error_outward']);Er=Q(r['rounding_only_error_outward']);S=B+2*E
 rows.append(dict(**r,reference_coefficient_l2_squared_upper=str(1536*B*B),reference_Phi_quadratic_upper=str(2304*B*B),
  source_inverse_eval_coefficient_l2_squared_upper=str(1536*S*S),source_inverse_eval_Phi_quadratic_upper=str(2304*S*S),rounding_layer_inverse_eval_l2_error_upper=str(2*Er)))
out=dict(schema='FT1536_INITIAL_TARGET_ERROR_LEDGER_V1',status='PASS_UNIFORM_ERRORS_BOTH_REFERENCES',domain='All unchanged emitted normalized keys and all canonical c_i0..18432, no future norm-success/distribution premise',
 fft_challenge=n['fft'],reciprocal=n['reciprocal'],targets=rows,rounding_relative=n['rounding_relative'],coefficient_space=n['coefficient_space'],
 numerical_certificate_sha256=sha(W/'artifacts/numeric_certificate.json'),proof='TARGET_FORMULAS.md, FFT_CHALLENGE_BOUNDS.md, ERROR_LEDGER.md',
 scopes=dict(frequency_targets_are_scalar_mu=False,source_iFFT_executed_or_certified=False,source_inverse_eval_is_mathematical=True,rounded_basis_determinant_assumed_q=False))
(W/'ERROR_LEDGER.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],targets=[dict(target=r['target'],rounding=r['rounding_only_error_outward'],ideal=r['ideal_reference_error_outward'],magnitude=r['source_modulus_and_component_upper']) for r in rows]),indent=2))
