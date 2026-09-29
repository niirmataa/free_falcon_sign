"""Create independent negative fixtures without changing pinned C or baselines."""
from pathlib import Path
import json

w = Path(__file__).resolve().parents[2]
src = w/'run/own_sage_005/build/review_vectors.tsv'
dest = w/'run/own_mutations_001'
assert not dest.exists()
dest.mkdir()
rows = [line.split() for line in src.read_text().splitlines()]
targets = [
    ('sign', next(x for x in rows if x[0]=='neg' and x[1]=='0000000000000000')),
    ('shift', next(x for x in rows if x[0]=='ursh' and x[1]=='8000000000000000' and x[2]=='0000000000000001')),
    ('rounding', next(x for x in rows if x[0]=='rint' and x[1]=='4004000000000000')),
]
for label,row in targets:
    broken = row.copy()
    broken[4] = f'{int(row[4],16) ^ 1:016x}'
    (dest/f'{label}.tsv').write_text('\t'.join(broken)+'\n')
    assert broken[4] != row[4]
invalid = next(x for x in rows if x[0]=='ulsh' and x[1]=='0000000000000001').copy()
invalid[2] = '0000000000000040'
(dest/'invalid_shift.tsv').write_text('\t'.join(invalid)+'\n')
(dest/'mutation_plan.json').write_text(json.dumps({
    'schema':'V02_MUTATION_PLAN_V1', 'oracle_sha':'independent Sage own_sage_005',
    'expected_exit':{'sign':1,'shift':1,'rounding':1,'invalid_shift':4},
    'scope':'wrong output oracle/illegal count checks; author replay has real source mutations'
}, indent=2)+'\n')
print(dest, [x[0] for x in targets], 'invalid shift count64')
