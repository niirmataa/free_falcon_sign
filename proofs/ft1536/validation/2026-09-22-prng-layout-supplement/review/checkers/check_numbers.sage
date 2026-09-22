# Własny niezależny rachunek recenzenta: zadeklarowane unchanged numbers
# suplementu RUN_003 vs poprzednik RUN_002 (exact ZZ, preparser SageMath).
# Uruchomienie: sage check_numbers.sage
import json, pathlib
R2 = pathlib.Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_002')
R3 = pathlib.Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003')

def flat(p):
    d = json.loads((p/'RESOURCE_INTERFACE.json').read_text())
    out = {}
    def rec(o, pre=''):
        for k, v in o.items():
            if isinstance(v, dict): rec(v, pre + k + '.')
            else: out[pre + k] = v
    rec(d)
    return out

fa, fb = flat(R2), flat(R3)
checks = []
def add(name, cond, detail=''):
    checks.append((name, bool(cond), detail))
def find(flatd, suffix):
    hits = [k for k in flatd if k.endswith(suffix)]
    return flatd[hits[0]] if len(hits) == 1 else None

# F4: klucze *_max przywrócone, wartości jak w poprzedniku i w pinie T01
a_ab, b_ab = find(fa, 'abandoned_bytes'), find(fb, 'abandoned_bytes_max')
a_fu, b_fu = find(fa, 'final_unused_bytes'), find(fb, 'final_unused_bytes_max')
add('R2 abandoned_bytes == R3 abandoned_bytes_max == 61320',
    a_ab is not None and b_ab is not None and ZZ(int(a_ab)) == ZZ(61320) and ZZ(int(b_ab)) == ZZ(61320),
    'R2=%s R3=%s' % (a_ab, b_ab))
add('R2 final_unused_bytes == R3 final_unused_bytes_max == 4088',
    a_fu is not None and b_fu is not None and ZZ(int(a_fu)) == ZZ(4088) and ZZ(int(b_fu)) == ZZ(4088),
    'R2=%s R3=%s' % (a_fu, b_fu))

# pin T01: ghost_budget.abandoned_at_reinit_max / final_unused_tail_max
t01 = json.loads((R3/'inputs/bootstrap/T01/RESOURCE_BOUND.json').read_text())
gb = t01.get('ghost_budget', {})
add('pin T01 ghost_budget.abandoned_at_reinit_max == 61320', ZZ(int(gb.get('abandoned_at_reinit_max', -1))) == ZZ(61320))
add('pin T01 ghost_budget.final_unused_tail_max == 4088', ZZ(int(gb.get('final_unused_tail_max', -1))) == ZZ(4088))

# świeżo przeliczony rachunek consumera (exact ZZ)
T = ZZ(49152); q = ZZ(4087)
r_max = (ZZ(33)*T - ZZ(8)) // q
add('r_max = floor((33*49152-8)/4087) = 396', r_max == ZZ(396), str(r_max))
add('64*(1+r_max) = 25408', ZZ(64)*(ZZ(1)+r_max) == ZZ(25408))
add('64*(16+6336) = 406528', ZZ(64)*(ZZ(16)+ZZ(6336)) == ZZ(406528))
add('56*16 = 896', ZZ(56)*ZZ(16) == ZZ(896))
add('896 + 40 nonce = 936', ZZ(896) + ZZ(40) == ZZ(936))
add('bloki*4096 = 26017792 (generated)', ZZ(64)*(ZZ(16)+ZZ(6336))*ZZ(64) == ZZ(26017792))
add('15 * 4088 = 61320', ZZ(15)*ZZ(4088) == ZZ(61320))
add('4096 - 8 = 4088', ZZ(4096) - ZZ(8) == ZZ(4088))

# RESOURCE_INTERFACE: wspólne klucze identyczne R2/R3 (etykiety rozłączne)
common = [k for k in fa if k in fb]
diffs = [k for k in common if fa[k] != fb[k]]
add('RESOURCE_INTERFACE: wspólne klucze R2==R3', not diffs, str(diffs))

ok = all(bool(c[1]) for c in checks)
for n, r, det in checks:
    print(('PASS' if r else 'FAIL'), n, det)
print('SUMMARY', len(checks), 'checks,', sum(1 for c in checks if c[1]), 'passed ->', 'PASS' if ok else 'FAIL')
assert ok, 'FAIL: ' + '; '.join(n for n, r, _ in checks if not r)
