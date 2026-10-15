#!/usr/bin/env python3
"""Collect only completely accepted isolated audit outputs; exact name union."""
from pathlib import Path
import fcntl,json
import job079 as job
import pre_sign_evidence084 as evidence
import keygen_whole088_audit as audit
ROOT=evidence.ROOT
BUILD=ROOT/'.build/norm131'
with (ROOT/'.build/JOB.lock').open('a') as lock:
    fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
    assert not job.active(),job.active()
    config=json.loads((BUILD/'FINAL_AUDIT.json').read_text())
    plan=json.loads((BUILD/config['parts']).read_text())
    modules=json.loads((BUILD/'AUDIT_MODULES.json').read_text())
    assert [p['module'] for p in plan['parts']]==modules
    final=ROOT/'.build/jobs'/config['job']
    receipts=json.loads((final/'RECEIPTS.json').read_text())
    assert [r['name'] for r in receipts]==['Source3_'+p['audit_module'] for p in plan['parts']]
    expected=audit.declarations(modules)
    rows=[];parts=[]
    for part,receipt in zip(plan['parts'],receipts):
        assert receipt['accepted'] and receipt['clean_log'] and receipt['exit_code']==0
        assert not receipt['forbidden_proof_markers']
        assert receipt['cumulative_child_maxrss_kib']<=receipt['normal_rss_budget_bytes']//1024
        assert (final/receipt['stdout']).stat().st_size==(final/receipt['stderr']).stat().st_size==0
        evidence.check(part['source'],part['source_sha256'])
        assert part['source_sha256']==receipt['source_sha256']
        output=final/part['output']
        data=json.loads(output.read_text())
        assert [r['name'] for r in data]==part['names']
        for row in data:
            assert set(row['axioms'])<={'propext','Classical.choice','Quot.sound'}
            assert '⋯' not in json.dumps(row,ensure_ascii=False)
            if row['body']['kind']!='kernel_inductive':
                assert row['body']['kind']=='full_expression_dag_json'
                assert row['body']['roundtrip_term_and_type_checked'] is True
                assert row['body']['type_check']=='kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded'
        rows.extend(data)
        parts.append({'module':part['module'],'audit_module':part['audit_module'],
            'output':evidence.pin(output),'source':evidence.pin(part['source'])})
    assert [r['name'] for r in rows]==expected
    assert len(expected)==len(set(expected))==plan['declarations']
    aggregate=evidence.write(BUILD/config['aggregate'],rows)
    print(json.dumps(evidence.write(BUILD/'AUDIT_COLLECTION.json',{
      'status':'PASS_FULL_KERNEL_DAG_AUDIT; NOT_INDEPENDENT_REVIEW',
      'declarations':len(rows),'mathematical_modules':len(modules),
      'isolated_clean_audit_processes':len(receipts),'aggregate':aggregate,
      'parts':parts,'plan':evidence.pin(BUILD/config['parts']),
      'receipts':evidence.pin(final/'RECEIPTS.json'),'tool':evidence.pin(__file__)})))
