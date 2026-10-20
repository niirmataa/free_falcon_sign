"""Fresh local replay of the three accepted probe modules on pinned libraries.

This is not a full Source3 rebuild. All artifact source bindings are in the
audit archive; full reconstruction requires the recorded Lean/Mathlib runtime.
"""
from pathlib import Path
import sys,json,hashlib,shutil,subprocess,os,datetime
W=Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    dest=Path(sys.argv[1]).resolve()
    repo=Path('/media/footfalcon/FT1536_DATA/free_falcon_sign')
    if not dest.is_relative_to(repo/'proofs/ft1536/replay-work') and not dest.is_relative_to(W):raise ValueError('Replay must stay in durable audit/replay work')
    dest.mkdir(parents=True,exist_ok=False)
    for sub in ['formal','scripts','tmp','cache']: (dest/sub).mkdir()
    for p in ['CONFIG.json','scripts/run_lean.py','formal/Source3Probes.lean','formal/PositiveControls.lean','formal/Run2Probes.lean']:
        shutil.copyfile(W/p,dest/p)
    inputs=json.loads((W/'LIBRARY_SNAPSHOT.json').read_text())
    for e in inputs:
        p=Path(e['path']);assert sha(p)==e['sha256'],str(p)
        q=dest/e['relative'];q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q)
    results=[]
    for module,original in [('Source3Probes','source3_probes_004'),('PositiveControls','positive_controls_002'),('Run2Probes','run2_probes_003')]:
        env=os.environ.copy()
        if module=='Run2Probes':env['AUDIT_LEAN_LIB']=str(dest/'lib_run2')
        run=subprocess.run(['python3','-B',str(dest/'scripts/run_lean.py'),'replay_'+module,'formal/'+module+'.lean'],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
        rec=json.loads((dest/'attempts'/('replay_'+module)/'RECEIPT.json').read_text())
        expected=json.loads((W/'attempts'/original/'RECEIPT.json').read_text())
        assert run.returncode==0 and rec['clean_log'],run.stdout
        assert rec['source_sha256']==expected['source_sha256']
        assert rec['stdout_sha256']==expected['stdout_sha256']
        results.append({'module':module,'source_sha256':rec['source_sha256'],'stdout_sha256':rec['stdout_sha256'],'clean_log':True,'exit_code':0,'receipt':str((dest/'attempts'/('replay_'+module)/'RECEIPT.json'))})
        print(module+' clean/source/stdout match',flush=True)
    (dest/'REPLAY_RESULT.json').write_text(json.dumps({'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'three audit modules; reused pinned corpus artifacts','results':results},indent=2)+'\n')
if __name__=='__main__':main()
