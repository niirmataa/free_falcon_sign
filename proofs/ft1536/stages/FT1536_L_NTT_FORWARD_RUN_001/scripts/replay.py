"""Standard: replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256.

Pre-freeze only: replay.py --rehearsal ABSENT_DEST. The rehearsal's semantic
anchor is explicit and is never accepted as an OUTPUTS pin by standard mode.
"""
import json,os,shutil,subprocess,sys,time
from pathlib import Path
from replaylib import member,sha,verify_manifest
W=Path(__file__).absolute().parents[1]
def main():
    args=sys.argv[1:];rehearsal=len(args)==2 and args[0]=='--rehearsal'
    if rehearsal:
        if (W/'OUTPUTS.sha256').exists():raise ValueError('rehearsal is pre-freeze only')
        destarg=args[1]
        anchor=member(W,'artifacts/semantic_manifest.sha256')
        sem=verify_manifest(W,'artifacts/semantic_manifest.sha256',sha(anchor))
        expected_matches=[dict(path=p,sha256=h) for p,h in sorted(sem.items())]
        expected_outputs=None
    else:
        if len(args)!=2:raise ValueError('usage: replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256')
        destarg,expected_outputs=args
        scope=verify_manifest(W,'OUTPUTS.sha256',expected_outputs)
        receipt=json.loads(member(W,'artifacts/fresh_replay.json').read_text())
        expected_matches=receipt['matches'];seen=set()
        if receipt['status'] not in ['FRESH_REPLAY_PASS','FRESH_REPLAY_MATCH'] or not expected_matches:
            raise ValueError('missing successful archived replay anchor')
        for row in expected_matches:
            p,h=row['path'],row['sha256']
            if p in seen or scope.get(p)!=h:raise ValueError('unbound replay match')
            seen.add(p)
    D=Path(destarg).absolute()
    if '..' in D.parts or not D.is_relative_to(W/'tmp') or D==W/'tmp' or D.exists() or D.is_symlink():
        raise ValueError('DEST must be a new descendant of this working copy tmp/')
    for parent in D.parents:
        if parent.is_symlink():raise ValueError('symlink DEST ancestor')
    D.mkdir(parents=True,exist_ok=False)
    driver=[]
    def copy(rel):
        if not rehearsal and rel not in scope:raise ValueError('unmanifested replay input: '+rel)
        src=member(W,rel);wanted=sha(src) if rehearsal else scope[rel]
        if sha(src)!=wanted:raise ValueError('input changed after verification: '+rel)
        dst=D/rel;dst.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(src,dst)
        assert sha(dst)==wanted
    # Archived local copies suffice; provenance original paths are not opened.
    for folder in ['source','inputs']:
        for p in sorted((W/folder).rglob('*')):
            if p.is_symlink():raise ValueError('symlink input')
            if p.is_file():copy(p.relative_to(W).as_posix())
    formal=json.loads(member(W,'artifacts/formal_audit.json').read_text())['source_sha256']
    for rel in formal:
        if '/LeafData/' not in rel and Path(rel).name not in ['LeafChecks.lean','Audit.lean','AuditTypes.lean']:copy(rel)
    for rel in ['formal/Rho.patch','checks/pipeline.c','artifacts/inherited_modules.json','artifacts/adaptations.json']:
        copy(rel)
    for name in ['run.py','check_lean.py','export_leaf_checks.py','audit.py','prepare_checks.py','run_controls.py','sage_controls.py','toolchain.py']:
        copy('scripts/'+name)
    for folder in ['logs','artifacts','tmp','bin']:(D/folder).mkdir(exist_ok=True)
    for tag,limit,argv in [
        ('nodes',30,['python3','-B','scripts/export_leaf_checks.py']),
        ('kernel',240,['python3','-B','scripts/audit.py','--build']),
        ('fixtures',30,['python3','-B','scripts/prepare_checks.py']),
        ('controls',180,['python3','-B','scripts/run_controls.py']),
        ('toolchain',90,['python3','-B','scripts/toolchain.py'])]:
        command=['python3','-B','scripts/run.py',str(limit)]+argv
        start=time.monotonic()
        # Child bwrap and all its processes have finite wall/CPU/address-space
        # limits. The parent's timeout includes a small logging allowance.
        p=subprocess.run(command,cwd=D,capture_output=True,timeout=limit+15)
        so=D/'logs'/('replay_'+tag+'.stdout');se=D/'logs'/('replay_'+tag+'.stderr')
        so.write_bytes(p.stdout);se.write_bytes(p.stderr)
        driver.append(dict(tag=tag,argv=command,cwd=str(D),exit_code=p.returncode,wall_limit=limit,
            elapsed=time.monotonic()-start,stdout=str(so.relative_to(D)),stderr=str(se.relative_to(D)),
            stdout_sha256=sha(so),stderr_sha256=sha(se)))
        (D/'REPLAY_COMMANDS.json').write_text(json.dumps(driver,indent=2)+'\n')
        print(tag,p.returncode,round(driver[-1]['elapsed'],3),flush=True)
        if p.returncode:raise RuntimeError('replay job failed: '+tag)
    matches=[]
    for row in expected_matches:
        actual=sha(member(D,row['path']))
        if actual!=row['sha256']:raise ValueError('replay mismatch: '+row['path'])
        matches.append(dict(path=row['path'],sha256=actual))
    result=dict(status='FRESH_REPLAY_PASS',matches=matches,mode='rehearsal' if rehearsal else 'standard',
        expected_outputs_sha256=expected_outputs,no_carried_olean_binaries_cache=True,
        originals_required=False,source_models_unchanged=True,receipt_count=len(driver))
    (D/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2)+'\n')
    if rehearsal:
        result['semantic_manifest_sha256']=sha(W/'artifacts/semantic_manifest.sha256')
        with (W/'artifacts/fresh_replay.json').open('x') as f:json.dump(result,f,indent=2);f.write('\n')
    print(json.dumps({k:v for k,v in result.items() if k!='matches'}|{'matched_files':len(matches)},indent=2))
if __name__=='__main__':main()
