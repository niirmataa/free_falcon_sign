"""Standard external-pin replay; pre-freeze --rehearsal uses a distinct anchor."""
import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import member,sha,verify_manifest
W=Path(__file__).absolute().parents[1]
def main():
    args=sys.argv[1:];rehearsal=len(args)==2 and args[0]=='--rehearsal'
    if rehearsal:
        if (W/'OUTPUTS.sha256').exists():raise ValueError('rehearsal is pre-freeze only')
        dest=args[1];a=member(W,'artifacts/semantic_manifest.sha256');sem=verify_manifest(W,'artifacts/semantic_manifest.sha256',sha(a))
        matches=[dict(path=p,sha256=h) for p,h in sorted(sem.items())];expected=None
    else:
        if len(args)!=2:raise ValueError('replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256')
        dest,expected=args;scope=verify_manifest(W,'OUTPUTS.sha256',expected)
        old=json.loads(member(W,'artifacts/fresh_replay.json').read_text());matches=old['matches'];seen=set()
        if old['status']!='FRESH_REPLAY_PASS' or not matches:raise ValueError('invalid archived receipt')
        for r in matches:
            if r['path'] in seen or scope.get(r['path'])!=r['sha256']:raise ValueError('unbound replay match')
            seen.add(r['path'])
    D=Path(dest).absolute()
    if '..' in D.parts or not D.is_relative_to(W/'tmp') or D==W/'tmp' or D.exists() or D.is_symlink() or any(p.is_symlink() for p in D.parents):raise ValueError('DEST must be new under tmp/')
    D.mkdir(parents=True,exist_ok=False)
    def cp(rel):
        if not rehearsal and rel not in scope:raise ValueError('unmanifested input '+rel)
        p=member(W,rel);want=sha(p) if rehearsal else scope[rel]
        if sha(p)!=want:raise ValueError('changed input')
        target=D/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target);assert sha(target)==want
    for folder in ['source','inputs']:
        for p in sorted((W/folder).rglob('*')):
            if p.is_symlink():raise ValueError('symlink input')
            if p.is_file():cp(p.relative_to(W).as_posix())
    for rel in json.loads(member(W,'artifacts/formal_audit.json').read_text())['sources_sha256']:
        if Path(rel).name not in ['M0Audit.lean','M0Types.lean']:cp(rel)
    for rel in ['artifacts/inherited_modules.json','checks/capacity.c','DECISIONS.md','GAME.md','RESOURCE_MODEL.md','H3_INTERFACE.md','TARGET_TYPE.md','CAPACITY.md','SOURCE_MODEL_BINDING.md','REUSED_RESULTS.md']:cp(rel)
    for name in ['run.py','check_lean.py','archive_attempt.py','replaylib.py','toolchain.py','audit.py','profile.py','ledger.py','check_contract.py','build_checks.py','native_checks.py','check_capacity.py']:cp('scripts/'+name)
    for name in ['logs','artifacts','tmp','bin']:(D/name).mkdir(exist_ok=True)
    jobs=[('kernel',240,False,['python3','-B','scripts/audit.py','--build']),
      ('controls_source',30,False,['python3','-B','scripts/build_checks.py']),
      ('profile',30,False,['python3','-B','scripts/profile.py']),('ledger',30,False,['python3','-B','scripts/ledger.py']),
      ('normal',120,False,['python3','-B','scripts/native_checks.py','normal']),
      ('sanitizers',120,True,['python3','-B','scripts/native_checks.py','san']),
      ('capacity',90,False,['/home/footfalcon/.local/bin/sage','scripts/check_capacity.py']),
      ('contract',30,False,['python3','-B','scripts/check_contract.py']),('toolchain',90,False,['python3','-B','scripts/toolchain.py'])]
    records=[]
    for tag,limit,san,argv in jobs:
        cmd=['python3','-B','scripts/run.py',str(limit)]+argv;env=dict(os.environ);env['FT1536_ASAN']='1' if san else '0';env['PYTHONOPTIMIZE']='0'
        t=time.monotonic();p=subprocess.run(cmd,cwd=D,env=env,capture_output=True,timeout=limit+15)
        so=D/'logs'/('replay_'+tag+'.stdout');se=D/'logs'/('replay_'+tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
        records.append(dict(tag=tag,argv=cmd,cwd=str(D),exit_code=p.returncode,limit=limit,elapsed=time.monotonic()-t,
          asan_shadow_reservation=san,stdout=str(so.relative_to(D)),stderr=str(se.relative_to(D)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
        (D/'REPLAY_COMMANDS.json').write_text(json.dumps(records,indent=2)+'\n');print(tag,p.returncode,round(records[-1]['elapsed'],3),flush=True)
        if p.returncode:raise RuntimeError('replay job failed: '+tag)
    for r in matches:
        if sha(member(D,r['path']))!=r['sha256']:raise ValueError('semantic mismatch '+r['path'])
    result=dict(status='FRESH_REPLAY_PASS',matches=matches,mode='rehearsal' if rehearsal else 'standard',expected_outputs_sha256=expected,
      no_carried_olean_binary_cache=True,originals_required=False,asan_ubsan_replayed=True,
      specification_documents_are_definitions_not_proofs=True,security_reduction_proved=False)
    (D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
    if rehearsal:
        result['semantic_manifest_sha256']=sha(W/'artifacts/semantic_manifest.sha256')
        with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(result,f,indent=2);f.write('\n')
    print(json.dumps({k:v for k,v in result.items() if k!='matches'}|{'matched_files':len(matches)},indent=2))
if __name__=='__main__':main()
