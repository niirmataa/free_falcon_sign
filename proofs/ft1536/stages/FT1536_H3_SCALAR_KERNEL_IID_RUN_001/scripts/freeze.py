import fcntl,json
from pathlib import Path
from replaylib import sha,verify_manifest
from scope import members
W=Path.cwd();assert not (W/'OUTPUTS.sha256').exists()
with (W/'executor.lock').open('a') as lock:
 fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
 required=['REPORT.md','RESULT.json','CLAIM.md','SCALAR_KERNEL_CERTIFICATE.json','RANDOMNESS_MODEL.md','BYTE_SCHEDULE.md','BYTE_SCHEDULE.json','CDF_MASS.md','CDF_MASS.json','BEREXP_INTEGER_KERNEL.md','ACCEPTANCE_FLOOR.md','ACCEPTANCE_FLOOR.json','REJECTION_LAW.md','PRNG_GAP_INTERFACE.md','SOURCE_MODEL_BINDING.md','MEMORY_FRAME.md','FAILED_ROUTES.md','NEXT_INTERFACE.md','OBLIGATIONS.json','REUSED_RESULTS.md','INPUTS.sha256','TOOLCHAIN.txt','COMMANDS.log','OUTPUT_SCOPE.md','REPLAY.md','SEMANTIC_FILES.json','artifacts/fresh_replay.json']
 for r in required:assert (W/r).is_file(),r
 result=json.loads((W/'RESULT.json').read_text());assert result['game']=='IID_BUFFER' and result['status']=='H3_SCALAR_KERNEL_PROVED_FOR_PINNED_IID_BUFFER_MODEL' and not result['real_prng_to_iid_bridge_proved']
 for r,h in result['proof_documents'].items():assert sha(W/r)==h
 for r,h in result['evidence'].items():assert sha(W/r)==h
 for r in json.loads((W/'SEMANTIC_FILES.json').read_text())['files']:assert sha(W/r['path'])==r['sha256']
 fresh=json.loads((W/'artifacts/fresh_replay.json').read_text());assert fresh['status']=='FRESH_REPLAY_PASS' and fresh['matches'] and fresh['matched']==fresh['expected_files']
 for r in fresh['matches']:assert sha(W/r['path'])==r['sha256']
 candidate={p:h for h,p in (s.split('  ',1) for s in (W/'inputs/bootstrap/CANDIDATE.sha256').read_text().splitlines())};assert set(p.name for p in (W/'source').iterdir())==set(candidate)
 for r,h in candidate.items():assert sha(W/'source'/r)==h
 verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256','eb890ea42dad55d397ebd6f71fad5457676d705e5443a5a672201a0ce6e553a8')
 data=(W/'COMMANDS.log').read_bytes();assert data.endswith(b'\n');rows=[json.loads(s) for s in data.splitlines()]
 for row in rows:
  for s in ['stdout','stderr']:assert sha(W/row[s])==row['stream_sha256'][s]
 (W/'artifacts/COMMANDS.final_prefix.log').write_bytes(data);(W/'artifacts/final_prefix_receipt.json').write_text(json.dumps(dict(bytes=len(data),records=len(rows),sha256=sha(W/'artifacts/COMMANDS.final_prefix.log'),completed_only=True),indent=2)+'\n')
 (W/'artifacts/freeze_recipe.json').write_text(json.dumps(dict(status=result['status'],game='IID_BUFFER',write_order='OUTPUTS is last write; subsequent jobs only in fresh DEST',report_sha256=sha(W/'REPORT.md'),source_changed=False,owner_accepted=False),indent=2)+'\n')
 scope=members(W);(W/'OUTPUTS.sha256').write_text(''.join(sha(W/r)+'  '+r+'\n' for r in scope))
 pin=sha(W/'OUTPUTS.sha256');assert set(verify_manifest(W,'OUTPUTS.sha256',pin))==set(members(W))
 print(json.dumps(dict(status=result['status'],game='IID_BUFFER',report_sha256=sha(W/'REPORT.md'),outputs_sha256=pin,members=len(scope),member_bytes=sum((W/r).stat().st_size for r in scope),semantic_files=len(fresh['matches']),real_prng_to_iid_bridge_proved=False),indent=2))
