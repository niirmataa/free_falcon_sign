#!/usr/bin/env python3
"""Negative controls of the replay driver. Each mutation must be rejected;
the correct no-op must pass. Python is organization only (no math)."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

W = Path(__file__).resolve().parent.parent.parent      # .../FT1536_..._RUN_001
BUNDLE = W / 'output'
WORK = W / 'run/guards_001'
PIN_FILE = W / 'run/REPLAY_SEED_PIN.txt'

def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

def invoke(dest, manifest, pin, extra=None, fixture=None):
    bundle = fixture if fixture else BUNDLE
    argv = [sys.executable, '-B', str((fixture if fixture else BUNDLE) / 'tools/replay.py'),
            '--bundle', str(bundle), '--dest', str(dest),
            '--manifest', manifest, '--manifest-sha', pin] + (extra or [])
    return subprocess.run(argv, capture_output=True, text=True, timeout=1800)

def record(name, res, expect_ok):
    ok = (res.returncode == 0)
    out = WORK / 'guard_controls'
    (out / f'{name}.stdout').write_text(res.stdout)
    (out / f'{name}.stderr').write_text(res.stderr)
    passed = ok == expect_ok
    print(f'{name}: exit={res.returncode} expected_ok={expect_ok} -> '
          f'{"PASS" if passed else "FAIL"}')
    return dict(name=name, exit_code=res.returncode, expected_ok=expect_ok,
                passed=passed, stdout=str(out / f'{name}.stdout'),
                stderr=str(out / f'{name}.stderr'))

def main():
    pin = PIN_FILE.read_text().strip()
    WORK.mkdir(parents=True, exist_ok=True)
    (WORK / 'guard_controls').mkdir(exist_ok=True)
    results = []
    base_dest = W / 'run/replays'

    # 0. correct no-op must pass (verification only)
    res = invoke(base_dest / 'noop_guard', 'REPLAY_SEED.sha256', pin, extra=['--verify-only'])
    results.append(record('correct_noop', res, True))

    # 1. wrong external pin
    res = invoke(base_dest / 'guard_wrong_pin', 'REPLAY_SEED.sha256', '0' * 64)
    results.append(record('wrong_external_pin', res, False))

    # 2. modified member (fixture copy of the bundle with one byte changed)
    fixture = WORK / 'fixture'
    if fixture.exists():
        shutil.rmtree(fixture)
    shutil.copytree(BUNDLE, fixture, symlinks=True)
    tgt = fixture / 'BUILD.json'
    tgt.write_text(tgt.read_text() + '\n')
    res = invoke(base_dest / 'guard_modified', 'REPLAY_SEED.sha256', sha(W / 'run/REPLAY_SEED.sha256'),
                 fixture=fixture)
    results.append(record('modified_member', res, False))

    # 3. incomplete manifest (fixture with a manifest missing members)
    inc = fixture / 'INCOMPLETE.sha256'
    lines = (fixture / 'REPLAY_SEED.sha256').read_text().splitlines()[:-5]
    inc.write_text('\n'.join(lines) + '\n')
    res = invoke(base_dest / 'guard_incomplete', 'INCOMPLETE.sha256', sha(inc), fixture=fixture)
    results.append(record('incomplete_manifest', res, False))

    # 4. existing destination
    existing = base_dest / 'guard_existing'
    existing.mkdir(parents=True, exist_ok=True)
    res = invoke(existing, 'REPLAY_SEED.sha256', pin)
    results.append(record('existing_dest', res, False))

    # 5. disallowed path (system tmp)
    res = invoke('/tmp/ft1536_guard_tmp', 'REPLAY_SEED.sha256', pin)
    results.append(record('disallowed_path_tmp', res, False))

    # 6. disallowed path (inside the repo)
    res = invoke('/home/footfalcon/free_falcon_sign/proofs/ft1536/work/guard_repo',
                 'REPLAY_SEED.sha256', pin)
    results.append(record('disallowed_path_repo', res, False))

    summary = dict(schema='FT1536_GAME_BINDING_GUARDS_V1',
                   total=len(results), passed=sum(r['passed'] for r in results),
                   controls=results)
    (WORK / 'guard_controls' / 'RESULT.json').write_text(json.dumps(summary, indent=2) + '\n')
    assert all(r['passed'] for r in results), 'GUARD_CONTROL_FAILED'
    print('GUARDS_PASS')

if __name__ == '__main__':
    main()
