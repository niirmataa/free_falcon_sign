#!/usr/bin/env python3
"""Pre-commit guard for proofs/ft1536.

Refuses staged changes that violate the archive's canonical layout:
- nothing may be staged under work/ or replay-work/ (ignored scratch areas),
- staging stages/<id>/ requires staging catalog/<id>.json in the same commit,
  so every frozen snapshot lands together with its pin registry entry.

This is a fast structural guard, not archive verification; the full
byte/pin check remains `python3 -B proofs/ft1536/tools/archive.py verify`.
Unrelated paths never trigger it. Bypass deliberately with --no-verify.
"""
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
PROOF = 'proofs/ft1536/'
FORBIDDEN = (PROOF + 'work/', PROOF + 'replay-work/')
FORBIDDEN_NAMES = ('.private', 'private_extraction')


def staged():
    out = subprocess.check_output(
        ['git', 'diff', '--cached', '--name-only', '-z', '--', PROOF], cwd=REPO)
    return [p.decode() for p in out.split(b'\0') if p]


def main():
    paths = staged()
    if not paths:
        return 0
    problems = []
    stage_ids = set()
    catalog_ids = set()
    for path in paths:
        if path.startswith(FORBIDDEN) or any(n in path for n in FORBIDDEN_NAMES):
            problems.append(f'non-canonical staged path: {path}')
            continue
        rest = path[len(PROOF):]
        if rest.startswith('stages/'):
            parts = rest.split('/')
            if len(parts) >= 2:
                stage_ids.add(parts[1])
        if rest.startswith('catalog/') and rest.endswith('.json'):
            catalog_ids.add(rest[len('catalog/'):-len('.json')])
    for stage in sorted(stage_ids - catalog_ids):
        problems.append(f'stages/{stage}/ staged without catalog/{stage}.json')
    if problems:
        for line in problems:
            print(f'ft1536 pre-commit: {line}', file=sys.stderr)
        print('ft1536 pre-commit: refused; fix staging or use --no-verify deliberately.',
              file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
