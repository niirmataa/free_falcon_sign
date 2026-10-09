#!/usr/bin/env python3
"""Generate the complete BATCH_038 type/term/constructor/axiom audit."""
from collections import defaultdict
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicRangeMemory', 'KeygenPublicRangeExpr', 'KeygenPublicRangeExec',
           'KeygenPublicForwardProgram', 'KeygenPublicForwardMemory', 'KeygenPublicForwardControl',
           'KeygenPublicForwardCall', 'KeygenPublicForwardRange', 'KeygenPublicForwardWrapper']
INHERITED = [
    'C99MemoryReference.Memory', 'C99MemoryReference.ArrayPointer', 'C99MemoryReference.ArrayPointer.offset',
    'C99MemoryReference.Allocated', 'C99MemoryReference.PointerAdd',
    'C99IntegerReference.Ty', 'C99IntegerReference.Value', 'C99IntegerReference.Value.integer',
    'C99IntegerReference.Value.type', 'C99IntegerReference.convert', 'C99IntegerReference.compare',
    'C99IntegerReference.promote', 'C99IntegerReference.usual', 'C99IntegerReference.ArithmeticExec',
    'C99ScalarReference.Env', 'C99ScalarReference.set', 'C99ScalarReference.boolean',
    'C99ScalarReference.Stmt', 'C99ScalarReference.Exec', 'C99ScalarReference.Eval',
    'C99Frontend.scalar', 'C99Frontend.expression', 'C99Frontend.binary',
    'C99DeclarationCells.declareCells', 'C99DeclarationCells.complete',
    'C99ArrayReference.Name', 'C99ArrayReference.Arg', 'C99ArrayReference.Param', 'C99ArrayReference.State',
    'C99ArrayReference.bindValue', 'C99ArrayReference.bindPointer', 'C99ArrayReference.restoreScope',
    'C99ProcedureReference.Result', 'C99ProcedureReference.Flow', 'C99ProcedureReference.ReturnValue',
    'C99ProcedureParser.zero', 'C99CountedWords.comparison_result',
    'C99NarrowReads.Load16', 'C99NarrowReads.le16', 'C99NarrowReads.unsignedPromotion',
    'C99NarrowReads.unsigned_promotion_exact', 'C99NarrowReads.load16_deterministic',
    'C99NarrowReads.load16_transport', 'KeygenSmallOutput.element', 'KeygenSmallOutput.byte16',
    'KeygenSmallOutput.Stored', 'KeygenSmallOutput.Store16', 'KeygenResidueVectors.join_bytes',
    'KeygenWordExpr.Expr', 'KeygenWordExpr.expression',
    'KeygenPublicScalar.Kind', 'KeygenPublicScalar.Call', 'KeygenPublicScalar.Square', 'KeygenPublicScalar.name',
    'KeygenPublicScalar.params', 'KeygenPublicScalar.lines', 'KeygenPublicScalar.expand',
    'KeygenPublicAlgebra.R', 'KeygenPublicAlgebra.Canonical', 'KeygenPublicAlgebra.value',
    'KeygenPublicAlgebra.source_add', 'KeygenPublicAlgebra.source_sub', 'KeygenPublicAlgebra.call_leaf',
    'KeygenPublicMontgomery.modulus', 'KeygenPublicMontgomery.inverse', 'KeygenPublicMontgomery.word_contract',
    'KeygenPublicArguments.U32', 'KeygenPublicArguments.Conversion', 'KeygenPublicArguments.u32_self',
    'KeygenPublicArguments.call_leaf_conversion', 'KeygenPublicArguments.source_mul_exact',
    'KeygenPublicLeafWords.source_add', 'KeygenPublicLeafWords.source_sub', 'KeygenPublicSquare.source_square_arguments',
    'KeygenPublicWord.Eval', 'KeygenPublicWord.Address', 'KeygenPublicWord.scalar', 'KeygenPublicWord.Bind',
    'KeygenPublicWord.narrow', 'KeygenPublicWord.bind_heap',
    'KeygenPublicExec.Stmt', 'KeygenPublicExec.Exec', 'KeygenPublicExec.Function', 'KeygenPublicExec.Program',
    'KeygenPublicExec.chain', 'KeygenPublicExec.allocated', 'KeygenPublicExec.localPointer',
    'KeygenPublicExec.localEntry', 'KeygenPublicExec.localExit',
    'KeygenPublicParser.Types', 'KeygenPublicParser.body', 'KeygenPublicParser.statement',
    'KeygenPublicSource.Kind', 'KeygenPublicSource.name', 'KeygenPublicSource.code', 'KeygenPublicSource.params',
    'KeygenPublicSource.function', 'KeygenPublicSource.program', 'KeygenPublicSource.types',
    'KeygenPublicSource.signatures', 'KeygenPublicSource.code_checked',
    'KeygenPublicTableAtoms.Slot', 'KeygenPublicTableAtoms.var', 'KeygenPublicTableAtoms.literal',
    'KeygenPublicTableAtoms.variable_value', 'KeygenPublicTableAtoms.literal_value', 'KeygenPublicTableAtoms.literal_argument',
    'KeygenPublicTableIndex.address', 'KeygenPublicTableStore.Pointers', 'KeygenPublicTableStore.Separate',
    'KeygenPublicTableCells.Cell', 'KeygenPublicTableControl.writes', 'KeygenPublicTableControl.supported',
    'KeygenPublicTableControl.frame', 'KeygenPublicTableControl.declare_frame',
    'KeygenPublicTableRows.noReturn', 'KeygenPublicTableRows.normal', 'KeygenPublicUpperLoops.PairCells',
    'KeygenPublicUpperFrames.UpperFrame', 'KeygenPublicUpperFrames.OutsideFull',
    'KeygenPublicUpperImages.source_complete_tables', 'KeygenPublicRoots.root', 'KeygenMkgm3Indices.tableExponent',
    'KeygenRngSource.Fresh', 'KeygenRngSource.disposed', 'ShakeExtractFrame.SameBlock', 'KeygenZintTop.tokens']


def declarations():
    names = []
    for module in MODULES:
        text = (ROOT/'formal/Source3'/(module+'.lean')).read_text()
        found = re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive|instance)\s+(\w+(?:\.\w+)*)', text, re.M)
        assert found and len(found) == len(set(found)), module
        names.extend('FT1536.Source3.'+module+'.'+name for name in found)
    return names


def main():
    assert len(INHERITED) == len(set(INHERITED))
    groups = defaultdict(list)
    for name in declarations():
        namespace, declaration = name.rsplit('.', 1)
        groups[namespace].append(declaration)
    template = (ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'PUBLIC_FORWARD_AUDIT')
    suffix = suffix.replace(
        '    IO.FS.writeFile "../PUBLIC_FORWARD_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_FORWARD_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+module+'\n' for module in MODULES)
    header += 'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated full internal forward-range audit. No independent review or evaluation claim. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+name+'"' for name in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join(
        '    ``FT1536.Source3.'+name for name in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicForwardAudit.lean').write_text(header+suffix)
    print({'proof_modules':len(MODULES),'named_declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
