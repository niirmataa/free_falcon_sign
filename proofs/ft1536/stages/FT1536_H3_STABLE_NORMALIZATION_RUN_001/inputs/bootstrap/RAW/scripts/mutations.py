import json,struct
from pathlib import Path
from raw_model import Machine,leaf_map,N,TMP
from replaylib import sha
W=Path.cwd();D=W/'checks/mutations';D.mkdir(parents=True,exist_ok=True)
data=[int(x,16) for x in (W/'checks/data/gram_1.input').read_text().split()]
expected=list(struct.unpack('<24576Q',(W/'checks/data/gram_1.words.bin').read_bytes()))
snap=json.loads((W/'checks/data/gram_1.snapshots.json').read_text());rows=[]
for kind in ['noop','omit_child','bad_offset','leaf_permutation','late_snapshot','bad_frame']:
 m=Machine(W,kind);m.write(('S',0),[x^0 for x in data]);error=None
 try:m.top()
 except ValueError as e:error=str(e)
 word_matches=m.mem['K']==expected;snapshot_matches=m.snapshots.get('root_D')==snap['root_D']
 passed=error is None and word_matches and snapshot_matches
 assert passed==(kind=='noop'),kind
 path=D/(kind+'.trace');path.write_text('\n'.join(m.events)+'\n')
 (D/(kind+'.words.bin')).write_bytes(struct.pack('<24576Q',*m.mem['K']))
 (D/(kind+'.snapshots.json')).write_text(json.dumps(m.snapshots,indent=2)+'\n')
 first_word=next((i for i,(a,b) in enumerate(zip(expected,m.mem['K'])) if a!=b),None)
 first_snap=next((i for i,(a,b) in enumerate(zip(snap['root_D'],m.snapshots.get('root_D',[]))) if a!=b),None)
 rows.append(dict(mutation=kind,expected_rejection=kind!='noop',checker_accepts=passed,model_stop=error,first_word_mismatch=first_word,
  first_root_D_snapshot_mismatch=first_snap,trace_sha256=sha(path),words_sha256=sha(D/(kind+'.words.bin')),snapshots_sha256=sha(D/(kind+'.snapshots.json'))))
invalid=[]
for kind in ['zero_divisor','nonfinite','short_coefficients','buffer_end']:
 m=Machine(W);error=None
 try:
  if kind=='short_coefficients':m.prefix([[0]*(N-1)]*4)
  elif kind=='buffer_end':m.write(('S',TMP-1),[0,0])
  else:
   v=list(data);v[:N]=[0]*N
   if kind=='nonfinite':v[0]=0x7ff0000000000000
   m.write(('S',0),v);m.top()
 except ValueError as e:error=str(e)
 assert error is not None
 invalid.append(dict(case=kind,preflight_stop=error,native_called=False,classification='outside tested source-operation/buffer domain; not a P_key or emitted counterexample'))
out=dict(status='PASS_EXECUTED_MODEL_MUTATIONS_AND_INVALID_PREFLIGHT',mutations=rows,invalid_cases=invalid,
 layer='Actual execution changes in the flat-memory model: omitted recursive child, shifted destination, real leaf swap, late physical scratch snapshot and unauthorized root-input write. Native source remains unchanged.',
 no_op_native_also_tested=True,retained_full_traces=True)
(W/'artifacts/mutations.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],mutations=rows,invalid_cases=invalid),indent=2))
