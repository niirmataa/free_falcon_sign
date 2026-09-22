#!/usr/bin/env python3
"""Independent transport/execution controller; no mathematical calculations.

Author scripts are unchanged. Compared with the author controller this clears
ALL regenerated artifacts and caches, retains raw streams and source hashes,
uses a W-only/network-off outer sandbox, and checks semantic/PDF steps too.
"""
import ast
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import resource
import shlex
import subprocess
import sys
import time

W = Path(__file__).resolve().parents[1]
IN = W / 'inputs'
SUBJECT = IN / 'subject'
REPO = Path('/home/footfalcon/free_falcon_sign')
DEST = W / 'replay/independent-001'
MIRROR = DEST / 'proofs/ft1536/work/pkg'
OUT_SHA = '9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e'
BUNDLE_SHA = '2ae164d9b3e338c9860b884e20c793855f1cdbb26e713283cc2fbbb3aa7edd7d'
SAGE = '/home/footfalcon/.local/bin/sage'
MPY = '/home/footfalcon/miniforge3/envs/sage/bin/python'
LEAN = '/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
START = time.monotonic()
RECEIPTS = []


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def emit(p, value):
    p = Path(p)
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(value, indent=2, sort_keys=True) + '\n')


def manifest(p):
    entries = {}
    for line in Path(p).read_text().splitlines():
        m = re.fullmatch(r'([0-9a-f]{64})  (.+)', line)
        assert m, line
        h, n = m.groups()
        assert not Path(n).is_absolute() and all(x not in ('', '.', '..') for x in n.split('/'))
        assert n not in entries
        entries[n] = h
    return entries


def checked_copy(source, target):
    source, target = Path(source), Path(target)
    assert source.is_file() and not source.is_symlink()
    target.parent.mkdir(parents=True, exist_ok=True)
    with target.open('xb') as f:
        f.write(source.read_bytes())
    assert sha(source) == sha(target)


def limit_memory():
    resource.setrlimit(resource.RLIMIT_AS, (8 * 1024**3, 8 * 1024**3))


def run(argv, label, cwd, capture=None, limit=5400):
    cwd = Path(cwd)
    remaining = 7200 - (time.monotonic() - START)
    assert remaining > 0, 'global review wall budget exhausted'
    timeout = min(limit, remaining)
    bound = {}
    for arg in argv[1:]:
        if arg.endswith(('.sage', '.py', '.lean')):
            p = Path(arg) if Path(arg).is_absolute() else cwd / arg
            if p.is_file():
                bound[str(p.relative_to(W))] = sha(p)
    env = os.environ.copy()
    env.update(HOME=str(DEST/'home'), TMPDIR=str(DEST/'tmp'),
               TMP=str(DEST/'tmp'), TEMP=str(DEST/'tmp'),
               DOT_SAGE=str(DEST/'cache/sage'), XDG_CACHE_HOME=str(DEST/'cache/xdg'),
               PYTHONPYCACHEPREFIX=str(DEST/'cache/python'), PYTHONDONTWRITEBYTECODE='1',
               PYTHONOPTIMIZE='0', PYTHONHASHSEED='0',
               FT1536_PKG_ROOT=str(MIRROR), LEAN_PATH=str(MIRROR/'.build/lean'),
               TEXMFVAR=str(DEST/'cache/texmf'), TEXMFCONFIG=str(DEST/'cache/texconfig'),
               MAMBA_ROOT_PREFIX='/home/footfalcon/miniforge3',
               OMP_NUM_THREADS='1', OPENBLAS_NUM_THREADS='1', MKL_NUM_THREADS='1')
    sandbox = ['/usr/bin/bwrap', '--die-with-parent', '--unshare-net', '--unshare-pid',
               '--ro-bind', '/', '/', '--bind', str(W), str(W),
               '--ro-bind', str(IN), str(IN),
               '--ro-bind', str(IN/'source17'), str(REPO/'Extra/c')]
    for old in ('FT_FAMILY_SCALING_CORRECTIONS_RUN_003',
                'FT_FAMILY_SEC_ESTIMATE_2026-09-22_RUN_001'):
        original = REPO/'proofs/ft1536/work'/old
        if original.exists():
            sandbox += ['--ro-bind', str(W/'empty'), str(original)]
    sandbox += ['--proc', '/proc', '--dev', '/dev', '--chdir', str(cwd), '--', *argv]
    t0 = time.monotonic()
    started = datetime.datetime.now(datetime.timezone.utc).isoformat()
    stdout = DEST/'raw'/f'{label}.stdout'
    stderr = DEST/'raw'/f'{label}.stderr'
    timed_out = False
    with stdout.open('xb') as out, stderr.open('xb') as err:
        child = subprocess.Popen(sandbox, cwd=W, env=env, stdin=subprocess.DEVNULL,
                                 stdout=out, stderr=err, preexec_fn=limit_memory)
        try:
            rc = child.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            child.kill()
            rc = child.wait()
            timed_out = True
    if capture is not None:
        p = cwd/capture
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_bytes(stdout.read_bytes() + stderr.read_bytes())
    after = {p: sha(W/p) for p in bound}
    rec = {'label': label, 'argv': argv, 'sandbox_argv': sandbox, 'cwd': str(cwd),
           'started_utc': started, 'elapsed_seconds': time.monotonic()-t0,
           'exit_code': rc, 'timed_out': timed_out,
           'source_before': bound, 'source_after': after,
           'sources_unchanged': bound == after,
           'stdout': str(stdout.relative_to(W)), 'stdout_sha256': sha(stdout),
           'stderr': str(stderr.relative_to(W)), 'stderr_sha256': sha(stderr)}
    RECEIPTS.append(rec)
    emit(DEST/'EXECUTION_RECEIPTS.json', RECEIPTS)
    print(json.dumps({'step': label, 'exit': rc, 'seconds': round(rec['elapsed_seconds'], 3)}), flush=True)
    assert bound == after, 'a source changed while executing'
    return rc


def main():
    assert not DEST.exists()
    assert sha(IN/'MANIFEST.sha256') == BUNDLE_SHA
    bundle = manifest(IN/'MANIFEST.sha256')
    actual = set()
    for p in IN.rglob('*'):
        assert not p.is_symlink()
        if p.is_file():
            actual.add(str(p.relative_to(IN)))
    assert actual == set(bundle) | {'MANIFEST.sha256'}
    for n, h in bundle.items():
        assert sha(IN/n) == h, n
    assert sha(SUBJECT/'OUTPUTS.sha256') == OUT_SHA
    outputs = manifest(SUBJECT/'OUTPUTS.sha256')
    assert len(outputs) == 100
    for n, h in outputs.items():
        assert sha(SUBJECT/n) == h, n
    tree = ast.parse((SUBJECT/'scripts/replay.py').read_text())
    steps = next(ast.literal_eval(node.value) for node in tree.body
                 if isinstance(node, ast.Assign) and any(isinstance(x, ast.Name) and x.id == 'STEPS' for x in node.targets))
    assert len(steps) == 16
    spec = json.loads((SUBJECT/'SEMANTIC_FILES.json').read_text())
    byte_targets = spec['byte_deterministic']
    semantic_targets = [x['path'] for x in spec['semantic_only']]
    assert len(byte_targets) == len(set(byte_targets)) == 18
    (W/'empty').mkdir(exist_ok=True)
    for folder in ('raw', 'home', 'tmp', 'cache'):
        (DEST/folder).mkdir(parents=True, exist_ok=False)
    for n in bundle:
        if n.startswith('subject/'):
            checked_copy(IN/n, MIRROR/n.removeprefix('subject/'))
        elif n.startswith('source17/'):
            checked_copy(IN/n, DEST/'Extra/c'/n.removeprefix('source17/'))
    (MIRROR/'.build/lean').mkdir(parents=True)
    removed_cache = []
    for p in list(MIRROR.rglob('*.pyc')):
        removed_cache.append({'path': str(p.relative_to(MIRROR)), 'sha256': sha(p)})
        p.unlink()
    remove = set(byte_targets + semantic_targets + ['paper/main.aux', 'paper/main.bbl',
                                                   'paper/main.blg', 'paper/main.log',
                                                   'paper/main.out'])
    removed = []
    for n in sorted(remove):
        p = MIRROR/n
        if p.exists():
            removed.append({'path': n, 'sha256': sha(p)})
            p.unlink()
    assert all(not (MIRROR/n).exists() for n in remove)
    emit(DEST/'FRESHNESS_START.json', {'source_outputs_validated_before_destination': len(outputs),
         'author_manifest_sha256': OUT_SHA, 'removed_generated': removed,
         'removed_cache': removed_cache, 'all_expected_products_absent': True,
         'author_source_scripts_unchanged': True})
    assert run([SAGE, '--version'], '00_sage_version', MIRROR, limit=90) == 0
    assert run([LEAN, '--version'], '00_lean_version', MIRROR, limit=60) == 0
    exits = []
    for i, (template, label, capture, required) in enumerate(steps, 1):
        command = template.replace('{py}', '/usr/bin/python3').replace('{sage}', SAGE).replace('{mpy}', MPY).replace('{lean}', LEAN)
        rc = run(shlex.split(command), f'{i:02d}_{label}', MIRROR, capture)
        exits.append({'step': label, 'exit_code': rc, 'author_required': required})
    pdf_steps = [(['pdflatex', '-interaction=nonstopmode', '-halt-on-error', '-no-shell-escape', 'main.tex'], 'pdf_1'),
                 (['bibtex', 'main'], 'bibtex'),
                 (['pdflatex', '-interaction=nonstopmode', '-halt-on-error', '-no-shell-escape', 'main.tex'], 'pdf_2'),
                 (['pdflatex', '-interaction=nonstopmode', '-halt-on-error', '-no-shell-escape', 'main.tex'], 'pdf_3')]
    pdf_exits = [run(argv, label, MIRROR/'paper', limit=300) for argv, label in pdf_steps]
    text_ok = False
    if (MIRROR/'paper/main.pdf').exists():
        rc1 = run(['pdftotext', str(MIRROR/'paper/main.pdf'), str(DEST/'rebuilt_pdf.txt')], 'pdf_text_new', W, limit=60)
        rc2 = run(['pdftotext', str(SUBJECT/'paper/main.pdf'), str(DEST/'author_pdf.txt')], 'pdf_text_original', W, limit=60)
        run(['pdfinfo', str(MIRROR/'paper/main.pdf')], 'pdf_info', W, limit=60)
        text_ok = rc1 == rc2 == 0 and (DEST/'rebuilt_pdf.txt').read_bytes() == (DEST/'author_pdf.txt').read_bytes()
    matches, mismatches = [], []
    for n in byte_targets:
        got = sha(MIRROR/n) if (MIRROR/n).is_file() else None
        row = {'path': n, 'expected': outputs[n], 'actual': got, 'match': got == outputs[n]}
        (matches if row['match'] else mismatches).append(row)
    extra = []
    for n in ('results/fft3_error.json', 'results/sage_exact.json'):
        got = sha(MIRROR/n) if (MIRROR/n).is_file() else None
        extra.append({'path': n, 'expected': outputs[n], 'actual': got, 'match': got == outputs[n]})
    remaining_absent = [n for n in semantic_targets if n != 'paper/compile.log' and not (MIRROR/n).is_file()]
    passed = not mismatches and all(x['exit_code'] == 0 for x in exits) and all(x['match'] for x in extra) and all(x == 0 for x in pdf_exits) and text_ok and not remaining_absent
    result = {'schema': 'S01_INDEPENDENT_INSTRUMENTED_REPLAY_V1',
              'result': 'FRESH_REPLAY_PASS' if passed else 'REPLAY_FAIL',
              'author_outputs_sha256': OUT_SHA, 'controller_sha256': sha(__file__),
              'scope': 'unchanged author proof sources; independent transport/controller with all-product/cache removal, all-step/PDF checks and raw receipts',
              'matches': matches, 'mismatches': mismatches, 'steps': exits,
              'extra_semantic_byte_checks': extra, 'semantic_products_missing': remaining_absent,
              'pdf_exits': pdf_exits, 'pdf_text_equal': text_ok,
              'elapsed_seconds': time.monotonic()-START}
    emit(DEST/'REPLAY_RESULT.json', result)
    assert sha(SUBJECT/'OUTPUTS.sha256') == OUT_SHA
    for n, h in outputs.items():
        assert sha(SUBJECT/n) == h
    print(json.dumps({'result': result['result'], 'matches': len(matches), 'mismatches': len(mismatches), 'seconds': result['elapsed_seconds']}), flush=True)
    return 0 if passed else 1


if __name__ == '__main__':
    try:
        raise SystemExit(main())
    except Exception as exc:
        if DEST.exists():
            emit(DEST/'CONTROLLER_FAILURE.json', {'type': type(exc).__name__, 'message': str(exc), 'elapsed_seconds': time.monotonic()-START})
        raise
