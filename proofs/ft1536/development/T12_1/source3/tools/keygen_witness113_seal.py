#!/usr/bin/env python3
"""Seal native witness evidence, explicitly leaving the kernel witness open."""
from pathlib import Path
import fcntl
import json
import sys
import job111 as job
import pre_sign_evidence084 as e

ROOT,REPO=e.ROOT,e.REPO
BUILD=ROOT/'.build/success113'
PARENT=ROOT/'.build/success112/POSTSEAL_112.json'
PARENT_SHA='e387fe7824253fa149e10bbc93fa707aa039df10de2e58b90aea2ad7933e29c3'
RECEIPT=ROOT/'notes/run/KEYGEN_WITNESS_113.json'


def inherited():
    e.check(PARENT,PARENT_SHA);checked=json.loads(PARENT.read_text())['checked']
    assert len(checked)==27803
    for p,h in checked.items():e.check(p,h)
    return checked


def native_files(label):
    folder=ROOT/'.build/jobs'/label
    return [e.pin(p) for p in sorted(folder.rglob('*')) if p.is_file() and not p.is_symlink()
        and p.relative_to(folder).parts[0] not in {'lib','home','tmp','cache'}]


def seal():
    inherited();assert not job.active(),job.active()
    e.check(BUILD/'ENTRY_PINS.json','272ea532d91b350bea7273d996e496fb9683c118575809c2abf0175e45782401')
    final=ROOT/'.build/jobs/keygen_witness113_005';witness=final/'WITNESS113.json'
    e.check(witness,'dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf')
    record=json.loads(witness.read_text())
    assert record['counter']==9 and record['observed_attempt_count']==record['observed_return']==1
    assert record['private_length']==7681 and record['public_length']==2881 and record['shake_bytes']==1032
    assert not record['kernel_source_witness'] and not record['full_statement_trace']
    pins=[]
    for row in record['source_inputs']+record['binary_pins']+record['artifacts']:
        e.check(row['path'],row['sha256']);pins.append(e.pin(row['path']))
    for row in json.loads((final/'COMMANDS.json').read_text()):
        assert row['exit_code']==0
        e.check(row['executable'],row['executable_sha256'])
        assert Path(row['stdout']).stat().st_size==Path(row['stderr']).stat().st_size==0
        pins.append(e.pin(row['executable']))
    prior=ROOT/'.build/jobs/keygen_witness113_006'
    assert json.loads((prior/'PRIOR113.json').read_text())['status']=='MATCH_RETAINED_S1_PUBLIC_FIXTURE_DIGEST'
    assert len(json.loads((prior/'PRIOR113.json').read_text())['unchanged_semantic_files'])==7
    for label in ['keygen_witness113_005','keygen_witness113_006']:
        folder=ROOT/'.build/jobs'/label;row=json.loads((folder/'RECEIPTS.json').read_text())[0]
        assert row['accepted'] and row['clean_log'] and row['exit_code']==0
        assert (folder/row['stdout']).stat().st_size==(folder/row['stderr']).stat().st_size==0
        e.check(ROOT/'sage'/('keygen_witness113.sage' if label.endswith('005') else 'keygen_witness113_prior.sage'),row['source_sha256'])
    assert (BUILD/'COMPUTATION_REPAIRED_VALIDATION.stdout').read_text().startswith('valid legacy version 1 evidence record;')
    assert (BUILD/'COMPUTATION_REPAIRED_VALIDATION.stderr').stat().st_size==0
    for rel in ['checks/keygen_witness113.c','tools/keygen_witness113_instrument.py',
        'tools/keygen_witness113_seal.py','tools/job111.py','sage/keygen_witness113.sage',
        'sage/keygen_witness113_prior.sage','notes/run/KEYGEN_WITNESS_113_REPORT.md',
        'notes/run/KEYGEN_WITNESS_113_FAILURES.json','notes/run/KEYGEN_WITNESS_113_COMPUTATION.json',
        '.build/success113/ENTRY_PINS.json','.build/success113/COMPUTATION_REPAIRED_VALIDATION.stdout',
        '.build/success113/COMPUTATION_REPAIRED_VALIDATION.stderr',
        '.build/success113/INTEGRITY_STOP_001.json','.build/success113/PROPOSED_REPAIR_001.patch',
        '.build/success113/REPAIR_AUTHORIZATION_001.json','.build/success113/REPORT_BEFORE_REPAIR.md',
        '.build/success113/COMPUTATION_BEFORE_REPAIR.json']:
        pins.append(e.pin(ROOT/rel))
    causes=json.loads((ROOT/'notes/run/KEYGEN_WITNESS_113_FAILURES.json').read_text());history=[]
    for i in range(1,7):
        label=f'keygen_witness113_{i:03d}';rows=json.loads((ROOT/'.build/jobs'/label/'RECEIPTS.json').read_text())
        failed=any(not r['accepted'] for r in rows);assert failed==(label in causes)
        history.append({'job':label,'failed':failed,'cause':causes.get(label),'files':native_files(label)})
    return e.write(RECEIPT,{'stage':'113','status':'NATIVE_WITNESS_WITH_EXACT_CONTROLS / KERNEL_SOURCE_WITNESS_OPEN',
        'owner_program':'ACTIVE / NOT_COMPLETE','point1_kernel_witness':False,'point2_numeric_bound':False,
        'point3_coding_probability_bound':False,'native_first_attempt_witness':True,'selected_counter':9,
        'new_assumptions':False,'do_sign_items':5,'push':False,'independent_review':False,
        'previous_postseal':e.pin(PARENT),'evidence':pins,'history':history,
        'native_calls_all_jobs':30,'native_calls_final_selected_replay':3,'failed_jobs':1,'failed_seal_attempts':1,'jobs':6})


def postseal(expected):
    checked=dict(inherited())
    def add(path,digest):
        path=str(Path(path).resolve());e.check(path,digest)
        assert path not in checked or checked[path]==digest,('CONFLICTING_PIN',path)
        checked[path]=digest
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value:add(value['path'],value['sha256'])
            for v in value.values():walk(v)
        elif isinstance(value,list):
            for v in value:walk(v)
    add(PARENT,PARENT_SHA);add(RECEIPT,expected);walk(json.loads(RECEIPT.read_text()))
    assert not job.active(),job.active()
    return e.write(BUILD/'POSTSEAL_113.json',{'status':'PASS_INTEGRITY; OWNER_PROGRAM_ACTIVE',
        'checked':checked,'distinct_pinned_files':len(checked),'kernel_source_witness':False,'push':False})


if __name__=='__main__':
    with (ROOT/'.build/JOB.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        if sys.argv[1:]==['seal']:result=seal()
        elif len(sys.argv)==3 and sys.argv[1]=='postseal':result=postseal(sys.argv[2])
        else:raise SystemExit('seal | postseal RECEIPT_SHA256')
        print(json.dumps(result))
