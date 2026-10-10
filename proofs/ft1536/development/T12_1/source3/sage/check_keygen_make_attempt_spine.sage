#!/usr/bin/env sage
# 056 scoped PUBLIC scripted controls for the attempt-level spine: all six
# gates on ONE AttemptExec derivation, entry facts from the allocation
# freshness, the accepted-break edge and the one-material handoff to the
# encoding-tail input boundary.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# gate-order region; it is a scripted control that supplements, never
# replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
Q = ZZ(18433)
WORKSPACE_BLOCK = ZZ(0)
TABLE_BLOCKS = [ZZ(1), ZZ(2)]
GATES = ['resultants', 'raw_norm', 'gs_norm', 'public', 'solver', 'certificate']


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ------------------------------------------------ 1. six-gate spine on one


def spine_ok(attempt, gates, order):
    ids = [g[ZZ(0)] for g in gates]
    names = [g[ZZ(1)] for g in gates]
    return (ids == [attempt] * ZZ(6) and names == order
            and len(set(ids)) == ZZ(1))


spine_gates = [[ZZ(7), name] for name in GATES]
spine_baseline = spine_ok(ZZ(7), spine_gates, GATES) and spine_ok(
    ZZ(1), [[ZZ(1), name] for name in GATES], GATES)
spine_mutations = {
    'gate_foreign_attempt': not spine_ok(ZZ(7), [[ZZ(7), name] for name in GATES[:ZZ(5)]]
                                         + [[ZZ(8), 'certificate']], GATES),
    'dropped_solver_gate': not spine_ok(ZZ(7), [[ZZ(7), name] for name in GATES
                                                if name != 'solver'], GATES),
    'public_solver_swapped': not spine_ok(ZZ(7), spine_gates[:ZZ(3)]
                                          + [spine_gates[ZZ(4)], spine_gates[ZZ(3)]]
                                          + spine_gates[ZZ(5):], GATES),
    'two_attempts_one_spine': not spine_ok(ZZ(7), [[ZZ(7), name] for name in GATES[:ZZ(3)]]
                                           + [[ZZ(9), name] for name in GATES[ZZ(3):]], GATES),
}

# ------------------------------------- 2. entry facts from the allocation


def fresh_entry(blocks, scratch_block, table_blocks, workspace_block):
    values = list(blocks)
    return (len(set(values)) == len(values)
            and scratch_block not in values
            and workspace_block not in values
            and all(b not in table_blocks for b in values))


entry_blocks = [ZZ(10), ZZ(11), ZZ(12), ZZ(13), ZZ(14), ZZ(15)]
entry_baseline = fresh_entry(entry_blocks, ZZ(4), TABLE_BLOCKS, WORKSPACE_BLOCK)
entry_mutations = {
    'reused_block': not fresh_entry([ZZ(10), ZZ(10), ZZ(12), ZZ(13), ZZ(14), ZZ(15)],
                                    ZZ(4), TABLE_BLOCKS, WORKSPACE_BLOCK),
    'h_shares_f_block': not fresh_entry([ZZ(10), ZZ(11), ZZ(12), ZZ(13), ZZ(10), ZZ(15)],
                                        ZZ(4), TABLE_BLOCKS, WORKSPACE_BLOCK),
    'workspace_collision': not fresh_entry([ZZ(10), ZZ(11), ZZ(12), ZZ(13), ZZ(14), ZZ(0)],
                                           ZZ(4), TABLE_BLOCKS, WORKSPACE_BLOCK),
    'table1_collision': not fresh_entry([ZZ(10), ZZ(11), ZZ(1), ZZ(13), ZZ(14), ZZ(15)],
                                        ZZ(4), TABLE_BLOCKS, WORKSPACE_BLOCK),
}

# --------------------------------------------------- 3. accepted-break edge


def accepted_edge(cert_return, flow, profiled):
    return profiled and cert_return and flow == 'breakLoop'


edge_baseline = (accepted_edge(True, 'breakLoop', True)
                 and not accepted_edge(False, 'continueLoop', True)
                 and not accepted_edge(True, 'normal', True))
edge_mutations = {
    'rejection_as_accept': not accepted_edge(False, 'continueLoop', True),
    'normal_fallthrough': not accepted_edge(True, 'normal', True),
    'unprofiled_as_call': not accepted_edge(True, 'breakLoop', False),
    'retry_edge_as_final': not accepted_edge(False, 'breakLoop', True),
}

# --------------------------------------- 4. one material across the gates


MATERIAL_BLOCKS = [ZZ(2), ZZ(3), ZZ(4), ZZ(5), ZZ(6)]
SCRATCH = ZZ(7)


def material_chain(before, after, written):
    kept = all(before[b] == after[b] for b in MATERIAL_BLOCKS if b not in written)
    return (kept and SCRATCH in written
            and all(b not in written for b in [ZZ(2), ZZ(3), ZZ(6)]))


material_before = {ZZ(2): [ZZ(1)], ZZ(3): [ZZ(2)], ZZ(4): [ZZ(3)], ZZ(5): [ZZ(4)],
                   ZZ(6): [ZZ(5)], ZZ(7): [ZZ(0)]}
material_after = {ZZ(2): [ZZ(1)], ZZ(3): [ZZ(2)], ZZ(4): [ZZ(8)], ZZ(5): [ZZ(9)],
                  ZZ(6): [ZZ(5)], ZZ(7): [ZZ(1)]}
material_baseline = material_chain(material_before, material_after, [ZZ(4), ZZ(5), ZZ(7)])
material_mutations = {
    'solver_writes_h': not material_chain(material_before, {**material_after, ZZ(6): [ZZ(9)]},
                                          [ZZ(4), ZZ(5), ZZ(7), ZZ(6)]),
    'solver_writes_f': not material_chain(material_before, {**material_after, ZZ(2): [ZZ(8)]},
                                          [ZZ(4), ZZ(5), ZZ(7), ZZ(2)]),
    'f_substituted': not material_chain(material_before, {**material_after, ZZ(2): [ZZ(8)]},
                                        [ZZ(4), ZZ(5), ZZ(7)]),
    'scratch_not_written': not material_chain(material_before, material_after, [ZZ(4), ZZ(5)]),
}

# ------------------------------------------- 5. reference C transcription


text = open(SOURCE).read()
public_index = text.index('if (!falcon_compute_public(h, f, g, logn, ter))')
solve_index = text.index('if (!solve_NTRU(fk, F, G, f, g))')
certificate_index = text.index('ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,')
break_index = text.index('Key pair is generated.')
encode_index = text.index('ske[0] = f;')
gate_region = normalize(text[public_index:certificate_index + 200])
expected = [
    'falcon_compute_public(h, f, g, logn, ter)',
    'solve_NTRU(fk, F, G, f, g)',
    'ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
    'ske[0] = f;',
    'ske[3] = G;',
]
transcription_baseline = (all(normalize(line) in normalize(text) for line in expected)
                          and public_index < solve_index < certificate_index
                          < break_index < encode_index
                          and 'continue' in gate_region)
solve_drifted = text.replace('solve_NTRU(fk, F, G, f, g)', 'solve_NTRU(fk, G, F, f, g)')
certificate_drifted = text.replace('ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
                                   'ft_keygen_leaf_certificate((fpr *)fk->tmp, g, f, F, G,')
order_drifted = (text[:public_index] + text[solve_index:solve_index + 60]
                 + text[public_index:solve_index] + text[solve_index + 60:])
missing_gate_drifted = text.replace('ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
                                    'ft_keygen_leaf_skipped((fpr *)fk->tmp, f, g, F, G,')
transcription_mutations = {
    'solver_argument_drift': not all(normalize(line) in normalize(solve_drifted)
                                     for line in expected),
    'certificate_argument_drift': not all(normalize(line) in normalize(certificate_drifted)
                                          for line in expected),
    'gate_order_drift': not (normalize(text).index('solve_NTRU(fk, F, G, f, g)')
                             < normalize(order_drifted).index('falcon_compute_public(h, f, g, logn, ter)')),
    'missing_certificate_gate': not all(normalize(line) in normalize(missing_gate_drifted)
                                        for line in expected),
}

# ------------------------------------------------------------------ report

families = [
    ('six_gate_spine', spine_baseline, spine_mutations),
    ('entry_from_allocation', entry_baseline, entry_mutations),
    ('accepted_break_edge', edge_baseline, edge_mutations),
    ('one_material_chain', material_baseline, material_mutations),
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
       'status': 'PASS_SCRIPTED_ATTEMPT_SPINE_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted six-gate-spine/allocation-freshness/'
                'accepted-edge/material-chain records and a gate-order transcription check '
                'against the reference C source; no real KeyGen/solver/certificate/codec result, no '
                'private key, no probability or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'ntru_q': str(Q), 'workspace_block': str(WORKSPACE_BLOCK),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
