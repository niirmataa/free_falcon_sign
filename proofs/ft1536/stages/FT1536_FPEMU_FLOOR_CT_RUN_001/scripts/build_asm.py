import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();tag=sys.argv[1];out=W/'artifacts/asm'/tag;out.mkdir(parents=True,exist_ok=False);rows=[]
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'baseline/source/Makefile').read_text(),re.M).group(1));flags=[s.replace('\\"','"') for s in flags]
def run(name,argv):
 t=time.monotonic();p=subprocess.run(argv,capture_output=True,timeout=120);so=out/(name+'.stdout');se=out/(name+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 rows.append(dict(argv=argv,cwd=str(W),limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=str(so.relative_to(W)),stderr=str(se.relative_to(W)),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (out/'commands.json').write_text(json.dumps(rows,indent=2)+'\n');assert p.returncode==0,(name,p.stderr.decode());return p.stdout
objects=[]
for variant in ['baseline','candidate']:
 inc=variant+'/source';vf=flags+['-std=c99','-I'+inc]
 for unit,src in [('wrapper','checks/floor_wrapper.c'),('sign',inc+'/falcon-sign.c')]:
  stem=variant+'_'+unit;obj='bin/'+tag+'_'+stem+'.o';asm=str((out/(stem+'.s')).relative_to(W));pre=str((out/(stem+'.i')).relative_to(W));dep=str((out/(stem+'.d')).relative_to(W))
  run(stem+'_compile',['/usr/bin/gcc']+vf+['-MMD','-MF',dep,'-c',src,'-o',obj])
  run(stem+'_asm',['/usr/bin/gcc']+vf+['-fverbose-asm','-S',src,'-o',asm])
  data=run(stem+'_preprocess',['/usr/bin/gcc']+vf+['-E',src]);(W/pre).write_bytes(data)
  dis=run(stem+'_objdump',['/usr/bin/objdump','-drwC',obj]);(out/(stem+'.dis')).write_bytes(dis)
  objects.append(dict(variant=variant,unit=unit,source=src,object_path=obj,object_sha256=sha(W/obj),assembly=asm,assembly_sha256=sha(W/asm),preprocessed=pre,preprocessed_sha256=sha(W/pre),flags=vf))
outdata=dict(tag=tag,objects=objects,candidate_header_sha256=sha(W/'candidate/source/fpr-emulated.h'),baseline_header_sha256=sha(W/'baseline/source/fpr-emulated.h'))
(out/'build.json').write_text(json.dumps(outdata,indent=2)+'\n');print(json.dumps(outdata,indent=2))
