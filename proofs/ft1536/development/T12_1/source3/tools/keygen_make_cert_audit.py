#!/usr/bin/env python3
"""Generate051's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeCertCall','KeygenMakeCertChronology','KeygenMakeCertMaterial']
INHERITED=['KeygenMakeCertCall.CertBind.workspace','KeygenMakeSearchPrefix.Sampled',
    'KeygenMakeSearchPrefix.Dimensions','KeygenMakeSearchPrefix.sampled_remaining',
    'KeygenMakeSearchPrefix.exhaustion','KeygenMakeSearchPrefix.gates_locals',
    'KeygenMakeSearchPrefix.gates_flow','KeygenMakeSampling.CappedSetup',
    'KeygenMakeSearchTrace.Numbered','KeygenMakeLocalFrame.fixed','KeygenCapWords.Count',
    'KeygenCapExecution.abortFlow','KeygenAttemptCap.limit',
    'CertificateFunctionReference.Arguments','CertificateFunctionReference.Profile',
    'CertificateFunctionReference.Exec','CertificateFunctionReference.initial',
    'CertificateFunctionReference.resolveLayout','CertificateFunctionFrame.source_frame',
    'CertificateFunctionOutcome.accepted','CertificateFunctionOutcome.CallerFrame',
    'CertificateFunctionOutcome.StoredBounds','CertificateM0Environment.Exec',
    'CertificateM0Environment.Pinned','CertificateM0Environment.stored_words',
    'CertificateFrameEntry.Legal','CertificateFunctionSyntax.Bound',
    'CertificateRegionFrame.Outside','CertificateAfterConversion.workspacePointer',
    'KeygenMaterial.Represents','KeygenPublicNormalizePolynomial.Represents',
    'KeygenPublicInputCells.Cell','KeygenSamplerFrame.represents','ShakeExtractFrame.SameBlock',
    'KeygenMakeSearchMaterial.source_ntru','KeygenMakePublicCall.Material']

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
    header+='/- Generated051 internal full terms. Certificate types are consumed at their pinned\n'
    header+='   interface; the workspace bridge is an explicit open field. Not a review. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeCertAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__': main()
