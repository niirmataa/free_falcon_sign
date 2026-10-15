#!/usr/bin/env python3
"""Exact kernel/DAG audits, one source module per isolated Lean process."""
from pathlib import Path
import hashlib,json,re
import keygen_whole088_audit as standard
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/resultant130'
TEMPLATE=ROOT/'formal/Source3/KeygenKernel129AuditProbe2.lean'
TEMPLATE_SHA='2af3cf64cc107cfe747f249a46a836edbf15b5ef7df73bf7476da35a2fa56daa'
assert hashlib.sha256(TEMPLATE.read_bytes()).hexdigest()==TEMPLATE_SHA
modules=json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert len(modules)==len(set(modules))
source=re.sub(r'\A(?:import [^\n]+\n)+','',TEMPLATE.read_text())
head,command=source.split('run_cmd Lean.Elab.Command.liftTermElabM do',1)
command='run_cmd Lean.Elab.Command.liftTermElabM do'+command
parts=[];seen=set()
for index,module in enumerate(modules):
    names=standard.declarations([module])
    assert names and not seen.intersection(names)
    seen.update(names)
    part=re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
      lambda m:m[1]+'\n'+',\n'.join('    ``'+n for n in names)+m[2],command,flags=re.S)
    stem=f'AUDIT130_PART_{index:03d}'
    part=part.replace('../SEARCH_AUDIT_ENTRIES.jsonl','../'+stem+'_ENTRIES.jsonl')
    part=part.replace('../SEARCH_AUDIT_PROGRESS.json','../'+stem+'_PROGRESS.json')
    part=part.replace('../SEARCH_AUDIT.json','../'+stem+'.json')
    audit=f'KeygenKernel130AuditPart{index:03d}'
    target=ROOT/'formal/Source3'/(audit+'.lean')
    text='import Lean.AddDecl\nimport Source3.'+module+'\n'+head+part
    if target.exists():assert target.read_text()==text
    else:target.write_text(text)
    parts.append({'module':module,'audit_module':audit,'output':stem+'.json',
      'entries':stem+'_ENTRIES.jsonl','names':names,'source':str(target),
      'source_sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
plan={'method':'one module per Lean process; full DAG term roundtrip plus kernel safe-definition check at original declared type; unchanged options/limits',
 'template':{'path':str(TEMPLATE),'sha256':TEMPLATE_SHA},'parts':parts,'declarations':len(seen)}
path=BUILD/'ISOLATED_AUDIT_PLAN.json';encoded=json.dumps(plan,indent=2)+'\n'
if path.exists():assert path.read_text()==encoded
else:path.write_text(encoded)
print(json.dumps({'modules':len(modules),'declarations':len(seen),'processes':len(parts)}))
