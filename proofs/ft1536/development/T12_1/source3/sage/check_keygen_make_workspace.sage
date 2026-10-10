#!/usr/bin/env sage
# 052 scoped PUBLIC scripted controls for the workspace relocation, the
# workspace bridge and the workspace-extent reservation.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The temp_size
# transcription check reads the REFERENCE C source (Extra/c) and compares its
# candidate assignments with the mirror used by the kernel proofs; it is a
# scripted control that supplements, never replaces, those proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
WORKSPACE_BYTES = ZZ(286720)
WORKSPACE_WORDS = ZZ(35840)


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ---------------------------------------------------------------- 1. bridge


def fpr_cast(p):
    block, base, count, eb, index = p
    offset = base + eb * index
    return (block, offset, (base + eb * count - offset) // 8, 8, ZZ(0))


def workspace_pointer(base):
    return (ZZ(0), base, WORKSPACE_WORDS, 8, ZZ(0))


def bridge_holds(p, base):
    return fpr_cast(p) == workspace_pointer(base)


def bridge_components(p, base):
    block, b0, count, eb, index = p
    offset = b0 + eb * index
    extent = b0 + eb * count - offset
    return block == 0 and base == offset and extent // 8 == WORKSPACE_WORDS


def bridge_components_relaxed(p, base):
    block, b0, count, eb, index = p
    offset = b0 + eb * index
    extent = b0 + eb * count - offset
    return base == offset and extent // 8 >= WORKSPACE_WORDS


def bridge_components_wrong_block(p, base):
    block, b0, count, eb, index = p
    offset = b0 + eb * index
    extent = b0 + eb * count - offset
    return base == offset and extent // 8 == WORKSPACE_WORDS


def descriptor_cases():
    cases = []
    for base in [ZZ(128), ZZ(0), ZZ(1024)]:
        for count in [ZZ(71680), ZZ(4096), ZZ(35840)]:
            for eb in [ZZ(4), ZZ(8)]:
                for index in [ZZ(0), ZZ(3)]:
                    for block in [ZZ(0), ZZ(3), ZZ(7)]:
                        cases.append((block, base, count, eb, index))
    return cases


bridge_cases = [(p, p[1] + p[4] * p[3]) for p in descriptor_cases()]
bridge_baseline = all(bridge_holds(p, base) == bridge_components(p, base)
                      for p, base in bridge_cases)
bridge_mutations = {}
for name, checker in [('block_perturbation', bridge_components_wrong_block),
                      ('extent_relaxed', bridge_components_relaxed)]:
    bad = [(p, base) for p, base in bridge_cases
           if bridge_holds(p, base) != checker(p, base)]
    bridge_mutations[name] = bool(bad)

# ------------------------------------------------------------- 2. relocation


def swap_block(b, i):
    return b if i == 0 else (ZZ(0) if i == b else i)


def swap_block_mutated(b, i):
    return i


def swap_heap(b, heap, swapfn=swap_block):
    out = {}
    for blk, cells in heap.items():
        out.setdefault(swapfn(b, blk), {}).update(cells)
    return out


def mock_heap():
    return {ZZ(0): {ZZ(0): ZZ(1), ZZ(1): ZZ(2)}, ZZ(3): {ZZ(0): ZZ(9), ZZ(8): ZZ(11)},
            ZZ(1): {ZZ(0): ZZ(5)}, ZZ(2): {ZZ(0): ZZ(6)}}


def swap_checks(b, heap, swapfn=swap_block):
    moved = swap_heap(b, heap, swapfn)
    if swapfn(b, swapfn(b, ZZ(3))) != ZZ(3):
        return False
    if swapfn(b, b) != ZZ(0):
        return False
    back = swap_heap(b, moved, swapfn)
    if back != heap:
        return False
    for blk, cells in heap.items():
        for off, val in cells.items():
            if moved.get(swapfn(b, blk), {}).get(off) != val:
                return False
    return True


relocation_baseline = all(swap_checks(b, mock_heap()) for b in [ZZ(0), ZZ(3), ZZ(7)])
relocation_mutations = {
    'swap_not_involution': not all(
        swap_checks(b, mock_heap(), lambda bb, i: swap_block_mutated(bb, i))
        for b in [ZZ(0), ZZ(3), ZZ(7)]),
    'scratch_not_relocated': not all(
        swap_block(b, b) == ZZ(0) for b in [ZZ(0), ZZ(3), ZZ(7)]) or
        swap_block_mutated(ZZ(3), ZZ(3)) != ZZ(0),
}

# ------------------------------------------------------ 3. temp_size witness

text = open(SOURCE).read()
start = text.index('temp_size(unsigned logn, int ternary)')
body = text[start:text.index('return gmax;', start) + len('return gmax;')]
statements = [normalize(m.group(1)) for m in
              re.finditer(r'((?:cur|max|gmax|tmp1|tmp2)\s*=[^;]*;)', body)]

expected_statements = [
    'gmax = 0;',
    'cur = (22 * n + 4 * (n / 3)) * sizeof(fpr);',
    'gmax = cur > gmax ? cur : gmax;',
    'cur = (2 * tn + 2 * n + 2 * dn) * sizeof(uint32_t);',
    'gmax = cur > gmax ? cur : gmax;',
    'cur = (n * tlen + 2 * n * slen + 3 * n) * sizeof(uint32_t);',
    'gmax = cur > gmax ? cur : gmax;',
    'cur = (n * tlen + 2 * n * slen + slen) * sizeof(uint32_t);',
    'gmax = cur > gmax ? cur : gmax;',
    'max = 0;',
    'cur = 8 * slen * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(2 * tn * sizeof(uint32_t)) + (2 * n + hn) * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = (hn + 4 * n) * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(2 * n * sizeof(uint32_t)) + 2 * n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = 7 * n * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(4 * n * sizeof(uint32_t)) + n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(3 * n * sizeof(uint32_t)) + (n + hn) * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = (2 * hn * dlen + 2 * n * llen) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = (2 * n * llen + 2 * n * slen + 7 * n) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = (2 * n * llen + 2 * n * slen + llen) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP((2 * n * llen + 2 * n * slen) * sizeof(uint32_t)) + 2 * n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(2 * n * slen * sizeof(uint32_t)) + 4 * n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = (5 * n + hn) * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_FP(2 * n * sizeof(uint32_t)) + 2 * n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = (2 * n * llen + 2 * n * slen + 4 * n) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'cur = (2 * n * llen + 2 * n * slen + llen) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'tmp1 = ALIGN_UW( ALIGN_FP((2 * n * llen + 2 * n * slen) * sizeof(uint32_t))'
    ' + (2 * n + hn) * sizeof(fpr)) + n * sizeof(uint32_t);',
    'tmp2 = ALIGN_FP((2 * n * llen + 2 * n * slen) * sizeof(uint32_t))'
    ' + (3 * n + hn) * sizeof(fpr);',
    'cur = tmp1 > tmp2 ? tmp1 : tmp2;',
    'cur = ALIGN_FP(cur) + n * sizeof(fpr);',
    'max = cur > max ? cur : max;',
    'cur = ALIGN_UW( ALIGN_FP((2 * n * llen + 2 * n * slen) * sizeof(uint32_t))'
    ' + (2 * n + hn) * sizeof(fpr)) + (5 * n + n * slen) * sizeof(uint32_t);',
    'max = cur > max ? cur : max;',
    'gmax = max > gmax ? max : gmax;',
]
expected_normalized = [normalize(s) for s in expected_statements]
transcription_match = statements == expected_normalized


def table(name):
    match = re.search(name + r'\[\] = \{([^}]*)\}', text)
    return [ZZ(x) for x in re.findall(r'\d+', match.group(1))]


def align_fp(t):
    return ((t + ZZ(7)) // ZZ(8)) * ZZ(8)


def align_uw(t):
    return ((t + ZZ(3)) // ZZ(4)) * ZZ(4)


def temp_size(logn, ternary, small_coef=ZZ(22), workspace_extra=None):
    small3 = table('MAX_BL_SMALL3')
    small2 = table('MAX_BL_SMALL2')
    large3 = table('MAX_BL_LARGE3')
    large2 = table('MAX_BL_LARGE2')
    gmax = ZZ(0)
    if ternary and logn == ZZ(10):
        n = ZZ(1536)
        cur = (small_coef * n + ZZ(4) * (n // ZZ(3))) * ZZ(8)
        gmax = max(cur, gmax)
    for depth in range(logn):
        if depth == 0 and ternary:
            n = ZZ(3) << (logn - ZZ(1))
            dn = ZZ(1) << logn
            tn = ZZ(1) << (logn - ZZ(1))
            cur = (ZZ(2) * tn + ZZ(2) * n + ZZ(2) * dn) * ZZ(4)
            gmax = max(cur, gmax)
        else:
            n = ZZ(1) << (logn - depth)
            slen = (small3 if ternary else small2)[depth]
            tlen = (small3 if ternary else small2)[depth + 1]
            cur = (n * tlen + ZZ(2) * n * slen + ZZ(3) * n) * ZZ(4)
            gmax = max(cur, gmax)
            cur = (n * tlen + ZZ(2) * n * slen + slen) * ZZ(4)
            gmax = max(cur, gmax)
    for depth in range(logn + 1):
        best = ZZ(0)
        if depth == logn:
            slen = (small3 if ternary else small2)[depth]
            cur = ZZ(8) * slen * ZZ(4)
            best = max(cur, best)
        elif ternary and depth == 0 and logn > ZZ(2):
            n = ZZ(3) << (logn - ZZ(1))
            tn = ZZ(1) << (logn - ZZ(1))
            hn = n >> ZZ(1)
            cur = align_fp(ZZ(2) * tn * ZZ(4)) + (ZZ(2) * n + hn) * ZZ(8)
            best = max(cur, best)
            cur = (hn + ZZ(4) * n) * ZZ(8)
            best = max(cur, best)
            cur = align_fp(ZZ(2) * n * ZZ(4)) + ZZ(2) * n * ZZ(8)
            best = max(cur, best)
        elif (not ternary) and depth == 1 and logn > ZZ(2):
            n = ZZ(1) << (logn - ZZ(1))
            hn = n >> ZZ(1)
            slen = small2[depth]
            dlen = small2[depth + 1]
            llen = large2[depth]
            for cur in [(ZZ(2) * hn * dlen + ZZ(2) * n * llen) * ZZ(4),
                        (ZZ(2) * n * llen + ZZ(2) * n * slen + ZZ(7) * n) * ZZ(4),
                        (ZZ(2) * n * llen + ZZ(2) * n * slen + llen) * ZZ(4),
                        align_fp((ZZ(2) * n * llen + ZZ(2) * n * slen) * ZZ(4))
                        + ZZ(2) * n * ZZ(8),
                        align_fp(ZZ(2) * n * slen * ZZ(4)) + ZZ(4) * n * ZZ(8),
                        (ZZ(5) * n + hn) * ZZ(8),
                        align_fp(ZZ(2) * n * ZZ(4)) + ZZ(2) * n * ZZ(8)]:
                best = max(cur, best)
        else:
            if ternary and depth == 0 and logn == ZZ(2):
                n = ZZ(6)
                hn = ZZ(2)
            else:
                n = ZZ(1) << (logn - depth)
                hn = n >> ZZ(1)
            slen = (small3 if ternary else small2)[depth]
            llen = (large3 if ternary else large2)[depth]
            cur = (ZZ(2) * n * llen + ZZ(2) * n * slen + ZZ(4) * n) * ZZ(4)
            best = max(cur, best)
            cur = (ZZ(2) * n * llen + ZZ(2) * n * slen + llen) * ZZ(4)
            best = max(cur, best)
            tmp1 = align_uw(align_fp((ZZ(2) * n * llen + ZZ(2) * n * slen) * ZZ(4))
                            + (ZZ(2) * n + hn) * ZZ(8)) + n * ZZ(4)
            tmp2 = align_fp((ZZ(2) * n * llen + ZZ(2) * n * slen) * ZZ(4)) \
                + (ZZ(3) * n + hn) * ZZ(8)
            cur = align_fp(max(tmp1, tmp2)) + n * ZZ(8)
            best = max(cur, best)
            cur = align_uw(align_fp((ZZ(2) * n * llen + ZZ(2) * n * slen) * ZZ(4))
                           + (ZZ(2) * n + hn) * ZZ(8)) + (ZZ(5) * n + n * slen) * ZZ(4)
            best = max(cur, best)
        gmax = max(best, gmax)
    return gmax


transcription_drifted = list(statements)
transcription_drifted[1] = transcription_drifted[1].replace('(22 * n', '(23 * n')

baseline_value = temp_size(ZZ(10), ZZ(1))
workspace_expression = (ZZ(22) * ZZ(1536) + ZZ(4) * (ZZ(1536) // ZZ(3))) * ZZ(8)
extent_baseline = (baseline_value == WORKSPACE_BYTES == workspace_expression
                   and baseline_value == temp_size(ZZ(10), ZZ(1), ZZ(22)))
extent_mutations = {
    'tampered_reservation_coefficient': temp_size(ZZ(10), ZZ(1), ZZ(23)) == WORKSPACE_BYTES,
    'shrunk_reservation_coefficient': temp_size(ZZ(10), ZZ(1), ZZ(21)) == WORKSPACE_BYTES,
}
extent_mutations = {k: not v for k, v in extent_mutations.items()}

# ------------------------------------------------------- 4. table-block mock


def mock_tables(name):
    return {'square': (ZZ(1), ZZ(0), ZZ(2048)), 'cubic': (ZZ(2), ZZ(0), ZZ(4096))}.get(name)


def tables_outside(block, offset, tables=mock_tables):
    for key in ['square', 'cubic']:
        entry = tables(key)
        if entry is not None:
            tblock, tbase, tcount = entry
            if not (block != tblock or offset < tbase or tbase + tcount <= offset):
                return False
    return True


def tables_moved(name):
    if name == 'square':
        return (ZZ(0), ZZ(0), ZZ(2048))
    return mock_tables(name)


tables_baseline = all(tables_outside(b, o) for b in [ZZ(0), ZZ(3), ZZ(5)] for o in [ZZ(0), ZZ(99)])
tables_mutations = {
    'table_in_workspace_block': not all(tables_outside(b, o, tables_moved)
                                        for b in [ZZ(0), ZZ(3), ZZ(5)] for o in [ZZ(0), ZZ(99)]),
}

# ------------------------------------------------------------------ report

families = [
    ('bridge_components', bridge_baseline, bridge_mutations),
    ('relocation_swap', relocation_baseline, relocation_mutations),
    ('temp_size_extent', extent_baseline and transcription_match, {
        'transcription_drift': transcription_drifted != expected_normalized, **extent_mutations}),
    ('table_block_inversion', tables_baseline, tables_mutations),
]
results = []
for name, ok, mutations in families:
    results.append({'case': name, 'variant': 'baseline', 'pass': bool(ok)})
    for mname, detected in mutations.items():
        results.append({'case': name, 'variant': mname, 'detected': bool(detected)})

baseline_pass = all(r['pass'] for r in results if r['variant'] == 'baseline')
mutations_detected = all(r['detected'] for r in results if r['variant'] != 'baseline')
out = {'utc': datetime.now(timezone.utc).isoformat(),
       'status': 'PASS_SCRIPTED_WORKSPACE_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; synthetic public bytes and a scripted temp_size '
                'transcription check against the reference C source; no real KeyGen/solver/'
                'certificate/codec result, no private key, no probability or law claim; '
                'supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'baseline_value': str(baseline_value), 'workspace_bytes': str(WORKSPACE_BYTES),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
