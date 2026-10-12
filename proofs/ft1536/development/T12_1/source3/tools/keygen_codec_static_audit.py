#!/usr/bin/env python3
"""Generate068's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenCodecStaticCountdown', 'KeygenCodecScalarCalculation', 'KeygenCodecStaticUnaryBit', 'KeygenCodecStaticProfile', 'KeygenCodecStaticUnaryAppend', 'KeygenCodecStaticPending', 'KeygenCodecStaticUnaryInvariant', 'KeygenCodecStaticByte']
INHERITED=['KeygenCodecExecution.Exec', 'KeygenCodecExecution.StoreByte', 'KeygenCodecValues.Eval', 'KeygenCodecValues.Update', 'KeygenCodecValues.Assigned', 'KeygenCodecValues.Args', 'KeygenCodecValues.Load16', 'KeygenCodecStaticBinding.source_bound', 'KeygenCodecStaticBinding.node040_source', 'KeygenCodecStaticBinding.node061_source', 'KeygenCodecStaticBinding.node062_source', 'KeygenCodecStaticBinding.guard087_source', 'KeygenCodecStaticBinding.guard081_source', 'KeygenCodecStaticBinding.node068_source', 'KeygenCodecStaticSuffix.low_append', 'KeygenCodecStaticSuffix.low_shl', 'KeygenCodecStaticSuffix.whole_word_bound_false', 'KeygenCodecStaticAppend.append_low', 'KeygenCodecStaticTerminal.terminal_exit', 'KeygenCodecStaticWindow.static_window']

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
    header+='/- Generated068 full terms for source STATIC unary invariant, profile and local byte content.\n'
    header+='   Internal audit only; full coefficient/outer STATIC invariant, lengths, decoders and public source codecs remain open. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenCodecStaticAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
