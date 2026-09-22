"""T02.1 authoritative binding checker (SageMath, `sage prng_checker.sage`).

Confirms, with exact integer arithmetic, that the independent Sage model of
artifacts/model_dump.json equals the original-C-slice harness dumps byte for
byte on every public fixture and stage (whole 4096-byte buffer, state.d,
pointer, type, 64-bit counter), that the harness frame/canary/extract
controls hold, that the sanitizer and alternate-branch controls agree, that
the mutation battery verdicts are as computed, and that the T01 resource
consumer and q-refill corollary were derived exactly.  It re-derives the
counter and resource arithmetic independently instead of trusting
artifacts/model_result.json.

Falcon Project / Thomas Pornin attribution and licenses preserved.
"""
import json
import hashlib
from pathlib import Path

assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024

W = Path('.').absolute()
A = W / 'artifacts'
MASK32 = int('ffffffff', 16)
MOD32 = int('100000000', 16)
MOD64 = int('10000000000000000', 16)
CW = (int('61707865', 16), int('3320646e', 16),
      int('79622d32', 16), int('6b206574', 16))

def m32(x):
    return int(x) & MASK32

def rotl32(x, s):
    x = int(x) & MASK32
    return ((x << s) | (x >> (32 - s))) & MASK32

def u32le(b, off):
    return int.from_bytes(bytes(b[off:off + 4]), 'little')

def u64le(b, off):
    return int.from_bytes(bytes(b[off:off + 8]), 'little')

def qround(st, a, b, c, d):
    st[a] = m32(st[a] + st[b])
    st[d] = rotl32(st[d] ^^ st[a], 16)
    st[c] = m32(st[c] + st[d])
    st[b] = rotl32(st[b] ^^ st[c], 12)
    st[a] = m32(st[a] + st[b])
    st[d] = rotl32(st[d] ^^ st[a], 8)
    st[c] = m32(st[c] + st[d])
    st[b] = rotl32(st[b] ^^ st[c], 7)

def double_round(st):
    qround(st, 0, 4, 8, 12)
    qround(st, 1, 5, 9, 13)
    qround(st, 2, 6, 10, 14)
    qround(st, 3, 7, 11, 15)
    qround(st, 0, 5, 10, 15)
    qround(st, 1, 6, 11, 12)
    qround(st, 2, 7, 8, 13)
    qround(st, 3, 4, 9, 14)

def refill_spot(state56, cc_start):
    """Second, structurally different implementation of the source refill,
    written directly from frng.c for the spot cross-check."""
    saved = [u32le(state56, 4*i) for i in range(12)]
    cc = int(cc_start) % MOD64
    out = []
    for _ in range(64):
        st = [CW[0], CW[1], CW[2], CW[3]] + saved
        st[14] = (st[14] ^^ (cc & MASK32)) & MASK32
        st[15] = (st[15] ^^ ((cc >> 32) & MASK32)) & MASK32
        for _ in range(10):
            double_round(st)
        for v in range(4):
            st[v] = (st[v] + CW[v]) & MASK32
        for v in range(4, 14):
            st[v] = (st[v] + saved[v - 4]) & MASK32
        st[14] = (st[14] + (saved[10] ^^ (cc & MASK32))) & MASK32
        st[15] = (st[15] + (saved[11] ^^ ((cc >> 32) & MASK32))) & MASK32
        cc = (cc + 1) % MOD64
        out.append(b''.join(int(w).to_bytes(4, 'little') for w in st))
    return b''.join(out), cc

fixtures = json.loads((A / 'fixtures.json').read_text())
harness = json.loads((A / 'harness_dump.json').read_text())
sanitized = json.loads((A / 'harness_dump_sanitized.json').read_text())
altbranch = json.loads((A / 'harness_dump_altbranch.json').read_text())
model = json.loads((A / 'model_dump.json').read_text())
model_result = json.loads((A / 'model_result.json').read_text())
mutations = json.loads((A / 'mutations.json').read_text())
kat = json.loads((A / 'kat_vectors.json').read_text())
checks = []
def check(name, ok, detail=None):
    assert ok, (name, detail)
    checks.append(dict(check=name, status='PASS', detail=detail))
print('loaded artifacts')

# ---------------------------------------------------------------- layout
pin = dict(sizeof_prng=int(4368), alignof_prng=int(8), offsetof_buf=int(0), offsetof_ptr=int(4096),
           offsetof_state=int(4104), offsetof_type=int(4360), sizeof_buf=int(4096),
           sizeof_state=int(256))
for key, val in pin.items():
    check('layout.' + key, harness['layout'][key] == val,
          dict(harness=harness['layout'][key], pinned=val))
check('falcon_le_u.actual_branch_1', harness['falcon_le_u'] == 1, harness['falcon_le_u'])
check('falcon_le_u.altbranch_0', altbranch['falcon_le_u'] == 0, altbranch['falcon_le_u'])
check('sanitized.falcon_le_u', sanitized['falcon_le_u'] == 1)

# ------------------------------------------- fixture/stage byte binding
field_pairs = int(0)
fixture_ids = [f['id'] for f in fixtures['fixtures']]
assert fixture_ids == [f['id'] for f in model['fixtures']] == [f['id'] for f in harness['fixtures']]
for fjson, m, h in zip(fixtures['fixtures'], model['fixtures'], harness['fixtures']):
    check('fixture.%s.init56_hex' % fjson['id'], h['init56_hex'] == fjson['init56_hex'])
    check('fixture.%s.cc0_readback' % fjson['id'],
          ZZ(int(h['cc0_readback'])) == ZZ(int(fjson['cc0'])), h['cc0_readback'])
    check('fixture.%s.type_returned' % fjson['id'],
          h['type_returned'] == 1 and m['type_returned'] == 1)
    check('fixture.%s.extract_len_ok' % fjson['id'], h['extract_len_bad'] == False)
    assert [s['stage'] for s in h['stages']] == ['after_init', 'after_refill1', 'after_refill2']
    for hs, ms in zip(h['stages'], m['stages']):
        tag = '%s.%s' % (fjson['id'], hs['stage'])
        check(tag + '.state_hex', hs['state_hex'] == ms['state_hex'])
        check(tag + '.buf_hex', hs['buf_hex'] == ms['buf_hex'])
        check(tag + '.ptr', hs['ptr'] == 0 and ms['ptr'] == 0)
        check(tag + '.type', hs['type'] == 1 and ms['type'] == 1)
        check(tag + '.cc_after', hs['cc_after'] == ms['cc_after'])
        field_pairs += int(5)
        check(tag + '.canary_ok', hs['canary_ok'] == True)
        check(tag + '.state_poison_ok', hs['state_poison_ok'] == True)
        check(tag + '.stub_calls', hs['stub_calls'] == 1)
        check(tag + '.stub_last_len', hs['stub_last_len'] == 56)
        # exact counter arithmetic, re-derived here
        k = ['after_init', 'after_refill1', 'after_refill2'].index(hs['stage']) + 1
        cc0 = ZZ(int(fjson['cc0']))
        check(tag + '.cc_after_formula', ZZ(int(hs['cc_after'])) == (cc0 + ZZ(64) * ZZ(k)) % ZZ(MOD64),
              str((cc0 + ZZ(64) * ZZ(k)) % ZZ(MOD64)))
        first = int(ms['cc_start'])
        check(tag + '.cc_start_formula', ZZ(first) == (cc0 + ZZ(64) * ZZ(k - 1)) % ZZ(MOD64))
        check(tag + '.wrap_flag', ms['wrap_in_stage'] == ((first + 63) >= MOD64))
        check(tag + '.wrap_flag_consistent', ms['wrap_in_stage'] == (int(ms['cc_start']) > int(ms['cc_last'])))

# ------------------------------------------------- frame and stub controls
for row in harness['unsupported']:
    check('unsupported.type_%d.returned_0' % row['type'], row['returned'] == 0)
    check('unsupported.type_%d.no_extract' % row['type'], row['extract_calls'] == 0)
    check('unsupported.type_%d.all_poison' % row['type'], row['all_poison'] == True)
    check('unsupported.type_%d.canary_ok' % row['type'], row['canary_ok'] == True)
check('unsupported.type_list',
      [r['type'] for r in harness['unsupported']] == [2, 3, -1, 99, 1048576],
      [r['type'] for r in harness['unsupported']])

d = harness['determinism']
b0 = harness['fixtures'][0]['stages'][0]
check('determinism.same_init_same_state', d['state_hex'] == b0['state_hex'])
check('determinism.same_init_same_buf', d['buf_hex'] == b0['buf_hex'])
check('determinism.ptr_type_cc', d['ptr'] == 0 and d['type'] == 1 and d['cc_after'] == b0['cc_after'])
check('determinism.extract_calls', d['extract_calls'] == 1)
t = harness['type_equivalence']
check('type_equivalence.type0_is_type1',
      t['type_returned'] == 1 and t['state_hex'] == b0['state_hex'] and t['buf_hex'] == b0['buf_hex'])
check('type_equivalence.extract_calls', t['extract_calls'] == 1)

# ------------------------------------------------- sanitizer/alt-branch equality
for name, other in (('sanitized', sanitized), ('altbranch', altbranch)):
    same = True
    for h1, h2 in zip(harness['fixtures'], other['fixtures']):
        for s1, s2 in zip(h1['stages'], h2['stages']):
            same = same and s1['state_hex'] == s2['state_hex'] and s1['buf_hex'] == s2['buf_hex']
            same = same and s1['cc_after'] == s2['cc_after'] and s1['ptr'] == s2['ptr']
    check('%s.byte_equality' % name, same)
    check('%s.tag' % name, other['tag'] == 'ORIGINAL_C_SLICE')


# --------------------------------------------------------------- mutations
check('mutations.count', mutations['count'] == 8, mutations['count'])
by_id = {m['id']: m for m in mutations['mutations']}
for mut in mutations['mutations']:
    if mut['kind'] == 'NO_OP_BY_CONSTRUCTION':
        check('mutations.%s.noop' % mut['id'],
              mut['verdict'] == 'NO_OP' and not mut['killed_by'])
    else:
        check('mutations.%s.killed' % mut['id'],
              mut['verdict'] == 'KILLED' and len(mut['killed_by']) > 0)
        firsts = [r['first_difference'] for r in mut['per_fixture'] if r['differs']]
        check('mutations.%s.evidence' % mut['id'],
              all(fd is not None and fd['stage'] in ('after_init', 'after_refill1', 'after_refill2')
                  for fd in firsts))
check('mutations.counter32.equivalence_class',
      by_id['counter32']['equivalent_on'] == ['F0_ALLZERO', 'F2_IV_ASYM_CTR0'],
      by_id['counter32']['equivalent_on'])
check('mutations.inference.reference_equals_C', True,
      'reference model == C harness on the compared stage fields, so a mutant differing from the reference differs from C too')

# ----------------------------------------------- counter / wrap rederivation
counter_rows = {r['fixture']: r for r in model['counter_rows']}
for fjson in fixtures['fixtures']:
    cc0 = ZZ(int(fjson['cc0']))
    row = counter_rows[fjson['id']]
    check('counter.%s.cc0' % fjson['id'], ZZ(int(row['cc0'])) == cc0)
    check('counter.%s.count_distinct' % fjson['id'],
          row['count'] == 192 and row['distinct'] == 192)
    crosses = []
    for s in range(3):
        # stage s covers counters (cc0+64*s+k) mod 2^64, k = 0..63; it wraps
        # iff the in-stage start plus 63 reaches 2^64 (equivalently cc_last <
        # cc_start). The start itself must be reduced mod 2^64 first: a later
        # stage of an already-wrapped context does not re-wrap.
        start = (cc0 + ZZ(64) * ZZ(s)) % ZZ(MOD64)
        if start + ZZ(63) >= ZZ(MOD64):
            crosses.append(['after_init', 'after_refill1', 'after_refill2'][s])
    check('counter.%s.wrap_stages' % fjson['id'], row['wrap_stages'] == crosses,
          dict(model=row['wrap_stages'], rederived=crosses))
check('counter.F4.init_post', harness['fixtures'][4]['stages'][0]['cc_after'] == '63')
check('counter.F5.init_post', harness['fixtures'][5]['stages'][0]['cc_after'] == '0')
check('counter.F6.wrap_stages',
      [s['wrap_in_stage'] for s in model['fixtures'][6]['stages']] == [False, True, False])
check('counter.wrap_not_repeat',
      all(r['distinct'] == 192 for r in model['counter_rows']),
      'wrap crossings keep all 192 per-context counters distinct')

# ------------------------------------------------ resources (recomputed in ZZ)
res = model_result['resources']
T_MAX = ZZ(49152)
J_MAX = ZZ(16)
r_max = (ZZ(33) * T_MAX - ZZ(8)) // ZZ(4087)
check('resources.r_max', r_max == ZZ(396), str(r_max))
check('resources.blocks_per_context', ZZ(64) * (1 + r_max) == ZZ(25408))
check('resources.additional_refills', J_MAX * r_max == ZZ(6336))
check('resources.region_blocks', ZZ(64) * (J_MAX + J_MAX * r_max) == ZZ(406528))
check('resources.shake56', ZZ(56) * J_MAX == ZZ(896))
check('resources.shake56_with_nonce', ZZ(56) * J_MAX + ZZ(40) == ZZ(936))
check('resources.monotone',
      all(ZZ(64) * (ZZ(1) + r) <= ZZ(25408) for r in range(0, 397)))
check('resources.model_matches_rederivation',
      res['r_max'] == str(r_max)
      and res['blocks_per_reached_context'] == str(ZZ(64) * (1 + r_max))
      and res['region_block_evaluations'] == str(ZZ(64) * (J_MAX + J_MAX * r_max))
      and res['requested_parent_SHAKE56_bytes'] == str(ZZ(56) * J_MAX)
      and res['with_nonce40_upper'] == str(ZZ(56) * J_MAX + ZZ(40)))
t01 = res['received_T01']
check('resources.t01_consistency',
      ZZ(int(t01['additional_blocks'])) == J_MAX * r_max
      and ZZ(int(t01['all_blocks'])) == J_MAX + J_MAX * r_max
      and ZZ(int(t01['generated_bytes'])) == ZZ(int(t01['all_blocks'])) * ZZ(4096)
      and ZZ(int(t01['getter_drops'])) == ZZ(9) * J_MAX * r_max
      and ZZ(int(t01['abandoned_bytes_max'])) == ZZ(int(t01['reinit_abandonments'])) * ZZ(4088)
      and ZZ(int(t01['returned_bytes'])) == ZZ(33) * ZZ(int(t01['proposals']))
      and ZZ(int(t01['source_SHAKE56_bytes'])) == ZZ(56) * J_MAX)


# --------------------------------------------- q-refill corollary rederivation
def u8_stream(q):
    ptr = 0
    refills = 0
    for _ in range(q):
        ptr += 1
        if ptr == 4096:
            refills += 1
            ptr = 0
    return refills, ptr
for q in range(0, 20001):
    r, p = u8_stream(q)
    assert ZZ(r) == ZZ(q) // ZZ(4096) and ZZ(p) == ZZ(q) % ZZ(4096), q
check('q_refill.exhaustive_0_20000', True,
      'refills = floor(q/4096), ptr = q mod 4096 for all q in 0..20000 (recomputed)')
check('q_refill.model_checks', model_result['q_refill']['exhaustive_range'] == '0..20000 exact')

# ------------------------------- spot cross-check with a second core writing
for fid in ('F0_ALLZERO', 'F5_IV_ASYM_CTR64M64'):
    fjson = [f for f in fixtures['fixtures'] if f['id'] == fid][0]
    mstage = [f for f in model['fixtures'] if f['id'] == fid][0]['stages'][0]
    hstage = [f for f in harness['fixtures'] if f['id'] == fid][0]['stages'][0]
    buf, cc = refill_spot(bytes.fromhex(fjson['init56_hex']), int(fjson['cc0']))
    check('spot.%s.refill' % fid,
          buf.hex() == mstage['buf_hex'] == hstage['buf_hex']
          and str(cc) == mstage['cc_after'] == hstage['cc_after'])

# -------------------------------------------------------------- KAT controls
check('kat.vectors', model_result['kat']['vectors'] == 5 and model_result['kat']['all_match'] == True)
check('kat.rfc8439_2_3_2_literal',
      kat['vectors'][1]['keystream_hex'] == kat['rfc8439_2_3_2_hex'])
check('kat.classic_all_zero_literal',
      kat['vectors'][3]['keystream_hex'] == kat['classic_all_zero_hex'])
check('kat.oracle', kat['tag'] == 'INDEPENDENT_OPENSSL_ORACLE')

# --------------------------------------------------- deterministic examples
check('cross_context.same_cc0',
      harness['fixtures'][0]['cc0_readback'] == '0'
      and harness['fixtures'][2]['cc0_readback'] == '0')
check('cross_context.different_buffers',
      harness['fixtures'][0]['stages'][0]['buf_hex'] != harness['fixtures'][2]['stages'][0]['buf_hex'])
check('cross_context.model_matches',
      model_result['examples']['same_cc0_different_context'].startswith('F0_ALLZERO'))

scope = dict(
    proved_bound='A+B+C for the pinned source model: 56-byte init layout and type dispatch, exact 64-block refill with per-block counters, post counter +64 mod 2^64, first-48-bytes preservation, ptr/frame, and the T01 budget consumer; universal source argument in SOURCE_MODEL_BINDING.md, fixture equality is a binding check',
    open='SHAKE-256/ChaCha20 output distribution and security, real PRNG to IID_BUFFER hop, whole real Sign, termination, owner acceptance; kernel: counter/layout/resource/q-refill in formal/CounterLayout.lean (28 theorems); ChaCha Word32 rounds stay outside the kernel (explicit boundary)',
    real_prng_to_iid_bridge_proved=False, SHAKE_security_proved=False,
    ChaCha_security_proved=False, whole_real_Sign_proved=False,
    source_changed=False, owner_accepted=False)
hashes = {p: hashlib.sha256((A / p).read_bytes()).hexdigest()
          for p in ('fixtures.json', 'fixtures.bin', 'kat_vectors.json',
                    'harness_dump.json', 'harness_dump_sanitized.json',
                    'harness_dump_altbranch.json', 'model_dump.json',
                    'model_result.json', 'mutations.json')}
checker_result = dict(
    schema='PRNG_T021_CHECKER_RESULT_V1', tag='AUTHORITATIVE_SAGE_CHECKER',
    status='PASS', checks=len(checks), checks_list=checks,
    field_pairs_compared=int(field_pairs),
    fixtures=int(len(fixtures['fixtures'])), stages=int(len(fixtures['fixtures']) * 3),
    artifacts=hashes, scope=scope)
(A / 'checker_result.json').write_text(json.dumps(checker_result, indent=2) + '\n')
print('checker PASS: %d checks, %d compared stage fields' % (len(checks), field_pairs))
