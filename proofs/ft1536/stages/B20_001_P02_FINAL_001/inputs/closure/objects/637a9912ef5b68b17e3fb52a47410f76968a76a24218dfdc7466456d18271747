"""Final bounded snapshot. OUTPUTS is the LAST filesystem write of this script."""
import fcntl,json
from pathlib import Path
from replaylib import sha,verify_manifest
from scope import members
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
with (W/'executor.lock').open('a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 required=['REPORT.md','RESULT.json','CLAIM.md','SOURCE_POSTPROCESSING_CERTIFICATE.json','SAMPLING_RETURN_INTERFACE.md','POSTPROCESSING_MAP.md','IFFT_SOURCE_PROOF.md','RINT_REFINEMENT.md','PRECAST_DISPOSITION.md','PRECAST_DISPOSITION.json','STATIC_BYTES.md','NORM_AND_CALLER_BINDING.md','ERROR_LEDGER.md','ERROR_LEDGER.json','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','FAULT_REJECTION.md','FAILED_ROUTES.md','NEXT_INTERFACE.md','OBLIGATIONS.json','REUSED_RESULTS.md','INPUTS.sha256','TOOLCHAIN.txt','COMMANDS.log','OUTPUT_SCOPE.md','REPLAY.md','SEMANTIC_FILES.json']
 for r in required:assert (W/r).is_file(),r
 result=json.loads((W/'RESULT.json').read_text());assert result['status']=='PARTIAL_PROOF' and result['source_narrowing_map_proved'] and not result['precast_value_preservation_proved']
 for r,h in result['proof_documents'].items():assert sha(W/r)==h
 for r,h in result['evidence'].items():assert sha(W/r)==h
 for r in json.loads((W/'SEMANTIC_FILES.json').read_text())['files']:assert sha(W/r['path'])==r['sha256']
 candidate={p:h for h,p in (s.split('  ',1) for s in (W/'inputs/bootstrap/CANDIDATE.sha256').read_text().splitlines())};assert set(p.name for p in (W/'source').iterdir())==set(candidate)
 for r,h in candidate.items():assert sha(W/'source'/r)==h
 verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','ae0b43d2c9ce7b88e63e2d81be97e04dcbd45bbab827cf63f9339828df147cff')
 data=(W/'COMMANDS.log').read_bytes();assert data.endswith(b'\n');rows=[json.loads(s) for s in data.splitlines()]
 for row in rows:
  for s in ['stdout','stderr']:assert sha(W/row[s])==row['stream_sha256'][s]
 (W/'artifacts/COMMANDS.final_prefix.log').write_bytes(data)
 (W/'artifacts/final_prefix_receipt.json').write_text(json.dumps(dict(bytes=len(data),records=len(rows),sha256=sha(W/'artifacts/COMMANDS.final_prefix.log'),completed_only=True),indent=2)+'\n')
 (W/'artifacts/freeze_recipe.json').write_text(json.dumps(dict(status='FROZEN_PARTIAL_PROOF',write_order='OUTPUTS.sha256 is last write; stdout hashes afterwards; all later jobs use fresh DEST only',source_readonly=True,bootstrap_readonly=True,source_changed=False,new_source_patch_integrated=False,owner_accepted=False,report_sha256=sha(W/'REPORT.md')),indent=2)+'\n')
 scope=members(W);text=''.join(sha(W/r)+'  '+r+'\n' for r in scope);(W/'OUTPUTS.sha256').write_text(text)
 pin=sha(W/'OUTPUTS.sha256');assert set(verify_manifest(W,'OUTPUTS.sha256',pin))==set(members(W))
 print(json.dumps(dict(status='PARTIAL_PROOF',operational_subclaim=result['operational_subclaim'],report_sha256=sha(W/'REPORT.md'),outputs_sha256=pin,members=len(scope),member_bytes=sum((W/r).stat().st_size for r in scope),semantic_files=len(json.loads((W/'SEMANTIC_FILES.json').read_text())['files'])),indent=2))
