"""Independent V02 comparator: inspect actual producers, not controller PASS text."""
from datetime import datetime
import hashlib
import json
from pathlib import Path
import re

W = Path(__file__).resolve().parents[1]
O = W/'inputs/subject'
D = W/'run/v02_fresh_001'
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
load = lambda p: json.loads(p.read_text())
receipt = load(D/'receipt.json')
plan = load(O/'SEMANTIC_FILES.json')
modules = load(O/'formal/BUILD_PLAN.json')['modules']
assert receipt['exit_code'] == 0 and receipt['sources_unchanged'] is True
assert len(receipt['steps']) == 43 and len(modules) == 34 and len(plan['matches']) == 16
assert receipt['inputs_sha256'] == 'b0a57afa260c403a11901ef29676104729306c02ecd856b07170ec261ab76045'
assert receipt['source_before'] == receipt['source_after']
assert set(receipt['source_before']) == {p.relative_to(O/'formal').as_posix() for p in (O/'formal').rglob('*') if p.is_file()}
assert all(sha(O/'formal'/p) == h == sha(D/'source'/p) for p,h in receipt['source_before'].items())
assert receipt['network'] == 'unshare-net' and receipt['single_worker']

child = 0
for i, step in enumerate(receipt['steps']):
    assert step['exit_code'] == 0 and step['clean'] and not step['timed_out']
    assert step['cwd'].endswith('/v02_fresh_001/source')
    assert '--unshare-net' in step['argv'] and '--as=8589934592' in step['argv']
    for key in ('stdout','stderr'):
        p = D/step[key]
        assert sha(p) == step[key+'_sha256']
    assert (D/step['stderr']).stat().st_size == 0
    assert 'warning:' not in (D/step['stdout']).read_text(errors='replace')
    if 8 <= i <= 41:
        mod = modules[i-8]
        assert step['argv'][-1].endswith('/source/'+mod)
        assert (D/'build'/Path(mod).with_suffix('.olean')).is_file()
    if i in (5,6,7):
        archived = D/step['child_receipt_snapshot']
        entries = load(archived)
        assert len(entries) == step['child_commands_snapshotted']
        for entry in entries:
            name = entry['name']
            expected = (3 if name == 'no_producer_rejected' else
                        1 if name.endswith('_execute') and name not in ('normal_execute','ubsan_execute') else 0)
            assert entry['exit_code'] == expected, (i,name)
            for key in ('stdout','stderr'):
                assert sha(archived.parent/(entry['name']+'.'+key)) == entry[key+'_sha256']
            child += 1
assert child == 45
assert receipt['steps'][42]['argv'][-1].endswith('/source/AuditTermsFull.lean')

matches = []
for item in plan['matches']:
    rel = item['path']
    p = D/rel if rel.startswith('build/') else D/'logs'/rel
    actual = sha(p)
    assert actual == item['sha256'] == sha(O/item['baseline']), rel
    step_index = item['producer_step']
    # Generated files have the predeclared end-of-pipeline index 3, while
    # embed_source (step1) and embed_le (step2) produce some earlier.
    if rel in ('build/PinnedHeader.lean','build/PinnedSlices.lean'):
        step_index = 1
    elif rel in ('build/PinnedShake.lean','build/PinnedLittleEndian.lean'):
        step_index = 2
    step = receipt['steps'][step_index]
    assert step['exit_code'] == 0 and step['clean']
    assert step['start'] <= step['stop']
    executable_source = step['argv'][-2] if step_index in (5,6,7) else step['argv'][-1]
    assert executable_source.endswith('/'+(
        'embed_source.py' if step_index == 1 else
        'embed_le.py' if step_index == 2 else
        'embed_scalar.py' if step_index == 3 else
        'check_transport.py' if step_index == 4 else
        'AuditTermsFull.lean' if step_index == 42 else
        Path(modules[step_index-8]).name if step_index >= 8 else
        'controls.py' if step_index == 5 else
        'le_controls.py' if step_index == 6 else 'scalar_controls.py')), (rel,step_index,executable_source)
    # For log products, the actual producer is the recorded step itself.
    if not rel.startswith('build/'):
        assert p == D/step['stdout']
    matches.append({'path':rel,'sha256':actual,'actual_producer_step':step_index,
                    'predeclared_pipeline_step':item['producer_step']})

gate = load(D/'build/toolchain/PORTABLE_GATE.json')
assert gate['pass'] and len(gate['roots']) == 9
assert [x['name'] for x in gate['roots']].count('mathlib') == 1
controls = {x:load(D/'build'/x) for x in (
    'CONTROL_RESULT.json','LE_CONTROL_RESULT.json','SCALAR_CONTROL_RESULT.json')}
assert controls['CONTROL_RESULT.json']['pass'] and controls['CONTROL_RESULT.json']['valid_cases']==12288
assert controls['CONTROL_RESULT.json']['mutants_rejected']==4
assert controls['LE_CONTROL_RESULT.json']['pass'] and controls['LE_CONTROL_RESULT.json']['cases']==3072
assert controls['LE_CONTROL_RESULT.json']['mutations']==3
assert controls['SCALAR_CONTROL_RESULT.json']['pass'] and controls['SCALAR_CONTROL_RESULT.json']['in_cases']==19721
assert controls['SCALAR_CONTROL_RESULT.json']['obs_cases']==21352
assert controls['SCALAR_CONTROL_RESULT.json']['mutants_rejected']==5
full = (D/'logs/042.stdout').read_text()
assert '⋯' not in full and '\n...\n' not in full
assert (O/'formal/AuditTermsFull.lean').read_text().count('#print ') == 20
for module in modules:
    src = (D/'source'/module).read_text()
    for forbidden in (r'\bsorry\b', r'\badmit\b', r'\bnative_decide\b', r'Lean\.ofReduceBool'):
        assert not re.search(forbidden,src), (module,forbidden)

record = {'status':'PASS', 'steps':43, 'formal_plan_modules':34,
          'semantic_matches':matches,'child_commands':child,
          'toolchain_gate_roots':len(gate['roots']),
          'real_elapsed_s':sum(x['elapsed_s'] for x in receipt['steps']),
          'started_utc':receipt['start'],'stopped_utc':receipt['stop'],
          'full_prints':20, 'full_print_truncated':False,
          'author_outputs_not_copied_as_new_results':True,
          'source_before_after_same':True,
          'original_asan_not_rerun_by_fresh':True,
          'producer_step_metadata_note':'4 generated files predeclare step3 as pipeline end; actual producers 1 and 2'}
(W/'run/fresh_replay_audit.json').write_text(json.dumps(record,indent=2,sort_keys=True)+'\n')
print(json.dumps({k:v if k!='semantic_matches' else len(v) for k,v in record.items()},sort_keys=True))
