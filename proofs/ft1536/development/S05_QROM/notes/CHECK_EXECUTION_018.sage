# Exact bookkeeping in Sage's standard preparser. No performance claim.
import json
from pathlib import Path
from sage.env import SAGE_VERSION
pairs = ZZ(196)*1536*80
blocks = ZZ(196)*1536
counts = {
    'bitRead': pairs*1024 + ZZ(30720),
    'cdfRead': pairs*(2*15+2),
    'pairTrial': pairs,
    'capStep': pairs+196,
    'capStop': blocks+1,
    'storePair': blocks+1536,
    'normBlock': blocks,
    'cubeCoord': ZZ(3072),
    'productPair': ZZ(1536)^2,
    'scatterUpdate': 2*ZZ(1536)^2,
    'outputCell': ZZ(3072),
}
expected = [24662538240,770703360,24084480,24084676,301057,302592,301056,3072,2359296,4718592,3072]
assert list(counts.values()) == expected
assert counts['bitRead'] % 8 == 0
norm_cap = ZZ(1536)*3*65535^2
assert norm_cap < 2^45
assert ZZ(18432)^2 < 2^29
assert 2*ZZ(18432) < 2^16
assert ZZ(24662538240) < 2^35
assert ZZ(30721) < 2^15
assert QQ(1)/2^47 == QQ(1)/140737488355328
# Independent stopping controls. Exact small cases, not a universal proof.
def first_events(outcomes, trial=ZZ(4), step=ZZ(2), stop=ZZ(7)):
    spent = ZZ(0)
    for x in outcomes:
        spent += trial+step
        if x is not None:
            return [x,spent]
    return [None,spent+stop]
controls = {
    'empty': first_events([]),
    'exhausted': first_events([None,None,None]),
    'early': first_events([ZZ(7),ZZ(7),ZZ(7)]),
    'late': first_events([None,None,ZZ(7)]),
}
assert controls == {'empty':[None,7], 'exhausted':[None,25], 'early':[7,6], 'late':[7,18]}
result = {
    'status':'PASS_EXACT_BOOKKEEPING_AND_FINITE_CONTROLS',
    'sage_version':SAGE_VERSION,
    'event_bounds':{k:int(v) for k,v in counts.items()},
    'full_private_tape_bytes':int(counts['bitRead']/8),
    'full_box_norm_upper_bound':int(norm_cap),
    'private_bit_address_bits':int(35),
    'cdf_bits':int(268),
    'threshold_bits':int(257),
    'word_bits':int(384),
    'norm_accumulator_bits':int(45),
    'controls':{k:[None if x is None else int(x) for x in v] for k,v in controls.items()},
    'scope':'Event counts and scalar widths only. Not total CPU/bit cost, not peak memory, not source binding, not a QROM theorem.',
}
Path('result.json').write_text(json.dumps(result,indent=int(2))+'\n')
print('PASS_EXACT_BOOKKEEPING_AND_FINITE_CONTROLS: 11 event counters, scalar widths, 4 stopping controls')
