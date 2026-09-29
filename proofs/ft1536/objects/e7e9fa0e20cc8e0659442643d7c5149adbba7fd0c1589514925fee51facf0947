#!/usr/bin/env python3
"""Check actual fresh replay, producer steps, semantic matches, then seal text evidence."""
from pathlib import Path
import hashlib,json,shutil,sys
W=Path(__file__).resolve().parents[1];O=W/'output';D=W/'run'/sys.argv[1]
assert D.is_dir()
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
r=json.loads((D/'receipt.json').read_text());plan=json.loads((O/'SEMANTIC_FILES.json').read_text())
assert r['exit_code']==0 and r['sources_unchanged'] and r['inputs_sha256']==sha(O/'INPUTS.sha256')
assert len(r['steps'])==8+len(plan['full_plan_modules'])+1==43
assert all(s['exit_code']==0 and s['clean'] and not s['timed_out'] for s in r['steps'])
for s in r['steps']:
    assert '--unshare-net' in s['argv'] and '--proc' in s['argv'] and '--dev-bind' in s['argv']
    for k in ('stdout','stderr'):
        assert sha(D/s[k])==s[k+'_sha256']
assert json.loads((D/'build/toolchain/PORTABLE_GATE.json').read_text())['pass']
assert len(json.loads((D/'build/toolchain/PORTABLE_GATE.json').read_text())['roots'])==9
actual=[]
generator_steps={'build/PinnedHeader.lean':1,'build/PinnedSlices.lean':1,
                 'build/PinnedShake.lean':2,'build/PinnedLittleEndian.lean':2,
                 'build/ScalarSlices.lean':3,'build/ScalarPrograms.lean':3}
for entry in plan['matches']:
    p=D/('logs/'+entry['path'] if entry['path'].endswith('.stdout') else entry['path'])
    # Historical 040/041 + supplemental 042 stdout are produced in fresh logs/.
    baseline=O/entry['baseline']
    assert p.is_file() and baseline.is_file()
    fresh=sha(p);historical=sha(baseline)
    assert historical==entry['sha256'] and fresh==historical,(entry['path'],fresh,historical)
    assert r['steps'][entry['producer_step']]['exit_code']==0
    real_step=generator_steps.get(entry['path'],entry['producer_step'])
    assert r['steps'][real_step]['exit_code']==0
    if real_step!=entry['producer_step']:
        # Predeclared 3 was the end of the generator pipeline; distinguish
        # that check from the precise producing command in the frozen receipt.
        assert entry['producer_step']==3 and real_step in (1,2)
    actual.append({'path':entry['path'],'sha256':fresh,'producer_step':real_step,
                   'predeclared_pipeline_complete_step':entry['producer_step'],
                   'producer_argv':r['steps'][real_step]['argv'],
                   'producer_exit':0,'baseline':entry['baseline']})
assert len(actual)==16
prior=json.loads((O/'HISTORY_BINDING.json').read_text());oldrun=next(x for x in prior['runs'] if x['id']=='replay_001')
assert oldrun['steps']==42
assert '⋯' not in (D/'logs/042.stdout').read_text()
for idx in (5,6,7):
    step=r['steps'][idx]
    assert step['child_commands_snapshotted']>0
    receipt_file=D/step['child_receipt_snapshot']
    assert receipt_file.is_file()
    for child in json.loads(receipt_file.read_text()):
        for kind in ('stdout','stderr'):
            path=receipt_file.parent/(child['name']+'.'+kind)
            assert sha(path)==child[kind+'_sha256'],(idx,child['name'],kind)
dst=O/'replay_evidence'/D.name
assert not dst.exists()
dst.mkdir(parents=True)
for name in ('receipt.json',):shutil.copyfile(D/name,dst/name)
for p in sorted((D/'logs').rglob('*')):
    if p.is_file():
        q=dst/p.relative_to(D);q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
allowed={'.json','.stdout','.stderr','.txt','.sage','.lean','.c','.h','.sha256','.git-tree','.log','.trace'}
for p in sorted((D/'build').rglob('*')):
    if p.is_file() and p.suffix in allowed and not p.is_symlink():
        q=dst/p.relative_to(D);q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
result={'schema':'P02_PORTABLE_FRESH_REPLAY_V2','status':'FRESH_REPLAY_PASS','run':D.name,
        'receipt':'replay_evidence/'+D.name+'/receipt.json',
        'steps':len(r['steps']),'matched_semantics':actual,'inputs_sha256':r['inputs_sha256'],
        'source_map_equal':r['sources_unchanged'],'source_before':r['source_before'],
        'source_after':r['source_after'],'fresh_gate':'replay_evidence/'+D.name+'/build/toolchain/PORTABLE_GATE.json',
        'semantic_plan_step_note':'For four generated files predeclared producer_step=3 was the completed generator pipeline, not the earliest writer; matched_semantics gives actual producer steps 1/2 with argv and exit.',
        'historic_sanitizer_receipts':['evidence/prior_run/'+name+'/receipt.json' for name in ('word_asan_002','le_asan_002','scalar_asan_001')],
        'old_result_scope':'PARTIAL_PROOF','owner_accepted':False}
(O/'REPLAY_RESULT.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print('FRESH_REPLAY_PASS',len(r['steps']),'steps',len(actual),'semantic matches','text evidence files',sum(p.is_file() for p in dst.rglob('*')))
