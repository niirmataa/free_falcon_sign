# Exact unit/cost-model counterexample for the not-yet-run aggregation script.
assert parent(1) is ZZ and parent(1/3) is QQ and 2^10 == 1024
import json,os,subprocess,hashlib
from pathlib import Path
W=Path(os.environ['FT_REVIEW_W']);O=Path(os.environ['FT_REVIEW_OUTPUT'])
P=O/'fixture';(P/'scripts').mkdir(parents=True);(P/'artifacts').mkdir()
original=W/'inputs/campaign/scripts/aggregate.py'
runner=P/'scripts/aggregate.py';runner.write_bytes(original.read_bytes())
rows=[{'scheme':'TOY','cost_model':'classical','shape_model':'GSA','status':'OK',
       'attacks':{'usvp':{'rop':int(1024),'beta':int(100)}}},
      {'scheme':'TOY','cost_model':'quantum','shape_model':'GSA','status':'OK',
       'attacks':{'usvp':{'rop':int(8),'beta':int(100)}}}]
(P/'artifacts/ntru_grid.ndjson').write_text('\n'.join(json.dumps(r) for r in rows)+'\n')
argv=['/usr/bin/python3','-B',str(runner)]
r=subprocess.run(argv,cwd=P,capture_output=True,timeout=30)
(O/'aggregate.stdout').write_bytes(r.stdout);(O/'aggregate.stderr').write_bytes(r.stderr)
assert r.returncode==0
summary=json.loads((P/'artifacts/comparative_summary.json').read_text())
chosen=summary['ntru_minima_per_attack']['TOY|usvp']
assert chosen['cost_model']=='quantum' and chosen['rop']==8
import csv
table=list(csv.DictReader((P/'artifacts/comparative.csv').open()))
entry=next(x for x in table if x['source']=='ntru_grid_min')
assert entry['point']=='log2_rop' and ZZ(entry['value'])==8
exact_log=log(ZZ(8),2);assert exact_log==3
out={'mode':'sage aggregation_audit.sage','program_argv':argv,'program_exit':r.returncode,
     'program_source_sha256':hashlib.sha256(original.read_bytes()).hexdigest(),
     'label':entry['point'],'exported_value':entry['value'],'correct_log2':str(exact_log),
     'unit_bug_demonstrated':True,'models_mixed_in_same_minimum':True,
     'selected_model':chosen['cost_model'],
     'scope':'synthetic software counterexample; original campaign aggregation was not yet run'}
(O/'aggregation_audit.json').write_text(json.dumps(out,indent=2,sort_keys=True)+'\n')
print(json.dumps(out,indent=2,sort_keys=True))
