"""Run with Sage 10.9: independent QQ decimal conversion and Arb/RBF enclosures."""
import re
import sys
from pathlib import Path
sys.path.insert(0, str(Path.cwd()/'scripts'))
from sage.all import QQ, RealBallField
from common import W, S, dump
from oracle import Q, rn, value, p2

R=RealBallField(256)
def ball(q):
    q=Q(q)
    return R(QQ(q.numerator)/QQ(q.denominator))
def tables(text):
    return {n:b for n,b in re.findall(r'static const fpr (fpr_gm\w+)\[\] = \{(.*?)\};',text,re.S)}
def rev(i,n):
    return int(f'{i:0{n}b}'[::-1],2) if n else 0

emu=tables((S/'fpr-emulated.h').read_text())
ref=tables((S/'fpr-double.h').read_text())
assert set(emu)==set(ref)=={'fpr_gm_tab','fpr_gm3_square','fpr_gm3_cubic'}
counts={}; words={}
for name,text in emu.items():
    ws=[(int(a,16),int(b,16)) for a,b in re.findall(r'FPC\(0x([0-9a-f]+)ULL, 0x([0-9a-f]+)ULL\)',text)]
    decimals=re.findall(r'FPC\(\{\s*([^}]+)\},\s*\{\s*([^}]+)\}\)',ref[name])
    assert len(ws)==len(decimals) and len(ws)>0
    for pair,ds in zip(ws,decimals):
        for w,d in zip(pair,ds):
            q=Q(d.strip()); assert w==rn(q,q==0 and d.strip().startswith('-'))
    words[name]=ws;counts[name]=len(ws)*2

twiddles=[]
for name,den in [('fpr_gm3_square',6),('fpr_gm3_cubic',9)]:
    # All half-blocks used by FFT3 for logn<=10/full-profile and recursive sizes.
    for k in range(1,10):
        m=1<<k
        for j in range(m//2):
            theta=R.pi()*2*(1+6*rev(j,k-1))/(den*m)
            wr,wi=words[name][m+j]
            err=max((ball(value(wr))-theta.cos()).abs().upper(),
                    (ball(value(wi))-theta.sin()).abs().upper())
            assert err < QQ(2)**-50
            twiddles.append((name,m+j))
# Fixed FFT3 constants and inverse imaginary unit are checked independently.
ct=dict((n,int(w,16)) for n,w in re.findall(r'static const fpr (\w+) = 0x([0-9a-f]+)ULL;',
                                            (S/'fpr-emulated.h').read_text()))
targets={'fpr_W1R':R(1)/2,'fpr_W1I':R(3).sqrt()/2,'fpr_W2R':-R(1)/2,
         'fpr_W2I':R(3).sqrt()/2,'fpr_W4R':-R(1)/2,'fpr_W4I':-R(3).sqrt()/2,
         'fpr_W5R':R(1)/2,'fpr_W5I':-R(3).sqrt()/2,'fpr_IW1I':2/R(3).sqrt(),
         'fpr_log2':R(2).log(),'fpr_inv_ln2':1/R(2).log()}
for name,target in targets.items():
    assert (ball(value(ct[name]))-target).abs().upper() < QQ(2)**-50

maxima={}; numbers={}; failures=[]
corpus=(W/'artifacts/corpus.tsv').read_text().splitlines()
out=(W/'artifacts/normal_scalar.stdout').read_text().splitlines()
for line,result in zip(corpus,out):
    op,xx,_,_=line.split();x=int(xx,16);r,z=(int(t,16) for t in result.split())
    if op not in ('expm','exp_small','log','sincos'):continue
    if op=='expm':
        err=(R(r)-(-ball(value(x))).exp()*R(2)**63).abs()
        limit=QQ(2)**14  # exploratory sampled majorant, not a whole-domain proof
    elif op=='exp_small':
        exact=ball(value(x)).exp()
        err=(ball(value(r))/exact-1).abs();limit=QQ(2)**-50
    elif op=='log':
        err=(ball(value(r))-ball(value(x)).log()).abs();limit=QQ(2)**-45
    else:
        theta=2*R.pi()*(x+1)/R(2)**32
        err=(ball(value(r))-theta.cos()).abs()+(ball(value(z))-theta.sin()).abs()
        limit=QQ(2)**-45
    ok=err.upper()<limit
    if not ok: failures.append(dict(op=op,input=f'{x:016x}',output=f'{r:016x}',error=str(err)))
    numbers[op]=numbers.get(op,0)+1
    maxima[op]=max(maxima.get(op,R(0).upper()),err.upper())

assert 13*p2(-24)+p2(-1021)<p2(-20)
assert 13*p2(-55)<p2(-48)
assert p2(-922)<p2(-900) and p2(-1018)<p2(-900)
dump('artifacts/rigorous.json',dict(status='PASS' if not failures else 'ISSUE',precision_bits=256,
    decimal_reference_word_counts=counts,independent_trigonometric_pairs=len(twiddles),
    fixed_constant_checks=len(targets),twiddle_abs_error_bound='2^-50',
    sampled_transcendental_counts=numbers,max_error_upper={k:str(v) for k,v in maxima.items()},
    failures=failures,primitive_majorant_inequalities=4,
    caveat='decimal reference is provenance only; RBF trigonometry is independent. Expm sampling is not the referenced whole-domain proof.'))
print('QQ/RBF256:',counts,'trigonometric pairs',len(twiddles),'transcendental',numbers,'failures',len(failures))
assert not failures
