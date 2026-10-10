#!/usr/bin/env python3
"""Build/run the unmodified pinned leaf gate on a public exact Sage fixture."""
import json,hashlib,subprocess,sys,time,os
from pathlib import Path
s=Path(__file__).resolve().parent.parent;repo=s.parents[3];out=s/sys.argv[1]
out.mkdir(parents=True,exist_ok=False)
source=repo/'Extra/c';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for line in (repo/'provenance/ft1536-candidate.sha256').read_text().splitlines():
 if not line.strip():continue
 h,p=line.split(None,1);assert sha(source/p.strip())==h,p
fixture=s/'.build/bridge_009/runs/sage_004/golay_ntru_witness.json'
a=json.loads(fixture.read_text())
with (out/'fixture.h').open('w') as f:
 for key in ['f','g','F','G']:
  f.write('static const int16_t fixture_'+key+'[1536]={'+','.join(map(str,a[key]))+'};\n')
wrapper=s/'notes/C_GATE_009.c';(out/wrapper.name).write_bytes(wrapper.read_bytes())
flags=['-std=c99','-O','-Wall','-Wextra','-DFPR_IMPL="fpr-emulated.h"','-DSAMPLER_CODF=0','-DSAMPLER_CDF=0','-DCT_BEREXP=1','-DFT_TERNARY_ADAPTIVE_CDF=1','-DFT1536_CANDIDATE_PROFILE=1','-DCLEANSE=1','-DTRUE_TERNARY_SECRET=1','-DTRUE_TERNARY_SECRET_MODE=1','-DTERNARY_KEYGEN_BOUND_SCALE_NUM=1250','-DTERNARY_KEYGEN_BOUND_SCALE_DEN=100','-DTERNARY_KEYGEN_MAX_ATTEMPTS=3000000','-DSIGN_MAX_ATTEMPTS=16']
files=['falcon-enc.c','falcon-vrfy.c','frng.c','shake.c','fpr-emulated.c','falcon-fft.c','falcon-sign.c']
cmd=['gcc',*flags,'-I'+str(source),'-I'+str(out),str(out/wrapper.name),*[str(source/p) for p in files],'-lm','-o',str(out/'gate')]
env=os.environ.copy();env['TMPDIR']=str(s/'.build/bridge_009/tmp')
start=time.monotonic()
with (out/'compile.stdout').open('w') as so,(out/'compile.stderr').open('w') as se:
 r=subprocess.run(cmd,env=env,stdout=so,stderr=se,timeout=90)
code=None
if r.returncode==0:
 with (out/'gate.json').open('w') as so,(out/'run.stderr').open('w') as se:
  code=subprocess.run([str(out/'gate')],env=env,stdout=so,stderr=se,timeout=15).returncode
rec={'status':'C_GATE_DIAGNOSTIC_ONLY','command':cmd,'compile_exit':r.returncode,'run_exit':code,
 'compiler':subprocess.check_output(['gcc','--version'],text=True).splitlines()[0],
 'elapsed_seconds':time.monotonic()-start,'source_manifest_sha256':sha(repo/'provenance/ft1536-candidate.sha256'),
 'fixture_sha256':sha(fixture),'wrapper_sha256':sha(wrapper),'runner_sha256':sha(Path(__file__)),
 'generated_fixture_header_sha256':sha(out/'fixture.h'),
 'files':[{'path':str(p.relative_to(s)),'sha256':sha(p)} for p in out.iterdir() if p.is_file()],
 'scope':'One public synthetic fixture through actual leaf certificate; no KeyGen execution, no universal root error, no source security proof'}
(out/'receipt.json').write_text(json.dumps(rec,indent=2)+'\n')
print(json.dumps({'compile_exit':r.returncode,'run_exit':code,'directory':str(out)}))
sys.exit(0 if r.returncode==code==0 else 1)
