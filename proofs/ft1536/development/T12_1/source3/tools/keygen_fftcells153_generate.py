#!/usr/bin/env python3
"""Generate kernel input certificates from pinned Sage literal candidates."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
MANIFEST=ROOT/'.build/jobs/keygen_fftcells153_003/DATA153_MANIFEST.json'
assert hashlib.sha256(MANIFEST.read_bytes()).hexdigest()=='e4dbf20c97271aa5b49aed157a524c922297dfb946f9f3f8a1630b96b0cbe736'
def write(path,text):
    if path.exists():assert path.read_text()==text,path
    else:path.write_text(text)
for row in json.loads(MANIFEST.read_text())['modules']:
    source=Path(row['path']);assert hashlib.sha256(source.read_bytes()).hexdigest()==row['sha256']
    write(ROOT/'formal/Source3'/(row['module']+'.lean'),source.read_text())
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
all_modules=[]
for side,actual,data in [('F','SelectedFftBuffer141.values','GeneratedFftData153FMiddle0At24'),('G','SelectedFftGInput148.values','GeneratedFftData153GInput')]:
    chunks=[]
    for block in range(6):
        name=f'GeneratedFftInput153{side}Chunk{block:03d}'
        text='import Source3.SelectedFftImages152\nimport Source3.'+data+'\n'+options
        text+='namespace FT1536.Source3.'+name+'\n\n'
        text+=f'theorem checked : FiniteWordVector153.checkChunk {actual} {data}.word (256*{block}) 256=true := by decide +kernel\n\n'
        text+='end FT1536.Source3.'+name+'\n'
        write(ROOT/'formal/Source3'/(name+'.lean'),text);chunks.append(name);all_modules.append(name)
    name='GeneratedFftInput153'+side
    text=''.join('import Source3.'+chunk+'\n' for chunk in chunks)+options
    text+='namespace FT1536.Source3.'+name+'\n\n'
    text+=f'theorem source : {actual}={data}.word := by\n'
    text+=f'  apply FiniteWordVector153.complete {actual} {data}.word 256 6 (by decide) (by decide)\n'
    text+='  intro block\n  fin_cases block\n'+''.join('  · exact '+chunk+'.checked\n' for chunk in chunks)
    text+='\nend FT1536.Source3.'+name+'\n'
    write(ROOT/'formal/Source3'/(name+'.lean'),text);all_modules.append(name)
plan={'status':'GENERATED_KERNEL_CHECK_TARGETS; NOT_ACCEPTED_UNTIL_LEAN','width':256,'blocks_per_vector':6,
      'source_manifest':{'path':str(MANIFEST),'sha256':hashlib.sha256(MANIFEST.read_bytes()).hexdigest()},
      'modules':all_modules,'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}}
write(ROOT/'.build/fftcells153/INPUT_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'modules':len(all_modules),'width':256,'blocks_per_vector':6}))
