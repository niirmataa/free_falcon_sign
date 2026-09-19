import hashlib,json,os,signal,subprocess,time,shlex,sys
from pathlib import Path
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];rows=[];L=W/'checks/logs'/mode;L.mkdir(parents=True,exist_ok=True)
flags=shlex.split(next(x for x in (W/'source/Makefile').read_text().splitlines() if x.startswith('CFLAGS = ')).split('=',1)[1])
def run(tag,cmd,lim=30):
 t=time.monotonic();p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
 try:o,e=p.communicate(timeout=lim)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
 rows.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,timeout=timed,seconds=time.monotonic()-t,limit=lim,
   stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
 (W/f'artifacts/{mode}_receipts.json').write_text(json.dumps(rows,indent=2)+'\n')
 assert not timed and p.returncode==0,(tag,o.decode(),e.decode())
 return o.decode().strip()
exe='bin/probe_'+mode
san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
run('compile',['/usr/bin/gcc','-std=c99']+flags+san+['-ffunction-sections','-fdata-sections','-Isource','checks/probe.c','source/fpr-emulated.c','source/falcon-fft.c','source/frng.c','source/shake.c','-Wl,--gc-sections','-lm','-o',exe],60)
jobs=[]
for x in [0,1,(1<<52)-1,1<<52,(1<<52)+1,0x3fefffffffffffff,0x3ff0000000000000,0x41dfffffa4bfffff,0x41dfffffa4c00000,0x41dfffffa4ffffff,0x41dfffffa5000000,0x41e0000000000000]:
 for s in [0,1<<63]: jobs.append(['floor',f'{x|s:016x}']);jobs.append(['guard',f'{x|s:016x}','3ff0000000000000'])
for x in ['0000000000000000','8000000000000000','0010000000000000','8010000000000000','0010000000000001','000fffffffffffff','8000000000000001','3ff0000000000000']:
 jobs+=[['half',x],['neg',x],['mul',x,'3fe0000000000000'],['div',x,'4000000000000000'],['add',x,'0000000000000000'],['sub',x,x],['sqrt',x]]
jobs += [['mul','0010000000000000','3fe8000000000000'],['add','0000000000000001','0000000000000001'],['sub','8000000000000001','bff0000000000000'],['sticky','7ff0000000000000','0000000000000000']]
jobs += [['add','3ff0000000000000','3c90000000000000'],['div','3ff0000000000000','4008000000000000']]
results=[dict(args=j,output=run('p'+str(i),[exe]+j)) for i,j in enumerate(jobs)]
results += [dict(args=[j],output=run(j,[exe,j])) for j in ['cdf','widths']]
if mode=='normal': (W/'artifacts/tables_C.txt').write_text(run('tables',[exe,'tables'])+'\n')
(W/f'artifacts/probes_{mode}.json').write_text(json.dumps(results,indent=2)+'\n')
print(json.dumps(dict(mode=mode,jobs=len(results),negative_zero_floor=next(r['output'] for r in results if r['args']==['floor','8000000000000000'])),indent=2))
