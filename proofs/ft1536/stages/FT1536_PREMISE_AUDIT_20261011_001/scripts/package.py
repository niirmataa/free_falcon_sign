"""Freeze this report only. No Git, mainline edits, or status changes."""
from pathlib import Path
import json,hashlib,shutil,gzip,re,datetime,subprocess
W=Path(__file__).resolve().parents[1]
OUT=W/'output'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def put_json(p,obj):p.write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
def copy(rel):
    p=W/rel;q=OUT/rel;q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
def main():
    assert not (OUT/'OUTPUTS.sha256').exists(),'Do not overwrite a sealed package'
    final=['source3_probes_004','run2_probes_003','positive_controls_002','inventory_004',
           'run2_inventory_001','omega_full_sweep_002']
    for label in final:
        d=W/'attempts'/label;r=json.loads((d/'RECEIPT.json').read_text())
        assert r['exit_code']==0 and r['clean_log'],label
        for stream in ['stdout','stderr']:assert sha(d/(stream+'.log'))==r[stream+'_sha256']
        assert sha(W/r['source'])==r['source_sha256']
    omega=[json.loads(x) for x in (W/'OMEGA_RESULTS.jsonl').read_text().splitlines()]
    assert len(omega)==8899
    assert omega[-2]['result']=='INCONSISTENT_PREMISES' and omega[-1]['result']=='INCONCLUSIVE'
    assert all(r['result']=='INCONCLUSIVE' for r in omega[:-2])
    graph=json.loads((W/'IMPORT_GRAPH.json').read_text());assert graph['excluded_reachable']==[]
    replay=json.loads((W/'fresh_replay_001/REPLAY_RESULT.json').read_text());assert len(replay['results'])==3
    for x in replay['results']:assert x['clean_log'] and x['exit_code']==0
    for folder in ['formal','scripts']:
        for p in sorted((W/folder).iterdir()):
            if p.is_file():copy(p.relative_to(W))
    for rel in ['REPORT.md','TASK.md','REPRODUCTION.md','ENTRY.json','CONFIG.json','INPUTS.json','SOURCE3_CLOSURE_INPUTS.json',
                'RUN2_INPUTS.json','ARTIFACT_INPUTS.json','LIBRARY_SNAPSHOT.json','DEPENDENCY_CHECK.json',
                'LIVE_DRIFT.json','IMPORT_GRAPH.json','COVERAGE.json','FILE_COVERAGE.json','FINDINGS.json',
                'UNUSED_PREMISES.json','PREMISE_MATRIX.tsv','WANTED.json','WANTED_RUN2.json','OMEGA_WANTED.json']:
        copy(rel)
    for name in ['SOURCE_INVENTORY.json','ELABORATED.jsonl','ELABORATED_RUN2.jsonl','PREMISE_MATRIX.json',
                 'BRANCH_MATRIX.json','EXPORT_PREMISES.json','DEFINITION_BRANCH_CANDIDATES.json','OMEGA_RESULTS.jsonl']:
        data=(W/name).read_bytes()
        (OUT/(name+'.gz')).write_bytes(gzip.compress(data,mtime=0))
    history=[]
    for d in sorted((W/'attempts').iterdir()):
        for p in sorted(d.iterdir()):
            if p.is_file() and p.suffix in ['.json','.lean','.log']:copy(p.relative_to(W))
            elif p.name.endswith('.jsonl'):
                q=OUT/p.relative_to(W);q.parent.mkdir(parents=True,exist_ok=True);q.with_suffix(q.suffix+'.gz').write_bytes(gzip.compress(p.read_bytes(),mtime=0))
        r=json.loads((d/'RECEIPT.json').read_text());history.append(r)
    # Reconstruct the exact early runner versions from this session's recorded edits;
    # validate against the already-recorded hashes, never invent a missing version.
    current=(W/'scripts/run_lean.py').read_text()
    v4=current.replace("'-j1','-M6144','-DElab.async=false'","'-j1','-DElab.async=false'").replace("    env['LEAN_NUM_THREADS']='1'\n",'').replace('(24*1024**3,24*1024**3)','(8*1024**3,8*1024**3)')
    v3=v4.replace("'-j1','-DElab.async=false'","'-j1'")
    v2=v3.replace("([env['AUDIT_LEAN_LIB']] if env.get('AUDIT_LEAN_LIB') else [])+",'')
    v1=v2.replace("str(LEAN),'-j1','-o'","str(LEAN),'-o'")
    versions={hashlib.sha256(v.encode()).hexdigest():v for v in [current,v4,v3,v2,v1]}
    assert {r['runner_sha256'] for r in history}<=versions.keys()
    for h,v in versions.items():
        p=OUT/'runner_versions'/(h+'.py');p.parent.mkdir(exist_ok=True);p.write_text(v);assert sha(p)==h
    for p in (W/'fresh_replay_001').rglob('*'):
        if p.is_file() and p.suffix in ['.json','.log','.lean','.py'] and not any(t in p.parts for t in ['lib','lib_run2','cache']):copy(p.relative_to(W))
    inputs={}
    for p in sorted((W/'snapshot').rglob('*')):
        if p.is_file():inputs[str(p)]=sha(p)
    manifest=''.join(h+'  '+p+'\n' for p,h in inputs.items())
    (OUT/'INPUTS.sha256').write_text(manifest)
    put_json(OUT/'INPUT_LAYOUT.json',[{'original':p,'relative':str(Path(p).relative_to(W)),'sha256':h} for p,h in inputs.items()])
    put_json(OUT/'ATTEMPTS.json',history)
    axes=[]
    for label in final[:3]:
        text=(W/'attempts'/label/'stdout.log').read_text()
        for m in re.finditer(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",text,re.S):
            axs=[a.strip() for a in (m.group(2) or '').split(',') if a.strip()]
            assert set(axs)<={'propext','Classical.choice','Quot.sound'},(m.group(1),axs)
            axes.append({'name':m.group(1),'axioms':axs,'receipt':label})
    put_json(OUT/'AXIOM_CHECK.json',{'exports':axes,'count':len(axes),'allowed':['propext','Classical.choice','Quot.sound']})
    result={'status':'CONFIRMED_VACUITY_PARTIAL_AUDIT','primary_verdict':'incomplete, with the smallest missing implication',
            'source_head':json.loads((W/'ENTRY.json').read_text())['head'],'report_only':True,
            'feasibility_complete':False,'all_impossible_premises_found':False,'owner_accepted':False,
            'reviewed':False,'mainline_formal_edited':False,'project_statuses_edited':False,'push':False,
            'principal_findings':['F01','F02','F03','F04'],'conditional_findings':['F05','F06'],
            'next':'Repair F01-F04 in the owner-assigned window; discharge open SUSPECT witnesses before claiming exhaustive clearance.'}
    put_json(OUT/'RESULT.json',result)
    pair={'schema':'FT1536_PREMISE_AUDIT_PAIR_V1','utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'scope':result,'report':{'path':'REPORT.md','sha256':sha(OUT/'REPORT.md')},
          'inputs_manifest_sha256':sha(OUT/'INPUTS.sha256'),'input_files':len(inputs),
          'source_manifest_sha256':sha(OUT/'INPUTS.json'),'library_snapshot_sha256':sha(OUT/'LIBRARY_SNAPSHOT.json'),
          'coverage_sha256':sha(OUT/'COVERAGE.json'),'findings_sha256':sha(OUT/'FINDINGS.json'),
          'receipts':[{'path':'attempts/'+x+'/RECEIPT.json','sha256':sha(OUT/'attempts'/x/'RECEIPT.json')} for x in final],
          'replay':{'path':'fresh_replay_001/REPLAY_RESULT.json','sha256':sha(OUT/'fresh_replay_001/REPLAY_RESULT.json')},
          'historical_runner_versions':'reconstructed byte-exactly from recorded edits and verified against original receipt hashes',
          'independent_second_reviewer':False,'pair_meaning':'report plus execution receipt; not a fabricated author/reviewer pair'}
    put_json(OUT/'AUDIT_PAIR.json',pair)
    entries=[p for p in sorted(OUT.rglob('*')) if p.is_file()]
    (OUT/'OUTPUTS.sha256').write_text(''.join(sha(p)+'  '+str(p.relative_to(OUT))+'\n' for p in entries))
    pins={'stage_id':'FT1536_PREMISE_AUDIT_20261011_001','report_sha256':sha(OUT/'REPORT.md'),
          'outputs_sha256':sha(OUT/'OUTPUTS.sha256'),'pair_sha256':sha(OUT/'AUDIT_PAIR.json'),
          'output_files':len(entries),'output_bytes':sum(p.stat().st_size for p in entries),'input_files':len(inputs)}
    put_json(W/'HANDOFF_PINS.json',pins)
    print(json.dumps(pins,indent=2))
if __name__=='__main__':main()
