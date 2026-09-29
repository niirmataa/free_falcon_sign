#!/usr/bin/env python3
from pathlib import Path
import datetime
import hashlib
import json
import os
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[1]
BUILD = Path(os.environ['P02_DEST']) / 'build'
IN = Path(os.environ['P02_INPUTS']) / 'source17'
records = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(name, argv, expected=0):
    out, err = BUILD / (name + '.stdout'), BUILD / (name + '.stderr')
    start = datetime.datetime.now(datetime.timezone.utc).isoformat()
    t = time.monotonic()
    with out.open('wb') as so, err.open('wb') as se:
        p = subprocess.run(argv, stdout=so, stderr=se, timeout=600)
    records.append({'name': name, 'argv': argv, 'start': start,
                    'stop': datetime.datetime.now(datetime.timezone.utc).isoformat(),
                    'elapsed_s': time.monotonic() - t, 'exit_code': p.returncode,
                    'expected_exit': expected, 'stdout': out.name, 'stderr': err.name,
                    'stdout_sha256': sha(out), 'stderr_sha256': sha(err)})
    (BUILD / 'LE_CONTROL_RECEIPTS.json').write_text(json.dumps(records, indent=2) + '\n')
    assert p.returncode == expected, (name, err.read_text())
    print(name, p.returncode, flush=True)
    return out, err


mode = sys.argv[1]
assert mode in ('normal', 'asan')
run('sage_le', ['/home/footfalcon/.local/bin/sage', str(ROOT / 'checks/little_endian.sage')])
oracle = json.loads((BUILD / 'le_oracle.json').read_text())
assert oracle['sage_version'] == '10.9' and oracle['preparser']
flags = ['-std=c99', '-O2', '-Wall', '-Wextra', '-Werror']
variants = {'asan': ['-fsanitize=address', '-fno-omit-frame-pointer']} if mode == 'asan' else {
    'normal': [], 'ubsan': ['-fsanitize=undefined', '-fno-sanitize-recover=all']}
for name, more in variants.items():
    exe = BUILD / name
    run(name + '_compile', ['/usr/bin/gcc', *flags, *more, '-I', str(IN), str(ROOT / 'checks/little_endian.c'), '-o', str(exe)])
    out, err = run(name + '_execute', [str(exe), str(BUILD / 'le_cases.txt')])
    assert json.loads(out.read_text()) == {'pass': True, 'cases': oracle['valid_cases']}
    assert not err.read_bytes()
if mode == 'normal':
    original = (IN / 'shake.c').read_text()
    mutations = {
        'decode_index': ('((uint64_t)buf[7] << 56)', '((uint64_t)buf[6] << 56)'),
        'encode_shift': ('buf[7] = (unsigned char)(x >> 56);', 'buf[7] = (unsigned char)(x >> 48);'),
        'encode_frame': ('buf[7] = (unsigned char)(x >> 56);', 'buf[8] = (unsigned char)(x >> 56);'),
    }
    for name, (old, new) in mutations.items():
        assert original.count(old) == 1
        d = BUILD / name
        d.mkdir()
        (d / 'shake.c').write_text(original.replace(old, new))
        (d / 'shake.c').chmod(0o444)
        run(name + '_compile', ['/usr/bin/gcc', *flags, '-I', str(d), '-I', str(IN), str(ROOT / 'checks/little_endian.c'), '-o', str(d / 'control')])
        _, err = run(name + '_execute', [str(d / 'control'), str(BUILD / 'le_cases.txt')], 1)
        assert 'MISMATCH' in err.read_text()
(BUILD / 'LE_CONTROL_RESULT.json').write_text(json.dumps({'pass': True, 'mode': mode,
    'cases': oracle['valid_cases'], 'mutations': 3 if mode == 'normal' else 0}, indent=2) + '\n')
