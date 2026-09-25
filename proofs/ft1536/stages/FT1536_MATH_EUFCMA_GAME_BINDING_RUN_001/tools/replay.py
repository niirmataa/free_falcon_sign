#!/usr/bin/env python3
"""Read-only sealed bundle -> NEW durable destination. Organization/hashes, no math in Python."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import shutil
import subprocess
import time

# External RO source root for library source cross-checks (pinned bundle of the
# predecessor; artifacts come from the pinned RO build cache roots).
PREV_BUNDLE = Path('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/'
                   'FT1536_MATH_EUFCMA_MTISIS_RUN_001/output')

def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()

def now():
    return datetime.now(timezone.utc).isoformat()

def verify_manifest(bundle, manifest, pin):
    assert sha(manifest) == pin, 'EXTERNAL_MANIFEST_PIN_MISMATCH'
    checked = []
    for line in manifest.read_text().splitlines():
        h, name = line.split(maxsplit=1)
        name = name.lstrip('*')
        rel = Path(name)
        assert not rel.is_absolute() and '..' not in rel.parts, (name, 'unsafe member')
        p = bundle / rel
        assert p.is_file() and not p.is_symlink(), ('missing/nonregular', name)
        assert p.resolve().is_relative_to(bundle.resolve()), (name, 'escape')
        assert sha(p) == h, ('MEMBER_PIN_MISMATCH', name)
        checked.append(name)
    return checked

def run_step(dest, name, argv, cwd, env):
    logs = dest / 'logs'
    out, err = logs / (name + '.stdout'), logs / (name + '.stderr')
    sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net',
               '--ro-bind', '/', '/', '--dev-bind', '/dev', '/dev',
               '--bind', str(dest), str(dest), '--bind', str(dest / 'tmp'), '/tmp',
               '--chdir', str(cwd),
               '/usr/bin/prlimit', '--as=12884901888', '--']
    start, t0 = now(), time.monotonic()
    with out.open('wb') as fo, err.open('wb') as fe:
        try:
            p = subprocess.run(sandbox + argv, env=env, stdout=fo, stderr=fe, timeout=1800)
            code = p.returncode
        except subprocess.TimeoutExpired:
            code = 124
    text = out.read_text(errors='replace')
    rec = dict(name=name, argv=argv, sandbox_argv=sandbox, cwd=str(cwd), start=start,
               stop=now(), elapsed_s=round(time.monotonic() - t0, 3), exit_code=code,
               wall_limit_s=1800, network='bwrap --unshare-net',
               address_space_bytes=12884901888, lean_heap_MiB=6144,
               cumulative_child_maxrss_kib=resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss,
               stdout=str(out.relative_to(dest)), stderr=str(err.relative_to(dest)),
               stdout_sha256=sha(out), stderr_sha256=sha(err))
    (logs / (name + '.receipt.json')).write_text(json.dumps(rec, indent=2) + '\n')
    print(f'{name}: exit={code} {rec["elapsed_s"]}s', flush=True)
    assert code == 0, ('JOB_FAILED', name, code)
    assert err.stat().st_size == 0, ('STDERR_NOT_CLEAN', name)
    assert 'warning:' not in text and 'error:' not in text, ('UNCLEAN_LEAN_LOG', name)
    assert rec['cumulative_child_maxrss_kib'] <= 8 * 1024 * 1024, 'RSS_BUDGET_EXCEEDED'
    return rec

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bundle', required=True)
    ap.add_argument('--dest', required=True)
    ap.add_argument('--manifest', default='OUTPUTS.sha256')
    ap.add_argument('--manifest-sha', required=True)
    ap.add_argument('--library-map', help='optional relocation JSON: library -> {source,build}')
    ap.add_argument('--verify-only', action='store_true')
    args = ap.parse_args()
    bundle = Path(args.bundle).resolve()
    dest = Path(args.dest).resolve()
    manifest = bundle / args.manifest
    checked = verify_manifest(bundle, manifest, args.manifest_sha)
    required = ['BUILD.json', 'FORMAL_EXPORTS.json', 'LIBRARY_CLOSURE.json', 'TOOLCHAIN.json',
                'EXPECTED.json', 'tools/replay.py', 'sage/check_games.sage']
    required += [str(p.relative_to(bundle)) for p in (bundle / 'formal').rglob('*.lean')]
    assert set(required) <= set(checked), 'MANIFEST_OMITS_REPLAY_INPUTS'
    assert not dest.exists(), 'DEST_MUST_BE_NEW'
    assert not dest.is_relative_to(bundle) and not bundle.is_relative_to(dest), 'DEST_OVERLAPS_BUNDLE'
    # Disallowed-path guard: DEST must be durable work of THIS run (outside the
    # repo, per owner decision), never system tmp and never the repo tree.
    assert 'run/replays' in str(dest), 'DEST_MUST_BE_UNDER_W_RUN_REPLAYS'
    assert '/tmp/' not in str(dest), 'NO_SYSTEM_TMP'
    assert 'free_falcon_sign' not in str(dest), 'NO_REPO_PATH_FOR_RUN'
    closure = json.loads((bundle / 'LIBRARY_CLOSURE.json').read_text())
    roots = closure['roots']
    if args.library_map:
        roots = json.loads(Path(args.library_map).read_text())
    artifacts = 0
    for item in closure['modules']:
        roots_item = roots[item['library']]
        relative = item['module'].replace('.', '/') + '.lean'
        src = Path(roots_item['source']) / relative
        if not src.is_file():
            src = PREV_BUNDLE / item['source']
        assert sha(src) == item['source_sha256'], ('LIBRARY_SOURCE_CHANGED', item['module'])
        for art in item['artifacts']:
            assert sha(Path(roots_item['build']) / art['path']) == art['sha256'], \
                ('CACHE_PIN_MISMATCH', item['module'], art['path'])
            artifacts += 1
    print(f'MANIFEST_PASS {len(checked)} members; LIBRARY_PASS {len(closure["modules"])} '
          f'modules/{artifacts} artifacts', flush=True)
    if args.verify_only:
        print('NO_OP_VERIFY_PASS', flush=True)
        return
    dest.mkdir(parents=True, exist_ok=False)
    for sub in ['logs', 'tmp', 'home', 'cache', 'lib', 'work']:
        (dest / sub).mkdir()
    shutil.copytree(bundle / 'formal', dest / 'formal')
    shutil.copytree(bundle / 'sage', dest / 'sage')
    env = os.environ.copy()
    env.update(HOME=str(dest / 'home'), TMPDIR=str(dest / 'tmp'), TMP=str(dest / 'tmp'),
               TEMP=str(dest / 'tmp'), DOT_SAGE=str(dest / 'home/.sage'),
               XDG_CACHE_HOME=str(dest / 'cache'), MPLCONFIGDIR=str(dest / 'cache/mpl'),
               PYTHONDONTWRITEBYTECODE='1', OPENBLAS_NUM_THREADS='1', OMP_NUM_THREADS='1',
               LEAN_PATH=':'.join([str(dest / 'lib')] +
                                  [v['build'] for v in roots.values() if v.get('build')]))
    tc = json.loads((bundle / 'TOOLCHAIN.json').read_text())
    lean = tc['lean']['executable']
    sage = tc['sage']['launcher']
    assert sha(Path(lean)) == tc['lean']['sha256'], 'LEAN_BINARY_CHANGED'
    assert sha(Path(sage)) == tc['sage']['launcher_sha256'], 'SAGE_LAUNCHER_CHANGED'
    receipts = []
    status = 'FAIL'
    try:
        receipts.append(run_step(dest, 'lean_version', [lean, '--version'], dest / 'work', env))
        receipts.append(run_step(dest, 'sage_version', [sage, '--version'], dest / 'work', env))
        receipts.append(run_step(dest, 'sage_controls', [sage, str(dest / 'sage/check_games.sage')],
                                 dest / 'work', env))
        generated = dest / 'work/generated/GameCertificate.lean'
        assert sha(generated) == sha(bundle / 'formal/FT1536/GameCertificate.lean'), \
            'SAGE_LEAN_CERTIFICATE_MISMATCH'
        shutil.copyfile(generated, dest / 'formal/FT1536/GameCertificate.lean')
        build = json.loads((bundle / 'BUILD.json').read_text())
        for mod in build['modules']:
            source = dest / 'formal' / (mod.replace('.', '/') + '.lean')
            obj = dest / 'lib' / (mod.replace('.', '/') + '.olean')
            obj.parent.mkdir(parents=True, exist_ok=True)
            rec = run_step(dest, mod.replace('.', '_'),
                           [lean] + build['lean_flags'] + ['-o', str(obj), str(source)],
                           dest / 'formal', env)
            rec.update(source_sha256=sha(source), olean_sha256=sha(obj))
            receipts.append(rec)
        expected = json.loads((bundle / 'EXPECTED.json').read_text())
        comparisons = []
        for rel, h in expected['products'].items():
            actual = sha(dest / rel)
            comparisons.append(dict(product=rel, expected=h, actual=actual, match=actual == h))
        assert all(c['match'] for c in comparisons), 'SEMANTIC_PRODUCT_MISMATCH'
        audit = (dest / 'logs/Audit.stdout').read_text()
        axioms = {}
        for m in re.finditer(r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)",
                             audit):
            axioms[m.group(1)] = [re.sub(r'\.\{[^}]+\}', '', s.strip())
                                  for s in (m.group(2) or '').split(',') if s.strip()]
        names = [e['name'] for e in
                 json.loads((bundle / 'FORMAL_EXPORTS.json').read_text())['exports']]
        assert set(axioms) == set(names), ('INCOMPLETE_AXIOM_AUDIT', len(axioms), len(names))
        allowed = {'propext', 'Classical.choice', 'Quot.sound'}
        assert all(set(a) <= allowed for a in axioms.values()), 'UNEXPECTED_AXIOM'
        (dest / 'AXIOMS.json').write_text(json.dumps(axioms, indent=1, sort_keys=True) + '\n')
        status = 'PASS'
        summary = dict(status=status, manifest=args.manifest,
                       external_manifest_sha256=args.manifest_sha,
                       checked_members=len(checked), library_modules=len(closure['modules']),
                       library_artifacts=artifacts, exports_audited=len(names),
                       comparisons=comparisons, own_cache_fresh=True,
                       inputs_and_outputs_in_new_dest=True,
                       network='bwrap --unshare-net', receipts=receipts)
        (dest / 'REPLAY_RESULT.json').write_text(json.dumps(summary, indent=2) + '\n')
    finally:
        (dest / 'EXECUTION_RECEIPTS.json').write_text(
            json.dumps(dict(status=status, jobs=receipts), indent=2) + '\n')
        (dest / 'SAGE_RUNS.json').write_text(
            json.dumps([r for r in receipts if r['name'].startswith('sage')], indent=2) + '\n')
        (dest / 'COMMANDS.log').write_text(''.join(json.dumps(r) + '\n' for r in receipts))
    verify_manifest(bundle, manifest, args.manifest_sha)
    print('FRESH_REPLAY_PASS', flush=True)

if __name__ == '__main__':
    main()
