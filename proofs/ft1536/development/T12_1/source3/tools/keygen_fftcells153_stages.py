#!/usr/bin/env python3
"""Generate grouped kernel checks for every literal FFT pass boundary."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parents[1]
TARGETS=ROOT/'.build/fftcells153/STAGE_TARGETS.json'
assert hashlib.sha256(TARGETS.read_bytes()).hexdigest()=='4e2afa5c178b4f855fc4702b42ecdbea185536f95f6f45a64bfcf3724cc8f3aa'
rows=json.loads(TARGETS.read_text());assert len(rows)==19
def write(path,text):
    if path.exists():assert path.read_text()==text,path
    else:path.write_text(text)
options='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\n'
modules=[];legacy=[];stages=[]
for row in rows:
    sid=row['id'];width=256 if sid in ['F0','G0'] else 32 if sid.endswith('Triple') else 64
    blocks=1536//width;groups=[]
    expr=row['expression'].replace('FftCertificateLink153.middle','FftLiteralCertificate153.middle').replace('FftCertificateLink153.tripling','FftLiteralCertificate153.tripling')
    probe='GeneratedFftTreeGroup153'+sid+'W'+str(width)+'Probe' if sid in ['F0','G0','GMiddle7','GTriple'] else None
    if probe:
        text='import Source3.FiniteWordVector153\nimport Source3.FftCertificateLink153\nimport Source3.'+row['input']+'\nimport Source3.'+row['output']+'\n'+options
        text+='namespace FT1536.Source3.'+probe+'\n\n'
        for k in range(4):text+=f"theorem checked{k} : FiniteWordVector153.checkChunk ({row['expression']}) {row['output']}.word ({width}*{k}) {width}=true := by decide +kernel\n\n"
        text+='end FT1536.Source3.'+probe+'\n'
        write(ROOT/'formal/Source3'/(probe+'.lean'),text);legacy.append(probe)
    for group in range((blocks+3)//4):
        name=f'GeneratedFftTreeStage153{sid}W{width}Group{group:03d}'
        text='import Source3.FiniteWordVector153\nimport Source3.FftLiteralCertificate153\nimport Source3.'+row['input']+'\nimport Source3.'+row['output']+'\n'
        reuse=probe is not None and group==0
        if reuse:text+='import Source3.'+probe+'\n'
        text+=options+'namespace FT1536.Source3.'+name+'\n\n'
        for k in range(4*group,min(blocks,4*group+4)):
            text+=f"theorem checked{k} : FiniteWordVector153.checkChunk ({expr}) {row['output']}.word ({width}*{k}) {width}=true := "
            if reuse and sid in ['F0','G0']:text+=probe+f'.checked{k}\n\n'
            elif reuse:
                lemma='tripling_source' if sid.endswith('Triple') else 'middle_source'
                text+='by\n  rw [FftLiteralCertificate153.'+lemma+']\n  exact '+probe+f'.checked{k}\n\n'
            else:text+='by decide +kernel\n\n'
        text+='end FT1536.Source3.'+name+'\n'
        write(ROOT/'formal/Source3'/(name+'.lean'),text);groups.append(name);modules.append(name)
    name='GeneratedFftTreeStage153'+sid
    text=''.join('import Source3.'+g+'\n' for g in groups)+options
    text+='namespace FT1536.Source3.'+name+'\n\n'
    text+=f"theorem source : ({expr})={row['output']}.word := by\n"
    text+=f"  apply FiniteWordVector153.complete ({expr}) {row['output']}.word {width} {blocks} (by decide) (by decide)\n"
    text+='  intro block\n  fin_cases block\n'
    for k in range(blocks):text+='  · exact '+groups[k//4]+f'.checked{k}\n'
    text+='\nend FT1536.Source3.'+name+'\n'
    write(ROOT/'formal/Source3'/(name+'.lean'),text);modules.append(name)
    stages.append({**row,'literal_expression':expr,'width':width,'blocks':blocks,'groups':groups,'module':name,'legacy_probe':probe})
plan={'status':'GENERATED_KERNEL_TARGETS; NOT_ACCEPTED_UNTIL_CHECKED','modules':modules,'legacy_probes':legacy,'stages':stages,
      'targets':{'path':str(TARGETS),'sha256':hashlib.sha256(TARGETS.read_bytes()).hexdigest()},
      'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()},'limits_unchanged':True}
write(ROOT/'.build/fftcells153/STAGE_PLAN.json',json.dumps(plan,indent=2)+'\n')
print(json.dumps({'stages':len(stages),'modules':len(modules),'finite_checks':sum(s['blocks'] for s in stages),'reused_probe_modules':len(legacy)}))
