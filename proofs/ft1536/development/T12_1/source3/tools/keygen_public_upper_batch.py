#!/usr/bin/env python3
"""Dedicated BATCH_036 verifier: seal and re-verify the BATCH_015-036 closure.

This is the 036 verifier required by checkpoint 16.1 step 5. It extends the
BATCH_015-036 closure with the BATCH_036 seal-ceremony artifacts (the full
term/type/constructor/axiom audit and the Sage standard-preparser controls of
this window's `_037_` jobs), then re-hashes everything on demand.

Subcommands (job labels of the seal ceremony are BATCH_037 jobs per the
pair-naming convention; the artifacts they produce live under
.build/levels_036/ and act ON the sealed BATCH_036 pair):

  ceremony SEAL_JOB CHECKS_JOB MANIFEST
      validate the audit and control job receipts/products and write the
      ceremony manifest MANIFEST with their exact pins

  verify PAIR_JSON_SHA NOTES_SHA CEREMONY_SHA RECEIPT
      re-hash the complete BATCH_015-036 closure plus the ceremony manifest
      and write the verification receipt (POSTSEAL/FINAL_VERIFY/entry style)

Any mismatch is stop-and-report, never pin weakening or silent repair.
"""
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_intermediate_batch import path, read, pin
from keygen_public_upper_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_036'
ENTRY = '.build/levels_036/ENTRY_PINS_036.json'
ENTRY_SHA = '8d48dfb915639e49843f9a2174c51dfa10576222b1a6c30ce184dcd7d7ab924c'
AUDIT_NAME = 'PUBLIC_UPPER_AUDIT'
CHECK_NAME = 'PUBLIC_UPPER_CHECK'
FIXTURE_NAME = 'PUBLIC_UPPER_FIXTURE'
SAGE_SOURCE = 'sage/check_keygen_public_upper_finish.sage'


def committed(p, head):
    p = path(p)
    content = subprocess.check_output(
        ['git', 'show', head + ':' + str(p.relative_to(job.REPO))], cwd=job.REPO)
    assert content == p.read_bytes(), ('worktree differs from HEAD', p)


def streams(directory, record, clean=False):
    result = {}
    for key in ['stdout', 'stderr']:
        p = directory / record[key]
        assert job.sha(p) == record[key+'_sha256'], p
        if clean:
            assert p.stat().st_size == 0, p
        result[key] = pin(p)
    return result


def module_checks(head, checked, cache):
    """Re-hash the three accepted BATCH_036 module pins against every record."""
    pair = read(BASE + '.json')
    modules = []
    for module in pair['accepted_modules']:
        name = module['module'].replace('Source3.', '', 1)
        source = path(module['source'])
        assert job.sha(source) == module['source_sha256'], (module['module'], 'source pin')
        committed(module['source'], head)
        current = cache[module['module']]
        assert current['source_sha256'] == module['source_sha256']
        receipt = Path(current['receipt'])
        directory = receipt.parent
        record = next(r for r in read(receipt) if r['name'] == module['module'].replace('.', '_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == []
        assert record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean')
        artifact = directory/'lib/Source3'/(name+'.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256']
        assert job.sha(artifact) == job.sha(Path(current['artifact'])) == record['olean_sha256'] \
            == current['artifact_sha256']
        for imported, expected in current.get('imports', {}).items():
            assert cache[imported]['artifact_sha256'] == expected, (module['module'], imported)
        for p in [source, snapshot, artifact, Path(current['artifact']), receipt,
                  directory/'SOURCE_INPUTS.json']:
            checked[str(p)] = job.sha(p)
        modules.append({'module': module['module'], 'source': pin(source), 'snapshot': pin(snapshot),
            'artifact': pin(artifact), 'receipt': pin(receipt),
            'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'logs': streams(directory, record, True), 'imports': current.get('imports', {}),
            'elapsed_s': record['elapsed_s'], 'maxrss_kib': record['cumulative_child_maxrss_kib']})
    for entry in pair['accepted_jobs']:
        receipts = '.build/jobs/'+entry['label']+'/RECEIPTS.json'
        assert job.sha(path(receipts)) == entry['receipts_sha256'], (entry['label'], 'receipts pin')
        checked[str(path(receipts))] = entry['receipts_sha256']
    return pair, modules


def ceremony(seal_job, checks_job, manifest):
    assert not job.active(), 'a proof job is active'
    head = subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip()
    checked = {}
    cache = read('.build/cache/CACHE_INDEX.json')
    audit_dir = Path(cache['Source3.KeygenPublicUpperAudit']['receipt']).parent
    assert audit_dir.name == seal_job, (audit_dir.name, seal_job)
    committed('formal/Source3/KeygenPublicUpperAudit.lean', head)
    committed('tools/keygen_public_upper_audit_source.py', head)
    committed(SAGE_SOURCE, head)
    audit = read(audit_dir/(AUDIT_NAME+'.json'))
    audit_entries = len(declarations())+len(INHERITED)
    assert len(audit) == len({e['name'] for e in audit}) == audit_entries, (len(audit), audit_entries)
    assert set(declarations()) <= {e['name'] for e in audit}
    assert {('FT1536.Source3.'+n) for n in INHERITED} <= {e['name'] for e in audit}
    entries = audit_dir/(AUDIT_NAME+'_ENTRIES.jsonl')
    assert entries.exists() and entries.read_text().count('\n') == audit_entries
    for e in audit:
        assert set(e['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}, e['name']
        assert '⋯' not in json.dumps(e, ensure_ascii=False), e['name']
        if e['body']['kind'] == 'definition_or_theorem':
            assert 'term' in e['body'] and e['body']['term'], e['name']
        else:
            assert e['body']['kind'] == 'kernel_inductive' and e['body']['constructors'], e['name']
    inputs = read(audit_dir/'SOURCE_INPUTS.json')
    for e in inputs['sources']:
        assert job.sha(path(e['path'])) == e['sha256'], e['path']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source', e['source']))) == e['source_sha256'], e['module']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256'], e['module']
    audit_receipts = read(audit_dir/'RECEIPTS.json')
    audit_record = next(r for r in audit_receipts if r['name'] == 'Source3_KeygenPublicUpperAudit')
    for record in audit_receipts:
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == []
        assert record['cumulative_child_maxrss_kib'] <= 8*1024*1024
    audit_artifact = audit_dir/'lib/Source3/KeygenPublicUpperAudit.olean'
    audit_snapshot = audit_dir/'formal/Source3/KeygenPublicUpperAudit.lean'
    assert job.sha(audit_snapshot) == job.sha(path('formal/Source3/KeygenPublicUpperAudit.lean'))
    assert job.sha(audit_artifact) == audit_record['olean_sha256'] \
        == cache['Source3.KeygenPublicUpperAudit']['artifact_sha256']

    control_dir = job.BUILD/'jobs'/checks_job
    controls = read(control_dir/(CHECK_NAME+'.json'))
    control_record = read(control_dir/'RECEIPTS.json')[0]
    assert control_record['accepted'] and control_record['clean_log'] and control_record['exit_code'] == 0
    assert job.sha(path(SAGE_SOURCE)) == job.sha(control_dir/SAGE_SOURCE) == control_record['source_sha256']
    assert controls['status'] == 'PASS_FINITE_SOURCE_CONTROLS'
    assert len(controls['variants']) == 14
    assert job.sha(control_dir/(FIXTURE_NAME+'.json')) == controls['fixture_sha256']
    assert job.sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    control_artifacts = [pin(control_dir/(FIXTURE_NAME+'.json'))]
    for variant in controls['variants']:
        assert variant['counts'] == {'C': 256, 'S': 255, 'F': 1, 'L': 2050}, variant['mode']+variant['variant']
        assert bool(variant['detected_differences']) == (variant['variant'] != 'baseline')
        for p, expected in variant['artifacts'].items():
            p = control_dir/p
            assert job.sha(p) == expected, p
            control_artifacts.append(pin(p))
    source_pins = []
    for name, expected in controls['source_pins'].items():
        p = job.OLD/'inputs/source'/name
        assert job.sha(p) == expected, p
        source_pins.append(pin(p))

    for p in [audit_dir/(AUDIT_NAME+'.json'), audit_dir/(AUDIT_NAME+'_ENTRIES.jsonl'),
              audit_dir/'SOURCE_INPUTS.json', audit_dir/'RECEIPTS.json', audit_snapshot, audit_artifact,
              cache['Source3.KeygenPublicUpperAudit']['artifact'],
              control_dir/(CHECK_NAME+'.json'), control_dir/'RECEIPTS.json', control_dir/'SOURCE_INPUTS.json',
              control_dir/SAGE_SOURCE]:
        checked[str(path(p))] = job.sha(path(p))
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'batch': 'BATCH_036',
        'window': 'BATCH_037 seal ceremony jobs acting on the sealed BATCH_036 pair',
        'checked': checked, 'distinct_pinned_files': len(checked), 'active_jobs': [], 'superseded': {},
        'audit': {'job': seal_job, 'entries': audit_entries,
            'named_source_declarations': len(declarations()), 'inherited_interfaces': len(INHERITED),
            'full_terms': sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types': sum('constructors' in e['body'] for e in audit),
            'elisions': 0, 'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'],
            'artifact': pin(audit_artifact), 'producer': pin('formal/Source3/KeygenPublicUpperAudit.lean'),
            'generator': pin('tools/keygen_public_upper_audit_source.py'),
            'receipt': pin(audit_dir/'RECEIPTS.json'), 'source_inputs': pin(audit_dir/'SOURCE_INPUTS.json'),
            'streams': streams(audit_dir, audit_record, True)},
        'controls': {'job': checks_job, 'runs': 14, 'mutations_per_mode': 6, 'scope': controls['scope'],
            'result': pin(control_dir/(CHECK_NAME+'.json')), 'fixture': pin(control_dir/(FIXTURE_NAME+'.json')),
            'sage': pin(SAGE_SOURCE), 'receipt': pin(control_dir/'RECEIPTS.json'),
            'source_inputs': pin(control_dir/'SOURCE_INPUTS.json'),
            'profile': pin(job.OLD/'inputs/source/PROFILE.json'), 'source_files': source_pins,
            'artifacts': control_artifacts, 'streams': streams(control_dir, control_record, True)},
        'verifier_sha256': job.sha(Path(__file__))}
    target = path(manifest)
    assert target.is_relative_to(job.BUILD.resolve())
    with target.open('x') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'ceremony_manifest': pin(target), 'checked': len(checked),
                      'audit_entries': audit_entries, 'control_runs': 14}, indent=2))


def verify(pair_sha, notes_sha, ceremony_sha, receipt):
    checked = {}

    def check(p, expected):
        p = path(p)
        actual = job.sha(p)
        assert actual == expected, (str(p), expected, actual)
        checked[str(p)] = actual

    head = subprocess.check_output(
        ['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip()
    check(BASE+'.json', pair_sha)
    check(BASE+'_NOTES.md', notes_sha)
    committed(BASE+'.json', head)
    committed(BASE+'_NOTES.md', head)
    pair = read(BASE+'.json')
    assert pair['batch'] == 'BATCH_036' and pair['superseded'] == {} and pair['active_jobs'] == []
    check(pair['entry']['receipt'], pair['entry']['receipt_sha256'])
    assert pair['entry']['receipt_sha256'] == ENTRY_SHA
    entry = read(pair['entry']['receipt'])
    for p, expected in entry['checked'].items():
        check(p, expected)
    cache = read('.build/cache/CACHE_INDEX.json')
    pair, modules = module_checks(head, checked, cache)
    check('.build/levels_036/SEAL_CEREMONY_036.json', ceremony_sha)
    for p, expected in read('.build/levels_036/SEAL_CEREMONY_036.json')['checked'].items():
        check(p, expected)
    assert not job.active(), 'a proof job is active'
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'batch': 'BATCH_015-036',
        'scope': 'complete BATCH_015-036 closure plus this window\'s BATCH_036 seal-ceremony artifacts',
        'checked': checked, 'distinct_pinned_files': len(checked),
        'current_source_inputs': 592+len(pair['accepted_modules']),
        'accepted_modules': modules, 'active_jobs': [], 'superseded': {},
        'verifier_sha256': job.sha(Path(__file__))}
    target = path(receipt)
    assert target.is_relative_to(job.BUILD.resolve())
    with target.open('x') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({k: v for k, v in result.items() if k not in {'checked', 'accepted_modules'}},
                     indent=2))
    print(json.dumps({'receipt': pin(target)}, indent=2))


if __name__ == '__main__':
    if sys.argv[1:2] == ['ceremony']:
        assert len(sys.argv) == 5
        ceremony(*sys.argv[2:])
    else:
        assert len(sys.argv) == 6 and sys.argv[1] == 'verify'
        verify(*sys.argv[2:])
