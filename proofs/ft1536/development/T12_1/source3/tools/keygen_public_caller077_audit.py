#!/usr/bin/env python3
"""Generate all full terms for the public077 actual caller and observed public packet."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenPublicCallerSite077', 'KeygenPublicPacket077', 'KeygenPublicCallerExecution077', 'KeygenPublicCallerTrace077', 'KeygenPublicObserved077', 'KeygenPublicCallerComplete077']
INHERITED=['KeygenMakeProgram.source_bound','KeygenPublicEncodeBinding077.source_bound','KeygenPublicDecodeBinding077.source_bound','KeygenPublicMath077.from_witness']
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
 header='import Source3.KeygenDecodeWrite16\nimport Source3.KeygenCodecStaticBitInverse\nimport Source3.KeygenDecodeNoneExactFrame\nimport Source3.KeygenPublicNormalizePolynomial\nimport Source3.KeygenInt16Vector076\n'+''.join('import Source3.'+m+'\n' for m in MODULES)
 header+='import Lean.Util.CollectAxioms\n\n'
 header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
 header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
 header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
 header+='/- Complete local public caller header/length/observed-byte proof; whole-root B1.07 assembly remains open. -/\n'
 header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
 header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
  '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
 header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
 target=ROOT/'formal/Source3/KeygenPublicCaller077Audit.lean';assert not target.exists()
 target.write_text(header+tail)
 print({'modules':len(MODULES),'new':sum(map(len,groups.values())),'inherited':len(INHERITED)})
if __name__=='__main__':main()
