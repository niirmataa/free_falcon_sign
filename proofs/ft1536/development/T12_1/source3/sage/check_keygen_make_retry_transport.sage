#!/usr/bin/env sage
# 058 scoped PUBLIC scripted controls for the retry-transport item: the
# `Initial`/legal/static entry facts of `entry_of_allocation` transported
# through EVERY attempt instance on EVERY return edge, and the gate-time
# `ReadTmp` tie of the executed `fk->tmp` binding through the same frames.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# allocation-binding/gate-call region; it is a scripted control that
# supplements, never replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
OBJECT_BLOCK = ZZ(8)
PRIMES_BLOCK = ZZ(1)
REV_BLOCK = ZZ(2)


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ----------------------------- 1. entry facts on every attempt return edge


def attempt_edges(edges):
    expected = {'earlyRejected', 'certificateRejected', 'acceptedBreak', 'unprofiledSkip'}
    return (set(e.get('name') for e in edges) == expected
            and all(e.get('entry') == 'kept' for e in edges))


edge_baseline_edges = [{'name': n, 'entry': 'kept'} for n in
                       ['earlyRejected', 'certificateRejected', 'acceptedBreak', 'unprofiledSkip']]
edges_baseline = attempt_edges(edge_baseline_edges)


def edge_drop(name):
    return [e for e in edge_baseline_edges if e.get('name') != name]


def edge_write(name):
    return [dict(e, entry='lost') if e.get('name') == name else e for e in edge_baseline_edges]


edges_mutations = {
    'early_edge_dropped': not attempt_edges(edge_drop('earlyRejected')),
    'retry_edge_lost_entry': not attempt_edges(edge_write('certificateRejected')),
    'accepted_edge_lost_entry': not attempt_edges(edge_write('acceptedBreak')),
    'skip_edge_dropped': not attempt_edges(edge_drop('unprofiledSkip')),
}

# ------------------------------- 2. entry frame keeps the three entry blocks


def entry_frame(blocks, sizes, writable):
    return (set(blocks) == {OBJECT_BLOCK, PRIMES_BLOCK, REV_BLOCK}
            and sizes == 'kept' and writable == 'kept')


frame_baseline = entry_frame([OBJECT_BLOCK, PRIMES_BLOCK, REV_BLOCK], 'kept', 'kept')
frame_mutations = {
    'prime_block_dropped': not entry_frame([OBJECT_BLOCK, REV_BLOCK], 'kept', 'kept'),
    'rev_block_dropped': not entry_frame([OBJECT_BLOCK, PRIMES_BLOCK], 'kept', 'kept'),
    'size_metadata_drift': not entry_frame([OBJECT_BLOCK, PRIMES_BLOCK, REV_BLOCK], 'lost', 'kept'),
    'writable_metadata_drift': not entry_frame([OBJECT_BLOCK, PRIMES_BLOCK, REV_BLOCK], 'kept', 'lost'),
}

# --------------------- 3. gate-time ReadTmp tie through the fk->tmp binding

RNG_LO = ZZ(8)
RNG_HI = ZZ(424)
TMP_FIELD = ZZ(432)


def readtmp_tie(member, load_field, binding, legal):
    return (member == TMP_FIELD and RNG_HI <= member
            and load_field == member and binding == 'executed' and legal == 'held')


tie_baseline = readtmp_tie(TMP_FIELD, TMP_FIELD, 'executed', 'held')
tie_mutations = {
    'member_inside_rng_region': not readtmp_tie(RNG_LO, RNG_LO, 'executed', 'held'),
    'wrong_load_field': not readtmp_tie(TMP_FIELD, ZZ(424), 'executed', 'held'),
    'binding_readback_dropped': not readtmp_tie(TMP_FIELD, TMP_FIELD, 'dropped', 'held'),
    'object_legal_dropped': not readtmp_tie(TMP_FIELD, TMP_FIELD, 'executed', 'lost'),
}

# ------------------------------------------- 4. reference C transcription


text = open(SOURCE).read()
NEEDLES = [
    'fk = malloc(sizeof *fk);',
    'fk->tmp_len = temp_size(logn, ternary);',
    'fk->tmp = malloc(fk->tmp_len);',
    'ft_keygen_leaf_certificate((fpr *)fk->tmp',
]


def transcription_ok(t):
    if not all(normalize(n) in normalize(t) for n in NEEDLES):
        return False
    positions = [t.index(n) for n in NEEDLES]
    return positions == sorted(positions)


transcription_baseline = transcription_ok(text)
object_drifted = text.replace('fk = malloc(sizeof *fk);', 'fk = malloc(sizeof *fk) + 1;', 1)
temp_drifted = text.replace('fk->tmp_len = temp_size(logn, ternary);',
                            'fk->tmp_len = temp_size(logn, 0);', 1)
binding_drifted = text.replace('fk->tmp = malloc(fk->tmp_len);', 'fk->tmp = malloc(fk->tmp_len + 8);', 1)
gate_drifted = text.replace('ft_keygen_leaf_certificate((fpr *)fk->tmp',
                            'ft_keygen_leaf_certificate((fpr *)fk->rng', 1)
transcription_mutations = {
    'object_allocation_drift': not transcription_ok(object_drifted),
    'temp_size_call_drift': not transcription_ok(temp_drifted),
    'tmp_binding_drift': not transcription_ok(binding_drifted),
    'gate_call_site_drift': not transcription_ok(gate_drifted),
}

# --------------------------- 5. named cert-entry residual on both call edges


def cert_residual(reject_edge, accept_edge, forbidden):
    return reject_edge == 'named_residual' and accept_edge == 'named_residual' and not forbidden


residual_baseline = cert_residual('named_residual', 'named_residual', False)
residual_mutations = {
    'reject_edge_residual_dropped': not cert_residual('dropped', 'named_residual', False),
    'accept_edge_residual_dropped': not cert_residual('named_residual', 'dropped', False),
    'residual_dropped_both_edges': not cert_residual('dropped', 'dropped', False),
    'scratch_block0_premise_smuggled': not cert_residual('named_residual', 'named_residual', True),
}

# ------------------------------------------------------------------ report

families = [
    ('attempt_edge_entry_transport', edges_baseline, edges_mutations),
    ('entry_frame_blocks', frame_baseline, frame_mutations),
    ('readtmp_binding_tie', tie_baseline, tie_mutations),
    ('reference_transcription', transcription_baseline, transcription_mutations),
    ('cert_entry_residual', residual_baseline, residual_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_RETRY_TRANSPORT_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted attempt-edge entry-transport/entry-frame/'
                'ReadTmp-binding-tie records, a cert-entry-residual presence check and an '
                'allocation/gate-call transcription check against the reference C source; '
                'no real KeyGen/solver/certificate/codec result, no private key, no probability '
                'or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
