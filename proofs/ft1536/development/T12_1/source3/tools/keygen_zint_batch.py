#!/usr/bin/env python3
"""Seal/verify BATCH_028's recoverable midpoint; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess
import sys

import job
from keygen_zint_audit_source import MODULES, INHERITED, declarations

BASE = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_028'
ENTRY = '.build/levels_028/ENTRY_PINS_028_002.json'
ENTRY_SHA = 'b9cec873c9440265d16347bfcb13104630dfeee33a14bf907699a13d87f1ce60'
CHECK_JOB = 'keygen_zint_checks_028_003'


def path(p):
    return (job.ROOT / p).resolve()


def read(p):
    return json.loads(path(p).read_text())


def pin(p):
    p = path(p)
    return {'path': str(p.relative_to(job.ROOT)) if p.is_relative_to(job.ROOT) else str(p),
            'sha256': job.sha(p), 'bytes': p.stat().st_size}


def streams(directory, record):
    result = {}
    for key in ('stdout', 'stderr'):
        p = directory / record[key]
        assert job.sha(p) == record[key + '_sha256'], p
        if record['accepted']:
            assert p.stat().st_size == 0, p
        result[key] = pin(p)
    return result


def committed(p, head):
    p = path(p)
    content = subprocess.check_output(['git', 'show', head + ':' + str(p.relative_to(job.REPO))], cwd=job.REPO)
    assert hashlib.sha256(content).hexdigest() == job.sha(p), p


def seal():
    assert not path(BASE + '.json').exists(), 'Never overwrite a historical pair'
    assert not job.active(), 'A proof job is active'
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=job.REPO, text=True).strip() == 'main'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=job.REPO, text=True).strip()
    assert job.sha(path(ENTRY)) == ENTRY_SHA
    entry = read(ENTRY)
    assert entry['distinct_pinned_files'] == 2917 and entry['active_jobs'] == []
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = {}
    details = []
    for name in MODULES + ['KeygenZintAudit']:
        module = 'Source3.' + name
        current = cache[module]
        source = Path(current['source']); receipt = Path(current['receipt']); directory = receipt.parent
        committed(source, head)
        record = next(r for r in read(receipt) if r['name'] == module.replace('.', '_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert record['forbidden_proof_markers'] == [] and record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory / 'formal/Source3' / (name + '.lean')
        artifact = directory / 'lib/Source3' / (name + '.olean')
        assert job.sha(source) == job.sha(snapshot) == record['source_sha256'] == current['source_sha256']
        assert job.sha(artifact) == job.sha(Path(current['artifact'])) == record['olean_sha256'] == current['artifact_sha256']
        for imported, expected in current.get('imports', {}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module, imported)
        accepted[name] = {'source': str(source.relative_to(job.ROOT)), 'sha256': job.sha(source)}
        details.append({'module': module, 'source': pin(source), 'snapshot': pin(snapshot),
            'artifact': pin(artifact), 'receipt': pin(receipt), 'source_inputs': pin(directory / 'SOURCE_INPUTS.json'),
            'logs': streams(directory, record), 'imports': current.get('imports', {}),
            'elapsed_s': record['elapsed_s'], 'maxrss_kib': record['cumulative_child_maxrss_kib']})
    current_sources = {str(path(e['source'])): e['sha256'] for e in accepted.values()}
    superseded = {}
    for p, expected in entry['checked'].items():
        actual = job.sha(path(p))
        if actual != expected:
            assert actual == current_sources.get(str(path(p))), (p, expected, actual)
            superseded[p] = {'entry_pins_028': expected, 'batch_028': actual}
    audit_dir = Path(cache['Source3.KeygenZintAudit']['receipt']).parent
    audit = read(audit_dir / 'ZINT_AUDIT.json')
    assert len(audit) == len({e['name'] for e in audit}) == len(declarations()) + len(INHERITED)
    assert set(declarations()) <= {e['name'] for e in audit}
    for e in audit:
        assert set(e['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(e, ensure_ascii=False)
    inputs = read(audit_dir / 'SOURCE_INPUTS.json')
    for e in inputs['sources']:
        assert job.sha(path(e['path'])) == e['sha256']
    for e in inputs['reused']:
        assert job.sha(path(e.get('current_source', e['source']))) == e['source_sha256']
        assert job.sha(path(e['artifact'])) == e['artifact_sha256']
    controls_dir = job.BUILD / 'jobs' / CHECK_JOB
    controls = read(controls_dir / 'ZINT_CHECK.json')
    assert len(controls['variants']) == 16
    assert len({e['variant'] for e in controls['variants']}) == 8
    record = read(controls_dir / 'RECEIPTS.json')[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    sage_source = 'sage/check_keygen_zint_closure.sage'
    committed(sage_source, head)
    assert job.sha(path(sage_source)) == job.sha(controls_dir / sage_source) == record['source_sha256']
    assert job.sha(controls_dir / 'PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    assert job.sha(job.OLD / 'inputs/source/PROFILE.json') == controls['profile_sha256']
    source_files = []
    for name, expected in controls['source_pins'].items():
        p = job.OLD / 'inputs/source' / name
        assert job.sha(p) == expected, p
        source_files.append(pin(p))
    artifacts = [pin(controls_dir / 'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        assert variant['counts'] == controls['variants'][0]['counts']
        for p, expected in variant['artifacts'].items():
            p = controls_dir / p
            assert job.sha(p) == expected
            artifacts.append(pin(p))
    receipts = {}; history = []
    for directory in sorted((job.BUILD / 'jobs').glob('keygen_zint_*_028_*')):
        records = read(directory / 'RECEIPTS.json')
        inventory = read(directory / 'SOURCE_INPUTS.json')
        snapshots = []
        for e in inventory['sources']:
            rel = 'formal/' + e['module'].replace('.', '/') + '.lean' if 'module' in e else 'sage/' + Path(e['path']).name
            p = directory / rel
            assert job.sha(p) == e['sha256']
            snapshots.append(pin(p))
        steps = []
        for r in records:
            steps.append({'name': r['name'], 'accepted': r['accepted'], 'exit_code': r['exit_code'],
                'clean_log': r['clean_log'], 'source_sha256': r['source_sha256'],
                'elapsed_s': r['elapsed_s'], 'maxrss_kib': r['cumulative_child_maxrss_kib'],
                'logs': streams(directory, r)})
        receipts[directory.name] = job.sha(directory / 'RECEIPTS.json')
        history.append({'job': directory.name, 'status': 'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED',
            'receipt': pin(directory / 'RECEIPTS.json'), 'source_inputs': pin(directory / 'SOURCE_INPUTS.json'),
            'preflight': pin(directory / 'PREFLIGHT.json'), 'snapshots': snapshots, 'steps': steps,
            'products': [pin(p) for p in sorted(directory.iterdir()) if p.is_file() and p.suffix in {'.json', '.c', '.stdout', '.stderr'}
                and p.name not in {'RECEIPTS.json', 'SOURCE_INPUTS.json', 'PREFLIGHT.json'}]})
    notes = path(BASE + '_NOTES.md')
    assert notes.exists()
    output = {
        'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': 'BATCH_028', 'stage': 'B1.05b-c',
        'window': 'CLOSED_AT_RECOVERABLE_MIDPOINT', 'b1_05_acceptance': 'NOT_MET',
        'status': 'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN', 'stage_result': 'PARTIAL_PROOF',
        'harness': 'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'created_utc': datetime.now(timezone.utc).isoformat(), 'proof_head': head,
        'notes': pin(notes), 'entry_pins_receipt': pin(ENTRY),
        'first_entry_receipt': pin('.build/levels_028/ENTRY_PINS_028.json'),
        'entry_verifier': pin('tools/keygen_zint_entry_pins.py'), 'superseded': superseded,
        'accepted_modules': accepted, 'accepted_module_checks': details,
        'current_final_audit_inputs': len(inputs['sources']) + len(inputs['reused']),
        'audit': {**pin(audit_dir / 'ZINT_AUDIT.json'), 'receipt': pin(audit_dir / 'RECEIPTS.json'),
            'source_inputs': pin(audit_dir / 'SOURCE_INPUTS.json'), 'exports': len(audit),
            'covered_source_declarations': len(declarations()), 'inherited_interfaces': len(INHERITED),
            'full_terms': sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types': sum('constructors' in e['body'] for e in audit),
            'elisions': 0, 'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound']},
        'sage': {'source': pin(sage_source), 'receipt': pin(controls_dir / 'RECEIPTS.json'),
            'source_inputs': pin(controls_dir / 'SOURCE_INPUTS.json'), 'result': pin(controls_dir / 'ZINT_CHECK.json'),
            'profile': pin(job.OLD / 'inputs/source/PROFILE.json'), 'source_files': source_files,
            'logs': streams(controls_dir, record), 'counts_per_run': controls['variants'][0]['counts'],
            'artifacts': artifacts},
        'attempt_history': receipts, 'attempt_history_receiptless': {}, 'attempt_details': history,
        'attempt_counts': {s: sum(e['status'] == s for e in history) for s in ['ACCEPTED', 'FAILED_RETAINED']},
        'tools': [pin(p) for p in ['tools/job.py', 'tools/job_when_available.py',
            'tools/keygen_zint_audit_source.py', 'formal/Source3/KeygenLevelsAudit.lean',
            'tools/keygen_zint_batch.py']],
        'contracts': {
            'extraction': 'Complete bitlength, signed bit length, top, max-bitlength and big-to-fpr bodies; static vv initializer/object binding and value-level returned call; actual division, return pun, pointer advance and nested FPEMU Store64.',
            'scaled': 'Complete add-scaled/sub-scaled bigint leaves and both poly_sub_scaled branches. Backward pointers execute (F+j)-off with intermediate bounds; k[u] is signed32.',
            'make_fg': 'Complete binary mkgm2/NTT2/iNTT2, complete make_fg_step/make_fg and fixed ternary-top/CRT dependency closure. Actual width16 REV10, width64 size tables and signed16 f/g loads.',
            'deepest': 'Complete deepest body, actual context-byte reads and member argument binding, CRT/Bezout/multiply failure gates and short-circuit order. Derived frame/material preservation for any input block separate from scratch/static tables.',
            'boundary': 'Finite defined executions in the pinned reference model. Context ABI/allocation, static table environment and legal object separation remain caller inputs. No bigint/NTT arithmetic, termination, probability or whole-solver conclusion is promoted from these frames.'},
        'open': ['Full solve_NTRU_intermediate and remaining active dependencies, including poly_sub_scaled_ntt if reached.',
            'Full PRIMES2/PRIMES3 and size-table object initialization, context/profile and root caller instantiation.',
            'Root post-decrement intermediate loop, complete sampled f/g transport through preceding GS/public/search operations and connection to existing depth0/output/validation suffix.',
            'B1.05 Acceptance exact integer NTRU about the same retained material remains NOT_MET; B1.06 not entered.'],
        'limits': 'Unchanged Lean j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors; pp.maxSteps200000; Sage standard preparser ZZ/QQ.',
        'git': {'branch': 'main', 'author': 'niirmataa', 'writer_lock': 'proofs/ft1536/work/archive.lock',
            'source_commits': subprocess.check_output(['git', 'log', '--reverse', '--format=%H %s',
                'dba69ac1..' + head, '--', str(job.ROOT.relative_to(job.REPO))], cwd=job.REPO, text=True).splitlines(),
            'push': 'none; explicit owner signal required', 'foreign_changes': 'preserved'},
        'active_jobs_at_close': []}
    with path(BASE + '.json').open('x') as stream:
        json.dump(output, stream, indent=2); stream.write('\n')
    print(json.dumps({'batch': pin(BASE + '.json'), 'notes': pin(notes),
        'modules': len(details), 'audited': len(audit), 'attempts': len(history),
        'attempt_counts': output['attempt_counts'], 'inputs': output['current_final_audit_inputs'],
        'superseded': superseded, 'counts_per_run': controls['variants'][0]['counts'],
        'max_accepted_rss_kib': max(e['maxrss_kib'] for e in details)}, indent=2))


def verify(batch_sha, notes_sha, receipt):
    checked = {}
    def check(p, expected):
        p = path(p)
        actual = job.sha(p)
        assert actual == expected, (str(p), expected, actual)
        checked[str(p)] = actual
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value: check(value['path'], value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value, list):
            for child in value: walk(child)
    check(BASE + '.json', batch_sha); check(BASE + '_NOTES.md', notes_sha)
    batch = read(BASE + '.json'); walk(batch)
    entry = read(batch['entry_pins_receipt']['path'])
    for p, expected in entry['checked'].items():
        if p in batch['superseded']:
            assert expected == batch['superseded'][p]['entry_pins_028']
            expected = batch['superseded'][p]['batch_028']
        check(p, expected)
    inputs = read(batch['audit']['source_inputs']['path'])
    for e in inputs['sources']: check(e['path'], e['sha256'])
    for e in inputs['reused']:
        check(e.get('current_source', e['source']), e['source_sha256'])
        check(e['artifact'], e['artifact_sha256'])
    assert len(inputs['sources']) + len(inputs['reused']) == batch['current_final_audit_inputs']
    assert not job.active(), 'A proof job is active'
    result = {'utc': datetime.now(timezone.utc).isoformat(), 'batch': 'BATCH_028',
        'checked': checked, 'distinct_pinned_files': len(checked),
        'current_source_inputs': batch['current_final_audit_inputs'], 'active_jobs': [],
        'superseded': batch['superseded'], 'verifier_sha256': job.sha(Path(__file__))}
    target = path(receipt)
    assert target.is_relative_to(job.BUILD.resolve())
    with target.open('x') as stream:
        json.dump(result, stream, indent=2); stream.write('\n')
    print(json.dumps({**{k: v for k, v in result.items() if k != 'checked'}, 'receipt': pin(target)}, indent=2))


if __name__ == '__main__':
    if sys.argv[1:] == ['seal']:
        seal()
    else:
        assert len(sys.argv) == 5 and sys.argv[1] == 'verify', 'seal | verify BATCH_SHA NOTES_SHA NEW_RECEIPT'
        verify(*sys.argv[2:])
