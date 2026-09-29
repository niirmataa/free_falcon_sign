#!/usr/bin/env python3
"""Seal portable replay sources, historical attempts, and a semantic plan BEFORE fresh replay."""
from pathlib import Path
import hashlib,json,shutil,difflib
W=Path(__file__).resolve().parents[1];O=W/'output';R=O/'replay';old=W/'inputs/bootstrap/prior/run/job.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert (W/'run/prepare_closure.exit').read_text().strip()=='0'
assert (W/'run/audit_history.exit').read_text().strip()=='0'
assert (W/'run/collect_failed_history.exit').read_text().strip()=='0'
assert (W/'run/recover_colliding_logs.exit').read_text().strip()=='0'
assert sha(old)==sha(R/'original_job.py')
shutil.copyfile(W/'run/portable_job.py',R/'job.py')
shutil.copyfile(W/'run/portable_toolchain_gate.py',R/'portable_toolchain_gate.py')
shutil.copyfile(W/'run/FAILED_HISTORY_INDEX.json',O/'FAILED_HISTORY_INDEX.json')
diff=''.join(difflib.unified_diff(old.read_text().splitlines(True),(R/'job.py').read_text().splitlines(True),
                                   fromfile='prior/run/job.py',tofile='replay/job.py'))
(R/'RUNNER_DELTA.diff').write_text(diff)
original=W/'inputs/bootstrap/prior/run/replay_001/source/tools/toolchain_gate.py'
(R/'TOOLCHAIN_DELTA.diff').write_text(''.join(difflib.unified_diff(original.read_text().splitlines(True),
    (R/'portable_toolchain_gate.py').read_text().splitlines(True),fromfile='prior/source/tools/toolchain_gate.py',
    tofile='replay/portable_toolchain_gate.py')))
baseline=O/'evidence/prior_run/replay_001'
names=['build/TRANSPORT_MATCH.json','build/CONTROL_RESULT.json','build/LE_CONTROL_RESULT.json',
       'build/SCALAR_CONTROL_RESULT.json','build/word_oracle.json','build/le_oracle.json',
       'build/scalar_oracle.json','build/PinnedHeader.lean','build/PinnedSlices.lean',
       'build/PinnedShake.lean','build/PinnedLittleEndian.lean','build/ScalarSlices.lean',
       'build/ScalarPrograms.lean','040.stdout','041.stdout']
plan=json.loads((O/'formal/BUILD_PLAN.json').read_text())['modules']
assert len(plan)==34
items=[]
for name in names:
    assert (baseline/name).is_file(),name
    step=40 if name=='040.stdout' else 41 if name=='041.stdout' else 4 if name=='build/TRANSPORT_MATCH.json' else 5 if name in ('build/CONTROL_RESULT.json','build/word_oracle.json') else 6 if name in ('build/LE_CONTROL_RESULT.json','build/le_oracle.json') else 7 if name in ('build/SCALAR_CONTROL_RESULT.json','build/scalar_oracle.json') else 3
    items.append({'path':name,'baseline':'evidence/prior_run/replay_001/'+name,
                  'sha256':sha(baseline/name),'producer_step':step})
supplement=O/'evidence/baseline_full_audit.stdout'
assert supplement.is_file() and '⋯' not in supplement.read_text()
items.append({'path':'042.stdout','baseline':'evidence/baseline_full_audit.stdout',
              'sha256':sha(supplement),'producer_step':42})
semantic={'schema':'P02_PORTABLE_SEMANTIC_PLAN_V2','declared_before_fresh':True,
          'matches':items,'baseline_receipt':'evidence/prior_run/replay_001/receipt.json',
          'full_plan_modules':plan,'audit_sources':['formal/AuditExports.lean','formal/AuditTerms.lean'],
          'supplementary_full_term_source':'formal/AuditTermsFull.lean',
          'gate':'replay/portable_toolchain_gate.py: rebuild 9 pinned source+cache manifests without git process',
          'sanitizers':'historical original source/harness receipts sealed in evidence/prior_run; no source/domain changes',
          'excluded':'wall-clock receipts, cache, binaries, nonsemantic paths'}
(O/'SEMANTIC_FILES.json').write_text(json.dumps(semantic,indent=2,sort_keys=True)+'\n')
static=('inputs','formal','predecessor','evidence','context','library_provenance','replay')
paths=sorted([p for d in static for p in (O/d).rglob('*') if p.is_file()]+[O/'SEMANTIC_FILES.json'],key=lambda p:p.relative_to(O).as_posix())
assert all(not p.is_symlink() for d in static for p in (O/d).rglob('*'))
(O/'INPUTS.sha256').write_text(''.join(sha(p)+'  '+p.relative_to(O).as_posix()+'\n' for p in paths))
print('STATIC_INPUTS_READY',len(paths), 'sha256',sha(O/'INPUTS.sha256'),'semantic matches',len(items),flush=True)
