#!/usr/bin/env python3
"""Organization/hash tooling for STABLE_BINARY_003; not mathematical evidence."""
from pathlib import Path
from hashlib import sha256
import json
import re
import sys

W = Path(__file__).resolve().parent.parent
RUN = W / 'run'
FORMAL = RUN / 'formal'
ROOTS = ['Source3.StableBinary003Outcome', 'Source3.C99CompletenessObligations',
         'Source3.StableBinary003Audit']
OLD_CLOSURE_SHA = 'f013bd471f4b7bda4eccca1748c5517e3c9c45d04816122558d5230872d5ff51'
OLD_REPORT_SHA = '051ea643c13519fe538e024afdb2cd7da160691d42733661c9094d761da70102'


def digest(p):
    h = sha256()
    with p.open('rb') as f:
        for buf in iter(lambda: f.read(1048576), b''):
            h.update(buf)
    return h.hexdigest()


def source(module):
    return FORMAL / (module.replace('.', '/') + '.lean')


def dependencies(covered):
    """Check reused local and frozen task imports down to pinned libraries."""
    config = json.loads((RUN / 'CONFIG.json').read_text())
    parent_formal = Path(config['parent_frozen']) / 'formal'
    parent_records = json.loads((W / 'PARENT_CACHE_BINDINGS.json').read_text())
    parent_map = {}
    for entry in parent_records:
        rel = Path(entry['source']).relative_to(parent_formal)
        parent_map[str(rel.with_suffix('')).replace('/', '.')] = entry
    accepted = []
    for rp in RUN.glob('*/RECEIPTS.json'):
        for rec in json.loads(rp.read_text()):
            if rec.get('accepted') and rec.get('clean_log') and rec.get('olean_sha256'):
                accepted.append((rp, rec))
    seen, reused, frozen, boundary = set(), [], [], set()

    def visit(module):
        if module in seen:
            return
        seen.add(module)
        p = source(module)
        if p.exists():
            artifact = RUN / 'devlib' / (module.replace('.', '/') + '.olean')
            if module not in covered:
                sh, oh = digest(p), digest(artifact)
                matches = [(rp, r) for rp, r in accepted if r.get('source_sha256') == sh
                           and r.get('olean_sha256') == oh]
                assert matches, 'unbound local dependency: ' + module
                rp, rec = max(matches, key=lambda item: item[1]['start'])
                reused.append({'module': module, 'source_path': str(p.relative_to(W)),
                    'source_sha256': sh, 'olean_path': str(artifact.relative_to(W)),
                    'olean_sha256': oh, 'receipt_path': str(rp.relative_to(W)),
                    'receipt_sha256': digest(rp), 'stdout_sha256': rec['stdout_sha256'],
                    'stderr_sha256': rec['stderr_sha256']})
        elif module in parent_map:
            entry = parent_map[module]
            p = Path(entry['source'])
            assert digest(p) == entry['source_sha256'], module
            assert digest(Path(entry['artifact'])) == entry['artifact_sha256'], module
            frozen.append({'module': module, **entry})
        else:
            boundary.add(module)
            return
        for line in p.read_text().splitlines():
            if line.startswith('import '):
                for imported in line.split()[1:]:
                    if imported.startswith('--'):
                        break
                    visit(imported)
    for root in ROOTS + ['Source3.StableBinary003Exports']:
        visit(root)
    return {'reused_local_dependencies': sorted(reused, key=lambda e: e['module']),
            'frozen_task_dependencies': sorted(frozen, key=lambda e: e['module']),
            'library_boundary_imports': sorted(boundary),
            'library_roots': config['library_roots']}


def new_modules():
    old = json.loads((RUN / 'STABLE_BINARY_002_CLOSURE.json').read_text())
    stop = {v['module'] for v in old['modules']}
    stop.add('Source3.StableBinaryFpr')
    seen, order = set(), []

    def visit(module):
        if module in seen or module in stop or not module.startswith('Source3.'):
            return
        seen.add(module)
        text = source(module).read_text()
        for imported in re.findall(r'^import\s+(\S+)', text, re.M):
            visit(imported)
        order.append(module)
    for root in ROOTS:
        visit(root)
    return order


def export_audit():
    modules = new_modules()
    lines = ['import ' + r for r in ROOTS]
    lines += ['set_option maxRecDepth 32768', 'set_option maxHeartbeats 2000000', '']
    exports = []
    for module in modules:
        text = source(module).read_text()
        namespaces = re.findall(r'^namespace\s+(\S+)', text, re.M)
        assert len(namespaces) == 1, module
        ns = namespaces[0]
        for theorem in re.findall(r'^theorem\s+(\w+)', text, re.M):
            full = ns + '.' + theorem
            exports.append(full)
            lines += ['#check @' + full, '#print ' + full, '#print axioms ' + full]
    path = source('Source3.StableBinary003Exports')
    if path.exists():
        raise ValueError('audit source already exists; do not overwrite a pinned attempt')
    path.write_text('\n'.join(lines) + '\n')
    print('EXPORT_AUDIT_CREATED', len(modules), len(exports), digest(path))


def record(label):
    assert digest(RUN / 'STABLE_BINARY_002_CLOSURE.json') == OLD_CLOSURE_SHA
    assert digest(RUN / 'STABLE_BINARY_002_REPORT.md') == OLD_REPORT_SHA
    modules = new_modules() + ['Source3.StableBinary003Exports']
    job = RUN / label
    receipts_path = job / 'RECEIPTS.json'
    receipts = json.loads(receipts_path.read_text())
    assert [r['name'] for r in receipts] == [m.replace('.', '_') for m in modules]
    records = []
    for module, r in zip(modules, receipts):
        assert r['exit_code'] == 0 and r['accepted'] and r['clean_log'], module
        assert not r['forbidden_proof_markers'], module
        p = source(module)
        artifact = job / 'lib' / (module.replace('.', '/') + '.olean')
        assert digest(p) == r['source_sha256'], module
        assert digest(artifact) == r['olean_sha256'], module
        assert digest(job / r['stdout']) == r['stdout_sha256'], module
        assert digest(job / r['stderr']) == r['stderr_sha256'], module
        records.append({'module': module, 'source_path': str(p.relative_to(W)),
            'source_sha256': digest(p), 'olean_path': str(artifact.relative_to(W)),
            'olean_sha256': digest(artifact), 'receipt_path': str(receipts_path.relative_to(W)),
            'receipt_sha256': digest(receipts_path), 'stdout_path': str((job / r['stdout']).relative_to(W)),
            'stdout_sha256': r['stdout_sha256'], 'stderr_sha256': r['stderr_sha256']})
    prior = json.loads((RUN / 'STABLE_BINARY_002_CLOSURE.json').read_text())
    for entry in prior['modules']:
        assert digest(W / entry['source_path']) == entry['source_sha256'], entry['module']
        assert digest(W / entry['olean_path']) == entry['olean_sha256'], entry['module']
    for name, expected in prior['source_pins'].items():
        assert digest(W / 'inputs/source' / name) == expected, name
    # Numeric bounds are an exact Sage cross-check, not a dependency of the proofs.
    sage = RUN / 'stable_binary003_sage_bounds_001/RECEIPTS.json'
    sr = json.loads(sage.read_text())[0]
    assert sr['accepted'] and sr['clean_log'] and sr['exit_code'] == 0
    assert digest(RUN / 'sage/check_stable_binary_totality.sage') == sr['source_sha256']
    out = {
        'task': 'T12.1/RUN_003/STABLE_BINARY_003',
        'status': 'PARTIAL_PROOF; A1/A2/A3 kernel-proved; B not complete',
        'model': 'openai/gpt-6-astra', 'session': 'ses_f12636605ffeL1FZg4teLUwUf5',
        'prior_report_sha256': OLD_REPORT_SHA, 'prior_closure_sha256': OLD_CLOSURE_SHA,
        'source_pins': prior['source_pins'], 'inherited_modules': prior['modules'],
        'modules': records, 'execution_runner_sha256': digest(job / 'EXECUTION_SOURCE.py'),
        'job_runner_sha256': digest(job / 'RUNNER_SOURCE.py'),
        'source_inputs_sha256': digest(job / 'SOURCE_INPUTS.json'),
        'parent_cache_bindings_sha256': digest(W / 'PARENT_CACHE_BINDINGS.json'),
        'config_sha256': digest(RUN / 'CONFIG.json'),
        'sage_receipt_path': str(sage.relative_to(W)), 'sage_receipt_sha256': digest(sage),
        'sage_ranges_sha256': digest(sage.parent / 'TOTALITY_RANGES.json'),
        'ast_emitter_source_sha256': digest(source('Source3.EmitFprAST')),
        'ast_emitter_receipt_sha256': digest(RUN / 'stable_binary003_emit_ast_002/RECEIPTS.json'),
        'ast_emitter_stdout_sha256': digest(RUN / 'stable_binary003_emit_ast_002/logs/Source3_EmitFprAST.stdout'),
        'organizer_sha256': digest(Path(__file__)),
        **dependencies(set(modules) | {m['module'] for m in prior['modules']}),
    }
    target = RUN / 'STABLE_BINARY_003_CLOSURE.json'
    if target.exists():
        raise ValueError('closure exists; preserve prior bytes before revision')
    target.write_text(json.dumps(out, sort_keys=True, indent=2) + '\n')
    print('STABLE_BINARY003_CLOSURE_PASS', len(records), digest(target))


if __name__ == '__main__':
    if sys.argv[1] == 'exports':
        export_audit()
    elif sys.argv[1] == 'modules':
        print(' '.join(new_modules() + ['Source3.StableBinary003Exports']))
    elif sys.argv[1] == 'record':
        record(sys.argv[2])
    else:
        raise ValueError('expected exports/modules/record')
