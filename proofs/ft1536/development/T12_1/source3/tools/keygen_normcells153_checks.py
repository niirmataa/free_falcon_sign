#!/usr/bin/env python3
"""Generate flat norm-transition certificates; no recursive numeric sum is assumed."""
from pathlib import Path
import hashlib,json,re,sys
ROOT=Path(__file__).resolve().parents[1]
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_fftcells153_[0-9]{3}',label) and re.fullmatch(r'[0-9a-f]{64}',digest)
manifest=ROOT/'.build/jobs'/label/'NORMDATA153_MANIFEST.json'
assert hashlib.sha256(manifest.read_bytes()).hexdigest()==digest
data=json.loads(manifest.read_text());src=Path(data['output']['path'])
assert hashlib.sha256(src.read_bytes()).hexdigest()==data['output']['sha256']
def write(path,text):
    if path.exists():assert path.read_text()==text,path
    else:path.write_text(text)
write(ROOT/'formal/Source3/GeneratedNormData153.lean',src.read_text())
actual='NormTrace153.stepImage GeneratedFftTree153FTriple.word GeneratedFftTree153GTriple.word GeneratedNormData153.point'
expected='NormTrace153.nextImage (n:=1536) GeneratedNormData153.point'
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
groups=[];modules=[]
for group in range(6):
    name=f'GeneratedNormCheck153Group{group:03d}'
    text='import Source3.NormTrace153\nimport Source3.GeneratedNormData153\nimport Source3.GeneratedFftTree153FTriple\nimport Source3.GeneratedFftTree153GTriple\n'+options
    text+='namespace FT1536.Source3.'+name+'\n\n'
    for k in range(4*group,4*group+4):
        text+=f'theorem checked{k} : FiniteWordVector153.checkChunk ({actual}) ({expected}) (64*{k}) 64=true := by decide +kernel\n\n'
    text+='end FT1536.Source3.'+name+'\n'
    write(ROOT/'formal/Source3'/(name+'.lean'),text);groups.append(name);modules.append(name)
name='GeneratedNormCheck153'
text=''.join('import Source3.'+g+'\n' for g in groups)+options
text+='namespace FT1536.Source3.'+name+'\n\n'
text+=f'theorem source : ({actual})=({expected}) := by\n'
text+=f'  apply FiniteWordVector153.complete ({actual}) ({expected}) 64 24 (by decide) (by decide)\n'
text+='  intro block\n  fin_cases block\n'
for k in range(24):text+='  · exact '+groups[k//4]+f'.checked{k}\n'
text+='\nend FT1536.Source3.'+name+'\n'
write(ROOT/'formal/Source3'/(name+'.lean'),text);modules.append(name)
plan={'modules':modules,'data_module':'GeneratedNormData153','source_manifest':{'path':str(manifest),'sha256':digest},
 'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()},
 'transitions':1536,'chunk_width':64,'checks_per_group':4}
write(ROOT/'.build/fftcells153/NORM_CHECK_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'modules':len(modules),'transitions':1536,'checks':24}))
