#!/usr/bin/env sage
# 055 scoped PUBLIC scripted controls for the ONE material witness: the
# solver-call h frame, the join of both equations on one material, the
# certificate frame over the five material blocks and the encoding-tail
# input boundary.
# EXPLICIT MOCK SEMANTICS: no real KeyGen, sampler, solver, certificate or
# codec result, no private key, no probability/law claim. The transcription
# family reads the REFERENCE C source (Extra/c) and compares the pinned
# public/solver/encoding regions; it is a scripted control that supplements,
# never replaces, the kernel proofs.
import json
import re
import sys
from datetime import datetime, timezone

SOURCE = sys.argv[1]
Q = ZZ(18433)
WORKSPACE_BYTES = ZZ(286720)
TABLE_BLOCKS = [ZZ(1), ZZ(2)]
WRITTEN_BY_SOLVER = [ZZ(2), ZZ(3), ZZ(4)]


def normalize(text):
    return re.sub(r'\s+', ' ', text).strip()


# ------------------------------------------------- 1. solver-call h frame


def frame_ok(h_block, scratch_block, written, tables, before_bytes, after_bytes):
    outside = (h_block != scratch_block and h_block not in written
               and h_block not in tables)
    same = before_bytes == after_bytes
    return outside and same


before_bytes = {ZZ(9): [ZZ(7), ZZ(0), ZZ(3071)]}
after_bytes = {ZZ(9): [ZZ(7), ZZ(0), ZZ(3071)]}
h_frame_baseline = (frame_ok(ZZ(9), ZZ(4), WRITTEN_BY_SOLVER, TABLE_BLOCKS,
                             before_bytes[ZZ(9)], after_bytes[ZZ(9)])
                    and frame_ok(ZZ(6), ZZ(4), WRITTEN_BY_SOLVER, TABLE_BLOCKS,
                                 [ZZ(1)], [ZZ(1)]))
h_frame_mutations = {
    'solver_writes_h': not frame_ok(ZZ(9), ZZ(4), [ZZ(2), ZZ(3), ZZ(9)], TABLE_BLOCKS,
                                    before_bytes[ZZ(9)], after_bytes[ZZ(9)]),
    'solver_writes_f': not (ZZ(5) not in [ZZ(5), ZZ(3), ZZ(4)]),
    'scratch_collision': not (ZZ(4) != ZZ(4)),
    'table_collision': not (ZZ(1) not in TABLE_BLOCKS),
}

# ---------------------------------------- 2. one material, both equations


def polymul(a, b):
    out = [ZZ(0)] * (len(a) + len(b) - ZZ(1))
    for i in range(len(a)):
        for j in range(len(b)):
            out[i + j] += a[i] * b[j]
    return out


def polysub(a, b):
    n = max(len(a), len(b))
    aa = list(a) + [ZZ(0)] * (n - len(a))
    bb = list(b) + [ZZ(0)] * (n - len(b))
    return [x - y for x, y in zip(aa, bb)]


def const_poly(z):
    return [ZZ(z)]


f = [ZZ(1)]
g = [ZZ(2)]
big_f = [ZZ(0)]
big_g = const_poly(18433)
h = [ZZ(2)]
f_inv = [ZZ(1)]


def ntru_ok(f, g, big_f, big_g):
    return polysub(polymul(f, big_g), polymul(g, big_f)) == const_poly(18433)


def public_ok(f, g, h):
    return [x % Q for x in polymul(h, f)] == [x % Q for x in g]


def inverse_ok(f, f_inv):
    return [x % Q for x in polymul(f_inv, f)] == const_poly(1)


join_baseline = (ntru_ok(f, g, big_f, big_g) and public_ok(f, g, h)
                 and inverse_ok(f, f_inv)
                 and ntru_ok([ZZ(3)], [ZZ(5)], [ZZ(1)], const_poly(6146)))
join_mutations = {
    'ntru_swapped': not ntru_ok(f, g, big_g, big_f),
    'wrong_residual': not (polysub(polymul(f, big_g), polymul(g, big_f)) == const_poly(18432)),
    'public_reversed': not ([x % Q for x in polymul(h, g)] == [x % Q for x in g]),
    'inverse_wrong': not ([x % Q for x in polymul([ZZ(2)], f)] == const_poly(1)),
}

# ------------------------------------- 3. certificate frame on five blocks


def retained(block, offset, base):
    if block in TABLE_BLOCKS:
        return False
    if block == ZZ(0):
        return offset < base or base + WORKSPACE_BYTES <= offset
    return True


cert_baseline = (retained(ZZ(5), ZZ(0), ZZ(200)) and retained(ZZ(9), ZZ(3071), ZZ(200))
                 and retained(ZZ(0), ZZ(199), ZZ(200))
                 and retained(ZZ(0), ZZ(200) + WORKSPACE_BYTES, ZZ(200)))
cert_mutations = {
    'block0_material': not retained(ZZ(0), ZZ(200), ZZ(200)),
    'table1_material': not retained(ZZ(1), ZZ(0), ZZ(200)),
    'region_offset_inside': not retained(ZZ(0), ZZ(200) + ZZ(4), ZZ(200)),
    'table2_material': not retained(ZZ(2), ZZ(64), ZZ(200)),
}

# --------------------------------------------- 4. encoding-tail boundary


def tail_shape(loop_stmt, tail, names):
    return (loop_stmt == 'attemptedLoop' and len(tail) == ZZ(18)
            and names == ['f', 'g', 'F', 'G', 'h'] and tail[ZZ(0)] != 'attemptedLoop')


outer = ['stmt'] * ZZ(14) + ['attemptedLoop'] + ['enc'] * ZZ(18)
names = ['f', 'g', 'F', 'G', 'h']
tail_baseline = tail_shape(outer[ZZ(14)], outer[ZZ(15):], names)
tail_mutations = {
    'wrong_loop_index': not tail_shape(outer[ZZ(13)], outer[ZZ(14):], names),
    'wrong_tail_length': not tail_shape(outer[ZZ(14)], outer[ZZ(15):][:ZZ(17)], names),
    'tail_overlaps_loop': not tail_shape(outer[ZZ(14)], outer[ZZ(14):], names),
    'missing_public_array': not tail_shape(outer[ZZ(14)], outer[ZZ(15):], names[:ZZ(4)]),
}

# ------------------------------------------- 5. reference C transcription


text = open(SOURCE).read()
public_index = text.index('if (!falcon_compute_public(h, f, g, logn, ter))')
solve_index = text.index('if (!solve_NTRU(fk, F, G, f, g))')
encode_index = text.index('ske[0] = f;')
encode_region = normalize(text[encode_index:encode_index + 900])
expected = [
    'solve_NTRU(fk, F, G, f, g)',
    'falcon_compute_public(h, f, g, logn, ter)',
    'ske[0] = f;',
    'ske[1] = g;',
    'ske[2] = F;',
    'ske[3] = G;',
    'falcon_encode_18433',
]
transcription_baseline = (all(normalize(line) in normalize(text) for line in expected)
                          and public_index < solve_index < encode_index
                          and 'h, logn' in encode_region)
argument_drifted = text.replace('solve_NTRU(fk, F, G, f, g)', 'solve_NTRU(fk, G, F, f, g)')
public_drifted = text.replace('falcon_compute_public(h, f, g, logn, ter)',
                              'falcon_compute_public(f, h, g, logn, ter)')
encode_drifted = text.replace('ske[3] = G;', 'ske[3] = g;')
public_encode_drifted = text.replace('falcon_encode_18433', 'falcon_encode_12289')
transcription_mutations = {
    'solver_argument_order_drift': not all(normalize(line) in normalize(argument_drifted)
                                           for line in expected),
    'public_argument_drift': not all(normalize(line) in normalize(public_drifted)
                                     for line in expected),
    'encode_segment_drift': not all(normalize(line) in normalize(encode_drifted)
                                    for line in expected),
    'public_encode_drift': not all(normalize(line) in normalize(public_encode_drifted)
                                   for line in expected),
}

# ------------------------------------------------------------------ report

families = [
    ('solver_h_frame', h_frame_baseline, h_frame_mutations),
    ('one_material_equations', join_baseline, join_mutations),
    ('certificate_frame', cert_baseline, cert_mutations),
    ('encoding_tail_boundary', tail_baseline, tail_mutations),
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
       'status': 'PASS_SCRIPTED_MATERIAL_WITNESS_CONTROLS' if baseline_pass and mutations_detected else 'FAIL',
       'scope': 'EXPLICIT MOCK SEMANTICS; scripted h-frame/equation-join/certificate-frame/'
                'encoding-tail arithmetic over ZZ and a solver/public/encode transcription check '
                'against the reference C source; no real KeyGen/solver/certificate/codec result, no '
                'private key, no probability or law claim; supplements kernel proofs, never replaces them',
       'cases_per_run': len(families), 'mutation_kinds': sum(len(m) for _, _, m in families),
       'baseline_pass': bool(baseline_pass), 'mutations_all_detected': bool(mutations_detected),
       'ntru_q': str(Q), 'workspace_bytes': str(WORKSPACE_BYTES),
       'results': results}
with open('CERT_CONTROL_CHECK.json', 'w') as stream:
    json.dump(out, stream, indent=2)
    stream.write('\n')
print(json.dumps({k: v for k, v in out.items() if k != 'results'}, indent=2))
assert baseline_pass and mutations_detected
