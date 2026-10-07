#!/usr/bin/env python3
"""Seal the recoverable B1.05 validation seam; integrity, not review."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess

import job
from keygen_ntt_batch import ROOT, REPO, sha, pin, read, streams

OUT = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_020.json'
MODULES = [
    'KeygenSolverEquation', 'KeygenSolverNttCalls', 'KeygenSolverTransforms',
    'KeygenSolverTarget', 'KeygenNttMemoryFrame', 'KeygenSolverValidation',
    'KeygenSolverValidationAudit',
]


def main():
    assert not OUT.exists(), 'Never overwrite a historical batch receipt'
    assert not job.active(), 'A proof job is still active'
    assert subprocess.check_output(['git', 'branch', '--show-current'], cwd=REPO, text=True).strip() == 'main'
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()
    preflight = read('.build/solver_020/PREFLIGHT.json')
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

    final_dir = ROOT/'.build/jobs/keygen_solver_audit_020_005'
    audit = json.loads((final_dir/'SOLVER_VALIDATION_AUDIT.json').read_text())
    assert len(audit) == 88 and len({e['name'] for e in audit}) == 88
    for entry in audit:
        assert set(entry['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(entry, ensure_ascii=False)
    assert sum('term' in e['body'] for e in audit) == 85
    assert sum(e['body']['kind'] == 'kernel_inductive' for e in audit) == 3
    new_names = set()
    for name in MODULES[:-1]:
        text = (ROOT/'formal/Source3'/(name+'.lean')).read_text()
        new_names.update('FT1536.Source3.'+name+'.'+decl for decl in
            re.findall(r'^(?:def|theorem|structure|inductive)\s+(\w+)', text, re.M))
    assert len(new_names) == 69 and new_names <= {entry['name'] for entry in audit}
    inventory = json.loads((final_dir/'SOURCE_INPUTS.json').read_text())
    for entry in inventory['sources']:
        assert sha(entry['path']) == entry['sha256'], entry.get('module')
    for entry in inventory['reused']:
        assert sha(entry.get('current_source', entry['source'])) == entry['source_sha256'], entry['module']
        assert sha(entry['artifact']) == entry['artifact_sha256'], entry['module']

    sage_dir = ROOT/'.build/jobs/keygen_solver_checks_020_001'
    sage_record = json.loads((sage_dir/'RECEIPTS.json').read_text())[0]
    assert sage_record['accepted'] and sage_record['clean_log'] and sage_record['exit_code'] == 0
    assert sha(ROOT/'sage/check_keygen_solver_validation.sage') == sage_record['source_sha256']
    controls = json.loads((sage_dir/'SOLVER_VALIDATION_CHECK.json').read_text())
    assert len(controls['variants']) == 14 and len(controls['cases']) == 6
    assert sha(sage_dir/'PUBLIC_FIXTURE.json') == controls['fixture_sha256']
    control_files = [pin(sage_dir/'PUBLIC_FIXTURE.json')]
    for variant in controls['variants']:
        label = variant['mode']+'_'+variant['variant']
        for suffix, field in [('.c','source_sha256'),('.stdout','stdout_sha256'),('.stderr','stderr_sha256'),
                              ('.compile.stdout','compile_stdout_sha256'),('.compile.stderr','compile_stderr_sha256')]:
            path = sage_dir/(label+suffix)
            assert sha(path) == variant[field], str(path)
            if suffix in {'.stderr','.compile.stdout','.compile.stderr'}:
                assert path.stat().st_size == 0
            control_files.append(pin(path))
        assert any(variant['differences']) == (variant['variant'] != 'baseline')
        assert all(row[3:] == [1,0,0,0] for row in variant['rows'])

    history = []
    for directory in sorted((ROOT/'.build/jobs').glob('*_020_*')):
        inventory_file = directory/'SOURCE_INPUTS.json'
        inputs = json.loads(inventory_file.read_text())
        snapshots = []
        for entry in inputs['sources']:
            relative = ('formal/'+entry['module'].replace('.','/')+'.lean' if 'module' in entry else
                        'sage/'+Path(entry['path']).name)
            snapshot = directory/relative
            assert sha(snapshot) == entry['sha256'], snapshot
            snapshots.append(pin(snapshot))
        receipt = directory/'RECEIPTS.json'
        evidence = {'job': directory.name, 'source_inputs': pin(inventory_file),
                    'preflight': pin(directory/'PREFLIGHT.json'), 'snapshots': snapshots}
        if not receipt.exists():
            assert directory.name == 'keygen_solver_equation_020_001'
            evidence.update(status='INTERRUPTED_NO_RECEIPT', explanation=pin(directory/'INTERRUPTED.md'),
                logs=[pin(p) for p in sorted((directory/'logs').glob('*'))])
        else:
            records = json.loads(receipt.read_text())
            steps = []
            for record in records:
                step = {'name': record['name'], 'accepted': record['accepted'], 'clean_log': record['clean_log'],
                    'source_sha256': record['source_sha256'], 'elapsed_s': record['elapsed_s'],
                    'maxrss_kib': record['cumulative_child_maxrss_kib'], 'logs': streams(directory, record)}
                if not record['accepted']:
                    text = (directory/record['stdout']).read_text()+(directory/record['stderr']).read_text()
                    step['failure_excerpt'] = [line for line in text.splitlines() if 'error:' in line or 'error(' in line][:4]
                steps.append(step)
            evidence.update(receipt=pin(receipt), steps=steps,
                status='ACCEPTED' if all(r['accepted'] for r in records) else 'FAILED_RETAINED',
                products=[pin(p) for p in sorted(directory.glob('*.json'))
                          if p.name not in {'SOURCE_INPUTS.json','RECEIPTS.json','PREFLIGHT.json'}])
        wait = ROOT/'.build/waits'/directory.name/'WAIT.jsonl'
        if wait.exists():
            evidence['wait'] = pin(wait)
        history.append(evidence)
    assert len(history) == 19

    predecessors = {}
    for number in ['015','016','017','018','019']:
        for suffix in ['.json','_NOTES.md']:
            path = 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_'+number+suffix
            predecessors[path] = preflight['checked'][str(ROOT/path)]
    result = {
        'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': 'BATCH_020', 'stage': 'B1.05',
        'created_utc': datetime.now(timezone.utc).isoformat(), 'window': 'CLOSED_AT_RECOVERABLE_MIDPOINT',
        'b1_05_acceptance': 'NOT_MET', 'stage_result': 'PARTIAL_PROOF',
        'status': 'IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN',
        'harness': 'GPT-6 Astra Ultrafast / openai/gpt-6-astra-ultrafast',
        'runner_note': 'Historical runner model/session labels retained; unchanged guarded serial execution.',
        'runner': pin('tools/job.py'), 'waiter': pin('tools/job_when_available.py'),
        'organizer': pin(Path(__file__).resolve()), 'organizer_helpers': pin('tools/keygen_ntt_batch.py'),
        'preflight': pin('.build/solver_020/PREFLIGHT.json'), 'preflight_program': pin('.build/solver_020/preflight.py'),
        'preflight_files_checked': len(preflight['checked']), 'preflight_current_inputs': preflight['current_source_inputs'],
        'input_pins': predecessors, 'proof_head': head, 'accepted_module_checks': accepted,
        'current_final_audit_inputs': len(inventory['sources'])+len(inventory['reused']),
        'contracts': {
            'calls': 'The four parsed statements and fixed NTT call stratum bind actual argument evaluations, the stride1 macro and complete forwardBody execution. Caller locals/pointers are restored, only the returned heap changes.',
            'sequence': 'Each transform preserves exact canonical words of later inputs and Images of earlier outputs. All four Images concern the same original vectors through common States.',
            'target': 'The actual r assignment executes modp_montymul(18433,1,p,p0i), with signed source literals converted to uint32 parameters. Check locals, pointers and canonical words are derived.',
            'equation': 'Successful parsed final comparison -> pointwise equations -> coefficient quotient equation -> zero integer residual modulo2147355649 -> exact integer NTRU using37748737.',
            'byte_frame': 'Pointer provenance and actual Store32 boundaries derive preservation outside the scratch object, including original16-bit f/g/F/G bytes. No canonical-cell premise is used for this frame.',
            'composition': 'generated_converted_checked starts at table generation, follows conversion, four source-bound calls and target/check return1, and concludes Equation v plus Represents finalHeap originalInput v for all four slots.',
            'remaining_premises': 'Source generator Entry/legal memory/static REV10; source p0i execution; original four-Vec representation and Bounds(1,1,2047,2047); scratch/input separation; actual generation/conversion/calls/validation executions; caller layout and scalar/pointer slots; equality of generation return and conversion entry heaps.',
            'open': 'Full active solve_NTRU graph and enclosing caller derivation; complete executed poly_big_to_small/zint_one_to_plain; MODE1 draw/rejection/store loop and input-preserving pre-validation search; derivation of the remaining bounds and caller bindings. No solver_correct premise, solver theorem or B1.05 Acceptance is claimed.',
        },
        'audit': {**pin(final_dir/'SOLVER_VALIDATION_AUDIT.json'), 'receipt': pin(final_dir/'RECEIPTS.json'),
            'source_inputs': pin(final_dir/'SOURCE_INPUTS.json'), 'exports': 88, 'new_declarations':69,
            'full_pretty_terms':85, 'kernel_structures_with_constructor_types':3,
            'allowed_axioms':['propext','Classical.choice','Quot.sound'], 'elisions':0,
            'generator':'formal/Source3/KeygenSolverValidationAudit.lean', 'independent_review':False},
        'sage': {'job':sage_dir.name, 'source':pin('sage/check_keygen_solver_validation.sage'),
            'receipt':pin(sage_dir/'RECEIPTS.json'), 'source_inputs':pin(sage_dir/'SOURCE_INPUTS.json'),
            'result':pin(sage_dir/'SOLVER_VALIDATION_CHECK.json'), 'logs':streams(sage_dir,sage_record),
            'artifacts':control_files, 'executions':14, 'cases_per_execution':6, 'mutation_families':6,
            'scope':'Finite public synthetic validation and small-output controls, exact QQ/ZZ Sage and normal/UBSan C; no whole-solver or sampler proof.'},
        'attempt_history':history,
        'retained_failures': 'Ten failed attempts and one interrupted outer-shell launch. Audit001 rejected a truncated print; audit002 rejected metadata in the inherited annotation-free DAG exporter. The binding proof was simplified without changing its statement; the final88-entry audit has complete flat terms. All affected descendants were rebuilt. No limits/warnings were relaxed.',
        'limits':'Unchanged Lean -j1/-M6144, maxRecDepth32768/maxHeartbeats2000000, wall1800s, AS12GiB/RSS8GiB, warnings as errors. pp.maxSteps200000 is rendering only. Sage uses the standard preparser. Outer shell waits after the interrupted attempt have no timeout.',
        'build_scope':'Incremental new modules, then the complete affected closure after binding-proof simplification; no unchanged whole-project replay.',
        'next_owner_stage':'Resume B1.05 at the original-material bounds and complete active solver/caller graph, per checkpoint section6. B1.06 not entered.',
        'git':{'branch':'main','author':'niirmataa','writer_lock':'proofs/ft1536/work/archive.lock',
            'source_commits':['b4c2e87f','e92271d2',head],'push':'none; explicit owner signal required','foreign_changes':'preserved'},
        'active_jobs_at_close':[],
    }
    with OUT.open('x') as stream:
        json.dump(result,stream,indent=2)
        stream.write('\n')
    print(json.dumps({'batch_sha256':sha(OUT),'modules':len(accepted),'exports':len(audit),
        'audit_sha256':sha(final_dir/'SOLVER_VALIDATION_AUDIT.json'),'attempts':len(history),
        'failed_attempts':sum(e['status']=='FAILED_RETAINED' for e in history),
        'interrupted_attempts':sum(e['status']=='INTERRUPTED_NO_RECEIPT' for e in history),
        'current_final_audit_inputs':result['current_final_audit_inputs'],
        'max_accepted_rss_kib':max(e['maxrss_kib'] for e in accepted)},indent=2))


if __name__ == '__main__':
    main()
