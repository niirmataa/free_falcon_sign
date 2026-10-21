#!/usr/bin/env python3
"""Read-only chain verification + NEW ENTRY_PINS for the post-modp_Rx windows.

Re-baseline per run2/notes/PINY_I_OLEAN_STRUKTURA.md section 3 (OWNER
DECISION A, 2026-10-21): both chain versions are preserved. The old
manifest .build/stepgs194/ENTRY_PINS.json stays untouched; this receipt
is the NEW ENTRY_PINS inherited by the next windows.

Chain verified before writing:
  1. the re-baseline document against its externally recorded SHA256;
  2. the old manifest 99ac47a1... and every one of its checked paths —
     with the two documented decision-A deltas checked against their NEW
     hashes (see the re-baseline document), everything else read-only;
  3. job receipts 560/561/562 and the job-559 preflight against external
     pins; every accepted product (816 rebuilt modules + the axiom audit)
     against its receipt record or its lane-cache record frozen here;
  4. no active owned job/Lean/Sage process before writing the receipt.

Output receipt: .build/steprx195/ENTRY_PINS.json (exclusive create).
Integrity facts only; no proof claim.
"""
from datetime import datetime, timezone
import fcntl
import json
from pathlib import Path
import sys

import job079 as job
import pre_sign_evidence084 as evidence

ROOT = evidence.ROOT
BUILD = ROOT / '.build/steprx195'
PREVIOUS = ROOT / '.build/stepgs194/ENTRY_PINS.json'
PREVIOUS_SHA = '99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8'
REBASELINE = ROOT / 'notes/run/KEYGEN_MODCALL_RX_REBASELINE_195.md'
REBASELINE_SHA = '79f4d3cae494e89063b9e536bc795159c6087b887756ba3b6d372a0c6cc95fe0'
RECEIPT_560 = ROOT / '.build/jobs/keygen_publicforward159_560/RECEIPTS.json'
RECEIPT_560_SHA = '95f13b20eb20c04bc30bbd9d5769481607c6b8145ccddd048a8e98a882e6abfc'
RECEIPT_561 = ROOT / '.build/jobs/keygen_publicforward159_561/RECEIPTS.json'
RECEIPT_561_SHA = '0a7f3f6d3b733432e67a241a3984324f7eb337a9c2f9e1c500c111af44be27a4'
RECEIPT_562 = ROOT / '.build/jobs/keygen_publicforward159_562/RECEIPTS.json'
RECEIPT_562_SHA = '7bca498eab8c38f2d886c779f3615408796ab27eb76235c9e35dcc0185f3e106'
PREFLIGHT_559 = ROOT / '.build/jobs/keygen_publicforward159_559/PREFLIGHT.json'
PREFLIGHT_559_SHA = '54fbce007436aeadc0ed191bbd4aecd856cb98709b2eee46d72057b181afcc68'
SELECTION = BUILD / 'SELECTION_ORDER.txt'
SELECTION_SHA = '4ba20f11ee89a86a421c77629be82ed3c4fc2c48da08b3cf01a6b1cba8f2f2dd'
SELECTION_561 = BUILD / 'SELECTION_ORDER_561.txt'
SELECTION_561_SHA = '65b8c481910583d582df38936b4082b9a22c0546c7b3a7514be30d1187ad0e28'
CLOSURE_SET = BUILD / 'CLOSURE_SET.json'
CLOSURE_SET_SHA = '89db859cce0921ce64f5965f69e905ce670568624288a6900ba215be5f298023'

# Decision-A delta: the two changed sources, old -> new (both versions are
# recorded in REBASELINE; the old manifest keeps the old hashes).
DELTA = {
    'formal/Source3/C99ModularReference.lean':
        'b2abbf443891f97d1608c08d8c0a045c2bf429ae4546832d4eb0fbc603712041',
    'formal/Source3/KeygenProperModular096.lean':
        '92aa68594f06edbd8de52e63f560be547915fb07eb00c3bc08fd00d354d485d2',
}
NEW_SOURCES = {
    'formal/Source3/KeygenModularRx096.lean':
        '40fccaeb6ab6172cf5a59dea9db684cf68de32010147774dbfe1ea2ee607aa71',
    'formal/Source3/KeygenRxCallees.lean':
        '1191a7234e203fcf9251c6ca91548fa17bae1a462d6ae02eac5ec78553218362',
    'formal/Source3/KeygenRxAudit195.lean':
        'f26c36bb33fc7cc3a4df1f65750498a7eed2f57d1a4f4d3b58088346bd995a26',
}
KEY_OLEANS = {
    '.build/jobs/keygen_publicforward159_559/lib/Source3/C99ModularReference.olean':
        '8b99a85057fc8c49169b49d48a4fa611cea2f6fabdbc54e76e56f6b5e19a4691',
    '.build/jobs/keygen_publicforward159_561/lib/Source3/KeygenProperModular096.olean':
        '0324b18bb42e6a1b544d0a4c92e5440e8aecd0d847898daf141fc47b51a0a0a0',
    '.build/jobs/keygen_publicforward159_561/lib/Source3/KeygenModularRx096.olean':
        '7a34b238c14ceeb155ea4801943169d1d34f41e41527c87e80bde5cd4cead08a',
    '.build/jobs/keygen_publicforward159_561/lib/Source3/KeygenRxCallees.olean':
        '65288500b7ab1db4c570257d369514dab76191804f13d01ab960af5a24384f6e',
    '.build/jobs/keygen_publicforward159_561/lib/Source3/KeygenModularLeaf096.olean':
        'c9de9db98167a0cc30cd3ecb7734b5a7c02079ade96c493f53af80453c6f6a67',
    '.build/jobs/keygen_publicforward159_561/lib/Source3/KeygenModpRx.olean':
        '5d3410103ec21314e465660efe4d9ce41300e2e00b29001486d94128726385aa',
}


def module_of(source_path):
    rel = source_path.split('/formal/', 1)[1][:-len('.lean')]
    return rel.replace('/', '.')


def entry():
    evidence.check(REBASELINE, REBASELINE_SHA)
    evidence.check(SELECTION, SELECTION_SHA)
    evidence.check(SELECTION_561, SELECTION_561_SHA)
    evidence.check(CLOSURE_SET, CLOSURE_SET_SHA)
    evidence.check(RECEIPT_560, RECEIPT_560_SHA)
    evidence.check(RECEIPT_561, RECEIPT_561_SHA)
    evidence.check(RECEIPT_562, RECEIPT_562_SHA)
    evidence.check(PREFLIGHT_559, PREFLIGHT_559_SHA)
    evidence.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())
    checked = dict(data['checked'])
    assert len(checked) == 73564 == data['checked_count']
    deltas = []
    for path, digest in checked.items():
        expected = DELTA.get(path[len(str(ROOT)) + 1:], digest)
        evidence.check(path, expected)
        if expected != digest:
            deltas.append((digest, expected))
    assert len(deltas) == 2, deltas

    def pin_key(rel, expected):
        p = ROOT / rel
        evidence.check(p, expected)
        checked[str(p)] = expected

    for rel, expected in {**DELTA, **NEW_SOURCES, **KEY_OLEANS}.items():
        pin_key(rel, expected)

    rebuilt = {}
    for receipt_path in (RECEIPT_560, RECEIPT_561, RECEIPT_562):
        for record in json.loads(receipt_path.read_text()):
            if not record['accepted']:
                # The one retained failure of job 560 (retained record):
                # KeygenModularLeaf096, rebuilt and accepted in job 561.
                assert record['name'] == 'Source3_KeygenModularLeaf096', record['name']
                continue
            assert record['clean_log'] and \
                record['exit_code'] == 0 and not record['forbidden_proof_markers'], record['name']
            module = module_of(record['argv'][-1])
            source = ROOT / 'formal' / (module.replace('.', '/') + '.lean')
            olean = ROOT / ('.build/jobs/keygen_publicforward159_' +
                            receipt_path.parent.name.rsplit('_', 1)[1]) / \
                'lib' / (module.replace('.', '/') + '.olean')
            assert evidence.sha(source) == record['source_sha256'], module
            assert evidence.sha(olean) == record['olean_sha256'], module
            rebuilt[module] = (str(source), str(olean))
            checked[str(source)] = record['source_sha256']
            checked[str(olean)] = record['olean_sha256']

    # Job 559 was killed before its aggregate receipts were written; its
    # 280 accepted products are anchored by the per-module receipts and
    # the lane-cache records frozen here.
    lane = json.loads((ROOT / '.build/key_law088/CACHE_INDEX.json').read_text())
    done559 = 0
    for path in sorted((ROOT / '.build/jobs/keygen_publicforward159_559/logs').glob('*.receipt.json')):
        record = json.loads(path.read_text())
        assert record['accepted'] and record['clean_log'] and \
            record['exit_code'] == 0 and not record['forbidden_proof_markers'], record['name']
        module = module_of(record['argv'][-1])
        cached = lane[module]
        assert 'keygen_publicforward159_559' in cached['origin'], module
        source = Path(cached['source'])
        olean = Path(cached['artifact'])
        assert evidence.sha(source) == cached['source_sha256'], module
        assert evidence.sha(olean) == cached['artifact_sha256'], module
        rebuilt[module] = (str(source), str(olean))
        checked[str(path)] = evidence.sha(path)
        checked[str(source)] = cached['source_sha256']
        checked[str(olean)] = cached['artifact_sha256']
        done559 += 1
    assert done559 == 280, done559

    selected = [line.strip() for line in SELECTION.read_text().splitlines() if line.strip()]
    assert set(selected) <= set(rebuilt), sorted(set(selected) - set(rebuilt))[:5]
    assert len(selected) == 816

    checked[str(REBASELINE)] = REBASELINE_SHA
    checked[str(RECEIPT_560)] = RECEIPT_560_SHA
    checked[str(RECEIPT_561)] = RECEIPT_561_SHA
    checked[str(RECEIPT_562)] = RECEIPT_562_SHA
    checked[str(PREFLIGHT_559)] = PREFLIGHT_559_SHA
    checked[str(SELECTION)] = SELECTION_SHA
    checked[str(SELECTION_561)] = SELECTION_561_SHA
    checked[str(CLOSURE_SET)] = CLOSURE_SET_SHA

    processes = job.active()
    assert not processes, processes
    value = {
        'status': 'PASS_INTEGRITY; MODPX_RX_STRATUM_REBASELINED',
        'verified_at': datetime.now(timezone.utc).isoformat(),
        'previous_entry_pins': evidence.pin(PREVIOUS),
        'previous_manifest_sha256': PREVIOUS_SHA,
        're_baseline_document': evidence.pin(REBASELINE),
        're_baseline_deltas': [{'old': old, 'new': new} for old, new in deltas],
        'jobs': {
            '559': {'aggregate_receipts': 'absent (external kill; per-module receipts pinned)',
                    'preflight': evidence.pin(PREFLIGHT_559), 'products': 280},
            '560': {'receipts': evidence.pin(RECEIPT_560), 'products': 495,
                    'failure': 'Source3.KeygenModularLeaf096 (incomplete topological order; retained)'},
            '561': {'receipts': evidence.pin(RECEIPT_561), 'products': 41},
            '562': {'receipts': evidence.pin(RECEIPT_562), 'products': 1,
                    'scope': 'DIAGNOSTIC axiom audit (record, not proof evidence)'},
        },
        'rebuilt_modules': len(rebuilt),
        'checked_count': len(checked),
        'checked': checked,
        'active_processes': processes,
        'next_unused_job_suffix': 563,
        'scope': 'resume verification only; no proof claim',
    }
    print(json.dumps(evidence.write(BUILD / 'ENTRY_PINS.json', value)))


if __name__ == '__main__':
    with (ROOT / '.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        if sys.argv[1:]:
            raise SystemExit('no arguments; read-only entry verification')
        entry()
