#!/usr/bin/env sage
# 053 scoped PUBLIC scripted controls for the workspace-shape extraction from
# the allocation execution (temp_size store + fk->tmp malloc binding), the
# legality frame extraction and the relocation composition.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The binding
# transcription check reads the REFERENCE C source (Extra/c) and compares the
# pinned allocation statements with the reference region; it is a scripted
# control that supplements, never replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
WORKSPACE_BYTES = ZZ(286720)
SCRATCH_WORDS = ZZ(71680)
SCRATCH_EB = ZZ(4)


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ------------------------------------------------- 1. scratch descriptor


def scratch_of(block, words=SCRATCH_WORDS, eb=SCRATCH_EB, base=ZZ(0), index=ZZ(0)):
    return (ZZ(block), base, words, eb, index)


def offset(p):
    block, base, count, eb, index = p
    return base + eb * index


def extent(p):
    block, base, count, eb, index = p
    return base + eb * count - offset(p)


def descriptor_ok(p):
    block, base, count, eb, index = p
    return (extent(p) == WORKSPACE_BYTES and eb == SCRATCH_EB and index == ZZ(0)
            and count * SCRATCH_EB == WORKSPACE_BYTES and offset(p) % ZZ(8) == ZZ(0))


descriptor_baseline = descriptor_ok(scratch_of(1))
descriptor_mutations = {
    'shrunk_word_count': not descriptor_ok(scratch_of(1, words=SCRATCH_WORDS - ZZ(1))),
    'fpr_word_view': not descriptor_ok(scratch_of(1, words=ZZ(35840), eb=ZZ(8))),
    'misaligned_offset': not descriptor_ok(scratch_of(1, base=ZZ(4))),
    'shifted_index': not descriptor_ok(scratch_of(1, index=ZZ(1))),
}

# ------------------------------------------- 2. temp_size binding + source


def align_fp(t):
    return ((t + ZZ(7)) / ZZ(8)) * ZZ(8)


def reservation(n):
    return (ZZ(22) * n + ZZ(4) * (n / ZZ(3))) * ZZ(8)


def binding_extent(tmp_len, width=SCRATCH_EB):
    return width * (tmp_len / width)


text = open(SOURCE).read()
start = text.index('falcon_keygen_new(unsigned logn, int ternary)')
region = normalize(text[start:start + 4000])
expected_binding = [
    'fk->tmp_len = temp_size(logn, ternary);',
    '#else',
    'fk->tmp = malloc(fk->tmp_len);',
]
transcription_match = all(normalize(line) in region for line in expected_binding)
order_ok = (region.index(normalize(expected_binding[0]))
            < region.index(normalize(expected_binding[1]))
            < region.index(normalize(expected_binding[2])))
drifted = region.replace('malloc(fk->tmp_len)', 'malloc(fk->tmp_len + 1)')
transcription_drifted = not all(normalize(line) in drifted for line in expected_binding)

tmp_len_value = reservation(ZZ(1536))
binding_baseline = (transcription_match and order_ok
                    and tmp_len_value == WORKSPACE_BYTES
                    and binding_extent(tmp_len_value) == WORKSPACE_BYTES
                    and scratch_of(1) == scratch_of(1, words=binding_extent(tmp_len_value) / SCRATCH_EB))
tampered_value = (ZZ(23) * ZZ(1536) + ZZ(4) * (ZZ(1536) / ZZ(3))) * ZZ(8)
binding_mutations = {
    'transcription_drift': transcription_drifted,
    'tampered_reservation_coefficient': binding_extent(tampered_value) != WORKSPACE_BYTES,
    'unaligned_tmp_len': binding_extent(WORKSPACE_BYTES - ZZ(2)) != WORKSPACE_BYTES,
    'malloc_count_drift': binding_extent(tmp_len_value + ZZ(4)) != WORKSPACE_BYTES,
}

# ---------------------------------------------------- 3. legality frame


def legal_fields(p, heap_size, writable=True):
    block, base, count, eb, index = p
    return (eb == ZZ(4) and base % ZZ(4) == ZZ(0) and index + ZZ(7168) <= count
            and base + ZZ(4) * count <= heap_size and heap_size < ZZ(2) ** ZZ(64)
            and writable)


legality_baseline = legal_fields(scratch_of(1), WORKSPACE_BYTES)
legality_mutations = {
    'undersized_block': not legal_fields(scratch_of(1), WORKSPACE_BYTES - ZZ(4)),
    'readonly_block': not legal_fields(scratch_of(1), WORKSPACE_BYTES, writable=False),
    'words_beyond_count': not legal_fields(scratch_of(1, words=ZZ(7000)), WORKSPACE_BYTES),
}

# ------------------------------------------------ 4. relocation composition


def swap_block(b, i):
    return b if i == ZZ(0) else (ZZ(0) if i == b else i)


def swap_ptr(b, p):
    block, base, count, eb, index = p
    return (swap_block(b, block), base, count, eb, index)


def relocated_ok(b, p):
    moved = swap_ptr(b, p)
    return (moved[0] == ZZ(0) and extent(moved) == extent(p)
            and offset(moved) % ZZ(8) == ZZ(0)
            and swap_ptr(b, moved) == p)


def swap_block_bad_label(b, i):
    return b if i == ZZ(0) else (ZZ(0) if i == b - ZZ(1) else i)


def swap_block_noninv(b, i):
    return b if i == ZZ(0) else (b + ZZ(1) if i == b else i)


def ptr_map(f, b, p):
    block, base, count, eb, index = p
    return (f(b, block), base, count, eb, index)


relocation_baseline = relocated_ok(ZZ(3), scratch_of(3))
relocation_mutations = {
    'wrong_block_label': not (ptr_map(swap_block_bad_label, ZZ(3), scratch_of(3))[0] == ZZ(0)),
    'non_involutive_swap': not (ptr_map(swap_block_noninv, ZZ(3),
                                ptr_map(swap_block_noninv, ZZ(3), scratch_of(3))) == scratch_of(3)),
    'block0_assumed_not_derived': not (scratch_of(3)[0] == ZZ(0)),
}

# ------------------------------------------------------------------ report

families = [
    ('scratch_descriptor', descriptor_baseline, descriptor_mutations),
    ('temp_size_binding', binding_baseline, binding_mutations),
    ('legality_frame', legality_baseline, legality_mutations),
    ('relocation_composition', relocation_baseline, relocation_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_ALLOCATION_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted allocation-binding transcription check '
                'against the reference C source and ZZ descriptor/extent arithmetic; no real '
                'KeyGen/solver/certificate/codec result, no private key, no probability or law '
                'claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'tmp_len_value': str(tmp_len_value), 'workspace_bytes': str(WORKSPACE_BYTES),
       'scratch_words': str(SCRATCH_WORDS), 'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
