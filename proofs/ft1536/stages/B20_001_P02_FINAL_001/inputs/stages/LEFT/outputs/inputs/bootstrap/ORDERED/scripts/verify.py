import json,sys
from pathlib import Path
from package_scope import output_files,semantic_paths
from replaylib import sha,verify_manifest,member
def verify(W,pin):
 W=Path(W);rows=verify_manifest(W,'OUTPUTS.sha256',pin);assert set(rows)==set(output_files(W))
 expected=json.loads((W/'SEMANTIC_FILES.json').read_text())['matches'];fresh=json.loads((W/'artifacts/fresh_replay.json').read_text())
 assert fresh['status']=='FRESH_REPLAY_PASS' and expected==fresh['matches'] and set(semantic_paths(W))=={r['path'] for r in expected}
 for r in expected:assert rows[r['path']]==r['sha256']
 prefix=json.loads((W/'artifacts/commands_prefix.json').read_text());data=(W/prefix['path']).read_bytes()
 assert len(data)==prefix['bytes'] and len(data.splitlines())==prefix['records'] and sha(W/prefix['path'])==prefix['sha256']
 if (W/'COMMANDS.log').exists():assert (W/'COMMANDS.log').read_bytes().startswith(data)
 for row in map(json.loads,data.splitlines()):
  for s in ['stdout','stderr']:assert rows[row[s]]==row['stream_sha256'][s]
 inputs={n:h for h,n in (s.split('  ',1) for s in (W/'INPUTS.sha256').read_text().splitlines())};prov=json.loads((W/'inputs/provenance.json').read_text());assert inputs=={r['path']:r['sha256'] for r in prov}
 for r in prov:assert rows[r['copy']]==r['sha256']
 result=json.loads((W/'RESULT.json').read_text());assert result['status']=='PARTIAL_PROOF' and not result['ordered_root_reach_proved'] and result['right_branch_mu_domain_proved']
 return dict(status='PASS_FROZEN_PACKAGE',claim_status='PARTIAL_PROOF',output_members=len(rows),output_bytes=sum(member(W,p).stat().st_size for p in rows),public_inputs=len(inputs),semantic_matches=len(expected),report_sha256=rows['REPORT.md'],outputs_sha256=pin,source_pin=result['source_pin'],certificate_sha256=rows['ORDERED_REACH_CERTIFICATE.json'])
if __name__=='__main__':print(json.dumps(verify(Path(__file__).absolute().parents[1],sys.argv[1]),indent=2))
