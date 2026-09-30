#!/usr/bin/env python3
"""Record verified local source progress; no mathematical computation."""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re

W = Path(__file__).resolve().parent.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def receipt(label):
    path = W / 'run' / label / 'RECEIPTS.json'
    records = json.loads(path.read_text())
    for rec in records:
        if not rec['accepted'] or not rec['clean_log'] or rec['forbidden_proof_markers']:
            raise ValueError('non-accepted receipt: ' + label)
        for field in ['stdout', 'stderr']:
            if sha(path.parent / rec[field]) != rec[field + '_sha256']:
                raise ValueError('log hash mismatch')
    return path, records


def main():
    target = W / 'run/SOURCE3_PROGRESS_RECEIPT.json'
    if target.exists():
        raise ValueError('preserve existing progress receipt')
    audit_input = W / 'run/SOURCE3_AUDIT_INPUTS.json'
    bound = json.loads(audit_input.read_text())
    for rec in bound['modules']:
        for name in ['source', 'artifact', 'receipt']:
            if sha(W / rec[name]) != rec[name + '_sha256']:
                raise ValueError('changed bound ' + name)
    ap, ar = receipt('source3_progress_audit_001')
    text = (ap.parent / ar[0]['stdout']).read_text()
    seen = {}
    for name, axioms in re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", text):
        seen[name] = sorted(x.strip() for x in axioms.split(',') if x.strip())
    for name in re.findall(r"'([^']+)' does not depend on any axioms", text):
        seen[name] = []
    expected = {x['name'] for x in bound['exports']}
    if set(seen) != expected:
        raise ValueError('axiom audit name set mismatch: ' + str(expected - set(seen)))
    # pp.universes is enabled in this audit. Accept only these exact
    # standard names, retaining the raw printed names in the receipt.
    allowed = {'propext': 'propext', 'Classical.choice': 'Classical.choice',
               'Quot.sound': 'Quot.sound', 'Classical.choice.{u}': 'Classical.choice',
               'Quot.sound.{u}': 'Quot.sound'}
    if any(set(xs) - set(allowed) for xs in seen.values()):
        raise ValueError('nonstandard transitive axiom')
    normalized = {name: sorted({allowed[a] for a in axioms}) for name, axioms in seen.items()}
    audit_source = W / 'run/formal/Source3/ProgressAudit.lean'
    if sha(audit_source) != bound['audit_source_sha256'] or sha(audit_source) != ar[0]['source_sha256']:
        raise ValueError('audit source mismatch')
    cp, cr = receipt('source_gate_controls_001')
    control = W / 'run/source_gate_controls_001/CONTROL_RESULT.json'
    controls = json.loads(control.read_text())
    if controls['status'] != 'PASS_SCOPED_CONTROLS':
        raise ValueError('controls are not PASS_SCOPED_CONTROLS')
    if sha(W / 'run/sage/check_source_gates.sage') != cr[0]['source_sha256']:
        raise ValueError('control checker changed')
    for path, pin in controls['input_source_pins'].items():
        if sha(W / 'inputs/source' / path) != pin:
            raise ValueError('control C source pin mismatch')
    result = {'utc': datetime.now(timezone.utc).isoformat(),
        'status': 'KERNEL_CHECKED_LOCAL_SOURCE_FRAGMENTS',
        'task_status': 'WORKING_NOT_FROZEN_PARTIAL_PROOF',
        'model_at_recording': 'openai/gpt-6-astra',
        'session': 'ses_f13464e70ffeuAM6Xf31ztFHAS',
        'source_modules': len(bound['modules']), 'audited_exports': len(seen),
        'audited_theorems': bound['theorem_count'],
        'source_bindings': str(audit_input.relative_to(W)), 'source_bindings_sha256': sha(audit_input),
        'audit_receipt': str(ap.relative_to(W)), 'audit_receipt_sha256': sha(ap),
        'audit_stdout': str((ap.parent / ar[0]['stdout']).relative_to(W)),
        'audit_stdout_sha256': ar[0]['stdout_sha256'], 'axioms_printed': seen, 'axioms': normalized,
        'controls': str(control.relative_to(W)), 'controls_sha256': sha(control),
        'controls_receipt_sha256': sha(cp), 'control_cases': controls['cases'],
        'all_keygen_source_success_bound': False, 'exact_gram_leaf_source_bound': False,
        'unconditional_m6_digits_proved': False, 'full_c_sign_security_proved': False,
        'independent_review_performed': False, 'owner_accepted': False,
        'scope_notes': ['Typed fragments and their declared caller frames only',
            'KeygenMandatory callee execution still parameterized',
            'Stored-word real bounds do not prove FFT/FPEMU real errors',
            'Development source/artifact bindings plus full export audit, not final whole-task replay'],
        'next': 'Full leaf-certificate prefix and same-key byte-heap composition; exact Gram/errors; M6 engine/tails'}
    target.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps({'receipt': str(target.relative_to(W)), 'sha256': sha(target),
                      'source_modules': result['source_modules'], 'audited_exports': len(seen),
                      'audited_theorems': result['audited_theorems'], 'control_cases': controls['cases'],
                      'status': result['status'], 'task_status': result['task_status']}, indent=2))


if __name__ == '__main__':
    main()
