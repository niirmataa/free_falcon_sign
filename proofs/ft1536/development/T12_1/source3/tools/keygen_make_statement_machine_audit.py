#!/usr/bin/env python3
"""Generate059's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeStatementMachine']
INHERITED=['KeygenSearchContext.Context','KeygenSearchContext.field','KeygenSearchContext.pointerWord',
    'KeygenSearchContext.M0','KeygenSearchContext.ReadTmp','KeygenSearchContext.ObjectLegal',
    'KeygenCallerEntry.Initial','KeygenMakeEntry.Original','KeygenMakeEntry.input',
    'KeygenMakeEntry.publicPointer','KeygenMakeEntry.input_width','KeygenMakeEntry.object_live',
    'KeygenMakeEntry.scratch_live','KeygenMakeObjects.pointer','KeygenMakeObjects.count',
    'KeygenMakeObjects.width','KeygenMakeObjects.extent','KeygenMakeObjects.Block',
    'KeygenMakeObjects.Exec','KeygenMakeObjects.object','KeygenMakeObjects.allocated_object',
    'KeygenMakeObjects.fresh_separate','KeygenMakeObjects.slots','KeygenMakeObjects.live_frame',
    'KeygenRngSource.Fresh','KeygenRngReference.call_slots',
    'KeygenMakePrologue.Declarations','KeygenMakePrologue.declared','KeygenMakePrologue.counted',
    'KeygenMakePrologue.sized','KeygenMakePrologue.ready','KeygenMakePrologue.projectionStart',
    'KeygenMakePrologue.allocation_projection','KeygenMakePrologue.projection_original',
    'KeygenMakePrologue.initial','KeygenMakePrologue.count_result',
    'KeygenMakePrologue.dimensions_result','KeygenMakeReady.Prefix','KeygenMakeReady.Gate',
    'KeygenMakeReady.gate_normal','KeygenMakeReady.block_frame','KeygenMakeReady.normal_prefix',
    'KeygenPublicInputMaterial.Legal','KeygenPublicFrame.Tables','KeygenPublicFrame.Outside',
    'KeygenRootSearch.Protected','KeygenMakeSearchPrefix.Dimensions','KeygenMakeSearchPrefix.Remaining',
    'KeygenMakeAttemptSpine.EntryFacts','KeygenMakeAttemptSpine.entry_of_allocation',
    'KeygenMakeRetryTransport.EntryFrame','KeygenMakeRetryTransport.CertEntryFrame',
    'KeygenMakeRetryTransport.cert_gate_entry','KeygenMakeRetryTransport.cert_shape',
    'KeygenMakeWorkspaceAllocation.Binding','KeygenMakeWorkspaceAllocation.scratchOf',
    'KeygenMakeWorkspaceAllocation.scratch_count','KeygenMakeWorkspaceAllocation.scratch_offset',
    'KeygenMakeWorkspaceAllocation.scratch_extent','KeygenMakeWorkspaceAllocation.tempSize_exact',
    'KeygenMakeWorkspaceAllocation.tempSize_workspace',
    'KeygenMakeWorkspaceAllocation.binding_tmp_load',
    'KeygenMakeWorkspaceAllocation.readTmp_of_binding',
    'KeygenMakeWorkspaceAllocation.cert_bind_relocated_of_allocation',
    'KeygenMakeWorkspaceRelocation.extent','KeygenMakeWorkspaceRelocation.extent_swapPtr',
    'KeygenMakeWorkspaceRelocation.bridge_iff','KeygenMakeWorkspaceRelocation.bridge_relocated',
    'KeygenMakeWorkspaceRelocation.bridge_of_extent','KeygenMakeWorkspaceRelocation.swapPtr',
    'KeygenMakeWorkspaceRelocation.swapBlock','KeygenMakeWorkspaceRelocation.swapPtr_block',
    'KeygenMakeWorkspaceRelocation.swapPtr_offset','KeygenMakeWorkspaceRelocation.swap_zero',
    'KeygenMakeWorkspaceRelocation.swap_swap','KeygenMakeWorkspaceRelocation.fprCast_swap',
    'KeygenMakeWorkspaceBridge.Cells','KeygenMakeWorkspaceBridge.swapState',
    'KeygenMakeWorkspaceBridge.relocateCtx','KeygenMakeWorkspaceBridge.swapArgs',
    'KeygenMakeWorkspaceBridge.cert_bind_relocated',
    'KeygenMakeWorkspaceTables.tables_block','KeygenMakeWorkspaceTables.tablesOutside_nonTable',
    'KeygenMakeWorkspaceTables.tablesOutside_zero','KeygenMakeWorkspaceTables.foreign_block_retained',
    'KeygenMakeWorkspaceExtent.candidates_fold_max','KeygenMakeWorkspaceExtent.workspace_extent_value',
    'KeygenMakeWorkspaceExtent.reservation_matches_workspace',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Profile','KeygenMakeCertCall.Call',
    'KeygenMakeCertCall.CertificateGate','KeygenMakeCertCall.fprCast',
    'KeygenMakeCertCall.bind_callee_profile','KeygenMakeCertCall.call_cells',
    'KeygenMakeCertCall.accepted_break_requires_call','KeygenMakeCertCall.retry_requires_call',
    'KeygenMakeCertCall.args_shape','KeygenMakeCertMaterial.LegalWorkspace',
    'KeygenMakeCertMaterial.workspace_scratch_block','KeygenMakeCertMaterial.leave_shape',
    'KeygenMakeCertMaterial.leave_bytes','KeygenMakeCertRelocation.ExecAt',
    'KeygenMakeCertRelocation.CallAt','KeygenMakeCertRelocation.CertBindAt',
    'KeygenMakeCertRelocation.callAt_run','KeygenMakeCertRelocation.certBindAt_iff',
    'KeygenMakeCertRelocation.pinned_swap','KeygenMakeCertRelocation.AcceptedPackageAt',
    'KeygenMakeCertRelocation.accepted_package_at','CertificateM0Environment.Pinned',
    'CertificateM0Environment.Exec','FftGlobalMemory.block','FftGlobalMemory.pointer',
    'FftGlobalMemory.tables','FftGlobalMemory.environment','FftTableParser.Table',
    'FftTableParser.rowCount','FftTableSources.words','FftTableSources.words_length',
    'CertificateFunctionReference.Arguments','CertificateFunctionReference.Profile',
    'CertificateFunctionReference.initial','CertificateFunctionWitness.Witness',
    'CertificateFunctionWitness.layout','CertificateFunctionSyntax.Bound',
    'CertificateFunctionFrame.source_frame','CertificateFunctionOutcome.StoredBounds',
    'CertificateFunctionOutcome.CallerFrame','CertificateFunctionOutcome.accepted',
    'CertificateFunctionOutcome.reverse_source','CertificateReverse.Snapshot',
    'CertificateEffects.Event','CertificateEffects.Good','CertificateEffects.State',
    'CertificateWorkspace.bytes','CertificateAfterConversion.workspacePointer',
    'CertificateFrameEntry.Legal','CertificateRegionFrame.Outside',
    'C99PointerFootprint.TablesOutside','C99Automatic32.pointer','C99MemoryBridge.encode',
    'StableBinaryByteView.flagRead','ShakeExtractFrame.SameBlock',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99MemoryReference.Load32','C99MemoryReference.Store64',
    'C99ArrayReference.State','C99ArrayReference.Name','C99ArrayReference.bindPointer',
    'C99IntegerReference.Value','C99ProcedureReference.Result','C99ProcedureReference.Flow',
    'C99ProcedureReference.Stmt','KeygenEntropySource.Event','KeygenResidueTrace.names',
    'KeygenMaterial.Represents','KeygenPublicNormalizePolynomial.Represents']

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
    header+='/- Generated059 internal full terms. The statement-machine extraction ties\n'
    header+='   the C call site `(fpr *)fk->tmp` to `ExecAt` through the `temp_size` body\n'
    header+='   and the `falcon_keygen_new` prologue binding, discharges the b-not-1/2\n'
    header+='   side condition from allocation freshness and closes `call_same_block` with\n'
    header+='   the EntryFacts/CertEntryFrame residual discharges. Not a review and not a\n'
    header+='   codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeStatementMachineAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__':
    main()
