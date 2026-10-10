#!/usr/bin/env python3
"""Generate058's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeRetryTransport']
INHERITED=['KeygenSearchContext.Context','KeygenSearchContext.field','KeygenSearchContext.pointerWord',
    'KeygenSearchContext.PointerLegal','KeygenSearchContext.ObjectLegal','KeygenSearchContext.Bound',
    'KeygenSearchContext.M0','KeygenSearchContext.ReadTmp','KeygenSamplerContext.OutsideRng',
    'KeygenSamplerContext.Call','KeygenSamplerContext.context','KeygenCallerEntry.Initial',
    'KeygenCallerEntry.input_not_rt','KeygenCallerTransport.prime_same','KeygenCallerTransport.rev_same',
    'KeygenCallerTransport.sampling_table','KeygenCallerTransport.sampler_locals',
    'KeygenCallerTransport.context_live','KeygenAttemptMaterial.Entry','KeygenAttemptMaterial.PublicGate',
    'KeygenAttemptMaterial.sampling_metadata','KeygenAttemptMaterial.resultants',
    'KeygenAttemptMaterial.sampler_slots','KeygenAttemptMaterial.protected_slots',
    'KeygenAttemptNorm.Protected','KeygenAttemptNorm.bytes','KeygenAttemptNorm.stable',
    'KeygenAttemptSlots.Slots','KeygenAttemptSlots.trans','KeygenResultantGate.bytes',
    'KeygenCallerPrefix.Ternary','KeygenCallerPrefix.close','KeygenCallerPrefix.close_array',
    'KeygenCallerPrefix.ternary_slots','KeygenMakeSearchPrefix.Gates','KeygenMakeSearchPrefix.Sampled',
    'KeygenMakeSearchPrefix.Remaining','KeygenMakeSearchPrefix.updated','KeygenMakeSampling.prepared_initial',
    'KeygenMakeSampling.cap_before_setup','KeygenMakeSampling.entry_from_prepared',
    'KeygenMakeSearchMaterial.root_initial','KeygenMakeSearchMaterial.context_norm',
    'KeygenMakeSearchMaterial.context_public','KeygenPublicSource.Call','KeygenPublicSource.frame',
    'KeygenPublicStability.call','KeygenRootSource.Call','KeygenRootSource.Exec','KeygenRootSource.params',
    'KeygenRootSource.arguments','KeygenRootSource.slots','KeygenRootValidationSource.Exec',
    'KeygenRootValidationSource.Prepare','KeygenRootValidationSource.returned',
    'KeygenRootValidationSource.genArgs','KeygenSolverNttCalls.Exec','KeygenSolverNttCalls.code',
    'KeygenSolverNttCalls.params','KeygenSolverNttCalls.expandArgs','KeygenLevelCalls.Kind',
    'KeygenLevelCalls.params','KeygenLevelCalls.bind_heap','KeygenMemoryStability.Stable',
    'KeygenMemoryStability.refl','KeygenMemoryStability.trans','KeygenMemoryStability.modular',
    'KeygenSearchStability.root','KeygenRootObjects.gate','KeygenMakeRetryFrames.solver_frame',
    'KeygenMakeCertCall.Call','KeygenMakeCertCall.CertificateGate','KeygenMakeCertCall.call_cells',
    'KeygenMakeCertMaterial.leave_shape','KeygenMakeCertChronology.AttemptExec',
    'KeygenMakeCertChronology.attempt_remaining','KeygenMakeAttemptSpine.close_heap',
    'KeygenMakeAttemptSpine.close_tables','KeygenMakeAttemptSpine.public_slots_state',
    'KeygenMakeAttemptSpine.entry_of_allocation','KeygenMakeWorkspaceAllocation.Binding',
    'KeygenMakeWorkspaceAllocation.binding_tmp_load','KeygenMakeWorkspaceAllocation.readTmp_of_binding',
    'KeygenMakeEntry.Original','KeygenMakeEntry.input','KeygenMakeEntry.publicPointer',
    'KeygenMakeReady.Prefix','KeygenEntropySource.Event','KeygenResidueTrace.names',
    'ShakeExtractFrame.SameBlock','ShakePointFrame.trans','Gate00Memory.load32_transport',
    'FftGlobalMemory.environment','KeygenMkgm3Layout.Legal','KeygenMkgm3Layout.aliasCode',
    'KeygenStaticTables.PrimeObject','KeygenMkgm3RevMemory.SourceTable','KeygenNttForwardPrograms.forwardBody',
    'KeygenMkgm3Program.code','KeygenResidueProgram.code','KeygenSolverTarget.code',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99ArrayReference.State','C99ArrayReference.Name',
    'C99ArrayReference.bind_heap','C99ArrayReference.bindPointer','C99IntegerReference.Value',
    'C99ProcedureReference.Result','C99ProcedureReference.Flow','C99ProcedureReference.Stmt']

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
    header+='/- Generated058 internal full terms. The per-retry entry transport of\n'
    header+='   the `Initial`/legal/static facts covers EVERY attempt instance on EVERY\n'
    header+='   return edge, with the gate-time `ReadTmp` tie of the executed `fk->tmp`\n'
    header+='   binding through the same frames. The certificate leg consumes the named\n'
    header+='   `CertEntryFrame` residual (open M0 table-block inversion). Not a review\n'
    header+='   and not a codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeRetryTransportAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
