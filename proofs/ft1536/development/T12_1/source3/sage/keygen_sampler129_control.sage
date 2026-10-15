#!/usr/bin/env sage
# Finite candidate/native consistency control; never a source/probability premise.
import hashlib,json,re
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
record=json.loads(manifest.read_text())
path=Path(record['selected'])/'DECODED.json'
assert sha(path)==next(row['sha256'] for row in record['artifacts'] if row['path']==str(path))
decoded=json.loads(path.read_text())
inputs=[('f','keygen_sampler129_001/GeneratedSampler129F24.lean','beb65341588778b156cf2d32cb6d193a5c9d2a055ae5d8cf3b15be7798a78f63'),
        ('g','keygen_sampler129_006/GeneratedSampler129G24.lean','eb7249f411e0cfb574f3cba54fe83f86c2de413ee76a8f29ce86b399594e25f2')]
results=[]
for label,relative,digest in inputs:
    source=root/'.build/jobs'/relative
    assert sha(source)==digest
    match=re.search(r'def coefficientBlock : C99FiniteMemory114.Block := ⟨6144,true,none,(.*?)⟩',source.read_text(),re.S)
    assert match is not None
    expression=match.group(1)
    tokens=re.findall(r'\.node|\.empty|some|none|[()]|[0-9]+',expression)
    assert ''.join(tokens)==re.sub(r'\s+','',expression)
    position=0;cells={}
    def eat(expected):
        global position
        assert tokens[position]==expected,(position,expected,tokens[position])
        position+=1
    def node(bits):
        global position
        if tokens[position]=='.empty':
            position+=1;return
        eat('(');eat('.node')
        if tokens[position]=='none':position+=1
        else:
            eat('(');eat('some');eat('(');eat('some')
            value=ZZ(tokens[position]);position+=1
            assert 0<=value<256
            eat(')');eat(')')
            assert bits not in cells;cells[bits]=value
        node(bits+(0,));node(bits+(1,));eat(')')
    node(())
    assert position==len(tokens)
    def key(index):
        bits=[]
        while index:
            bits.append(int(index%2));index=index//2
        return tuple(bits)
    assert len(cells)==3072 and all(key(i) in cells for i in range(3072))
    values=[]
    for i in range(1536):
        word=cells[key(2*i)]+256*cells[key(2*i+1)]
        values.append(word if word<2^15 else word-2^16)
    assert values==[ZZ(x) for x in decoded[label]]
    assert max(abs(x) for x in values)<=1
    results.append({'array':label,'path':str(source),'sha256':digest,'words':len(values),
      'counts':{str(x):int(values.count(ZZ(x))) for x in [-1,0,1]},'matches_pinned_native':True})
(Path.cwd()/'SAMPLER129_CONTROL.json').write_text(json.dumps({
 'status':'PASS_FINITE_CONTROL_ONLY; NOT_SOURCE_OR_PROBABILITY_PROOF',
 'sage_version':SAGE_VERSION,'decoded':{'path':str(path),'sha256':sha(path)},
 'manifest':{'path':str(manifest),'sha256':sha(manifest)},'arrays':results},indent=2)+'\n')
