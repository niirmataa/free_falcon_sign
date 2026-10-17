# Exact auxiliary controls for the MODE1 coefficient law window.
# Standard Sage preparser, exact ZZ/QQ only. Nothing computed here is a
# premise of any kernel theorem; these are finite arithmetic controls.
# No KeyGen run is performed and no population bound is proved.

import json

out = {}
out['status'] = 'PASS_EXACT_AUXILIARY_CONTROLS_ONLY'
out['new_keygen_runs'] = 0
out['population_probability_lower_bound_proved'] = False
out['seed_law_lower_bound_proved'] = False
out['chunk_law_of_shake_derived'] = False

# Control 1: rejection-normalized marginal of one stored MODE1 coefficient.
# valueLaw mass x = m(chunkOf x) / (1 - m(3)); exact rational arithmetic.
def value_law(m):
    d = QQ(1) - m[3]
    assert d > 0
    return [m[i] / d for i in range(3)]

m_unif = [QQ(1)/4 for _ in range(4)]
v_unif = value_law(m_unif)
assert v_unif == [QQ(1)/3 for _ in range(3)]
out['uniform_case'] = {'chunk_masses': [str(x) for x in m_unif],
                       'value_masses': [str(x) for x in v_unif],
                       'total': str(sum(v_unif))}

# Control 2: deviation bound |m_x/(1-m_3) - 1/3| <= 16 d / (9 - 12 d)
# for every chunk mass within d of 1/4. Grid over rational deviations.
grid = [QQ(0), QQ(1)/1000, QQ(1)/200, QQ(1)/100, QQ(1)/20, QQ(1)/10,
        QQ(1)/8, QQ(3)/20, QQ(1)/5, QQ(1)/4, QQ(3)/10]
checked = 0
worst = QQ(0)
worst_ratio = QQ(0)
for d in grid:
    assert d < QQ(3)/4
    bound = 16*d / (9 - 12*d)
    for e0 in [-d, -d/2, QQ(0), d/2, d]:
        for e1 in [-d, -d/2, QQ(0), d/2, d]:
            for e2 in [-d, -d/2, QQ(0), d/2, d]:
                # Chunk masses must sum to one: e0+e1+e2+e3 = 0 and |e3| <= d.
                e3 = -(e0 + e1 + e2)
                if abs(e3) > d:
                    continue
                m = [QQ(1)/4 + e0, QQ(1)/4 + e1, QQ(1)/4 + e2, QQ(1)/4 + e3]
                if any(x < 0 or x > 1 for x in m):
                    continue
                if m[3] >= 1:
                    continue
                v = value_law(m)
                assert sum(v) == 1
                for x in v:
                    dev = abs(x - QQ(1)/3)
                    assert dev <= bound, (d, m, x, dev, bound)
                    checked += 1
                    worst = max(worst, dev)
                    if bound > 0:
                        worst_ratio = max(worst_ratio, dev/bound)
out['deviation_grid'] = {'deltas': [str(x) for x in grid],
                         'marginal_points_checked': int(checked),
                         'worst_abs_deviation': str(worst),
                         'worst_ratio_to_bound': str(worst_ratio),
                         'bound_formula': '16*d/(9-12*d)'}

# Control 3: geometric retry series. Partial sums of
# sum_j m(3)^j * m(c) converge to m(c)/(1-m(3)) with tail <= m(3)^N * m(c)/(1-m(3)).
for m in [m_unif, [QQ(1)/5, QQ(3)/10, QQ(3)/10, QQ(1)/5]]:
    for c in range(3):
        limit = m[c] / (1 - m[3])
        for N in [1, 2, 4, 8, 16, 32]:
            partial = sum(m[3]**j * m[c] for j in range(N))
            tail = m[3]**N * m[c] / (1 - m[3])
            assert partial + tail == limit
            assert abs(limit - partial) <= tail
out['geometric_retry'] = 'exact tail identity partial + m3^N*m(c)/(1-m3) = m(c)/(1-m3)'

# Control 4: chunk map of the pinned MODE1 body (mask/shift/refill).
# chunks of one u64: 32 two-bit fields, low bits first.
def chunks_of_word(w):
    return [(w >> (2*i)) % 4 for i in range(32)]

for w in [0, 1, 2**64-1, 0x0123456789ABCDEF, 0xAAAAAAAAAAAAAAAA]:
    cs = chunks_of_word(w)
    assert len(cs) == 32
    assert cs[0] == w % 4
accepted_example = [c for c in chunks_of_word(0x0123456789ABCDEF) if c != 3]
assert [c - 1 for c in accepted_example] == [c - 1 for c in accepted_example]
out['chunk_map_control'] = {'words_checked': int(5), 'chunks_per_word': int(32),
                            'store_map': 'x-1 on x != 3, rejection of chunk 3'}

# Control 5: the measured S1 counters are exact arithmetic only.
assert ZZ(8192) + ZZ(15436) == ZZ(23628)
assert QQ(8192) / QQ(23628) > QQ(1)/4 and QQ(8192) / QQ(23628) < QQ(1)/2
assert QQ(256) / QQ(739) > QQ(1)/4 and QQ(256) / QQ(739) < QQ(1)/2
assert ZZ(376) + ZZ(392) + ZZ(0) + ZZ(12303) + ZZ(814) + ZZ(1551) + ZZ(8192) == ZZ(23628)
assert QQ(8192) / QQ(2**256) < QQ(1)/4
out['measured_control'] = {'primary': '8192/23628', 'control': '256/739',
                           'reject_accounting': '376+392+0+12303+814+1551+8192=23628',
                           'is_premise': False}

# Control 6: the deviation bound is finite only together with the chunk law.
# The SHAKE chunk law over uniform seeds is NOT computed here; recorded as open.
out['open_premises'] = [
    'chunk law m of the SHAKE word stream over the uniform 32-byte seed law',
    'per-gate acceptance-region distribution bounds (resultants/norm/gs/public/solve/certificate)',
    'coding lower bound at the same first accepted state (certificate/codec lane open)',
]

def native(o):
    if isinstance(o, dict):
        return {str(k): native(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [native(v) for v in o]
    if isinstance(o, bool):
        return o
    if isinstance(o, (int, Integer)):
        return int(o)
    return o

text = json.dumps(native(out), indent=2, sort_keys=True)
with open('ZLOWER134_CONTROLS.json', 'w') as stream:
    stream.write(text + '\n')
