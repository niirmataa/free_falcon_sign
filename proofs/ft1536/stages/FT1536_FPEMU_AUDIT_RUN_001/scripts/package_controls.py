"""Negative controls for the replay trust boundary, using disposable manifests."""
from common import W, sha, dump
from replay import verify_manifest, safe

d=W/'tmp/package_controls'
d.mkdir(parents=True,exist_ok=False)
h=sha(W/'scripts/oracle.py')
good=d/'good.sha256'
good.write_text(h+'  scripts/oracle.py\n')
assert verify_manifest(good,sha(good))=={'scripts/oracle.py':h}
checks=[]
def reject(name,call):
    try: call()
    except (AssertionError,ValueError): checks.append(name)
    else: raise AssertionError('accepted '+name)
reject('wrong_external_manifest_hash',lambda:verify_manifest(good,'0'*64))
for name,text in [
    ('wrong_member_hash','0'*64+'  scripts/oracle.py\n'),
    ('duplicate_member',good.read_text()*2),
    ('parent_traversal',h+'  ../oracle.py\n'),
    ('absolute_path',h+'  /etc/passwd\n'),
    ('manifest_self_inclusion',h+'  OUTPUTS.sha256\n')]:
    p=d/(name+'.sha256');p.write_text(text)
    reject(name,lambda p=p:verify_manifest(p,sha(p)))
link=d/'symlink'
link.symlink_to(W/'scripts')
reject('symlink_component',lambda:safe(W,'tmp/package_controls/symlink/oracle.py'))
dump('artifacts/package_controls.json',dict(status='PASS',positive='valid pinned member accepted',
    rejected=checks,controls_touch_only_disposable_tmp=True))
print('PASS: replay manifest positive control and',len(checks),'negative trust-boundary controls')
