#!/usr/bin/env python3
"""Restore pinned GS literal modules and generate bounded diagnostic certificates."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/gscells156'
MANIFEST=ROOT/'.build/jobs/keygen_gscells156_001/GSDATA156_MANIFEST.json'
assert hashlib.sha256(MANIFEST.read_bytes()).hexdigest()=='256e7c395e8c21a3ddf399ca22f301e0e38d1fbe3727684462eb050f50f18d22'
def write(path,text):
    if path.exists():assert path.read_text()==text,path
    else:path.write_text(text)
data=[]
for row in json.loads(MANIFEST.read_text())['modules']:
    source=Path(row['path']);assert hashlib.sha256(source.read_bytes()).hexdigest()==row['sha256']
    write(ROOT/'formal/Source3'/(row['module']+'.lean'),source.read_text());data.append(row['module'])
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
targets=[
 ('Inverse1','GsNumericTarget156.inverse GeneratedGsData156Denominator.word','GeneratedGsData156Inverse.word',1),
 ('Denominator64','GsNumericTarget156.denominator','GeneratedGsData156Denominator.word',64),
 ('ScaledF128','SelectedGsScale155.fValues','GeneratedGsData156ScaledF.word',128),
 ('FinalF128','GsAutoCall155.image GeneratedGsData156Inverse.word GeneratedGsData156ScaledF.word','GeneratedGsData156FinalF.word',128),
 ('Norm64','NormTrace153.stepImage GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word GeneratedGsData156Norm.point',
  'NormTrace153.nextImage (n:=1536) GeneratedGsData156Norm.point',64)]
probes=[]
for suffix,actual,expected,width in targets:
    name='GeneratedGsCheck156Probe'+suffix
    text='import Source3.GsNumericTarget156\n'+''.join('import Source3.'+d+'\n' for d in data)+options
    text+='namespace FT1536.Source3.'+name+'\n\n'
    text+=f'theorem checked : FiniteWordVector153.checkChunk ({actual}) ({expected}) 0 {width}=true := by decide +kernel\n\n'
    text+='end FT1536.Source3.'+name+'\n';write(ROOT/'formal/Source3'/(name+'.lean'),text);probes.append(name)
plan={'data_modules':data,'probe_modules':probes,'targets':targets,
 'manifest':{'path':str(MANIFEST),'sha256':hashlib.sha256(MANIFEST.read_bytes()).hexdigest()},
 'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}}
write(BUILD/'PREPARE_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'data_modules':len(data),'probes':len(probes)}))
