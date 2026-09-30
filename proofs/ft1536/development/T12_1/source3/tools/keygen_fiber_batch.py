#!/usr/bin/env python3
"""Record checked internal work without asserting the full KeyGen theorem."""
import hashlib
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parent.parent
REPO = ROOT.parents[4]
REPORT = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_001.json'
MODULES = [
    'Run2.NTRUBasis', 'FT1536.Geometry', 'FT1536.ROM', 'FT1536.Relation',
    'Run2.CoefficientQuotient', 'Run2.QuotientOperations', 'Run2.ActualNTRUFiber',
    'Source3.KeygenIntegerLift', 'Source3.KeygenSmallOutput', 'Source3.KeygenMaterial',
    'Source3.KeygenFiberAssembly', 'Source3.C99CompareObjects', 'Source3.Gate00Scalar',
    'Source3.Gate00Memory', 'Source3.CertificateReturnLifetime', 'Source3.KeygenFiber001Audit',
]
MODULES_002 = [
    'FftBind.FftPin', 'Source3.C99InitializationTrace', 'Source3.CertificateWorkspace',
    'Source3.FprPrefixCalls', 'Source3.C99ArrayReference', 'Source3.C99ArrayParser',
    'Source3.C99ArrayFrame', 'Source3.FftLeafPrograms', 'Source3.FftLeafFrames',
    'Source3.MontgomeryArithmetic', 'Source3.KeygenModpWord', 'Source3.KeygenMontgomery',
    'Source3.KeygenNinv31', 'Source3.KeygenFiber002Audit',
]


def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def validate_receipt(job, row):
    assert row['accepted'] and row['clean_log'] and row['exit_code'] == 0, row['name']
    assert not row['forbidden_proof_markers'], row['name']
    assert row['cumulative_child_maxrss_kib'] <= 8*1024*1024, row['name']
    for stream in ('stdout', 'stderr'):
        assert sha(job / row[stream]) == row[stream+'_sha256'], (row['name'], stream)


def record(label, batch='001'):
    assert batch in {'001', '002'}
    modules = MODULES if batch == '001' else MODULES_002
    report = ROOT / ('notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_'+batch+'.json')
    job = ROOT / '.build/jobs' / label
    receipt_file = job / 'RECEIPTS.json'
    receipts = json.loads(receipt_file.read_text())
    inputs = json.loads((job / 'SOURCE_INPUTS.json').read_text())
    assert [r['name'] for r in receipts] == [m.replace('.', '_') for m in modules]
    sources = {e['module']: e for e in inputs['sources']}
    rows = []
    for module, row in zip(modules, receipts):
        validate_receipt(job, row)
        source = Path(sources[module]['path'])
        artifact = job / 'lib' / (module.replace('.', '/')+'.olean')
        assert sha(source) == row['source_sha256'] == sources[module]['sha256'], module
        assert sha(artifact) == row['olean_sha256'], module
        rows.append({'module': module, 'source': str(source.relative_to(REPO)),
                     'source_sha256': sha(source), 'artifact': str(artifact.relative_to(ROOT)),
                     'artifact_sha256': sha(artifact), 'stdout': row['stdout'],
                     'stdout_sha256': row['stdout_sha256'], 'stderr_sha256': row['stderr_sha256']})
    audit = (job / receipts[-1]['stdout']).read_text()
    groups = re.findall(r'depends on axioms:\s*\[([^]]*)\]', audit)
    for group in groups:
        assert {a.strip() for a in group.split(',') if a.strip()} <= {'propext', 'Classical.choice', 'Quot.sound'}
    count = len(groups) + audit.count('does not depend on any axioms')
    assert count == 20, count
    reused = {e['module']: e for e in inputs['reused']}
    visited, dependencies, boundary = set(), [], set()

    def visit(module):
        if module in visited:
            return
        visited.add(module)
        if module in sources:
            source = Path(sources[module]['path'])
        elif module in reused:
            entry = reused[module]
            source = Path(entry.get('current_source', entry['source']))
            assert sha(source) == entry['source_sha256'], module
            assert sha(Path(entry['artifact'])) == entry['artifact_sha256'], module
            dependencies.append(entry)
        else:
            assert module.startswith(('Mathlib.', 'Init.', 'Lean.', 'Std.')), module
            boundary.add(module)
            return
        for dep in re.findall(r'^import\s+(\S+)', source.read_text(), re.M):
            visit(dep)

    for module in modules:
        visit(module)
    evidence = []
    evidence_inputs = [
        ('check_keygen_source_helpers.sage', 'keygen_helpers_002', 'KEYGEN_SOURCE_HELPERS.json'),
        ('check_keygen_callgraph.sage', 'keygen_callgraph_002', 'KEYGEN_SOURCE_CALLGRAPH.json'),
    ]
    if batch == '002':
        evidence_inputs.append(('check_keygen_montgomery.sage', 'keygen_montgomery_checks_001', 'KEYGEN_MONTGOMERY_CHECK.json'))
    for filename, run, result in evidence_inputs:
        directory = ROOT / '.build/jobs' / run
        receipt = json.loads((directory / 'RECEIPTS.json').read_text())[0]
        validate_receipt(directory, receipt)
        assert sha(ROOT / 'sage' / filename) == receipt['source_sha256'], filename
        evidence.append({'source': 'sage/'+filename, 'source_sha256': receipt['source_sha256'],
                         'receipt': str((directory/'RECEIPTS.json').relative_to(ROOT)),
                         'receipt_sha256': sha(directory/'RECEIPTS.json'),
                         'result': str((directory/result).relative_to(ROOT)),
                         'result_sha256': sha(directory/result)})
    graph = json.loads((ROOT / evidence[1]['result']).read_text())
    source_root = REPO / 'proofs/ft1536/work/FT1536_MATH_EUFCMA_MTISIS_RUN_002/continuations/FT1536_MATH_EUFCMA_MTISIS_RUN_003/inputs/source'
    assert sha(source_root/'PROFILE.json') == graph['profile_sha256']
    for name, expected in graph['source_pins'].items():
        assert sha(source_root/name) == expected, name
    result = {
        'task': 'KEYGEN_SOURCE_TO_FIBER_001', 'batch': batch, 'status': 'IN_PROGRESS / NOT_REVIEWED',
        'scope': 'Checked internal batch; not a full source KeyGen or full certificate theorem',
        'final_source_theorem_proved': False,
        'modules': rows, 'audited_internal_exports': count, 'dependencies': dependencies,
        'library_boundary': sorted(boundary), 'library_roots': inputs['library_roots'],
        'source_profile_sha256': graph['profile_sha256'], 'source_pins': graph['source_pins'],
        'fresh_job': str(job.relative_to(ROOT)), 'receipt_sha256': sha(receipt_file),
        'source_inputs_sha256': sha(job/'SOURCE_INPUTS.json'),
        'runner_sha256': inputs['runner_sha256'], 'execution_sha256': inputs['execution_sha256'],
        'organizer_sha256': sha(Path(__file__)), 'sage': evidence,
        'elapsed_s': round(sum(r['elapsed_s'] for r in receipts), 3),
        'maxrss_kib': max(r['cumulative_child_maxrss_kib'] for r in receipts),
        'open_obligations': [
            'Full source certificate prefix, FFT3/raw LDL, initialization and frame/lifetime binding',
            'Full source KeyGen execution, final-attempt identity and source encoding/decoding proofs',
            'Source sampler bounds and preservation of the same material across calls',
            'Source NTT/Montgomery check to coefficient congruence modulo 2147355649',
            'Source public computation and inverse equations modulo 18433/Phi',
            'Final emitted_to_actual_fiber composition and its complete mutation coverage',
        ],
    }
    with report.open('x') as stream:
        json.dump(result, stream, indent=2, sort_keys=True)
        stream.write('\n')
    print(json.dumps({'receipt': str(report.relative_to(ROOT)), 'sha256': sha(report),
                      'elapsed_s': result['elapsed_s'], 'maxrss_kib': result['maxrss_kib']}))


if __name__ == '__main__':
    if sys.argv[1:] == ['modules']:
        print(' '.join(MODULES))
    elif sys.argv[1:] == ['modules', '002']:
        print(' '.join(MODULES_002))
    elif len(sys.argv) == 3 and sys.argv[1] == 'record':
        record(sys.argv[2])
    elif len(sys.argv) == 4 and sys.argv[1] == 'record':
        record(sys.argv[2], sys.argv[3])
    else:
        raise SystemExit('usage: keygen_fiber_batch.py modules [002] | record UNIQUE_FRESH_JOB [001|002]')
