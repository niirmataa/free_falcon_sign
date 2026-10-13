#!/usr/bin/env python3
"""Generate the073 source NONE decoder development audit without modifying072."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenDecodeValues','KeygenDecodeExecution','KeygenDecodeCellFrame',
 'KeygenDecodePointerFrame','KeygenDecodeStateFrame','KeygenDecodeMemory',
 'KeygenDecodeNoneFrame','KeygenDecodePure']
INHERITED=['KeygenDecodeNoneBinding.source_bound','KeygenDecodeNoneScalar.pair_roundtrip',
 'KeygenDecodeNonePairs.segment_roundtrip','KeygenCodecExactLengths.none_source_length']

def declarations():
    result=[]
    for module in MODULES:
        source=(ROOT/'formal/Source3'/(module+'.lean')).read_text()
        namespace=re.search(r'^namespace (FT1536\.Source3\.\w+)$',source,re.M).group(1)
        names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',source,re.M)
        assert names and len(names)==len(set(names)),module
        result.extend((namespace,name) for name in names)
    return result

def main():
    template=(ROOT/'formal/Source3/KeygenCodecLengthsAudit.lean').read_text()
    tail=template[template.index('  let names := groups.flatMap'):]
    groups={}
    for namespace,name in declarations():groups.setdefault(namespace,[]).append(name)
    header=''.join('import Source3.'+m+'\n' for m in MODULES)
    header+='import Source3.KeygenCodecExactLengths\nimport Source3.KeygenDecodeNonePairs\nimport Lean.Util.CollectAxioms\n\n'
    header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header+='/- Author audit of decoder operations and frames only; no round-trip claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
      '    (`'+ns+',['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join(
      '    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenDecodeNoneAudit.lean'
    assert not target.exists(),'Never overwrite a sealed audit producer'
    target.write_text(header+tail)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})
if __name__=='__main__':main()
