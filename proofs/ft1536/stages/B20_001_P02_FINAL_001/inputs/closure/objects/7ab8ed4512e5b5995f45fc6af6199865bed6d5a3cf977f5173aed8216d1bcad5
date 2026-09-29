"""Seal a defined contract and limited auxiliary proofs, never a security reduction."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,member
if sys.flags.optimize:raise RuntimeError('assertions required')
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
def load(p):return json.loads(member(W,p).read_text())
def write(p,x):
    with (W/p).open('x') as f:json.dump(x,f,indent=2,ensure_ascii=False);f.write('\n')
a=load('artifacts/formal_audit.json');r=load('artifacts/fresh_replay.json');c=load('artifacts/capacity_checks.json');p=load('PROFILE.json');l=load('HOP_LEDGER.json')
assert a['status']=='PASS' and a['modules']==67 and a['checked_theorems']==535 and a['new_theorems']==43 and a['all_final_logs_clean']
assert r['status']=='FRESH_REPLAY_PASS' and len(r['matches'])==273 and not r['security_reduction_proved']
assert c['status']=='PASS' and c['capacity_bound']==3160 and c['witness']['payload']==3156
assert load('artifacts/contract_checks.json')['status']=='PASS' and len(l['rows'])==22
assert not p['status']['security_reduction_proved'] and not p['status']['H3_proved']
assert 'FINAL_COMPOSITION' not in l['target']['component_certificate_ids']
for rel,h in a['sources_sha256'].items():assert sha(member(W,rel))==h
for row in r['matches']:assert sha(member(W,row['path']))==row['sha256']
for row in load('inputs/provenance.json'):assert sha(member(W,row['copy']))==row['sha256']
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,name=line.split('  ',1);assert sha(member(W,'source/'+name))==h
write('RESULT.json',dict(schema='FT1536_M0_RESULT_V1',status='M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE',
    contract_id=p['contract_id'],source_sha256=sha(W/'source/falcon-vrfy.c'),source_manifest_sha256=sha(W/'inputs/source_hashes.sha256'),
    task_sha256=sha(W/'inputs/task.md'),profile_sha256=sha(W/'PROFILE.json'),ledger_sha256=sha(W/'HOP_LEDGER.json'),
    owner_decisions=dict(sig_capacity=4096,payload_header_included=True,nonce_bytes=40,nonce_separate=True,variable_actual_payload=True,
                         resource_target='parametric Q_s,Q_H,t,w,L',concrete_security_level_selected=False),
    capacity_status='PROVED_ANALYTIC_AND_KERNEL_COUNT_MODEL_WITH_PINNED_C_BINDING',capacity_payload_bound=3160,
    capacity_witness=dict(norm=2093088768,payload=3156,source_is_short=1,capacity2049='FAIL_SPACE',capacity3073='FAIL_SPACE',capacity4096='PASS_ROUNDTRIP_CANARIES'),
    framing_status='FIXED40_INJECTIVITY_PROVED_AND_REPARTITION_CONTROL_PASSED',parent_shake_bytes=936,
    security_reduction_proved=False,H3_started=False,source_integrated=False,protocol_wrapper_integrated=False,owner_accepted=False,
    inherited_full_L_V_proved=True,full_L_V_source_sha256=sha(W/'source/falcon-vrfy.c'),
    final_modules=67,checked_theorems=535,new_theorems=43,all_final_logs_clean=True,
    native_normal_asan_ubsan_match=True,native_mutations_detected=3,contract_mutations_detected=8,noop_pass=True,
    ledger_rows=22,open_future_work=['H3 reachability/arithmetic','scalar/joint geometry','pre-cast/bytes/fault/retry','consistent R5T package','full M5 shared kernels','public sampler and budgets','classical ROM programming','primitive reductions and MT assumption','M7 composition','public XOF/H2P and later QROM'],
    target_type='TARGET_TYPE.md',H3_handoff='H3_INTERFACE.md',M0_ambiguities_remaining=[],
    replay_protocol='standard',rehearsal_status='FRESH_REPLAY_PASS',semantic_files=273,frozen_replay_receipt='artifacts/fresh_replay.json',
    specs_are_definitions_not_security_proofs=True,report_sha256=sha(W/'REPORT.md')))
prefix=(W/'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(prefix)
write('artifacts/command_prefix.json',dict(path='COMMANDS.log',bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),snapshot='artifacts/COMMANDS.frozen.log',
  note='Seal receipt and subsequent read-only checks are outside this prefix.'))
docs=['AGENTS.md','REPORT.md','RESULT.json','PROFILE.json','DECISIONS.md','GAME.md','RESOURCE_MODEL.md','HOP_LEDGER.json','HOP_LEDGER.md','SOURCE_MODEL_BINDING.md','CAPACITY.md','REUSED_RESULTS.md','TARGET_TYPE.md','H3_INTERFACE.md','OBLIGATIONS.json','INPUTS.sha256','TOOLCHAIN.txt','REPLAY.md','OUTPUT_SCOPE.md']
files={W/x for x in docs}
for folder in ['source','inputs','formal','scripts','artifacts','logs','checks']:
    for f in (W/folder).rglob('*'):
        assert not f.is_symlink()
        if f.is_file() and '.olean' not in f.name and f.suffix not in ['.ilean','.pyc'] and '__pycache__' not in f.parts:files.add(f)
rels={f.relative_to(W).as_posix() for f in files};assert all(x['path'] in rels for x in r['matches'])
with (W/'OUTPUTS.sha256').open('x') as f:
    for x in sorted(files):f.write(sha(x)+'  '+x.relative_to(W).as_posix()+'\n')
print(json.dumps(dict(status='M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE',capacity_bound=3160,security_reduction_proved=False,
    manifest_entries=len(files),REPORT=str(W/'REPORT.md'),REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256'),
    frozen_command_prefix_bytes=len(prefix),semantic_files=273),indent=2))
