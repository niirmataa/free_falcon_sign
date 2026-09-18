"""Limited full-buffer prefix controls, with complete per-command receipts."""
import hashlib,json,os,signal,subprocess,time
from pathlib import Path
W=Path.cwd();C=W/'checks';L=C/'logs';L.mkdir(exist_ok=True)
lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
records=[]
def run(tag,argv,limit,stdout=None):
    start=time.monotonic();p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    timed=False
    try:out,err=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:
        timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    outpath=Path(stdout) if stdout else L/(tag+'.stdout');errpath=L/(tag+'.stderr')
    outpath.write_bytes(out);errpath.write_bytes(err)
    rec=dict(tag=tag,argv=argv,cwd=str(W),limit=limit,elapsed=time.monotonic()-start,exit_code=p.returncode,timeout=timed,
             stdout=str(outpath.relative_to(W)),stderr=str(errpath.relative_to(W)),stdout_sha256=hashlib.sha256(out).hexdigest(),stderr_sha256=hashlib.sha256(err).hexdigest())
    records.append(rec);(C/'commands.json').write_text(json.dumps(records,indent=2)+'\n')
    print(tag,p.returncode,round(rec['elapsed'],3),flush=True)
    assert not timed and p.returncode==0,(tag,err.decode(errors='replace'))
    return out
for name in ['observer','noop','plain','labels','cubic_order','scale','read_after_write']:
    run('gcc_'+name,['/usr/bin/gcc','-std=c99','-O2','-ffunction-sections','-fdata-sections','-Isource',f'checks/{name}_main.c','-Wl,--gc-sections','-o',f'bin/trace_{name}'],30)
for i in range(2):
    run(f'c{i}',['bin/trace_observer',f'checks/input{i}.txt'],30,C/f'c{i}.trace')
    out=run(f'lean{i}',[lean,'-j1','-M2048','--run','formal/TraceMain.lean',f'checks/input{i}.txt',f'checks/model{i}.trace'],120)
    assert b'warning:' not in out and b'error:' not in out
    assert (C/f'c{i}.trace').read_bytes()==(C/f'model{i}.trace').read_bytes(),f'C/model trace {i}'
    run(f'plain{i}',['bin/trace_plain',f'checks/input{i}.txt'],30,C/f'plain{i}.trace')
    endpoints=b''.join(l for l in (C/f'c{i}.trace').read_bytes().splitlines(keepends=True) if l.split()[0] in [b'input',b'forward',b'roundtrip'])
    assert endpoints==(C/f'plain{i}.trace').read_bytes()
for name in ['noop','labels','cubic_order','scale','read_after_write']:
    run(name,[f'bin/trace_{name}','checks/input0.txt'],30,C/(name+'.trace'))
    equal=(C/(name+'.trace')).read_bytes()==(C/'c0.trace').read_bytes()
    assert equal==(name=='noop'),name
def parse(path):
    rows={}
    for line in path.read_text().splitlines():
        a=line.split();key=(a[0],int(a[1]),int(a[2]));assert key not in rows
        rows[key]=list(map(int,a[3:]));assert len(rows[key])==1536
    return rows
counts=[len(parse(C/f'c{i}.trace')) for i in range(2)]
v=list(map(int,(C/'input0.txt').read_text().split()))
label=parse(C/'labels.trace')
assert label['roundtrip',0,1536]==v
assert label['forward',0,1536]!=parse(C/'c0.trace')['forward',0,1536]
result=dict(C_Lean_all_prefix_buffers_equal=True,plain_observer_endpoints_equal=True,snapshots_per_case=counts,
            compared_coefficients=sum(counts)*1536,mutations_detected=4,noop_pass=True,
            matched_labels_roundtrip_pass_but_forward_wrong=True,cases=2)
(W/'artifacts/controls.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
