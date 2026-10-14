#!/usr/bin/env sage
# Untrusted literal-state certificate generation. Lean checks every phase.
import hashlib,json,re
from pathlib import Path
from sage.env import SAGE_VERSION

root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4];dest=Path.cwd()
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text())
pins={row['path']:row['sha256'] for row in record['artifacts']}
folder=Path(record['selected']);seed_path=folder/'seed.bin';events_path=folder/'events.bin'
for p in [seed_path,events_path]:assert sha(p)==pins[str(p)]
seed=seed_path.read_bytes();assert len(seed)==32
raw=events_path.read_bytes();position=0;events=[]
while position<len(raw):
    n=int.from_bytes(raw[position:position+4],'little');position+=4
    tag=raw[position:position+n].decode();position+=n
    n=int.from_bytes(raw[position:position+8],'little');position+=8
    value=raw[position:position+n];assert len(value)==n;position+=n
    events.append((tag,value))
assert position==len(raw)
def only(tag):
    values=[v for t,v in events if t==tag];assert len(values)==1
    return values[0]
new=only('rng_new');seeded=only('rng_seeded')
flipped=next(v for t,v in events if t=='shake_before')
assert len(new)==len(seeded)==len(flipped)==416
complements=[1,2,8,12,17,20]
initialized=bytearray(416)
initialized[208:216]=int(136).to_bytes(8,'little')
for i in complements:initialized[216+8*i:224+8*i]=int(2^64-1).to_bytes(8,'little')
assert bytes(initialized)==new
injected=bytearray(initialized);injected[:32]=seed;injected[200:208]=int(32).to_bytes(8,'little')
assert bytes(injected)==seeded
padded=bytearray(injected);padded[32]=31;padded[33:135]=bytes(102);padded[135]=128
padded[200:208]=int(136).to_bytes(8,'little')
for i in range(17):
    a=ZZ(int.from_bytes(padded[216+8*i:224+8*i],'little'))
    b=ZZ(int.from_bytes(padded[8*i:8*i+8],'little'))
    padded[216+8*i:224+8*i]=int(a^^b).to_bytes(8,'little')
assert bytes(padded)==flipped

source=repo/'Extra/c/shake.c'
source_pin=next(row['sha256'] for row in record['source_inputs'] if row['path']==str(source))
assert sha(source)==source_pin
rc_text=''.join(source.read_text().splitlines(keepends=True)[39:51])
rc=[ZZ(s,16) for s in re.findall(r'0x([0-9A-Fa-f]+)',rc_text)]
assert len(rc)==24 and all(0<=v<2^64 for v in rc)
rc_bytes=b''.join(int(v).to_bytes(8,'little') for v in rc)

# The exact same sparse-trie shape as C99FiniteMap114.digits/set. Literal
# constructor output is untrusted and is independently kernel checked below.
def digits(n):
    n=ZZ(n);out=[]
    while n:
        out.append(int(n%2));n//=2
    return out
def insert(tree,key,value):
    if tree is None:tree=[None,None,None]
    if not key:tree[0]=value
    else:tree[1+key[0]]=insert(tree[1+key[0]],key[1:],value)
    return tree
def tree_text(tree):
    if tree is None:return '.empty'
    value='none' if tree[0] is None else '(some '+tree[0]+')'
    return '(.node '+value+' '+tree_text(tree[1])+' '+tree_text(tree[2])+')'
def block(data,writable):
    tree=None
    for i,v in enumerate(data):tree=insert(tree,digits(i),'(some '+str(int(v))+')')
    return '⟨'+str(len(data))+','+('true' if writable else 'false')+',none,'+tree_text(tree)+'⟩'
def state(rng):
    # Local SHAKE scope only: unused context bytes are fixed zero; full law110
    # canonical caller/domain construction remains a separate obligation.
    context=bytearray(448);context[8:424]=rng
    tree=None
    for number,data,writable in [(0,seed,True),(1,context,True),(20,rc_bytes,False)]:
        tree=insert(tree,digits(number),block(data,writable))
    return '⟨⟨'+tree_text(tree)+'⟩,[],[],[],[("RC".toList,⟨20,0,24,8,0⟩)]⟩'
module='''import Source3.ShakeSeedInvoke118

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Generated public synthetic119 byte states. This file is an untrusted
   candidate certificate, not a native-execution premise. -/
namespace FT1536.Source3.GeneratedSeed119Fixture
open C99CompactState115 (State reference)
def ctx : ShakeExtractSource.Layout := ⟨1,8⟩
def seedPointer : C99MemoryReference.ArrayPointer := ⟨0,0,32,1,0⟩
def rcPointer : C99MemoryReference.ArrayPointer := ⟨20,0,24,8,0⟩
'''
for name,data in [('seedBytes',seed),('newBytes',new),('seededBytes',seeded),('flippedBytes',flipped)]:
    module+='def '+name+' : List (BitVec 8) := ['+','.join(str(int(v)) for v in data)+']\n\n'
for name,data in [('before',new),('initialized',initialized),('injected',injected),('flipped',padded)]:
    module+='def '+name+' : State := '+state(data)+'\n\n'
module+='end FT1536.Source3.GeneratedSeed119Fixture\n'
target=dest/'GeneratedSeed119Fixture.lean';target.write_text(module)
result={'status':'PINNED_NATIVE_BOUNDARIES_MATCH_EXACT_SOURCE_PHASE_CANDIDATES; KERNEL_CHECK_PENDING',
    'sage_version':SAGE_VERSION,'exact_domain':'ZZ','selected_counter':int(9),'seed_bytes':int(32),
    'rng_bytes_per_boundary':int(416),'context_bytes':int(448),'canonical_caller_domain_constructed':False,
    'inputs':[{'path':str(p),'sha256':sha(p)} for p in [manifest,seed_path,events_path,source]],
    'output':{'path':str(target),'sha256':sha(target)},
    'checks':['rng_new exact512-capacity initialization','rng_seeded exact32-byte injection','first shake_before exact padding and17 little-endian xor words','source RC24 words','literal finite-trie state serialization']}
(dest/'SELECTED119.json').write_text(json.dumps(result,indent=2)+'\n')
