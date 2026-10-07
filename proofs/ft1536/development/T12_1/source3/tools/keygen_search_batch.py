#!/usr/bin/env python3
"""Seal BATCH_023's recoverable search midpoint; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

import job
from keygen_ntt_batch import ROOT, REPO, sha, pin, read, streams
from keygen_search_audit_source import MODULES, INHERITED

OUT = ROOT/'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_023.json'


def committed(path, head):
    data = subprocess.check_output(['git', 'show', head+':'+str(path.relative_to(REPO))], cwd=REPO)
    assert hashlib.sha256(data).hexdigest() == sha(path), path


def main():
    assert not OUT.exists(), 'Never overwrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=REPO, text=True).strip() == 'main'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()
    preflight = read('.build/search_023/PREFLIGHT.json')
    assert len(preflight['checked']) == 2317 and preflight['current_source_inputs'] == 433
    for path, expected in preflight['checked'].items():
        assert sha(path) == expected, path
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = []
    for name in MODULES+['KeygenSearchAudit']:
        module = 'Source3.'+name
        entry = cache[module]
        source, receipt = Path(entry['source']), Path(entry['receipt'])
        assert sha(source) == entry['source_sha256'], module
        committed(source, head)
        directory = receipt.parent
        records = json.loads(receipt.read_text())
        record = next(r for r in records if r['name'] == module.replace('.', '_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert not record['forbidden_proof_markers']
        assert record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory/'formal/Source3'/(name+'.lean')
        artifact = directory/'lib/Source3'/(name+'.olean')
        assert sha(snapshot) == sha(source) == record['source_sha256']
        assert sha(artifact) == sha(entry['artifact']) == record['olean_sha256'] == entry['artifact_sha256']
        for imported, expected in entry.get('imports', {}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module, imported)
        accepted.append({'module': module, 'source': pin(source), 'snapshot': pin(snapshot),
            'artifact': pin(artifact), 'receipt': pin(receipt), 'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'job': directory.name, 'logs': streams(directory, record), 'imports': entry.get('imports', {}),
            'elapsed_s': record['elapsed_s'], 'maxrss_kib': record['cumulative_child_maxrss_kib'],
            'all_steps_in_job_accepted': all(r['accepted'] for r in records)})

    audit_dir = Path(cache['Source3.KeygenSearchAudit']['receipt']).parent
    audit = json.loads((audit_dir/'SEARCH_AUDIT.json').read_text())
    new_names = set()
    for name in MODULES:
        text = (ROOT/'formal/Source3'/(name+'.lean')).read_text()
        new_names.update('FT1536.Source3.'+name+'.'+n for n in
            re.findall(r'^\s*(?:def|theorem|structure|inductive)\s+(\w+)', text, re.M))
    assert len(audit) == len({e['name'] for e in audit}) == len(new_names)+len(INHERITED)
    assert new_names <= {e['name'] for e in audit}
    for entry in audit:
        assert set(entry['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(entry, ensure_ascii=False)
    inventory = json.loads((audit_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path']) == entry['sha256'], entry.get('module')
    for entry in inventory['reused']:
        assert sha(entry.get('current_source', entry['source'])) == entry['source_sha256'], entry['module']
        assert sha(entry['artifact']) == entry['artifact_sha256'], entry['module']
    input_count = len(inventory['sources'])+len(inventory['reused'])

    directory = ROOT/'.build/jobs/keygen_search_checks_023_001'
    record = json.loads((directory/'RECEIPTS.json').read_text())[0]
    assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
    source = ROOT/'sage/check_keygen_search.sage'
    assert sha(source) == sha(directory/'sage'/source.name) == record['source_sha256']
    committed(source, head)
    controls = json.loads((directory/'SEARCH_CHECK.json').read_text())
    assert controls['cases'] == 7 and len(controls['variants']) == 14
    assert sha(directory/'PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    assert sha(job.OLD/'inputs/source/PROFILE.json') == controls['profile_sha256']
    for name, expected in controls['source_pins'].items():
        assert sha(job.OLD/'inputs/source'/name) == expected, name
    artifacts = [pin(directory/'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        assert bool(variant['differences']) == (variant['variant'] != 'baseline')
        for path, expected in variant['artifacts'].items():
            path = directory/path
            assert sha(path) == expected, path
            artifacts.append(pin(path))
    sage = {'job': directory.name, 'source': pin(source), 'snapshot': pin(directory/'sage'/source.name),
        'receipt': pin(directory/'RECEIPTS.json'), 'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
        'result': pin(directory/'SEARCH_CHECK.json'), 'logs': streams(directory, record), 'artifacts': artifacts}

    history = []
    for directory in sorted((ROOT/'.build/jobs').glob('*_023_*')):
        records = json.loads((directory/'RECEIPTS.json').read_text())
        inputs = json.loads((directory/'SOURCE_INPUTS.json').read_text())
        snapshots = []
        for entry in inputs['sources']:
            rel = 'formal/'+entry['module'].replace('.', '/')+'.lean' if 'module' in entry else 'sage/'+Path(entry['path']).name
            snapshot = directory/rel
            assert sha(snapshot) == entry['sha256'], snapshot
            snapshots.append(pin(snapshot))
        diagnostic = directory.name == 'keygen_search_probe_023_001'
        steps = []
        for record in records:
            if diagnostic:
                assert record['accepted'] and (directory/record['stdout']).read_text() == 'none\n'
                logs = {}
                for stream in ['stdout', 'stderr']:
                    path = directory/record[stream]
                    assert sha(path) == record[stream+'_sha256']
                    logs[stream] = pin(path)
            else:
                logs = streams(directory, record)
            step = {'name': record['name'], 'runner_accepted': record['accepted'],
                'proof_accepted': record['accepted'] and not diagnostic, 'clean_log': record['clean_log'],
                'source_sha256': record['source_sha256'], 'elapsed_s': record['elapsed_s'],
                'maxrss_kib': record['cumulative_child_maxrss_kib'], 'logs': logs}
            if not record['accepted']:
                text = (directory/record['stdout']).read_text()+(directory/record['stderr']).read_text()
                step['failure_excerpt'] = [s for s in text.splitlines() if 'error' in s.lower()][:8]
            steps.append(step)
        status = 'DIAGNOSTIC_NONEMPTY_STDOUT' if diagnostic else (
            'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED')
        common = {'job': directory.name, 'status': status, 'preflight': pin(directory/'PREFLIGHT.json'),
            'receipt': pin(directory/'RECEIPTS.json'), 'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'snapshots': snapshots, 'steps': steps,
            'products': [pin(p) for p in sorted(directory.glob('*.json')) if p.name not in {
                'SOURCE_INPUTS.json', 'RECEIPTS.json', 'PREFLIGHT.json'}]}
        wait = ROOT/'.build/waits'/directory.name/'WAIT.jsonl'
        if wait.exists():
            common['wait'] = pin(wait)
        history.append(common)
    counts = {status: sum(e['status'] == status for e in history) for status in
        ['ACCEPTED', 'FAILED_RETAINED', 'DIAGNOSTIC_NONEMPTY_STDOUT']}
    predecessors = {path: expected for path, expected in preflight['checked'].items()
        if '/notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_' in path and Path(path).name.endswith(('.json', '_NOTES.md'))}
    result = {'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': 'BATCH_023', 'stage': 'B1.05',
        'created_utc': datetime.now(timezone.utc).isoformat(), 'window': 'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_05_acceptance': 'NOT_MET', 'stage_result': 'PARTIAL_PROOF',
        'status': 'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness': 'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note': 'Historical runner model/session labels remain provenance.',
        'runner': pin('tools/job.py'), 'waiter': pin('tools/job_when_available.py'),
        'organizer': pin(Path(__file__).resolve()), 'organizer_helpers': pin('tools/keygen_ntt_batch.py'),
        'verifier': pin('tools/keygen_search_verify.py'),
        'audit_source_generator': pin('tools/keygen_search_audit_source.py'),
        'audit_generator_template': pin('formal/Source3/KeygenSmallBoundsAudit.lean'),
        'preflight': pin('.build/search_023/PREFLIGHT.json'), 'preflight_program': pin('tools/keygen_search_preflight.py'),
        'preflight_files_checked': 2317, 'preflight_current_inputs': 433, 'input_pins': predecessors,
        'proof_head': head, 'accepted_module_checks': accepted, 'current_final_audit_inputs': input_count,
        'contracts': {
            'depth0': 'Complete pinned7051--7273 ternary_depth0 body with five parsed statement-boundary pieces, local FPC macro/scaffold, actual context reads, casts/alignment, overlap-safe memmove, small-to-fpr, FFT/iFFT/invnorm/multiply and rint; no arbitrary search callee.',
            'frame': 'Call.frame and material derive unchanged caller f/g bytes from executed source and legal separation from scratch/static table objects. No assumed heap-frame or transform result.',
            'return': 'Every finite completed depth0 Call returns int32 1, derived from checked source control and function-boundary conversion.',
            'composition': 'call_gate_validated transports incoming f/g through depth0 and the actual output gate, derives F/G Bound2047, and feeds the same four vectors to inherited exact NTRU validation.',
            'entry_boundary': 'Typed LP64 context/pointer allocation environment, actual fk binding/member reads, source globals/typed views, incoming f/g Represents/Bound1, root caller slots and inherited Validation execution/legal bindings remain local inputs.',
            'open': 'Full solve_NTRU root, deepest and intermediate search closure, post-decrement loop and root validation initializers; sampled f/g transport through all preceding attempt gates/search; concrete sampler context/global/profile/caller binding. No full successful-solver claim.'},
        'audit': {**pin(audit_dir/'SEARCH_AUDIT.json'), 'receipt': pin(audit_dir/'RECEIPTS.json'),
            'source_inputs': pin(audit_dir/'SOURCE_INPUTS.json'), 'exports': len(audit), 'new_declarations': len(new_names),
            'full_pretty_terms': sum('term' in e['body'] for e in audit),
            'kernel_inductives_with_constructor_types': sum(e['body']['kind'] == 'kernel_inductive' for e in audit),
            'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'], 'elisions': 0,
            'generator': 'formal/Source3/KeygenSearchAudit.lean', 'independent_review': False},
        'sage': sage, 'attempt_history': history, 'attempt_counts': counts,
        'retained_failures': 'All failed snapshots/raw streams retained. Monolithic inherited audit and recursive footprint simplification exceeded unchanged memory limits. Chunk lemmas and explicit sequence composition resolved them. Initial lexer diagnostic printed none; runner acceptance is not proof acceptance for that attempt.',
        'limits': 'Unchanged Lean-j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors, pp.maxSteps200000. Sage standard preparser.',
        'build_scope': 'New search dependency closure and audit only; all current accepted Lean logs0/0. No unchanged broad replay or independent review.',
        'next_owner_stage': 'Resume B1.05 checkpoint section6: deepest/intermediate full source execution, root caller and actual sampled-material transport; B1.06 not entered.',
        'git': {'branch': 'main', 'author': 'niirmataa', 'writer_lock': 'proofs/ft1536/work/archive.lock',
            'source_commits': ['409c3ae9', '633c6200', head], 'push': 'none; owner signal required', 'foreign_changes': 'preserved'},
        'active_jobs_at_close': []}
    with OUT.open('x') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256': sha(OUT), 'modules': len(accepted), 'exports': len(audit),
        'attempts': len(history), 'counts': counts, 'current_final_audit_inputs': input_count,
        'max_accepted_rss_kib': max(e['maxrss_kib'] for e in accepted)}, indent=2))


if __name__ == '__main__':
    main()
