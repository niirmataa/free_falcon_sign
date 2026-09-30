#!/usr/bin/env python3
"""Bind source/log/axiom evidence for the M6 progress; no mathematical calculations."""
import hashlib
import json
from pathlib import Path
import re

W = Path(__file__).resolve().parent.parent
BUILD = W / 'run/m6_fresh_kernel_001'
SAGE = W / 'run/m6_kernel_margins_002'


def sha(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(1048576), b''):
            h.update(chunk)
    return h.hexdigest()


def bind(path):
    return {'path': path.relative_to(W).as_posix(), 'sha256': sha(path)}


def checked_run(root):
    receipts = json.loads((root / 'RECEIPTS.json').read_text())
    sources = json.loads((root / 'SOURCE_INPUTS.json').read_text())['sources']
    for source in sources:
        path = Path(source['path'])
        assert path.is_relative_to(W)
        assert sha(path) == source['sha256'], ('changed source', str(path))
    for receipt in receipts:
        assert receipt['exit_code'] == 0 and not receipt['timeout']
        out, err = root / receipt['stdout'], root / receipt['stderr']
        assert sha(out) == receipt['stdout_sha256']
        assert sha(err) == receipt['stderr_sha256']
        assert not err.read_bytes(), str(err)
        assert not re.search(r'\b(?:warning|error):', out.read_text()), str(out)
    return receipts, sources


def main():
    lean, sources = checked_run(BUILD)
    sage, sage_sources = checked_run(SAGE)
    assert len(lean) == len(sources) == 33
    assert len(sage) == len(sage_sources) == 1
    for source in sources:
        rel = Path(source['path']).relative_to(W / 'run/formal')
        local = BUILD / 'lib' / rel.with_suffix('.olean')
        assert local.is_file() and not local.is_symlink(), str(local)
        assert sha(BUILD / 'formal' / rel) == source['sha256']
    audit = BUILD / 'logs/Run2_M6Audit.stdout'
    text = audit.read_text()
    exports = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", text)
    assert len(exports) == 13
    allowed = {'propext', 'Classical.choice', 'Quot.sound'}
    axioms = []
    for name, raw in exports:
        used = {x.strip() for x in raw.split(',') if x.strip()}
        assert used <= allowed, (name, used)
        axioms.append({'declaration': name, 'transitive_axioms': sorted(used)})
    new_modules = ['NormalizerComparison', 'A2Theta', 'T5ThetaNumeric',
                   'ShiftedGaussian', 'TriangularGaussian', 'T5ScalarMass']
    new_sources = [W / 'run/formal/Run2' / (m + '.lean') for m in new_modules]
    for source in new_sources:
        assert not re.search(r'\b(sorry|admit|native_decide|axiom)\b|Lean\.ofReduceBool',
                             source.read_text()), str(source)
    result = {
        'schema': 'FT1536_M6_PROGRESS_RECEIPT_V1',
        'status': 'WORKING_PARTIAL_KERNEL_PROGRESS_NOT_FROZEN',
        'model': 'openai/gpt-6-astra-fast',
        'session': 'ses_f2ec4fa0cffe7f5AugjiH8YLBE',
        'fresh_own_source_modules': len(lean),
        'new_math_modules': [bind(p) for p in new_sources],
        'new_named_theorems': sum(len(re.findall(r'^theorem\s+', p.read_text(), re.M))
                                  for p in new_sources),
        'audited_exports': axioms,
        'lean_receipts': bind(BUILD / 'RECEIPTS.json'),
        'lean_source_inputs': bind(BUILD / 'SOURCE_INPUTS.json'),
        'printed_types_and_axioms': bind(audit),
        'sage_receipts': bind(SAGE / 'RECEIPTS.json'),
        'sage_source_inputs': bind(SAGE / 'SOURCE_INPUTS.json'),
        'sage_product': bind(SAGE / 'm6_kernel_margins.json'),
        'source_keygen_to_exact_lattice_binding_complete': False,
        'radial_mass_kernel_certificate_complete': False,
        'all_key_probability_bound_proved': False,
        'full_RUN_002_final_replay_performed': False,
        'external_libraries': 'Existing read-only pinned Lean4.34.0/Mathlib cache; '
                              'new complete source replay closure required at final freeze',
        'clean_snapshot_modified': False,
    }
    out = W / 'run/M6_PROGRESS_RECEIPT.json'
    out.write_text(json.dumps(result, indent=2, sort_keys=True) + '\n')
    print(json.dumps({'receipt': str(out), 'sha256': sha(out),
                      'fresh_modules': len(lean), 'audited_exports': len(axioms),
                      'new_named_theorems': result['new_named_theorems'],
                      'all_key_probability_bound_proved': False}, indent=2))


if __name__ == '__main__':
    main()
