#!/usr/bin/env python3
"""Run original-C scalar controls and mutation controls; mathematics lives in scalar.sage."""
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
    (BUILD / 'SCALAR_CONTROL_RECEIPTS.json').write_text(json.dumps(records, indent=2) + '\n')
    print(name, 'exit', p.returncode, flush=True)
    assert p.returncode == expected, (name, err.read_text())
    return out, err


mode = sys.argv[1]
assert mode in ('normal', 'asan')
run('sage_version', [SAGE, '--version'])
run('sage_oracle', [SAGE, str(ROOT / 'checks/scalar.sage')])
oracle = json.loads((BUILD / 'scalar_oracle.json').read_text())
assert oracle['preparser'] and '10.9' in oracle['sage_version']
run('gcc_version', ['/usr/bin/gcc', '--version'])
cases = BUILD / 'scalar_cases.txt'
flags = ['-std=c99', '-O2', '-Wall', '-Wextra', '-Werror']
csrc = [str(ROOT / 'checks/scalar_controls.c'), str(INPUTS / 'source17/fpr-emulated.c')]
variants = {'asan': ['-fsanitize=address', '-fno-omit-frame-pointer']} if mode == 'asan' else {
    'normal': [], 'ubsan': ['-fsanitize=undefined', '-fno-sanitize-recover=all'],
}
for name, more in variants.items():
    exe = BUILD / ('scalar_' + name)
    run(name + '_compile', ['/usr/bin/gcc', *flags, *more, '-I', str(INPUTS / 'source17'), *csrc, '-o', str(exe)])
    out, err = run(name + '_execute', [str(exe), str(cases)])
    result = json.loads(out.read_text())
    assert result == {'valid_in': oracle['in_cases'], 'valid_obs': oracle['obs_cases'],
                      'rejected': oracle['reject_cases'], 'pass': True}, (name, result)
    assert not err.read_bytes(), (name, 'unexpected diagnostic')

if mode == 'normal':
    original = (INPUTS / 'source17/fpr-emulated.h').read_text()
    mutations = {
        'shift': ('m = ((x << 10) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);',
                  'm = ((x << 11) | ((uint64_t)1 << 62)) & (((uint64_t)1 << 63) - 1);'),
        'rounding_rint': ('m = fpr_ursh(m, e) + (uint64_t)((0xC8U >> f) & 1U);',
                          'm = fpr_ursh(m, e) + (uint64_t)((0xC9U >> f) & 1U);'),
        'sign_neg': ('x ^= (uint64_t)1 << 63;\n\treturn x;',
                     'x ^= (uint64_t)1 << 62;\n\treturn x;'),
        'floor_mask': ('mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);',
                       'mask = -(uint64_t)((uint32_t)(63 - cc) >> 30);'),
        'rounding_pack': ('x += (0xC8U >> f) & 1;',
                          'x += (0xC9U >> f) & 1;'),
    }
    for name, (before, after) in mutations.items():
        directory = BUILD / ('scalar_mutation_' + name)
        directory.mkdir()
        assert before in original, name
        changed = original.replace(before, after, 1)
        header = directory / 'fpr-emulated.h'
        header.write_text(changed)
        header.chmod(0o444)
        exe = directory / 'control'
        run(name + '_compile', ['/usr/bin/gcc', *flags, '-I', str(directory), '-I', str(INPUTS / 'source17'), *csrc, '-o', str(exe)])
        out, err = run(name + '_execute', [str(exe), str(cases)], expected=1)
        assert 'MISMATCH' in err.read_text() and not out.read_bytes()
    empty = BUILD / 'scalar_empty_cases.txt'
    empty.write_text('')
    run('no_producer_rejected', [str(BUILD / 'scalar_normal'), str(empty)], expected=3)

(BUILD / 'SCALAR_CONTROL_RESULT.json').write_text(json.dumps({'mode': mode, 'pass': True, 'in_cases': oracle['in_cases'], 'obs_cases': oracle['obs_cases'], 'steps': len(records), 'mutants_rejected': 5 if mode == 'normal' else 0}, indent=2) + '\n')
print('SCALAR_CONTROL_PASS', mode, oracle['in_cases'], oracle['obs_cases'])
