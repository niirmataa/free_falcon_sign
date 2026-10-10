#!/usr/bin/env python3
"""Generate the internal048 full-term readiness audit, not a review."""
from collections import defaultdict
from pathlib import Path
import re

from keygen_make_entry_audit_source import INHERITED as ENTRY_INTERFACES

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['ShakeSeedMemory', 'ShakeSeedProgram', 'ShakeSeedReference',
           'KeygenEntropySource', 'KeygenRngProgram', 'KeygenRngReference',
           'KeygenRngFrame', 'KeygenReadyResult', 'KeygenMakeReady',
           'KeygenMakeReadySampling', 'KeygenRngAdequacy']
INHERITED = ENTRY_INTERFACES + ['KeygenMakeEntry.Original',
    'KeygenMakePrologue.AlreadyReadyPrefix', 'KeygenMakePrologue.Declarations',
    'KeygenMakePrologue.count_result', 'KeygenMakePrologue.dimensions_result',
    'KeygenMakePrologue.prefix_tokens_source', 'KeygenMakePrologue.ready_count',
    'KeygenReadyFast.Read', 'KeygenReadyFast.NotTest', 'KeygenReadyFast.skipped_nonzero',
    'ShakeExtractFrame.Call', 'ShakeExtractSource.Process', 'ShakeExtractSource.Layout',
    'ShakeExtractSource.struct_source', 'ShakePointFrame.call', 'ShakeEncode.Store8']


def declarations():
    result = []
    for module in MODULES:
        text = (ROOT/'formal/Source3'/(module+'.lean')).read_text()
        found = re.findall(r'^(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)', text, re.M)
        assert found and len(found) == len(set(found)), module
        result.extend('FT1536.Source3.'+module+'.'+n for n in found)
    return result


def main():
    groups = defaultdict(list)
    for full in declarations():
        namespace, name = full.rsplit('.', 1)
        groups[namespace].append(name)
    template = (ROOT/'formal/Source3/KeygenLevelsAudit.lean').read_text()
    suffix = template[template.index('  let names := groups.flatMap'):].replace('LEVELS_AUDIT', 'RNG_AUDIT')
    suffix = suffix.replace('    IO.FS.writeFile "../RNG_AUDIT_PARTIAL.json" (Lean.Json.arr rows |>.pretty)',
        '    IO.FS.withFile "../RNG_AUDIT_ENTRIES.jsonl" .append fun stream =>\n'
        '      stream.putStrLn rows.back!.compress')
    header = ''.join('import Source3.'+m+'\n' for m in MODULES)
    header += 'import Source3.KeygenMakePreprocess\nimport Source3.KeygenPublicAccepted\nimport Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Generated internal048 full-term audit; no loop or independent acceptance. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    header += '  let groups : Array (Lean.Name × List String) := #[\n'+',\n'.join(
        '    (`'+ns+',\n      ['+','.join('"'+n+'"' for n in names)+'])' for ns,names in groups.items())+']\n'
    header += '  let inherited : Array Lean.Name := #[\n'+',\n'.join('    ``FT1536.Source3.'+n for n in INHERITED)+']\n'
    target = ROOT/'formal/Source3/KeygenRngAudit.lean'
    assert not target.exists(), 'Never overwrite a historical producer'
    target.write_text(header+suffix)
    print({'modules':len(MODULES),'declarations':len(declarations()),'inherited':len(INHERITED)})


if __name__ == '__main__':
    main()
