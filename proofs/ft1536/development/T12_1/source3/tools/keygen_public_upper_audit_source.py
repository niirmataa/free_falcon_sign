#!/usr/bin/env python3
"""Generate the BATCH_036 seal-ceremony complete term/type/constructor/axiom audit.

Scope: the three accepted BATCH_036 modules (whole upper-loop composition and
the exceptional finish core) plus the exact inherited interfaces they consume.
The generated producer is Source3.KeygenPublicUpperAudit (PUBLIC_UPPER_AUDIT).
"""
from collections import defaultdict
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicUpperFrames', 'KeygenPublicUpperLoops', 'KeygenPublicUpperFinish']
INHERITED = ['C99ArrayReference.Name', 'C99ArrayReference.State', 'C99ArrayReference.bindValue',
             'C99IntegerReference.Ty', 'C99IntegerReference.Value', 'C99IntegerReference.Value.integer',
             'C99IntegerReference.convert', 'C99IntegerReference.compare', 'C99IntegerReference.exact',
             'C99IntegerReference.promote', 'C99IntegerReference.usual',
             'C99IntegerReference.ArithmeticExec', 'C99IntegerReference.arithmetic_iff',
             'C99ScalarReference.boolean', 'C99ScalarReference.set',
             'C99CountedWords.comparison_result',
             'C99MemoryReference.Memory', 'C99MemoryReference.ArrayPointer',
             'C99ProcedureReference.Result',
             'C99NarrowReads.Load16', 'C99NarrowReads.unsignedPromotion', 'C99NarrowReads.load16_deterministic',
             'KeygenWordExpr.Expr',
             'KeygenPublicScalar.Call', 'KeygenPublicScalar.name',
             'KeygenPublicWord.Eval', 'KeygenPublicWord.scalar', 'KeygenPublicWord.narrow',
             'KeygenPublicExec.Stmt', 'KeygenPublicExec.Exec', 'KeygenPublicExec.chain',
             'KeygenPublicTableAtoms.Slot', 'KeygenPublicTableAtoms.var', 'KeygenPublicTableAtoms.literal',
             'KeygenPublicTableAtoms.mont', 'KeygenPublicTableAtoms.divide',
             'KeygenPublicTableAtoms.literal_value', 'KeygenPublicTableAtoms.variable_value',
             'KeygenPublicTableAtoms.assign_result', 'KeygenPublicTableAtoms.slot_after',
             'KeygenPublicTableIndex.literal', 'KeygenPublicTableIndex.word64', 'KeygenPublicTableIndex.address',
             'KeygenPublicTableControl.seq_inv', 'KeygenPublicTableControl.supported',
             'KeygenPublicTableControl.writes', 'KeygenPublicTableControl.frame',
             'KeygenPublicTableControl.assign_heap',
             'KeygenPublicTableStore.Word', 'KeygenPublicTableStore.Pointers', 'KeygenPublicTableStore.Separate',
             'KeygenPublicTableStore.LastFrame', 'KeygenPublicTableStore.pointers_after',
             'KeygenPublicTableCells.Cell', 'KeygenPublicTableCells.promoted_cell',
             'KeygenSmallOutput.Store16', 'KeygenSmallOutput.element',
             'KeygenNttLoopSupport.USlot', 'KeygenNttLoopSupport.u64', 'KeygenNttLoopSupport.u64_integer',
             'KeygenNttLoopSupport.convert_u64_self', 'KeygenNttLoopSupport.convert_u64_nat',
             'KeygenNttLoopSupport.add_one_literal',
             'KeygenNttForwardExec.shift_left_value',
             'KeygenModpAddSub.result',
             'KeygenPublicAlgebra.R', 'KeygenPublicAlgebra.value', 'KeygenPublicAlgebra.Canonical',
             'KeygenPublicAlgebra.radix', 'KeygenPublicAlgebra.call_leaf', 'KeygenPublicAlgebra.source_add',
             'KeygenPublicAlgebra.source_sub', 'KeygenPublicAlgebra.radix_inverse',
             'KeygenPublicMontgomery.modulus',
             'KeygenPublicArguments.U32', 'KeygenPublicArguments.u32_self',
             'KeygenPublicArguments.u32_literal', 'KeygenPublicArguments.call_leaf_conversion',
             'KeygenPublicLeafWords.source_add', 'KeygenPublicLeafWords.source_sub',
             'KeygenPublicDivisionAlgebra.Scaled', 'KeygenPublicDivisionAlgebra.normalize_call',
             'KeygenPublicDivisionAlgebra.division_power', 'KeygenPublicDivisionAlgebra.nonzero_value',
             'KeygenPublicDivisionWords.division', 'KeygenPublicDivisionWords.source_exact',
             'KeygenPublicRoots.root', 'KeygenPublicRoots.firstRoot', 'KeygenPublicRoots.first_root_relation',
             'KeygenMkgm3Indices.tableExponent', 'KeygenMkgm3Layout.DisjointBytes',
             'KeygenPublicSource.program', 'KeygenPublicSource.code',
             'KeygenPublicLastEntry.assign64_result', 'KeygenPublicLastEntry.bind_heap',
             'KeygenPublicLastEntry.size_one',
             'KeygenPublicLastRow.source_last_row',
             'KeygenPublicUpperProgram.u', 'KeygenPublicUpperProgram.doubleU',
             'KeygenPublicUpperProgram.cubeBody', 'KeygenPublicUpperProgram.powerK',
             'KeygenPublicUpperProgram.upper', 'KeygenPublicUpperProgram.cubeCondition',
             'KeygenPublicUpperProgram.cubeIncrement', 'KeygenPublicUpperProgram.cubeLoop',
             'KeygenPublicUpperProgram.squareBody', 'KeygenPublicUpperProgram.squareCondition',
             'KeygenPublicUpperProgram.squareIncrement', 'KeygenPublicUpperProgram.squareLoop',
             'KeygenPublicUpperProgram.initK', 'KeygenPublicUpperProgram.initCube',
             'KeygenPublicUpperProgram.initSquare', 'KeygenPublicUpperProgram.finish',
             'KeygenPublicUpperProgram.afterRows',
             'KeygenPublicUpperAtoms.declaration_heap', 'KeygenPublicUpperAtoms.index_value',
             'KeygenPublicUpperBody.PairCell', 'KeygenPublicUpperBody.RowUpdate',
             'KeygenPublicUpperBody.counter_after', 'KeygenPublicUpperBody.cube_body',
             'KeygenPublicUpperBody.square_body']


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
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'PUBLIC_UPPER_AUDIT')
    suffix = suffix.replace(
        '    IO.FS.writeFile "../PUBLIC_UPPER_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_UPPER_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+module+'\n' for module in MODULES)
    header += 'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated BATCH_036 seal-ceremony audit; whole upper loops and the exceptional\n'
    header += '   finish core. Inherited interfaces are audited at their exact consumed names. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+name+'"' for name in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join(
        '    ``FT1536.Source3.'+name for name in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicUpperAudit.lean').write_text(header+suffix)
    print({'proof_modules':len(MODULES),'named_declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
