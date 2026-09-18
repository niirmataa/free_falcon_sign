"""Final clean kernel verification, full logs, exhaustive exported theorem audit."""
import hashlib,json,os,re,signal,subprocess,time
from pathlib import Path
W=Path.cwd();log=W/'logs/final';log.mkdir(exist_ok=True)
lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
modules=['Deps/Words','Deps/Linear','Deps/Tables','Deps/Composition','Buffer','Layouts','Twiddles','SourceModel',
         'Expressions','BlockExpressions','BlockChecks','LocalInverse','Stages','InverseGlobal','ForwardProgress','Pipeline','TraceMain']
decls=[];sources={};receipts=[]
for module in modules:
    path=W/'formal'/(module+'.lean');text=path.read_text()
    assert not re.search(r'^\s*(axiom|opaque)\s',text,re.M)
    assert not re.search(r'\b(sorry|admit|native_decide)\b',text)
    ns=re.search(r'^namespace (\w+)',text,re.M)
    for name in re.findall(r'^theorem ([\w.]+)',text,re.M):decls.append((ns.group(1)+'.'+name) if ns else name)
    sources[str(path.relative_to(W))]=hashlib.sha256(path.read_bytes()).hexdigest()
audit='import Pipeline\nimport TraceMain\nset_option pp.universes true\n'
audit+='\n'.join('#check @FT1536Global.'+n for n in ['inverseMem_forwardMem','inverseC_forwardC','inverse_forward','pipelineC_lift','L_NTT_pending_forward'])+'\n'
audit+='\n'.join('#print axioms '+n for n in decls)+'\n'
(W/'formal/Audit.lean').write_text(audit)
sources['formal/Audit.lean']=hashlib.sha256(audit.encode()).hexdigest()
for module in modules+['Audit']:
    name=module.replace('/','_');argv=[lean,'-j1','-M2048','--root=formal','-o',f'formal/{module}.olean',f'formal/{module}.lean']
    start=time.monotonic();p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True)
    timed=False
    try:out,err=p.communicate(timeout=120)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    (log/(name+'.stdout')).write_bytes(out);(log/(name+'.stderr')).write_bytes(err)
    receipts.append(dict(module=module,argv=argv,cwd=str(W),exit_code=p.returncode,timeout=timed,wall_limit=120,
        address_space_bytes=8*1024**3,Lean_heap_limit_MiB=2048,elapsed_seconds=time.monotonic()-start,
        stdout=f'logs/final/{name}.stdout',stderr=f'logs/final/{name}.stderr',stdout_sha256=hashlib.sha256(out).hexdigest(),stderr_sha256=hashlib.sha256(err).hexdigest()))
    (W/'artifacts/kernel_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
    assert not timed and p.returncode==0,(module,out.decode(),err.decode())
    assert not re.search(rb'(warning:|error:|sorryAx|Lean.ofReduceBool)',out+err),(module,out.decode(),err.decode())
    print(module,'clean',round(receipts[-1]['elapsed_seconds'],3),flush=True)
allowed={'propext','Classical.choice','Quot.sound'}
auditout=(log/'Audit.stdout').read_text()
for name in decls:assert "'"+name+"'" in auditout,name
for deps in re.findall(r'depends on axioms: \[([^]]*)\]',auditout):
    names={re.sub(r'\.\{[^}]*\}$','',a) for a in deps.split(', ')}
    assert names<=allowed,deps
result=dict(modules=len(modules)+1,checked_theorems=len(decls),theorems=decls,sources_sha256=sources,
            all_final_logs_clean=True,axioms_allowed=sorted(allowed),audit_stdout_sha256=hashlib.sha256(auditout.encode()).hexdigest(),
            note='L_NTT_pending_forward explicitly retains forward_product; inspect its full type')
(W/'artifacts/formal_audit.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['theorems','sources_sha256']},indent=2))
