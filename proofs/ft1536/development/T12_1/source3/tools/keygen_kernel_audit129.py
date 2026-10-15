#!/usr/bin/env python3
"""Full DAG roundtrip with explicit kernel type checking at unchanged limits."""
from pathlib import Path
import re
import sys
import keygen_whole088_audit as standard

root = Path(__file__).resolve().parents[1]
audit_name, *modules = sys.argv[1:]
assert modules and all(re.fullmatch(r'[A-Za-z][A-Za-z0-9_]*', value) for value in [audit_name, *modules])
names = standard.declarations(modules)
assert len(names) == len(set(names))
template = (root / 'formal/Source3/KeygenLaw087Audit.lean').read_text()
template = re.sub(r'\A(?:import [^\n]+\n)+', ''.join(f'import Source3.{m}\n' for m in modules), template)
template = re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
    lambda m: m[1] + '\n' + ',\n'.join('    ``' + n for n in names) + m[2], template, flags=re.S)
old_start = '  let mut rows : Array Lean.Json := #[]'
new_start = '  IO.FS.writeFile "../SEARCH_AUDIT.json" "[\\n"\n  let mut firstRow := true'
assert template.count(old_start) == 1
template = template.replace(old_start, new_start)
old_row = '''    rows := rows.push (Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),("type",Lean.toJson (← render info.type)),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))])
    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn rows.back!.compress
  IO.FS.writeFile "../SEARCH_AUDIT.json" (Lean.Json.arr rows |>.pretty)'''
new_row = '''    let row := Lean.Json.mkObj [
      ("name",Lean.toJson name.toString),("type",Lean.toJson (← render info.type)),
      ("body",body),("axioms",Lean.toJson (axes.map Lean.Name.toString))]
    let encoded := row.compress
    IO.FS.withFile "../SEARCH_AUDIT_ENTRIES.jsonl" .append fun stream =>
      stream.putStrLn encoded
    let separator := if firstRow then "" else ",\\n"
    IO.FS.withFile "../SEARCH_AUDIT.json" .append fun stream => do
      stream.putStr separator
      stream.putStr encoded
    firstRow := false
  IO.FS.withFile "../SEARCH_AUDIT.json" .append fun stream =>
    stream.putStr "\\n]\\n"'''
assert template.count(old_row) == 1
template = template.replace(old_row, new_row)
old_type_check = '\n'.join([
    '          unless ← Lean.Meta.isDefEq (← Lean.Meta.inferType restored) info.type do',
    '            throwError "Expression roundtrip changed the type: {name}"'])
new_type_check = '\n'.join([
    '          let opts ← Lean.getOptions',
    '          if Lean.debug.skipKernelTC.get opts then throwError "Kernel checking must stay enabled"',
    '          let checkedName := Lean.Name.str name "_roundtrip_checked_129"',
    '          let declaration : Lean.Declaration := .defnDecl {',
    '            name := checkedName',
    '            levelParams := info.levelParams',
    '            type := info.type',
    '            value := restored',
    '            hints := .abbrev',
    '            safety := .safe }',
    '          discard <| Lean.ofExceptKernelException <|',
    '            (← Lean.getEnv).toKernelEnv.addDecl opts declaration none'])
template='import Lean.AddDecl\n'+template
assert template.count(old_type_check)==1
template=template.replace(old_type_check,new_type_check)
template=template.replace('("roundtrip_term_and_type_checked",Lean.toJson true)',
    '("roundtrip_term_and_type_checked",Lean.toJson true),' +
    '("type_check",Lean.toJson "kernel checked fresh safe definition at original declared type; original options/limits; result environment discarded")')
target = root / 'formal/Source3' / f'{audit_name}.lean'
if target.exists():
    assert target.read_text() == template, 'Audit reproduction mismatch'
else:
    target.write_text(template)
print(f'{audit_name}: {len(names)} full declarations; explicit kernel type check with original options/limits')
