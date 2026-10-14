# Exact finite controls only; no actual KeyGen seeds are enumerated.
from pathlib import Path
from sage.env import SAGE_VERSION
import json
import platform
import sys

cardinality = ZZ(256)^32
assert cardinality == ZZ(2)^256

# Disjoint whole-call outcomes; keyA/keyB are symbolic test labels.
outcomes = ['noDefined', 'cap', 'cap', 'encoding', 'keyA', 'keyA', 'keyA', 'keyB']
labels = ['noDefined', 'readiness', 'cap', 'encoding', 'keyA', 'keyB']
raw = {label: QQ(outcomes.count(label))/ZZ(len(outcomes)) for label in labels}
assert sum(raw.values(), QQ(0)) == 1
success = raw['keyA'] + raw['keyB']
assert success == QQ(1)/2
assert raw['noDefined'] + raw['readiness'] + raw['cap'] + raw['encoding'] + success == 1

def conditioned(values):
    denominator = sum(values.values(), QQ(0))
    if denominator == 0:
        return None
    return {key: value/denominator for key, value in values.items()}

keys = conditioned({key: raw[key] for key in ['keyA', 'keyB']})
assert keys == {'keyA': QQ(3)/4, 'keyB': QQ(1)/4}
assert conditioned({'keyA': QQ(0), 'keyB': QQ(0)}) is None

# A many-to-one public map tests aggregation, not an injectivity shortcut.
public = {'h': sum(keys.values(), QQ(0))}
raw_public_success = {'h': raw['keyA'] + raw['keyB']}
assert conditioned(raw_public_success) == public == {'h': QQ(1)}

# Orthogonal count formula and explicit rejected wrong normalizations.
assert keys['keyA'] == QQ(outcomes.count('keyA'))/ZZ(sum(label.startswith('key') for label in outcomes))
assert sum(raw[label] for label in labels if label != 'encoding') != 1
assert raw['keyA'] != keys['keyA']
wrong = conditioned({'keyA': raw['keyA'] + raw['noDefined'], 'keyB': raw['keyB']})
assert wrong != keys

result = {
    'status': 'PASS_EXACT_FINITE_CONTROLS_ONLY',
    'domain': 'ZZ / QQ; standard Sage preparser',
    'seed_cardinality': str(cardinality),
    'toy_outcomes': outcomes,
    'raw_mass': {key: str(value) for key, value in raw.items()},
    'success_mass': str(success),
    'conditional_keys': {key: str(value) for key, value in keys.items()},
    'conditional_public': {key: str(value) for key, value in public.items()},
    'zero_success_returns_none': True,
    'rejected_mutations': ['omit_encoding_failure_mass', 'use_raw_mass_as_conditional', 'count_noDefined_as_keyA'],
    'actual_keygen_seed_enumeration': False,
    'actual_acceptance_probability_computed': False,
    'non_claims': ['No actual KeyGen frequency or acceptance lower bound', 'No IID/retry-geometric inference', 'Not a replacement for general kernel theorems'],
    'software': {'sage': SAGE_VERSION, 'python': sys.version},
    'hardware': {'machine': platform.machine(), 'platform': platform.platform()}
}
text = json.dumps(result, indent=2, sort_keys=True) + '\n'
roundtrip = json.loads(text)
assert QQ(roundtrip['success_mass']) == success
assert ZZ(roundtrip['seed_cardinality']) == cardinality
Path('LAW110_CONTROLS.json').write_text(text)
