#!/usr/bin/env python3
"""Seal BATCH_019 at B1.04 Acceptance; integrity organization, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess

import job
from keygen_ntt_batch import ROOT, REPO, sha, pin, read, streams

OUT = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_019.json'
MODULES = [
    'KeygenNttControl', 'KeygenNttMiddleValues', 'KeygenNttTripleValues',
    'KeygenNttExecution', 'KeygenNttTwiddleCert', 'KeygenNttTwiddleTree',
    'KeygenNttRoundPolynomial', 'KeygenNttTransform', 'KeygenNttTransformAudit',
]


def main():
    assert not OUT.exists(), 'Never overwrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=REPO, text=True).strip() == 'main'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()
    preflight = read('.build/ntt_composition_019/PREFLIGHT.json')
    for path, expected in preflight['checked'].items():
        assert sha(path) == expected, path
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = []
    for name in MODULES:
        module = 'Source3.' + name
        entry = cache[module]
        source, receipt = Path(entry['source']), Path(entry['receipt'])
        assert sha(source) == entry['source_sha256'], module
        committed = subprocess.check_output(['git', 'show', head + ':' + str(source.relative_to(REPO))], cwd=REPO)
        assert hashlib.sha256(committed).hexdigest() == entry['source_sha256'], module
        directory = receipt.parent
        records = json.loads(receipt.read_text())
        record = next(r for r in records if r['name'] == module.replace('.', '_'))
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert not record['forbidden_proof_markers']
        assert record['cumulative_child_maxrss_kib'] <= 8*1024*1024
        snapshot = directory / 'formal/Source3' / (name + '.lean')
        artifact = directory / 'lib/Source3' / (name + '.olean')
        assert sha(snapshot) == sha(source) == record['source_sha256']
        assert sha(artifact) == sha(entry['artifact']) == record['olean_sha256'] == entry['artifact_sha256']
        for imported, expected in entry.get('imports', {}).items():
            if imported in cache:
                assert cache[imported]['artifact_sha256'] == expected, (module, imported)
        accepted.append({'module': module, 'source': pin(source), 'snapshot': pin(snapshot),
            'artifact': pin(artifact), 'receipt': pin(receipt), 'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'job': directory.name, 'logs': streams(directory, record), 'imports': entry.get('imports', {}),
            'elapsed_s': record['elapsed_s'], 'maxrss_kib': record['cumulative_child_maxrss_kib']})

    final_dir = ROOT/'.build/jobs/keygen_ntt_transform_audit_019_002'
    audit = json.loads((final_dir/'NTT_TRANSFORM_AUDIT.json').read_text())
    assert len(audit) == 131 and len({e['name'] for e in audit}) == 131
    for entry in audit:
        assert set(entry['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(entry, ensure_ascii=False)
    assert sum('term' in e['body'] for e in audit) == 128
    assert sum(e['body']['kind'] == 'kernel_inductive' for e in audit) == 3
    inventory = json.loads((final_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path']) == entry['sha256'], entry.get('module')
    for entry in inventory['reused']:
        assert sha(entry.get('current_source', entry['source'])) == entry['source_sha256'], entry['module']
        assert sha(entry['artifact']) == entry['artifact_sha256'], entry['module']

    sage_dir = ROOT/'.build/jobs/keygen_ntt_children_gen_019_001'
    sage_record = json.loads((sage_dir/'RECEIPTS.json').read_text())[0]
    assert sage_record['accepted'] and sage_record['clean_log'] and sage_record['exit_code'] == 0
    assert sha(ROOT/'sage/generate_keygen_ntt_children.sage') == sage_record['source_sha256']
    generation = json.loads((sage_dir/'NTT_CHILDREN_GENERATION.json').read_text())
    certificate = ROOT/'formal/Source3/KeygenNttTwiddleCert.lean'
    assert sha(sage_dir/'KeygenNttTwiddleCert.lean') == sha(certificate) == generation['sha256']
    assert generation['non_top_parents'] == 510 and generation['chunks'] == 32 and generation['chunk_size'] == 16

    history = []
    for directory in sorted((ROOT/'.build/jobs').glob('keygen_ntt_*_019_*')):
        receipt = directory/'RECEIPTS.json'
        assert receipt.exists(), directory
        records = json.loads(receipt.read_text())
        steps = []
        for record in records:
            snapshot = (directory/'sage/generate_keygen_ntt_children.sage' if record['name'] == 'sage' else
                directory/'formal/Source3'/(record['name'].removeprefix('Source3_')+'.lean'))
            assert sha(snapshot) == record['source_sha256'], snapshot
            step = {'name': record['name'], 'accepted': record['accepted'], 'clean_log': record['clean_log'],
                'source_sha256': record['source_sha256'], 'snapshot': pin(snapshot), 'elapsed_s': record['elapsed_s'],
                'maxrss_kib': record['cumulative_child_maxrss_kib'], 'logs': streams(directory, record)}
            if not record['accepted']:
                text = (directory/record['stdout']).read_text() + (directory/record['stderr']).read_text()
                step['failure_excerpt'] = [line for line in text.splitlines() if 'error:' in line or 'error(' in line][:4]
            steps.append(step)
        history.append({'job': directory.name, 'receipt': pin(receipt),
            'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'status': 'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED', 'steps': steps})
    assert len(history) == 19

    predecessors = {}
    for number in ['015', '016', '017', '018']:
        for suffix in ['.json', '_NOTES.md']:
            path = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_' + number + suffix
            predecessors[path] = preflight['checked'][str(ROOT/path)]

    result = {
        'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': 'BATCH_019', 'stage': 'B1.04',
        'created_utc': datetime.now(timezone.utc).isoformat(), 'window': 'CLOSED_AT_ACCEPTANCE',
        'b1_04_acceptance': 'MET', 'stage_result': 'PROVED_KERNEL_SCOPED',
        'package_result': 'PARTIAL_PROOF', 'status': 'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness': 'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note': 'Historical runner model/session labels retained; unchanged guarded serial execution.',
        'runner': pin('tools/job.py'), 'waiter': pin('tools/job_when_available.py'),
        'organizer': pin(Path(__file__).resolve()), 'organizer_helpers': pin('tools/keygen_ntt_batch.py'),
        'preflight': pin('.build/ntt_composition_019/PREFLIGHT.json'),
        'preflight_program': pin('.build/ntt_composition_019/preflight.py'),
        'preflight_files_checked': len(preflight['checked']), 'preflight_current_inputs': preflight['current_source_inputs'],
        'input_pins': predecessors, 'proof_head': head, 'accepted_module_checks': accepted,
        'current_final_audit_inputs': len(inventory['sources']) + len(inventory['reused']),
        'contracts': {
            'middle': 'The actual u1Inner declarations/read/binds/vLoop, every u1 block and all eight m rounds yield canonical source-ordered arrays, initialized gm and disjoint-cell frames through common heaps. No free nested-trace heap is identified by assumption.',
            'triple': 'wSquared is derived from the actual gm[1] reads and Montgomery call. All512 triple iterations return canonical quadratic evaluations in the fixed physical order and preserve gm.',
            'twiddle_tree': 'Existing source rowExponent/REV10 definitions; 32 kernel chunks cover 512 candidates, with510 non-top signed child identities. h^2304=-1 and the exceptional top complement are derived in the field.',
            'polynomial': 'blocks_values identifies sequential source block updates; low/high polynomial identities and their degree bounds propagate original CoefficientQuotient evaluation through eight rounds. transform_evaluation holds for every coefficient vector and every physical index.',
            'full_body': 'source_values consumes the complete existing parsed forwardBody. source_transform concludes forall i:Fin1536, exists word, Load32 output(element p i) word and Canonical word and value word = polynomial(castVec originalVec).eval(point i).',
            'composition': 'generated_converted_transform consumes table generation, actual coefficient conversion and the complete NTT. Canonical inputs and initialized gm are derived, not premises. Same original four-Vec material and selected slot are retained.',
            'actual_premises': 'Legal source generator/scratch/REV10 entry; executed p0i initialization; actual generation, conversion and forwardBody executions; original four-Vec byte representations with Bound2047; width/layout/separation; actual caller locals/pointers and equal returned/next-entry heaps.',
            'point_family': 'Unchanged BATCH_018 point(i)=h^(E(512+i/3)+1536*(i%3));1536 distinct Phi roots, quotient injectivity and equation_of_pointwise remain checked dependencies.',
            'frame_boundary': 'NTT Frame preserves disjoint canonical32-bit cells. An arbitrary16-bit original-material byte frame for the enclosing solver is not exported here.',
            'scope': 'B1.04 Acceptance in the pinned C-fragment reference semantics. Full caller/allocator, four-transform solver composition, integer lift, codecs, emitted-to-fiber, compiler/machine refinement and independent review are not claimed.'
        },
        'audit': {**pin(final_dir/'NTT_TRANSFORM_AUDIT.json'), 'receipt': pin(final_dir/'RECEIPTS.json'),
            'source_inputs': pin(final_dir/'SOURCE_INPUTS.json'), 'exports': len(audit),
            'full_pretty_terms': 128, 'kernel_structures_with_constructor_types': 3,
            'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'], 'elisions': 0,
            'generator': 'formal/Source3/KeygenNttTransformAudit.lean via the pinned serial Lean job',
            'large_artifact': '11906748-byte regenerable audit remains in durable .build with hash; source generator is tracked.',
            'inherited_prime_dag': pin('.build/jobs/keygen_ntt_values_audit_005/NTT_PRIME_TERM_DAG.json'),
            'independent_review': False},
        'sage': {'job': sage_dir.name, 'source': pin('sage/generate_keygen_ntt_children.sage'),
            'receipt': pin(sage_dir/'RECEIPTS.json'), 'source_inputs': pin(sage_dir/'SOURCE_INPUTS.json'),
            'result': pin(sage_dir/'NTT_CHILDREN_GENERATION.json'), 'logs': streams(sage_dir, sage_record),
            'generated_certificate': pin(sage_dir/'KeygenNttTwiddleCert.lean'),
            'tracked_certificate': pin(certificate), 'scope': 'Exact ZZ standard-preparser generation/checks; separate kernel certificate check accepted.'},
        'inherited_finite_controls': pin('.build/jobs/keygen_ntt_values_checks_002/NTT_VALUES_CHECK.json'),
        'finite_controls_note': 'BATCH_018 normal/UBSan controls of all first/eight middle/final snapshots and six mutations remain pinned. Unchanged C controls were not rerun.',
        'attempt_history': history,
        'retained_failures': 'Eight elaboration/syntax/API/linter failures retained with full snapshots and raw logs; all current sources subsequently accepted. No proof/resource limits changed.',
        'limits': 'Unchanged Lean -j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors. Audit pp.maxSteps200000 affects rendering only. Sage uses the standard preparser.',
        'build_scope': 'Incremental dependency-ordered new modules, current source/artifact/import bindings and final internal audit; no unchanged full-project replay.',
        'next_owner_stage': 'B1.05 source solver success to the exact integer NTRU equation, per the existing EXECUTION_PLAN; not entered in this window.',
        'git': {'branch': 'main', 'author': 'niirmataa', 'writer_lock': 'proofs/ft1536/work/archive.lock',
            'source_commits': ['e58e2a51', '6e6b98d0', '7665543b'], 'push': 'none; explicit owner signal required',
            'foreign_changes': 'preserved'},
        'active_jobs_at_close': [],
    }
    with OUT.open('x') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256': sha(OUT), 'modules': len(accepted), 'exports': len(audit),
        'audit_sha256': sha(final_dir/'NTT_TRANSFORM_AUDIT.json'), 'attempts': len(history),
        'failed_attempts': sum(e['status'] == 'FAILED_RETAINED' for e in history),
        'current_final_audit_inputs': result['current_final_audit_inputs'],
        'max_accepted_rss_kib': max(e['maxrss_kib'] for e in accepted)}, indent=2))


if __name__ == '__main__':
    main()
