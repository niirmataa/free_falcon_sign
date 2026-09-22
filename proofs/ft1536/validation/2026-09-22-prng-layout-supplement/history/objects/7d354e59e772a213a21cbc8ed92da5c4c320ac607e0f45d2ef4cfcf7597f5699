"""Final W-only checkpoint: run after the rehearsal replay; creates
artifacts/freeze.json and the sealed OUTPUTS.sha256 manifest."""
import fcntl,json
from pathlib import Path
from replaylib import sha,verify_manifest
from scope import members
from common import W
def main():
    assert not (W/'OUTPUTS.sha256').exists(),'already frozen'
    with (W/'executor.lock').open('a') as lock:
        fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
        R=json.loads((W/'RESULT.json').read_text())
        C=json.loads((W/'PRNG_LAYOUT_CERTIFICATE.json').read_text())
        assert C['status']==R['status']=='PRNG_LAYOUT_COUNTER_PROVED_FOR_PINNED_SOURCE_MODEL'
        assert R['certificate_sha256']==sha(W/'PRNG_LAYOUT_CERTIFICATE.json')
        F=json.loads((W/'artifacts/fresh_replay.json').read_text())
        assert F['status']=='FRESH_REPLAY_PASS' and F['mismatches']==[]
        assert F['matched']==F['expected_files']==len(F['matches'])
        E=json.loads((W/'SEMANTIC_FILES.json').read_text())
        assert F['matches']==E['files'],'replay matches vs semantic files'
        for r in E['files']:
            assert sha(W/r['path'])==r['sha256'],r['path']
        for p,h in C['proof_files'].items():
            assert sha(W/p)==h,p
        verify_manifest(W/'inputs/bootstrap','MANIFEST.sha256',C['bootstrap_manifest_sha256'])
        data=(W/'COMMANDS.log').read_bytes()
        assert data.endswith(b'\n')
        cmds=[json.loads(s) for s in data.splitlines()]
        assert cmds[-1]['exit_code']==0 and not cmds[-1]['timeout']
        (W/'artifacts/COMMANDS.frozen.log').write_bytes(data)
        (W/'artifacts/freeze.json').write_text(json.dumps(dict(
            status='FROZEN_AFTER_SUCCESSFUL_REHEARSAL_REPLAY',
            task_id='FT1536_PRNG_LAYOUT_COUNTER_RUN_001',
            report_sha256=sha(W/'REPORT.md'),
            semantic_files=len(E['files']),commands_records=len(cmds),
            commands_frozen_sha256=sha(W/'artifacts/COMMANDS.frozen.log'),
            rehearsal_replay_status=F['status'],
            rehearsal_replay_destination=F['destination'],
            source_changed=False,production_source_changed=False,owner_accepted=False,
            outputs_manifest='OUTPUTS.sha256 (written after this receipt)',
            handoff='author TUI chat only; no relay, no Git, no publication'),indent=2)+'\n')
        paths=members(W)
        (W/'OUTPUTS.sha256').write_text(''.join(sha(W/p)+'  '+p+'\n' for p in paths))
        pin=sha(W/'OUTPUTS.sha256')
        assert set(verify_manifest(W,'OUTPUTS.sha256',pin))==set(paths)
        print(json.dumps(dict(status='FROZEN',members=len(paths),
            member_bytes=sum((W/p).stat().st_size for p in paths),
            report_sha256=sha(W/'REPORT.md'),outputs_sha256=pin,
            semantic_files=len(E['files'])),indent=2))
if __name__=='__main__':main()
