#!/usr/bin/env python3
"""Generate057's complete-term internal audit; not a mathematical review."""
from collections import defaultdict
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
MODULES=['KeygenMakeRetryFrames']
INHERITED=['KeygenSmallSource.Stmt','KeygenSmallSource.Exec','KeygenSmallSource.code',
    'C99ModularFrame.readOnly','C99ModularFrame.source_frame','KeygenSmallOutput.Store16',
    'KeygenSmallStep.reject_result','KeygenOutputGateSource.Context','KeygenOutputGateSource.Condition',
    'KeygenOutputGateSource.condition','KeygenOutputGateSource.Argument','KeygenOutputGateSource.lower',
    'KeygenOutputGateSource.arguments','KeygenOutputGateSource.view','KeygenOutputGateSource.Call',
    'KeygenOutputGateSource.Evaluate','KeygenOutputGateSource.Exec',
    'KeygenOutputGateBounds.Caller','KeygenOutputGateBounds.destinationName',
    'KeygenOutputGateBounds.sourceIndex','KeygenOutputGateBounds.binding_entry',
    'KeygenOutputGateBounds.caller_preserved','KeygenSmallCalls.params',
    'KeygenRootValidation.Entry','KeygenRootValidation.ready_inputs','KeygenRootValidation.ready_caller',
    'KeygenRootValidation.arrays','KeygenRootValidationSource.Exec','KeygenRootValidationSource.Prepare',
    'KeygenRootValidationSource.prepared','KeygenRootValidationSource.generator_entry',
    'KeygenRootValidationSource.ready','KeygenRootValidationSource.returned',
    'KeygenRootValidationSource.genArgs','KeygenLevelCalls.Bind','KeygenLevelCalls.params',
    'KeygenLevelCalls.Kind','KeygenLevelCalls.bind_heap','KeygenResidueTrace.Inputs',
    'KeygenResidueTrace.Arrays','KeygenResidueLoop.source_trace','KeygenResidueLoop.Trace',
    'KeygenMakeMaterialWitness.trace_bytes','KeygenMakeMaterialWitness.output_block',
    'KeygenNttControl.frame','KeygenSolverNttCalls.Caller','KeygenSolverTransforms.Bindings',
    'KeygenSolverTransforms.four_code','KeygenSolverValidation.sequence_frame',
    'KeygenSolverValidation.read_only_heap','KeygenNttMemoryFrame.Frame',
    'KeygenMkgm3Frame.outside_bytes','KeygenMkgm3Frame.source_footprint','KeygenMkgm3Program.code',
    'KeygenSolverTarget.code','KeygenResidueProgram.code','KeygenMemoryStability.Stable',
    'KeygenMemoryStability.modular','KeygenSearchContext.Context','KeygenSearchContext.M0',
    'KeygenSearchContext.ternary_m0','KeygenSearchContext.tmp_value','KeygenRootCaller.Legal',
    'KeygenRootCaller.bound','KeygenRootCaller.bound_entry','KeygenRootCaller.bind_exact',
    'KeygenRootSource.Call','KeygenRootSource.Exec','KeygenRootSource.suffix_entry',
    'KeygenRootSearch.Protected','KeygenRootSearch.Exec','KeygenRootSearch.frame',
    'KeygenRootSearch.output_caller','KeygenRootObjects.search_profile','KeygenRootObjects.gate',
    'KeygenSearchStability.root','KeygenMkgm3Layout.output','KeygenStaticTables.PrimeTable',
    'KeygenNttForwardExec.lognAt','C99ArrayReference.State','C99ArrayReference.Name',
    'C99ArrayReference.bind_heap','C99MemoryReference.Memory','C99MemoryReference.ArrayPointer',
    'C99MemoryReference.PointerAdd','C99IntegerReference.Value','C99ProcedureReference.Result',
    'ShakeExtractFrame.SameBlock','KeygenResidueTrace.names']

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
    header+='/- Generated057 internal full terms. The solver-call frame covers every\n'
    header+='   edge of the solver gate, the rejected edges (early search rejection,\n'
    header+='   partial output-gate writes, zero-return validation) included, keeping\n'
    header+='   the public h bytes. Not a review and not a codec or law claim. -/\n'
    header+='run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header+='  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header+='  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target=ROOT/'formal/Source3/KeygenMakeRetryFramesAudit.lean'
    assert not target.exists(),'Never overwrite an audit producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})

if __name__=='__main__': main()
