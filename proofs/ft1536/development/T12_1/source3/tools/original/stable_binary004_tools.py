#!/usr/bin/env python3
"""One-shot closure/audit organizer; no mathematical computation."""
from pathlib import Path
from hashlib import sha256
import importlib.util
import json
import re
import sys

W = Path(__file__).resolve().parent.parent
RUN = W / 'run'
FORMAL = RUN / 'formal'
ROOTS = ['Source3.StableBinary004Outcome', 'Source3.StableBinary004Audit']
REPORT003 = 'd9e1ee9835a331bc0a0917fb0c4e5d58ed3c9f768d71e7174833ee6db46f9c46'
CLOSURE003 = 'bb5abe4fb8a02a2c1c6645e6f7a71bdb671ae444fd1f49f90c6be583ffeb4e6a'


def digest(p):
    h = sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def source(m):
    return FORMAL / (m.replace('.', '/') + '.lean')


def prior():
    assert digest(RUN / 'STABLE_BINARY_003_REPORT.md') == REPORT003
    assert digest(RUN / 'STABLE_BINARY_003_CLOSURE.json') == CLOSURE003
    p = json.loads((RUN / 'STABLE_BINARY_003_CLOSURE.json').read_text())
    for group in ['modules', 'inherited_modules', 'reused_local_dependencies']:
        for e in p[group]:
            assert digest(W / e['source_path']) == e['source_sha256'], e['module']
            assert digest(W / e['olean_path']) == e['olean_sha256'], e['module']
    for name, pin in p['source_pins'].items():
        assert digest(W / 'inputs/source' / name) == pin, name
    return p


def modules():
    p = prior()
    stop = {e['module'] for g in ['modules', 'inherited_modules', 'reused_local_dependencies'] for e in p[g]}
    seen, order = set(), []

    def visit(m):
        if m in seen or m in stop or not m.startswith('Source3.'):
            return
        seen.add(m)
        for dep in re.findall(r'^import\s+(\S+)', source(m).read_text(), re.M):
            visit(dep)
        order.append(m)
    for m in ROOTS:
        visit(m)
    return order


def exports():
    lines = ['import ' + r for r in ROOTS]
    lines += ['set_option maxRecDepth 32768', 'set_option maxHeartbeats 2000000', '']
    names = []
    for m in modules():
        text = source(m).read_text()
        ns = re.findall(r'^namespace\s+(\S+)', text, re.M)
        assert len(ns) == 1, m
        for th in re.findall(r'^theorem\s+(\w+)', text, re.M):
            full = ns[0] + '.' + th
            names.append(full)
            lines += ['#check @' + full, '#print ' + full, '#print axioms ' + full]
    out = source('Source3.StableBinary004Exports')
    assert not out.exists(), 'preserve generated audits; use a new label if revised'
    out.write_text('\n'.join(lines) + '\n')
    print(json.dumps({'modules': len(modules()), 'theorems': len(names), 'audit_sha256': digest(out)}))


def record(label):
    p = prior()
    ms = modules() + ['Source3.StableBinary004Exports']
    job = RUN / label
    rp = job / 'RECEIPTS.json'
    receipts = json.loads(rp.read_text())
    assert [r['name'] for r in receipts] == [m.replace('.', '_') for m in ms]
    records = []
    for m, r in zip(ms, receipts):
        assert r['accepted'] and r['clean_log'] and r['exit_code'] == 0, m
        assert not r['forbidden_proof_markers'], m
        assert r['cumulative_child_maxrss_kib'] <= 8*1024*1024, m
        sp = source(m)
        op = job / 'lib' / (m.replace('.', '/') + '.olean')
        assert digest(sp) == r['source_sha256'], m
        assert digest(op) == r['olean_sha256'], m
        for name in ['stdout', 'stderr']:
            assert digest(job / r[name]) == r[name + '_sha256'], m
        records.append({'module': m, 'source_path': str(sp.relative_to(W)), 'source_sha256': digest(sp),
            'olean_path': str(op.relative_to(W)), 'olean_sha256': digest(op),
            'receipt_path': str(rp.relative_to(W)), 'receipt_sha256': digest(rp),
            'stdout_path': str((job / r['stdout']).relative_to(W)), 'stdout_sha256': r['stdout_sha256'],
            'stderr_path': str((job / r['stderr']).relative_to(W)), 'stderr_sha256': r['stderr_sha256']})
    text = (job / receipts[-1]['stdout']).read_text()
    axiom_sets = re.findall(r"depends on axioms:\s*\[([^]]*)\]", text)
    allowed = {'propext', 'Classical.choice', 'Quot.sound'}
    for group in axiom_sets:
        assert {a.strip() for a in group.split(',') if a.strip()} <= allowed, group
    expected = len(re.findall(r'^#print axioms ', source(ms[-1]).read_text(), re.M))
    audited = len(axiom_sets) + text.count('does not depend on any axioms')
    assert audited == expected, (audited, expected)
    spec = importlib.util.spec_from_file_location('closure003', RUN / 'stable_binary003_tools.py')
    old = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(old)
    old.ROOTS = ROOTS + [ms[-1]]
    deps = old.dependencies(set(ms))
    out = {'task': 'T12.1/RUN_003/STABLE_BINARY_004',
        'status': 'KERNEL_PROVED_SCOPED; author C99/GCC-LP64 fragment; NOT_REVIEWED; NOT_FROZEN',
        'model': 'openai/gpt-6-astra', 'session': 'ses_f12636605ffeL1FZg4teLUwUf5',
        'prior_report_sha256': REPORT003, 'prior_closure_sha256': CLOSURE003,
        'source_pins': p['source_pins'], 'modules': records, 'theorems_audited': audited,
        'allowed_transitive_axioms': sorted(allowed), 'fresh_job': label,
        'job_runner_sha256': digest(job / 'RUNNER_SOURCE.py'),
        'execution_runner_sha256': digest(job / 'EXECUTION_SOURCE.py'),
        'source_inputs_sha256': digest(job / 'SOURCE_INPUTS.json'),
        'parent_cache_bindings_sha256': digest(W / 'PARENT_CACHE_BINDINGS.json'),
        'config_sha256': digest(RUN / 'CONFIG.json'), 'organizer_sha256': digest(Path(__file__)),
        'dependency_organizer_sha256': digest(RUN / 'stable_binary003_tools.py'),
        'diagnostic_source_sha256': digest(source('Source3.C99HelperCtorAudit')),
        'new_numeric_computation': False, 'inherited_sage_evidence': 'STABLE_BINARY_003_CLOSURE.json',
        **deps}
    target = RUN / 'STABLE_BINARY_004_CLOSURE.json'
    assert not target.exists(), 'preserve prior closure'
    target.write_text(json.dumps(out, sort_keys=True, indent=2) + '\n')
    print(json.dumps({'closure_sha256': digest(target), 'modules': len(ms), 'theorems': audited,
        'seconds': sum(r['seconds'] for r in receipts) if 'seconds' in receipts[0] else None,
        'maxrss_kib': max(r['cumulative_child_maxrss_kib'] for r in receipts)}))


if __name__ == '__main__':
    if sys.argv[1] == 'modules':
        print(' '.join(modules() + ['Source3.StableBinary004Exports']))
    elif sys.argv[1] == 'exports':
        exports()
    elif sys.argv[1] == 'record':
        record(sys.argv[2])
    else:
        raise ValueError('exports/modules/record expected')
