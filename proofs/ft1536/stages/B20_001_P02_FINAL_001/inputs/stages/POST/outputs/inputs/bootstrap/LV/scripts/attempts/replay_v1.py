"""Standard external-pin replay, or pre-freeze --rehearsal. No original paths needed."""
import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import member,sha,verify_manifest
W=Path(__file__).absolute().parents[1]
def main():
    args=sys.argv[1:];rehearsal=len(args)==2 and args[0]=='--rehearsal'
    if rehearsal:
        if (W/'OUTPUTS.sha256').exists():raise ValueError('rehearsal is pre-freeze only')
        dest=args[1];anchor=member(W,'artifacts/semantic_manifest.sha256')
        sem=verify_manifest(W,'artifacts/semantic_manifest.sha256',sha(anchor))
        matches=[dict(path=p,sha256=h) for p,h in sorted(sem.items())];expected=None
    else:
        if len(args)!=2:raise ValueError('replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256')
        dest,expected=args;scope=verify_manifest(W,'OUTPUTS.sha256',expected)
        old=json.loads(member(W,'artifacts/fresh_replay.json').read_text());matches=old['matches']
        if old['status']!='FRESH_REPLAY_PASS' or not matches:raise ValueError('invalid archived replay receipt')
        seen=set()
        for row in matches:
            if row['path'] in seen or scope.get(row['path'])!=row['sha256']:raise ValueError('unbound replay match')
            seen.add(row['path'])
    D=Path(dest).absolute()
    if '..' in D.parts or not D.is_relative_to(W/'tmp') or D==W/'tmp' or D.exists() or D.is_symlink():raise ValueError('DEST must be new under this copy tmp/')
    if any(p.is_symlink() for p in D.parents):raise ValueError('symlink ancestor')
    D.mkdir(parents=True,exist_ok=False)
    def copy(rel):
        if not rehearsal and rel not in scope:raise ValueError('unmanifested input: '+rel)
        src=member(W,rel);want=sha(src) if rehearsal else scope[rel]
        if sha(src)!=want:raise ValueError('input changed')
        dst=D/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst);assert sha(dst)==want
    for folder in ['source','inputs']:
        for p in sorted((W/folder).rglob('*')):
            if p.is_symlink():raise ValueError('symlink input')
            if p.is_file():copy(p.relative_to(W).as_posix())
    for rel in json.loads(member(W,'artifacts/formal_audit.json').read_text())['sources_sha256']:
        if Path(rel).name not in ['BridgeAudit.lean','BridgeTypes.lean']:copy(rel)
    copy('artifacts/inherited_modules.json');copy('checks/harness.c')
    for name in ['run.py','check_lean.py','audit.py','fixtures.py','build_controls.py','native_runs.py','compare_controls.py','toolchain.py']:copy('scripts/'+name)
    for name in ['artifacts','logs','tmp','bin']:(D/name).mkdir(exist_ok=True)
    jobs=[('kernel',240,False,['python3','-B','scripts/audit.py','--build']),
      ('fixtures',90,False,['/home/footfalcon/.local/bin/sage','scripts/fixtures.py']),
      ('observers',30,False,['python3','-B','scripts/build_controls.py']),
      ('normal',180,False,['python3','-B','scripts/native_runs.py','normal']),
      ('sanitizers',180,True,['python3','-B','scripts/native_runs.py','san']),
      ('oracle',120,False,['/home/footfalcon/.local/bin/sage','scripts/compare_controls.py']),
      ('toolchain',90,False,['python3','-B','scripts/toolchain.py'])]
    driver=[]
    for tag,limit,san,argv in jobs:
        command=['python3','-B','scripts/run.py',str(limit)]+argv
        env=dict(os.environ);env['FT1536_ASAN']='1' if san else '0';env['PYTHONOPTIMIZE']='0'
        tick=time.monotonic();p=subprocess.run(command,cwd=D,env=env,capture_output=True,timeout=limit+15)
        so=D/'logs'/('replay_'+tag+'.stdout');se=D/'logs'/('replay_'+tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
        driver.append(dict(argv=command,cwd=str(D),tag=tag,exit_code=p.returncode,wall_limit=limit,asan_shadow_reservation=san,
          elapsed=time.monotonic()-tick,stdout=str(so.relative_to(D)),stderr=str(se.relative_to(D)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
        (D/'REPLAY_COMMANDS.json').write_text(json.dumps(driver,indent=2)+'\n')
        print(tag,p.returncode,round(driver[-1]['elapsed'],3),flush=True)
        if p.returncode:raise RuntimeError('failed replay job: '+tag)
    for row in matches:
        if sha(member(D,row['path']))!=row['sha256']:raise ValueError('replay mismatch: '+row['path'])
    result=dict(status='FRESH_REPLAY_PASS',matches=matches,mode='rehearsal' if rehearsal else 'standard',
        expected_outputs_sha256=expected,no_carried_olean_binaries_cache=True,originals_required=False,
        asan_ubsan_replayed=True,receipt_count=len(driver))
    (D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
    if rehearsal:
        result['semantic_manifest_sha256']=sha(W/'artifacts/semantic_manifest.sha256')
        with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(result,f,indent=2);f.write('\n')
    print(json.dumps({k:v for k,v in result.items() if k!='matches'}|{'matched_files':len(matches)},indent=2))
if __name__=='__main__':main()
