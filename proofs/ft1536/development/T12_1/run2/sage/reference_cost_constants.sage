from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10==1024
q=ZZ(18433)
bits=['true' if q.test_bit(i) else 'false' for i in range(15)]
neg_bits=['true' if (q-1).test_bit(i) else 'false' for i in range(15)]
# Word lengths: inputs padded to16; multiply length≤16+2*16=48.
# Schoolbook multiplication followed by canonical binary modular reduction.
mul_cost=64*(16+16+1)*(16+1)
mod_cost=128*(48+15+1)*(48+1)+2*15+1
total=mul_cost+mod_cost+1
assert total<2^20
Path('generated').mkdir(exist_ok=True)
Path('generated/FieldConstants.lean').write_text('''import Run2.BitModular
namespace FT1536.Run2.BitArithmetic
def modulusBits : List Bool := ['''+', '.join(bits)+''']
theorem modulusBits_value : value modulusBits=18433 := by norm_num [modulusBits,value,bit]
theorem modulusBits_length : modulusBits.length=15 := rfl
def negOneBits : List Bool := ['''+', '.join(neg_bits)+''']
theorem negOneBits_value : value negOneBits=18432 := by norm_num [negOneBits,value,bit]
theorem negOneBits_length : negOneBits.length=15 := rfl
theorem field_cost_arithmetic :
  64*(16+16+1)*(16+1)+128*(48+15+1)*(48+1)+2*15+1+1 < (2 : ℕ)^20 := by norm_num
end FT1536.Run2.BitArithmetic
''')
Path('reference_cost_constants.json').write_text(json.dumps(dict(q=str(q),modulus_bits=bits,
    multiply_steps=str(mul_cost),modular_steps=str(mod_cost),combined_steps=str(total),
    coarse_bound='2^20',scope='verified reference bit routines; not yet aggregate whole-reducer memory/time'),indent=int(2))+'\n')
print('REFERENCE_COST_CONSTANTS_PASS',total)
