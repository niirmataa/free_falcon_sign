#!/usr/bin/env python3
"""Generate071's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenCodecPointerFrame', 'KeygenCodecStaticJoint', 'KeygenCodecStaticBudget', 'KeygenCodecStaticOuterHistory', 'KeygenCodecStaticEntry', 'KeygenCodecStaticReadPrefix', 'KeygenCodecStaticReadJoint', 'KeygenCodecStaticMaterial', 'KeygenCodecStaticOuterMaterial', 'KeygenCodecStaticReturnHistory', 'KeygenCodecStaticComplete', 'KeygenCodecStaticCall', 'KeygenCodecStaticCalls']
INHERITED=['KeygenCodecExecution.Exec', 'KeygenCodecExecution.StoreByte', 'KeygenCodecValues.Eval', 'KeygenCodecValues.Update', 'KeygenCodecValues.Assigned', 'KeygenCodecValues.Args', 'KeygenCodecValues.Load16', 'KeygenCodecStaticBinding.source_bound', 'KeygenCodecStaticUnaryInvariant.unary_invariant', 'KeygenCodecStaticUnaryInvariant.unary_low_suffix', 'KeygenCodecStaticUnaryInvariant.finish_low', 'KeygenCodecStaticByte.padded_byte', 'KeygenCodecStaticAppend.append_step', 'KeygenCodecStaticAppend.append_low', 'KeygenCodecStaticSuffix.whole_word_bound_false', 'KeygenCodecStaticWindow.static_window', 'KeygenCodecCellFrame.exec_frame', 'KeygenCodecStateFrame.heap_frame', 'KeygenCodecScalarCalculation.computes_eval', 'KeygenCodecStaticProfile.assignment']

def declarations():
    result=[]
    for module in MODULES:
        text=(ROOT/'formal/Source3'/(module+'.lean')).read_text()
        namespace=re.search(r'^namespace (FT1536\.Source3\.\w+)$',text,re.M).group(1)
        names=re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)',text,re.M)
        assert names and len(names)==len(set(names)),module
        result.extend(namespace+'.'+name for name in names)
    assert len(result)==len(set(result))
    return result

def main():
    groups=defaultdict(list)
    for full in declarations():
        namespace,name=full.rsplit('.',1);groups[namespace].append(name)
    template=(ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix=template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT','SEARCH_AUDIT')
    suffix=suffix.replace('    IO.FS.writeFile "../SEARCH_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header=''.join('import Source3.'+module+'\n' for module in MODULES)
    header+='import Source3.CertificateM0Environment\nimport Lean.Util.CollectAxioms\n\n'
    header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header+='/- Generated071 full terms for complete STATIC histories on original physical input words, all capacity returns and padding.\n'
    header+='   Internal audit only; physical array semantics are source-bound; exact lengths/decoders and vector-to-WORD transport follow, public last. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenCodecCompleteAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
