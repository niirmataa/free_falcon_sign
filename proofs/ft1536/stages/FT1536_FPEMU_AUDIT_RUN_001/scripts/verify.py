"""Independently verify the complete supplied public bootstrap, without Git."""
import hashlib
import json
from pathlib import Path
import sys

W = Path(__file__).resolve().parents[1]
B = W / 'inputs/bootstrap'
PIN = 'f836a37c9247de53ff70297e809fa55c46812d749e69886857d24e89db7de166'

def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def verify():
    assert sha(B/'MANIFEST.sha256') == PIN
    entries = {}
    for line in (B/'MANIFEST.sha256').read_text().splitlines():
        h, rel = line.split('  ', 1)
        assert rel not in entries and not Path(rel).is_absolute() and '..' not in Path(rel).parts
        p = B/rel
        assert not p.is_symlink() and p.is_file() and sha(p) == h, rel
        entries[rel] = h
    actual = {str(p.relative_to(B)) for p in B.rglob('*') if p.is_file()}
    assert not any(p.is_symlink() for p in B.rglob('*'))
    assert actual == set(entries) | {'MANIFEST.sha256'}, actual ^ set(entries)
    assert len(entries) == 126
    assert entries['CANDIDATE.sha256'] == '2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
    assert entries['source/fpr-emulated.c'] == '7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f'
    assert entries['source/fpr-emulated.h'] == '242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'
    origins = json.loads((B/'ORIGINS.json').read_text())
    base = 'b5805bab84a9c0057cd0392671e389bf81031a76'
    assert origins['base_commit'] == base
    assert len(origins['files']) == 124
    copies = set()
    projected = 0
    for row in origins['files']:
        rel = row['copy']
        assert rel not in copies
        copies.add(rel)
        assert entries[rel] == row['sha256']
        assert (B/rel).stat().st_size == row['bytes']
        assert row['original'].startswith('git:'+base+':')
        parts = Path(rel).parts
        if parts[0] in ('H3', 'ZERO', 'ROOT', 'NODE3', 'LV', 'M0') and parts[-1] != 'OUTPUTS.sha256':
            historical = dict((r, h) for h, r in
                              (ln.split('  ', 1) for ln in (B/parts[0]/'OUTPUTS.sha256').read_text().splitlines()))
            assert historical[str(Path(*parts[1:]))] == entries[rel], rel
            projected += 1
    assert copies == set(entries) - {'README.md', 'ORIGINS.json'}
    candidate = dict((r, h) for h, r in
                     (ln.split('  ', 1) for ln in (B/'CANDIDATE.sha256').read_text().splitlines()))
    for rel, h in candidate.items():
        assert entries['source/'+Path(rel).name] == h
    assert len(candidate) == 17
    task_pin = 'd5b064ba6082f1f563bfba717ee1d167254e2aedcea667576bfb3f56a9103de9'
    task = W/'inputs/TASK.md'
    if '--capture-task' in sys.argv:
        original = Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_FPEMU_AUDIT_2026-09-19.md')
        assert sha(original) == task_pin
        assert not task.exists()
        task.write_bytes(original.read_bytes())
    assert sha(task) == task_pin
    result = dict(status='PASS', manifest_sha256=PIN, members=126,
                   exact_file_set=True, snapshot='b5805bab84a9c0057cd0392671e389bf81031a76',
                   task_sha256=task_pin, candidate_files=17, public_origins=124,
                   historical_projection_members_checked=projected,
                  provenance_limit='Supplied public Git-origin records are hash-bound; no Git access/re-extraction in this audit.',
                  origins=origins)
    (W/'artifacts').mkdir(exist_ok=True)
    (W/'artifacts/bootstrap_verification.json').write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
    print('PASS: task, 126 members, exact file set, 124 origins, 17 candidate files and historical projections')
    return entries, origins

if __name__ == '__main__':
    verify()
