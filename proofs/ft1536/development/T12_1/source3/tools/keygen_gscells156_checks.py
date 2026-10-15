#!/usr/bin/env python3
"""Generate complete bounded GS certificates with exact coverage and accepted probe reuse."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/gscells156'
manifest=ROOT/'.build/jobs/keygen_gscells156_001/GSDATA156_MANIFEST.json'
assert hashlib.sha256(manifest.read_bytes()).hexdigest()=='256e7c395e8c21a3ddf399ca22f301e0e38d1fbe3727684462eb050f50f18d22'
data=[r['module'] for r in json.loads(manifest.read_text())['modules']]
job=ROOT/'.build/jobs/keygen_gscells156_004'
receipts=json.loads((job/'RECEIPTS.json').read_text())
for r in receipts:
    assert r['accepted'] and r['clean_log'] and r['exit_code']==0 and not r['forbidden_proof_markers']
    assert (job/r['stdout']).stat().st_size==(job/r['stderr']).stat().st_size==0
    assert hashlib.sha256((ROOT/'formal/Source3'/(r['name'][8:]+'.lean')).read_bytes()).hexdigest()==r['source_sha256']
probes={r['name'][8:] for r in receipts}
targets=[
 ('Denominator',768,64,'GsNumericTarget156.denominator','GeneratedGsData156Denominator.word','Denominator64'),
 ('Inverse',768,32,'GsNumericTarget156.inverse GeneratedGsData156Denominator.word','GeneratedGsData156Inverse.word','Inverse32'),
 ('ScaledF',1536,128,'SelectedGsScale155.fValues','GeneratedGsData156ScaledF.word','ScaledF128'),
 ('ScaledG',1536,128,'SelectedGsScale155.gValues','GeneratedGsData156ScaledG.word',None),
 ('FinalF',1536,128,'GsAutoCall155.image GeneratedGsData156Inverse.word GeneratedGsData156ScaledF.word','GeneratedGsData156FinalF.word','FinalF128'),
 ('FinalG',1536,128,'GsAutoCall155.image GeneratedGsData156Inverse.word GeneratedGsData156ScaledG.word','GeneratedGsData156FinalG.word',None),
 ('Norm',1536,64,'NormTrace153.stepImage GeneratedGsData156FinalF.word GeneratedGsData156FinalG.word GeneratedGsData156Norm.point',
  'NormTrace153.nextImage (n:=1536) GeneratedGsData156Norm.point','Norm64')]
def write(p,t):
    if p.exists():assert p.read_text()==t,p
    else:p.write_text(t)
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
modules=[];stages=[];used=[]
for suffix,n,width,actual,expected,probe in targets:
    assert n%width==0 and (n//width)%4==0
    blocks=n//width;groups=[]
    probeName='GeneratedGsCheck156Probe'+probe if probe else None
    if probeName:assert probeName in probes;used.append(probeName)
    for group in range(blocks//4):
        name='GeneratedGsCheck156'+suffix+f'Group{group:03d}'
        t='import Source3.GsNumericTarget156\n'+''.join('import Source3.'+m+'\n' for m in data)
        if group==0 and probeName:t+='import Source3.'+probeName+'\n'
        t+=options+'namespace FT1536.Source3.'+name+'\n\n'
        for k in range(group*4,group*4+4):
            proof=probeName+'.checked' if k==0 and probeName else 'by decide +kernel'
            t+=f'theorem checked{k} : FiniteWordVector153.checkChunk ({actual}) ({expected}) ({width}*{k}) {width}=true := {proof}\n\n'
        t+='end FT1536.Source3.'+name+'\n';write(ROOT/'formal/Source3'/(name+'.lean'),t);modules.append(name);groups.append(name)
    name='GeneratedGsCheck156'+suffix
    t=''.join('import Source3.'+g+'\n' for g in groups)+options+'namespace FT1536.Source3.'+name+'\n\n'
    t+=f'theorem source : ({actual})=({expected}) := by\n'
    t+=f'  apply FiniteWordVector153.complete ({actual}) ({expected}) {width} {blocks} (by decide) (by decide)\n'
    t+='  intro block\n  fin_cases block\n'
    for k in range(blocks):t+='  · exact '+groups[k//4]+f'.checked{k}\n'
    t+='\nend FT1536.Source3.'+name+'\n';write(ROOT/'formal/Source3'/(name+'.lean'),t);modules.append(name)
    stages.append({'id':suffix,'length':n,'width':width,'blocks':blocks,'groups':groups,'module':name,'probe':probeName})
plan={'status':'GENERATED_KERNEL_CHECK_TARGETS; ACCEPTED_ONLY_BY_LEAN','modules':modules,'stages':stages,'reused_probes':used,
 'data_modules':data,'manifest':{'path':str(manifest),'sha256':hashlib.sha256(manifest.read_bytes()).hexdigest()},
 'probe_receipts':{'path':str(job/'RECEIPTS.json'),'sha256':hashlib.sha256((job/'RECEIPTS.json').read_bytes()).hexdigest()},
 'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}}
write(BUILD/'CHECK_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'modules':len(modules),'checks':sum(x['blocks'] for x in stages),'reused_probes':len(used)}))
