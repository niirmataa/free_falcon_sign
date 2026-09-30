#!/usr/bin/env python3
"""Execution, snapshots and hashes only. Mathematical computations live in Lean/Sage."""
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone

W = Path(__file__).resolve().parent.parent
LIB = W.parents[0] / 'B20_001/P01/bootstrap/mathlib4'
LEAN = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean')
SAGE = '/home/footfalcon/.local/bin/sage'

def sha(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()

def now():
    return datetime.now(timezone.utc).isoformat()

def paths(lib):
    return [str(lib / '.lake/build/lib/lean')] + [str(p) for p in sorted(
        (lib.parents[1] / 'run/.lake/packages').glob('*/.lake/build/lib/lean'))]

def env_for(dest, lib=LIB):
    env = os.environ.copy()
    for key, sub in [('HOME', 'home'), ('TMPDIR', 'tmp'), ('TMP', 'tmp'),
                     ('TEMP', 'tmp'), ('DOT_SAGE', 'home/.sage'),
                     ('XDG_CACHE_HOME', 'cache'), ('MPLCONFIGDIR', 'cache/mpl')]:
        p = dest / sub
        p.mkdir(parents=True, exist_ok=True)
        env[key] = str(p)
    env.update(PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1',
               OMP_NUM_THREADS='1', LEAN_PATH=':'.join([str(dest / 'lib')] + paths(lib)))
    return env

def step(dest, name, argv, cwd, env):
    requested_argv = list(argv)
    argv = list(argv)
    lean_positions = [i for i, arg in enumerate(argv) if arg == str(LEAN)]
    if lean_positions and not any(arg.startswith('-DwarningAsError=') for arg in argv):
        argv.insert(lean_positions[0] + 1, '-DwarningAsError=true')
    logs = dest / 'logs'
    logs.mkdir(exist_ok=True)
    out, err = logs / (name + '.stdout'), logs / (name + '.stderr')
    sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net',
               '--ro-bind', '/', '/', '--dev-bind', '/dev', '/dev',
               '--bind', str(dest), str(dest), '--bind', str(dest / 'tmp'), '/tmp',
               '--chdir', str(cwd), '/usr/bin/prlimit', '--as=12884901888', '--']
    start, t0 = now(), time.monotonic()
    timed_out = False
    with out.open('wb') as fo, err.open('wb') as fe:
        try:
            p = subprocess.run(sandbox + argv, env=env, stdout=fo, stderr=fe, timeout=1800)
            code = p.returncode
        except subprocess.TimeoutExpired:
            code, timed_out = 124, True
    stdout_text, stderr_text = out.read_text(errors='replace'), err.read_text(errors='replace')
    forbidden = sorted(set(re.findall(r'\bsorryAx\b|Lean\.ofReduceBool|\bnative_decide\b',
                                      stdout_text + '\n' + stderr_text)))
    clean_log = not stderr_text and not re.search(r'\b(?:warning|error):', stdout_text)
    accepted = code == 0 and clean_log and not forbidden
    rec = dict(name=name, argv=argv, requested_argv=requested_argv, sandbox_argv=sandbox, cwd=str(cwd), start=start,
                stop=now(), elapsed_s=round(time.monotonic()-t0, 3), exit_code=code,
                accepted=accepted, clean_log=bool(clean_log), forbidden_proof_markers=forbidden,
               timeout=timed_out, wall_limit_s=1800, address_space_bytes=12884901888,
               normal_rss_budget_bytes=8589934592,
               network='bwrap --unshare-net', stdout=str(out.relative_to(dest)),
               stderr=str(err.relative_to(dest)), stdout_sha256=sha(out), stderr_sha256=sha(err),
               cumulative_child_maxrss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
    (logs / (name + '.receipt.json')).write_text(json.dumps(rec, indent=2)+'\n')
    print(f'{name}: exit={code}, accepted={accepted}, {rec["elapsed_s"]}s', flush=True)
    if not accepted:
        for log in [out, err]:
            lines = log.read_text(errors='replace').splitlines()
            print('\n'.join(lines[:80]))
            if len(lines) > 80:
                print(f'Preview: 80/{len(lines)} lines; full raw log: {log}', flush=True)
    return rec

def main():
    mode, label, *args = sys.argv[1:]
    if not re.fullmatch(r'[A-Za-z0-9_]+', label):
        raise ValueError('job label must be a single directory name')
    dest = W / 'run' / label
    dest.mkdir(exist_ok=False)
    shutil.copyfile(Path(__file__), dest / 'RUNNER_SOURCE.py')
    inputs = {'runner_sha256': sha(Path(__file__)), 'sources': [], 'shared_cache': []}
    if mode == 'lean':
        for module in args:
            if not re.fullmatch(r'[A-Za-z_][\w]*(?:\.[A-Za-z_][\w]*)*', module):
                raise ValueError('invalid Lean module: ' + module)
            rel = Path(module.replace('.', '/') + '.lean')
            src = W / 'run/formal' / rel
            dst = dest / 'formal' / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(src, dst)
            inputs['sources'].append({'path': str(src), 'sha256': sha(src)})
        # Development imports use one shared cache, read-only in the sandbox.
        # A final clean replay uses its separate fresh-build driver.
        for p in sorted((W / 'run/devlib').rglob('*.olean')):
            inputs['shared_cache'].append({'path': str(p), 'sha256': sha(p)})
    elif mode == 'sage':
        rel = Path(args[0])
        if rel.is_absolute() or '..' in rel.parts or rel.suffix != '.sage':
            raise ValueError('expected a relative Sage source path')
        src = W / 'run/sage' / rel
        dst = dest / 'sage' / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dst)
        inputs['sources'].append({'path': str(src), 'sha256': sha(src)})
    (dest / 'lib').mkdir()
    if mode == 'lean':
        # Lean resolves a namespace from its first matching search root. A
        # partial Run2 directory therefore masks Run2 modules in later roots.
        # Present one complete import tree without copying the shared cache.
        # Outputs of this job are deliberately excluded: Lean must create local
        # files, never follow a symlink to overwrite the read-only shared cache.
        rebuilt = {module.replace('.', '/') + '.olean' for module in args}
        for p in sorted((W / 'run/devlib').rglob('*.olean')):
            rel = p.relative_to(W / 'run/devlib')
            if rel.as_posix() in rebuilt:
                continue
            link = dest / 'lib' / rel
            link.parent.mkdir(parents=True, exist_ok=True)
            link.symlink_to(p)
    env = env_for(dest)
    if mode == 'lean':
        env['LEAN_PATH'] = ':'.join([str(dest / 'lib'), str(W / 'run/devlib')] + paths(LIB))
    (dest / 'SOURCE_INPUTS.json').write_text(json.dumps(inputs, indent=2)+'\n')
    recs = []
    if mode == 'lean':
        for module in args:
            src = dest / 'formal' / (module.replace('.', '/') + '.lean')
            artifact = dest / 'lib' / (module.replace('.', '/') + '.olean')
            artifact.parent.mkdir(parents=True, exist_ok=True)
            lean_argv = [str(LEAN), '-j1', '-M6144', '-o', str(artifact), str(src)]
            if env.get('FT1536_LEAN_PROFILE') == '1':
                lean_argv.insert(1, '--profile')
            rec = step(dest, module.replace('.', '_'), lean_argv, dest / 'formal', env)
            rec['source_sha256'] = sha(src)
            recs.append(rec)
            if not rec['accepted']:
                break
            cache = W / 'run/devlib' / (module.replace('.', '/') + '.olean')
            cache.parent.mkdir(parents=True, exist_ok=True)
            for product in artifact.parent.glob(artifact.name + '*'):
                shutil.copyfile(product, cache.parent / product.name)
    elif mode == 'sage':
        recs.append(step(dest, 'sage', [SAGE, str(dest / 'sage' / args[0])] + args[1:], dest, env))
    else:
        recs.append(step(dest, 'command', args, dest, env))
    (dest / 'RECEIPTS.json').write_text(json.dumps(recs, indent=2)+'\n')
    return int(any(not r['accepted'] for r in recs))

if __name__ == '__main__':
    sys.exit(main())
