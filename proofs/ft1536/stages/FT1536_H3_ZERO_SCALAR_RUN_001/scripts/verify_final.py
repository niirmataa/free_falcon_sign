"""Read-only final integrity, provenance and scope validation; not a new proof."""
import json, sys
from pathlib import Path
from package_scope import selected_files
from replaylib import member, sha, verify_manifest

W = Path(__file__).absolute().parents[1]
if len(sys.argv) != 2:
    raise ValueError('verify_final.py EXTERNAL_OUTPUTS_SHA256')
scope = verify_manifest(W, 'OUTPUTS.sha256', sys.argv[1])
# Extra files in the live work log after seal are intentionally outside freeze.
selected = set(selected_files(W))
extra = selected-set(scope)
assert set(scope) <= selected
assert all(p.startswith('logs/') for p in extra), sorted(extra)
for rel in extra:
    assert Path(rel).parent.as_posix() == 'logs' and Path(rel).suffix in {'.stdout', '.stderr'}
result = json.loads(member(W, 'RESULT.json').read_text())
assert scope['REPORT.md'] == result['pins']['report_sha256']
assert result['status'] == 'H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL'
assert result['source_add_error_fully_kernelized'] is False
assert result['consumer_analytic_premise_explicit'] is True
for key in ['H3_range_proved', 'global_reachability_proved', 'sampler_law_proved',
            'source_changed', 'new_source_patch_integrated', 'protocol_wrapper_integrated',
            'owner_accepted', 'security_reduction_proved']:
    assert result[key] is False
assert result['baseline_source_integrated'] is True
receipt = json.loads(member(W, 'artifacts/fresh_replay.json').read_text())
assert receipt['status'] == 'FRESH_REPLAY_PASS'
matches = {r['path']: r['sha256'] for r in receipt['matches']}
assert len(matches) == len(receipt['matches']) == 95
for rel, h in matches.items():
    assert scope[rel] == h
assert verify_manifest(W, 'artifacts/semantic_manifest.sha256', receipt['semantic_manifest_sha256']) == matches
boot = W/'inputs/bootstrap'
bootstrap = verify_manifest(boot, 'MANIFEST.sha256', result['pins']['bootstrap_manifest_sha256'])
assert len(bootstrap) == 73
assert {p.relative_to(boot).as_posix() for p in boot.rglob('*') if p.is_file()} == set(bootstrap)|{'MANIFEST.sha256'}
assert sha(boot/'CANDIDATE.sha256') == result['pins']['candidate_manifest_sha256']
for line in (boot/'CANDIDATE.sha256').read_text().splitlines():
    h, n = line.split('  ', 1)
    assert sha(member(W/'source', n)) == h
provenance = json.loads(member(W, 'inputs/provenance.json').read_text())
inputs = {}
for line in member(W, 'INPUTS.sha256').read_text().splitlines():
    h, p = line.split('  ', 1)
    assert p not in inputs
    inputs[p] = h
assert inputs == {r['path']: r['sha256'] for r in provenance}
for row in provenance:
    assert scope[row['copy']] == row['sha256']
ledger = json.loads(member(W, 'ERROR_LEDGER.json').read_text())
assert ledger['status'] == result['status']
for row in ledger['rows']:
    for evidence in row['evidence']:
        assert scope[evidence['path']] == evidence['sha256']
audit = json.loads(member(W, 'artifacts/formal_audit.json').read_text())
assert audit['all_final_logs_clean'] and not audit['B_fully_kernelized']
assert scope['ANALYTIC_PROOF.md'] == audit['analytic_proof_sha256']
for p, h in audit['sources_sha256'].items():
    assert scope[p] == h
archive = json.loads(member(W, 'artifacts/replay_evidence.json').read_text())
for row in archive['files']:
    assert scope[row['path']] == row['sha256']
prefix = json.loads(member(W, 'artifacts/command_prefix.json').read_text())
data = member(W, prefix['path']).read_bytes()
assert len(data) == prefix['bytes'] and sha(W/prefix['path']) == prefix['sha256']
assert len(data.splitlines()) == prefix['command_records']
if (W/'COMMANDS.log').exists():
    assert (W/'COMMANDS.log').read_bytes().startswith(data)
print(json.dumps(dict(status='FINAL_INTEGRITY_PASS', members=len(scope),
                      semantic_matches=len(matches), public_inputs=len(provenance),
                      unarchived_post_seal_log_files=len(extra),
                      report_sha256=scope['REPORT.md'], outputs_sha256=sys.argv[1],
                      proof_kind=result['local_proof_kind']), indent=2))
