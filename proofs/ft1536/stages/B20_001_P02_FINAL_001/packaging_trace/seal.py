#!/usr/bin/env python3
"""Final immutable successor output manifest and external report/manifest digests."""
from pathlib import Path
import hashlib,json,datetime
W=Path(__file__).resolve().parents[1];O=W/'output';R=W.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    result=json.loads((O/'RESULT.json').read_text());head=json.loads((O/'HEAD_CONTEXT.json').read_text())
    assert result['task_id']=='B20_001_P02_WORD_FPEMU_REFINEMENT'
    assert result['packaging_task_id']=='FT1536_P02_FREEZE_CLOSURE_RUN_001'
    assert result['status']=='PARTIAL_PROOF' and not result['owner_accepted']
    assert result['new_package_head']==head['head']==(R/'.git/refs/heads/main').read_text().strip()
    assert (R/'.git/HEAD').read_text().strip()=='ref: refs/heads/main'
    assert sha(O/'predecessor/OUTPUTS.sha256')=='4e8942ccaf46f0971688a0f0cc1d07c5831a46175e6ad2dde903c9f55b046a01'
    assert sha(O/'predecessor/REPORT.md')=='98ea050bfe15b39b4ad2a6d26428bcd7e12f22ca33b06b6bc98e9e964bb295a5'
    assert json.loads((O/'REPLAY_RESULT.json').read_text())['status']=='FRESH_REPLAY_PASS'
    assert len(json.loads((O/'REPLAY_RESULT.json').read_text())['matched_semantics'])==16
    assert (W/'run/prepare_closure.exit').read_text().strip()=='0'
    assert (W/'run/audit_history.exit').read_text().strip()=='0'
    assert (W/'run/prepare_replay.exit').read_text().strip()=='0'
    assert (W/'run/check_replay.exit').read_text().strip()=='0'
    assert (W/'run/fresh_001.controller.exit').read_text().strip()=='0'
    assert (W/'run/fresh_002.controller.exit').read_text().strip()=='0'
    assert (W/'run/fresh_003.controller.exit').read_text().strip()=='0'
    listing=O/'OUTPUTS.sha256';assert not listing.exists()
    files=sorted((p for p in O.rglob('*') if p.is_file()),key=lambda p:p.relative_to(O).as_posix())
    assert all(not p.is_symlink() for p in O.rglob('*'))
    assert len(files)>29000
    assert not any(p.suffix in ('.olean','.pyc','.so','.o') for p in files)
    listing.write_text(''.join(sha(p)+'  '+p.relative_to(O).as_posix()+'\n' for p in files))
    print(json.dumps({'status':'FROZEN_COMPLETE_FOR_REVIEW_PARTIAL_PROOF',
        'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'head':head['head'],'files':len(files),'report_sha256':sha(O/'REPORT.md'),
        'outputs_sha256':sha(listing),'input_manifest_sha256':sha(O/'INPUTS.sha256')},indent=2))
if __name__=='__main__':main()
