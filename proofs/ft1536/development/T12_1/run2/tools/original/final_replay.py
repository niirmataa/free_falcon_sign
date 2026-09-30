#!/usr/bin/env python3
"""Pinned source bundle -> fresh project cache; sequential network-off replay.

Python performs only orchestration, inventories and hashes. Mathematics is
in .sage with the standard preparser and Lean kernel-checked modules.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import sys


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1048576), b''):
            h.update(chunk)
    return h.hexdigest()


def write(path, value):
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def manifest(bundle, name, pin):
    path = bundle / name
    if sha(path) != pin:
        raise ValueError('external manifest mismatch')
    seen = set()
    for line in path.read_text().splitlines():
        expected, rel = line.split(maxsplit=1)
        p = Path(rel)
        if p.is_absolute() or '..' in p.parts or rel in seen:
            raise ValueError('unsafe/duplicate member: ' + rel)
        target = bundle / p
        if target.is_symlink() or not target.is_file() or sha(target) != expected:
            raise ValueError('member mismatch: ' + rel)
        seen.add(rel)
    return seen


def preflight():
    active = []
    for proc in Path('/proc').glob('[0-9]*'):
        if int(proc.name) == os.getpid():
            continue
        try:
            argv = [x.decode(errors='replace') for x in (proc / 'cmdline').read_bytes().split(b'\0') if x]
            if not argv:
                continue
            if Path(argv[0]).name in {'lean', 'lake', 'sage', 'sage-python'} or any(
                    Path(x).name in {'job.py', 'replay.py', 'final_replay.py', 'a3_job.py'} for x in argv[1:]):
                active.append({'pid': int(proc.name), 'cwd': str((proc / 'cwd').resolve()), 'argv': argv})
        except (OSError, PermissionError):
            continue
    return active


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bundle', required=True)
    ap.add_argument('--dest', required=True)
    ap.add_argument('--manifest', default='REPLAY_INPUTS.sha256')
    ap.add_argument('--manifest-sha', required=True)
    ap.add_argument('--library-map')
    args = ap.parse_args()
    bundle, dest = Path(args.bundle).resolve(), Path(args.dest).resolve()
    if dest.exists() or dest.is_relative_to(bundle) or bundle.is_relative_to(dest):
        raise ValueError('destination must be new and disjoint')
    if not str(dest).startswith(str(bundle.parent) + '/'):
        raise ValueError('all replay writes must stay under this physical W')
    members = manifest(bundle, args.manifest, args.manifest_sha)
    build = json.loads((bundle / 'BUILD.json').read_text())
    required = {'BUILD.json', 'FORMAL_EXPORTS.json', 'LIBRARY_CLOSURE.json', 'TOOLCHAIN.json',
                'tools/replay.py', 'tools/execution.py'}
    required.update('formal/' + m.replace('.', '/') + '.lean' for m in build['modules'])
    required.update('sage/' + s['source'] for s in build['sage'])
    if not required <= members:
        raise ValueError('replay inputs omitted from manifest: ' + repr(required - members))
    closure = json.loads((bundle / 'LIBRARY_CLOSURE.json').read_text())
    roots = json.loads(Path(args.library_map).read_text()) if args.library_map else closure['roots']
    for item in closure['modules']:
        root = roots[item['library']]
        rel = item['module'].replace('.', '/') + '.lean'
        if sha(Path(root['source']) / rel) != item['source_sha256'] or sha(bundle / item['source']) != item['source_sha256']:
            raise ValueError('library source mismatch: ' + item['module'])
        for artifact in item['artifacts']:
            if sha(Path(root['build']) / artifact['path']) != artifact['sha256']:
                raise ValueError('library cache mismatch: ' + item['module'])
    tc = json.loads((bundle / 'TOOLCHAIN.json').read_text())
    for k, pathkey, hashkey in [('lean', 'executable', 'sha256'), ('sage', 'launcher', 'launcher_sha256')]:
        if sha(Path(tc[k][pathkey])) != tc[k][hashkey]:
            raise ValueError('toolchain mismatch: ' + k)
    if active := preflight():
        print(json.dumps(active, indent=2))
        raise ValueError('active compute before replay')
    dest.mkdir()
    shutil.copyfile(bundle / 'tools/replay.py', dest / 'REPLAY_SOURCE.py')
    shutil.copyfile(bundle / 'tools/execution.py', dest / 'EXECUTION_SOURCE.py')
    for sub in ['lib', 'logs', 'tmp', 'home', 'cache', 'work']:
        (dest / sub).mkdir()
    shutil.copytree(bundle / 'formal', dest / 'formal')
    shutil.copytree(bundle / 'sage', dest / 'sage')
    spec = importlib.util.spec_from_file_location('execution', bundle / 'tools/execution.py')
    execution = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(execution)
    execution.LEAN = Path(tc['lean']['executable'])
    env = os.environ.copy()
    env.update(HOME=str(dest / 'home'), TMPDIR=str(dest / 'tmp'), TMP=str(dest / 'tmp'),
        TEMP=str(dest / 'tmp'), DOT_SAGE=str(dest / 'home/.sage'), XDG_CACHE_HOME=str(dest / 'cache'),
        MPLCONFIGDIR=str(dest / 'cache/mpl'), PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1',
        OMP_NUM_THREADS='1', LEAN_PATH=':'.join([str(dest / 'lib')] +
            [v['build'] for k, v in roots.items() if k != 'lean']))
    receipts, comparisons = [], []
    status = 'FAIL'

    def step(name, argv, cwd, source=None):
        active = preflight()
        write(dest / 'logs' / (name + '.preflight.json'), {'utc': datetime.now(timezone.utc).isoformat(), 'active': active})
        if active:
            raise RuntimeError('active other compute before ' + name)
        rec = execution.step(dest, name, argv, cwd, env)
        if source:
            rec['source'] = str(source.relative_to(dest))
            rec['source_sha256'] = sha(source)
        receipts.append(rec)
        write(dest / 'EXECUTION_RECEIPTS.json', {'status': 'RUNNING', 'jobs': receipts})
        if not rec['accepted'] or rec['cumulative_child_maxrss_kib'] > 8*1024*1024:
            raise RuntimeError('rejected step: ' + name)
        return rec

    try:
        step('lean_version', [tc['lean']['executable'], '--version'], dest)
        step('sage_version', [tc['sage']['launcher'], '--version'], dest)
        for s in build['sage']:
            name = s['name']
            cwd = dest / 'work' / name
            cwd.mkdir()
            source = dest / 'sage' / s['source']
            for generated in s.get('generated', []):
                if (cwd / generated['product']).exists():
                    raise ValueError('producer output unexpectedly present')
            step(name, [tc['sage']['launcher'], str(source)] + s.get('args', []), cwd, source)
            for generated in s.get('generated', []):
                produced = cwd / generated['product']
                expected = bundle / generated['expected']
                ok = sha(produced) == sha(expected)
                comparisons.append({'product': str(produced.relative_to(dest)), 'expected': generated['expected'],
                                    'actual_sha256': sha(produced), 'expected_sha256': sha(expected), 'match': ok})
                if not ok:
                    raise ValueError('producer/source mismatch: ' + generated['product'])
                if generated['expected'].startswith('formal/'):
                    shutil.copyfile(produced, dest / generated['expected'])
        for module in build['modules']:
            source = dest / 'formal' / (module.replace('.', '/') + '.lean')
            obj = dest / 'lib' / (module.replace('.', '/') + '.olean')
            obj.parent.mkdir(parents=True, exist_ok=True)
            if obj.exists():
                raise ValueError('fresh module cache contaminated: ' + module)
            rec = step(module.replace('.', '_'), [tc['lean']['executable'], '-j1', '-M6144', '-o', str(obj), str(source)],
                       dest / 'formal', source)
            rec['olean_sha256'] = sha(obj)
        audit = (dest / 'logs/FinalAudit.stdout').read_text()
        exports = json.loads((bundle / 'FORMAL_EXPORTS.json').read_text())['exports']
        observed = {}
        for match in re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)", audit):
            observed[match[1]] = [x.strip() for x in (match[2] or '').split(',') if x.strip()]
        if set(observed) != {x['name'] for x in exports}:
            raise ValueError('incomplete axiom inventory')
        if any(set(v) - {'propext', 'Classical.choice', 'Quot.sound'} for v in observed.values()):
            raise ValueError('unexpected proof axiom')
        write(dest / 'AXIOMS.json', observed)
        manifest(bundle, args.manifest, args.manifest_sha)
        status = 'PASS'
    finally:
        write(dest / 'EXECUTION_RECEIPTS.json', {'status': status, 'jobs': receipts})
        write(dest / 'REPLAY_RESULT.json', {'status': status, 'external_manifest_sha256': args.manifest_sha,
            'project_cache_fresh': True, 'library_cache_rebuilt': False, 'network': 'bwrap --unshare-net',
            'modules_expected': len(build['modules']), 'jobs_completed': len(receipts),
            'all_source_and_producer_comparisons': comparisons,
            'exports_expected': len(json.loads((bundle / 'FORMAL_EXPORTS.json').read_text())['exports'])})
    print('FRESH_REPLAY_PASS', len(build['modules']), 'modules', flush=True)


if __name__ == '__main__':
    main()
