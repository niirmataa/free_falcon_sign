#!/usr/bin/env python3
"""Generate all full terms for the public077 source foundation and complete encoder."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenPublicBits077', 'KeygenPublicDecodeBinding077Part00', 'KeygenPublicDecodeBinding077Part01', 'KeygenPublicDecodeBinding077Part02', 'KeygenPublicDecodeSource077', 'KeygenPublicDecodeBinding077', 'KeygenPublicDecodeExecution077', 'KeygenPublicDecodeAssignments077', 'KeygenPublicDecodeCellFrame077', 'KeygenPublicDecodeCertified077', 'KeygenPublicDecodeCertifiedLoop077', 'KeygenPublicDecodeStateFrame077', 'KeygenPublicDecodeStore077', 'KeygenPublicEncodeValues077', 'KeygenPublicEncodeBinding077Part00', 'KeygenPublicEncodeBinding077Part01', 'KeygenPublicEncodeBinding077Part02', 'KeygenPublicEncodeSource077', 'KeygenPublicEncodeBinding077', 'KeygenPublicEncodeExecution077', 'KeygenPublicEncodeCellFrame077', 'KeygenPublicEncodeStateFrame077', 'KeygenPublicEncodePure077', 'KeygenPublicEncodeDynamic077', 'KeygenPublicEncodeAssignments077', 'KeygenPublicEncodeCertified077', 'KeygenPublicEncodeStore077', 'KeygenPublicInteger077', 'KeygenPublicEncodeReady077', 'KeygenPublicEncodeAppend077', 'KeygenPublicEncodePrepare077', 'KeygenPublicEncodeByteCalc077', 'KeygenPublicEncodeCertifiedLoop077', 'KeygenPublicEncodeEmit077', 'KeygenPublicEncodeDrainStep077', 'KeygenPublicEncodeDrain077', 'KeygenPublicEncodeSequence077', 'KeygenPublicEncodeIteration077', 'KeygenPublicEncodeLoop077', 'KeygenPublicEncodePrologue077', 'KeygenPublicEncodeComplete077', 'KeygenPublicStream077']
INHERITED=['KeygenCodecStaticMaterial.Words','KeygenDecodeNoneMemory.Trace','KeygenPublicNormalizePolynomial.Represents','KeygenInt16Vector076.signedEquiv']
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
 header+='/- Full public encoder/source foundation audit; public decoder and caller assembly remain open. -/\n'
 header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
 header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
  '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
 header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
 target=ROOT/'formal/Source3/KeygenPublicEncoder077Audit.lean';assert not target.exists()
 target.write_text(header+tail)
 print({'modules':len(MODULES),'new':sum(map(len,groups.values())),'inherited':len(INHERITED)})
if __name__=='__main__':main()
