"""Bounded normal/sanitizer runs and source-rule mutations; full streams retained."""
import json,hashlib,os,signal,subprocess,sys,time
from pathlib import Path
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];B=W/'bin';B.mkdir(exist_ok=True)
L=W/'checks/logs'/mode;L.mkdir(parents=True,exist_ok=True);cases=json.loads((W/'checks/cases.json').read_text());receipts=[]
def run(tag,argv,limit=30):
    p=subprocess.Popen(argv,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);start=time.monotonic();timed=False
    try:out,err=p.communicate(timeout=limit)
    except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);out,err=p.communicate()
    so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(out);se.write_bytes(err)
    receipts.append(dict(argv=argv,cwd=str(W),exit_code=p.returncode,timeout=timed,wall_limit=limit,elapsed=time.monotonic()-start,
      stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(out).hexdigest(),stderr_sha256=hashlib.sha256(err).hexdigest()))
    (W/f'artifacts/native_{mode}_receipts.json').write_text(json.dumps(receipts,indent=2)+'\n')
    assert not timed and p.returncode==0,(tag,out.decode(),err.decode())
    return out
def build(variant,san=False):
    exe=f'bin/{mode}_{variant}'
    flags=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if san else ['-O2']
    run('gcc_'+variant,['/usr/bin/gcc','-std=c99']+flags+['-ffunction-sections','-fdata-sections','-Isource',f'checks/{variant}_main.c','source/shake.c','-Wl,--gc-sections','-o',exe],60)
    return exe
def execute(variant,chosen=None):
    exe=build(variant,mode=='san');output=dict(verify={},norm={},center={})
    for case in cases['verify']:
        if chosen is not None and case['name'] not in chosen:continue
        out=run(variant+'_'+case['name'],[exe,'verify',case['pk'],case['c'],case['sig']]);output['verify'][case['name']]=json.loads(out)
    for case in cases['norm']:
        if chosen is not None and case['name'] not in chosen:continue
        out=run(variant+'_'+case['name'],[exe,'norm',case['path']]);output['norm'][case['name']]=json.loads(out)
    for d in cases['centers']:
        if chosen is not None and 'c'+str(d) not in chosen:continue
        out=run(variant+'_c'+str(d),[exe,'center',str(d)]);output['center'][str(d)]=json.loads(out)
    return output
results={}
if mode=='normal':
    lean='/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean'
    out=run('lean_models',[lean,'-j1','-M2048','--run','formal/BridgeControlMain.lean','checks/model_jobs.txt','checks/model_values.txt'],120)
    assert b'warning:' not in out and b'error:' not in out
    for variant in ['plain','observer']:results[variant]=execute(variant)
    selections={'noop':['zero_0','zero_1','old_witness','norm_negative_cross','c9216'],
      'center':['center_9216','c9216'],'offset':['norm_offset','norm_negative_cross'],
      'cross':['norm_negative_cross'],'bound':['bound_1_0','bound_1_1','norm_2093922385'],
      'narrow':['raw_0_32768','raw_1_32768','raw_0_65535','raw_1_65535']}
    for variant,sel in selections.items():results[variant]=execute(variant,sel)
else:results['observer']=execute('observer')
(W/f'checks/native_{mode}.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(dict(mode=mode,variants=list(results),runs=len(receipts),verify_cases=len(cases['verify']),norm_cases=len(cases['norm'])),indent=2))
