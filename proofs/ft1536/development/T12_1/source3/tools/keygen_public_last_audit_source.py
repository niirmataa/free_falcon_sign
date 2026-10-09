#!/usr/bin/env python3
"""Generate the BATCH_035 complete term/type/constructor/axiom audit."""
from collections import defaultdict
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicTableControl', 'KeygenPublicLastProgram',
           'KeygenPublicTableIndex', 'KeygenPublicTableStore',
           'KeygenPublicLastBody', 'KeygenPublicLastLoop',
           'KeygenPublicLastEntry', 'KeygenPublicLastRow',
           'KeygenPublicUpperProgram', 'KeygenPublicUpperAtoms', 'KeygenPublicUpperBody']
INHERITED = ['KeygenPublicTableRows.source_last_row_entry',
             'KeygenPublicTableRows.remaining', 'KeygenPublicTableRows.afterRows',
             'KeygenPublicTableRows.ready', 'KeygenPublicTableRows.scaled_seeds',
             'KeygenPublicTableSeed.ready', 'KeygenPublicTableSeed.root_scaled',
             'KeygenPublicTableSeed.inverse_scaled', 'KeygenPublicSource.program',
             'KeygenPublicSource.code', 'KeygenPublicSource.code_checked',
             'KeygenPublicScalar.Call', 'KeygenPublicWord.scalar',
             'KeygenPublicWord.Eval', 'KeygenPublicWord.Address',
             'KeygenPublicExec.Stmt', 'KeygenPublicExec.Exec',
             'KeygenPublicRevCert.source_last_index', 'KeygenPublicTableCells.Cell',
             'KeygenPublicTableCells.written_cell', 'KeygenPublicTableCells.preserves_cell',
             'KeygenPublicDivisionAlgebra.Scaled', 'KeygenPublicDivisionAlgebra.scaled_product',
             'KeygenSmallOutput.Store16', 'C99NarrowReads.Load16',
             'KeygenMkgm3IndexCert.all_indices', 'KeygenMkgm3Indices.tableExponent',
             'KeygenMkgm3Table.last_injective', 'KeygenMkgm3Table.last_covers']


def declarations():
    names = []
    for module in MODULES:
        text = (ROOT/'formal/Source3'/(module+'.lean')).read_text()
        found = re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive|instance)\s+(\w+(?:\.\w+)*)', text, re.M)
        assert found and len(found) == len(set(found)), module
        names.extend('FT1536.Source3.'+module+'.'+name for name in found)
    return names


def main():
    groups = defaultdict(list)
    for name in declarations():
        namespace, declaration = name.rsplit('.', 1)
        groups[namespace].append(declaration)
    template = (ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'PUBLIC_LAST_AUDIT')
    suffix = suffix.replace(
        '    IO.FS.writeFile "../PUBLIC_LAST_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_LAST_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+module+'\n' for module in MODULES)
    header += 'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated internal audit; last-row and upper-body scope, not full tables or NTT. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+name+'"' for name in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join(
        '    ``FT1536.Source3.'+name for name in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicLastAudit.lean').write_text(header+suffix)
    print({'proof_modules':len(MODULES),'named_declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
