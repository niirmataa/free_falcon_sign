#!/usr/bin/env python3
"""Pin the concrete NTRU/fiber/gate progress, without promoting the final claim."""
import json
from pathlib import Path
import re
from m6_progress_receipt import W, sha, bind, checked_run


def main():
    build = W / 'run/m6_kernel_binding_fresh_001'
    sage = W / 'run/m6_binding_controls_002'
    lean_receipts, sources = checked_run(build)
    sage_receipts, sage_sources = checked_run(sage)
    assert len(lean_receipts) == len(sources) == 41
    assert len(sage_receipts) == len(sage_sources) == 1
    for source in sources:
        rel = Path(source['path']).relative_to(W / 'run/formal')
        artifact = build / 'lib' / rel.with_suffix('.olean')
        assert artifact.is_file() and not artifact.is_symlink()
        assert sha(build / 'formal' / rel) == source['sha256']
    allowed = {'propext', 'Classical.choice', 'Quot.sound'}
    exports = []
    for module, count in [('Run2_M6Audit', 13), ('Run2_KernelBindingAudit', 18)]:
        log = build / 'logs' / (module + '.stdout')
        declarations = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", log.read_text())
        assert len(declarations) == count
        for name, raw in declarations:
            axioms = {x.strip() for x in raw.split(',') if x.strip()}
            assert axioms <= allowed, (name, axioms)
            exports.append({'declaration': name, 'axioms': sorted(axioms), 'printed_type_log': bind(log)})
    assert len({e['declaration'] for e in exports}) == 31
    modules = ['NTRUBasis', 'CoefficientQuotient', 'QuotientOperations', 'ActualNTRUFiber',
               'KeygenLeafGate', 'StableLeafAlgebra', 'StableLeafSchedule']
    paths = [W / 'run/formal/Run2' / (m + '.lean') for m in modules]
    for p in paths:
        assert not re.search(r'\b(sorry|admit|native_decide|axiom)\b|Lean\.ofReduceBool', p.read_text())
    result = {
        'schema': 'FT1536_KERNEL_BINDING_PROGRESS_V1',
        'status': 'WORKING_PARTIAL_KERNEL_PROGRESS_NOT_FROZEN',
        'session': 'ses_f2ec4fa0cffe7f5AugjiH8YLBE',
        'model': 'openai/gpt-6-astra-fast',
        'fresh_own_source_modules': len(sources),
        'new_modules': [bind(p) for p in paths],
        'new_named_theorems': sum(len(re.findall(r'^theorem\s+', p.read_text(), re.M)) for p in paths),
        'exports': exports,
        'source_inputs': bind(build / 'SOURCE_INPUTS.json'),
        'lean_receipts': bind(build / 'RECEIPTS.json'),
        'sage_source_inputs': bind(sage / 'SOURCE_INPUTS.json'),
        'sage_receipts': bind(sage / 'RECEIPTS.json'),
        'sage_product': bind(sage / 'kernel_binding_controls.json'),
        'ntru_affine_fiber_bijection_bound_to_existing_A': True,
        'bitvector_gate_model_universal_theorem': True,
        'exact_stable_schedule_reciprocal_theorem': True,
        'full_source_keygen_execution_refinement': False,
        'source_fp_to_exact_leaf_bound': False,
        'source_spectrum_to_actual_gram_ldl_binding': False,
        'radial_mass_kernel_certificate_complete': False,
        'all_key_probability_bound_proved': False,
        'full_RUN_002_final_replay_performed': False,
        'clean_snapshot_modified': False,
    }
    out = W / 'run/KERNEL_BINDING_RECEIPT.json'
    out.write_text(json.dumps(result, indent=2, sort_keys=True)+'\n')
    print(json.dumps({'receipt': str(out), 'sha256': sha(out), 'fresh_modules': len(sources),
                      'new_named_theorems': result['new_named_theorems'], 'audited_exports': len(exports),
                      'all_key_probability_bound_proved': False}, indent=2))


if __name__ == '__main__':
    main()
