#!/usr/bin/env python3
"""Generate every named full term for the new075 STATIC source foundation."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenDecodeStaticBindingPart00','KeygenDecodeStaticBindingPart01','KeygenDecodeStaticBindingPart02','KeygenDecodeStaticBindingPart03','KeygenDecodeStaticBindingPart04','KeygenDecodeStaticSource','KeygenDecodeStaticBinding','KeygenDecodeStaticExecution','KeygenDecodeDynamicCalculation','KeygenDecodeStaticCellFrame','KeygenDecodeStaticPointerFrame','KeygenDecodeStaticFrame','KeygenCodecStaticBits','KeygenDecodeStaticAssignments']
INHERITED=['KeygenCodecStaticComplete.source_outcome','KeygenCodecStaticLength.encoded_length',
 'KeygenCodecStaticStreamByte.drain_low','KeygenCodecStaticSuffix.low_append',
 'KeygenDecodeMemory.store_readback','KeygenDecodeWrite16.exists_store']
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
 header='import Source3.KeygenDecodeWrite16\n'+''.join('import Source3.'+m+'\n' for m in MODULES)
 header+='import Lean.Util.CollectAxioms\n\n'
 header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
 header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
 header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
 header+='/- Internal audit of constructive scalar/read/store components; full STATIC value/round-trip composition remains open. -/\n'
 header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
 header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
  '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
 header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
 target=ROOT/'formal/Source3/KeygenDecodeStaticFoundation075Audit.lean';assert not target.exists()
 target.write_text(header+tail)
 print({'modules':len(MODULES),'new':sum(map(len,groups.values())),'inherited':len(INHERITED)})
if __name__=='__main__':main()
