#!/usr/bin/env python3
"""Seal BATCH_018's recoverable B1.04 midpoint; organization, not mathematics."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import subprocess

import job

ROOT = Path(__file__).resolve().parent.parent
REPO = ROOT.parents[4]
OUT = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_018.json'
MODULES = [
    'KeygenNttCells', 'KeygenNttFirstValues', 'KeygenNttPolynomial',
    'KeygenNttFirstComposition', 'KeygenNttGeometry', 'KeygenNttRoots',
    'KeygenNttBinaryValues', 'KeygenNttSubpolynomial', 'ExprAuditDag',
    'KeygenNttEvaluation', 'KeygenNttValuesAudit',
]


def sha(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def pin(path):
    path = ROOT / path
    return {'path': str(path.relative_to(ROOT)), 'sha256': sha(path), 'bytes': path.stat().st_size}


def read(path):
    return json.loads((ROOT / path).read_text())


def streams(directory, record):
    result = {}
    for stream in ['stdout', 'stderr']:
        path = directory / record[stream]
        assert sha(path) == record[stream + '_sha256'], str(path)
        if record['accepted']:
            assert path.stat().st_size == 0, str(path)
        result[stream] = pin(path)
    return result


def main():
    assert not OUT.exists(), 'Never rewrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=REPO, text=True).strip() == 'main'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()
    cache = read('.build/cache/CACHE_INDEX.json')
    accepted = []
    for name in MODULES:
        module = 'Source3.' + name
        entry = cache[module]
        source = Path(entry['source'])
        assert sha(source) == entry['source_sha256'], module
        committed = subprocess.check_output(['git', 'show', head + ':' + str(source.relative_to(REPO))], cwd=REPO)
        assert hashlib.sha256(committed).hexdigest() == entry['source_sha256'], module
        receipt = Path(entry['receipt'])
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
            'elapsed_s': record['elapsed_s'], 'maxrss_kib': record['cumulative_child_maxrss_kib'],
            'all_steps_in_job_accepted': all(r['accepted'] for r in records)})

    final_dir = ROOT / '.build/jobs/keygen_ntt_values_audit_005'
    audit = json.loads((final_dir/'NTT_VALUES_AUDIT.json').read_text())
    dag = json.loads((final_dir/'NTT_PRIME_TERM_DAG.json').read_text())
    assert len(audit) == 85
    for entry in audit:
        assert set(entry['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(entry, ensure_ascii=False)
    dag_entries = [entry for entry in audit if 'term_dag' in entry['body']]
    assert len(dag_entries) == 1 and dag_entries[0]['body']['roundtrip_structural_equality']
    assert dag_entries[0]['name'] == 'FT1536.Source3.KeygenNttRoots.modulusPrime'
    assert dag['format'] == 'Lean.Expr.DAG.v1' and len(dag['nodes']) == 277341
    # Structure checks complement the Lean-side serialized round-trip check.
    child_fields = {'app': [1, 2], 'lam': [2, 3], 'forall': [2, 3], 'let': [2, 3, 4], 'proj': [3]}
    for index, node in enumerate(dag['nodes']):
        assert node[0] in {'app', 'lam', 'forall', 'let', 'proj', 'bvar', 'sort', 'const', 'nat', 'string'}
        for field in child_fields.get(node[0], []):
            assert 0 <= node[field] < index
    assert 0 <= dag['root'] < len(dag['nodes'])

    inventory = json.loads((final_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path']) == entry['sha256'], entry['module']
    for entry in inventory['reused']:
        assert sha(entry.get('current_source', entry['source'])) == entry['source_sha256'], entry['module']
        assert sha(entry['artifact']) == entry['artifact_sha256'], entry['module']

    sage_dir = ROOT / '.build/jobs/keygen_ntt_values_checks_002'
    sage_record = json.loads((sage_dir/'RECEIPTS.json').read_text())[0]
    assert sage_record['accepted'] and sage_record['clean_log'] and sage_record['exit_code'] == 0
    assert sha(ROOT/'sage/check_keygen_ntt_values.sage') == sage_record['source_sha256']
    controls = json.loads((sage_dir/'NTT_VALUES_CHECK.json').read_text())
    assert len(controls['variants']) == 14 and len(controls['points']) == 1536
    for variant in controls['variants']:
        assert len(variant['cases']) == 3 and variant['table_and_guard_preserved']
        label = variant['mode'] + '_' + variant['variant']
        assert sha(sage_dir/(label+'.c')) == variant['c_sha256']
        assert sha(sage_dir/(label+'.stdout')) == variant['stdout_sha256']
        assert (sage_dir/(label+'.stderr')).stat().st_size == 0
        if variant['variant'] == 'baseline':
            assert all(not any(c['differences_by_snapshot']) and not any(c['noncanonical_by_snapshot'])
                       for c in variant['cases'])
        else:
            assert any(any(c['differences_by_snapshot']) for c in variant['cases'])

    preflight = read('.build/ntt_values_018/PREFLIGHT.json')
    history = []
    for directory in sorted((ROOT/'.build/jobs').glob('keygen_ntt_*')):
        pf, receipt = directory/'PREFLIGHT.json', directory/'RECEIPTS.json'
        if not pf.exists() or not receipt.exists() or json.loads(pf.read_text())['utc'] < preflight['utc']:
            continue
        records = json.loads(receipt.read_text())
        steps = []
        for record in records:
            step = {'name': record['name'], 'accepted': record['accepted'], 'clean_log': record['clean_log'],
                'source_sha256': record['source_sha256'], 'elapsed_s': record['elapsed_s'],
                'maxrss_kib': record['cumulative_child_maxrss_kib'], 'logs': streams(directory, record)}
            if not record['accepted']:
                text = (directory/record['stdout']).read_text() + (directory/record['stderr']).read_text()
                step['failure_excerpt'] = [line for line in text.splitlines() if
                    'error:' in line or 'AssertionError' in line or 'PANIC' in line][:4]
            steps.append(step)
        history.append({'job': directory.name, 'receipt': pin(receipt),
            'source_inputs': pin(directory/'SOURCE_INPUTS.json'),
            'status': 'ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED', 'steps': steps})

    pins = {}
    for number in ['015', '016', '017']:
        for suffix in ['.json', '_NOTES.md']:
            path = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_' + number + suffix
            expected = preflight['checked'][str(ROOT/path)]
            assert sha(ROOT/path) == expected
            pins[path] = expected

    result = {
        'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': 'BATCH_018',
        'created_utc': datetime.now(timezone.utc).isoformat(), 'stage': 'B1.04',
        'stage_result': 'PARTIAL_PROOF', 'window': 'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_04_acceptance': 'NOT_MET', 'status': 'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness': 'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note': 'Historical hardcoded model/session labels retained; unchanged serial guarded runner.',
        'runner': pin('tools/job.py'), 'waiter': pin('tools/job_when_available.py'),
        'organizer': pin(Path(__file__).resolve()), 'preflight': pin('.build/ntt_values_018/PREFLIGHT.json'),
        'preflight_program': pin('.build/ntt_values_018/preflight.py'), 'input_pins': pins,
        'preflight_files_checked': len(preflight['checked']),
        'preflight_current_inputs': preflight['current_source_inputs'],
        'proof_head': head, 'accepted_module_checks': accepted,
        'current_final_audit_inputs': len(inventory['sources']) + len(inventory['reused']),
        'contracts': {
            'cells': 'The same executed first/binary/triple butterflies yield canonical ordinary-residue cells, exact formulas in physical store order and disjoint-cell preservation.',
            'first_pass': 'All 768 first butterflies plus the actual gm[1] read; exact two degree-<768 remainders of the existing CoefficientQuotient.polynomial and source w^2-w+1=0.',
            'composition': 'generated_converted_prefix consumes BATCH_017 table generation, actual conversion, prologue and firstPass. Premises are source executions, M0/scalar/pointer/cross-call heap bindings, legal scratch/input separation, original Vec bytes and Bound 2047. No initialized-gm/canonical-result premise remains. It preserves gm and returns the same material first-pass cells/remainders.',
            'binary_block': 'The complete vLoop yields canonical 1536-cell memory, unchanged cells outside its block, and two exact degree-<ht remainders. load_twiddle derives scaled gm[m+u1]. The u1/m loop compositions are still required.',
            'geometry': 'Header t*m=1536 for rounds0..8, seam ht*m=768 before the m doubling, actual butterfly/twiddle bounds and source exit m=512,t=3.',
            'roots': 'Kernel primality, row9/REV10 triple point family h^(E(512+i/3)+1536*(i%3)), 1536 distinct Phi roots, degree/root-count injectivity and quotient multiplication/subtraction transport.',
            'coefficient_equation': 'equation_of_pointwise proves multiply f G - multiply g F = constantCoeffs rhs in ZMod2147355649, conditional on the pointwise equalities. Their complete source derivation and the integer lift remain open.',
            'boundary': 'Pinned C-fragment reference semantics; no compiler theorem, full source NTT evaluation, complete solver, B1.04 Acceptance, emitted-to-fiber theorem or independent review.'
        },
        'audit': {**pin(final_dir/'NTT_VALUES_AUDIT.json'), 'exports': len(audit),
            'full_pretty_terms': sum('term' in e['body'] for e in audit),
            'kernel_structures_with_constructor_types': sum(e['body']['kind'] == 'kernel_inductive' for e in audit),
            'prime_term_dag': pin(final_dir/'NTT_PRIME_TERM_DAG.json'), 'dag_nodes': len(dag['nodes']),
            'dag_roundtrip': 'Parsed serialized JSON reconstructs an Expr.equal term in the audit command. Shared DAG avoids exponential pretty-print expansion without omitting proof nodes.',
            'allowed_axioms': ['propext', 'Classical.choice', 'Quot.sound'], 'elisions': 0,
            'independent_review': False},
        'sage': {'job': sage_dir.name, 'source': pin('sage/check_keygen_ntt_values.sage'),
            'receipt': pin(sage_dir/'RECEIPTS.json'), 'source_inputs': pin(sage_dir/'SOURCE_INPUTS.json'),
            'result': pin(sage_dir/'NTT_VALUES_CHECK.json'), 'logs': streams(sage_dir, sage_record),
            'executions': 14, 'public_arrays_per_execution': 3, 'snapshots_per_array': 10,
            'words_per_snapshot': 1536, 'mutation_families': 6,
            'scope': 'Finite pinned C normal/UBSan controls plus independent Sage direct polynomial evaluation. Baselines agree; six mutations are detected in both modes. Not universal source proof.'},
        'attempt_history': history,
        'retained_failure_notes': [
            'audit_001/_002 exhausted memory while pretty-printing the already checked modulusPrime term; _002 preserved the first52 entries and current-name progress. No proof or resource limit changed.',
            'audit_003 retained DAG-exporter syntax/Option API errors; audit_004 passed79 entries and final audit_005 passed85 after adding quotient evaluation.',
            'values_checks_001 rejected the initial triple mutant for unused fC2 under -Werror; the repaired semantic swap retains both operands. Failed compiler logs and partial successful controls remain.'
        ],
        'limits': 'Unchanged Lean -j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors. Existing exponentiation threshold32768 for the first-root certificate. Audit pp.maxSteps200000 is rendering only. Sage uses the standard preparser.',
        'build_scope': 'Incremental dependency-ordered new modules and changed audit closure, all current source/artifact/import pins checked. No unchanged project-wide replay.',
        'remaining_in_plan_order': [
            'B1.04: compose actual u1Inner read/binds with the proved vLoop; carry memory/table/locals through every u1 and m round.',
            'B1.04: connect block polynomial invariants to even/odd source twiddle-child laws; the top complement case differs from later sign splits.',
            'B1.04: compose source wSquared, all512 triple butterflies and physical point evaluations; consume the prior degree3 block remainders.',
            'B1.04: full forwardBody and generated/converted/same-Vec transform theorem, then Acceptance and scoped handoff.',
            'B1.05-B1.11: solver/integer/public/caller/codecs/fiber and complete final replay.'
        ],
        'git': {'branch': 'main', 'author': 'niirmataa', 'writer_lock': 'proofs/ft1536/work/archive.lock',
            'push': 'none; separate explicit owner signal required', 'foreign_changes': 'preserved'},
        'active_jobs_at_close': [],
    }
    with OUT.open('x') as stream:
        json.dump(result, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256': sha(OUT), 'modules': len(accepted), 'exports': len(audit),
        'audit_sha256': sha(final_dir/'NTT_VALUES_AUDIT.json'), 'dag_sha256': sha(final_dir/'NTT_PRIME_TERM_DAG.json'),
        'controls_sha256': sha(sage_dir/'NTT_VALUES_CHECK.json'), 'attempts': len(history),
        'failed_attempts': sum(e['status'] == 'FAILED_RETAINED' for e in history),
        'current_final_audit_inputs': result['current_final_audit_inputs']}, indent=2))


if __name__ == '__main__':
    main()
