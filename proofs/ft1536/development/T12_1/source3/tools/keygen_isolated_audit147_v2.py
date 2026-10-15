#!/usr/bin/env python3
"""Exact unchanged kernel/DAG checks with complete declaration partitions."""
from pathlib import Path
import hashlib,json,re
import keygen_whole088_audit as standard
ROOT=Path(__file__).resolve().parents[1]
BUILD=ROOT/'.build/fftinputs147'
TEMPLATE=ROOT/'formal/Source3/KeygenKernel129AuditProbe2.lean'
TEMPLATE_SHA='2af3cf64cc107cfe747f249a46a836edbf15b5ef7df73bf7476da35a2fa56daa'
assert hashlib.sha256(TEMPLATE.read_bytes()).hexdigest()==TEMPLATE_SHA
modules=json.loads((BUILD/'AUDIT_MODULES.json').read_text())
assert len(modules)==len(set(modules))
source=re.sub(r'\A(?:import [^\n]+\n)+','',TEMPLATE.read_text())
head,command=source.split('run_cmd Lean.Elab.Command.liftTermElabM do',1)
command='run_cmd Lean.Elab.Command.liftTermElabM do'+command
parts=[];seen=[]
for module in modules:
    all_names=standard.declarations([module])
    assert all_names
    chunks=[[n] for n in all_names] if module=='FftTripleCubic147' else [all_names]
    for names in chunks:
        assert not set(seen).intersection(names);seen.extend(names)
        index=len(parts)
        part=re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
          lambda m:m[1]+'\n'+',\n'.join('    ``'+n for n in names)+m[2],command,flags=re.S)
        stem=f'AUDIT147_V2_PART_{index:03d}'
        part=part.replace('../SEARCH_AUDIT_ENTRIES.jsonl','../'+stem+'_ENTRIES.jsonl')
        part=part.replace('../SEARCH_AUDIT_PROGRESS.json','../'+stem+'_PROGRESS.json')
        part=part.replace('../SEARCH_AUDIT.json','../'+stem+'.json')
        audit=f'KeygenKernel147AuditV2Part{index:03d}'
        target=ROOT/'formal/Source3'/(audit+'.lean')
        text='import Lean.AddDecl\nimport Source3.'+module+'\n'+head+part
        if target.exists():assert target.read_text()==text
        else:target.write_text(text)
        parts.append({'module':module,'audit_module':audit,'output':stem+'.json',
          'entries':stem+'_ENTRIES.jsonl','names':names,'source':str(target),
          'source_sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
assert seen==standard.declarations(modules)
plan={'method':'unchanged full DAG roundtrip and fresh safe kernel definition at original type; one module per process except cubic split per declaration; unchanged proof/audit options and limits; exact complete-name coverage',
 'template':{'path':str(TEMPLATE),'sha256':TEMPLATE_SHA},'parts':parts,'declarations':len(seen),
 'mathematical_modules':modules,'split_modules':{'FftTripleCubic147':'one declaration per process to bound cumulative run_cmd cost'}}
path=BUILD/'ISOLATED_AUDIT_PLAN_V2.json';encoded=json.dumps(plan,indent=2)+'\n'
if path.exists():assert path.read_text()==encoded
else:path.write_text(encoded)
print(json.dumps({'modules':len(modules),'declarations':len(seen),'processes':len(parts)}))
