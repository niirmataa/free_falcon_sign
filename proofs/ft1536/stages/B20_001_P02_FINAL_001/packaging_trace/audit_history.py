#!/usr/bin/env python3
"""Bind historical P02 runs to byte-level sources, child commands and logs."""
from pathlib import Path
import hashlib,json,datetime

W=Path(__file__).resolve().parents[1];O=W/'output';P=O/'predecessor';E=O/'evidence/prior_run'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((O/'formal/BUILD_PLAN.json').read_text())['modules']
assert len(plan)==34
index=json.loads((P/'EXECUTION_RECEIPTS.json').read_text())['runs']
assert len(index)==9
snapshot=json.loads((E/'replay_001/receipt.json').read_text())['source_before']
assert snapshot==json.loads((E/'replay_001/receipt.json').read_text())['source_after']
sealed={p.relative_to(O/'formal').as_posix():sha(p) for p in (O/'formal').rglob('*') if p.is_file()}
for rel in plan:
    assert sealed[rel]==snapshot[rel]
assert len([x for x in plan if x not in ['AuditExports.lean','AuditTerms.lean']])==32
output_index={rel:h for h,rel in (line.split('  ',1) for line in (P/'OUTPUTS.sha256').read_text().splitlines())}
assert all('formal/'+rel in output_index for rel in plan[:32])
assert not any('formal/'+rel in output_index for rel in plan[32:])
records=[]; child_commands=[]; total=0; logs=0; omitted_binary=[]; no_children=[]; overwritten=[]
equivalents={(r['receipt'].split('/')[-1],r['child'],r['stream']):r for r in json.loads((O/'OVERWRITTEN_LOGS.json').read_text())['rows']}
for entry in index:
    runid=entry['id'];rd=E/runid;receipt=json.loads((rd/'receipt.json').read_text())
    assert receipt['name']==runid and receipt['start']==entry['start']
    assert receipt['exit_code']==0 and receipt['sources_unchanged'] and receipt['source_before']==receipt['source_after']
    assert len(receipt['steps'])==entry['steps']
    assert all(s['exit_code']==0 and not s['timeout'] for s in receipt['steps'])
    runner_sha=sha(rd/'job.py')
    for rel,h in receipt['source_before'].items():
        assert sha(rd/'source'/rel)==h,(runid,rel)
    matched=sum(sealed.get(k)==v for k,v in receipt['source_before'].items() if k in sealed)
    # Historical snapshots need not all be final, and are not silently normalized.
    for n,s in enumerate(receipt['steps']):
        assert s['argv'] and s['cwd']==str(receipt['writable_project_root']+'/source')
        assert str(receipt['writable_project_root']) in str(s['argv'])
        for suffix in ['stdout','stderr']:
            assert sha(rd/s[suffix])==s[suffix+'_sha256'],(runid,n,suffix)
            logs+=1
        if 'lean_log_clean' in s:assert s['lean_log_clean']
    for rel,h in receipt['products'].items():
        path=rd/rel
        if path.is_file():assert sha(path)==h,(runid,rel)
        else:
            assert path.suffix in ('.olean','.o','.so') or path.name in ('normal','ubsan','asan','word_control','le_control','scalar_control','control') or path.name.startswith(('scalar_','le_','word_')),(runid,rel)
            omitted_binary.append(runid+'/'+rel)
    child=[]
    for p in sorted((rd/'build').glob('*RECEIPTS.json')):
        j=json.loads(p.read_text());assert isinstance(j,list)
        for c in j:
            assert c['argv'] and c.get('cwd',receipt['writable_project_root']+'/source') and 'exit_code' in c
            for suffix in ('stdout','stderr'):
                f=rd/'build'/c[suffix]
                if sha(f)!=c[suffix+'_sha256']:
                    assert runid=='replay_001'
                    alternate=equivalents[(p.name,c['name'],suffix)]
                    assert alternate['overwritten_hash']==sha(f)
                    assert sha(O/alternate['replacement_path'])==c[suffix+'_sha256']
                    overwritten.append(alternate)
            assert c['exit_code']==c.get('expected_exit',0),(runid,c['name'])
            child.append({'source':str(p.relative_to(E)),'name':c['name'],'argv':c['argv'],
                          'exit_code':c['exit_code'],'stdout_sha256':c['stdout_sha256'],'stderr_sha256':c['stderr_sha256']})
    child_commands.extend(child)
    if not child:no_children.append(runid)
    total+=len(receipt['steps'])
    records.append({'id':runid,'receipt_sha256':sha(rd/'receipt.json'),'runner_snapshot_sha256':runner_sha,'source_count':len(receipt['source_before']),
                    'final_source_matches':matched,'steps':len(receipt['steps']),'raw_step_logs':2*len(receipt['steps']),
                    'child_commands':len(child),'mode_memory_bytes':receipt['address_space_bytes'],'first_step_argv':receipt['steps'][0]['argv'],
                    'snapshot_audits':{n:receipt['source_before'].get(n) for n in ('AuditExports.lean','AuditTerms.lean')},
                    'snapshot_probe':receipt['source_before'].get('ProbeFreezeScan.lean')})
assert total==144 and logs==288
assert len(json.loads((P/'FORMAL_EXPORTS.json').read_text())['primary_exports'])>0
assert len(child_commands)>0 and len(overwritten)==6
result={'schema':'P02_HISTORICAL_CLOSURE_V2','checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'predecessor_report_sha256':sha(P/'REPORT.md'),'predecessor_outputs_sha256':sha(P/'OUTPUTS.sha256'),
        'runner_sha256':sha(E/'replay_001/job.py'),'plan':plan,
        'sealed_32_source_matches':True,'audit_module_pins':{k:sealed[k] for k in plan[32:]},
        'runs':records,'total_steps':total,'raw_step_logs':logs,'child_commands':child_commands,
        'binary_products_excluded':omitted_binary,'runs_without_child_receipts':no_children,
        'overwritten_child_logs_byte_equivalents':overwritten,
        'frozen_output_never_included_runs':True,'old_final_head':'UNRECORDED'}
(O/'HISTORY_BINDING.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('HISTORY_BINDING_PASS',len(records),total,logs,len(child_commands),'child commands',len(omitted_binary),'excluded binaries')
