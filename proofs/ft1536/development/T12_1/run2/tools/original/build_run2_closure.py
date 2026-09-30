#!/usr/bin/env python3
# Budowa closure modulow Run2/FT1536 (zrodla RO z W RUN_002) do lokalnego
# check_lib W CENTERING_CLOSURE. Kolejnosc topologiczna po importach.
import re, subprocess, sys, os, time
from pathlib import Path

# Zrodla Run2: lokalna kopia przypieta w run2_src.SHA256SUMS (constraint
# roota Lean: pliki musza byc pod katalogiem W). FT1536.*: oleany w
# check_lib zbudowane z bajtowo identycznych zrodel (hash-zgodnosc 28/28).
FORMAL = Path(__file__).resolve().parents[2] / 'formal'
W = Path(__file__).resolve().parents[2]
LIB = W / '.build/check_lib'
LOGS = W / '.build/logs/run2_closure'
LOGS.mkdir(parents=True, exist_ok=True)
LEAN = '/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
B20 = Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/B20_001/P01')
upstream = [B20 / 'bootstrap/mathlib4/.lake/build/lib/lean']
for p in 'plausible importGraph LeanSearchClient batteries aesop proofwidgets Qq'.split():
    upstream.append(B20 / f'run/.lake/packages/{p}/.lake/build/lib/lean')
upstream.append(Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/lib/lean'))
LEAN_PATH = ':'.join([str(LIB)] + [str(u) for u in upstream])

TARGETS = [
    'Run2.ChangedTailReduction', 'Run2.RadialObligations', 'Run2.RawRadialEnclosure',
    'Run2.RadialBinningSandwich', 'Run2.LegalKeyErrorTransfer', 'Run2.GuaranteedDigits',
    'Run2.NormalizerComparison', 'Run2.RejectionNumericMargin', 'Run2.PackedConvolution',
    'Run2.RadialWindowSplit', 'Run2.RadialSymmetry', 'Run2.RadialTriangleSplit',
    'Run2.RawRadialEvents', 'Run2.RawProductLaw', 'Run2.RawIndependence',
]

def mod_of(p):
    return '.'.join(p.relative_to(FORMAL).with_suffix('').parts)

srcs = {mod_of(p): p for p in FORMAL.rglob('*.lean')}
PREBUILT = {m for m in srcs if m.startswith('FT1536.') and
            (LIB / (m.replace('.', '/') + '.olean')).exists()}
imps = {}
for m, p in srcs.items():
    imps[m] = [l.split()[1] for l in p.read_text().splitlines()
               if l.startswith('import ')]

# domkniecie tranzytywne po lokalnych modulach
seen, order = set(), []
def visit(m):
    if m in seen:
        return
    seen.add(m)
    for i in imps.get(m, []):
        if i in srcs:
            visit(i)
    order.append(m)
for t in TARGETS:
    if t not in srcs:
        print(f'BRAK ZRODLA {t}', flush=True)
        sys.exit(1)
    visit(t)

print(f'modulow do zbudowania: {len(order)}', flush=True)
env = dict(os.environ, LEAN_PATH=LEAN_PATH, HOME=str(W / 'run/home'),
           TMPDIR=str(W / 'run/tmp'))
t_all = time.time()
for m in order:
    out = LIB / (m.replace('.', '/') + '.olean')
    if out.exists() and out.stat().st_mtime > srcs[m].stat().st_mtime:
        print(f'{m}: cached', flush=True)
        continue
    out.parent.mkdir(parents=True, exist_ok=True)
    log = LOGS / (m.replace('.', '_') + '.log')
    t0 = time.time()
    with open(log, 'w') as fh:
        r = subprocess.run([LEAN, '-o', str(out), str(srcs[m])],
                           stdout=fh, stderr=subprocess.STDOUT, env=env,
                           timeout=3600)
    dt = int(time.time() - t0)
    txt = log.read_text()
    err = len(re.findall(r'error', txt))
    wrn = len(re.findall(r'warning', txt))
    print(f'{m}: exit={r.returncode} err={err} warn={wrn} {dt}s', flush=True)
    if r.returncode != 0:
        print(f'FAIL {m} — patrz {log}', flush=True)
        sys.exit(2)
print(f'OK wszystkie {len(order)} modulow, lacznie {int(time.time()-t_all)}s', flush=True)
