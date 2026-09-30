#!/usr/bin/env python3
"""Pin existing artifacts and copy public source inputs. No mathematics."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import shutil

W = Path(__file__).resolve().parent.parent
P = W.parents[1]
REPO = P.parents[3]


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def verify(base, name, expected):
    manifest = base / name
    if sha(manifest) != expected:
        raise ValueError('manifest pin mismatch: ' + str(manifest))
    members = []
    for line in manifest.read_text().splitlines():
        h, rel = line.split(maxsplit=1)
        if Path(rel).is_absolute() or '..' in Path(rel).parts:
            raise ValueError('unsafe member')
        f = base / rel
        if f.is_symlink() or not f.is_file() or sha(f) != h:
            raise ValueError('member mismatch: ' + str(f))
        members.append(rel)
    return members


def copy(p, q):
    q.parent.mkdir(parents=True, exist_ok=True)
    if q.exists():
        raise ValueError('refusing existing destination: ' + str(q))
    shutil.copyfile(p, q)


def main():
    receipt = W / 'BOOTSTRAP_RECEIPT.json'
    if receipt.exists():
        raise ValueError('bootstrap already completed')
    prev = P / 'output'
    prev_pin = '6400ec7850bda22609dd52c261285149b170777c64b7e2b07a9394c4a54d6d59'
    prior_members = verify(prev, 'OUTPUTS.sha256', prev_pin)
    p02 = P.parent / 'B20_001/P02/output'
    p02_pin = '4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01'
    p02_members = verify(p02, 'OUTPUTS.sha256', p02_pin)
    for label, source in [('run002', prev), ('p02', p02)]:
        for name in ['REPORT.md', 'RESULT.json', 'OUTPUTS.sha256', 'FORMAL_EXPORTS.json',
                     'ASSUMPTIONS.json', 'NEXT_INTERFACE.md']:
            copy(source / name, W / 'inputs' / label / name)
    profile_path = P / 'inputs/legal_key_context/M0/PROFILE.json'
    profile = json.loads(profile_path.read_text())
    copy(profile_path, W / 'inputs/source/PROFILE.json')
    src = REPO / 'proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001/source'
    bindings = []
    for name, expected in profile['core']['source_files'].items():
        if sha(src / name) != expected:
            raise ValueError('M0 profile/source mismatch: ' + name)
        copy(src / name, W / 'inputs/source' / name)
        current = REPO / 'Extra/c' / name
        bindings.append({'name': name, 'pinned_sha256': expected, 'origin': str(src / name),
                         'live_Extra_sha256': sha(current) if current.is_file() else None,
                         'live_Extra_is_proof_base': False})
    for p in sorted((p02 / 'formal').rglob('*.lean')):
        copy(p, W / 'run/formal' / p.relative_to(p02 / 'formal'))
    # Inherited RUN_002 project artifacts must come from the fresh replay,
    # never an unrelated/stale development cache. Sources remain frozen RO.
    fresh = P / 'run/final_fresh_replay_20260929_002'
    rr = json.loads((fresh / 'REPLAY_RESULT.json').read_text())
    if rr['status'] != 'PASS':
        raise ValueError('parent fresh replay is not PASS')
    caches = []
    for rec in json.loads((fresh / 'EXECUTION_RECEIPTS.json').read_text())['jobs']:
        if 'olean_sha256' not in rec:
            continue
        source = fresh / rec['source']
        rel = source.relative_to(fresh / 'formal')
        if sha(source) != rec['source_sha256'] or sha(prev / 'formal' / rel) != rec['source_sha256']:
            raise ValueError('parent source binding differs')
        artifact = fresh / 'lib' / rel.with_suffix('.olean')
        if sha(artifact) != rec['olean_sha256']:
            raise ValueError('parent artifact binding differs')
        caches.append({'source': str(prev / 'formal' / rel), 'source_sha256': rec['source_sha256'],
                       'artifact': str(artifact), 'artifact_sha256': rec['olean_sha256']})
    for d in ['run/devlib', 'run/sage', 'run/preflight', 'output']:
        (W / d).mkdir(parents=True, exist_ok=True)
    config = {'parent': str(P), 'repo': str(REPO), 'parent_frozen': str(prev),
        'parent_cache': str(fresh / 'lib'), 'p02_frozen': str(p02),
        'library_roots': json.loads((prev / 'LIBRARY_CLOSURE.json').read_text())['roots']}
    (W / 'run/CONFIG.json').write_text(json.dumps(config, indent=2) + '\n')
    (W / 'SOURCE_BINDINGS.json').write_text(json.dumps(bindings, indent=2) + '\n')
    (W / 'PARENT_CACHE_BINDINGS.json').write_text(json.dumps(caches, indent=2) + '\n')
    lines = [sha(p) + '  ' + str(p.relative_to(W)) for p in sorted((W / 'inputs').rglob('*')) if p.is_file()]
    (W / 'INPUTS.sha256').write_text('\n'.join(lines) + '\n')
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'task_id': W.name,
        'model': 'openai/gpt-6-astra-fast', 'session': 'ses_f13464e70ffeuAM6Xf31ztFHAS',
        'task_sha256': sha(W / 'TASK.md'), 'parent_outputs_sha256': prev_pin,
        'parent_members_verified': len(prior_members), 'p02_outputs_sha256': p02_pin,
        'p02_members_verified': len(p02_members), 'parent_cache_bindings': len(caches),
        'input_manifest_sha256': sha(W / 'INPUTS.sha256'), 'input_members': len(lines),
        'source_profile': 'M0 pinned17; Extra/c comparison is orientation only',
        'p02_mathematical_review_performed': False, 'p02_missing_arithmetic_premises_assumed': False,
        'ownership': 'sole continuation executor; T5/P02 other W remain read-only'}
    receipt.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
