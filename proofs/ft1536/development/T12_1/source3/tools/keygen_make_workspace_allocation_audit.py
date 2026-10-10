#!/usr/bin/env python3
"""Generate053's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeWorkspaceAllocation']
INHERITED=['KeygenMakeWorkspaceBridge.Shape','KeygenMakeWorkspaceBridge.Cells',
    'KeygenMakeWorkspaceBridge.cert_bind_of_source','KeygenMakeWorkspaceBridge.cert_bind_relocated',
    'KeygenMakeWorkspaceBridge.relocateCtx','KeygenMakeWorkspaceBridge.swapState',
    'KeygenMakeWorkspaceBridge.swapArgs','KeygenMakeWorkspaceBridge.legalWorkspace_of_shape',
    'KeygenMakeWorkspaceBridge.accepted_certificate_source',
    'KeygenMakeWorkspaceExtent.candidates','KeygenMakeWorkspaceExtent.candidates_fold_max',
    'KeygenMakeWorkspaceExtent.cert_candidate_value','KeygenMakeWorkspaceExtent.reservation_matches_workspace',
    'KeygenMakeWorkspaceRelocation.extent','KeygenMakeWorkspaceRelocation.extent_swapPtr',
    'KeygenMakeWorkspaceRelocation.swap','KeygenMakeWorkspaceRelocation.swapPtr',
    'KeygenMakeWorkspaceRelocation.swap_size','KeygenMakeWorkspaceRelocation.swap_writable',
    'KeygenMakeWorkspaceRelocation.swapPtr_block','KeygenMakeWorkspaceRelocation.swapPtr_base',
    'KeygenMakeWorkspaceRelocation.swapPtr_count','KeygenMakeWorkspaceRelocation.swapPtr_elementBytes',
    'KeygenMakeWorkspaceRelocation.swapPtr_index','KeygenMakeWorkspaceRelocation.swapPtr_offset',
    'KeygenMakeWorkspaceRelocation.swapBlock_self','KeygenMakeWorkspaceRelocation.relocated_scratch_block',
    'KeygenMakeCertCall.CertBind','KeygenMakeCertCall.Call','KeygenMakeCertCall.fprCast',
    'KeygenMkgm3Layout.Legal','KeygenMkgm3Layout.scratchWords',
    'CertificateWorkspace.bytes','CertificateWorkspace.workspace_size',
    'KeygenRngSource.Fresh','KeygenMakeObjects.allocated',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer',
    'C99MemoryReference.ArrayPointer.offset','C99MemoryReference.Allocated',
    'C99MemoryReference.Load64','C99MemoryReference.Store64',
    'C99MemoryReference.le64','C99MemoryReference.byte64',
    'KeygenSearchContext.Context','KeygenSearchContext.field','KeygenSearchContext.pointerWord',
    'KeygenSearchContext.Bound','KeygenSearchContext.ObjectLegal','KeygenSearchContext.PointerLegal',
    'KeygenSearchContext.ReadTmp',
    'CertificateFunctionReference.Arguments','CertificateM0Environment.Exec',
    'CertificateFunctionOutcome.StoredBounds','CertificateFunctionOutcome.CallerFrame',
    'CertificateFunctionSyntax.Bound','CertificateEffects.Event','CertificateEffects.Good',
    'FftGlobalMemory.environment','KeygenMakeCertMaterial.LegalWorkspace',
    'KeygenMakeSearchPrefix.Dimensions','C99Automatic32.Space','C99Automatic32.pointer',
    'Pinned.keygenLines']

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
    header+='/- Generated053 internal full terms. The workspace Shape and the scratch\n'
    header+='   legality frame are DERIVED from the allocation execution (temp_size store\n'
    header+='   + fk->tmp malloc binding); certificate interfaces are consumed at their\n'
    header+='   pinned types. Not a review. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeWorkspaceAllocationAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__': main()
