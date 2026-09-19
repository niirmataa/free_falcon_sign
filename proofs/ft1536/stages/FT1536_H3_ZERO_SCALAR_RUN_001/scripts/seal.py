"""One-shot freeze. The seal command's own receipt is after the frozen log prefix."""
import json
from pathlib import Path
from package_scope import selected_files
from replaylib import member, sha, verify_manifest

W = Path.cwd()
assert not (W/'OUTPUTS.sha256').exists()
result = json.loads(member(W, 'RESULT.json').read_text())
assert sha(member(W, 'REPORT.md')) == result['pins']['report_sha256']
assert result['status'] == 'H3_ZERO_SCALAR_PROVED_FOR_PINNED_MODEL'
assert not result['source_add_error_fully_kernelized']
receipt = json.loads(member(W, 'artifacts/fresh_replay.json').read_text())
anchor = verify_manifest(W, 'artifacts/semantic_manifest.sha256', receipt['semantic_manifest_sha256'])
assert receipt['status'] == 'FRESH_REPLAY_PASS'
assert {r['path']: r['sha256'] for r in receipt['matches']} == anchor
prefix = member(W, 'COMMANDS.log').read_bytes()
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:
    f.write(prefix)
with (W/'artifacts/command_prefix.json').open('x') as f:
    json.dump(dict(path='artifacts/COMMANDS.frozen.log', bytes=len(prefix),
                   sha256=sha(W/'artifacts/COMMANDS.frozen.log'),
                   command_records=len(prefix.splitlines()),
                   note='Exact completed-command prefix before the seal command receipt.'), f, indent=2)
    f.write('\n')
paths = selected_files(W)
for rel, h in anchor.items():
    assert rel in paths and sha(member(W, rel)) == h
with (W/'OUTPUTS.sha256').open('x') as f:
    for rel in paths:
        f.write(sha(member(W, rel))+'  '+rel+'\n')
pin = sha(W/'OUTPUTS.sha256')
assert set(verify_manifest(W, 'OUTPUTS.sha256', pin)) == set(paths)
print(json.dumps(dict(status='FROZEN', members=len(paths),
                      report_sha256=sha(W/'REPORT.md'), outputs_sha256=pin), indent=2))
