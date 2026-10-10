#!/usr/bin/env python3
"""Generate the internal049 full-term caller/scope audit, not a review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=(['KeygenMakeSyntax','KeygenMakeTokens','KeygenMakeGrammar',
    'KeygenMakeAtomProbe','KeygenMakeExpressionProbe']+
    ['KeygenMakeBindingPart'+str(i).zfill(2) for i in range(12)]+[
    'KeygenMakeBinding','KeygenMakeProgram','KeygenMakeLifetime'])
INHERITED=['KeygenMakePreprocess.source_partition','KeygenMakePreprocess.make_bound',
    'KeygenMakeObjects.Exec','KeygenMakeObjects.dispose_object','KeygenMakeObjects.dispose_other',
    'KeygenMakePrologue.Declarations','KeygenMakePrologue.allocation_projection',
    'KeygenMakePrologue.count_result','KeygenMakePrologue.dimensions_result',
    'KeygenMakeReady.Prefix','KeygenMakeReady.Gate','KeygenMakeReady.normal_prefix',
    'KeygenMakeReady.failure_result','KeygenMakeReady.normal_prefix_locals','KeygenMakeEntry.Original',
    'KeygenCapWords.Count','KeygenMakeSampling.CappedSetup','KeygenMakeSampling.cap_before_setup',
    'KeygenMakeSampling.no_counter_wrap','KeygenMakeReadySampling.FirstSamples',
    'KeygenMakeReadySampling.source_same_material','KeygenRngReference.Call',
    'KeygenRngReference.call_slots','KeygenReadyResult.call_flags','C99ArrayReference.restoreScope',
    'C99MemoryReference.Load64','C99NarrowReads.Load16','KeygenPublicAccepted.source_same_material',
    'KeygenRootCaller.Legal','KeygenRootCaller.success','CertificateFunctionReference.Arguments',
    'CertificateFunctionReference.Environment','CertificateFunctionReference.Profile',
    'CertificateFunctionReference.Exec','CertificateFunctionReference.initial',
    'CertificateFunctionReference.resolveLayout','CertificateFunctionReference.bad_dead_after_return',
    'CertificateM0Environment.Pinned','CertificateM0Environment.Exec','CertificateM0Environment.stored_words',
    'CertificateFunctionOutcome.accepted']


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
    suffix=template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT','MAKE_AUDIT')
    suffix=suffix.replace('    IO.FS.writeFile "../MAKE_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../MAKE_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header=''.join('import Source3.'+module+'\n' for module in MODULES)
    header+='import Source3.KeygenPublicAccepted\nimport Source3.KeygenRootCaller\nimport Source3.KeygenMakeReadySampling\n'
    header+='import Source3.CertificateM0Environment\nimport Lean.Util.CollectAxioms\n\n'
    header+='set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header+='set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header+='set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header+='/- Generated internal049 complete terms; no independent review or whole-attempt proof. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeAudit.lean'
    assert not target.exists(), 'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__=='__main__':
    main()
