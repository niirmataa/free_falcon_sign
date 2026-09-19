"""Seal the completed candidate-specific L_V proof exactly once."""
import hashlib,json,sys
from pathlib import Path
from replaylib import sha,member
if sys.flags.optimize:raise RuntimeError('Python assertions must be enabled')
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
def load(p):return json.loads(member(W,p).read_text())
def write(p,data):
    with (W/p).open('x') as f:json.dump(data,f,indent=2,ensure_ascii=False);f.write('\n')
audit=load('artifacts/formal_audit.json');fresh=load('artifacts/fresh_replay.json');controls=load('artifacts/controls.json')
assert audit['status']=='PASS' and audit['modules']==73 and audit['checked_theorems']==570 and audit['new_theorems']==104
assert audit['all_final_logs_clean'] and audit['remaining_bridge_hypotheses']==[]
assert fresh['status']=='FRESH_REPLAY_PASS' and len(fresh['matches'])==402 and fresh['asan_ubsan_replayed']
assert controls['status']=='PASS' and controls['asan_ubsan_match'] and controls['plain_observer_decisions_match']
assert not load('OBLIGATIONS.json')['blocking']
for p,h in audit['sources_sha256'].items():assert sha(member(W,p))==h
for row in fresh['matches']:assert sha(member(W,row['path']))==row['sha256']
for row in load('inputs/provenance.json'):assert sha(member(W,row['copy']))==row['sha256']
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,p=line.split('  ',1);assert sha(member(W,'source/'+p))==h
source=sha(W/'source/falcon-vrfy.c');assert source=='3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42'
write('RESULT.json',dict(schema='FT1536_L_V_BRIDGE_RESULT_V1',status='L_V_PROVED_FOR_PINNED_MODEL',
    source_sha256=source,encoder_source_sha256=sha(W/'source/falcon-enc.c'),source_manifest_sha256=sha(W/'inputs/source_hashes.sha256'),
    full_L_V_proved=True,full_L_V_source_sha256=source,source_integrated=False,owner_accepted=False,
    parameters=dict(N=1536,q=18433,Phi='X^1536-X^768+1',B=2093922385,sigma_sign=768,ternary=1,logn=10,honest_compression='FALCON_COMP_STATIC'),
    domain='All canonical h,c and all finite byte strings with legal size_t64 lengths/objects/lifecycle in the pinned GCC14.2.0/C99/Linux x86_64 LP64 model. Verify includes NONE and STATIC, no2049 cap.',
    raw_theorem='FT1536Bridge.RAW_VERIFIER_SOUND',byte_theorems=['FT1536Bridge.L_V_BYTES','FT1536Bridge.L_V_LOADED','FT1536Bridge.L_V_SOURCE'],
    remaining_bridge_hypotheses=[],blocking=[],models_inherited_unchanged=59,inputs=124,source_files=17,
    formal_modules=73,checked_theorems=570,new_theorems=104,all_final_logs_clean=True,
    audit_stdout_sha256=audit['audit_stdout_sha256'],full_types_sha256=audit['full_types_sha256'],
    task_sha256=sha(W/'inputs/task.md'),PREV_report_sha256=sha(W/'inputs/PREV/REPORT.md'),PREV_outputs_sha256=sha(W/'inputs/PREV/OUTPUTS.sha256'),
    controls=dict(verify_cases=55,norm_cases=8,center_cases=4,mutants_detected=5,noop_pass=True,normal_asan_ubsan_match=True,
                  plain_observer_decisions_match=True,old_witness_rejected=True,old_witness_norm=43058711057),
    replay_protocol='standard',rehearsal_status='FRESH_REPLAY_PASS',semantic_files=402,frozen_replay_receipt='artifacts/fresh_replay.json',
    report_sha256=sha(W/'REPORT.md'),historical_S17_counterexample_unchanged=True,
    scope_limits=['No sampler theorem','No EUF-CMA or MT-ISIS hardness theorem','No key-distribution or H2P preimage theorem','No conditional chi-square/52-bit whole-scheme claim']))
prefix=(W/'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(prefix)
write('artifacts/command_prefix.json',dict(path='COMMANDS.log',bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),
    snapshot='artifacts/COMMANDS.frozen.log',note='Seal receipt and subsequent read-only checks are outside this prefix.'))
docs=['AGENTS.md','REPORT.md','RESULT.json','CLAIM.md','OBLIGATIONS.json','REUSED_RESULTS.md','SOURCE_MODEL_BINDING.md','REPLAY.md','OUTPUT_SCOPE.md','INPUTS.sha256','TOOLCHAIN.txt']
files={W/p for p in docs}
for folder in ['source','inputs','formal','scripts','artifacts','logs','checks']:
    for p in (W/folder).rglob('*'):
        assert not p.is_symlink(),str(p)
        if p.is_file() and '.olean' not in p.name and p.suffix not in ['.ilean','.pyc'] and '__pycache__' not in p.parts:files.add(p)
relset={p.relative_to(W).as_posix() for p in files}
assert all(r['path'] in relset for r in fresh['matches'])
with (W/'OUTPUTS.sha256').open('x') as f:
    for p in sorted(files):f.write(sha(p)+'  '+p.relative_to(W).as_posix()+'\n')
print(json.dumps(dict(status='L_V_PROVED_FOR_PINNED_MODEL',full_L_V_proved=True,source_sha256=source,
    manifest_entries=len(files),REPORT=str(W/'REPORT.md'),REPORT_sha256=sha(W/'REPORT.md'),OUTPUTS_sha256=sha(W/'OUTPUTS.sha256'),
    frozen_command_prefix_bytes=len(prefix),semantic_files=402),indent=2))
