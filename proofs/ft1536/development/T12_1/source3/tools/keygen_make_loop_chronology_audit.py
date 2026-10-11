#!/usr/bin/env python3
"""Generate061's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeInvocation','KeygenMakeLoopChronology']
INHERITED=['KeygenSearchContext.Context',
    'KeygenMakeEntry.input','KeygenMakeEntry.publicPointer','KeygenMakeEntry.Original',
    'KeygenMakeObjects.pointer','KeygenMakeObjects.name','KeygenMakeObjects.count',
    'KeygenMakeObjects.width','KeygenMakeObjects.enter',
    'KeygenMakeArguments.Arguments','KeygenMakeArguments.params','KeygenMakeArguments.values',
    'KeygenMakeArguments.Bind','KeygenMakeArguments.actual_cells','KeygenMakeArguments.bind_exact',
    'KeygenMakeLifetime.close','KeygenMakeLifetime.close_flow','KeygenMakeLifetime.close_object',
    'KeygenMakeLifetime.prefix_empty',
    'KeygenMakeReady.Prefix','KeygenMakeReady.normal_prefix','KeygenMakeReady.gate_normal',
    'KeygenMakePrologue.declared','KeygenMakePrologue.counted','KeygenMakePrologue.sized',
    'KeygenMakePrologue.logged','KeygenMakePrologue.ternary','KeygenMakePrologue.ready',
    'KeygenMakePrologue.middle','KeygenMakePrologue.tailDeclared','KeygenMakePrologue.a0',
    'KeygenMakePrologue.a1','KeygenMakePrologue.a2','KeygenMakePrologue.a3','KeygenMakePrologue.a4',
    'KeygenMakePrologue.a5','KeygenMakePrologue.a6','KeygenMakePrologue.count_result',
    'KeygenMakePrologue.dimensions_result','KeygenMakePrologue.initial',
    'KeygenMakeSearchPrefix.Dimensions','KeygenMakeSearchPrefix.Remaining',
    'KeygenMakeSearchPrefix.Gates','KeygenMakeSearchPrefix.Sampled','KeygenMakeSearchPrefix.close',
    'KeygenMakeSearchPrefix.updated','KeygenMakeSearchPrefix.gates_locals',
    'KeygenMakeSampling.cap_before_setup','KeygenMakeSampling.prepared_slot',
    'KeygenMakeSearchPrefix.prepared_local',
    'KeygenCapWords.advanced',
    'KeygenCapExecution.abortFlow',
    'KeygenCallerInit.rtNames',
    'KeygenCallerPrefix.close','KeygenCallerPrefix.ternary_slots',
    'KeygenAttemptMaterial.PublicGate',
    'KeygenCallerSuccess.RootGate',
    'KeygenRootSource.Call','KeygenRootSource.slots',
    'KeygenRngReference.call_slots',
    'KeygenMakeCertMaterial.LegalWorkspace',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Profile','KeygenMakeCertCall.Call',
    'KeygenMakeCertCall.CertificateGate','KeygenMakeCertCall.gate_cells',
    'KeygenMakeCertCall.profile_of_dimensions','KeygenMakeCertCall.accepted_break_requires_call',
    'KeygenMakeCertChronology.AttemptExec','KeygenMakeCertChronology.AttemptExecution',
    'KeygenMakeCertChronology.LoopTrace','KeygenMakeCertChronology.AttemptAccepted',
    'KeygenMakeCertChronology.attempt_remaining',
    'KeygenMakeCertChronology.successful_loop_last_attempt',
    'KeygenMakeRetryTransport.EntryFrame','KeygenMakeRetryTransport.CertEntryFrame',
    'KeygenMakeRetryTransport.entry_frame_trans','KeygenMakeRetryTransport.attempt_entry',
    'KeygenMakeRetryTransport.initial_of_attempt','KeygenMakeRetryTransport.frame_of_attempt',
    'KeygenMakeStatementMachine.cert_package_of_call',
    'KeygenMakeProgram.encoding','KeygenMakeProgram.varExpr','KeygenMakeProgram.number',
    'KeygenMakeProgram.capacityReturn','KeygenMakeProgram.secretLoop',
    'KeygenMakeProgram.publicDispatch',
    'KeygenEntropySource.Event',
    'CertificateFunctionReference.Arguments','CertificateFunctionSyntax.Bound',
    'CertificateFunctionOutcome.StoredBounds','CertificateFunctionWitness.Witness',
    'CertificateFunctionWitness.layout','CertificateReverse.Snapshot',
    'CertificateEffects.Event','CertificateEffects.Good','CertificateEffects.State',
    'C99Automatic32.pointer','C99MemoryBridge.encode','StableBinaryByteView.flagRead',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99MemoryReference.Load32','C99MemoryReference.Store64',
    'C99ArrayReference.State','C99ArrayReference.Name','C99ArrayReference.bindPointer',
    'C99ArrayReference.bindValue','C99ArrayReference.restoreScope',
    'C99IntegerReference.Value','C99IntegerReference.Ty','C99ScalarReference.set',
    'C99ProcedureReference.Result','C99ProcedureReference.Flow',
    'C99CountedWords.Limit','C99CountedWords.convert_self',
    'C99DeclarationStatements.effect','C99DeclarationCells.declareCells']

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
    header+='/- Generated061 internal full terms. The virtual-map legality class is\n'
    header+='   restricted to the finite live-block set (the 060 all-Nat shape is\n'
    header+='   unsatisfiable and made the encoded branch vacuous); the pointer\n'
    header+='   uniqueness proofs and their consumers are re-checked here. The\n'
    header+='   loop-trace chronology composition of the per-retry transport and the\n'
    header+='   TailCells derivation across rejected attempts complete the exports.\n'
    header+='   Not a review and not a codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeLoopChronologyAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
