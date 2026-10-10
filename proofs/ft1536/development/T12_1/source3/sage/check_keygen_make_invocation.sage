#!/usr/bin/env sage
# 060 scoped PUBLIC scripted controls for the whole-invocation statement-machine
# execution: the 18-statement encoding tail run to the actual encoder call
# sites, the four output-capacity return-0 edges, the complete teardown on
# every return edge and the write-then-read pointer uniqueness of the `ske`
# cells. EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate
# or codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# encoding-tail region; it is a scripted control that supplements, never
# replaces, the kernel proofs.
import json
import os
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]


def locate(name):
    here = os.getcwd()
    for _ in range(12):
        candidate = os.path.join(here, name)
        if os.path.exists(candidate):
            return candidate
        here = os.path.dirname(here)
    raise SystemExit('reference source not found: ' + name)


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# --------------------------- 1. the 18-statement encoding-tail source shape

TAIL = ['klen=*privkey_len', 'skbuf=privkey', 'capacity:klen<1', 'skbuf[0]=header',
        'skoff=1', 'ske[0]=f', 'ske[1]=g', 'ske[2]=F', 'ske[3]=G',
        'segments:encode_small', '*privkey_len=skoff', 'klen=*pubkey_len',
        'capacity:klen<1', 'pubkey[0]=header', 'dispatch:encode_18433/12289',
        'capacity:klen==0', '*pubkey_len=klen+1', 'return 1']


def tail_shape(statements):
    return statements == TAIL


tail_baseline = tail_shape(list(TAIL))
tail_mutations = {
    'ske_store_dropped': not tail_shape(TAIL[:5] + TAIL[6:]),
    'segments_reordered': not tail_shape(TAIL[:9] + [TAIL[10], TAIL[9]] + TAIL[11:]),
    'final_return_lost': not tail_shape(TAIL[:17] + ['fallthrough']),
    'length_store_swapped': not tail_shape(TAIL[:10] + [TAIL[11], TAIL[10]] + TAIL[12:]),
}

# ------------------------------------------------- 2. output-capacity events

CAPACITY_EDGES = ['klen<1-private', 'elen==0-segment', 'klen<1-public', 'klen==0-public']


def capacity_events(edges, return_zero):
    return sorted(edges) == sorted(CAPACITY_EDGES) and return_zero


capacity_baseline = capacity_events(list(CAPACITY_EDGES), True)
capacity_mutations = {
    'segment_edge_lost': not capacity_events(CAPACITY_EDGES[:1] + CAPACITY_EDGES[2:], True),
    'private_precheck_lost': not capacity_events(CAPACITY_EDGES[1:], True),
    'public_zero_edge_lost': not capacity_events(CAPACITY_EDGES[:3], True),
    'capacity_returns_one': not capacity_events(list(CAPACITY_EDGES), False),
}

# ------------------------------------------------------ 3. complete teardown

RETURN_EDGES = ['return-0-private', 'return-0-segment', 'return-0-public',
                'return-0-encode', 'return-0-cap', 'return-1']


def teardown(edges, disposed, restored):
    return sorted(edges) == sorted(RETURN_EDGES) and disposed and restored


teardown_baseline = teardown(list(RETURN_EDGES), True, True)
teardown_mutations = {
    'success_edge_unclosed': not teardown(RETURN_EDGES[:-1], True, True),
    'cap_edge_unclosed': not teardown(RETURN_EDGES[1:2] + RETURN_EDGES[2:5], True, True),
    'blocks_not_disposed': not teardown(list(RETURN_EDGES), False, True),
    'scope_not_restored': not teardown(list(RETURN_EDGES), True, False),
}

# -------------------------------- 4. pointer roundtrip: write then read back

MODULUS = ZZ(2) ** 64


def roundtrip(stored_word, read_word, canonical, injective_map):
    return (stored_word == read_word and 0 <= stored_word < MODULUS
            and canonical and injective_map)


WORD = ZZ(123456789012345)
roundtrip_baseline = roundtrip(WORD, WORD, True, True)
roundtrip_mutations = {
    'word_drift': not roundtrip(WORD, WORD + 1, True, True),
    'noncanonical_shape': not roundtrip(WORD, WORD, False, True),
    'map_not_injective': not roundtrip(WORD, WORD, True, False),
    'truncated_address': not roundtrip(WORD + MODULUS, WORD, True, True),
}

# ------------------------------------------- 5. reference C transcription

text = open(locate(SOURCE)).read()
NEEDLES = [
    'klen = *privkey_len;',
    'skbuf = privkey;',
    'elen = falcon_encode_small(',
    '*privkey_len = skoff;',
    'klen = falcon_encode_18433(',
    'if (klen == 0) {',
    '*pubkey_len = klen + 1;',
    'return 1;',
]


def transcription_ok(t):
    cursor = 0
    for n in NEEDLES:
        position = t.find(n, cursor)
        if position < 0:
            return False
        cursor = position + len(n)
    return True


transcription_baseline = transcription_ok(text)
len_drifted = text.replace('klen = *privkey_len;', 'klen = privkey_len;', 1)
dst_drifted = text.replace('skbuf = privkey;', 'skbuf = pubkey;', 1)
call_drifted = text.replace('elen = falcon_encode_small(', 'elen = falcon_encode_12289(', 1)
store_drifted = text.replace('*privkey_len = skoff;', '*pubkey_len = skoff;', 1)
transcription_mutations = {
    'private_length_read_drift': not transcription_ok(len_drifted),
    'skbuf_binding_drift': not transcription_ok(dst_drifted),
    'segment_call_drift': not transcription_ok(call_drifted),
    'length_store_drift': not transcription_ok(store_drifted),
}

# ------------------------------------------------------------------ report

families = [
    ('encoding_tail_shape', tail_baseline, tail_mutations),
    ('output_capacity_events', capacity_baseline, capacity_mutations),
    ('complete_teardown', teardown_baseline, teardown_mutations),
    ('pointer_roundtrip', roundtrip_baseline, roundtrip_mutations),
    ('reference_transcription', transcription_baseline, transcription_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_INVOCATION_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted encoding-tail-shape/output-capacity/'
                'complete-teardown/pointer-roundtrip records and a transcription check of the '
                'encoding-tail region against the reference C source; no real KeyGen/solver/'
                'certificate/codec result, no private key, no probability or law claim; '
                'supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
