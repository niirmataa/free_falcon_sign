#!/usr/bin/env python3
"""Hash/import/audit organizer for CERTIFICATE_SUFFIX_001; no mathematics."""
import importlib.util
import json
from pathlib import Path
import re
import sys

ROOT=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('source3_runner',ROOT/'tools/job.py')
runner=importlib.util.module_from_spec(spec); spec.loader.exec_module(runner)
sha=runner.sha
ROOTS=['Source3.CertificateSuffix001Outcome','Source3.CertificateSuffix001Audit']
AUDIT='Source3.CertificateSuffix001Exports'

def source(m): return ROOT/'formal'/(m.replace('.','/')+'.lean')
def seeds():
    base,cfg,entries=runner.pinned()
    entries.update(runner.suffix_dependencies())
    return base,cfg,entries
def modules():
    _,_,old=seeds(); seen=set(); order=[]
    def visit(m):
        if m in seen or m in old or not m.startswith('Source3.'): return
        seen.add(m)
        for d in re.findall(r'^import\s+(\S+)',source(m).read_text(),re.M): visit(d)
        order.append(m)
    for m in ROOTS: visit(m)
    return order
def exports():
    lines=['import '+m for m in ROOTS]+['set_option maxRecDepth 32768','set_option maxHeartbeats 2000000','set_option pp.proofs true','']
    count=0
    for m in modules():
        text=source(m).read_text(); ns=re.findall(r'^namespace\s+(\S+)',text,re.M)
        assert len(ns)==1,m
        for name in re.findall(r'^theorem\s+(\w+)',text,re.M):
            full=ns[0]+'.'+name; count+=1
            lines.extend(['#check @'+full,'#print '+full,'#print axioms '+full])
    p=source(AUDIT); assert not p.exists()
    p.write_text('\n'.join(lines)+'\n')
    print(json.dumps({'modules':len(modules())+1,'theorems':count,'audit_sha256':sha(p)}))
def record(label):
    base,cfg,old=seeds(); ms=modules()+[AUDIT]
    job=ROOT/'.build/jobs'/label; rp=job/'RECEIPTS.json'; receipts=json.loads(rp.read_text())
    assert [r['name'] for r in receipts]==[m.replace('.','_') for m in ms]
    rows=[]
    for m,r in zip(ms,receipts):
        assert r['accepted'] and r['clean_log'] and r['exit_code']==0 and not r['forbidden_proof_markers'],m
        assert r['cumulative_child_maxrss_kib']<=8*1024*1024,m
        p=source(m); op=job/'lib'/(m.replace('.','/')+'.olean')
        assert sha(p)==r['source_sha256'] and sha(op)==r['olean_sha256'],m
        assert sha(job/r['stdout'])==r['stdout_sha256'] and sha(job/r['stderr'])==r['stderr_sha256'],m
        rows.append({'module':m,'source':str(p.relative_to(ROOT)),'source_sha256':sha(p),
            'artifact':str(op.relative_to(ROOT)),'artifact_sha256':sha(op),
            'receipt':str(rp.relative_to(ROOT)),'receipt_sha256':sha(rp),
            'stdout':str((job/r['stdout']).relative_to(ROOT)),'stdout_sha256':r['stdout_sha256'],'stderr_sha256':r['stderr_sha256']})
    text=(job/receipts[-1]['stdout']).read_text(); groups=re.findall(r'depends on axioms:\s*\[([^]]*)\]',text)
    for g in groups: assert {a.strip() for a in g.split(',') if a.strip()}<={'propext','Classical.choice','Quot.sound'},g
    count=len(groups)+text.count('does not depend on any axioms')
    assert count==len(re.findall(r'^#print axioms ',source(AUDIT).read_text(),re.M))
    seen=set(); deps=[]; boundary=set()
    def visit(m):
        if m in seen: return
        seen.add(m)
        if m in ms: p=source(m)
        elif m in old:
            e=old[m]; p=Path(e['source'])
            assert sha(p)==e['source_sha256'] and sha(Path(e['artifact']))==e['artifact_sha256'],m
            deps.append({'module':m,**e})
        else: boundary.add(m); return
        for d in re.findall(r'^import\s+(\S+)',p.read_text(),re.M): visit(d)
    for m in ROOTS: visit(m)
    for name,pin in base['source_pins'].items(): assert sha(runner.OLD/'inputs/source'/name)==pin
    sage=[]
    for filename,label,result in [('check_certificate_q.sage','certificate_q_sage_001','CERTIFICATE_Q_CHECK.json'),
                                  ('check_certificate_suffix_mutations.sage','certificate_c_mutations_002','CERTIFICATE_SUFFIX_MUTATIONS.json')]:
        d=ROOT/'.build/jobs'/label; rec=json.loads((d/'RECEIPTS.json').read_text())[0]
        assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
        assert sha(ROOT/'sage'/filename)==rec['source_sha256']
        assert sha(d/rec['stdout'])==rec['stdout_sha256'] and sha(d/rec['stderr'])==rec['stderr_sha256']
        sage.append({'source':'sage/'+filename,'source_sha256':rec['source_sha256'],
            'receipt':str((d/'RECEIPTS.json').relative_to(ROOT)),'receipt_sha256':sha(d/'RECEIPTS.json'),
            'result':str((d/result).relative_to(ROOT)),'result_sha256':sha(d/result)})
    out={'task':'T12.1/source3/CERTIFICATE_SUFFIX_001','status':'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'session':runner.SESSION,'model':'openai/gpt-6-astra','scope':'source suffix7757-7776 at return edge; n1536/hn768; not whole function/prefix/KeyGen',
        'modules':rows,'theorems_audited':count,'pinned_dependencies':deps,'library_boundary':sorted(boundary),'library_roots':cfg['library_roots'],
        'source_pins':base['source_pins'],'binary004_report_sha256':runner.REPORT_SHA,'binary004_closure_sha256':runner.CLOSURE_SHA,
        'top001_report_sha256':runner.TOP_REPORT_SHA,'top001_closure_sha256':runner.TOP_CLOSURE_SHA,
        'fresh_job':str(job.relative_to(ROOT)),'runner_sha256':sha(ROOT/'tools/job.py'),'organizer_sha256':sha(Path(__file__)),
        'engine_sha256':sha(job/'EXECUTION_SOURCE.py'),'source_inputs_sha256':sha(job/'SOURCE_INPUTS.json'),
        'elapsed_s':round(sum(r['elapsed_s'] for r in receipts),3),'maxrss_kib':max(r['cumulative_child_maxrss_kib'] for r in receipts),
        'sage':sage,'runtime_note':'Persistent ignored .build; job.py and recorded sources/modules recreate products. Failed attempts retained.'}
    target=ROOT/'notes/run/CERTIFICATE_SUFFIX_001_CLOSURE.json'; assert not target.exists()
    target.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({'closure_sha256':sha(target),'modules':len(ms),'theorems':count,'dependencies':len(deps),
        'elapsed_s':out['elapsed_s'],'maxrss_kib':out['maxrss_kib']}))
if __name__=='__main__':
    if sys.argv[1]=='exports': exports()
    elif sys.argv[1]=='modules': print(' '.join(modules()+[AUDIT]))
    elif sys.argv[1]=='record': record(sys.argv[2])
    else: raise ValueError('exports/modules/record required')
