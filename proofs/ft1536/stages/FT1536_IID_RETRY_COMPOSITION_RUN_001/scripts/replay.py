"""Usage: replay.py ABSENT_DEST EXTERNAL_SHA [--manifest ANCHOR].
Validate the entire immutable manifest before destination creation, seed only
proof/input sources, hide original project trees, rebuild and compare outputs.
"""
import argparse,json,os,resource,shutil,signal,subprocess,sys,time
from pathlib import Path
from replaylib import member,sha,verify_manifest
from scope import ANCHOR,members,seed_file
S=Path(__file__).absolute().parents[1];REPO=Path('/home/footfalcon/free_falcon_sign')
a=argparse.ArgumentParser();a.add_argument('destination');a.add_argument('external_sha');a.add_argument('--manifest',default='OUTPUTS.sha256',choices=['OUTPUTS.sha256',ANCHOR]);a=a.parse_args()
D=Path(a.destination);assert D.is_absolute() and not D.exists() and not D.is_symlink() and D.parent.is_dir()
assert S==S.resolve() and D.parent==D.parent.resolve()
assert any(D.is_relative_to(REPO/'proofs/ft1536'/r) for r in ['work','replay-work'])
rows=verify_manifest(S,a.manifest,a.external_sha);assert set(rows)==set(members(S,anchor=a.manifest==ANCHOR))
expected=json.loads(member(S,'SEMANTIC_FILES.json').read_text());assert expected['count']==len(expected['files'])>0
assert len({r['path'] for r in expected['files']})==expected['count']
for r in expected['files']:assert rows[r['path']]==r['sha256']
assert shutil.disk_usage(D.parent).free>2*1024**3
D.mkdir();started=time.monotonic();out=dict(status='FRESH_REPLAY_STARTED',game='G_retry_IID',region='post-H2P3327-3421 cap16 and STATIC codec',event='WholeRegionBad, BOTH pre-narrow vectors in every reached/completed attempt',scope='mixed universal source/analytical/kernel, not real PRNG/H2P prefix/whole real Sign',external_manifest=a.manifest,external_manifest_sha256=a.external_sha,package=str(S),destination=str(D),expected_files=expected['count'],matches=[])
try:
 seeds=[]
 for r,h in rows.items():
  if not seed_file(r):continue
  p=D/r;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(member(S,r),p);assert sha(p)==h;seeds.append(r)
 assert not any(p.suffix in ['.olean','.ilean'] for p in D.rglob('*'))
 assert not (D/'bin').exists() and not (D/'cache').exists()
 for r in ['bin','cache/home','cache/sage','cache/mpl','cache/ipython','tmp','runtime','logs','artifacts/diffs']:(D/r).mkdir(parents=True,exist_ok=True)
 (D/'artifacts/replay_seed.json').write_text(json.dumps(dict(sources=seeds,project_cache_seeded=False,derived_outputs_seeded=False),indent=2)+'\n')
 # Durable empty skeleton allows the fresh nested DEST mount while hiding
 # all original worktrees. No project bytes are kept on tmpfs.
 work=REPO/'proofs/ft1536/work';marker=D/'cache/hidden_work';marker.mkdir()
 if D.is_relative_to(work):(marker/D.relative_to(work)).mkdir(parents=True)
 empty=D/'cache/hidden_empty';empty.mkdir()
 env=dict(os.environ);env.update(HOME=str(D/'cache/home'),TMPDIR=str(D/'tmp'),TMP=str(D/'tmp'),TEMP=str(D/'tmp'),XDG_CACHE_HOME=str(D/'cache'),DOT_SAGE=str(D/'cache/sage'),MPLCONFIGDIR=str(D/'cache/mpl'),IPYTHONDIR=str(D/'cache/ipython'),PYTHONDONTWRITEBYTECODE='1',PYTHONOPTIMIZE='0',LEAN_PATH=str(D/'formal'),GIT_OPTIONAL_LOCKS='0',FT1536_REPLAY_ORIGINAL=str(S))
 box=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--unshare-pid','--ro-bind','/','/','--ro-bind',str(marker),str(work)]
 for r in ['proofs/ft1536/stages','proofs/ft1536/background','Extra']:
  if (REPO/r).is_dir():box+=['--ro-bind',str(empty),str(REPO/r)]
 box+=['--bind',str(D),str(D),'--ro-bind',str(D/'source'),str(D/'source'),'--ro-bind',str(D/'inputs/bootstrap'),str(D/'inputs/bootstrap'),'--proc','/proc','--dev','/dev','--chdir',str(D),'--',sys.executable,'-B','scripts/recipe.py']
 def bounds():
  resource.setrlimit(resource.RLIMIT_CORE,(0,0));resource.setrlimit(resource.RLIMIT_NOFILE,(256,256));resource.setrlimit(resource.RLIMIT_CPU,(240,241))
 p=subprocess.Popen(box,cwd=D,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True,preexec_fn=bounds)
 try:o,e=p.communicate(timeout=1800)
 except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate();out['controller_timeout']=True
 (D/'logs/replay_controller.stdout').write_bytes(o);(D/'logs/replay_controller.stderr').write_bytes(e);out.update(controller_argv=box,controller_exit_code=p.returncode,elapsed_seconds=time.monotonic()-started)
 assert p.returncode==0 and not out.get('controller_timeout'),('recipe failed',p.returncode)
 regenerated=json.loads((D/'SEMANTIC_FILES.json').read_text());assert regenerated==expected
 for r in expected['files']:
  assert sha(member(D,r['path']))==r['sha256'],r['path'];out['matches'].append(r)
 # Confirm the immutable package remained byte-for-byte the same.
 assert verify_manifest(S,a.manifest,a.external_sha)==rows
 out.update(status='FRESH_REPLAY_PASS',matched=len(out['matches']),fresh_project_cache=True,original_trees_hidden=True,only_destination_written=True,source_inputs_readonly=True,network_off=True)
except BaseException as e:
 out.update(status='FRESH_REPLAY_FAIL',error=repr(e),elapsed_seconds=time.monotonic()-started)
 (D/'REPLAY_RESULT.json').write_text(json.dumps(out,indent=2)+'\n');raise
(D/'REPLAY_RESULT.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:out[k] for k in ['status','matched','expected_files','game','region','destination','elapsed_seconds']},indent=2))
