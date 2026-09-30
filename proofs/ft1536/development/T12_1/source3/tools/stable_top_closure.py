#!/usr/bin/env python3
"""STABLE_TOP_001 audit/closure organizer. No mathematical computation."""
import importlib.util
import json
from pathlib import Path
import re
import sys

ROOT=Path(__file__).resolve().parent.parent
spec=importlib.util.spec_from_file_location('source3_runner',ROOT/'tools/job.py')
runner=importlib.util.module_from_spec(spec)
spec.loader.exec_module(runner)
sha=runner.sha
ROOTS=['Source3.StableTop001Outcome','Source3.StableTop001Audit']
AUDIT='Source3.StableTop001Exports'

def source(module):
    return ROOT/'formal'/(module.replace('.','/')+'.lean')

def modules():
    _,_,seeds=runner.pinned()
    seen,order=set(),[]
    def visit(m):
        if m in seen or m in seeds or not m.startswith('Source3.'):
            return
        seen.add(m)
        for d in re.findall(r'^import\s+(\S+)',source(m).read_text(),re.M): visit(d)
        order.append(m)
    for m in ROOTS: visit(m)
    return order

def exports():
    lines=['import '+m for m in ROOTS]+['set_option maxRecDepth 32768','set_option maxHeartbeats 2000000','set_option pp.proofs true','']
    count=0
    for m in modules():
        text=source(m).read_text()
        ns=re.findall(r'^namespace\s+(\S+)',text,re.M)
        assert len(ns)==1,m
        for name in re.findall(r'^theorem\s+(\w+)',text,re.M):
            full=ns[0]+'.'+name
            lines.extend(['#check @'+full,'#print '+full,'#print axioms '+full]); count+=1
    out=source(AUDIT)
    assert not out.exists(), 'preserve previous audit source'
    out.write_text('\n'.join(lines)+'\n')
    print(json.dumps({'modules':len(modules())+1,'theorems':count,'audit_sha256':sha(out)}))

def record(label):
    base,config,seeds=runner.pinned()
    assert sha(runner.OLD/'PARENT_CACHE_BINDINGS.json')==base['parent_cache_bindings_sha256']
    for name,pin in base['source_pins'].items(): assert sha(runner.OLD/'inputs/source'/name)==pin,name
    ms=modules()+[AUDIT]
    job=ROOT/'.build/jobs'/label; rp=job/'RECEIPTS.json'; receipts=json.loads(rp.read_text())
    assert [r['name'] for r in receipts]==[m.replace('.','_') for m in ms]
    records=[]
    for m,r in zip(ms,receipts):
        assert r['accepted'] and r['clean_log'] and r['exit_code']==0 and not r['forbidden_proof_markers'],m
        assert r['cumulative_child_maxrss_kib']<=8*1024*1024,m
        p=source(m); op=job/'lib'/(m.replace('.','/')+'.olean')
        assert sha(p)==r['source_sha256'] and sha(op)==r['olean_sha256'],m
        assert sha(job/r['stdout'])==r['stdout_sha256'] and sha(job/r['stderr'])==r['stderr_sha256'],m
        records.append({'module':m,'source':str(p.relative_to(ROOT)),'source_sha256':sha(p),
            'artifact':str(op.relative_to(ROOT)),'artifact_sha256':sha(op),
            'receipt':str(rp.relative_to(ROOT)),'receipt_sha256':sha(rp),
            'stdout':str((job/r['stdout']).relative_to(ROOT)),'stdout_sha256':r['stdout_sha256'],
            'stderr_sha256':r['stderr_sha256']})
    text=(job/receipts[-1]['stdout']).read_text()
    ax=re.findall(r'depends on axioms:\s*\[([^]]*)\]',text)
    for group in ax: assert set(a.strip() for a in group.split(',') if a.strip())<={'propext','Classical.choice','Quot.sound'},group
    count=len(ax)+text.count('does not depend on any axioms')
    assert count==len(re.findall(r'^#print axioms ',source(AUDIT).read_text(),re.M))
    seen,deps,boundary=set(),[],set()
    def visit(m):
        if m in seen: return
        seen.add(m)
        if m in ms: p=source(m)
        elif m in seeds:
            e=seeds[m]; p=Path(e['source'])
            assert sha(p)==e['source_sha256'] and sha(Path(e['artifact']))==e['artifact_sha256'],m
            deps.append({'module':m,**e})
        else: boundary.add(m); return
        for d in re.findall(r'^import\s+(\S+)',p.read_text(),re.M): visit(d)
    for m in ROOTS: visit(m)
    sage=[]
    for name,label,result in [('check_stable_top_inputs.sage','stable_top_inputs_sage_001','FPR_OF_3_CROSSCHECK.json'),
                              ('check_stable_top_mutations.sage','stable_top_c_mutations_002','STABLE_TOP_MUTATIONS.json')]:
        d=ROOT/'.build/jobs'/label; rec=json.loads((d/'RECEIPTS.json').read_text())[0]
        assert rec['accepted'] and rec['clean_log'] and rec['exit_code']==0
        assert sha(ROOT/'sage'/name)==rec['source_sha256']
        assert sha(d/rec['stdout'])==rec['stdout_sha256'] and sha(d/rec['stderr'])==rec['stderr_sha256']
        sage.append({'source':'sage/'+name,'source_sha256':rec['source_sha256'],
            'receipt':str((d/'RECEIPTS.json').relative_to(ROOT)),'receipt_sha256':sha(d/'RECEIPTS.json'),
            'result':str((d/result).relative_to(ROOT)),'result_sha256':sha(d/result)})
    out={'task':'T12.1/source3/STABLE_TOP_001','status':'PROVED_KERNEL_SCOPED / NOT_REVIEWED',
        'model':'openai/gpt-6-astra','session':runner.SESSION,'modules':records,'theorems_audited':count,
        'dependency_closure004_sha256':runner.CLOSURE_SHA,'dependency_report004_sha256':runner.REPORT_SHA,
        'source_pins':base['source_pins'],'pinned_dependencies':deps,'library_boundary':sorted(boundary),
        'library_roots':config['library_roots'],'sage':sage,'fresh_job':str(job.relative_to(ROOT)),
        'elapsed_s':round(sum(r['elapsed_s'] for r in receipts),3),
        'maxrss_kib':max(r['cumulative_child_maxrss_kib'] for r in receipts),
        'runner_sha256':sha(ROOT/'tools/job.py'),'engine_sha256':sha(job/'EXECUTION_SOURCE.py'),
        'source_inputs_sha256':sha(job/'SOURCE_INPUTS.json'),'organizer_sha256':sha(Path(__file__)),
        'ast_emitter_sha256':sha(source('Source3.EmitScaledAST')),
        'ast_transport_sha256':sha(ROOT/'tools/capture_scaled_ast.py'),
        'ast_emitter_receipt_sha256':sha(ROOT/'.build/jobs/stable_top_emit_scaled_001/RECEIPTS.json'),
        'runtime_note':'Ignored persistent .build; recreate with pinned sources, tools/job.py and the recorded module order. Old W and immutable dependency products remain preserved.'}
    p=ROOT/'notes/run/STABLE_TOP_001_CLOSURE.json'
    assert not p.exists(), 'preserve previous closure'
    p.write_text(json.dumps(out,sort_keys=True,indent=2)+'\n')
    print(json.dumps({'closure_sha256':sha(p),'modules':len(ms),'theorems':count,'dependencies':len(deps),
        'elapsed_s':out['elapsed_s'],'maxrss_kib':out['maxrss_kib']}))

if __name__=='__main__':
    if sys.argv[1]=='exports': exports()
    elif sys.argv[1]=='modules': print(' '.join(modules()+[AUDIT]))
    elif sys.argv[1]=='record': record(sys.argv[2])
    else: raise ValueError('exports/modules/record required')
