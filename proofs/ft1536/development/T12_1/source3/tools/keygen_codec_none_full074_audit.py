#!/usr/bin/env python3
"""Generate full terms for074 complete source NONE memory round-trip and honest execution."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenDecodeNoneEntryCalculations', 'KeygenDecodeNoneEntryControl', 'KeygenDecodeNonePrologue', 'KeygenDecodeNonePrologueExists', 'KeygenDecodeNoneFor', 'KeygenDecodeSequence', 'KeygenDecodeNoneComplete', 'KeygenDecodeNoneExactFrame', 'KeygenCodecNoneRoundtrip', 'KeygenDecodeDispatchBindingPart00', 'KeygenDecodeDispatchSource', 'KeygenDecodeDispatchBinding', 'KeygenDecodeNoneDispatchExecution', 'KeygenDecodeNoneDispatchFacts', 'KeygenCodecNoneCallMaterial', 'KeygenCodecNoneCallRoundtrip', 'KeygenCodecNoneMemoryIdentity']
INHERITED=['KeygenDecodeNoneLoop.source_loop', 'KeygenDecodeNoneLoop.loop_exists', 'KeygenDecodeNoneCoefficient.source_store', 'KeygenDecodeNoneCoefficientExists.coefficient_exists', 'KeygenCodecNoneOriginal.source_bytes', 'KeygenCodecNoneWire.source_readable', 'KeygenCodecNoneWire.source_original_preserved']
def declarations():
 groups={}
 for module in MODULES:
  source=(ROOT/'formal/Source3'/(module+'.lean')).read_text()
  namespace=re.search(r'^namespace (FT1536\.Source3\.\w+)$',source,re.M).group(1)
  names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',source,re.M)
  assert names and len(names)==len(set(names))
  groups.setdefault(namespace,[]).extend(names)
  assert len(groups[namespace])==len(set(groups[namespace])),namespace
 return groups

def main():
 template=(ROOT/'formal/Source3/KeygenDecodeNoneAudit.lean').read_text()
 tail=template[template.index('  let names := groups.flatMap'):]
 groups=declarations()
 header=''.join('import Source3.'+m+'\n' for m in MODULES)
 header+='import Lean.Util.CollectAxioms\n\n'
 header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
 header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
 header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
 header+='/- Internal audit of full source NONE bodies/dispatchers and physical memory identity; STATIC and mathematical transport remain separate. -/\n'
 header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
 header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
  '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
 header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
 target=ROOT/'formal/Source3/KeygenCodecNoneFull074Audit.lean';assert not target.exists()
 target.write_text(header+tail)
 print({'modules':len(MODULES),'new':sum(map(len,groups.values())),'inherited':len(INHERITED)})
if __name__=='__main__':main()
