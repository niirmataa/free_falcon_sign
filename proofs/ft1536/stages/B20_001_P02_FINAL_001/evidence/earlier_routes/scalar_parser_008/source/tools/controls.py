#!/usr/bin/env python3
"""Run original-C and mutation controls; mathematics lives in word_helpers.sage."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
DEST = Path(os.environ['P02_DEST'])
BUILD = DEST / 'build'
INPUTS = Path(os.environ['P02_INPUTS'])
SAGE = '/home/footfalcon/.local/bin/sage'
records = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(name, argv, expected=0):
    out = BUILD / (name + '.stdout')
    err = BUILD / (name + '.stderr')
    start = datetime.datetime.now(datetime.timezone.utc).isoformat()
    t = time.monotonic()
    with out.open('wb') as so, err.open('wb') as se:
        p = subprocess.run(argv, stdout=so, stderr=se, timeout=600)
    rec = {'name': name, 'argv': argv, 'cwd': str(Path.cwd()), 'start': start,
           'stop': datetime.datetime.now(datetime.timezone.utc).isoformat(),
           'elapsed_s': time.monotonic() - t, 'exit_code': p.returncode,
           'expected_exit': expected, 'stdout': out.name, 'stdout_sha256': sha(out),
           'stderr': err.name, 'stderr_sha256': sha(err)}
    records.append(rec)
    (BUILD / 'CONTROL_RECEIPTS.json').write_text(json.dumps(records, indent=2) + '\n')
    print(name, 'exit', p.returncode, flush=True)
    assert p.returncode == expected, (name, err.read_text())
    return out, err


mode = sys.argv[1]
assert mode in ('normal', 'asan')
run('sage_version', [SAGE, '--version'])
run('sage_oracle', [SAGE, str(ROOT / 'checks/word_helpers.sage')])
oracle = json.loads((BUILD / 'word_oracle.json').read_text())
assert oracle['preparser'] and '10.9' in oracle['sage_version']
run('gcc_version', ['/usr/bin/gcc', '--version'])
cases = BUILD / 'word_cases.txt'
flags = ['-std=c99', '-O2', '-Wall', '-Wextra', '-Werror']
variants = {'asan': ['-fsanitize=address', '-fno-omit-frame-pointer']} if mode == 'asan' else {
    'normal': [], 'ubsan': ['-fsanitize=undefined', '-fno-sanitize-recover=all'],
}
for name, more in variants.items():
    exe = BUILD / name
    run(name + '_compile', ['/usr/bin/gcc', *flags, *more, '-I', str(INPUTS / 'source17'), str(ROOT / 'checks/word_helpers.c'), '-o', str(exe)])
    out, err = run(name + '_execute', [str(exe), str(cases)])
    result = json.loads(out.read_text())
    assert result == {'valid': oracle['valid_cases'], 'preflight_rejected': 2, 'pass': True}
    assert not err.read_bytes(), (name, 'unexpected diagnostic')

if mode == 'normal':
    original = (INPUTS / 'source17/fpr-emulated.h').read_text()
    mutations = {
        'middle_shift': ('x ^= (x ^ (x >> 32)) & -(uint64_t)(n >> 5);', 'x ^= (x ^ (x >> 31)) & -(uint64_t)(n >> 5);'),
        'count_mask': ('return x >> (n & 31);', 'return x >> (n & 30);'),
        'noop': ('return x >> (n & 31);', 'return x;'),
        'signed_logical': ('x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);\n\treturn x >> (n & 31);', 'x ^= (x ^ (x >> 32)) & -(int64_t)(n >> 5);\n\treturn (int64_t)((uint64_t)x >> (n & 31));'),
    }
    for name, (before, after) in mutations.items():
        directory = BUILD / ('mutation_' + name)
        directory.mkdir()
        assert before in original
        changed = original.replace(before, after, 1)
        header = directory / 'fpr-emulated.h'
        header.write_text(changed)
        header.chmod(0o444)
        exe = directory / 'control'
        run(name + '_compile', ['/usr/bin/gcc', *flags, '-I', str(directory), str(ROOT / 'checks/word_helpers.c'), '-o', str(exe)])
        out, err = run(name + '_execute', [str(exe), str(cases)], expected=1)
        assert 'MISMATCH' in err.read_text() and not out.read_bytes()
    empty = BUILD / 'empty_cases.txt'
    empty.write_text('')
    run('no_producer_rejected', [str(BUILD / 'normal'), str(empty)], expected=3)

(BUILD / 'CONTROL_RESULT.json').write_text(json.dumps({'mode': mode, 'pass': True, 'valid_cases': oracle['valid_cases'], 'steps': len(records), 'mutants_rejected': 4 if mode == 'normal' else 0}, indent=2) + '\n')
print('CONTROL_PASS', mode, oracle['valid_cases'])
