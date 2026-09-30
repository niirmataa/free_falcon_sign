# Project Niirmata; exact arithmetic for the declared RUN_002 reference
# machine. These are upper bounds, not attainable maxima or CPU timings.
from pathlib import Path
import json
assert parent(1) is ZZ and parent(1/3) is QQ

coefficient_weight_cap = ((6150+1)*1536+2)*1536+1
polynomial_code_cap = 32*1536*coefficient_weight_cap
multiply_time_cap = 1536*((2^20+4)*coefficient_weight_cap+33)
assert polynomial_code_cap <= 2^50
assert multiply_time_cap < 2^66
assert 32*2^66 == 2^71
assert 2*2^66 == 2^67
assert 2*2^71 == 2^72
assert 2*1536*17+2 == 52226
assert 16+1 == 17

def envelope(qs, qh, msg, coins, sbits, acode, adepth, scode, sdepth, pcode):
    qs,qh,msg,coins,sbits,acode,adepth,scode,sdepth,pcode = map(ZZ,
        [qs,qh,msg,coins,sbits,acode,adepth,scode,sdepth,pcode])
    assert min(qs,qh,msg,coins,sbits,acode,adepth,scode,sdepth,pcode) >= 0
    N=qs+qh; T=qh+1
    C=3*(N+1)*(9*(msg+41)+27000+T)+T+4
    ai=24577+coins+N*(9*msg+26440); ao=9*msg+26120
    si=24900+C+9*msg+sbits; so=50689
    A=((adepth+1)*(2*ai+3*acode+8)+16*(ai+ao),
       ai+2*acode+adepth+8+8*(ai+ao),ai+ao)
    S=((sdepth+1)*(2*si+3*scode+8)+16*(si+so),
       si+2*scode+sdepth+8+8*(si+so),si+so)
    F=2*C+ao
    U=(N+1)*(133*(41+msg)+2)+1
    H=U+24577*(T+1)+8*(41+msg)+24576+T+8
    I=24576*T+24576+coins+acode+scode+pcode+N+1+2^20
    init=(16*I+1+5*coins,I+coins,I+coins)
    turn=(A[0]+S[0]+2*(16*F+1)+H+U+5*(320+sbits),
          I+C+A[1]+S[1]+32*F+32*(H+U)+320+sbits,
          A[2]+S[2]+2*F+320+sbits)
    P=H+2*U+msg+16; O=T+52226
    terminal=(17+2*(16*F+1)+P+2^67+16*O+1,
              I+C+16+32*F+32*P+2^72+16*O,
              1+2*F+O)
    total=(init[0]+(N+1)*turn[0]+terminal[0],
           max(init[1],turn[1],terminal[1]),
           init[2]+(N+1)*turn[2]+terminal[2])
    return dict(state_cap=str(C),static_bits=str(I),turn=list(map(str,turn)),
                initial=list(map(str,init)),terminal=list(map(str,terminal)),
                bound=list(map(str,total)))

# Illustration parameters only: no sampler or adversary instantiation is
# asserted by these numeric records. Their certificates remain explicit.
examples=[]
for qs,qh in [(0,0),(1,1),(16,32)]:
    examples.append(dict(qs=int(qs),qh=int(qh),message_bytes=int(64),
        placeholder_code_bits=int(4096),placeholder_depth=int(32),
        sampler_bits=int(320),adversary_bits=int(256),
        costs=envelope(qs,qh,64,256,320,4096,32,4096,32,2^50)))
result=dict(schema='RUN002_RESOURCE_ENVELOPE_V1',arithmetic='sage preparser; exact ZZ/QQ',
    bound_kind='conservative upper bound in the declared finite-file reference cost semantics',
    coefficient_weight_cap=str(coefficient_weight_cap),polynomial_code_cap=str(polynomial_code_cap),
    polynomial_code_power_cap=str(2^50),multiply_time_cap=str(multiply_time_cap),
    verifier_time_cap=str(2^66),verifier_allocation_cap=str(2^71),
    verify_plus_extraction_time_cap=str(2^67),verify_plus_extraction_allocation_cap=str(2^72),
    witness_payload_cap='target_index+52226',examples=examples,
    concrete_sampler_instantiated=False,attainable_worst_case_claim=False,
    all_key_error_bound_proved=False)
Path('resource_envelope.json').write_text(json.dumps(result,indent=int(2),sort_keys=True)+'\n')
print('RESOURCE_ENVELOPE_PASS')
print(json.dumps(result,sort_keys=True))
