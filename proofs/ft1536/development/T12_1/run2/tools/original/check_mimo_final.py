import hashlib,json,difflib
from pathlib import Path
W=Path(__file__).resolve().parent.parent
S=Path('/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/output')
OLD=W/'run/GAME_BINDING_REVIEW_001/source_snapshot_6f0d4f42'
D=W/'run/GAME_BINDING_REVIEW_002';D.mkdir(exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
pins={'OUTPUTS.sha256':'cc01337d093029458d07946088066b1ffeae93ac59a0896b8e26968d8c215269',
    'REPORT.md':'e593d91ed0e827bd240a145a31d2767407c4ea55eafd34e9a07252b49cd10d7c',
    'REPLAY_SEED.sha256':'375e14a322808d81309c0ba123839854325e7580044534ed1e2f1ea0b1f0b630'}
for n,h in pins.items():assert sha(S/n)==h,n
def members(base):
    r={}
    for line in (base/'OUTPUTS.sha256').read_text().splitlines():
        h,n=line.split(maxsplit=1)
        assert n not in r and not Path(n).is_absolute() and '..' not in Path(n).parts
        p=base/n;assert p.is_file() and not p.is_symlink() and sha(p)==h,n
        r[n]=h
    return r
new=members(S);old=members(OLD)
changed=[n for n in new if n in old and new[n]!=old[n]]
added=[n for n in new if n not in old];removed=[n for n in old if n not in new]
diffs=[]
for n in changed:
    if n.endswith('.lean'):
        diff=''.join(difflib.unified_diff((OLD/n).read_text().splitlines(True),(S/n).read_text().splitlines(True),
            fromfile='snapshot_6f0d4f42/'+n,tofile='snapshot_cc01337d/'+n))
        (D/(Path(n).stem+'.diff')).write_text(diff);diffs.append(n)
replay=json.loads((S/'replay/REPLAY_RESULT.json').read_text())
jobs=replay.get('receipts',[]);build=json.loads((S/'BUILD.json').read_text())
result=dict(status='PRIMARY_INTEGRITY_PASS',pins=pins,members=len(new),changed=changed,added=added,removed=removed,
    changed_lean=diffs,author_recorded_jobs=len(jobs),build_expected_jobs=3+len(build['modules']),
    author_exports=replay.get('exports_audited'),author_job_names=[j['name'] for j in jobs],
    author_stderr_hashes_match=all(sha(S/'replay'/j[k])==j[k+'_sha256'] for j in jobs for k in ['stdout','stderr']),
    note='Original untouched; same REPORT pin retained by author; fresh independent replay follows.')
(D/'INTAKE_AND_DIFF.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
