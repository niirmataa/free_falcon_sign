# Exact audit of the constants used by the executable integration layer.
# This script does not assign a cost to the whole reducer or instantiate a
# sampler. The corresponding symbolic source bounds are kernel theorems.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
n=ZZ(1536)
coefficient_weight=(6151*n+2)*n+1
poly_steps=n*((2^20+4)*coefficient_weight+33)
assert poly_steps<2^65
reduce_file=n*(4*n+35+2^22+2+33)
center_file=n*(2*(4*n+33)+2^22+516+4+35)
gather=768*(2*(4*n+35)+66)
norm=(1536+1)*(2^18+32*(50+1536+1)+8)
sign_check=3175*768+1
final_compare=48*(1536+50)+24
file_control=64*(3*n+3072)+2^12
assert reduce_file<=2^33 and center_file<=2^33 and gather<=2^24 and norm<=2^30
verify_steps=reduce_file+poly_steps+center_file+3*gather+norm+sign_check+final_compare+file_control
assert verify_steps<=2^66
# Formal controls that prevent confusing the calibrated reference byte loop
# with the smaller price supplied by the author's abstract operation ledger.
assert 16*8+1+1==130
assert 130+3==133
assert 133*40+1 > 8*40+8
result=dict(schema='FT1536_INTEGRATED_MACHINE_CONSTANTS_V1',
    domains='Sage ZZ with standard preparser',
    coefficient_expression_weight=str(coefficient_weight),
    whole_polynomial_bit_steps=str(poly_steps),
    reduction_file_bound=str(reduce_file),centering_file_bound=str(center_file),
    pair_gather_bound=str(gather),norm_bound=str(norm),
    signature_check_bound=str(sign_check),threshold_compare_bound=str(final_compare),
    file_control_bound=str(file_control),verifier_combined_bound=str(verify_steps),
    verifier_power_of_two_bound='2^66',one_byte_equality_bit_steps='130',
    byte_loop_per_position='133',
    scope='naive reference code; loose bounds, not physical C timings or full-reducer Resources',
    full_machine_resource_theorem=False)
Path('integrated_machine_bounds.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('INTEGRATED_MACHINE_BOUNDS_PASS',json.dumps(result,sort_keys=True))
