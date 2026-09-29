#!/usr/bin/env python3
"""Sealed P02 v2 full replay from this package, in absent W/run DEST; no prior W use."""
from pathlib import Path
import argparse,datetime,hashlib,json,os,shutil,signal,subprocess,sys,time

O=Path(__file__).resolve().parents[1];W=O.parent;REPO=W.parents[3]
LEAN=Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean')
P01=REPO/'proofs/ft1536/work/B20_001/P01'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
stamp=lambda:datetime.datetime.now(datetime.timezone.utc).isoformat()
static=('inputs','formal','predecessor','evidence','context','library_provenance','replay')

def preflight(outputs_sha=None,inputs_sha=None):
    assert sha(O/'predecessor/OUTPUTS.sha256')=='4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01'
    assert sha(O/'predecessor/REPORT.md')=='98ea050bfe15b39b4ad2a6d26428bcd7e12f22ca33b06b6bc98e9e964bb295a5'
    assert sha(O/'inputs/MATERIALIZED.sha256')=='d70316d8450015aba6980a8c521f9979046b1983e6d6dcef5400f864abeef03b'
    assert sha(O/'inputs/source17/CANDIDATE.sha256')=='56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
    assert sha(O/'inputs/BOUND_INPUTS.json')=='567f57ac135d0c766f95dfbc53b5dfedcd9d4eb15993d78ab896d4bead936278'
    manifest=O/'INPUTS.sha256'
    if inputs_sha:assert sha(manifest)==inputs_sha
    rows={}
    for line in manifest.read_text().splitlines():
        h,name=line.split('  ',1);p=Path(name)
        assert name not in rows and not p.is_absolute() and '..' not in p.parts and name!=manifest.name
        f=O/p
        assert f.is_file() and not f.is_symlink() and f.resolve().is_relative_to(O.resolve())
        assert sha(f)==h,name
        rows[name]=h
    actual={p.relative_to(O).as_posix() for d in static for p in (O/d).rglob('*') if p.is_file()}
    actual.add('SEMANTIC_FILES.json')
    assert all(not p.is_symlink() for d in static for p in (O/d).rglob('*'))
    assert actual==set(rows),(len(actual),len(rows),list(actual-set(rows))[:8])
    assert len([x for x in rows if x.startswith('inputs/')])==7372
    for raw in (O/'predecessor/OUTPUTS.sha256').read_text().splitlines():
        h,n=raw.split('  ',1);assert sha(O/'predecessor'/n)==h,n
    if outputs_sha:
        assert sha(O/'OUTPUTS.sha256')==outputs_sha
        expected=set()
        for line in (O/'OUTPUTS.sha256').read_text().splitlines():
            h,n=line.split('  ',1);p=Path(n)
            assert not p.is_absolute() and '..' not in p.parts and n not in expected
            assert sha(O/p)==h,n
            expected.add(n)
        assert {p.relative_to(O).as_posix() for p in O.rglob('*') if p.is_file() and p!=O/'OUTPUTS.sha256'}==expected
    plan=json.loads((O/'formal/BUILD_PLAN.json').read_text())['modules']
    assert len(plan)==34 and all((O/'formal'/p).is_file() for p in plan)
    print('PREFLIGHT_PASS',len(rows),'input/static files; plan',len(plan),flush=True)
    return plan,sha(manifest)

def files(root):return {p.relative_to(root).as_posix():sha(p) for p in sorted(root.rglob('*')) if p.is_file()}

def main():
    a=argparse.ArgumentParser();a.add_argument('name');a.add_argument('--inputs-sha256');a.add_argument('--outputs-sha256');args=a.parse_args()
    assert args.name.replace('_','').isalnum()
    dest=W/'run'/args.name
    assert not dest.exists()
    plan,pin=preflight(args.outputs_sha256,args.inputs_sha256)
    dest.mkdir()
    for part in ['source','build','home','tmp','cache','sage','config','data','logs']:(dest/part).mkdir()
    shutil.copytree(O/'formal',dest/'source',dirs_exist_ok=True,copy_function=shutil.copyfile)
    before=files(dest/'source')
    for p in (dest/'source').rglob('*'):
        if p.is_file():p.chmod(0o444)
    srcpins={p.relative_to(O/'formal').as_posix():sha(p) for p in (O/'formal').rglob('*') if p.is_file()}
    assert srcpins==before
    # Organizer replacement is separately sealed; the historical tool is retained unchanged.
    env={'PATH':'/home/footfalcon/.local/bin:/home/footfalcon/miniforge3/envs/sage/bin:/usr/bin:/bin',
         'LANG':'C.UTF-8','HOME':str(dest/'home'),'TMPDIR':str(dest/'tmp'),'TMP':str(dest/'tmp'),'TEMP':str(dest/'tmp'),
         'DOT_SAGE':str(dest/'sage'),'XDG_CACHE_HOME':str(dest/'cache'),'XDG_CONFIG_HOME':str(dest/'config'),
         'XDG_DATA_HOME':str(dest/'data'),'PYTHONDONTWRITEBYTECODE':'1','OMP_NUM_THREADS':'1','OPENBLAS_NUM_THREADS':'1',
         'P02_INPUTS':str(O/'inputs'),'P02_DEST':str(dest),'P02_PACKAGE':str(O)}
    libs=[P01/'bootstrap/mathlib4/.lake/build/lib/lean']+[p/'.lake/build/lib/lean' for p in sorted((P01/'run/.lake/packages').iterdir()) if p.is_dir()]
    env['LEAN_PATH']=':'.join(map(str,[dest/'build']+libs))
    sandbox=['/usr/bin/bwrap','--die-with-parent','--unshare-net','--ro-bind','/','/',
             '--proc','/proc','--dev-bind','/dev','/dev','--bind',str(dest),str(dest),
             '--ro-bind',str(dest/'source'),str(dest/'source'),'--ro-bind',str(O),str(O),
             '--bind',str(dest/'tmp'),'/tmp','--chdir',str(dest/'source')]
    actions=[('/usr/bin/python3', '-B', str(O/'replay/portable_toolchain_gate.py'))]
    for name,tails in [('embed_source.py',[]),('embed_le.py',[]),('embed_scalar.py',[]),('check_transport.py',[]),
                       ('controls.py',['normal']),('le_controls.py',['normal']),('scalar_controls.py',['normal'])]:
        actions.append(('/usr/bin/python3','-B',str(dest/'source/tools'/name),*tails))
    for rel in plan:
        out=dest/'build'/Path(rel).with_suffix('.olean');out.parent.mkdir(parents=True,exist_ok=True)
        actions.append((str(LEAN),'-j1','-M2048','--root='+str(dest/'source'),'-o',str(out),str(dest/'source'/rel)))
    audit=dest/'source/AuditTermsFull.lean'
    assert audit.is_file()
    actions.append((str(LEAN),'-j1','-M2048','--root='+str(dest/'source'),
                    '-o',str(dest/'build/AuditTermsFull.olean'),str(audit)))
    receipt={'schema':'P02_PORTABLE_FULL_REPLAY_V2','start':stamp(),'name':args.name,'package_root':str(O),
             'predecessor_outputs_sha256':sha(O/'predecessor/OUTPUTS.sha256'),'inputs_sha256':pin,
             'source_before':before,'steps':[],'single_worker':True,'network':'unshare-net',
             'wall_per_step_s':1800,'address_space_bytes':8589934592,'environment':env}
    code=0
    for n,command in enumerate(actions):
        out=dest/f'logs/{n:03d}.stdout';err=dest/f'logs/{n:03d}.stderr'
        argv=sandbox+['/usr/bin/prlimit','--as=8589934592','--',*command]
        started=stamp();t=time.monotonic();timed_out=False
        with out.open('wb') as so,err.open('wb') as se:
            p=subprocess.Popen(argv,env=env,stdout=so,stderr=se,start_new_session=True)
            try:code=p.wait(timeout=1800)
            except subprocess.TimeoutExpired:
                os.killpg(p.pid,signal.SIGKILL);p.wait();code=124;timed_out=True
        stdout=out.read_text(errors='replace');stderr=err.read_bytes()
        clean=not stderr and 'warning:' not in stdout
        if command[-1].endswith('/AuditTermsFull.lean'):
            clean=clean and '⋯' not in stdout and '\n...\n' not in stdout
        receipt['steps'].append({'argv':argv,'cwd':str(dest/'source'),'start':started,'stop':stamp(),
            'elapsed_s':time.monotonic()-t,'exit_code':code,'timed_out':timed_out,'clean':clean,
            'stdout':str(out.relative_to(dest)),'stderr':str(err.relative_to(dest)),
            'stdout_sha256':sha(out),'stderr_sha256':sha(err)})
        if code==0 and n in (5,6,7):
            # Three controllers reuse child log basenames in build/. Capture each
            # producer's raw streams before the next controller can overwrite them.
            label={5:'word',6:'le',7:'scalar'}[n]
            child=dest/'build'/({'word':'CONTROL_RECEIPTS.json','le':'LE_CONTROL_RECEIPTS.json',
                                 'scalar':'SCALAR_CONTROL_RECEIPTS.json'}[label])
            raw=json.loads(child.read_text())
            archived=dest/'logs/child'/label;archived.mkdir(parents=True)
            shutil.copyfile(child,archived/child.name)
            for entry in raw:
                for kind in ('stdout','stderr'):
                    source=dest/'build'/entry[kind]
                    assert sha(source)==entry[kind+'_sha256'],(n,entry['name'],kind)
                    target=archived/(entry['name']+'.'+kind)
                    shutil.copyfile(source,target)
                    assert sha(target)==entry[kind+'_sha256']
            receipt['steps'][-1]['child_receipt_snapshot']=str((archived/child.name).relative_to(dest))
            receipt['steps'][-1]['child_commands_snapshotted']=len(raw)
        print(args.name,n,'exit',code,'clean',clean,flush=True)
        if code or not clean:
            print(stdout[-5000:],stderr.decode(errors='replace')[-5000:],flush=True)
            code=code or 1
            break
    receipt['stop']=stamp();receipt['exit_code']=code;receipt['source_after']=files(dest/'source')
    receipt['sources_unchanged']=receipt['source_before']==receipt['source_after']==srcpins
    receipt['text_products']={p.relative_to(dest/'build').as_posix():sha(p) for p in (dest/'build').rglob('*') if p.is_file() and p.suffix not in ('.olean','.o','.so') and not os.access(p,os.X_OK)}
    assert receipt['sources_unchanged']
    (dest/'receipt.json').write_text(json.dumps(receipt,indent=2,sort_keys=True)+'\n')
    return code

if __name__=='__main__':sys.exit(main())
