"""Freeze this completed proof package once, preserving an explicit journal prefix."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,member
if sys.flags.optimize:raise RuntimeError('run with Python assertions enabled')
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
def load(p):return json.loads(member(W,p).read_text())
def write(p,v):
    with (W/p).open('x') as f:json.dump(v,f,indent=2,ensure_ascii=False);f.write('\n')
audit=load('artifacts/formal_audit.json');fresh=load('artifacts/fresh_replay.json');controls=load('artifacts/controls.json')
assert audit['status']=='PASS' and audit['modules']==63 and audit['checked_theorems']==472 and audit['new_theorems']==109
assert audit['all_final_logs_clean'] and audit['remaining_global_hypotheses']==[]
assert fresh['status']=='FRESH_REPLAY_PASS' and len(fresh['matches'])==217
assert controls['status']=='PASS' and load('artifacts/replay_protocol_tests.json')['status']=='PASS'
assert not load('OBLIGATIONS.json')['blocking']
for path,h in audit['source_sha256'].items():assert sha(member(W,path))==h
for row in fresh['matches']:assert sha(member(W,row['path']))==row['sha256']
prov=load('inputs/provenance.json');assert len(prov)==55
for row in prov:assert sha(member(W,row['copy']))==row['sha256']
assert sha(W/'source/falcon-vrfy.c')=='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,rel=line.split('  ',1);assert sha(member(W,'source/'+rel))==h
write('RESULT.json',dict(schema='FT1536_L_NTT_FORWARD_RESULT_V1',status='L_NTT_PROVED_FOR_PINNED_MODEL',
    L_NTT_proved=True,FORWARD_GLOBAL_proved=True,forward_product_proved=True,inverse_forward_reused=True,
    p_d_and_ranges_proved=True,rho_substitution_proved_for_int16=True,remaining_global_hypotheses=[],
    source_integrated=False,owner_accepted=False,full_L_V_proved=False,
    parameters=dict(N=1536,q=18433,ternary=1,logn=10,Phi='X^1536-X^768+1',profile='full ternary secret / FALCON_COMP_STATIC'),
    domain='All canonical h,r,c with valid aligned/nonaliasing buffers in the pinned GCC14.2.0/C99/Linux x86_64 LP64 model; rho corollary for all signed int16 s.',
    source_sha256=sha(W/'source/falcon-vrfy.c'),source_manifest_sha256=sha(W/'inputs/source_hashes.sha256'),
    task_sha256=sha(W/'inputs/task.md'),PREV_report_sha256=sha(W/'inputs/PREV/REPORT.md'),PREV_outputs_sha256=sha(W/'inputs/PREV/OUTPUTS.sha256'),
    source_models_changed=False,inherited_formal_files_unchanged=16,Rho_proof_alias_adaptation=load('artifacts/adaptations.json'),
    final_theorem='FT1536Forward.L_NTT',rho_theorem='FT1536Forward.L_NTT_rho',
    checked_theorems=472,new_theorems=109,final_modules=63,all_final_logs_clean=True,
    audit_stdout_sha256=audit['audit_stdout_sha256'],full_types_sha256=audit['full_types_sha256'],
    controls=controls,replay_protocol='standard',rehearsal_status='FRESH_REPLAY_PASS',semantic_files=217,
    frozen_replay_receipt='artifacts/fresh_replay.json',report_sha256=sha(W/'REPORT.md'),
    next_mathematical_step='Complete remaining L_V bridge: parser, C centering, exact Q and strict B for the same candidate.'))
prefix=(W/'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(prefix)
write('artifacts/command_prefix.json',dict(path='COMMANDS.log',bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),
    snapshot='artifacts/COMMANDS.frozen.log',note='Seal receipt and later read-only checks are outside this authoritative prefix.'))
docs=['AGENTS.md','REPORT.md','RESULT.json','CLAIM.md','OBLIGATIONS.json','REUSED_RESULTS.md','INVARIANTS.md',
      'SOURCE_MODEL_BINDING.md','REPLAY.md','OUTPUT_SCOPE.md','INPUTS.sha256','TOOLCHAIN.txt']
files={W/p for p in docs}
for folder in ['source','inputs','formal','scripts','artifacts','logs','checks']:
    for p in (W/folder).rglob('*'):
        assert not p.is_symlink(),str(p)
        if p.is_file() and '.olean' not in p.name and p.suffix not in ['.ilean','.pyc'] and '__pycache__' not in p.parts:files.add(p)
relset={p.relative_to(W).as_posix() for p in files}
assert all(row['path'] in relset for row in fresh['matches'])
with (W/'OUTPUTS.sha256').open('x') as f:
    for p in sorted(files):f.write(sha(p)+'  '+p.relative_to(W).as_posix()+'\n')
print(json.dumps(dict(status='L_NTT_PROVED_FOR_PINNED_MODEL',manifest_entries=len(files),
    REPORT=str(W/'REPORT.md'),REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256'),
    frozen_command_prefix_bytes=len(prefix),semantic_files=217),indent=2))
