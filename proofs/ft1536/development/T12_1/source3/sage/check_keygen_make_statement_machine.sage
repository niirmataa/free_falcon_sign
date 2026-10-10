#!/usr/bin/env sage
# 059 scoped PUBLIC scripted controls for the statement-machine extraction:
# the C call site `(fpr *)fk->tmp` tied to `ExecAt` through the `temp_size`
# reservation body and the `falcon_keygen_new` prologue binding, the b-not-1/2
# side condition of the pinned transport discharged from allocation freshness,
# the `call_same_block` foreign-block frame and the `EntryFacts`/`CertEntryFrame`
# residual discharges. EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler,
# solver, certificate or codec result, no private key, no probability/law
# claim. The transcription family reads the REFERENCE C source (Extra/c) and
# compares the pinned allocation/gate-call region; it is a scripted control
# that supplements, never replaces, the kernel proofs.
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


# ----------------------- 1. b-not-1/2 side condition from allocation freshness

SCRATCH = ZZ(0)


def freshness_side(scratch_block, scratch_size_before, table1_live, table2_live):
    return (scratch_size_before == 0 and table1_live and table2_live
            and scratch_block != 1 and scratch_block != 2)


side_baseline = freshness_side(SCRATCH, ZZ(0), True, True)
side_mutations = {
    'table_blocks_not_live': not freshness_side(SCRATCH, ZZ(0), False, True),
    'scratch_not_fresh': not freshness_side(SCRATCH, ZZ(286720), True, True),
    'scratch_at_table_block_1': not freshness_side(ZZ(1), ZZ(0), True, True),
    'scratch_at_table_block_2': not freshness_side(ZZ(2), ZZ(0), True, True),
}

# ------------------------------------- 2. call-site bridge: temp_size and cast

WORKSPACE_BYTES = ZZ(286720)
SCRATCH_WORDS = ZZ(71680)


def call_site_bridge(extent, workspace, cast_count):
    return extent == WORKSPACE_BYTES and workspace == WORKSPACE_BYTES \
        and cast_count == extent / 8


bridge_baseline = call_site_bridge(WORKSPACE_BYTES, WORKSPACE_BYTES, ZZ(35840))
bridge_mutations = {
    'temp_size_value_drift': not call_site_bridge(ZZ(286728), WORKSPACE_BYTES, ZZ(35841)),
    'workspace_extent_drift': not call_site_bridge(WORKSPACE_BYTES, ZZ(286712), ZZ(35840)),
    'cast_span_drift': not call_site_bridge(WORKSPACE_BYTES, WORKSPACE_BYTES, ZZ(35839)),
    'reservation_not_workspace': not call_site_bridge(WORKSPACE_BYTES, ZZ(1024), ZZ(35840)),
}

# ------------------------------- 3. call_same_block frame on foreign blocks


def same_block(block, ret, beyond_size, kept):
    foreign = block != 0 and block != 1 and block != 2
    if beyond_size:
        return foreign and kept == 'leave_bytes' and ret in ('true', 'false')
    return foreign and kept == 'source_frame' and ret in ('true', 'false')


frame_baseline = same_block(ZZ(7), 'true', False, 'source_frame') \
    and same_block(ZZ(7), 'false', False, 'source_frame') \
    and same_block(ZZ(7), 'true', True, 'leave_bytes') \
    and same_block(ZZ(7), 'false', True, 'leave_bytes')
frame_mutations = {
    'workspace_block_admitted': not same_block(ZZ(0), 'true', False, 'source_frame'),
    'table_block_admitted': not same_block(ZZ(1), 'false', False, 'source_frame'),
    'rejected_return_frame_dropped': not same_block(ZZ(7), 'false', False, 'dropped'),
    'beyond_size_leg_dropped': not same_block(ZZ(7), 'true', True, 'source_frame'),
}

# ------------------------------------------- 4. reference C transcription

text = open(locate(SOURCE)).read()
NEEDLES = [
    'fk->tmp_len = temp_size(logn, ternary);',
    'fk->tmp = malloc(fk->tmp_len);',
    'if (fk->tmp == NULL) {',
    'ft_keygen_leaf_certificate((fpr *)fk->tmp',
]


def transcription_ok(t):
    if not all(normalize(n) in normalize(t) for n in NEEDLES):
        return False
    positions = [t.index(n) for n in NEEDLES]
    return positions == sorted(positions)


transcription_baseline = transcription_ok(text)
temp_drifted = text.replace('fk->tmp_len = temp_size(logn, ternary);',
                            'fk->tmp_len = temp_size(logn, 0);', 1)
malloc_drifted = text.replace('fk->tmp = malloc(fk->tmp_len);',
                              'fk->tmp = malloc(fk->tmp_len + 8);', 1)
guard_drifted = text.replace('if (fk->tmp == NULL) {',
                             'if (fk->tmp_len == 0) {', 1)
cast_drifted = text.replace('ft_keygen_leaf_certificate((fpr *)fk->tmp',
                            'ft_keygen_leaf_certificate((uint32_t *)fk->tmp', 1)
transcription_mutations = {
    'temp_size_call_drift': not transcription_ok(temp_drifted),
    'malloc_binding_drift': not transcription_ok(malloc_drifted),
    'null_guard_drift': not transcription_ok(guard_drifted),
    'fpr_cast_site_drift': not transcription_ok(cast_drifted),
}

# ----------------------- 5. EntryFacts/CertEntryFrame freshness discharges


def fresh_discharge(material_blocks, h_block, live_blocks, forbidden_premise):
    separated = all(b not in (0, 1, 2) for b in material_blocks)
    h_separated = h_block not in (0, 1, 2) and h_block not in live_blocks
    return separated and h_separated and not forbidden_premise


discharge_baseline = fresh_discharge([ZZ(3), ZZ(4), ZZ(5), ZZ(6)], ZZ(7),
                                     [ZZ(0), ZZ(1), ZZ(2)], False)
discharge_mutations = {
    'material_block_at_workspace': not fresh_discharge([ZZ(0), ZZ(4), ZZ(5), ZZ(6)], ZZ(7),
                                                       [ZZ(0), ZZ(1), ZZ(2)], False),
    'material_block_at_table': not fresh_discharge([ZZ(3), ZZ(4), ZZ(5), ZZ(1)], ZZ(7),
                                                   [ZZ(0), ZZ(1), ZZ(2)], False),
    'h_collides_with_live': not fresh_discharge([ZZ(3), ZZ(4), ZZ(5), ZZ(6)], ZZ(2),
                                                [ZZ(0), ZZ(1), ZZ(2)], False),
    'scratch_block0_premise_smuggled': not fresh_discharge([ZZ(3), ZZ(4), ZZ(5), ZZ(6)], ZZ(7),
                                                           [ZZ(0), ZZ(1), ZZ(2)], True),
}

# ------------------------------------------------------------------ report

families = [
    ('freshness_side_condition', side_baseline, side_mutations),
    ('call_site_bridge', bridge_baseline, bridge_mutations),
    ('foreign_block_call_frame', frame_baseline, frame_mutations),
    ('reference_transcription', transcription_baseline, transcription_mutations),
    ('freshness_discharge', discharge_baseline, discharge_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_STATEMENT_MACHINE_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted freshness-side-condition/call-site-bridge/'
                'foreign-block-frame records and an EntryFacts/CertEntryFrame freshness-discharge '
                'presence check, plus an allocation/gate-call transcription check against the '
                'reference C source; no real KeyGen/solver/certificate/codec result, no private '
                'key, no probability or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
