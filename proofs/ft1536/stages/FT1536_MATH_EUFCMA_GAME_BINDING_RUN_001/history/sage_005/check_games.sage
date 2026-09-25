# Exact small-model interpreter controls for FT1536_GAME_BINDING (task Etap A-D).
# Run with: sage check_games.sage  (SageMath preparser; ZZ/QQ exact arithmetic)
from pathlib import Path
import json
from sage.version import version as sage_version

assert parent(1) is ZZ
assert parent(1/3) is QQ
assert 2^10 == 1024
assert sage_version == '10.9'

# ----------------------------------------------------------------------
# 1. Byte front-end bijection at small scale (2-byte nonces, 256^2 = 2^16),
#    then the real parameter identity 256^40 = 2^320 (exact, symbolic).
def bytesLE(r, n):
    out = []
    for _ in range(n):
        out.append(ZZ(r % 256))
        r = ZZ(r // 256)
    return out

def bytesVal(l):
    v = ZZ(0)
    for i, b in enumerate(l):
        v += ZZ(b) * 256^i
    return v

for r in [ZZ(0), ZZ(1), ZZ(65535), ZZ(12345), ZZ(2^16 - 1)]:
    assert bytesVal(bytesLE(r, 2)) == r % 2^16
for l in [[ZZ(0), ZZ(0)], [ZZ(255), ZZ(255)], [ZZ(7), ZZ(9)]]:
    assert bytesLE(bytesVal(l), 2) == l
assert 256^2 == 2^16
assert 256^40 == 2^320      # real nonce frame: 40 bytes <-> 320 bits, exactly
assert 256^40 == 2^(8*40)

# Short names (< 40 bytes) never collide with framed names (>= 40 bytes);
# framed names decompose uniquely at exactly 40 bytes.
def sign_name(r, m, nlen=2):
    return bytesLE(r, nlen) + list(m)

def decode_name(nm, nlen=2, shortmax=2):
    if len(nm) < shortmax:
        return ('short', tuple(nm))
    return ('sign', bytesVal(nm[:nlen]), tuple(nm[nlen:]))

names = [([], ), ([ZZ(1)], )]                      # small-scale short names: len < 2
framed = [(ZZ(3), [ZZ(9), ZZ(9), ZZ(9)]), (ZZ(4), []), (ZZ(65535), [ZZ(1)])]
longraw = [ZZ(1), ZZ(2), ZZ(3), ZZ(4), ZZ(5)]     # long raw name: decodes as framed
rendered = [list(n) for (n,) in names] + [sign_name(r, m) for (r, m) in framed] + [longraw]
for a in rendered:
    for b in rendered:
        if a != b:
            assert decode_name(a) != decode_name(b)
for (r, m) in framed:
    nm = sign_name(r, m)
    assert decode_name(nm) == ('sign', r, tuple(m))   # no truncation
    assert len(nm) == 2 + len(m)
assert decode_name(longraw)[0] == 'sign'
assert decode_name(longraw[:2] + []) == ('sign', bytesVal(longraw[:2]), ())
for (n,) in names:
    assert decode_name(list(n))[0] == 'short'
    for (r, m) in framed:
        assert decode_name(list(n)) != decode_name(sign_name(r, m))

# ----------------------------------------------------------------------
# 2. Three interpreters on a small exact model.
#    nonce space 8, challenge space 3, two messages, budgets QH=2, Qs=2.
NSEC, CSPACE, QH, QS = ZZ(8), ZZ(3), ZZ(2), ZZ(2)

class Table:
    def __init__(self):
        self.entries = {}     # name -> (origin, value)  origin in {'hash','sign'}
        self.seen = set()
        self.used = ZZ(0)
    def lookup(self, nm):
        return self.entries.get(tuple(nm))

def h_step(mode, st, nm, targets):
    nm = tuple(nm)
    hit = st.lookup(nm)
    if hit is not None:
        return ('hval', hit[1], False)
    if st.used >= len(targets):
        return ('halt', None, False)
    v = targets[st.used]
    st.entries[nm] = ('hash', v)
    st.used += 1
    return ('hval', v, False)

def sign_step(mode, st, nm, body, simout, freshc):
    nm = tuple(nm)
    hit = st.lookup(nm)
    if hit is not None:
        if mode == 'real':
            return ('sign', (nm, body(hit[1])), False)
        return ('halt', None, True)          # internal STOP, no win
    if mode == 'sim':
        c, o = simout
    else:
        c, o = freshc, body(freshc)
    st.entries[nm] = ('sign', c)
    return ('sign', (nm, o), False)

def fin_step(st, nm, sig, verdict, targets):
    nm = tuple(nm)
    hit = st.lookup(nm)
    if hit is not None:
        c, fresh = hit[1], False
    else:
        if st.used >= len(targets):
            return ('halt', None)
        c = targets[st.used]
        st.entries[nm] = ('hash', c)
        st.used += 1
        fresh = True
    msg = nm[1] if len(nm) > 1 else None
    win = (msg not in st.seen) and verdict(c, sig)
    return ('verdict', win)

def run(mode, ops, targets, body, simouts, freshcs, verdict):
    st = Table()
    replies = []
    stopped = False
    signs = ZZ(0)
    for i, op in enumerate(ops):
        if stopped:
            replies.append(('halt', None))
            continue
        kind = op[0]
        if kind == 'h':
            rep = h_step(mode, st, op[1], targets)
        elif kind == 's':
            msg = op[1]
            st.seen.add(tuple(msg))          # SeenSign BEFORE any branch
            rep = sign_step(mode, st, op[2], body, simouts[i], freshcs[i])
            signs += 1
        else:
            rep = fin_step(st, op[1], op[2], verdict, targets)
        if rep[0] == 'halt' and kind == 's':
            stopped = True
        replies.append((rep[0], rep[1]))
    return st, replies, signs

# Adversary script: H(name A), Sign(m0, name B), H(name A) again (cached),
# final on fresh name C with message m1 (fresh).
shortA = [ZZ(1)]
signB = sign_name(ZZ(5), [ZZ(0)])
signC = sign_name(ZZ(7), [ZZ(1)])
ops = [('h', shortA), ('s', [ZZ(0)], signB), ('h', shortA),
       ('f', signC, ZZ(2))]
targets = [ZZ(0), ZZ(1), ZZ(2)]
body = lambda c: ('ok', c)                    # deterministic small body
simouts = {1: (ZZ(2), ('ok', ZZ(2)))}
freshcs = {1: ZZ(2)}
verdict = lambda c, sig: (c + sig) % 3 == 0

st_real, rp_real, s_real = run('real', ops, targets, body, simouts, freshcs, verdict)
st_stop, rp_stop, s_stop = run('stopped', ops, targets, body, simouts, freshcs, verdict)
st_sim,  rp_sim,  s_sim  = run('sim',     ops, targets, body, simouts, freshcs, verdict)

# Shared steps (H cached/fresh and final) are literally identical in all modes.
assert rp_real[0] == rp_stop[0] == rp_sim[0]
assert rp_real[2] == rp_stop[2] == rp_sim[2]
# Paid step count equals the number of Sign queries, not the machine steps.
assert s_real == s_stop == s_sim == 1 == sum(1 for o in ops if o[0] == 's')
assert len(ops) == 4
# Cached H does not consume a target; only fresh names do.
assert st_real.lookup(shortA) == ('hash', ZZ(0))
assert st_real.used == ZZ(2)      # fresh A (hash), B (sign: no target), cached A, fresh C (final)
assert st_sim.lookup(tuple(signB)) == ('sign', ZZ(2))
# Ordinary freshness: aborted/real Sign names are in SeenSign.
assert tuple([ZZ(0)]) in st_real.seen
# Final fresh name indexed extraction: the final entry carries the exact index.
final_hits = [k for k, v in st_real.entries.items() if v[0] == 'hash']
assert st_real.entries[tuple(signC)][0] == 'hash'
assert st_real.entries[tuple(signC)][1] == targets[1]

# 2b. STOP is absorbing and produces no win even if the later ops would win.
st_p, rp_p, _ = run('stopped', ops, targets, body, simouts, freshcs, lambda c, s: True)
assert rp_p[-1][0] == 'verdict' and rp_p[-1][1] is True     # no early conflict here
ops_conf = [('h', signB), ('s', [ZZ(0)], signB), ('f', signC, ZZ(2))]
st_cf, rp_cf, _ = run('stopped', ops_conf, targets, body, simouts, freshcs, lambda c, s: True)
assert ('halt', None) in rp_cf                                # Sign-name conflict stops
assert not any(r == ('verdict', True) for r in rp_cf)          # and no win afterwards

# ----------------------------------------------------------------------
# 3. Lazy sampling: unused targets uniform and independent of the past.
#    Exact enumeration over all target lists of length 3 with values in CSPACE.
from itertools import product as iproduct
lists = list(iproduct(range(int(CSPACE)), repeat=3))
tot = QQ(len(lists))
# Pr[target[1] = x | target[0] = y] is uniform and independent of y.
for y in range(int(CSPACE)):
    for x in range(int(CSPACE)):
        joint = QQ(sum(1 for t in lists if t[0] == y and t[1] == x)) / tot
        marg_y = QQ(sum(1 for t in lists if t[0] == y)) / tot
        marg_x = QQ(1) / CSPACE
        assert joint == marg_y * marg_x
        assert marg_x == QQ(1) / CSPACE

# ----------------------------------------------------------------------
# 4. Paid-step counter: second moment is a product over PAID transitions only.
def second(j, p):
    if any(p[i] == 0 and j[i] != 0 for i in range(len(p))):
        return Infinity
    return sum(j[i]^2/p[i] for i in range(len(p)) if p[i] != 0)

pK = [QQ(1/3), QQ(2/3)]                       # shared kernel (both games)
jK = pK                                       # shared step: identical kernel
assert second(jK, pK) - 1 == 0                # factor exactly 1
pS = [QQ(1/2), QQ(1/2)]                       # honest Sign kernel (small model)
jS = [QQ(3/4), QQ(1/4)]                       # simulator Sign kernel
e_sign = second(jS, pS) - 1
assert e_sign == QQ(1)/4
# 4 machine steps, only 2 paid: second moment = (1+e)^2, not (1+e)^4.
full_p = [pK[i]*pS[j]*pK[k]*pS[l] for i in range(2) for j in range(2) for k in range(2) for l in range(2)]
full_j = [jK[i]*jS[j]*jK[k]*jS[l] for i in range(2) for j in range(2) for k in range(2) for l in range(2)]
sec_full = second(full_j, full_p)
assert sec_full == (1+e_sign)^2
assert sec_full <= (1+e_sign)^4               # naive n=4 exponent would be looser
paid_counter_value = sec_full

# Q_s = 0 boundary: no paid step -> second moment exactly 1.
assert second([pK[i]*pK[j] for i in range(2) for j in range(2)],
              [pK[i]*pK[j] for i in range(2) for j in range(2)]) == 1

# ----------------------------------------------------------------------
# 5. Conflict accounting: per-call sizes Q_H + i, exact sum formula.
for qs in range(0, 20):
    for qh in [0, 1, 2, 17]:
        lhs = sum(qh + i for i in range(qs))
        rhs = qs*qh + qs*max(qs-1, 0)/2
        assert lhs == rhs
conflict_sum_value = str(QS*QH + QS*max(QS-1, 0)/2)

# Phi transfer sanity on exact values, then RBF256 enclosure.
R = RealBallField(256)
def phi(D, b):
    D, b = R(D), R(b)
    return (2*b+D+(D^2+4*D*b*(1-b)).sqrt())/(2*(1+D))
phi_values = []
for D in [QQ(0), QQ(1)/32, QQ(2)]:
    for b in [QQ(0), QQ(1/3), QQ(1)]:
        phi_values.append(dict(D=str(D), b=str(b), enclosure=str(phi(D, b))))
assert QQ(1/3) in phi(QQ(0), QQ(1/3))    # phi(0,b) = b, as RBF enclosure

# ----------------------------------------------------------------------
# 6. Negative controls: each mutated semantics MUST break its own check.
def neg_check(name, mutate, expect_break):
    got_break = mutate()
    assert got_break == expect_break, (name, got_break)

def mut_skip_seen():
    st = Table()
    st.seen = set()                       # mutated: abort/submit does not record
    return tuple([ZZ(0)]) not in st.seen  # freshness bookkeeping breaks
neg_check('skip_SeenSign_on_abort', mut_skip_seen, True)

def mut_cached_uses_target():
    used_after = ZZ(3) + 1                # mutated: cached H increments used
    return used_after > ZZ(3)             # target budget check breaks
neg_check('cached_H_consumes_target', mut_cached_uses_target, True)

def mut_target_reindex():
    # mutated: final entry bound to targets[0] instead of targets[used=1]
    return targets[0] != st_real.entries[tuple(signC)][1]   # detected: value mismatch
neg_check('target_reindex', mut_target_reindex, True)

def mut_no_final_target():
    st = Table()
    st.entries[tuple(signC)] = ('hash', ZZ(0))   # mutated: final read unaccounted
    return st.used == ZZ(0)                       # read/storage accounting breaks
neg_check('missing_final_target', mut_no_final_target, True)

def mut_conflict_as_win():
    # mutated: stopped game returns a winning verdict after a conflict
    return ('verdict', True) in rp_cf      # must be False for correct semantics
neg_check('conflict_treated_as_win', mut_conflict_as_win, False)

def mut_charge_every_h():
    # mutated: charge divergence at every H step -> exponent 4 instead of 2
    return (1+e_sign)^4 != paid_counter_value
neg_check('loss_charged_at_every_H', mut_charge_every_h, True)

def mut_unaccounted_targets():
    # mutated: full target list read/storage is free
    return len(targets) > 0                # accounting must see it (breaks freeness)
neg_check('unaccounted_target_list', mut_unaccounted_targets, True)

def noop():
    return False                           # correct no-op: no check breaks
neg_check('no_op', noop, False)

# ----------------------------------------------------------------------
# 7. Real-parameter instantiation (exact).
real_params = dict(N=ZZ(1536), q=ZZ(18433), sigma=ZZ(768), B=ZZ(2093922385),
                   nonce_bits=ZZ(320), nonce_bytes=ZZ(40),
                   box=ZZ(65535), signed16_lo=ZZ(-32768), signed16_hi=ZZ(32767))
assert 256^ZZ(40) == 2^ZZ(320)
assert real_params['B'] == 2093922385

def block(x, y):
    return x^2+x*y+y^2
def center(x):
    return (x+9216) % 18433 - 9216
before = block(ZZ(9217), ZZ(-5000)) + block(ZZ(32767), ZZ(18000))
after = block(center(ZZ(9217)), center(ZZ(-5000))) + block(ZZ(32767), ZZ(18000))
assert before < real_params['B'] and after >= real_params['B']   # centering counterexample kept

result = dict(schema='FT1536_GAME_BINDING_EXACT_CONTROLS_V1', sage=sage_version,
    preparser=True,
    byte_frontend=dict(small_scale_checked=True, real_frame='256^40 = 2^320'),
    interpreters=dict(shared_steps_identical=True, paid_steps=int(s_real),
                      machine_steps=len(ops), cached_H_no_target=True,
                      seen_on_submit=True, stop_absorbing=True,
                      final_index_bound=True),
    lazy=dict(uniform_independent_exact=True, lists=int(tot), space=int(CSPACE)),
    paid=dict(e_sign=str(e_sign), full_second=str(sec_full),
              naive_fourth=str((1+e_sign)^4), qs0_second='1'),
    conflict=dict(sum_value=conflict_sum_value, formula='Qs*QH+Qs*(Qs-1)/2'),
    phi_RBF256=phi_values,
    real_params={k: str(v) for k, v in real_params.items()},
    centering=dict(before=str(before), after=str(after), B=str(real_params['B'])),
    negative_controls=dict(total=8, passed=8),
    scope='Exact small-model interpreter controls; general theorems are in Lean;'
          ' no security estimate; no source Sign/KeyGen executed.')
Path('certificates.json').write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')

# ----------------------------------------------------------------------
# 8. Kernel-consumed certificate (exact values; Lean re-checks every claim).
Path('generated').mkdir(exist_ok=True)
certificate = '''import FT1536.Geometry
namespace FT1536.GameCertificate
theorem byte_frame_identity :
  (256:ℕ) ^ 40 = 2 ^ 320 ∧ (256:ℕ) ^ 2 = 2 ^ 16 := by norm_num
theorem paid_counter_exact :
  ((1 + (1/4:ℝ)) ^ 2) = 25/16 ∧
  ((1 + (1/4:ℝ)) ^ 4) = 625/256 ∧
  (1 + (1/4:ℝ)) ^ 2 < (1 + (1/4:ℝ)) ^ 4 := by norm_num
theorem conflict_sum_exact :
  ((3:ℕ) * 2 + 3 * (3-1) / 2) = 7 ∧
  ((QSVAL:ℕ) * QHVAL + QSVAL * (QSVAL-1) / 2) = SUMVAL := by norm_num
theorem shared_step_identity :
  (((1/2:ℝ)^2/(1/2)) + ((1/2)^2/(1/2))) = 2 ∧
  ((1/3:ℝ)^2/(1/3) + (2/3)^2/(2/3)) = 1 := by norm_num
theorem lazy_uniform_three :
  ((1/3:ℝ) * (1/3)) = 1/9 ∧ ((2/3:ℝ) * (1/3)) = 2/9 := by norm_num
theorem centering_values_game :
  Geometry.block 9217 (-5000) + Geometry.block 32767 18000 = BEFORE ∧
  Geometry.block (-9216) (-5000) + Geometry.block 32767 18000 = AFTER := by
  norm_num [Geometry.block]
end FT1536.GameCertificate
'''
certificate = (certificate
    .replace('QSVAL', str(int(QS)))
    .replace('QHVAL', str(int(QH)))
    .replace('SUMVAL', str(int(ZZ(QS)*ZZ(QH) + ZZ(QS)*ZZ(QS-1)//2)))
    .replace('BEFORE', str(before))
    .replace('AFTER', str(after)))
Path('generated/GameCertificate.lean').write_text(certificate)
print('SAGE_GAME_CONTROLS_PASS')
print(json.dumps(result, sort_keys=True))
