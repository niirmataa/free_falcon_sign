import datetime,hashlib,json,os,stat
from pathlib import Path
W=Path.cwd()
def read(p):
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents]);assert stat.S_ISREG(p.lstat().st_mode)
    return p.read_bytes()
def sha(p):return hashlib.sha256(read(p)).hexdigest()
assert not (W/'OUTPUTS.sha256').exists()
r=json.loads(read(W/'RESULT.json'));assert r['result']=='L_RHO_PROVED_FOR_PINNED_MODEL'
assert r['report_sha256']==sha(W/'REPORT.md') and not r['source_integrated'] and not r['owner_accepted']
a=json.loads(read(W/'artifacts/audit_final.json'));assert a['original_inputs_checked']==34
log=read(W/'COMMANDS.log')
with (W/'artifacts/COMMANDS.frozen.log').open('xb') as f:f.write(log)
cut=dict(created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),bytes=len(log),records=len(log.splitlines()),sha256=hashlib.sha256(log).hexdigest())
with (W/'artifacts/COMMANDS.frozen.json').open('x') as f:json.dump(cut,f,indent=2);f.write('\n')
files=set(['REPORT.md','RESULT.json','REPLAY.md','OUTPUT_SCOPE.md','TOOLCHAIN.txt','INPUTS.sha256','CANDIDATE.sha256','candidate.patch'])
for root in ['reference','candidate','inputs','scripts','formal','mutants','observed','fixtures','artifacts']:
    for base,dirs,names in os.walk(W/root,followlinks=False):
        for name in dirs:assert not (Path(base)/name).is_symlink()
        dirs[:]=[x for x in dirs if x!='__pycache__']
        for name in names:
            if name.endswith(('.lock','.pyc')):continue
            p=Path(base)/name;assert stat.S_ISREG(p.lstat().st_mode) and not p.is_symlink()
            files.add(p.relative_to(W).as_posix())
for rec in map(json.loads,log.splitlines()):
    for k in ['stdout','stderr']:
        if rec.get(k):
            rel=Path(rec[k]);assert not rel.is_absolute() and '..' not in rel.parts;files.add(rel.as_posix())
manifest=''.join(sha(W/x)+'  '+x+'\n' for x in sorted(files))
assert read(W/'COMMANDS.log')==log
with (W/'OUTPUTS.sha256').open('x') as f:f.write(manifest)
for line in manifest.splitlines():
    h,path=line.split(maxsplit=1);assert sha(W/path)==h
print(json.dumps({'status':'FROZEN','files':len(files),'report':str(W/'REPORT.md'),'report_sha256':sha(W/'REPORT.md'),'outputs_sha256':sha(W/'OUTPUTS.sha256'),'frozen_log':cut},indent=2))
