#!/usr/bin/env python3
"""Generate every named full term for the new075 STATIC physical reader and source prefix-refill loop."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenDecodeStaticReady','KeygenDecodeStaticInputGate','KeygenDecodeStaticCounterOps','KeygenDecodeStaticRefill','KeygenDecodeStaticWire','KeygenDecodeStaticPrefixLoop','KeygenDecodeStaticBitSlice','KeygenDecodeStaticPrefixValues']
INHERITED=['KeygenCodecStaticBitStream.encoded_bits','KeygenCodecStaticBitInverse.encoded_inverse',
 'KeygenDecodeStaticRead.source_append','KeygenDecodeStaticCertifiedStore.store']
def declarations():
 groups={}
 for module in MODULES:
  source=(ROOT/'formal/Source3'/(module+'.lean')).read_text()
  namespace=re.search(r'^namespace (FT1536\.Source3\.\w+)$',source,re.M).group(1)
  names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',source,re.M)
  assert names and len(names)==len(set(names))
  groups.setdefault(namespace,[]).extend(names)
  assert len(groups[namespace])==len(set(groups[namespace]))
 return groups

def main():
 template=(ROOT/'formal/Source3/KeygenDecodeNoneAudit.lean').read_text()
 tail=template[template.index('  let names := groups.flatMap'):]
 groups=declarations()
 header='import Source3.KeygenDecodeWrite16\nimport Source3.KeygenCodecStaticBitInverse\n'+''.join('import Source3.'+m+'\n' for m in MODULES)
 header+='import Lean.Util.CollectAxioms\n\n'
 header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
 header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
 header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
 header+='/- Internal audit of constructive scalar/read/store components; full operational STATIC round-trip remains open. -/\n'
 header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
 header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
  '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
 header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
 target=ROOT/'formal/Source3/KeygenDecodeStaticReader075Audit.lean';assert not target.exists()
 target.write_text(header+tail)
 print({'modules':len(MODULES),'new':sum(map(len,groups.values())),'inherited':len(INHERITED)})
if __name__=='__main__':main()
