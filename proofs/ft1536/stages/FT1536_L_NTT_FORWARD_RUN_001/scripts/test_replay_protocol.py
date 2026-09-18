"""Meaningful rejection controls for the new external-pin replay interface."""
import hashlib,json
from pathlib import Path
from replaylib import sha,verify_manifest
root=Path.cwd()/'tmp/protocol_checks';root.mkdir(exist_ok=False)
(root/'public.txt').write_text('public fixture\n')
manifest=root/'OUTPUTS.sha256';manifest.write_text(sha(root/'public.txt')+'  public.txt\n')
assert verify_manifest(root,'OUTPUTS.sha256',sha(manifest))=={'public.txt':sha(root/'public.txt')}
results=['valid_manifest_pass']
def rejected(name,expected):
    try:verify_manifest(root,'OUTPUTS.sha256',expected)
    except ValueError:results.append(name);return
    raise AssertionError(name)
rejected('wrong_external_pin_rejected','0'*64)
(root/'public.txt').write_text('changed\n')
rejected('changed_member_rejected',sha(manifest))
manifest.write_text(sha(root/'public.txt')+'  ../public.txt\n')
rejected('traversal_rejected',sha(manifest))
(root/'link').symlink_to('public.txt')
manifest.write_text(sha(root/'public.txt')+'  link\n')
rejected('symlink_rejected',sha(manifest))
manifest.write_text((sha(root/'public.txt')+'  public.txt\n')*2)
rejected('duplicate_rejected',sha(manifest))
out=dict(status='PASS',checks=results,scope='manifest authority/path validation; no math proof inferred')
Path('artifacts/replay_protocol_tests.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out,indent=2))
