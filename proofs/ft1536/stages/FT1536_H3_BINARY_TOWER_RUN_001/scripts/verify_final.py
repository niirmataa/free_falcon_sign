"""Read-only integrity; preserves distinct A/B, kernelization and assembly flags."""
import json,sys
from pathlib import Path
from package_scope import selected_files
from replaylib import member,sha,verify_manifest
W=Path(__file__).absolute().parents[1]
if len(sys.argv)!=2:raise ValueError('verify_final.py EXTERNAL_OUTPUTS_SHA256')
scope=verify_manifest(W,'OUTPUTS.sha256',sys.argv[1]);selected=set(selected_files(W));extra=selected-set(scope);assert set(scope)<=selected
for r in extra:assert Path(r).parent.as_posix()=='logs' and Path(r).suffix in {'.stdout','.stderr'},r
result=json.loads(member(W,'RESULT.json').read_text());assert scope['REPORT.md']==result['pins']['report_sha256']
assert result['status']=='H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL' and result['full_binary_tower_theorem_kernelized'] is False
for k in ['binary_tower_proved','remaining_binary_subtrees_proved','source_inner7_totality_proved','baseline_source_integrated']:assert result[k] is True
assert result['levels_proved']==[7,6,5,4,3,2,1]
for k in ['H3_range_proved','global_reachability_proved','full_internal_tree_proved','sampler_law_proved','security_reduction_proved','source_changed','new_source_patch_integrated','protocol_wrapper_integrated','owner_accepted']:assert result[k] is False
assert result['unresolved_numerical_premises']==[]
receipt=json.loads(member(W,'artifacts/fresh_replay.json').read_text());assert receipt['status']=='FRESH_REPLAY_PASS'
matches={r['path']:r['sha256'] for r in receipt['matches']};assert len(matches)==len(receipt['matches'])==175
for r,h in matches.items():assert scope[r]==h
assert verify_manifest(W,'artifacts/semantic_manifest.sha256',receipt['semantic_manifest_sha256'])==matches
boot=W/'inputs/bootstrap';entries=verify_manifest(boot,'MANIFEST.sha256',result['pins']['bootstrap_manifest_sha256']);assert len(entries)==137
assert {p.relative_to(boot).as_posix() for p in boot.rglob('*') if p.is_file()}==set(entries)|{'MANIFEST.sha256'}
orig=json.loads((boot/'ORIGINS.json').read_text());assert len(orig['files'])==135
for r in orig['files']:assert entries[r['copy']]==r['sha256'] and (boot/r['copy']).stat().st_size==r['bytes']
assert sha(boot/'CANDIDATE.sha256')==result['pins']['candidate_manifest_sha256']
for line in (boot/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(member(W/'source',n))==h
provenance=json.loads(member(W,'inputs/provenance.json').read_text());inputs={}
for line in member(W,'INPUTS.sha256').read_text().splitlines():
 h,p=line.split('  ',1);assert p not in inputs;inputs[p]=h
assert len(provenance)==141 and inputs=={r['path']:r['sha256'] for r in provenance}
for r in provenance:assert scope[r['copy']]==r['sha256']
ledger=json.loads(member(W,'BOUND_LEDGER.json').read_text());tower=json.loads(member(W,'TOWER_CERTIFICATE.json').read_text())
assert ledger['status']==tower['status']==result['status'] and ledger['uniform_summaries']==tower['uniform_summaries']==result['uniform_summaries']
assert scope[tower['constants_file']]==tower['constants_sha256']==result['constants_sha256']
for evidence in tower['evidence']+[e for row in ledger['rows'] for e in row['evidence']]:assert scope[evidence['path']]==evidence['sha256']
audit=json.loads(member(W,'artifacts/formal_audit.json').read_text());assert audit['all_final_logs_clean'] and not audit['full_binary_tower_theorem_kernelized']
for r,h in (audit['sources_sha256']|audit['analytical_proofs']).items():assert scope[r]==h
archive=json.loads(member(W,'artifacts/replay_evidence.json').read_text())
for r in archive['files']:assert scope[r['path']]==r['sha256']
prefix=json.loads(member(W,'artifacts/command_prefix.json').read_text());data=member(W,prefix['path']).read_bytes()
assert len(data)==prefix['bytes'] and sha(W/prefix['path'])==prefix['sha256'] and len(data.splitlines())==prefix['command_records']
if (W/'COMMANDS.log').exists():assert (W/'COMMANDS.log').read_bytes().startswith(data)
print(json.dumps(dict(status='FINAL_INTEGRITY_PASS',members=len(scope),semantic_matches=len(matches),public_inputs=len(provenance),unarchived_post_seal_log_files=len(extra),report_sha256=scope['REPORT.md'],outputs_sha256=sys.argv[1],proof_kind=result['proof_kind']),indent=2))
