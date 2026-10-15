#!/usr/bin/env python3
"""Generate bounded checks of active twiddle literals against pinned source rows."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
MANIFEST=ROOT/'.build/jobs/keygen_fftcells153_015/TWIDDLE153_MANIFEST.json'
assert hashlib.sha256(MANIFEST.read_bytes()).hexdigest()=='d1cc55a067cdf1ee68b513e1aba1a27d74439e32e67175fbddd3465565352cd0'
def write(path,text):
    if path.exists():assert path.read_text()==text,path
    else:path.write_text(text)
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
modules=[]
for row in json.loads(MANIFEST.read_text())['modules']:
    src=Path(row['path']);assert hashlib.sha256(src.read_bytes()).hexdigest()==row['sha256']
    write(ROOT/'formal/Source3'/(row['module']+'.lean'),src.read_text())
    kind=row['kind'];data=row['module'];actual='FftTwiddleFlat153.'+kind.lower();blocks=24 if kind=='Square' else 16
    groups=[]
    for group in range(blocks//4):
        name=f'GeneratedFftTwiddleCheck153{kind}Group{group:03d}'
        text='import Source3.FftTwiddleFlat153\nimport Source3.'+data+'\n'+options
        text+='namespace FT1536.Source3.'+name+'\n\n'
        for k in range(4*group,4*group+4):
            text+=f'theorem checked{k} : FiniteWordVector153.checkChunk {actual} {data}.word (32*{k}) 32=true := by decide +kernel\n\n'
        text+='end FT1536.Source3.'+name+'\n'
        write(ROOT/'formal/Source3'/(name+'.lean'),text);groups.append(name);modules.append(name)
    name='GeneratedFftTwiddleCheck153'+kind
    text=''.join('import Source3.'+g+'\n' for g in groups)+options
    text+='namespace FT1536.Source3.'+name+'\n\n'
    text+=f'theorem source : {actual}={data}.word := by\n'
    text+=f'  apply FiniteWordVector153.complete {actual} {data}.word 32 {blocks} (by decide) (by decide)\n'
    text+='  intro block\n  fin_cases block\n'
    for k in range(blocks):text+='  · exact '+groups[k//4]+'.checked'+str(k)+'\n'
    text+='\nend FT1536.Source3.'+name+'\n'
    write(ROOT/'formal/Source3'/(name+'.lean'),text);modules.append(name)
plan={'modules':modules,'source_manifest':{'path':str(MANIFEST),'sha256':hashlib.sha256(MANIFEST.read_bytes()).hexdigest()},
 'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()},'words':1280,'chunk_width':32,'checks_per_group':4}
write(ROOT/'.build/fftcells153/TWIDDLE_CHECK_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'modules':len(modules),'words':1280,'checks':40}))
