#!/usr/bin/env sage
# 062 scoped PUBLIC scripted controls for the reachable-state certificate
# premise repair and the derived `ske` cell call-site liveness.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# certificate-gate/encoding-tail region; it is a scripted control that
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

# ------------------- 1. reachable-state gate premises vs global quantifiers


def gate_premises(counter_transport, derived_dimensions, global_quantifier):
    """The gate-state `Dimensions` instance must be DERIVED along the
    attempt/loop chronology; a quantifier over all states is rejected by
    the empty-locals witness and never counts as a derivation."""
    return counter_transport and derived_dimensions and not global_quantifier


premises_baseline = gate_premises(True, True, False)
premises_mutations = {
    'global_quantifier_accepted': not gate_premises(True, True, True),
    'counter_not_transported': not gate_premises(False, True, False),
    'gate_dimensions_assumed': not gate_premises(True, False, False),
    'both_missing': not gate_premises(False, False, False),
}

# ------------------------- 2. reachable workspace derivation at the gate state


def workspace_chain(scratch_legal, space_bound, bridge_block0, shape_pinned):
    """LegalWorkspace at the reachable gate state follows from the
    transported scratch legality, the automatic-object space bound, the
    bridge-field block numbering and the allocation shape."""
    return scratch_legal and space_bound and bridge_block0 and shape_pinned


workspace_baseline = workspace_chain(True, True, True, True)
workspace_mutations = {
    'block0_assumed': not workspace_chain(True, True, False, True),
    'space_dropped': not workspace_chain(True, False, True, True),
    'scratch_untransported': not workspace_chain(False, True, True, True),
    'shape_unpinned': not workspace_chain(True, True, True, False),
}

# ------------------------------------------- 3. ske cell write-then-read history

MODULUS64 = MODULUS
CELL_BASE = 4096
SEGMENT_BASE = {0: 100, 1: 200, 2: 300, 3: 400}


def cell_history(stored_word, read_word, foreign_preserved, canonical):
    """The store creates the cell word, foreign stores preserve it, and the
    canonical read returns the stored word."""
    return (stored_word == read_word and foreign_preserved
            and canonical and 0 <= stored_word < MODULUS64)


history_baseline = cell_history(CELL_BASE + 100, CELL_BASE + 100, True, True)
history_mutations = {
    'word_drift': not cell_history(CELL_BASE + 100, CELL_BASE + 101, True, True),
    'foreign_clobber': not cell_history(CELL_BASE + 100, CELL_BASE + 100, False, True),
    'noncanonical_read': not cell_history(CELL_BASE + 100, CELL_BASE + 100, True, False),
    'word_wrap': not cell_history(CELL_BASE + 100 + MODULUS64, CELL_BASE + 100, True, True),
}

# -------------------------- 4. explicit live-set extension decides the decode


def decode_live(live_injective, extended, read_block_live):
    """With the explicit live-set extension the word round-trip decides the
    read pointer and its liveness FOLLOWS; without the extension a word
    alias outside the live set is unconstrained and the decode is open."""
    return live_injective and extended and read_block_live


decode_baseline = decode_live(True, True, True)
decode_mutations = {
    'extension_missing': not decode_live(True, False, True),
    'membership_assumed': not decode_live(False, True, True),
    'alias_unconstrained': not decode_live(True, True, False),
    'nothing_holds': not decode_live(False, False, False),
}

# ------------------------------------------------- 5. reference C transcription

text = open(locate(SOURCE)).read()
NEEDLES = [
    'ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
    'klen = *privkey_len;',
    'skbuf = privkey;',
    'ske[0] = f;',
    'ske[1] = g;',
    'ske[2] = F;',
    'ske[3] = G;',
    'for (i = 0; i < 4; i ++) {',
    'elen = falcon_encode_small(skbuf + skoff, klen - skoff,',
    '*privkey_len = skoff;',
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
gate_drifted = text.replace('ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
                            'ft_keygen_leaf_certificate((fpr *)fk->tmp, g, f, F, G,', 1)
bind_drifted = text.replace('ske[0] = f;', 'ske[0] = g;', 1)
loop_drifted = text.replace('for (i = 0; i < 4; i ++) {', 'for (i = 0; i < 3; i ++) {', 1)
tail_drifted = text.replace('*privkey_len = skoff;', '*privkey_len = klen;', 1)
transcription_mutations = {
    'gate_argument_drift': not transcription_ok(gate_drifted),
    'ske_binding_drift': not transcription_ok(bind_drifted),
    'segment_loop_drift': not transcription_ok(loop_drifted),
    'tail_write_drift': not transcription_ok(tail_drifted),
}

# ------------------------------------------------------------------ report

families = [
    ('reachable_gate_premises', premises_baseline, premises_mutations),
    ('workspace_derivation', workspace_baseline, workspace_mutations),
    ('ske_cell_history', history_baseline, history_mutations),
    ('live_set_extension_decode', decode_baseline, decode_mutations),
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
       'status': 'PASS_SCRIPTED_CERTIFICATE_PREMISE_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted reachable-premise/workspace-derivation/'
                'ske-cell-history/live-set-extension records and a transcription check of the '
                'certificate-gate/encoding-tail region against the reference C source; no real '
                'KeyGen/solver/certificate/codec result, no private key, no probability or law '
                'claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
