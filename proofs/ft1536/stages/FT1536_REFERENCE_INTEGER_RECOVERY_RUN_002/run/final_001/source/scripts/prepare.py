#!/usr/bin/env python3
"""Read-only input checks and provenance snapshots. No mathematics or Git calls."""
from pathlib import Path
import datetime
import hashlib
import json
import os
import shutil

W = Path(__file__).resolve().parents[1]
REPO = W.parents[3]
IN = W / 'inputs/bootstrap'


def sha(p):
    with p.open('rb') as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()


def check_manifest(root, manifest, excluded=(), exact=False):
    rows = {}
    for line in manifest.read_text().splitlines():
        h, name = line.split('  ', 1)
        p = Path(name)
        assert not p.is_absolute() and '..' not in p.parts and name not in rows
        assert not (root / p).is_symlink()
        assert (root / p).resolve().is_relative_to(root.resolve())
        assert sha(root / p) == h, name
        rows[name] = h
    if exact:
        actual = set()
        for p in root.rglob('*'):
            assert not p.is_symlink(), p
            if p.is_file():
                actual.add(p.relative_to(root).as_posix())
        assert actual == set(rows) | set(excluded)
    return {'members': len(rows), 'bytes': sum((root / n).stat().st_size for n in rows),
            'manifest_sha256': sha(manifest)}


def main():
    out = W / 'artifacts/preflight.json'
    assert not out.exists()
    task = REPO / 'proofs/ft1536/documents/FT1536_ZADANIE_T03_B_GAP_FIX_2026-09-29.md'
    assert sha(task) == 'c10d50304e8272df1f8367c5e19a432a0746e1239d1d7029c4447b20df75781a'
    assert sha(IN / 'MANIFEST.sha256') == 'a47dc77e48fb521b17de30115be67dca9e97221063e6b001af5cb4db4bc63f9f'
    boot = check_manifest(IN, IN / 'MANIFEST.sha256', ('MANIFEST.sha256', 'ORIGINS.json'), True)
    assert boot['members'] == 1396 and boot['bytes'] == 32721541
    old = IN / 'T03/inputs/bootstrap'
    assert sha(old / 'CANDIDATE.sha256') == '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
    source = check_manifest(old / 'source', old / 'CANDIDATE.sha256', exact=True)
    assert source['members'] == 17
    pins = {
        'T03/REPORT.md': 'e01a09789091c9c9322f9727263503063c94441a68ff5f30af952bcc4417785c',
        'T03/OUTPUTS.sha256': '0cafdbb2c746043380081052951cb6438643f6a1765a98028a065fa57b7df6de',
        'REVIEW_002/REVIEW.md': '2df1b7fa36921d14ea84e41c35e8a60707e044bd6d19688c41e4d79ea172b75f',
        'REVIEW_002/REVIEW_OUTPUTS.sha256': '9ea0274b78bfd5c0123a9502644ce081e3cc11dc9b59843c40597a6f5e76ef04'}
    for rel, expected in pins.items():
        assert sha(IN / rel) == expected
    extra = W / 'inputs/supplemental'
    extra.mkdir()
    origins = []

    def copy(src, rel):
        dest = extra / rel
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dest)
        dest.chmod(0o444)
        origins.append({'path': rel, 'origin': str(src), 'sha256': sha(dest)})

    copy(task, 'TASK.md')
    copy(REPO / 'proofs/ft1536/batches/B20_001/STATUS.json', 'B20_STATUS.json')
    p02 = REPO / 'proofs/ft1536/work/B20_001/P02'
    assert sha(p02 / 'output/OUTPUTS.sha256') == '4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01'
    p02check = check_manifest(p02 / 'output', p02 / 'output/OUTPUTS.sha256')
    for name in ['HANDOFF.md', 'output/REPORT.md', 'output/NEXT_INTERFACE.md',
                 'output/OUTPUTS.sha256', 'output/RESULT.json', 'output/FORMAL_EXPORTS.json']:
        copy(p02 / name, 'P02/' + name)
    # Library provenance only: no P02 theorem is imported or treated as reviewed.
    tc = p02 / 'run/replay_001/build/toolchain'
    for p in sorted(tc.iterdir()):
        if p.name.endswith(('.sha256', '.git-tree')) or p.name == 'TOOLCHAIN_GATE.json':
            copy(p, 'library_provenance/' + p.name)
    (extra / 'ORIGINS.json').write_text(json.dumps(origins, indent=2) + '\n')
    (extra / 'ORIGINS.json').chmod(0o444)
    out.parent.mkdir(exist_ok=True)
    result = {'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'task_sha256': sha(task), 'bootstrap': boot, 'source17': source,
              'pins': pins, 'p02_integrity_only_not_review': p02check,
              'historical_P02_toolchain_gate_used_only_as_library_provenance': True,
              'no_git_processes_invoked': True, 'symlinks_or_escape': False,
              'owner_accepted': False}
    out.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
