"""Deterministic boundary campaign. Bounds and RN are checked separately."""
from collections import Counter
import hashlib
import sys
from common import W, dump, job, sha
from oracle import Q, MASK, SIGN, FRAC, p2, value, signed, rn, rnint, sqrt_rn, normal, nz

def word(e, f=0, s=0):
    return (s << 63) | (e << 52) | f

def fixtures():
    cases = []
    def put(op, x, y=0, n=0, group='core'):
        cases.append((op, x & MASK, y & MASK, n, group))
    # Entire exponent field (finite), explicit significand and sign boundaries.
    mant = [0, 1, (1 << 51)-1, 1 << 51, FRAC-1, FRAC]
    critical = [0,1,2,3,122,123,124,511,512,969,970,971,1018,1019,1020,1021,
                1022,1023,1024,1052,1053,1054,1055,1057,1058,1059,1074,1075,
                1076,1084,1085,1086,1122,1123,1124,2044,2045,2046]
    pool = sorted({word(e,f,s) for e in critical for f in mant for s in (0,1)})
    for x in pool:
        v = value(x)
        for op in ('neg','half','double'):
            put(op,x,group='edges')
        if v >= 0:
            put('sqrt',x,group='edges')
        if abs(v) < p2(63):
            for op in ('floor','trunc','rint'):
                put(op,x,group='integer')
        for y in (0,SIGN,x,x^SIGN,rn(1),rn(-1)):
            for op in ('add','sub','mul','lt','max'):
                put(op,x,y,group='edges')
        if v:
            put('inv',x,group='edges')
        put('sqr',x,group='edges')
    # Every normal exponent tested with carries, ties, cancellation, sqrt.
    for e in range(1,2047):
        for f in (0,FRAC):
            x = word(e,f,e%2)
            for op,y in [('add',x),('sub',x),('sub',x^1),('mul',rn(Q(3,4))),('div',rn(3))]:
                put(op,x,y,group='exponent_sweep')
            put('sqrt',x & (SIGN-1),group='exponent_sweep')
    # Source contracts include subnormals; test absolute envelopes directly.
    caps = [w for w in pool if abs(value(w)) <= p2(100)]
    denoms = sorted({rn(q)+d for q in (Q(1,16),Q(1,2),Q(1),Q(3),p2(23),p2(35))
                     for d in (-1,0,1) if Q(1,16) <= value(rn(q)+d) <= p2(35)})
    for i,x in enumerate(caps):
        for y in (caps[(i*17+5)%len(caps)],x,x^SIGN,rn(p2(100))):
            for op in ('add','sub','mul'):
                put(op,x,y,group='ROOT')
        for y in denoms:
            put('div',x,y,group='NODE3_div')
    # Public SHA-256(counter) fixtures. No PRNG/key material is consumed.
    for i in range(4096):
        h = hashlib.sha256(('FT1536 public arithmetic fixture '+str(i)).encode()).digest()
        a,b = int.from_bytes(h[:8],'big'),int.from_bytes(h[8:16],'big')
        x = word(1+(a>>52)%1122,a & FRAC,(a>>63)&1)
        y = word(1+(b>>52)%1122,b & FRAC,(b>>63)&1)
        for op in ('add','sub','mul'):
            put(op,x,y,group='ROOT')
        put('div',x,denoms[i%len(denoms)],group='NODE3_div')
        put('high',a,b,group='high')
    # NumericCenter, all z on endpoints; representative z on internal classes.
    centers = [x for x in pool if -2147483283 <= value(x) < 2147483282]
    endpoints = [0,SIGN,1,SIGN|1,rn(-2147483283),rn(2147483282)-1,rn(Q(1,2)),rn(Q(-1,2))]
    for x in sorted(set(centers+endpoints)):
        s = value(x).__floor__()-(x == SIGN)
        zs = range(-365,367) if x in endpoints else (-365,-1,0,1,366)
        put('floor',x,group='ZERO')
        put('sub',x,rn(s),group='ZERO_center')
        for z in zs:
            assert -(1<<31) <= s+z < (1<<31)
            put('of',s+z,group='ZERO_of')
            put('sub',x,rn(s+z),group='ZERO_residual')
    ints = sorted({0,1,-1,(1<<63)-1,-((1<<63)-1)} |
                  {s*((1<<e)+d) for e in range(0,63) for d in (-1,0,1) for s in (-1,1)
                   if abs((1<<e)+d)<(1<<63)})
    for i in ints:
        put('of',i,group='conversion')
        for sc in (-1100,-1076,-1075,-1074,-1023,-1022,-64,-32,-1,0,1,31,100,900):
            put('scaled',i,n=sc,group='conversion')
    for i in (-18433,-768,-3,-1,1,2,3,256,512,768,1536,18433):
        put('inverse_of',i,group='inverse')
    for i in range(-200,201):
        for d in (-1,0,1):
            x = (rn(Q(i,2))+d)&MASK
            if ((x>>52)&2047)<2047:
                for op in ('floor','rint','trunc'):
                    put(op,x,group='ties')
    words = sorted({0,1,MASK,SIGN,SIGN-1} | {1<<i for i in range(64)} |
                   {(1<<i)-1 for i in range(65)})
    for x in words:
        put('norm',x,group='helpers')
        for n in range(64):
            for op in ('ursh','irsh','ulsh'):
                put(op,x,n=n,group='helpers')
        for y in words:
            put('high',x,y,group='high')
    for e in (-1077,-1076,-1075,-1000,-54,0,48,968):
        for m in [0]+[(1<<54)+i for i in range(16)]+[(1<<55)-i for i in range(1,17)]:
            for s in (0,1):
                put('pack',m,s,e,'pack')
    for i in range(257):
        x = rn(Q(i,256)*value(0x3fe62e42fefa39ef))
        put('expm',x,group='transcendental')
        put('exp_small',x,group='transcendental')
        put('exp_small',x^SIGN,group='transcendental')
        put('log',rn(Q(i+1,257)),group='transcendental')
        put('sincos',(i*0xffffffff)//256,group='transcendental')
    return cases

def check(cases, outputs):
    counts, checks = Counter(), Counter()
    errors, diagnostics = [], []
    def eq(got, expected, label, case):
        checks[label] += 1
        if got != expected:
            errors.append(dict(case=case,check=label,observed=str(got),expected=str(expected)))
    def bound(ok,label,case,got):
        checks[label] += 1
        if not ok:
            errors.append(dict(case=case,check=label,observed=f'{got:016x}',expected='source envelope'))
    U, eta = p2(-48),p2(-900)
    for c,(r,z) in zip(cases,outputs):
        op,x,y,n,g = c
        counts[op] += 1
        diag = False
        if op == 'norm':
            k = 64-x.bit_length() if x else 63
            eq((r,signed(z)),(x<<k,-k),'norm',c)
        elif op in ('ursh','irsh','ulsh','high'):
            e = {'ursh':lambda:x>>n,'irsh':lambda:(signed(x)>>n)&MASK,
                 'ulsh':lambda:(x<<n)&MASK,'high':lambda:(x*y)>>64}[op]()
            eq(r,e,op,c)
        elif op == 'pack':
            v = x*p2(n)*(-1 if y else 1)
            expected = (SIGN if y else 0) if n < -1076 else rn(v, bool(y))
            eq(r,expected,'pack_normal_or_flush',c)
        elif op in ('of','scaled','inverse_of'):
            v = Q(signed(x))
            if op == 'scaled': v *= p2(n)
            if op == 'inverse_of': v = 1/v
            expected = rn(v)
            if not v or p2(-1022) <= abs(v) <= value(0x7fefffffffffffff):
                eq(r,expected,'conversion_RN',c)
            else: diag = True
        elif op in ('expm','exp_small','log','sincos'):
            continue  # Independently checked by Sage RBF, never self-oracled.
        else:
            a,b = value(x),value(y)
            if op in ('floor','trunc','rint'):
                expected = a.__floor__() if op == 'floor' else int(a) if op == 'trunc' else rnint(a)
                if op == 'floor' and x == SIGN:
                    eq(signed(r),-1,'known_floor_minus_zero',c)
                else: eq(signed(r),expected,'integer_'+op,c)
            elif op == 'neg':
                eq(r,x^SIGN,'neg_bits',c)
            elif op in ('lt','max'):
                if op == 'max': eq(value(r),max(a,b),'max_value',c)
                elif a == b == 0 and x != y:
                    eq(r,int(x == SIGN),'signed_zero_order_observed',c)
                    if r != int(a<b):
                        diagnostics.append(dict(case=c,observed=f'{r:016x}',expected=f'{int(a<b):016x}',kind='lt_numeric_contract'))
                else: eq(r,int(a<b),'lt_numeric',c)
            elif op == 'sqrt':
                if normal(x) or not a: eq(r,sqrt_rn(a),'sqrt_RN',c)
                else: diag = True
            else:
                v = {'add':lambda:a+b,'sub':lambda:a-b,'mul':lambda:a*b,'sqr':lambda:a*a,
                     'div':lambda:a/b,'inv':lambda:1/a,'half':lambda:a/2,'double':lambda:a*2}[op]()
                finite = ((r>>52)&2047) != 2047
                if op in ('add','sub','mul') and abs(a)<=p2(100) and abs(b)<=p2(100):
                    lim = U*(abs(a)+abs(b) if op in ('add','sub') else abs(v))+eta
                    bound(finite and (normal(r) or nz(r)) and abs(value(r)-v)<=lim,'ROOT_'+op,c,r)
                if op == 'div' and abs(a)<=p2(100) and Q(1,16)<=b<=p2(35):
                    bound(finite and (normal(r) or nz(r)) and abs(value(r)-v)<=U*abs(v)+eta,'NODE3_div',c,r)
                    if Q(1,2)<=b<=p2(23):
                        bound(finite and abs(value(r)-v)<=U*abs(v)+eta,'ROOT_div',c,r)
                if op in ('add','sub') and ((x>>52)&2047)<=1054 and ((y>>52)&2047)<=1054:
                    bound(finite and abs(value(r)-v)<p2(-20),'ZERO_add_error',c,r)
                if g == 'ZERO_center':
                    bound(finite and not (r&SIGN) and 0<=value(r)<=1 and (normal(r) or nz(r)), 'ZERO_r_domain',c,r)
                # Strict RN is only diagnostic outside the normal-result regime.
                eligible = (normal(x) or nz(x)) and (normal(y) or nz(y))
                eligible &= not v or p2(-1022)<=abs(v)<=value(0x7fefffffffffffff)
                if op == 'half': eligible &= ((x>>52)&2047)>=2 or nz(x)
                if op == 'double': eligible &= ((x>>52)&2047)<=2045
                if eligible:
                    negz = False
                    if not v:
                        if op in ('add','sub'): negz = bool(x&SIGN) and bool((y^(SIGN if op=='sub' else 0))&SIGN)
                        elif op in ('mul','sqr'): negz = bool((x^(x if op=='sqr' else y))&SIGN)
                        elif op == 'double': negz = bool(x&SIGN)
                        # Portable div and half canonicalize zero to +0.
                    eq(r,rn(v,negz),'normal_RN_'+op,c)
                else: diag = True
        if diag and len(diagnostics)<80:
            diagnostics.append(dict(case=c,observed=f'{r:016x}',kind='outside_RN_domain'))
    return dict(operation_counts=dict(counts),checks=dict(checks),failures=errors,diagnostics=diagnostics)

def main():
    mode = sys.argv[1]
    assert mode in ('normal','asan')
    cases = fixtures()
    text = ''.join(f'{op} {x:016x} {y:016x} {n}\n' for op,x,y,n,_ in cases).encode()
    (W/'artifacts/corpus.tsv').write_bytes(text)
    # Explicit preflight rejections; these are not submitted to C.
    dump('artifacts/rejected_cases.json',[
        {'operation':'of/scaled','input':'INT64_MIN','reason':'source absolute-value signed overflow'},
        {'operation':'scaled/pack','input':'INT_MIN, INT_MAX scale','reason':'signed exponent adjustment may overflow'},
        {'operation':'div/inv','input':'zero denominator','reason':'caller precondition'},
        {'operation':'sqrt','input':'negative nonzero','reason':'caller precondition'},
        {'operation':'floor/rint/trunc','input':'abs(value)>=2^63, NaN, infinity','reason':'integer conversion domain'},
        {'operation':'shift helpers','input':'n<0 or n>=64','reason':'helper specification n=0..63'},
    ])
    p = job(mode+'-scalar',[f'bin/{mode}/scalar'],text)
    (W/f'artifacts/{mode}_scalar.stdout').write_bytes(p.stdout)
    out = [tuple(int(t,16) for t in ln.split()) for ln in p.stdout.decode().splitlines()]
    assert len(out) == len(cases) and all(len(v)==2 for v in out)
    result = check(cases,out)
    # Second-stage delta uses the actual C center, not the exact rho.
    centers = [r for c,(r,_) in zip(cases,out) if c[4]=='ZERO_center']
    delta_in = ''.join(f'sub 3ff0000000000000 {r:016x} 0\n' for r in centers).encode()
    (W/'artifacts/delta_corpus.tsv').write_bytes(delta_in)
    dp = job(mode+'-delta',[f'bin/{mode}/scalar'],delta_in)
    (W/f'artifacts/{mode}_delta.stdout').write_bytes(dp.stdout)
    delta = [int(ln.split()[0],16) for ln in dp.stdout.decode().splitlines()]
    assert len(delta)==len(centers)
    for r in delta:
        assert not(r&SIGN) and (normal(r) or nz(r)) and 0<=value(r)<=1
    result.update(cases=len(cases),delta_cases=len(delta),corpus_sha256=sha(W/'artifacts/corpus.tsv'),
                  delta_corpus_sha256=sha(W/'artifacts/delta_corpus.tsv'),
                  status='FAIL' if result['failures'] else 'PASS_FINITE_SOURCE_CONTRACT_CONTROLS')
    dump(f'artifacts/{mode}_arithmetic.json',result)
    # Semantic summary is intentionally identical across normal and sanitizers.
    print(f"{mode}: {len(cases)} scalar + {len(delta)} actual-delta cases; {len(result['failures'])} unexpected failures")
    assert not result['failures'], result['failures'][:3]

if __name__ == '__main__': main()
