#!/usr/bin/env python3
"""Generate the complete BATCH_039 same-material/first-value internal audit."""
from collections import defaultdict
from pathlib import Path
import re

from keygen_public_forward_audit_source import INHERITED as PREVIOUS

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenPublicInputProgram', 'KeygenPublicInputCells', 'KeygenPublicInputAtoms',
    'KeygenPublicInputLoop', 'KeygenPublicInputMaterial', 'KeygenPublicInputSetup',
    'KeygenPublicInputCalls', 'KeygenPublicInputBridge', 'KeygenPublicInputLifetime',
    'KeygenPublicValueExpr', 'KeygenPublicFirstValues', 'KeygenPublicFirstPolynomial']
INHERITED = ['FT1536.Source3.'+n for n in PREVIOUS] + [
    'FT1536.Source3.KeygenPublicForwardWrapper.source_forward_canonical',
    'FT1536.Source3.KeygenPublicForwardWrapper.domain_of_image',
    'FT1536.Source3.KeygenPublicForwardMemory.Block',
    'FT1536.Source3.KeygenPublicForwardMemory.load_block',
    'FT1536.Source3.KeygenPublicForwardMemory.initialized_live',
    'FT1536.Source3.KeygenPublicForwardMemory.allocated_other',
    'FT1536.Source3.KeygenPublicRangeMemory.read_after_store',
    'FT1536.Source3.KeygenPublicRangeMemory.image',
    'FT1536.Source3.KeygenPublicRangeMemory.domain_same_block',
    'FT1536.Source3.KeygenPublicRangeMemory.initialized_same_block',
    'FT1536.Source3.KeygenPublicRangeExpr.word_nat',
    'FT1536.Source3.KeygenPublicRangeExpr.word_argument',
    'FT1536.Source3.KeygenPublicRangeExpr.narrowed_range',
    'FT1536.Source3.KeygenPublicAlgebra.source_conv',
    'FT1536.Source3.KeygenPublicTableCells.stored_load',
    'FT1536.Source3.KeygenPublicTableCells.narrowing',
    'FT1536.Source3.KeygenMaterial.Represents',
    'FT1536.Source3.KeygenIntegerLift.Bound',
    'FT1536.Source3.KeygenSmallOutput.narrowed_exact',
    'FT1536.Source3.KeygenNttLoopSupport.USlot',
    'FT1536.Source3.KeygenNttLoopSupport.plus_u64',
    'FT1536.Source3.KeygenPublicFrame.body',
    'FT1536.Source3.KeygenPublicRoots.firstRoot',
    'FT1536.Source3.KeygenPublicRoots.first_root_relation',
    'FT1536.Source3.KeygenPublicRoots.point_half_power',
    'FT1536.Relation.reduceVec',
    'FT1536.Run2.CoefficientQuotient.polynomial',
    'FT1536.Run2.CoefficientQuotient.coefficient_low',
    'FT1536.Run2.CoefficientQuotient.coefficient_high',
    'FT1536.Run2.CoefficientQuotient.coefficient_outside']


def declarations():
    names = []
    for module in MODULES:
        text = (ROOT/'formal/Source3'/(module+'.lean')).read_text()
        found = re.findall(r'^\s*(?:noncomputable\s+)?(?:def|abbrev|theorem|structure|inductive|instance)\s+(\w+(?:\.\w+)*)', text, re.M)
        assert found and len(found) == len(set(found)), module
        names.extend('FT1536.Source3.'+module+'.'+n for n in found)
    return names


def main():
    assert len(INHERITED) == len(set(INHERITED))
    groups = defaultdict(list)
    for name in declarations():
        namespace, declaration = name.rsplit('.', 1)
        groups[namespace].append(declaration)
    template = (ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT','PUBLIC_INPUT_AUDIT')
    suffix = suffix.replace('    IO.FS.writeFile "../PUBLIC_INPUT_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../PUBLIC_INPUT_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+m+'\n' for m in MODULES)+'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated complete internal039 audit, not independent review. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+namespace+',\n      ['+','.join('"'+n+'"' for n in names)+'])'
        for namespace,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``'+n for n in INHERITED)+']\n'
    (ROOT/'formal/Source3/KeygenPublicInputAudit.lean').write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
