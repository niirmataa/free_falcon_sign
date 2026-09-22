"""Usage: replay.py ABSENT_DEST EXTERNAL_SHA [--manifest OUTPUTS.sha256|ANCHOR].

Validate the entire immutable manifest before destination creation, seed only
proof/input sources, hide the original project trees, rebuild inside a
network-off bwrap sandbox with a fresh build/cache, and compare the regenerated
semantic files byte for byte.  A receipt is written inside the destination
(REPLAY_RESULT.json) and, while the author W is still unfrozen, also as
artifacts/fresh_replay.json in the author W.
"""
import argparse,json,os,resource,shutil,signal,subprocess,time
from pathlib import Path
from replaylib import member,sha,verify_manifest
from scope import ANCHOR,members,seed_file
S=Path(__file__).absolute().parents[1]
REPO=Path('/home/footfalcon/free_falcon_sign')
a=argparse.ArgumentParser()
a.add_argument('destination');a.add_argument('external_sha')
a.add_argument('--manifest',default='OUTPUTS.sha256',choices=['OUTPUTS.sha256',ANCHOR])
a=a.parse_args()
D=Path(a.destination)
assert D.is_absolute() and not D.exists() and not D.is_symlink() and D.parent.is_dir()
assert S==S.resolve() and D.parent==D.parent.resolve()
assert any(D.is_relative_to(REPO/'proofs/ft1536'/r) for r in ['work','replay-work'])
rows=verify_manifest(S,a.manifest,a.external_sha)
assert set(rows)==set(members(S,anchor=a.manifest==ANCHOR)),'member set vs manifest'
expected=json.loads(member(S,'SEMANTIC_FILES.json').read_text())
assert expected['count']==len(expected['files'])>0
assert len({r['path'] for r in expected['files']})==expected['count']
for r in expected['files']:
    assert rows[r['path']]==r['sha256'],r['path']
assert shutil.disk_usage(D.parent).free>2*1024**3
D.mkdir();started=time.monotonic()
out=dict(status='FRESH_REPLAY_STARTED',task_id='FT1536_PRNG_LAYOUT_COUNTER_RUN_001',
    event='T02.1 A+B+C pinned-source-model layout/block/counter contract',
    scope='deterministic source contract; not SHAKE/ChaCha security, not the real->IID hop',
    external_manifest=a.manifest,external_manifest_sha256=a.external_sha,
    package=str(S),destination=str(D),expected_files=expected['count'],matches=[],mismatches=[])
frozen=(S/'OUTPUTS.sha256').exists()
def write_receipts():
    (D/'REPLAY_RESULT.json').write_text(json.dumps(out,indent=2)+'\n')
    if not frozen:
        (S/'artifacts/fresh_replay.json').write_text(json.dumps(out,indent=2)+'\n')
        (S/'receipts/REPLAY_RESULT.json').write_text(json.dumps(out,indent=2)+'\n')
try:
    seeds=[]
    for r,h in rows.items():
        if not seed_file(r):continue
        p=D/r;p.parent.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(member(S,r),p);assert sha(p)==h;seeds.append(r)
    assert not any(p.suffix in ['.olean','.ilean'] for p in D.rglob('*'))
    assert not (D/'bin').exists() and not (D/'cache').exists()
    for r in ['bin','cache/home','cache/tmp','cache/sage','tmp','logs','artifacts','receipts']:
        (D/r).mkdir(parents=True,exist_ok=True)
    (D/'artifacts/replay_seed.json').write_text(json.dumps(dict(
        sources=seeds,project_cache_seeded=False,derived_outputs_seeded=False),indent=2)+'\n')
    work=REPO/'proofs/ft1536/work';replay=REPO/'proofs/ft1536/replay-work'
    marker=D/'cache/hidden_work';marker.mkdir()
    for base in (work,replay):
        if D.is_relative_to(base):(marker/D.relative_to(base)).mkdir(parents=True,exist_ok=True)
    empty=D/'cache/hidden_empty';empty.mkdir()
    env=dict(os.environ)
    env.update(HOME=str(D/'cache/home'),TMPDIR=str(D/'tmp'),TMP=str(D/'tmp'),TEMP=str(D/'tmp'),
        XDG_CACHE_HOME=str(D/'cache'),DOT_SAGE=str(D/'cache/sage'),PYTHONDONTWRITEBYTECODE='1',
        GIT_OPTIONAL_LOCKS='0',FT1536_REPLAY_ORIGINAL=str(S))
    box=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--unshare-pid','--ro-bind','/','/']
    for base in (work,replay):
        if base.exists():box+=['--ro-bind',str(marker),str(base)]
    for r in ['proofs/ft1536/stages','proofs/ft1536/background','proofs/ft1536/documents',
              'proofs/ft1536/objects','proofs/ft1536/validation','proofs/ft1536/catalog',
              'proofs/ft1536/history','Extra']:
        if (REPO/r).is_dir():box+=['--ro-bind',str(empty),str(REPO/r)]
    box+=['--bind',str(D),str(D),'--ro-bind',str(D/'source'),str(D/'source'),
          '--ro-bind',str(D/'inputs'),str(D/'inputs'),
          '--proc','/proc','--dev','/dev','--chdir',str(D),
          '--','python3','-B','scripts/recipe.py']
    def bounds():
        resource.setrlimit(resource.RLIMIT_CORE,(0,0))
        resource.setrlimit(resource.RLIMIT_NOFILE,(512,512))
        resource.setrlimit(resource.RLIMIT_CPU,(2400,2401))
    p=subprocess.Popen(box,cwd=str(D),env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,
        start_new_session=True,preexec_fn=bounds)
    try:
        o,e=p.communicate(timeout=3000)
    except subprocess.TimeoutExpired:
        os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate();out['controller_timeout']=True
    (D/'logs/replay_controller.stdout').write_bytes(o)
    (D/'logs/replay_controller.stderr').write_bytes(e)
    out.update(controller_argv=box,controller_exit_code=p.returncode,
        elapsed_seconds=time.monotonic()-started)
    assert p.returncode==0 and not out.get('controller_timeout'),('recipe failed',p.returncode,e[-2000:])
    regenerated=json.loads((D/'SEMANTIC_FILES.json').read_text())
    assert regenerated==expected,'regenerated SEMANTIC_FILES.json differs'
    for r in expected['files']:
        assert sha(member(D,r['path']))==r['sha256'],r['path']
        out['matches'].append(r)
    assert verify_manifest(S,a.manifest,a.external_sha)==rows,'sealed package changed during replay'
    out.update(status='FRESH_REPLAY_PASS',matched=len(out['matches']),
        fresh_project_cache=True,original_trees_hidden=True,only_destination_written=True,
        source_inputs_readonly=True,network_off=True)
except BaseException as e:
    out.update(status='FRESH_REPLAY_FAIL',error=repr(e),
        elapsed_seconds=time.monotonic()-started)
    write_receipts();raise
write_receipts()
print(json.dumps({k:out[k] for k in ['status','matched','expected_files','destination','elapsed_seconds']},indent=2))
