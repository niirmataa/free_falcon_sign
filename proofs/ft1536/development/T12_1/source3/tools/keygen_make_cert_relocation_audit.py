#!/usr/bin/env python3
"""Generate054's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeCertRelocation']
INHERITED=['KeygenMakeWorkspaceBridge.swapState','KeygenMakeWorkspaceBridge.relocateCtx',
    'KeygenMakeWorkspaceBridge.swapArgs','KeygenMakeWorkspaceBridge.Cells',
    'KeygenMakeWorkspaceBridge.cells_relocated','KeygenMakeWorkspaceBridge.cert_bind_relocated',
    'KeygenMakeWorkspaceAllocation.Binding','KeygenMakeWorkspaceAllocation.AcceptedPackage',
    'KeygenMakeWorkspaceAllocation.accepted_certificate_relocated_of_allocation',
    'KeygenMakeWorkspaceRelocation.swap','KeygenMakeWorkspaceRelocation.swapPtr',
    'KeygenMakeWorkspaceRelocation.swapBlock','KeygenMakeWorkspaceRelocation.swap_swap',
    'KeygenMakeWorkspaceRelocation.swapPtr_swapPtr','KeygenMakeWorkspaceRelocation.swapPtr_zero',
    'KeygenMakeWorkspaceRelocation.swap_zero','KeygenMakeWorkspaceRelocation.swapBlock_self',
    'KeygenMakeWorkspaceRelocation.swapBlock_self_zero','KeygenMakeWorkspaceRelocation.swapBlock_zero',
    'KeygenMakeWorkspaceRelocation.swapBlock_fixed','KeygenMakeWorkspaceRelocation.swap_size',
    'KeygenMakeWorkspaceRelocation.swap_writable','KeygenMakeWorkspaceRelocation.swap_bytes',
    'KeygenMakeWorkspaceRelocation.load64_swap','KeygenMakeWorkspaceRelocation.load32_swap',
    'KeygenMakeWorkspaceRelocation.fprCast_swap','KeygenMakeWorkspaceRelocation.workspacePointer_swap',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Call','KeygenMakeCertCall.CertificateGate',
    'KeygenMakeCertCall.Profile','KeygenMakeCertCall.fprCast','KeygenMakeCertCall.call_cells',
    'KeygenMakeCertCall.call_bit','KeygenMakeCertCall.gate_flow','KeygenMakeCertCall.gate_no_normal',
    'KeygenMakeCertCall.accepted_break_requires_call','KeygenMakeCertCall.retry_requires_call',
    'CertificateM0Environment.Exec','CertificateM0Environment.Pinned',
    'CertificateFunctionReference.Arguments','CertificateFunctionReference.initial',
    'CertificateFunctionOutcome.StoredBounds','CertificateFunctionOutcome.CallerFrame',
    'CertificateFunctionWitness.layout','CertificateWorkspace.layout','CertificateWorkspace.slot',
    'CertificateWorkspace.bytes','CertificateFrameEntry.Legal','CertificateRegionFrame.Outside',
    'CertificateFunctionSyntax.Bound','CertificateEffects.Event','CertificateEffects.Good',
    'CertificateMemory.Layout','CertificateMemory.leaves','C99MemoryReference.Memory',
    'C99MemoryReference.ArrayPointer','C99MemoryReference.ArrayPointer.offset',
    'C99MemoryReference.Allocated','C99MemoryReference.Load64','C99MemoryReference.Load32',
    'C99MemoryReference.Store64','C99MemoryBridge.encode','C99MemoryBridge.load64_source_to_interpreter',
    'C99Automatic32.align4','C99Automatic32.address','C99Automatic32.pointer','C99Automatic32.Space',
    'C99PointerFootprint.TablesOutside','C99ArrayReference.State',
    'StableBinaryByteView.wordRead','StableBinary.addr',
    'KeygenSearchContext.Context','KeygenSearchContext.ReadTmp',
    'KeygenMakeSearchPrefix.Dimensions','KeygenMakeCertChronology.dimensions_cells',
    'KeygenMakeWorkspaceTables.tablesOutside_nonTable','KeygenMakeWorkspaceTables.tablesOutside_zero',
    'FftGlobalMemory.environment','FftGlobalMemory.pointer','FftGlobalMemory.block',
    'FftGlobalMemory.tables','FftTableSources.words','FftTableParser.Table']

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
    header+='/- Generated054 internal full terms. The certificate execution is\n'
    header+='   transported across the block relocation (the sigma conjugate of the\n'
    header+='   pinned block0 machine), and every accepted-package conclusion is read\n'
    header+='   in actual-world scratch-block bytes. Not a review. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeCertRelocationAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__': main()
