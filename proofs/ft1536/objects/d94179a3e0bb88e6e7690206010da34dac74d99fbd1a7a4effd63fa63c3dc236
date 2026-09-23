"""External pin + full manifest BEFORE absent DEST. Fresh isolated bounded jobs."""
import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import sha,verify_manifest,member
W=Path(__file__).resolve().parents[1];D=Path(sys.argv[1]);pin=sys.argv[2];anchor=len(sys.argv)==4 and sys.argv[3]=='--anchor';assert len(sys.argv)==3 or anchor
assert D.is_absolute() and not D.exists() and not D.is_symlink()
assert D.parent.is_dir() and D.parent.resolve().is_relative_to((W/'tmp').resolve())
manifest='artifacts/rehearsal_anchor.sha256' if anchor else 'OUTPUTS.sha256'
rows=verify_manifest(W,manifest,pin)
if not anchor:
 from scope import members
 assert set(rows)==set(members(W)),'OUTPUTS is not exact declared scope'
expected=json.loads(member(W,'SEMANTIC_FILES.json').read_text());assert 'SEMANTIC_FILES.json' in rows and sha(W/'SEMANTIC_FILES.json')==rows['SEMANTIC_FILES.json']
for r in expected['files']:assert rows[r['path']]==r['sha256']
D.mkdir()
for r in rows:
 dst=D/r;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(W/r,dst);assert sha(dst)==rows[r]
for r in ['tmp','bin','cache','logs','artifacts']:(D/r).mkdir(exist_ok=True)
prefix='artifacts/COMMANDS.final_prefix.log' if 'artifacts/COMMANDS.final_prefix.log' in rows else 'artifacts/COMMANDS.frozen.log'
shutil.copyfile(D/prefix,D/'COMMANDS.log')
# No project cache or compiled object is copied; erase all generated semantic evidence.
for r in expected['files']:(D/r['path']).unlink()
if (D/'artifacts/kernel.jsonl').exists():(D/'artifacts/kernel.jsonl').unlink()
assert not list((D/'formal').rglob('*.olean')) and not list((D/'bin').iterdir())
original_inputs=json.loads((D/'inputs/provenance.json').read_text())
for r in original_inputs:assert sha(member(D,r['copy']))==r['sha256']
verify_manifest(D/'inputs/bootstrap','MANIFEST.sha256','ae0b43d2c9ce7b88e63e2d81be97e04dcbd45bbab827cf63f9339828df147cff')
jobs=[(60,['python3','-B','scripts/toolchain.py'],False)]
jobs += [(240,['python3','-B','scripts/kernel_build.py',str(k)],False) for k in range(5)]
jobs += [(180,['/home/footfalcon/.local/bin/sage','scripts/numeric_certificate.py'],False),(30,['python3','-B','scripts/source_binding.py'],False),(120,['python3','-B','scripts/build.py','normal'],False),(120,['python3','-B','scripts/build.py','sanitized'],False),(240,['python3','-B','scripts/fixtures.py'],False)]
jobs += [(180,['python3','-B','scripts/native_controls.py',mode,str(k)],mode=='sanitized') for mode in ['normal','sanitized'] for k in range(5)]
jobs += [(240,['/home/footfalcon/.local/bin/sage','scripts/inverse_oracle.py'],False),(180,['python3','-B','scripts/mutations.py'],False),(180,['python3','-B','scripts/audit.py'],False),(60,['python3','-B','scripts/metadata.py'],False)]
receipts=[]
for k,(limit,cmd,asan) in enumerate(jobs):
 env=dict(os.environ);env['FT1536_ASAN']='1' if asan else '0';argv=[sys.executable,'-B','scripts/run.py',str(limit)]+cmd;t=time.monotonic()
 p=subprocess.run(argv,cwd=D,env=env,capture_output=True,timeout=limit+15)
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(D/'logs'/('replay_job_'+str(k)+'.'+s)).write_bytes(b)
 receipts.append(dict(index=k,argv=argv,asan=asan,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(D/'logs'/('replay_job_'+str(k)+'.stdout')),stderr_sha256=sha(D/'logs'/('replay_job_'+str(k)+'.stderr'))));(D/'REPLAY_COMMANDS.json').write_text(json.dumps(receipts,indent=2)+'\n')
 print('REPLAY_JOB',k,cmd[-2:],p.returncode,flush=True)
 if p.returncode:
  (D/'REPLAY_RESULT.json').write_text(json.dumps(dict(status='FAIL_JOB',index=k,exit_code=p.returncode),indent=2)+'\n');raise SystemExit(p.returncode)
matches=[];bad=[]
for r in expected['files']:
 actual=sha(member(D,r['path']));row=dict(path=r['path'],expected=r['sha256'],actual=actual,match=actual==r['sha256']);matches.append(row)
 if not row['match']:bad.append(row)
result=dict(status='PASS_FRESH_REPLAY' if not bad else 'FAIL_SEMANTIC_MATCH',external_manifest_sha256=pin,manifest=manifest,source_members_verified=len(rows),fresh_without_project_cache=True,regenerated_expected_files=len(matches),matched=sum(r['match'] for r in matches),all_matches=not bad,matches=matches,source_scope_unchanged=all(sha(member(W,r))==h for r,h in rows.items()),historical_status='PARTIAL_PROOF',operational_subclaim='H3_SOURCE_POSTPROCESSING_DEFINED_FOR_EMITTED_PINNED_MODEL',owner_accepted=False)
(D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='matches'},indent=2));assert not bad and result['source_scope_unchanged'],bad
