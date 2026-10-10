#!/usr/bin/env python3
"""Generate055's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeMaterialWitness']
INHERITED=['KeygenMakeCertMaterial.LegalWorkspace','KeygenMakeCertMaterial.represents_same',
    'KeygenMakeCertMaterial.public_represents_same','KeygenMakeCertMaterial.leave_shape',
    'KeygenMakeCertMaterial.leave_bytes','KeygenMakePublicCall.Material',
    'KeygenMakePublicCall.source_same_material','KeygenMakeWorkspaceTables.foreign_block_retained',
    'KeygenMakeWorkspaceTables.tablesOutside_nonTable','KeygenRootCaller.Legal',
    'KeygenRootCaller.bound','KeygenRootCaller.bind_exact','KeygenRootCaller.bound_entry',
    'KeygenRootCaller.success','KeygenRootSource.Call','KeygenRootSource.Exec',
    'KeygenRootSource.Entry','KeygenRootSource.suffix_entry','KeygenRootValidation.Entry',
    'KeygenRootValidation.arrays','KeygenRootValidation.validation','KeygenRootValidationSource.Exec',
    'KeygenRootSearch.Protected','KeygenRootSearch.frame','KeygenRootSearch.output_caller',
    'KeygenSearchStability.root','KeygenRootObjects.gate','KeygenRootObjects.search_profile',
    'KeygenOutputGateBounds.Caller','KeygenOutputGateBounds.gate_writes',
    'KeygenSmallBounds.Writes','KeygenSmallOutput.element','KeygenSmallOutput.Stored',
    'KeygenSmallOutput.Store16','KeygenResidueTrace.Arrays','KeygenResidueTrace.Writes',
    'KeygenResidueTrace.Inputs','KeygenResidueTrace.slots','KeygenResidueLoop.Trace',
    'KeygenResidueLoop.source_trace','KeygenMkgm3Frame.Outside','KeygenMkgm3Frame.Bindings',
    'KeygenMkgm3Frame.outside_bytes','KeygenMkgm3Frame.source_footprint','KeygenMkgm3.Entry',
    'KeygenMkgm3Layout.output','KeygenMkgm3Layout.gm','KeygenMkgm3Layout.Legal',
    'KeygenMemoryStability.Stable','KeygenMemoryStability.modular','KeygenNttControl.frame',
    'KeygenSolverNttCalls.Caller','KeygenSolverTransforms.Bindings','KeygenSolverTransforms.four_code',
    'KeygenNttMemoryFrame.Frame','KeygenSolverValidation.sequence_frame',
    'KeygenSolverValidation.read_only_heap','KeygenOutputGateValidation.Validation',
    'KeygenOutputGateValidation.material','KeygenSolverEquation.Bounds','KeygenSolverEquation.Equation',
    'KeygenMaterial.Represents','KeygenPublicNormalizePolynomial.Represents',
    'KeygenPublicInputCells.Cell','KeygenIntegerLift.Bound','KeygenAttemptMaterial.Material',
    'KeygenMakeSearchPrefix.Dimensions','KeygenMakeCertCall.Call','KeygenMakeCertCall.CertificateGate',
    'KeygenMakeCertCall.bind_callee_profile','CertificateFunctionOutcome.CallerFrame',
    'CertificateFunctionOutcome.accepted','CertificateFunctionReference.Exec',
    'CertificateFunctionReference.Arguments','CertificateM0Environment.Exec',
    'CertificateRegionFrame.Outside','C99PointerFootprint.TablesOutside','ShakeExtractFrame.SameBlock',
    'C99MemoryReference.Memory','C99MemoryReference.ArrayPointer','KeygenPublicInputMaterial.Legal',
    'KeygenPublicInputLifetime.LiveTables','KeygenPublicFrame.Tables','KeygenMakeProgram.encoding',
    'KeygenMakeProgram.outer','KeygenMakeProgram.attemptedLoop','KeygenMakeProgram.get',
    'KeygenMakeProgram.outer_shape','KeygenMakeProgram.actual_encoder_tail_length',
    'KeygenSearchContext.Context','KeygenCapWords.Count']

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
    header+='/- Generated055 internal full terms. The solver call keeps the h frame\n'
    header+='   and ONE material carries both equations on the same physical f/g/F/G/h,\n'
    header+='   preserved by the accepted certificate call to the encoding-tail input\n'
    header+='   boundary. Not a review and not a codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeMaterialWitnessAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__': main()
