import json,sys
from pathlib import Path
from replaylib import sha,verify_manifest,member
from package_scope import output_files,semantic_paths
def verify(root,pin):
 root=Path(root);rows=verify_manifest(root,'OUTPUTS.sha256',pin)
 assert set(rows)==set(output_files(root)),'Unexpected/missing authoritative output file'
 expected=json.loads((root/'SEMANTIC_FILES.json').read_text())['matches']
 assert expected==json.loads((root/'artifacts/fresh_replay.json').read_text())['matches']
 assert set(semantic_paths(root))=={r['path'] for r in expected}
 for r in expected:assert rows[r['path']]==r['sha256']
 prefix=json.loads((root/'artifacts/commands_prefix.json').read_text());data=(root/prefix['path']).read_bytes()
 assert len(data)==prefix['bytes'] and sha(root/prefix['path'])==prefix['sha256'] and len(data.splitlines())==prefix['records']
 if (root/'COMMANDS.log').exists():assert (root/'COMMANDS.log').read_bytes().startswith(data)
 for r in map(json.loads,data.splitlines()):
  for stream in ['stdout','stderr']:assert rows[r[stream]]==r['stream_sha256'][stream]
 inputs={n:h for h,n in (line.split('  ',1) for line in (root/'INPUTS.sha256').read_text().splitlines())}
 provenance=json.loads((root/'inputs/provenance.json').read_text());assert inputs=={r['path']:r['sha256'] for r in provenance}
 for r in provenance:assert rows[r['copy']]==r['sha256']
 result=json.loads((root/'RESULT.json').read_text());assert result['status']=='FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD'
 return dict(status='PASS_FROZEN_PACKAGE',output_members=len(rows),output_bytes=sum(member(root,p).stat().st_size for p in rows),
  public_inputs=len(inputs),semantic_matches=len(expected),report_sha256=rows['REPORT.md'],outputs_sha256=pin,
  candidate_manifest_sha256=result['candidate_manifest_sha256'],candidate_header_sha256=result['candidate_header_sha256'],patch_sha256=result['patch_sha256'])
if __name__=='__main__':print(json.dumps(verify(Path(__file__).absolute().parents[1],sys.argv[1]),indent=2))
