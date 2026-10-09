#!/usr/bin/env python3
"""Generate BATCH_034 complete types/terms/constructor types/axioms."""
from collections import defaultdict
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicScalarControl', 'KeygenPublicRev', 'KeygenPublicRevCert',
           'KeygenPublicTableAtoms', 'KeygenPublicTableSeed', 'KeygenPublicTableRows',
           'KeygenPublicTableCells']
INHERITED = ['KeygenPublicScalar.Kind', 'KeygenPublicScalar.params', 'KeygenPublicScalar.code',
             'KeygenPublicScalar.Body', 'KeygenPublicScalar.Leaf', 'KeygenPublicScalar.Square',
             'KeygenPublicScalar.Call', 'KeygenPublicSource.code_checked', 'KeygenPublicSource.Call',
             'KeygenPublicSource.program', 'KeygenPublicSource.params', 'KeygenPublicSource.function',
             'KeygenPublicWord.scalar', 'KeygenPublicWord.Eval', 'KeygenPublicWord.Address',
             'KeygenPublicWord.Bind', 'KeygenPublicExec.Stmt', 'KeygenPublicExec.Exec',
             'KeygenPublicParser.statement', 'KeygenPublicParser.body',
             'C99ModularReference.GenEval', 'C99ModularReference.GenExec',
             'C99ModularReference.bindParams', 'C99ScalarReference.Exec', 'C99ScalarReference.Eval',
             'C99ProcedureReference.ReturnValue', 'KeygenPublicAlgebra.source_scaled_product',
             'KeygenPublicArguments.U32', 'KeygenPublicDivisionAlgebra.source_division',
             'KeygenPublicRoots.root_order', 'KeygenPublicRoots.points_distinct',
             'KeygenPublicRoots.coefficient_injective', 'KeygenSmallOutput.Store16',
             'C99NarrowReads.Load16', 'KeygenMkgm3IndexCert.all_indices']


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
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'PUBLIC_TABLES_AUDIT')
    suffix = suffix.replace(
        '    IO.FS.writeFile "../PUBLIC_TABLES_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_TABLES_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+module+'\n' for module in MODULES)
    header += 'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated internal audit; no independent review or table/NTT completion claim. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+name+'"' for name in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join(
        '    ``FT1536.Source3.'+name for name in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicTablesAudit.lean').write_text(header+suffix)
    print({'proof_modules':len(MODULES),'named_declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
