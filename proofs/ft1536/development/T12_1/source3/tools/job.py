#!/usr/bin/env python3
"""source3 development runner: snapshots/hashes/sandbox only, one job at a time.

The immutable STABLE_BINARY_004 products are imported by exact pins. New
sources come from this component, with archived stage sources as fallback.
No old W or historical runner is edited or used as a writable cache.
"""
from datetime import datetime, timezone
import fcntl
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import sys

ROOT = Path(__file__).resolve().parent.parent
REPO = ROOT.parents[4]
BUILD = ROOT / '.build'
OLD = REPO / 'proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002/continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003'
CLOSURE_SHA = 'd62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2'
REPORT_SHA = '3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96'
TOP_CLOSURE_SHA = '1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a'
TOP_REPORT_SHA = 'bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f'
SESSION = 'ses_f12636605ffeL1FZg4teLUwUf5'


def sha(p):
    with p.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def active():
    result = []
    for p in Path('/proc').glob('[0-9]*'):
        if int(p.name) == os.getpid():
            continue
        try:
            argv = [s.decode(errors='replace') for s in (p / 'cmdline').read_bytes().split(b'\0') if s]
            if not argv:
                continue
            script = argv[2] if len(argv)>2 and argv[1]=='-B' else argv[1] if len(argv)>1 else ''
            if Path(argv[0]).name in {'lean', 'sage', 'lake'} or (
                Path(argv[0]).name.startswith('python') and Path(script).name in
                    {'job.py', 'replay.py', 'a3_job.py', 'final_replay.py'}):
                result.append({'pid': int(p.name), 'exe': argv[0], 'cwd': str((p / 'cwd').resolve())})
        except OSError:
            pass
    return result


def pinned():
    cp = ROOT / 'notes/run/STABLE_BINARY_004_CLOSURE.json'
    rp = ROOT / 'notes/run/STABLE_BINARY_004_REPORT.md'
    assert sha(cp)==CLOSURE_SHA and sha(rp)==REPORT_SHA, 'dependency handoff pin mismatch'
    c = json.loads(cp.read_text())
    cfg = OLD / 'run/CONFIG.json'
    assert sha(cfg)==c['config_sha256'], 'historical library configuration changed'
    config = json.loads(cfg.read_text())
    entries = {}
    for e in c['modules'] + c['reused_local_dependencies']:
        entries[e['module']] = {'source': str(OLD/e['source_path']), 'source_sha256': e['source_sha256'],
            'artifact': str(OLD/e['olean_path']), 'artifact_sha256': e['olean_sha256'], 'origin': 'STABLE_BINARY_004'}
    for e in c['frozen_task_dependencies']:
        entries[e['module']] = {**e, 'origin': 'frozen-task'}
    return c, config, entries


def suffix_dependencies():
    """Additional immutable inputs; keep pinned() compatible with the _001 organizer."""
    cp=ROOT/'notes/run/STABLE_TOP_001_CLOSURE.json'
    rp=ROOT/'notes/run/STABLE_TOP_001_REPORT.md'
    assert sha(cp)==TOP_CLOSURE_SHA and sha(rp)==TOP_REPORT_SHA
    entries={}
    for e in json.loads(cp.read_text())['modules']:
        entries[e['module']]={'source':str(ROOT/e['source']),'source_sha256':e['source_sha256'],
            'artifact':str(ROOT/e['artifact']),'artifact_sha256':e['artifact_sha256'],'origin':'STABLE_TOP_001 / NOT_REVIEWED'}
    old_bindings=OLD/'run/SOURCE3_AUDIT_INPUTS.json'
    assert sha(old_bindings)=='b0cacca9992875074906188b6e09203598e10d6a785a5791b46f8acdb2b8edb8'
    for e in json.loads(old_bindings.read_text())['modules']:
        if e['module'] not in {'Source3.LeafRange','Source3.LeafScan','Source3.LeafCertificateSuffix','Source3.LeafWordBounds'}:
            continue
        assert sha(OLD/e['source'])==e['source_sha256'] and sha(OLD/e['artifact'])==e['artifact_sha256'],e['module']
        assert sha(OLD/e['receipt'])==e['receipt_sha256'],e['module']
        records=json.loads((OLD/e['receipt']).read_text())
        rec=next(r for r in records if r['name']==e['module'].replace('.','_'))
        assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0,e['module']
        entries[e['module']]={**e,'source':str(OLD/e['source']),'artifact':str(OLD/e['artifact']),
            'receipt':str(OLD/e['receipt']),'origin':'SOURCE3_PROGRESS / scoped dependency'}
    return entries


def main():
    mode, label, *args = sys.argv[1:]
    if mode not in {'lean', 'sage'} or not re.fullmatch(r'[A-Za-z0-9_]+', label) or not args:
        raise ValueError('usage: python3 -B tools/job.py lean|sage unique_label module...|file.sage')
    BUILD.mkdir(exist_ok=True)
    with (BUILD/'JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        dest = BUILD/'jobs'/label
        dest.mkdir(parents=True, exist_ok=False)
        processes = active()
        (dest/'PREFLIGHT.json').write_text(json.dumps({'utc': datetime.now(timezone.utc).isoformat(),
            'session': SESSION, 'model': 'openai/gpt-6-astra', 'processes': processes}, indent=2)+'\n')
        if processes:
            print(json.dumps(processes, indent=2))
            return 2
        closure, config, seeds = pinned()
        seeds.update(suffix_dependencies())
        engine_source = Path(config['parent_frozen'])/'tools/execution.py'
        assert sha(engine_source)==closure['execution_runner_sha256'], 'execution engine changed'
        spec = importlib.util.spec_from_file_location('pinned_execution', engine_source)
        engine = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(engine)
        shutil.copyfile(Path(__file__), dest/'RUNNER_SOURCE.py')
        shutil.copyfile(engine_source, dest/'EXECUTION_SOURCE.py')
        for d in ['lib', 'formal', 'home', 'tmp', 'cache', 'logs']:
            (dest/d).mkdir()
        archived = json.loads((ROOT/'ARCHIVED_DEPENDENCIES.json').read_text())['files']
        archived = {e['target'][7:]: e for e in archived if e['target'].startswith('formal/')}
        cache_file = BUILD/'cache/CACHE_INDEX.json'
        cache = json.loads(cache_file.read_text()) if cache_file.exists() else {}
        bindings = {**seeds, **cache}

        def source(module):
            rel = module.replace('.', '/')+'.lean'
            own = ROOT/'formal'/rel
            if own.exists():
                return own
            if rel in archived:
                e = archived[rel]
                p = REPO/e['stage']
                assert sha(p)==e['sha256'], 'stage source changed: '+module
                return p
            if module in seeds:
                return Path(seeds[module]['source'])
            raise ValueError('source not pinned: '+module)

        selected = set(args) if mode=='lean' else set()
        inputs = {'runner_sha256': sha(Path(__file__)), 'closure004_sha256': CLOSURE_SHA,
            'stable_top001_closure_sha256': TOP_CLOSURE_SHA,
            'execution_sha256': sha(engine_source), 'sources': [], 'reused': [], 'library_roots': config['library_roots']}
        # One complete namespace tree; outputs never point through a symlink.
        for m, e in bindings.items():
            if m in selected:
                continue
            op = Path(e['artifact'])
            assert sha(op)==e['artifact_sha256'], 'product changed: '+m
            assert sha(source(m))==e['source_sha256'], 'stale source cache (rebuild): '+m
            link = dest/'lib'/(m.replace('.', '/')+'.olean')
            link.parent.mkdir(parents=True, exist_ok=True)
            link.symlink_to(op)
            inputs['reused'].append({'module': m, **e, 'current_source': str(source(m))})
        env = os.environ.copy()
        for key, sub in [('HOME','home'),('TMPDIR','tmp'),('TMP','tmp'),('TEMP','tmp'),
                         ('DOT_SAGE','home/.sage'),('XDG_CACHE_HOME','cache'),('MPLCONFIGDIR','cache/mpl')]:
            p=dest/sub; p.mkdir(parents=True, exist_ok=True); env[key]=str(p)
        libs = [str(v['build']) for k,v in config['library_roots'].items() if k!='lean']
        env.update(PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1',
            LEAN_PATH=':'.join([str(dest/'lib')]+libs), FT1536_SOURCE3_ORIGINAL_W=str(OLD))
        snapshots=[]
        if mode=='lean':
            for m in args:
                if not re.fullmatch(r'[A-Za-z_][\w]*(?:\.[A-Za-z_][\w]*)*', m):
                    raise ValueError('invalid module')
                p=source(m); q=dest/'formal'/(m.replace('.', '/')+'.lean')
                q.parent.mkdir(parents=True, exist_ok=True); shutil.copyfile(p,q)
                snapshots.append((m,q))
                inputs['sources'].append({'module':m,'path':str(p),'sha256':sha(p)})
        else:
            rel=Path(args[0])
            if rel.is_absolute() or '..' in rel.parts or rel.suffix!='.sage':
                raise ValueError('expected relative .sage source')
            p=ROOT/'sage'/rel; q=dest/'sage'/rel
            q.parent.mkdir(parents=True, exist_ok=True); shutil.copyfile(p,q)
            inputs['sources'].append({'path':str(p),'sha256':sha(p)})
        (dest/'SOURCE_INPUTS.json').write_text(json.dumps(inputs, indent=2)+'\n')
        receipts=[]
        if mode=='lean':
            for m,q in snapshots:
                imports=re.findall(r'^import\s+(\S+)',q.read_text(),re.M)
                dependency_hashes={}
                for dep in imports:
                    if dep in bindings:
                        dependency_hashes[dep]=bindings[dep]['artifact_sha256']
                        for transitive,expected in bindings[dep].get('imports',{}).items():
                            assert bindings[transitive]['artifact_sha256']==expected, 'stale dependency: '+dep
                op=dest/'lib'/(m.replace('.', '/')+'.olean'); op.parent.mkdir(parents=True,exist_ok=True)
                rec=engine.step(dest,m.replace('.','_'),[str(engine.LEAN),'-j1','-M6144','-o',str(op),str(q)],dest/'formal',env)
                rec['source_sha256']=sha(q); receipts.append(rec)
                if not rec['accepted'] or rec['cumulative_child_maxrss_kib']>8*1024*1024:
                    break
                rec['olean_sha256']=sha(op)
                cp=BUILD/'cache'/(m.replace('.', '/')+'.olean'); cp.parent.mkdir(parents=True,exist_ok=True)
                shutil.copyfile(op,cp)
                cache[m]={'source':str(source(m)),'source_sha256':sha(q),'artifact':str(cp),
                    'artifact_sha256':sha(cp),'imports':dependency_hashes,'origin':str(dest.relative_to(ROOT)),
                    'receipt':str(dest/'RECEIPTS.json')}
                bindings[m]=cache[m]
                cache_file.write_text(json.dumps(cache,indent=2)+'\n')
        else:
            rec=engine.step(dest,'sage',[engine.SAGE,str(q)]+args[1:],dest,env)
            rec['source_sha256']=sha(q); receipts.append(rec)
        (dest/'RECEIPTS.json').write_text(json.dumps(receipts,indent=2)+'\n')
        return int(any(not r['accepted'] or r['cumulative_child_maxrss_kib']>8*1024*1024 for r in receipts))


if __name__=='__main__':
    sys.exit(main())
