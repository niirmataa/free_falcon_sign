#!/usr/bin/env python3
"""Generate a width-specific exact inverse certificate without replacing older probes."""
from pathlib import Path
import hashlib,json,sys
ROOT=Path(__file__).resolve().parents[1]
assert len(sys.argv)==2
width=int(sys.argv[1]);assert width in [2,4,8,16,32,64] and 768%width==0
name='GeneratedGsCheck156ProbeInverse'+str(width)
text='import Source3.GsNumericTarget156\nimport Source3.GeneratedGsData156Denominator\nimport Source3.GeneratedGsData156Inverse\n'
text+='\nset_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\nset_option Elab.async false\n\nnamespace FT1536.Source3.'+name+'\n\n'
text+='theorem checked : FiniteWordVector153.checkChunk (GsNumericTarget156.inverse GeneratedGsData156Denominator.word) GeneratedGsData156Inverse.word 0 '+str(width)+'=true := by decide +kernel\n\n'
text+='end FT1536.Source3.'+name+'\n'
p=ROOT/'formal/Source3'/(name+'.lean')
if p.exists():assert p.read_text()==text
else:p.write_text(text)
plan={'module':name,'width':width,'source':str(p),'source_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),
 'generator':{'path':str(Path(__file__).resolve()),'sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest()}}
p=ROOT/'.build/gscells156'/('INVERSE_PROBE'+str(width)+'.json');encoded=json.dumps(plan,indent=2)+'\n'
if p.exists():assert p.read_text()==encoded
else:p.write_text(encoded)
print(json.dumps({'module':name,'width':width}))
