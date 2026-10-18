#!/usr/bin/env python3
"""Owner-authorized historical-document recovery; never rewrite an old seal."""
import hashlib
import json
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
REVISION = '3e7353785e7654f91f4159a2d66992ac5a0e0510'
MANIFEST = ROOT / '.build/public159/POSTSEAL_159.json'
MANIFEST_SHA = 'ccd05f39988fc963d38139928cacd17a307659dc2db74bbae97d51b0f2ea6299'
SNAPSHOTS = ROOT / 'notes/run/snapshots/KEYGEN_PUBLIC_FORWARD_159_INITIAL'
BUILD = ROOT / '.build/r1resume160'
CHANGES = {
    'notes/run/KEYGEN_PUBLIC_FORWARD_159_REPORT.md': (
        'cf8c90a0a298452d2c449dcba26fdb229b40cd528e191949ee866bcdd694dee8',
        '343bf01cf7449dbb0af16023edb7bba71bbb684f'),
    'notes/run/KEYGEN_PUBLIC_FORWARD_159_FAILURES.json': (
        '8a15ee15b67abb37ce29c5d7c601e949ed7fcb58f67251e9c9eac3aa536e64b3',
        'e40477f91979e1de8e28199de5d9b76302920e79'),
}


def sha(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def immutable(path, content):
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        assert path.read_bytes() == content, ('REFUSE_OVERWRITE', str(path))
    else:
        with path.open('xb') as stream:
            stream.write(content)


def encoded(value):
    return (json.dumps(value, indent=2, sort_keys=True) + '\n').encode()


def main():
    assert (REPO / '.git').exists(), REPO
    assert sha(MANIFEST) == MANIFEST_SHA
    old = json.loads(MANIFEST.read_text())
    recovered = []
    preserved = {}
    prepared = []
    for name, expected in old['files'].items():
        current = ROOT / name
        if name not in CHANGES:
            assert sha(current) == expected, ('UNEXPECTED_MISMATCH', name)
            preserved[str(current)] = expected
            continue
        current_sha, change_commit = CHANGES[name]
        assert sha(current) == current_sha, ('CURRENT_DOCUMENT_CHANGED', name)
        git_path = current.relative_to(REPO).as_posix()
        historical = subprocess.run(
            ['git', '-C', str(REPO), 'show', REVISION + ':' + git_path],
            check=True, capture_output=True).stdout
        assert hashlib.sha256(historical).hexdigest() == expected
        target = SNAPSHOTS / current.name
        prepared.append((target, historical))
        recovered.append({'original_path': name, 'historical_revision': REVISION,
            'snapshot': target.relative_to(ROOT).as_posix(),
            'historical_sha256': expected, 'current_sha256': current_sha,
            'change_commit': change_commit})

    # Complete all incoming checks before creating the recovery snapshots.
    entry_file = ROOT / '.build/public158/ENTRY_PINS.json'
    assert sha(entry_file) == '528dbf18337a1e33322eac63ff99a9ba5008fc03449c1751483dcec7b9130290'
    inherited = json.loads(entry_file.read_text())['checked']
    checked = dict(inherited)
    for path, expected in inherited.items():
        assert sha(path) == expected, ('INHERITED_MISMATCH', path)
    print('Verified inherited pins:', len(inherited), flush=True)
    later = {}
    for name, expected_sha in [
        ('.build/public159b/POSTSEAL_159B.json',
         '1558cd5b1ffc98f8d8d3c78e96667e9a66a648cd3b813b122befefd87efe367c'),
        ('.build/zlower134/POSTSEAL_Z134.json',
         'cb0f0f9f780c531e7dead1478e3428d83e42d7a52b87860ef0f1ae15f6150894'),
    ]:
        path = ROOT / name
        if expected_sha is not None:
            assert sha(path) == expected_sha
        data = json.loads(path.read_text())
        for item, expected in data['files'].items():
            source = Path(item) if Path(item).is_absolute() else ROOT / item
            assert sha(source) == expected, ('LATER_MISMATCH', item)
            checked[str(source)] = expected
        later[name] = {'sha256': sha(path), 'checked': len(data['files'])}
        checked[str(path)] = sha(path)

    job = ROOT / '.build/jobs/keygen_publicforward159_108'
    receipt = job / 'RECEIPTS.json'
    assert sha(receipt) == '7c853d608cf4edb0300ffe26563a339c6bd607d412daaf947accb2154e61dead'
    rows = json.loads(receipt.read_text())
    assert len(rows) == 1
    row = rows[0]
    assert row['accepted'] and row['clean_log'] and row['exit_code'] == 0
    for name in ['stdout', 'stderr']:
        assert (job / row[name]).stat().st_size == 0
    source = ROOT / 'formal/Source3/PublicTailFirst159.lean'
    snapshot = job / 'formal/Source3/PublicTailFirst159.lean'
    assert sha(source) == sha(snapshot) == 'e86304c894e1bfc07ca57b4937f1809f721ed6b7e439e7972b3d9e3fbf83a7b0'
    checked.update(preserved)
    for path in [entry_file, MANIFEST, receipt, source, snapshot, Path(__file__)]:
        checked[str(path)] = sha(path)

    for target, content in prepared:
        immutable(target, content)
        checked[str(target)] = sha(target)
    for name in CHANGES:
        checked[str(ROOT / name)] = sha(ROOT / name)
    record = {
        'status': 'PASS_HISTORICAL_RECOVERY_AND_CURRENT_INPUTS; NOT_A_PROOF_AUDIT',
        'authorization': 'Owner explicitly approved the documented pin-repair plan on 2026-10-18.',
        'old_manifest': {'path': '.build/public159/POSTSEAL_159.json', 'sha256': MANIFEST_SHA},
        'old_live_path_verification': 'FAIL_TWO_DOCUMENT_VERSION_MISMATCHES (retained, not relabelled)',
        'historical_resolution': recovered,
        'unchanged_old_paths_checked': len(preserved),
        'inherited_pins_checked': len(inherited),
        'later_manifests': later,
        'accepted_job108': {'source_sha256': sha(source), 'receipt_sha256': sha(receipt),
                           'logs': '0 errors / 0 warnings; both empty'},
        'script_sha256': sha(__file__),
        'scope': 'Recover historical documents and certify resume inputs; no mathematical claim is added.',
    }
    record_path = ROOT / 'notes/run/KEYGEN_POSTSEAL_159_RECONCILIATION_001.json'
    immutable(record_path, encoded(record))
    checked[str(record_path)] = sha(record_path)
    entry = {'status': 'PASS_RESUME_INPUTS_WITH_EXPLICIT_HISTORICAL_RECONCILIATION',
        'reconciliation': {'path': str(record_path), 'sha256': sha(record_path)},
        'checked_count': len(checked), 'checked': checked}
    immutable(BUILD / 'ENTRY_PINS.json', encoded(entry))
    for path, expected in checked.items():
        assert sha(path) == expected, ('POSTWRITE_MISMATCH', path)
    postseal = {'status': 'PASS_POSTSEAL_RECONCILIATION; NOT_REVIEWED',
        'entry_sha256': sha(BUILD / 'ENTRY_PINS.json'),
        'receipt_sha256': sha(record_path), 'checked_count': len(checked)}
    immutable(BUILD / 'POSTSEAL_RECONCILIATION.json', encoded(postseal))
    print(json.dumps(postseal), flush=True)


if __name__ == '__main__':
    main()
