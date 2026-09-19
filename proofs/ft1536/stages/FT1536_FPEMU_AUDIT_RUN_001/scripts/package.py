"""Packaging only, no numerical jobs: pre-freeze anchor, receipt import, freeze."""
import json
from pathlib import Path
import shutil
import sys
from common import W, sha, dump

def files(root):
    pp=sorted(root.rglob('*'))
    assert not any(p.is_symlink() for p in pp)
    return [p for p in pp if p.is_file()]

def manifest(paths,dest):
    assert not dest.exists()
    rows=sorted(set(paths))
    assert all(p.is_relative_to(W) and not p.is_symlink() for p in rows)
    dest.write_text(''.join(sha(p)+'  '+str(p.relative_to(W))+'\n' for p in rows))
    return dict(path=str(dest.relative_to(W)),members=len(rows),sha256=sha(dest))

mode=sys.argv[1]
if mode=='anchor':
    # Absolute provenance names remain historical; sealed copies permit relocation.
    inputs=files(W/'inputs')
    (W/'INPUTS.sha256').write_text(''.join(sha(p)+'  '+str(p)+'\n' for p in inputs))
    semantic=json.loads((W/'SEMANTIC_FILES.json').read_text())
    seed=inputs+files(W/'scripts')+files(W/'checks')+[W/'SEMANTIC_FILES.json',W/'INPUTS.sha256']
    result=manifest(seed+[W/p for p in semantic],W/'artifacts/rehearsal_anchor.sha256')
    print(json.dumps(result,indent=2))
elif mode=='receive':
    src=Path(sys.argv[2]).resolve()
    assert src.is_relative_to(W/'tmp')
    rr=json.loads((src/'REPLAY_RESULT.json').read_text())
    assert rr['status']=='FRESH_REPLAY_PASS' and rr['mode']=='pre-freeze rehearsal'
    assert rr['expected_outputs_sha256']==sha(W/'artifacts/rehearsal_anchor.sha256')
    for row in rr['matches']:
        assert sha(W/row['path'])==row['sha256']
    (W/'artifacts/fresh_replay.json').write_bytes((src/'REPLAY_RESULT.json').read_bytes())
    dst=W/'logs/rehearsal'
    assert not dst.exists()
    shutil.copytree(src/'logs',dst)
    (dst/'COMMANDS.log').write_bytes((src/'COMMANDS.log').read_bytes())
    (dst/'asan_build.json').write_bytes((src/'artifacts/asan_build.json').read_bytes())
    print('PASS: pre-freeze receipt and full rehearsal logs captured')
elif mode=='freeze':
    assert not (W/'OUTPUTS.sha256').exists()
    rr=json.loads((W/'artifacts/fresh_replay.json').read_text())
    assert rr['status']=='FRESH_REPLAY_PASS'
    for row in rr['matches']: assert sha(W/row['path'])==row['sha256']
    for line in (W/'INPUTS.sha256').read_text().splitlines():
        h,p=line.split('  ',1);assert sha(Path(p))==h
    result=json.loads((W/'RESULT.json').read_text())
    assert result['source_changed'] is False and result['status']=='CONFIRMED_ISSUE'
    (W/'artifacts/COMMANDS.frozen.log').write_bytes((W/'COMMANDS.log').read_bytes())
    top=['AGENTS.md','PREPARATION.md','REPORT.md','RESULT.json','AUDIT_MATRIX.json','AUDIT_MATRIX.md',
         'FINDINGS.json','IMPACT_MATRIX.md','TIMING_REVIEW.md','REPLAY.md','TOOLCHAIN.txt',
         'INPUTS.sha256','COMMANDS.log','OUTPUT_SCOPE.md','EXECUTION_NOTES.md','SEMANTIC_FILES.json']
    dump('artifacts/freeze_scope.json',dict(argv=sys.argv,cwd=str(W),report_sha256=sha(W/'REPORT.md'),
        semantic_files=len(rr['matches']),rehearsal_anchor_sha256=rr['expected_outputs_sha256'],
        method='Exact listed top-level files plus regular inputs/scripts/checks/logs/artifacts. No tmp/cache/bin/formal output.'))
    allpaths=[W/p for p in top]
    for root in ('inputs','scripts','checks','logs','artifacts'):allpaths+=files(W/root)
    result=manifest(allpaths,W/'OUTPUTS.sha256')
    result['report_sha256']=sha(W/'REPORT.md')
    print(json.dumps(result,indent=2))
else: raise ValueError(mode)
