import datetime,hashlib,json,os,stat
from pathlib import Path
W=Path.cwd()
def data(p):
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents]);assert stat.S_ISREG(p.lstat().st_mode);return p.read_bytes()
def sha(p):return hashlib.sha256(data(p)).hexdigest()
assert not (W/'OUTPUTS.sha256').exists()
result=json.loads(data(W/'RESULT.json'));assert result['result']=='PARTIAL_PROOF'
assert result['report_sha256']==sha(W/'REPORT.md')
assert not result['source_integrated'] and not result['owner_accepted'] and not result['full_L_V_proved']
audit=json.loads(data(W/'artifacts/audit_final.json'));assert audit['original_inputs_checked']==31 and audit['permitted_main_verdict']=='PARTIAL_PROOF'
log=data(W/'COMMANDS.log')
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(log)
cut=dict(created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),bytes=len(log),records=len(log.splitlines()),sha256=hashlib.sha256(log).hexdigest())
with (W/'artifacts/COMMANDS.frozen.json').open('x') as f:json.dump(cut,f,indent=2);f.write('\n')
files=set(['REPORT.md','RESULT.json','CLAIM.md','DERIVATION.md','OBLIGATIONS.json','REPLAY.md','OUTPUT_SCOPE.md','INPUTS.sha256','TOOLCHAIN.txt'])
for root in ['source','inputs','scripts','formal','observed','mutants','fixtures','artifacts']:
    for base,dirs,names in os.walk(W/root,followlinks=False):
        for name in dirs:assert not (Path(base)/name).is_symlink()
        dirs[:]=[x for x in dirs if x!='__pycache__']
        for name in names:
            if name.endswith(('.pyc','.lock')):continue
            p=Path(base)/name;assert stat.S_ISREG(p.lstat().st_mode) and not p.is_symlink();files.add(p.relative_to(W).as_posix())
for r in map(json.loads,log.splitlines()):
    for key in ['stdout','stderr']:
        if r.get(key):
            p=Path(r[key]);assert not p.is_absolute() and '..' not in p.parts;files.add(p.as_posix())
manifest=''.join(sha(W/path)+'  '+path+'\n' for path in sorted(files))
assert data(W/'COMMANDS.log')==log
with (W/'OUTPUTS.sha256').open('x') as f:f.write(manifest)
for line in manifest.splitlines():
    h,path=line.split(maxsplit=1);assert sha(W/path)==h
print(json.dumps({'result':'PARTIAL_PROOF','frozen_outputs':len(files),'report':str(W/'REPORT.md'),'report_sha256':sha(W/'REPORT.md'),
                  'outputs_sha256':sha(W/'OUTPUTS.sha256'),'command_prefix':cut},indent=2))
