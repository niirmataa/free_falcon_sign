"""Read-only verification of the sealed file set and frozen command prefix."""
import hashlib,json
from pathlib import Path
W=Path.cwd()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
rows=(W/'OUTPUTS.sha256').read_text().splitlines();seen=set()
for row in rows:
    want,rel=row.split('  ',1);p=Path(rel)
    assert not p.is_absolute() and '..' not in p.parts and rel not in seen
    seen.add(rel);p=W/p
    assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents)),rel
    assert sha(p)==want,rel
prefix=json.loads((W/'artifacts/command_prefix.json').read_text())
assert hashlib.sha256((W/'COMMANDS.log').read_bytes()[:prefix['bytes']]).hexdigest()==prefix['sha256']
result=json.loads((W/'RESULT.json').read_text())
assert result['status']=='PARTIAL_PROOF' and not result['L_NTT_proved'] and result['inverse_forward_instantiated']
assert sha(W/'REPORT.md')==result['report_sha256']
print(json.dumps(dict(manifest='PASS',verified_entries=len(rows),command_prefix='PASS',status=result['status'],
                     report_sha256=sha(W/'REPORT.md'),outputs_sha256=sha(W/'OUTPUTS.sha256')),indent=2))
