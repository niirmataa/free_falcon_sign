#!/usr/bin/env python3
"""Independent cross-check of frozen exports, records, logs, and boundaries."""
from pathlib import Path
import hashlib, json, re
W=Path(__file__).resolve().parents[1]; S=W/'inputs/subject'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
get=lambda name:json.loads((S/name).read_text())
export=get('FORMAL_EXPORTS.json'); axioms=get('AXIOMS.json'); text=(S/'artifacts/FORMAL_TYPES_TERMS.txt').read_text()
names=[e['name'] for e in export['exports']]
assert len(names)==len(set(names))==15==export['export_count']
assert set(names)==set(axioms['exports'])==set(axioms['printed_axiom_names'])
assert sha(S/'artifacts/FORMAL_TYPES_TERMS.txt')==axioms['audit_log_sha256']
assert '⋯' not in text and 'sorryAx' not in text and 'sorry' not in (S/'formal/Ledger.lean').read_text()
for e in export['exports']:
    n=e['name']; assert e['source_instantiated'] is False
    assert e['module_sha256']==sha(S/e['module'])
    assert text.count('theorem '+n+'.')==1 or text.count('theorem '+n+' :')==1, n
    assert text.count("'"+n+"' depends on axioms: [")==1, n
    assert e['printed_type'] in text
    printed=axioms['printed_axiom_names'][n]
    assert all(re.fullmatch(r'(propext|Classical\.choice|Quot\.sound)(\.\{u\})?',v) for v in printed)
    assert set(x.split('.{')[0] for x in printed)==set(axioms['exports'][n])
assert not axioms['forbidden_axioms']
ledger=get('LEDGER_TERM_BINDINGS.json')
assert [t['id'] for t in ledger['terms']]==['A1','A2','A3','A4','B','C1','C2','C3','D','E']
assert not ledger['complete_source_decomposition_proved']
assert all(t['historical_numeric_bound_reused_as_new_source_bound'] is False for t in ledger['terms'])
deps=get('EXPORT_DEPENDENCIES.json')['dependencies']
assert len(deps)==7 and all(d['status']=='OPEN_NOT_ASSUMED' and d['accepted_export_pin'] is None for d in deps)
origin=get('artifacts/dependency_evidence/ORIGIN.json')
scalar=S/'artifacts/dependency_evidence/P02_ScalarCalls.lean'
assert sha(scalar)==origin['sha256']
code=scalar.read_text()
assert all(x in code for x in ['fpr_ursh','fpr_irsh','fpr_ulsh','else none'])
assert all(x not in code for x in ['"fpr_add"','"fpr_mul"','"fpr_div"','"fpr_sqrt"'])
for d in deps:
    for f in d['evidence']:
        assert sha(S/f['path'])==f['sha256']
run=get('EXECUTION_RECEIPTS.json')
steps=0; logs=0
for r in run['runs']:
    p=S/r['path']; assert sha(p)==r['sha256']; receipt=json.loads(p.read_text())
    assert receipt['exit_code']==r['exit_code'] and receipt['sources_unchanged'] and len(receipt['steps'])==r['steps']
    assert (r['exit_code']==1)==(r['path']=='run/normal_001/receipt.json')
    steps+=len(receipt['steps']); logs+=2*len(receipt['steps'])
    for s in receipt['steps']:
        if r['exit_code']==0: assert s['exit_code']==0 and s['clean_log']
        for k in ['stdout','stderr']:
            assert sha(p.parent/s[k])==s[k+'_sha256']
assert len(run['runs'])==13 and steps==57 and logs==114
for rel in [run['external_interruption'],*run['packaging_failures']]:
    assert (S/rel).is_file()
assert b'not JSON serializable' in (S/'run/normal_001/logs/000.stderr').read_bytes()
assert not (S/'run/initial_001/receipt.json').exists()
assert (S/'run/final_002/build/FORMAL_TYPES_TERMS.txt').read_text().count('⋯')>0
assert '⋯' not in (S/'run/audit_001/build/FORMAL_TYPES_TERMS.txt').read_text()
assert 'Quot.sound.{u}' in (S/'artifacts/FORMAL_TYPES_TERMS.txt').read_text()
out={'exports':len(names),'printed_terms_complete':True,'axioms_allowlisted':True,
     'ledger_terms':[x['id'] for x in ledger['terms']], 'missing_interfaces':[x['id'] for x in deps],
     'P02_shift_only_dispatcher_sha256':sha(scalar),
     'receipt_runs':len(run['runs']),'receipt_steps':steps,'raw_logs':logs,
     'scope':'algebra/source byte-bindings only, no C refinement'}
(W/'output/CLAIM_AUDIT.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print(json.dumps(out,indent=2))
