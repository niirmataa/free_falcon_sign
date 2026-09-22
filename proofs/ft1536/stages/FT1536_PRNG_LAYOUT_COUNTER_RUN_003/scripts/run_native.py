"""Run the original-C-slice harness: normal (8 GiB AS cap), ASan/UBSan, alt branch.

The normal and alternate-branch runs are bounded to 8 GiB address space;
the ASan/UBSan run runs separately with its shadow mapping and core dumps
disabled.  Dumps are stored byte-for-byte as the program stdout.
"""
import json,os,resource
from pathlib import Path
from common import W,run_logged
from replaylib import sha
A=W/'artifacts';BIN=W/'bin'
ART={'normal':'harness_dump.json','sanitized':'harness_dump_sanitized.json','altbranch':'harness_dump_altbranch.json'}
def cap8gib():
 resource.setrlimit(resource.RLIMIT_CORE,(0,0))
 resource.setrlimit(resource.RLIMIT_AS,(8*1024**3,8*1024**3))
def core0():
 resource.setrlimit(resource.RLIMIT_CORE,(0,0))
RUNS={'normal':(cap8gib,{}),
 'sanitized':(core0,{'ASAN_OPTIONS':'abort_on_error=1:detect_leaks=0:allocator_may_return_null=1','UBSAN_OPTIONS':'halt_on_error=1:print_stacktrace=1'}),
 'altbranch':(cap8gib,{})}
def main():
 recs=[]
 for name,(pre,extra) in RUNS.items():
  env=dict(os.environ);env.update(extra)
  argv=[BIN/('prng-harness-'+name),A/'fixtures.bin',A/'fixtures_ids.txt','7']
  rec,so,se=run_logged('native_'+name,argv,cwd=W,env=env,timeout=1200,preexec=pre)
  assert rec['exit_code']==0,('native run failed',name,se.decode()[-3000:])
  d=json.loads(so)
  assert d['tag']=='ORIGINAL_C_SLICE' and len(d['fixtures'])==7,(name,d.get('tag'))
  out=A/ART[name];out.write_bytes(so)
  recs.append(dict(name=name,artifact='artifacts/'+out.name,artifact_sha256=sha(out),exit_code=rec['exit_code'],stdout_sha256=rec['stdout_sha256'],stderr_sha256=rec['stderr_sha256'],sanitizer=(name=='sanitized'),address_space_limit_8gib=(name!='sanitized')))
 (W/'receipts/native_run.json').write_text(json.dumps(dict(schema='PRNG_T021_NATIVE_RUN_V1',fixtures=7,runs=recs),indent=2)+'\n')
 print(json.dumps(recs,indent=2))
if __name__=='__main__':main()
