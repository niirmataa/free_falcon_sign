#!/usr/bin/env sage
# PUBLIC synthetic byte-memory controls, exact ZZ. No real codec/KeyGen,
# secret key, distribution or universal proof. Kernel proofs are separate.
import json
import os
import sys
from datetime import datetime, timezone

def locate(name):
    here = os.getcwd()
    for _ in range(12):
        p = os.path.join(here, name)
        if os.path.exists(p): return p
        here = os.path.dirname(here)
    raise RuntimeError('reference source not found')

BASE = ZZ(4096)
VALUES = [ZZ(100), ZZ(200), ZZ(300), ZZ(400)]

def put(memory, offset, value):
    out = dict(memory)
    for j in range(8): out[offset+j] = (value >> (8*j)) & 255
    return out

def get(memory, offset):
    return sum(ZZ(memory[offset+j]) << (8*j) for j in range(8))

def chain(order, wrong=-1):
    memory = {}
    for i in order:
        memory = put(memory, BASE+8*i, VALUES[i]+(1 if i == wrong else 0))
        for j in order[:order.index(i)]:
            if get(memory, BASE+8*j) != VALUES[j]: return False
    return all(all(BASE+8*i+j in memory for j in range(8)) and
               get(memory, BASE+8*i) == VALUES[i] for i in range(4))

baseline = chain([0,1,2,3])
mutations = {'omit_0':not chain([1,2,3]), 'omit_3':not chain([0,1,2]),
             'wrong_word':not chain([0,1,2,3],2), 'duplicate_slot':not chain([0,1,1,3])}
original = put({}, BASE, VALUES[0])
foreign = put(original, BASE+8, VALUES[1])
frame_baseline = get(foreign, BASE) == VALUES[0]
frame_mutations = {}
for shift in [0,1,4,7]:
    changed = put(original, BASE+shift, ZZ(2)^64-1)
    frame_mutations['overlap_'+str(shift)] = get(changed, BASE) != VALUES[0]

text = open(locate(sys.argv[1])).read()
needles = ['klen = *privkey_len;', 'skbuf = privkey;', 'skoff = 1;',
           'ske[0] = f;', 'ske[1] = g;', 'ske[2] = F;', 'ske[3] = G;',
           'for (i = 0; i < 4; i ++) {',
           'elen = falcon_encode_small(skbuf + skoff, klen - skoff,']
def transcription(t):
    cursor = 0
    for needle in needles:
        pos = t.find(needle,cursor)
        if pos < 0: return False
        cursor = pos+len(needle)
    return True
trans_mutations = {str(i):not transcription(text.replace(needles[i], 'MUTATED;',1))
                  for i in [3,4,5,6]}
families = [('chain_creation',baseline,mutations),
            ('foreign_store_frame',frame_baseline,frame_mutations),
            ('source_order',transcription(text),trans_mutations)]
results = [{'case':name,'baseline':bool(ok),'mutations':{k:bool(v) for k,v in muts.items()}}
           for name,ok,muts in families]
passed = all(r['baseline'] and all(r['mutations'].values()) for r in results)
out = {'utc':datetime.now(timezone.utc).isoformat(),
       'status':'PASS_SCRIPTED_SKE_CHAIN_CONTROLS' if passed else 'FAIL',
       'scope':'PUBLIC synthetic byte-memory controls and Extra/c transcription; no real codec or KeyGen; no universal proof or law claim',
       'arithmetic':'ZZ; little-endian 8-byte words',
       'baseline_pass':bool(passed),'mutations_all_detected':bool(passed),
       'cases_per_run':len(families),'mutation_kinds':int(12),'results':results}
with open('SKE_CHAIN_CHECK.json','w') as stream: json.dump(out,stream,indent=2);stream.write('\n')
assert passed
