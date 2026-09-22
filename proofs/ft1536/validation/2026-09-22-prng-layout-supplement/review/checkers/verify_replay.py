"""Independent byte comparison of the 17 semantic files: DEST vs my copy vs SOURCE_W."""
import hashlib, json, pathlib, sys
W = pathlib.Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001')
DEST = W/'replay/INDEPENDENT_001'
COPY = W/'seed/pkg_003'
SOURCE = pathlib.Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003')
def sha(p): return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
expected = json.loads((COPY/'SEMANTIC_FILES.json').read_text())
dest_sem = json.loads((DEST/'SEMANTIC_FILES.json').read_text())
rows, bad = [], 0
for r in expected['files']:
    p = r['path']; h = r['sha256']
    hd, hc, hs = sha(DEST/p), sha(COPY/p), sha(SOURCE/p)
    ok = (hd == hc == hs == h)
    if not ok: bad += 1
    rows.append(dict(path=p, pin=h, dest=hd, copy=hc, source=hs, equal=ok))
out = dict(
    schema='FT1536_REVIEW_REPLAY_CHECKS_V1',
    review_id='FT1536_PRNG_LAYOUT_COUNTER_SUPPLEMENT_REVIEW_001',
    expected_count=expected['count'],
    dest_semantic_json_identical=(dest_sem == expected),
    equal_three_way=sum(1 for r in rows if r['equal']),
    mismatches=[r for r in rows if not r['equal']],
    rows=rows)
(W/'checkers/REPLAY_CHECKS.json').write_text(json.dumps(out, indent=1) + '\n')
print('expected', expected['count'], 'three-way equal', out['equal_three_way'], 'bad', bad)
print('dest SEMANTIC_FILES.json identical to expected:', out['dest_semantic_json_identical'])
sys.exit(1 if bad else 0)
