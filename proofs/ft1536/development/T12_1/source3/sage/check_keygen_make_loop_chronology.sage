#!/usr/bin/env sage
# 061 scoped PUBLIC scripted controls for the loop-trace chronology
# composition of the per-retry transport and the `TailCells` derivation,
# plus the finite-live-set repair of the virtual map legality class.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# attempt-loop/encoding-tail region; it is a scripted control that
# supplements, never replaces, the kernel proofs.
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


MODULUS = ZZ(2) ** 64

# ----------------------------- 1. finite live-set legality of the address map

LIVE = [3, 7, 11, 42]
BASE = {3: 100, 7: 200, 11: 300, 42: 400}


def map_legal(live_blocks, base_of, domain_size):
    """Bounded and injective on the FINITE live set; the unqualified all-Nat
    domain exceeds the modulus and is rejected by pigeonhole."""
    if domain_size > MODULUS:
        return False
    values = [ZZ(base_of(b)) for b in live_blocks]
    return all(0 <= v < MODULUS for v in values) and len(set(values)) == len(values)


legality_baseline = map_legal(LIVE, BASE.get, len(LIVE))
legality_mutations = {
    'global_quantifier_restored': not map_legal(LIVE, BASE.get, MODULUS + 1),
    'live_block_unbounded': not map_legal(LIVE, lambda b: MODULUS + BASE[b], len(LIVE)),
    'live_collision': not map_legal([3, 7, 11], lambda b: 5, 3),
    'word_wrap_collision': not map_legal([3, 7], lambda b: 5 if b == 3 else 5 + MODULUS, 2),
}

# -------------------------------- 2. pointer roundtrip on the live set


def roundtrip(stored_word, read_word, canonical, live_injective):
    return (stored_word == read_word and 0 <= stored_word < MODULUS
            and canonical and live_injective)


WORD = ZZ(123456789012345)
roundtrip_baseline = roundtrip(WORD, WORD, True, True)
roundtrip_mutations = {
    'word_drift': not roundtrip(WORD, WORD + 1, True, True),
    'noncanonical_shape': not roundtrip(WORD, WORD, False, True),
    'map_not_injective_on_live': not roundtrip(WORD, WORD, True, False),
    'truncated_address': not roundtrip(WORD + MODULUS, WORD, True, True),
}

# ------------------------------- 3. loop-trace chronology of the retry fold


def chronology(steps, counter):
    """Rejected attempts chain to the single accepted final attempt; the
    per-retry facts survive each step and the counter advances by one."""
    if not steps or steps[-1] != 'accepted':
        return False
    if any(s != 'rejected' for s in steps[:-1]):
        return False
    return counter == len(steps)


chronology_baseline = chronology(['rejected', 'rejected', 'accepted'], 3)
chronology_mutations = {
    'accepted_edge_lost': not chronology(['rejected', 'rejected'], 2),
    'counter_not_advanced': not chronology(['rejected', 'rejected', 'accepted'], 2),
    'interior_acceptance': not chronology(['rejected', 'accepted', 'accepted'], 3),
    'empty_loop': not chronology([], 0),
}

# ------------------------------------- 4. TailCells derivation at the tail entry

CELLS = ['privkey', 'privkey_len', 'pubkey', 'pubkey_len', 'comp',
         'logn', 'ter', 'material', 'publicCell', 'ske']


def tail_cells(cells, logn_value, ter_value):
    return sorted(cells) == sorted(CELLS) and logn_value == 10 and ter_value == 1


cells_baseline = tail_cells(list(CELLS), 10, 1)
cells_mutations = {
    'material_cell_lost': not tail_cells([c for c in CELLS if c != 'material'], 10, 1),
    'ske_cell_lost': not tail_cells([c for c in CELLS if c != 'ske'], 10, 1),
    'logn_drift': not tail_cells(list(CELLS), 9, 1),
    'ter_drift': not tail_cells(list(CELLS), 10, 2),
}

# ------------------------------------------------- 5. reference C transcription

text = open(locate(SOURCE)).read()
NEEDLES = [
    'for (;;) {',
    'local_attempts ++;',
    'sample_true_ternary_secret(fk, f, n);',
    'sample_true_ternary_secret(fk, g, n);',
    'if (!solve_NTRU(fk, F, G, f, g)) {',
    'break;',
    'klen = *privkey_len;',
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
cap_drifted = text.replace('local_attempts ++;', 'attempts_total ++;', 1)
sample_drifted = text.replace('sample_true_ternary_secret(fk, g, n);',
                              'sample_true_ternary_secret(fk, f, n);', 1)
solver_drifted = text.replace('if (!solve_NTRU(fk, F, G, f, g)) {',
                              'if (!solve_NTRU(fk, F, G, g, f)) {', 1)
tail_drifted = text.replace('klen = *privkey_len;', 'klen = privkey_len;', 1)
transcription_mutations = {
    'attempt_counter_drift': not transcription_ok(cap_drifted),
    'sampler_order_drift': not transcription_ok(sample_drifted),
    'solver_argument_drift': not transcription_ok(solver_drifted),
    'tail_entry_drift': not transcription_ok(tail_drifted),
}

# ------------------------------------------------------------------ report

families = [
    ('live_map_legality', legality_baseline, legality_mutations),
    ('pointer_roundtrip', roundtrip_baseline, roundtrip_mutations),
    ('retry_chronology', chronology_baseline, chronology_mutations),
    ('tail_cells_derivation', cells_baseline, cells_mutations),
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
       'status': 'PASS_SCRIPTED_LOOP_CHRONOLOGY_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted finite-live-set-map-legality/pointer-roundtrip/'
                'retry-chronology/tail-cells records and a transcription check of the attempt-loop/'
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
