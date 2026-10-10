#!/usr/bin/env python3
"""Generate the complete internal BATCH_046 public-equation audit."""
from collections import defaultdict
from pathlib import Path
import re

from keygen_public_reverse_audit_source import INHERITED as OLD, declarations as old_declarations

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicRootInverseProgram', 'KeygenPublicRootInverseValues',
    'KeygenPublicRootInverseFold', 'KeygenPublicRootInversePolynomial',
    'KeygenPublicRootInverseEntry', 'KeygenPublicRootInverseMaterial',
    'KeygenPublicNormalizeProgram', 'KeygenPublicNormalizeAtoms',
    'KeygenPublicNormalizeFold', 'KeygenPublicNormalizeEntry',
    'KeygenPublicNormalizePolynomial', 'KeygenPublicNormalizeMaterial',
    'KeygenPublicEvaluationIso', 'KeygenPublicEquations',
    'KeygenPublicParameterFrames', 'KeygenPublicAccepted']
INHERITED = list(dict.fromkeys(OLD + old_declarations()))


def declarations():
    names = []
    for module in MODULES:
        text = (ROOT/'formal/Source3'/(module+'.lean')).read_text()
        found = re.findall(r'^(?:noncomputable\s+)?(?:def|abbrev|theorem|structure|inductive|instance)\s+(\w+(?:\.\w+)*)', text, re.M)
        assert found and len(found) == len(set(found)), module
        names.extend('FT1536.Source3.'+module+'.'+n for n in found)
    return names


def main():
    groups = defaultdict(list)
    for name in declarations():
        namespace, declaration = name.rsplit('.', 1)
        groups[namespace].append(declaration)
    assert not (set(declarations()) & set(INHERITED))
    template = (ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'PUBLIC_ACCEPTED_AUDIT')
    suffix = suffix.replace('    IO.FS.writeFile "../PUBLIC_ACCEPTED_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_ACCEPTED_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+m+'\n' for m in MODULES)+'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated complete internal046 audit, not independent review. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+n+'"' for n in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``'+n for n in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicAcceptedAudit.lean').write_text(header+suffix)
    print({'modules':len(MODULES), 'named_declarations':len(declarations()), 'inherited_interfaces':len(INHERITED)})


if __name__ == '__main__':
    main()
