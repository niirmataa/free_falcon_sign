#!/usr/bin/env python3
"""Generate060's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeInvocation']
INHERITED=['KeygenSearchContext.Context',
    'KeygenMakeEntry.input','KeygenMakeEntry.publicPointer',
    'KeygenMakeObjects.pointer','KeygenMakeObjects.name','KeygenMakeObjects.count',
    'KeygenMakeObjects.width',
    'KeygenMakeArguments.Arguments','KeygenMakeArguments.params','KeygenMakeArguments.values',
    'KeygenMakeArguments.Bind',
    'KeygenMakeLifetime.close','KeygenMakeLifetime.close_flow','KeygenMakeLifetime.close_object',
    'KeygenMakeLifetime.prefix_empty',
    'KeygenMakeReady.Prefix',
    'KeygenMakeSearchPrefix.Dimensions',
    'KeygenMakeCertMaterial.LegalWorkspace',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Profile','KeygenMakeCertCall.Call',
    'KeygenMakeCertCall.CertificateGate','KeygenMakeCertCall.profile_of_dimensions',
    'KeygenMakeCertCall.accepted_break_requires_call',
    'KeygenMakeCertChronology.AttemptExec','KeygenMakeCertChronology.AttemptExecution',
    'KeygenMakeCertChronology.LoopTrace','KeygenMakeCertChronology.AttemptAccepted',
    'KeygenMakeCertChronology.successful_loop_last_attempt',
    'KeygenMakeStatementMachine.cert_package_of_call',
    'KeygenMakeProgram.encoding','KeygenMakeProgram.varExpr','KeygenMakeProgram.number',
    'KeygenMakeProgram.capacityReturn','KeygenMakeProgram.secretLoop',
    'KeygenMakeProgram.publicDispatch',
    'KeygenCapExecution.abortFlow',
    'KeygenEntropySource.Event',
    'CertificateFunctionReference.Arguments','CertificateFunctionSyntax.Bound',
    'CertificateFunctionOutcome.StoredBounds','CertificateFunctionWitness.Witness',
    'CertificateFunctionWitness.layout','CertificateReverse.Snapshot',
    'CertificateEffects.Event','CertificateEffects.Good','CertificateEffects.State',
    'C99Automatic32.pointer','C99MemoryBridge.encode','StableBinaryByteView.flagRead',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99MemoryReference.Load32','C99MemoryReference.Store64',
    'C99ArrayReference.State','C99ArrayReference.Name','C99ArrayReference.bindPointer',
    'C99IntegerReference.Value','C99IntegerReference.Ty','C99ScalarReference.set',
    'C99ProcedureReference.Result','C99ProcedureReference.Flow']

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
    header+='/- Generated060 internal full terms. The whole-invocation statement-machine\n'
    header+='   execution runs the 18 encoding-tail statements to the actual encoder call\n'
    header+='   sites with their evaluated argument cells, exposes the four output-capacity\n'
    header+='   return-0 edges and closes every return edge with the complete teardown;\n'
    header+='   the certificate package is tied to the same invocation through the accepted\n'
    header+='   gate call. Not a review and not a codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeInvocationAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
