#!/usr/bin/env python3
"""Copy final reviewer receipts/logs/semantic products into frozen output closure."""
from pathlib import Path
import hashlib,json,shutil
W=Path(__file__).resolve().parents[1];O=W/'output';E=O/'evidence'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def copy(src,dst):
    assert src.is_file() and not src.is_symlink(), (src,dst)
    if dst.exists():
        assert sha(src)==sha(dst)
        return
    dst.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(src,dst)
    assert sha(src)==sha(dst)
fresh=W/'run/fresh_002'; replay=json.loads((fresh/'REPLAY_RESULT.json').read_text())
assert replay['status']=='FRESH_REPLAY_PASS' and len(replay['matches'])==10 and replay['sources_unchanged']
assert replay['input_manifest_before']==replay['input_manifest_after']
for r in replay['matches']:
    actual=fresh/r['path']; baseline=W/'inputs/subject'/r['baseline']/r['path']
    assert sha(actual)==sha(baseline)==r['sha256'] and r['producer_exit_code']==0
    copy(actual,E/'fresh_002'/r['path'])
for name in ['fresh_001','fresh_002','ubsan_001','asan_001']:
    run=W/'run'/name
    receipt=json.loads((run/'receipt.json').read_text())
    expected=0 if name!='fresh_001' else 1
    assert receipt['exit_code']==expected and receipt['sources_unchanged']
    copy(run/'receipt.json',E/name/'receipt.json')
    if (run/'REPLAY_RESULT.json').exists(): copy(run/'REPLAY_RESULT.json',E/name/'REPLAY_RESULT.json')
    for s in receipt['steps']:
        for k in ['stdout','stderr']:
            source=run/s[k]; assert sha(source)==s[k+'_sha256']
            copy(source,E/name/s[k])
    for rel in ['build/TOOLCHAIN_GATE.json','build/LEAN_RUNTIME.sha256','build/C_DOMAIN_PREFLIGHT.json',
                'build/C_SLICES_CHECK.json','build/C_SOURCE_BINDING.json','build/C_COMMANDS.json',
                'build/BUDGET_ANALYSIS.json','build/C_SLICES.ndjson',
                'build/local_slices.c','build/public_cases.h']:
        source=run/rel
        if source.is_file() and not (E/name/rel).exists():copy(source,E/name/rel)
    ccommands=run/'build/C_COMMANDS.json'
    if ccommands.exists():
        for c in json.loads(ccommands.read_text()):
            for key in ['stdout','stderr']:
                source=run/'build'/c[key]
                assert sha(source)==c[key+'_sha256']
                copy(source,E/name/'build'/c[key])
for mode in ['fresh_001','fresh_002','ubsan','asan']:
    for suffix in ['stdout','stderr','exit']:
        controller=W/'run'/f'{mode}_controller.{suffix}'
        if controller.exists():copy(controller,E/'controllers'/controller.name)
summary={'replay':'FRESH_REPLAY_PASS','semantic_matches':len(replay['matches']),
         'source_maps_unchanged':replay['sources_unchanged'],
         'toolchain_gate_pass':json.loads((fresh/'build/TOOLCHAIN_GATE.json').read_text())['pass'],
         'first_attempt_failure':'outer bwrap /proc RO, nested uid map unavailable; retained as fresh_001',
         'sanitizers':{mode:json.loads((W/'run'/mode/'receipt.json').read_text())['exit_code'] for mode in ['ubsan_001','asan_001']},
         'copied_files':sum(p.is_file() for p in E.rglob('*'))}
(O/'REPLAY_AUDIT.json').write_text(json.dumps(summary,indent=2,sort_keys=True)+'\n')
print(json.dumps(summary,indent=2))
