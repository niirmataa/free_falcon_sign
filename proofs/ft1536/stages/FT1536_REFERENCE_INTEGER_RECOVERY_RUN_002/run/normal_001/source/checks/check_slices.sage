# Actual public terminal/suffix/rint controls. Finite diagnostics, not membership.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import json
import os
import sys
from pathlib import Path
from sage.env import SAGE_VERSION
assert SAGE_VERSION == '10.9'
OUT = Path(os.environ['RUN002_DEST']) / 'build'
mode = sys.argv[1]

def decode(w):
    w = ZZ(w)
    s, exponent, frac = w >> 63, (w >> 52) & 2047, w & (2^52-1)
    assert exponent != 2047
    return (-1)^s * (frac*2^-1074 if exponent == 0 else (2^52+frac)*2^(exponent-1075))

def encode(q):
    q = QQ(q)
    if q == 0:
        return ZZ(0)
    s = 0 if q > 0 else 1
    a, e = abs(q), 0
    while a < 1:
        a *= 2; e -= 1
    while a >= 2:
        a /= 2; e += 1
    m = (a-1)*2^52
    assert m in ZZ and -1022 <= e <= 1023
    w = ZZ(s*2^63 + (e+1023)*2^52 + m)
    assert decode(w) == q
    return w

def nearest(q):
    q = QQ(q)
    lo = floor(q)
    r = q-lo
    return ZZ(lo if r < 1/2 or (r == 1/2 and lo%2 == 0) else lo+1)

term = [(encode(2^29), encode(1+2^-24), ZZ(2^29), ZZ(0)),
        (encode(-2^29), encode(-1-2^-24), -ZZ(2^29), ZZ(0)),
        (ZZ(0), ZZ(2^63), ZZ(0), ZZ(0))]
rints = [ZZ(0), ZZ(2^63), ZZ(1), ZZ(2^63+1), ZZ(2^52-1), ZZ(2^63+2^52-1)]
for n in [-3,-2,-1,0,1,2,3]:
    for off in [-2^-50, 0, 2^-50]:
        rints.append(encode(n+1/2+off))

if mode == 'preflight':
    for t0,t1,y0,y1 in term:
        assert abs(decode(t0)) < 937866519 and abs(decode(t1)) < 2
        assert abs(decode(t1)-y1) < 367
        assert abs(decode(t0)-y0) < 1
    assert all(abs(decode(w)) < 4 for w in rints)
    # Public suffix entries have |component|<=8. Each product component<=48,
    # each sum<=96: well inside the historical finite <2^100 domains.
    assert 2*3*8+2*2*8 <= 96 < 2^100
    text = '/* Sage-generated public, exact-domain diagnostic inputs. */\n'
    text += 'static const struct { fpr t0,t1; int y0,y1; } term_cases[] = {\n'
    for t0,t1,y0,y1 in term:
        text += '{0x%016xULL,0x%016xULL,%d,%d},\n' % (t0,t1,y0,y1)
    text += '};\nstatic const fpr rint_cases[] = {\n'
    text += ''.join('0x%016xULL,\n' % w for w in rints)+'};\n'
    (OUT/'public_cases.h').write_text(text)
    (OUT/'C_DOMAIN_PREFLIGHT.json').write_text(json.dumps({
        'pass': True, 'sage_version': SAGE_VERSION, 'terminal_cases': len(term),
        'rint_cases': len(rints), 'suffix_slots_each_vector': 1536,
        'domain': 'local public finite slices only; no emitted-key/history membership',
        'new_secrets': False, 'suffix_scalar_operand_cap': '96',
        'raw_signed_zero_and_subnormal_rint_inputs': True,
        'required_domain_counterexample': False},indent=2,sort_keys=True)+'\n')
    print('C_DOMAIN_PREFLIGHT_PASS')
else:
    assert mode == 'check'
    rows = [json.loads(s) for s in (OUT/'C_SLICES.ndjson').read_text().splitlines()]
    ts = [r for r in rows if r['case']=='terminal']
    rs = [r for r in rows if r['case']=='rint']
    fs = [r for r in rows if r['case']=='suffix']
    assert len(ts)==len(term) and len(rs)==len(rints) and len(fs)==1536
    def val(row,k): return decode(ZZ(row[k],16))
    terminal = []
    for i,(t0,t1,y0,y1) in enumerate(term):
        r=ts[i]; assert r['i']==i
        assert val(r,'mu1')==decode(t1)
        # First two fixtures have exact half and both exact subtraction stages.
        if i < 2:
            rx = (decode(t1)-y1)/2
            eadd = val(r,'mu0')-(decode(t0)+rx)
            esub = (val(r,'z0')+rx)-(val(r,'mu0')-y0)
            defect = val(r,'z0')-(decode(t0)-y0)
            assert esub == 0 and defect == eadd != 0
            assert abs(eadd) == 2^-25
            terminal.append({'i': int(i), 'old_target_defect': str(defect),
                             'update_add_error': str(eadd), 'sub_and_half_errors': '0'})
        else:
            assert val(r,'z0')==0 and val(r,'z1')==0
    for i,w in enumerate(rints):
        assert rs[i]['i']==i and ZZ(rs[i]['word'],16)==w
        assert ZZ(rs[i]['result']) == nearest(decode(w))
    # Check all768 physical complex slots, BOTH frequency vectors.
    K = QuadraticField(-1,'j'); j=K.gen()
    stale_count=sign_count=0
    for i in range(768):
        lo,hi=fs[i],fs[i+768]
        assert lo['i']==i and hi['i']==i+768
        vals={k:K(val(lo,k))+j*val(hi,k) for k in ['x','y','b00','b01','b10','b11','out0','out1']}
        x,y=vals['x'],vals['y']
        w0=x*vals['b00']+y*vals['b10']
        w1=y*vals['b11']+x*vals['b01']
        assert vals['out0']==w0 and vals['out1']==w1
        stale_count += (vals['out0']*vals['b01']+y*vals['b11'] != w1)
        sign_count += (x*vals['b01']-y*vals['b11'] != w1)
    assert stale_count>0 and sign_count>0
    assert nearest(1/2)==0 and nearest(-1/2)==0
    assert nearest(3/2)==2 and nearest(-3/2)==-2
    result={'pass':True,'terminal':terminal,'rint_cases':len(rs),
            'suffix_complex_slots_both_vectors':768,'stale_operand_detected_slots':int(stale_count),
            'wrong_sign_detected_slots':int(sign_count),'noop':True,
            'required_domain_counterexample':False,'source_bound_proved':False,
            'meaning':'Nonzero old-target update defect absent from the innovation-frame residual list; local fixture only.'}
    (OUT/'C_SLICES_CHECK.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
    print('C_SLICES_CHECK_PASS; local update-add defect = +/- 1/33554432; not a required-domain witness')
