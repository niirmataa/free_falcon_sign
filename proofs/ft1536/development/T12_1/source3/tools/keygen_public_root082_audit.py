#!/usr/bin/env python3
"""Generate a complete term/type/axiom inventory for assembly step 082."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenExternalSampling082', 'KeygenExternalGates082', 'KeygenExternalLoop082', 'KeygenPublicEntry082', 'KeygenPublicPrivateBridge082', 'KeygenPublicComplete082']
INHERITED = ['KeygenPublicEncodeBinding077.source_bound', 'KeygenPublicDecodeBinding077.source_bound', 'KeygenPublicCallerComplete077.observed_output', 'KeygenSecretComplete081.observed_secret', 'KeygenSecretInvocation081.PinnedExec', 'KeygenMakeAssembly080.LegalEntry', 'KeygenOutputMemory081.Legal', 'KeygenPublicPacket077.DecodePublic', 'KeygenPublicObserved077.ObservedPublic']

def declarations():
    result = {}
    for module in MODULES:
        source = (ROOT / 'formal/Source3' / (module + '.lean')).read_text()
        namespace = re.search(r'^namespace (FT1536\.Source3\.\w+)$', source, re.M).group(1)
        names = re.findall(r'^\s*(?:def|abbrev|theorem|structure|inductive)\s+(\w+(?:\.\w+)*)', source, re.M)
        assert names and len(names) == len(set(names))
        for dotted in names:
            parts = dotted.split('.')
            actual_namespace = '.'.join([namespace] + parts[:-1])
            result.setdefault(actual_namespace, []).append(parts[-1])
    return result

def main():
    template = (ROOT / 'formal/Source3/KeygenDecodeNoneAudit.lean').read_text()
    tail = template[template.index('  let names := groups.flatMap'):]
    header = ''.join('import Source3.' + module + '\n' for module in MODULES)
    header += 'import Lean.Util.CollectAxioms\n\n'
    header += 'set_option maxRecDepth 32768\nset_option maxHeartbeats 2000000\n'
    header += 'set_option pp.proofs true\nset_option pp.deepTerms true\nset_option pp.fullNames true\n'
    header += 'set_option pp.universes true\nset_option pp.maxSteps 200000\n\n'
    header += '/- Author inventory of root public input transport and joint observed key output. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    groups = declarations()
    header += '  let groups : Array (Lean.Name × List String) := #[\n' + ',\n'.join(
        '    (`' + ns + ',[' + ','.join('"' + n + '"' for n in names) + '])'
        for ns, names in groups.items()) + ']\n'
    header += '  let inherited : Array Lean.Name := #[\n' + ',\n'.join(
        '    ``FT1536.Source3.' + n for n in INHERITED) + ']\n'
    target = ROOT / 'formal/Source3/KeygenPublicRoot082Audit.lean'
    with target.open('x') as stream:
        stream.write(header + tail)
    print({'modules': len(MODULES), 'new': sum(map(len, groups.values())), 'inherited': len(INHERITED)})

if __name__ == '__main__':
    main()
