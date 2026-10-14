#!/usr/bin/env sage
# Exact auxiliary controls only. No KeyGen campaign or empirical premise.
import csv, hashlib, json, sys
from pathlib import Path
from sage.env import SAGE_VERSION

root = next(p for p in [Path.cwd(), *Path.cwd().parents]
    if (p / 'notes/run/KEYGEN_SUCCESS_112_INPUTS.json').is_file())
repo = root.parents[4]
manifest = root / 'notes/run/KEYGEN_SUCCESS_112_INPUTS.json'
inputs = json.loads(manifest.read_text())['inputs']
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
for item in inputs:
    assert sha(repo/item['path']) == item['sha256']
probe = repo/'proofs/ft1536/work/FT1536_FG_PROBE_P_ACCEPT_001'
def counters(name):
    with (probe/'out'/name).open() as stream:
        return {row['metric']: row['value'] for row in csv.DictReader(stream)}
primary, control = counters('meas1_summary.csv'), counters('ctl_summary.csv')
assert ZZ(primary['successes']) == 8192 and ZZ(primary['attempts']) == 23628
assert ZZ(control['successes']) == 256 and ZZ(control['attempts']) == 739
rates = []
for record in [primary,control]:
    rejects = sum(ZZ(record[key]) for key in ['reject_resultant_f','reject_resultant_g',
        'reject_norm','reject_gs','reject_public','reject_solve'])
    successes, attempts = ZZ(record['successes']), ZZ(record['attempts'])
    assert rejects == ZZ(record['total_rejects']) and rejects+successes == attempts
    rate = QQ(successes)/attempts
    assert QQ(1)/4 < rate < QQ(1)/2
    rates.append(str(rate))

def digest_observations(name, count):
    lines = (probe/name).read_text().splitlines()
    entries = [line.split() for line in lines if line.split()[0].isdigit()]
    assert len(entries) == count
    assert [ZZ(row[0]) for row in entries] == list(range(count))
    assert all(len(row)==2 and len(row[1])==16 and all(c in '0123456789abcdef' for c in row[1]) for row in entries)
    assert lines[-1] == 'OK %s / %s' % (count,count)
    return entries
assert digest_observations('digests_clean.txt',256) == digest_observations('digests_probe.txt',256)
digest_observations('digests_meas1.txt',8192)
# These are retained observations, not kernel source executions.

space = ZZ(256)^32
assert space == ZZ(2)^256
atom = QQ(1)/space
assert atom > 0 and QQ(8192)/space < QQ(1)/4
assert QQ(ZZ(2)^254)/space == QQ(1)/4
assert QQ(ZZ(2)^254-1)/space < QQ(1)/4

checked = ZZ(0)
for code in range(3^8):
    digits = ZZ(code).digits(base=3,padto=8)
    accepted = {i for i,d in enumerate(digits) if d != 0}
    encoded = {i for i,d in enumerate(digits) if d == 2}
    assert encoded <= accepted
    pA,pC = QQ(len(accepted))/8,QQ(len(encoded))/8
    whole = encoded | {i for i in range(8) if i%2==0}
    pK = QQ(len(whole))/8
    assert pC <= pK
    if pA:
        ratio = pC/pA
        assert 0 <= ratio <= 1 and pA*ratio == pC
    else:
        assert pC == 0
    if encoded:
        assert QQ(1)/8 <= pK
    checked += 1
assert checked == 3^8

# Equal per-attempt marginals, different whole-call availability.
correlated = [(False,False),(True,True)]
antithetic = [(False,True),(True,False)]
def event_mass(rows, predicate):
    return QQ(sum(ZZ(predicate(row)) for row in rows))/len(rows)
for rows in [correlated,antithetic]:
    assert event_mass(rows,lambda x:x[0]) == QQ(1)/2
    assert event_mass(rows,lambda x:x[1]) == QQ(1)/2
assert event_mass(correlated,lambda x:any(x)) == QQ(1)/2
assert event_mass(antithetic,lambda x:any(x)) == 1
geometric = 1-(1-QQ(1)/2)^2
assert geometric == QQ(3)/4
assert geometric != event_mass(correlated,lambda x:any(x))
assert geometric != event_mass(antithetic,lambda x:any(x))

for item in inputs:
    assert sha(repo/item['path']) == item['sha256']
Path('SUCCESS112_CONTROLS.json').write_text(json.dumps({
    'status':'PASS_EXACT_AUXILIARY_CONTROLS_ONLY',
    'software':{'sage':SAGE_VERSION,'python':sys.version},
    'domains':['ZZ','QQ'],'input_manifest_sha256':sha(manifest),
    'measured_rationals':rates,'seed_space_cardinality':str(space),
    'atom_mass':str(atom),'first_attempt_subset_cases':str(checked),
    'preserved_old_observations':{'primary_calls':int(8192),'control_calls':int(256)},
    'rejected_shortcuts':['geometric availability from marginals alone','8192 certified seeds imply quarter population mass'],
    'new_keygen_runs':int(0),'population_probability_lower_bound_proved':False,
    'source_success_witness_constructed':False,'paper_changed':False
},indent=2)+'\n')
