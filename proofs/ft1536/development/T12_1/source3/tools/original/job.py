#!/usr/bin/env python3
"""One continuation job; reuse the pinned strict acceptance/sandbox runner."""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import sys

W = Path(__file__).resolve().parent.parent
CONFIG = json.loads((W / 'run/CONFIG.json').read_text())
EXECUTION = Path(CONFIG['parent_frozen']) / 'tools/execution.py'
spec = importlib.util.spec_from_file_location('run002_execution', EXECUTION)
engine = importlib.util.module_from_spec(spec)
spec.loader.exec_module(engine)


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def active():
    found = []
    for p in Path('/proc').glob('[0-9]*'):
        if int(p.name) == os.getpid():
            continue
        try:
            argv = [s.decode(errors='replace') for s in (p / 'cmdline').read_bytes().split(b'\0') if s]
            # A concurrent `git add` may enumerate a path called job.py in
            # its *file list*. This is not an executing job. Only inspect
            # Python's script position (accounting for `python3 -B`).
            script = argv[2] if len(argv) > 2 and argv[1] == '-B' else (
                argv[1] if len(argv) > 1 else '')
            if argv and (Path(argv[0]).name in {'lean', 'sage', 'lake'} or
                    (Path(argv[0]).name.startswith('python') and
                     Path(script).name in {'job.py', 'replay.py', 'a3_job.py', 'final_replay.py'})):
                found.append({'pid': int(p.name), 'executable': Path(argv[0]).name,
                              'cwd': str((p / 'cwd').resolve())})
        except OSError:
            pass
    return found


def main():
    mode, label, *args = sys.argv[1:]
    if mode not in {'lean', 'sage'} or not re.fullmatch(r'[A-Za-z0-9_]+', label):
        raise ValueError('invalid mode/label')
    pre = W / 'run/preflight' / (label + '.json')
    if pre.exists():
        raise ValueError('label already used')
    processes = active()
    pre.write_text(json.dumps({'utc': datetime.now(timezone.utc).isoformat(),
        'processes': processes, 'model': 'openai/gpt-6-astra',
        'session': 'ses_f12636605ffeL1FZg4teLUwUf5'}, indent=2) + '\n')
    if processes:
        print(json.dumps(processes, indent=2))
        return 2
    dest = W / 'run' / label
    dest.mkdir()
    shutil.copyfile(Path(__file__), dest / 'RUNNER_SOURCE.py')
    shutil.copyfile(EXECUTION, dest / 'EXECUTION_SOURCE.py')
    for sub in ['lib', 'home', 'tmp', 'cache', 'logs']:
        (dest / sub).mkdir()
    env = os.environ.copy()
    for key, sub in [('HOME', 'home'), ('TMPDIR', 'tmp'), ('TMP', 'tmp'), ('TEMP', 'tmp'),
                     ('DOT_SAGE', 'home/.sage'), ('XDG_CACHE_HOME', 'cache'), ('MPLCONFIGDIR', 'cache/mpl')]:
        p = dest / sub
        p.mkdir(parents=True, exist_ok=True)
        env[key] = str(p)
    env.update(PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1')
    owncache = W / 'run/devlib'
    roots = [dest / 'lib', owncache, Path(CONFIG['parent_cache'])]
    roots += [Path(v['build']) for k, v in CONFIG['library_roots'].items() if k != 'lean']
    env['LEAN_PATH'] = ':'.join(map(str, roots))
    inputs = {'runner_sha256': sha(Path(__file__)), 'execution_sha256': sha(EXECUTION), 'sources': [],
              'parent_cache_bindings_sha256': sha(W / 'PARENT_CACHE_BINDINGS.json'), 'own_cache': []}
    if mode == 'lean':
        rebuilt = {m.replace('.', '/') + '.olean' for m in args}
        for p in sorted(owncache.rglob('*.olean')):
            rel = p.relative_to(owncache)
            inputs['own_cache'].append({'path': str(rel), 'sha256': sha(p)})
            if str(rel) not in rebuilt:
                target = dest / 'lib' / rel
                target.parent.mkdir(parents=True, exist_ok=True)
                target.symlink_to(p)
        for m in args:
            if not re.fullmatch(r'[A-Za-z_][\w]*(?:\.[A-Za-z_][\w]*)*', m):
                raise ValueError('invalid module')
            rel = Path(m.replace('.', '/') + '.lean')
            p = W / 'run/formal' / rel
            q = dest / 'formal' / rel
            q.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(p, q)
            inputs['sources'].append({'path': str(p), 'sha256': sha(p)})
    else:
        rel = Path(args[0])
        if rel.is_absolute() or '..' in rel.parts or rel.suffix != '.sage':
            raise ValueError('expected .sage')
        p = W / 'run/sage' / rel
        q = dest / 'sage' / rel
        q.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(p, q)
        inputs['sources'].append({'path': str(p), 'sha256': sha(p)})
    (dest / 'SOURCE_INPUTS.json').write_text(json.dumps(inputs, indent=2) + '\n')
    receipts = []
    if mode == 'lean':
        for m in args:
            source = dest / 'formal' / (m.replace('.', '/') + '.lean')
            product = dest / 'lib' / (m.replace('.', '/') + '.olean')
            product.parent.mkdir(parents=True, exist_ok=True)
            rec = engine.step(dest, m.replace('.', '_'),
                [str(engine.LEAN), '-j1', '-M6144', '-o', str(product), str(source)], dest / 'formal', env)
            rec['source_sha256'] = sha(source)
            receipts.append(rec)
            if not rec['accepted'] or rec['cumulative_child_maxrss_kib'] > 8*1024*1024:
                break
            rec['olean_sha256'] = sha(product)
            cache = owncache / product.relative_to(dest / 'lib')
            cache.parent.mkdir(parents=True, exist_ok=True)
            for artifact in product.parent.glob(product.name + '*'):
                shutil.copyfile(artifact, cache.parent / artifact.name)
    else:
        rec = engine.step(dest, 'sage', [engine.SAGE, str(dest / 'sage' / args[0])] + args[1:], dest, env)
        rec['source_sha256'] = sha(dest / 'sage' / args[0])
        receipts.append(rec)
    (dest / 'RECEIPTS.json').write_text(json.dumps(receipts, indent=2) + '\n')
    return int(any(not r['accepted'] or r['cumulative_child_maxrss_kib'] > 8*1024*1024 for r in receipts))


if __name__ == '__main__':
    sys.exit(main())
