#!/usr/bin/env python3
"""Read-only BATCH_024 verification with external JSON/notes pins."""
from datetime import datetime, timezone
import json
from pathlib import Path
import sys

import job

def verify(batch_sha,notes_sha):
    checked={}
    def check(path,expected):
        path=job.ROOT/path
        actual=job.sha(path)
        assert actual==expected,(str(path),expected,actual)
        checked[str(path)]=actual
    def walk(value):
        if isinstance(value,dict):
            if 'path' in value and 'sha256' in value:
                check(value['path'],value['sha256'])
            for child in value.values(): walk(child)
        elif isinstance(value,list):
            for child in value: walk(child)
    base='notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_024'
    check(base+'.json',batch_sha);check(base+'_NOTES.md',notes_sha)
    batch=json.loads((job.ROOT/(base+'.json')).read_text())
    walk(batch)
    for path,expected in batch['input_pins'].items(): check(path,expected)
    preflight=json.loads((job.ROOT/batch['preflight']['path']).read_text())
    assert len(preflight['checked'])==2595
    for path,expected in preflight['checked'].items(): check(path,expected)
    inputs=json.loads((job.ROOT/batch['audit']['source_inputs']['path']).read_text())
    for entry in inputs['sources']: check(entry['path'],entry['sha256'])
    for entry in inputs['reused']:
        check(entry.get('current_source',entry['source']),entry['source_sha256'])
        check(entry['artifact'],entry['artifact_sha256'])
    count=len(inputs['sources'])+len(inputs['reused'])
    assert count==batch['current_final_audit_inputs']
    active=job.active();assert not active,active
    return {'utc':datetime.now(timezone.utc).isoformat(),'batch':'BATCH_024',
        'batch_sha256':batch_sha,'notes_sha256':notes_sha,'checked':checked,
        'distinct_pinned_files':len(checked),'current_source_inputs':count,'active_jobs':active,
        'verifier_sha256':job.sha(Path(__file__))}

if __name__=='__main__':
    assert len(sys.argv) in (3,4),'usage: keygen_levels_verify.py BATCH_SHA NOTES_SHA [new_receipt_path]'
    result=verify(sys.argv[1],sys.argv[2])
    if len(sys.argv)==4:
        target=(job.ROOT/sys.argv[3]).resolve()
        assert target.is_relative_to(job.BUILD.resolve())
        with target.open('x') as stream:
            json.dump(result,stream,indent=2);stream.write('\n')
        result['receipt_sha256']=job.sha(target)
    print(json.dumps({k:v for k,v in result.items() if k!='checked'},indent=2))
