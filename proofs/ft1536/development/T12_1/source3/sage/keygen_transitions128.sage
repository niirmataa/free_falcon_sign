#!/usr/bin/env sage
# Untrusted public-fixture proposals. Source proofs are separate obligations.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION

root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
dest=Path.cwd()
def sha(path): return hashlib.sha256(Path(path).read_bytes()).hexdigest()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text())
path=Path(record['selected'])/'events.bin'
expected=next(row['sha256'] for row in record['artifacts'] if row['path']==str(path))
assert sha(path)==expected
raw=path.read_bytes();position=0;events=[]
while position<len(raw):
    n=int.from_bytes(raw[position:position+4],'little');position+=4
    tag=raw[position:position+n].decode();position+=n
    n=int.from_bytes(raw[position:position+8],'little');position+=8
    data=raw[position:position+n];assert len(data)==n;position+=n
    events.append((tag,data))
assert position==len(raw)
def word(data,offset):return ZZ(int.from_bytes(data[offset:offset+8],'little'))
def lanes(data):
    assert len(data)==416
    result=[word(data,216+8*i) for i in range(25)]
    assert all(0<=x<2^64 for x in result)
    return result
before=None;captured=None;pairs=[];draws=0
for tag,data in events:
    if tag=='shake_before':
        assert before is None;before=data;captured=None
    elif tag=='shake_bytes':
        assert before is not None and captured is None and len(data)==8;captured=data
    elif tag=='shake_after':
        assert before is not None and captured is not None
        assert word(before,208)==word(data,208)==136
        old,new=lanes(before),lanes(data)
        if word(before,200)==136:
            assert word(data,200)==8;pairs.append((old,new))
        else:
            assert word(data,200)==word(before,200)+8 and old==new
        draws+=1;before=None;captured=None
assert before is None and draws==129 and len(pairs)==8
assert len(set(tuple(a) for a,b in pairs))==8
def lean_list(values):return '['+','.join(hex(int(x)) for x in values)+']'
module='''import Source3.ShakeProcessProposal128

namespace FT1536.Source3.GeneratedProcessTransitions128
def candidates : List ShakeProcessProposal128.Transition := [
'''+',\n'.join('  ⟨'+lean_list(a)+','+lean_list(b)+'⟩' for a,b in pairs)+''']
end FT1536.Source3.GeneratedProcessTransitions128
'''
output=dest/'GeneratedProcessTransitions128.lean';output.write_text(module)
(dest/'TRANSITIONS128.json').write_text(json.dumps({
    'status':'UNTRUSTED_PROPOSALS_ONLY; NO_SOURCE_OR_PROBABILITY_PREMISE',
    'sage_version':SAGE_VERSION,'input':{'path':str(path),'sha256':sha(path)},
    'manifest':{'path':str(manifest),'sha256':sha(manifest)},
    'draws':int(draws),'process_calls':len(pairs),'word_bits':int(64),'lanes':int(25),
    'checks':['sealed input digest','paired129 eight-byte draws','rate136 and cursor evolution','eight distinct full input lane vectors','no lane change between refills'],
    'artifacts':[{'path':str(output),'sha256':sha(output)}]},indent=2)+'\n')
