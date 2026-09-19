import hashlib,json,os,signal,subprocess,sys,time,shlex
from pathlib import Path
import order_model as M
from dyadic import rn,floor_bits
W=Path.cwd();mode=sys.argv[1];L=W/'checks/gap_logs'/mode;L.mkdir(parents=True,exist_ok=True);records=[]
def run(tag,cmd):
 t=time.monotonic();p=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,start_new_session=True);timed=False
 try:o,e=p.communicate(timeout=60)
 except subprocess.TimeoutExpired:timed=True;os.killpg(p.pid,signal.SIGKILL);o,e=p.communicate()
 so=L/(tag+'.stdout');se=L/(tag+'.stderr');so.write_bytes(o);se.write_bytes(e)
 records.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,timeout=timed,limit=60,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=hashlib.sha256(o).hexdigest(),stderr_sha256=hashlib.sha256(e).hexdigest()))
 (W/f'artifacts/gap_{mode}_receipts.json').write_text(json.dumps(records,indent=2)+'\n')
 assert not timed and p.returncode==0,(o.decode(),e.decode());return o.decode()
flags=shlex.split(next(l for l in (W/'source/Makefile').read_text().splitlines() if l.startswith('CFLAGS = ')).split('=',1)[1]);exe='bin/gap_'+mode
san=['-O1','-g','-fsanitize=address,undefined','-fno-sanitize-recover=all','-fno-omit-frame-pointer','-no-pie'] if mode=='san' else []
run('compile',['/usr/bin/gcc','-std=c99']+flags+san+['-ffunction-sections','-fdata-sections','-Isource','checks/leaf_gap.c','source/fpr-emulated.c','source/falcon-fft.c','source/frng.c','source/shake.c','-Wl,--gc-sections','-lm','-o',exe])
text=run('run',[exe]);machine=M.Machine(W/'source/fpr-emulated.h');trace=[]
class Stop(Exception):pass
def sampler(mu,sigma,path,slot):
 i=len(trace);s=floor_bits(mu)
 if not -2147483283<=s<=2147483281:trace.append(f'first_unproved_center {i} {mu:016x} {s}');raise Stop()
 z=i-3;trace.append(f'prior {i} {mu:016x} {sigma:016x} {s} {z}');return s+z
machine.sample=sampler
try:machine.inner([rn(4294967296),0,0x4037ffffc16bfe5c,0x3ff55311b09aeb8c],0,[0,0],[0,0],'synthetic')
except Stop:pass
else:raise AssertionError('expected first open center')
assert '\n'.join(trace)+'\n'==text
out=dict(status='LEAF_ONLY_PREMISES_INSUFFICIENT',native_model_exact_match=True,trace=trace,
    all_stored_widths_pass_historical_H4_interval=True,L_real=4294967296,initial_targets_zero=True,
    prior_returns_in_proposal_support=True,source_center_exceeds_Cmu=True,
    required_key_support=False,loader_output=False,required_domain_counterexample=False,
    note='Synthetic two-polynomial inner node; no KeyGen/Sign invocation, no key/seed. Program stopped before unsafe long->int/s+z. Not a counterexample to emitted support.')
(W/f'artifacts/leaf_gap_{mode}.json').write_text(json.dumps(out,indent=2)+'\n')
if mode=='san':assert out==json.loads((W/'artifacts/leaf_gap_normal.json').read_text())
print(json.dumps(out,indent=2))
