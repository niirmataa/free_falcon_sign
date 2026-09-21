"""IID_KERNEL fresh replay; external manifest verified before absent DEST."""
import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import sha,verify_manifest,member
W=Path(__file__).resolve().parents[1];D=Path(sys.argv[1]);pin=sys.argv[2];anchor=len(sys.argv)==4 and sys.argv[3]=='--anchor';assert len(sys.argv)==3 or anchor
assert D.is_absolute() and not D.exists() and not D.is_symlink() and D.parent.is_dir() and D.parent.resolve().is_relative_to((W/'tmp').resolve())
manifest='artifacts/rehearsal_anchor.sha256' if anchor else 'OUTPUTS.sha256';rows=verify_manifest(W,manifest,pin)
if not anchor:
 from scope import members
 assert set(rows)==set(members(W)),'OUTPUTS scope mismatch'
expected=json.loads(member(W,'SEMANTIC_FILES.json').read_text());assert sha(W/'SEMANTIC_FILES.json')==rows['SEMANTIC_FILES.json']
for r in expected['files']:assert rows[r['path']]==r['sha256']
D.mkdir()
for r,h in rows.items():
 dst=D/r;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(W/r,dst);assert sha(dst)==h
for r in ['tmp','bin','cache','logs','artifacts']:(D/r).mkdir(exist_ok=True)
prefix='artifacts/COMMANDS.final_prefix.log' if 'artifacts/COMMANDS.final_prefix.log' in rows else 'artifacts/COMMANDS.frozen.log';shutil.copyfile(D/prefix,D/'COMMANDS.log')
for r in expected['files']:(D/r['path']).unlink()
if (D/'artifacts/kernel.jsonl').exists():(D/'artifacts/kernel.jsonl').unlink()
assert not list((D/'formal').rglob('*.olean')) and not list((D/'bin').iterdir())
for r in json.loads((D/'inputs/provenance.json').read_text()):assert sha(member(D,r['copy']))==r['sha256']
verify_manifest(D/'inputs/bootstrap','MANIFEST.sha256','eb890ea42dad55d397ebd6f71fad5457676d705e5443a5a672201a0ce6e553a8')
jobs=[(60,['python3','-B','scripts/toolchain.py'],False)]+[(240,['python3','-B','scripts/kernel_build.py',str(k)],False) for k in range(2)]
jobs += [(60,['python3','-B','scripts/kernel_certificate.py'],False),(30,['python3','-B','scripts/source_binding.py'],False),(120,['python3','-B','scripts/build.py','normal'],False),(120,['python3','-B','scripts/build.py','sanitized'],False),(240,['python3','-B','scripts/fixtures.py'],False)]
jobs += [(240,['python3','-B','scripts/native_controls.py',m,str(k)],m=='sanitized') for m in ['normal','sanitized'] for k in range(4)]
jobs += [(180,['/home/footfalcon/.local/bin/sage','scripts/rational_oracle.py'],False),(60,['python3','-B','scripts/mutations.py'],False),(180,['python3','-B','scripts/audit.py'],False),(60,['python3','-B','scripts/metadata.py'],False)]
receipts=[]
for k,(limit,cmd,asan) in enumerate(jobs):
 env=dict(os.environ);env['FT1536_ASAN']='1' if asan else '0';argv=[sys.executable,'-B','scripts/run.py',str(limit)]+cmd;t=time.monotonic();p=subprocess.run(argv,cwd=D,env=env,capture_output=True,timeout=limit+15)
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(D/'logs'/('replay_job_'+str(k)+'.'+s)).write_bytes(b)
 receipts.append(dict(index=k,argv=argv,asan=asan,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(D/'logs'/('replay_job_'+str(k)+'.stdout')),stderr_sha256=sha(D/'logs'/('replay_job_'+str(k)+'.stderr'))));(D/'REPLAY_COMMANDS.json').write_text(json.dumps(receipts,indent=2)+'\n');print('REPLAY_JOB',k,cmd[-2:],p.returncode,flush=True)
 if p.returncode:
  (D/'REPLAY_RESULT.json').write_text(json.dumps(dict(status='FRESH_REPLAY_FAIL_JOB',index=k,exit_code=p.returncode,matches=[]),indent=2)+'\n');raise SystemExit(p.returncode)
matches=[];bad=[]
for r in expected['files']:
 h=sha(member(D,r['path']))
 if h==r['sha256']:matches.append(dict(path=r['path'],sha256=h))
 else:bad.append(dict(path=r['path'],expected=r['sha256'],actual=h))
result=dict(status='FRESH_REPLAY_PASS' if not bad else 'FRESH_REPLAY_FAIL_MATCH',game='IID_BUFFER',external_manifest_sha256=pin,manifest=manifest,source_members_verified=len(rows),fresh_without_project_cache=True,expected_files=len(expected['files']),matched=len(matches),matches=matches,mismatches=bad,source_scope_unchanged=all(sha(member(W,r))==h for r,h in rows.items()),historical_status='H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL',real_prng_to_iid_bridge_proved=False,owner_accepted=False)
(D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k not in ['matches','mismatches']},indent=2));assert not bad and result['source_scope_unchanged'],bad
