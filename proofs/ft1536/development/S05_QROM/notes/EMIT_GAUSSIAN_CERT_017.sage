# sage EMIT_GAUSSIAN_CERT_017.sage CERTIFICATE OUTDIR
# Emit reproducible integer data only; separate Lean checkers prove its soundness.
from pathlib import Path
import json,sys,hashlib
cert=json.loads(Path(sys.argv[1]).read_text());out=Path(sys.argv[2]);out.mkdir(parents=True,exist_ok=False)
assert cert['status']=='ALL_EXACT_ROW_AND_LITERAL_CHECKS_PASS_NOT_YET_KERNEL'
lo=[ZZ(x) for x in cert['lower']];hi=[ZZ(x) for x in cert['upper']]
assert len(lo)==len(hi)==30721
chunks=[];names={'lo':[],'hi':[]}
for j,start in enumerate(range(0,30721,256)):
 for label,values in [('lo',lo),('hi',hi)]:
  name=label+'_'+str(j).zfill(3);names[label].append(name)
  chunks.append('def '+name+' : Array Nat := #['+','.join(str(x) for x in values[start:start+256])+']\n')
modules=[]
for j,start in enumerate(range(0,len(chunks),32)):
 name='GaussianBounds017_'+str(j).zfill(2);p=out/(name+'.lean')
 p.write_text('/- Generated exact certificate data; not a standalone analytic assertion. -/\nnamespace FT1536.S05.GaussianData017\n'+''.join(chunks[start:start+32])+'end FT1536.S05.GaussianData017\n')
 modules.append({'module':name,'source':str(p.resolve()),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size})
p=out/'GaussianBounds017.lean'
p.write_text(''.join('import '+r['module']+'\n' for r in modules)+'namespace FT1536.S05.GaussianData017\n'+
 'def lowerChunks : Array (Array Nat) := #['+','.join(names['lo'])+']\n'+
 'def upperChunks : Array (Array Nat) := #['+','.join(names['hi'])+']\n'+
 'def lower (i : Nat) : Nat := (lowerChunks.getD (i/256) #[]).getD (i%256) 0\n'+
 'def upper (i : Nat) : Nat := (upperChunks.getD (i/256) #[]).getD (i%256) 0\n'+
 'end FT1536.S05.GaussianData017\n')
modules.append({'module':'GaussianBounds017','source':str(p.resolve()),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size})
(out/'MANIFEST.json').write_text(json.dumps({'certificate_sha256':hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest(),'modules':modules,'states':len(lo)},indent=2)+'\n')
print('Emitted',len(modules),'modules;',sum(r['bytes'] for r in modules),'bytes',flush=True)
