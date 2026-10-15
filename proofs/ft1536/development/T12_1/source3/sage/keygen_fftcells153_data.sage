#!/usr/bin/env sage
# Literal candidate generation only; every equality still needs a kernel check.
import hashlib,json
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
candidate=root/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
assert sha(candidate)=='3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891'
data=json.loads(candidate.read_text());rows=[]
for side in ['f','g']:
    assert len(data[side])==12
    for stage,encoded in data[side].items():
        words=[ZZ(v) for v in encoded]
        assert len(words)==1536 and all(0<=v<2^64 for v in words)
        suffix=''.join(part[0].upper()+part[1:] for part in stage.split('_'))
        module='GeneratedFftData153'+side.upper()+suffix
        literals=[format(int(v),'#018x') for v in words]
        chunks=[', '.join(literals[i:i+8]) for i in range(0,len(literals),8)]
        text='import Source3.FiniteWordVector153\n\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+module+'\n\n'
        text+='def data : Array (BitVec 64) := #[\n  '+',\n  '.join(chunks)+']\n\n'
        text+='theorem size : data.size=1536 := by decide +kernel\n\n'
        text+='def word (i : Fin 1536) : BitVec 64 := data[i.val]\'(by rw [size]; exact i.isLt)\n\n'
        text+='end FT1536.Source3.'+module+'\n'
        p=Path.cwd()/(module+'.lean');p.write_text(text)
        rows.append({'side':side,'stage':stage,'module':module,'path':str(p),'sha256':sha(p),'words':int(len(words))})
(Path.cwd()/'DATA153_MANIFEST.json').write_text(json.dumps({
 'status':'CANDIDATE_LITERAL_DATA; KERNEL_EQUALITIES_NOT_YET_PROVED','sage_version':SAGE_VERSION,'domains':['ZZ'],
 'candidate':{'path':str(candidate),'sha256':sha(candidate)},'modules':rows},indent=2)+'\n')
