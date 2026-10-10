#!/usr/bin/env sage
# 057 scoped PUBLIC scripted controls for the retry-frame item: the
# solver-call frame on EVERY edge of the solver gate, the rejected edges
# (early search rejection, the failed output gate with PARTIAL output-gate
# writes, zero-return validation) keeping the public h bytes.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# conversion/rejection region; it is a scripted control that supplements,
# never replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
H_BLOCK = ZZ(6)
F_BLOCK = ZZ(4)
G_BLOCK = ZZ(5)
DST_BLOCKS = [F_BLOCK, G_BLOCK]


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ------------------------------------------- 1. h frame on rejected edges


def h_frame(edges):
    return (set(e.get('name') for e in edges) == {'searchRejected', 'outputRejected', 'validatedZero'}
            and all(edge.get('h') == 'kept' for edge in edges))


search_reject = {'name': 'searchRejected', 'h': 'kept'}
output_reject = {'name': 'outputRejected', 'h': 'kept'}
validated_zero = {'name': 'validatedZero', 'h': 'kept'}
h_baseline = h_frame([search_reject, output_reject, validated_zero])
h_mutations = {
    'gate_writes_h': not h_frame([search_reject, {'name': 'outputRejected', 'h': 'written'},
                                  validated_zero]),
    'validation_writes_h': not h_frame([search_reject, output_reject,
                                        {'name': 'validatedZero', 'h': 'written'}]),
    'search_writes_h': not h_frame([{'name': 'searchRejected', 'h': 'written'},
                                    output_reject, validated_zero]),
    'rejected_edge_dropped': not h_frame([search_reject, output_reject]),
}

# ---------------------------------- 2. partial output-gate writes in F/G


SCRATCH = ZZ(7)


def gate_writes(before, after, written):
    kept = all(before[b] == after[b] for b in [H_BLOCK, ZZ(2), ZZ(3)] if b not in written)
    return kept and all(b in DST_BLOCKS + [SCRATCH] for b in written)


gate_before = {ZZ(2): [ZZ(1)], ZZ(3): [ZZ(2)], F_BLOCK: [ZZ(3)], G_BLOCK: [ZZ(4)],
               H_BLOCK: [ZZ(5)], ZZ(7): [ZZ(0)]}
gate_after = {ZZ(2): [ZZ(1)], ZZ(3): [ZZ(2)], F_BLOCK: [ZZ(8)], G_BLOCK: [ZZ(4)],
              H_BLOCK: [ZZ(5)], ZZ(7): [ZZ(1)]}
gate_baseline = (gate_writes(gate_before, gate_after, [F_BLOCK, ZZ(7)])
                 and gate_writes(gate_before, {**gate_after, G_BLOCK: [ZZ(9)]},
                                 [F_BLOCK, G_BLOCK, ZZ(7)]))
gate_mutations = {
    'partial_write_into_h': not gate_writes(gate_before, {**gate_after, H_BLOCK: [ZZ(9)]},
                                            [F_BLOCK, H_BLOCK, ZZ(7)]),
    'partial_write_into_tmp': not gate_writes(gate_before, {**gate_after, ZZ(7): [ZZ(9)]},
                                              [F_BLOCK, ZZ(7), ZZ(3)]),
    'write_outside_dst': not gate_writes(gate_before, {**gate_after, ZZ(2): [ZZ(9)]},
                                         [F_BLOCK, ZZ(2), ZZ(7)]),
    'scratch_claimed_dst': not gate_writes(gate_before, gate_after, [F_BLOCK, ZZ(3)]),
}

# ---------------------------------------- 3. small-body write footprint


def writes_only(names, statements):
    for kind, target in statements:
        if kind == 'store16' and target not in names:
            return False
        if kind == 'modular' and target != 'readonly':
            return False
    return True


body_statements = [('modular', 'readonly'), ('plain', 'locals'), ('store16', 'd'),
                   ('modular', 'readonly'), ('store16', 'd')]
footprint_baseline = (writes_only(['d'], body_statements)
                      and writes_only([], [('modular', 'readonly'), ('modular', 'readonly')]))
footprint_mutations = {
    'store16_into_s': not writes_only(['d'], body_statements[:-ZZ(1)]
                                      + [('store16', 's')]),
    'writable_modular': not writes_only(['d'], body_statements[:-ZZ(1)]
                                        + [('modular', 'store32')]),
    'reject_body_writes': not writes_only([], [('modular', 'readonly'), ('store16', 'd')]),
    'unchecked_code': not writes_only(['d'], [('store16', 'other')]),
}

# --------------------------------------------- 4. solver edge coverage


def edge_set(edges):
    pairs = set((e[ZZ(0)], e[ZZ(1)]) for e in edges)
    return (pairs == {('searchRejected', ZZ(0)), ('outputRejected', ZZ(0)),
                      ('validated', ZZ(0)), ('validated', ZZ(1))})


edges_baseline = edge_set([('searchRejected', ZZ(0)), ('outputRejected', ZZ(0)),
                           ('validated', ZZ(0)), ('validated', ZZ(1))])
edges_mutations = {
    'missing_output_rejected': not edge_set([('searchRejected', ZZ(0)), ('validated', ZZ(0))]),
    'nonboolean_return': not edge_set([('searchRejected', ZZ(0)), ('outputRejected', ZZ(2)),
                                       ('validated', ZZ(1))]),
    'validated_only_success': not edge_set([('searchRejected', ZZ(0)), ('outputRejected', ZZ(0)),
                                            ('validated', ZZ(1))]),
    'no_rejected_edge': not edge_set([('validated', ZZ(1))]),
}

# ------------------------------------------- 5. reference C transcription


text = open(SOURCE).read()
NEEDLES = [
    'poly_big_to_small(F, fk->tmp, logn, fk->ternary)',
    'poly_big_to_small(G, fk->tmp + n, logn, fk->ternary)',
    'solve_NTRU(fk, F, G, f, g)',
]


def transcription_ok(t):
    if not all(normalize(n) in normalize(t) for n in NEEDLES):
        return False
    c1 = t.index(NEEDLES[ZZ(0)])
    c2 = t.index(NEEDLES[ZZ(1)])
    sc = t.index(NEEDLES[ZZ(2)])
    return c1 < c2 < sc and 'return 0;' in t[c2:c2 + 120]


transcription_baseline = transcription_ok(text)
dst_drifted = text.replace('poly_big_to_small(F, fk->tmp, logn, fk->ternary)',
                           'poly_big_to_small(fk->tmp, F, logn, fk->ternary)')
src_drifted = text.replace('poly_big_to_small(G, fk->tmp + n, logn, fk->ternary)',
                           'poly_big_to_small(G, fk->tmp, logn, fk->ternary)')
first_conv = text.index(NEEDLES[ZZ(0)])
second_conv = text.index(NEEDLES[ZZ(1)])
order_drifted = (text[:first_conv] + text[second_conv:second_conv + 60]
                 + text[first_conv:second_conv] + text[second_conv + 60:])
reject_return = text.index('return 0;', second_conv)
missing_reject_drifted = (text[:reject_return]
                          + text[reject_return:].replace('return 0;', 'return 1;', 1))
transcription_mutations = {
    'destination_drift': not transcription_ok(dst_drifted),
    'source_offset_drift': not transcription_ok(src_drifted),
    'conversion_order_drift': not transcription_ok(order_drifted),
    'reject_return_drift': not transcription_ok(missing_reject_drifted),
}

# ------------------------------------------------------------------ report

families = [
    ('rejected_edge_h_frame', h_baseline, h_mutations),
    ('partial_output_gate_writes', gate_baseline, gate_mutations),
    ('small_body_footprint', footprint_baseline, footprint_mutations),
    ('solver_edge_coverage', edges_baseline, edges_mutations),
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
       'status': 'PASS_SCRIPTED_RETRY_FRAME_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted rejected-edge h-frame/partial-write/footprint/'
                'edge-coverage records and a conversion/rejection transcription check '
                'against the reference C source; no real KeyGen/solver/certificate/codec result, no '
                'private key, no probability or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'h_block': str(H_BLOCK), 'dst_blocks': [str(b) for b in DST_BLOCKS],
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
