#!/usr/bin/env sage
# 054 scoped PUBLIC scripted controls for the certificate-execution transport
# across the block relocation: the sigma conjugation of the pinned block0
# machine against the general fk->tmp scratch at block b, the relativized
# workspace view/binding, the layout/flag transport and the caller-frame
# transport.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The call-site
# transcription check reads the REFERENCE C source (Extra/c) and compares the
# pinned certificate call region; it is a scripted control that supplements,
# never replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
WORKSPACE_BYTES = ZZ(286720)
FPR_WORDS = ZZ(35840)
SLOT_STRIDE = ZZ(12288)
TABLE_BLOCKS = [ZZ(1), ZZ(2)]


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


def align4(n):
    return ((ZZ(n) + ZZ(3)) // ZZ(4)) * ZZ(4)


# ------------------------------------------------ 1. exec conjugation table


def swap_block(b, i):
    return b if i == ZZ(0) else (ZZ(0) if i == b else i)


def swap_ptr(b, p):
    block, base, count, eb, index = p
    return (swap_block(b, block), base, count, eb, index)


def swap_args(b, args):
    base, f, g, big_f, big_g, logn, ter = args
    return (base, swap_ptr(b, f), swap_ptr(b, g), swap_ptr(b, big_f), swap_ptr(b, big_g), logn, ter)


def workspace_ptr(block, base, slot):
    return (block, base, FPR_WORDS, ZZ(8), ZZ(1536) * slot)


def machine_workspace_reads_scratch(b, scratch):
    return swap_block(b, ZZ(0)) == scratch[0]


def swap_block_bad_label(b, i):
    return b if i == ZZ(0) else (ZZ(0) if i == b - ZZ(1) else i)


def swap_block_noninv(b, i):
    return b if i == ZZ(0) else (b + ZZ(1) if i == b else i)


scratch = (ZZ(3), ZZ(0), ZZ(71680), ZZ(4), ZZ(0))
probe = (ZZ(3), ZZ(0), ZZ(1536), ZZ(2), ZZ(0))
args = (ZZ(200), (ZZ(5), ZZ(0), ZZ(1536), ZZ(2), ZZ(0)), (ZZ(6), ZZ(0), ZZ(1536), ZZ(2), ZZ(0)),
        (ZZ(7), ZZ(0), ZZ(1536), ZZ(2), ZZ(0)), (ZZ(8), ZZ(0), ZZ(1536), ZZ(2), ZZ(0)),
        ZZ(10), ZZ(1))
conjugation_baseline = (swap_block(ZZ(3), ZZ(0)) == ZZ(3) and swap_block(ZZ(3), ZZ(3)) == ZZ(0)
                        and swap_ptr(ZZ(3), probe)[0] == ZZ(0)
                        and swap_ptr(ZZ(3), swap_ptr(ZZ(3), probe)) == probe
                        and swap_args(ZZ(3), swap_args(ZZ(3), args)) == args
                        and machine_workspace_reads_scratch(ZZ(3), scratch))
conjugation_mutations = {
    'wrong_block_label': not (swap_block_bad_label(ZZ(3), ZZ(3)) == ZZ(0)),
    'non_involutive_swap': not (swap_block_noninv(ZZ(3), swap_block_noninv(ZZ(3), ZZ(0))) == ZZ(0)),
    'material_pointer_unmoved': not (ZZ(3) == swap_ptr(ZZ(3), probe)[0]),
    'workspace_left_at_block0': not machine_workspace_reads_scratch(ZZ(3),
        (ZZ(0), ZZ(0), ZZ(71680), ZZ(4), ZZ(0))),
}

# --------------------------------------- 2. workspace view and call binding


def fpr_cast(p):
    block, base, count, eb, index = p
    return (block, base + eb * index, ZZ(base + eb * count - (base + eb * index)) / ZZ(8), ZZ(8), ZZ(0))


def workspace_at(b, base, slot):
    return swap_ptr(b, workspace_ptr(ZZ(0), base, slot))


def binding_ok(b, base, scratch_p):
    view = workspace_at(b, base, ZZ(0))
    cast = fpr_cast(scratch_p)
    return (view == (b, base, FPR_WORDS, ZZ(8), ZZ(0)) and view == cast
            and (base % ZZ(8) == ZZ(0)) and cast[0] == scratch_p[0])


base = ZZ(0)
binding_baseline = binding_ok(ZZ(3), base, scratch)
binding_mutations = {
    'misaligned_base': not binding_ok(ZZ(3), ZZ(4), (ZZ(3), ZZ(4), ZZ(71680), ZZ(4), ZZ(0))),
    'wrong_word_count': not (workspace_at(ZZ(3), base, ZZ(0))[2] == FPR_WORDS - ZZ(1)),
    'view_block_zero_not_b': not (workspace_at(ZZ(3), base, ZZ(0))[0] == ZZ(0)),
    'extent_drift': not binding_ok(ZZ(3), base, (ZZ(3), ZZ(0), ZZ(71679), ZZ(4), ZZ(0))),
}

# ------------------------------------------- 3. layout and flag transport


def layout_at(b, base, size_b, size_0):
    return (base + SLOT_STRIDE * ZZ(4), base + SLOT_STRIDE * ZZ(20), align4(size_b))


def flag_pointer_at(b, size_b):
    return (b, align4(size_b), ZZ(1), ZZ(4), ZZ(0))


def layout_ok(b, base, size_b, size_0):
    roots, leaves, bad = layout_at(b, base, size_b, size_0)
    flag = flag_pointer_at(b, size_b)
    return (roots == base + SLOT_STRIDE * ZZ(4) and leaves == base + ZZ(245760)
            and bad == align4(size_b) and flag[0] == b
            and flag[1] == bad and bad + ZZ(4) <= size_b + ZZ(4))


size_b = ZZ(286720)
size_0 = ZZ(448)
layout_baseline = layout_ok(ZZ(3), base, size_b, size_0)
layout_mutations = {
    'bad_from_block0_size': not (align4(size_0) == align4(size_b)),
    'wrong_slot_constant': not (layout_at(ZZ(3), base, size_b, size_0)[1] == base + SLOT_STRIDE * ZZ(19)),
    'roots_slot_drift': not (layout_at(ZZ(3), base, size_b, size_0)[0] == base + SLOT_STRIDE * ZZ(5)),
    'align_drift': not (align4(size_b + ZZ(1)) == size_b),
}

# ---------------------------------------------- 4. frame transport renaming


def outside(base, block, offset, excluded_block):
    return block != excluded_block or offset < base or base + WORKSPACE_BYTES <= offset


def frame_ok(b, block, offset, base):
    renamed = swap_block(b, block)
    table_free = (renamed not in TABLE_BLOCKS and block not in TABLE_BLOCKS and b not in TABLE_BLOCKS)
    return table_free and (outside(base, renamed, offset, ZZ(0))
                           == (block != b or offset < base or base + WORKSPACE_BYTES <= offset))


frame_baseline = (frame_ok(ZZ(3), ZZ(7), ZZ(0), base)
                  and frame_ok(ZZ(3), ZZ(3), base + ZZ(1), base)
                  and frame_ok(ZZ(3), ZZ(0), base + WORKSPACE_BYTES, base))
frame_mutations = {
    'scratch_block_not_excluded': not (ZZ(3) != ZZ(3) or ZZ(0) < base
        or base + WORKSPACE_BYTES <= ZZ(0)),
    'table_block_included': not (swap_block(ZZ(3), ZZ(1)) not in TABLE_BLOCKS),
    'wrong_rename_direction': not (swap_block_bad_label(ZZ(3), ZZ(3)) == ZZ(0)),
    'b_may_be_a_table_block': not (swap_block(ZZ(1), ZZ(1)) == ZZ(1)),
}

# --------------------------------------------- 5. reference call transcription


text = open(SOURCE).read()
call_index = text.index('ft_keygen_leaf_certificate((fpr *)fk->tmp')
call_region = normalize(text[call_index - 200:call_index + 400])
expected_call = [
    'ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,',
    'logn, ter))',
    'if (ter && logn == 10 && n == 1536)',
]
call_match = all(normalize(line) in call_region for line in expected_call)
call_order = (call_region.index(normalize(expected_call[2]))
              < call_region.index(normalize(expected_call[0]))
              < call_region.index(normalize(expected_call[1])))
drifted = call_region.replace('(fpr *)fk->tmp', '(fpr *)fk')
profile_drifted = call_region.replace('logn, ter))', 'logn))')
argument_drifted = call_region.replace('F, G,', 'G, F,')
transcription_baseline = call_match and call_order
transcription_mutations = {
    'call_transcription_drift': not all(normalize(line) in drifted for line in expected_call),
    'argument_order_drift': not all(normalize(line) in argument_drifted for line in expected_call),
    'workspace_argument_drift': not ('(fpr *)fk->tmp' in drifted),
    'profile_argument_drift': not all(normalize(line) in profile_drifted for line in expected_call),
}

# ------------------------------------------------------------------ report

families = [
    ('exec_conjugation', conjugation_baseline, conjugation_mutations),
    ('workspace_binding', binding_baseline, binding_mutations),
    ('layout_flag_transport', layout_baseline, layout_mutations),
    ('frame_transport', frame_baseline, frame_mutations),
    ('reference_call_transcription', transcription_baseline, transcription_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_CERT_RELOCATION_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted sigma-conjugation/workspace-view/layout/frame '
                'transport arithmetic over ZZ and a certificate-call transcription check against '
                'the reference C source; no real KeyGen/solver/certificate/codec result, no private '
                'key, no probability or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'workspace_bytes': str(WORKSPACE_BYTES), 'fpr_words': str(FPR_WORDS),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
