import json,shutil
from pathlib import Path
from replaylib import sha
W=Path.cwd();D=W/'tmp/rehearsal_001';A=W/'artifacts/attempts/rehearsal_001';assert not A.exists();r=json.loads((D/'REPLAY_RESULT.json').read_text());assert r['status']=='FRESH_REPLAY_FAIL_JOB'
paths={'COMMANDS.log','REPLAY_RESULT.json','REPLAY_COMMANDS.json','logs/replay_job_0.stdout','logs/replay_job_0.stderr'}
commands=[x for x in map(json.loads,(D/'COMMANDS.log').read_text().splitlines()) if x['cwd']==str(D)]
for c in commands:
 for s in ['stdout','stderr']:paths.add(c[s])
for i in range(3):
 for s in ['stdout','stderr']:paths.add('logs/toolchain_'+str(i)+'.'+s)
files=[]
for rel in sorted(paths):
 dst=A/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(D/rel,dst);files.append(dict(path=rel,sha256=sha(dst)))
(A/'FILES.json').write_text(json.dumps(dict(files=files,fresh_commands=commands,explanation='Toolchain sage --version timed out45s. Bounded verbose mamba diagnostic then returned10.9. No recipe/limits/input changes; independent absent rehearsal_002 rebuilt516/516.'),indent=2)+'\n');print('ARCHIVED_FAILED_REPLAY_AND_DIAGNOSTIC',len(files))
