#!/usr/bin/env python3
"""Extract pinned executable declarations; no mathematical computation.
Generated source is kernel checked in both worlds and separately compared
pointwise with018. Copies do not edit any earlier source or manifest.
"""
from pathlib import Path
import json,re,hashlib,sys
S=Path(__file__).resolve().parent.parent;B=S/'.build/model_bridge_019'
PINS={x['module']:x for x in json.loads((B/'legacy/lib/PINS.json').read_text())}
used={}
def declaration(module,name):
 rec=PINS[module];p=Path(rec['source']);text=p.read_text()
 assert hashlib.sha256(p.read_bytes()).hexdigest()==rec['source_sha256']
 used[module]={'source':str(p),'source_sha256':rec['source_sha256']}
 pattern=r'^(?:noncomputable )?(?:def|abbrev|structure|theorem|instance) ([A-Za-z0-9_]+)\b'
 matches=list(re.finditer(pattern,text,re.M));i=next(i for i,m in enumerate(matches) if m.group(1)==name)
 end=matches[i+1].start() if i+1<len(matches) else text.index('\n#print',matches[i].start())
 result=text[matches[i].start():end].rstrip()
 # Intervening comments are provenance-only; declarations here precede no local attributes.
 return result+'\n'
lines=['import JointInterface019','import FT1536.Model','import PublicTables016','import Run2.PolynomialReference','import Mathlib.Logic.Equiv.Fin.Basic','import Init.Data.Vector.OfFn','',
 'set_option maxRecDepth 8192','namespace FT1536.S05.StandaloneRuntime019',
 'open FT1536.Geometry FT1536.PublicSimulation FT1536.Relation JointInterface019','']
for n in ['split','chunks','value','value_lt','word']:lines.append(declaration('BitTapes016',n))
for n in ['CoordIndex','PairIndex','Block','Tables','embedCoord','zeroBlock','PairBits','PairSeed','VectorSeed','NormSeed','CubeSeed','Seed']:lines.append(declaration('SamplerCode016',n))
lines.append(declaration('CapExecution016','first').replace('def first (trial', 'def first {Coin A : Type} (trial'))
lines.append(declaration('BinarySearch018','search'))
for n in ['extended','coordRun','coord']:lines.append(declaration('BinaryCDF018',n).replace('BitTapes016.',''))
for n in ['CachedBox','view','save','pairTrial','pair','vector','normTrial']:
 lines.append(declaration('CachedSampler018',n).replace('BinaryCDF018.','').replace('BitTapes016.',''))
lines.append(declaration('SamplerCode016','cubeCoord').replace('BitTapes016.',''))
lines.append('def cube (coins : CubeSeed) : CachedBox :=\n  (Vector.ofFn (fun i => (cubeCoord (coins.1 i).1,cubeCoord (coins.1 i).2)),\n   Vector.ofFn (fun i => (cubeCoord (coins.2 i).1,cubeCoord (coins.2 i).2)))\n')
lines.append(declaration('CachedSampler018','selected'))
for n in ['pairEquiv','pairSeedEquiv','halfSeedEquiv','vectorSeedEquiv','normSeedEquiv','cubeHalfEquiv','cubeSeedEquiv','seedEquiv']:lines.append(declaration('SamplerCode016',n))
lines+=['namespace Scatter','open FT1536.Run2.PolynomialReference']
for n in ['Coeffs','addAt','scatter','indices','step','multiply','view']:lines.append(declaration('Scatter018',n))
lines+=['end Scatter','def tables : Tables where\n  cdf i := TableData016.cdf i.val\n  threshold i := TableData016.threshold i.val\n']
for n in ['Key','Output','keyView','saveKey','challenge','run','outputView']:
 t=declaration('StoredInterface018',n).replace('CachedSampler018.','').replace('Scatter018.','Scatter.').replace('ActualTables016.tables','tables')
 # A scoped irreducibility directive belongs to old proof elaboration, not runtime.
 t=re.sub(r'^attribute \[local irreducible\].*\n?', '', t, flags=re.M)
 lines.append(t)
lines+=['def publicCode (h : Rq) : PairCode Rq (Option BoxVec) where\n  bits := 24662538240\n  code tape := outputView (run (saveKey h) (seedEquiv tape))\n','end FT1536.S05.StandaloneRuntime019']
output='\n'.join(lines)+'\n'
# Only declarations explicitly selected above and their inherited comments.
output=re.sub(r'^attribute \[local irreducible\].*\n?', '',output,flags=re.M)
p=S/(sys.argv[1] if len(sys.argv)>1 else 'formal/StandaloneRuntime019.lean');assert p.resolve().is_relative_to(S);assert not p.exists();p.write_text(output)
q=B/(sys.argv[2] if len(sys.argv)>2 else 'RUNTIME_EXTRACTION_FINAL.json');assert not q.exists();q.write_text(json.dumps({'inputs':used,'output':str(p),'output_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'generator_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'status':'SOURCE_GENERATED_NOT_YET_PROVED','scope':'Executable declarations extracted, prefixes rewritten, cube materialization made explicit; equivalence needs its own kernel proof.'},indent=2)+'\n')
print({'source':str(p),'lines':len(output.splitlines()),'input_modules':len(used)})
