from pathlib import Path
import json,re,subprocess,os,hashlib,shutil
W=Path(__file__).resolve().parents[1]
R=W.parents[3]
BASE=W/'snapshot/proofs/ft1536/development/T12_1/run2'
LIB=W/'lib_run2'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    arcs={e['target'].removeprefix('formal/').removesuffix('.lean').replace('/','.'):e
          for e in json.loads((BASE/'ARCHIVED_DEPENDENCIES.json').read_text())['files'] if e['target'].startswith('formal/')}
    seeds=json.loads((W/'DEPENDENCY_CANDIDATES.json').read_text());order=[];seen=set();inputs=[]
    def source(m):
        p=BASE/'formal'/(m.replace('.','/')+'.lean')
        if p.exists():return p
        if m in arcs:
            e=arcs[m];p=R/e['stage'];assert sha(p)==e['sha256'],m
            q=W/'snapshot'/e['stage'];q.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,q);return q
        if m in seeds:return Path(seeds[m]['source'])
        raise ValueError('Unresolved source: '+m)
    def visit(m):
        if m in seen:return
        if m.split('.')[0] in ['Mathlib','Lean','Std','Init','Batteries','Aesop']:return
        seen.add(m);p=source(m)
        imports=re.findall(r'^import\s+([\w.]+)',p.read_text(),re.M)
        for im in imports:visit(im)
        reuse=m in seeds and sha(p)==seeds[m]['source_sha256']
        inputs.append({'module':m,'source':str(p),'sha256':sha(p),'reused':reuse,'imports':imports})
        if not reuse:order.append((m,p))
    for m in ['HacGlue','CompPrg','AssemblyComp','Run2.UniformErrorBound','T5Pointwise']:visit(m)
    (W/'RUN2_INPUTS.json').write_text(json.dumps(inputs,indent=2)+'\n')
    LIB.mkdir(exist_ok=True)
    for m in seen:
        if m in seeds:
            dest=LIB/(m.replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
            if not dest.exists():shutil.copyfile(W/'lib'/(m.replace('.','/')+'.olean'),dest)
    env=os.environ.copy();env['AUDIT_LEAN_LIB']=str(LIB)
    for i,(m,p) in enumerate(order):
        label='run2_build_'+str(i+1).zfill(3)+'_'+m.replace('.','_')
        while (W/'attempts'/label/'RECEIPT.json').exists() and json.loads((W/'attempts'/label/'RECEIPT.json').read_text())['exit_code']!=0:
            label+='_retry'
        if (W/'attempts'/label/'RECEIPT.json').exists():
            rec=json.loads((W/'attempts'/label/'RECEIPT.json').read_text());assert rec['exit_code']==0
        else:
            run=subprocess.run(['python3','-B',str(W/'scripts/run_lean.py'),label,str(p)],env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
            if run.returncode:print(run.stdout,flush=True);raise SystemExit(run.returncode)
        product=W/'attempts'/label/(p.stem+'.olean');dest=LIB/(m.replace('.','/')+'.olean')
        dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(product,dest)
        print(f'{i+1}/{len(order)} {m}',flush=True)
if __name__=='__main__':main()
