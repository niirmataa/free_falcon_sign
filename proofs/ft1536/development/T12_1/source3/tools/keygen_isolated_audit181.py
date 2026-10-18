#!/usr/bin/env python3
"""Unchanged full checks, one declaration per command, one module per process."""
from pathlib import Path
import hashlib,json,re
import keygen_whole088_audit as standard
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/genfinish181'
TEMPLATE=ROOT/'formal/Source3/KeygenKernel129AuditProbe2.lean'
TEMPLATE_SHA='2af3cf64cc107cfe747f249a46a836edbf15b5ef7df73bf7476da35a2fa56daa'
assert hashlib.sha256(TEMPLATE.read_bytes()).hexdigest()==TEMPLATE_SHA
modules=json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert len(modules)==len(set(modules))
source=re.sub(r'\A(?:import [^\n]+\n)+','',TEMPLATE.read_text())
head,command=source.split('run_cmd Lean.Elab.Command.liftTermElabM do',1)
command='run_cmd Lean.Elab.Command.liftTermElabM do'+command
parts=[];seen=[]
for index,module in enumerate(modules):
    names=standard.declarations([module]);assert names
    assert not set(seen).intersection(names);seen.extend(names)
    commands=[];bodies=[]
    for subindex,name in enumerate(names):
        body=re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
            lambda m:m[1]+'\n    ``'+name+m[2],command,flags=re.S)
        stem=f'AUDIT181_V2_PART_{index:03d}_DECL_{subindex:03d}'
        body=body.replace('../SEARCH_AUDIT_ENTRIES.jsonl','../'+stem+'_ENTRIES.jsonl')
        body=body.replace('../SEARCH_AUDIT_PROGRESS.json','../'+stem+'_PROGRESS.json')
        body=body.replace('../SEARCH_AUDIT.json','../'+stem+'.json')
        bodies.append(body)
        commands.append({'name':name,'output':stem+'.json','entries':stem+'_ENTRIES.jsonl'})
    audit=f'KeygenKernel181AuditV2Part{index:03d}'
    target=ROOT/'formal/Source3'/(audit+'.lean')
    text='import Lean.AddDecl\nimport Lean.Elab.Command\nimport Source3.'+module+'\n'+head+'\n'.join(bodies)
    if target.exists():assert target.read_text()==text
    else:target.write_text(text)
    parts.append({'module':module,'audit_module':audit,'commands':commands,'names':names,
      'source':str(target),'source_sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
assert seen==standard.declarations(modules)
plan={'method':'unchanged full DAG roundtrip and fresh safe kernel definition at original type; one declaration per run_cmd; all commands of one mathematical module in one sequential Lean process; same template/options/limits',
 'template':{'path':str(TEMPLATE),'sha256':TEMPLATE_SHA},'parts':parts,'declarations':len(seen),
 'mathematical_modules':modules,'partition':'exact ordered coverage; separate command budget for every declaration; process shared only within one module'}
path=BUILD/'ISOLATED_AUDIT_V2_PLAN.json';encoded=json.dumps(plan,indent=2)+'\n'
if path.exists():assert path.read_text()==encoded
else:path.write_text(encoded)
print(json.dumps({'modules':len(modules),'declarations':len(seen),'processes':len(parts),'commands':len(seen)}))
