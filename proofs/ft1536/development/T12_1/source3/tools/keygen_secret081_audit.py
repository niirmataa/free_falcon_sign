#!/usr/bin/env python3
"""Generate a complete term/type/axiom inventory for assembly step 081."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenSecretBits081', 'KeygenSecretSegment081', 'KeygenSecretPacket081', 'KeygenSecretChain081', 'KeygenSecretPrelude081', 'KeygenSecretObserved081', 'KeygenSecretCallerTrace081', 'KeygenPublicForeign081', 'KeygenPublicSuffixFrame081', 'KeygenSecretTailSource081', 'KeygenSecretLocal081', 'KeygenSecretTailBinding081', 'KeygenSecretInvocation081', 'KeygenOutputMemory081', 'KeygenSecretComplete081', 'KeygenSecretDecodeSource081']
INHERITED = ['KeygenMakeProgram.source_bound', 'KeygenCodecStaticBinding.source_bound', 'KeygenDecodeStaticBinding.source_bound', 'KeygenMakeAssembly080.LegalEntry', 'KeygenMakeInvocation.VirtualLegal', 'KeygenCodecStaticComplete.encoded', 'KeygenInt16Caller076.chain_transport', 'KeygenDecodeStaticComplete.source_outcome', 'KeygenPinnedInvocation080.successful_frontier']

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
    header += '/- Author inventory of complete observed secret packet, source decoders and caller lifetime. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    groups = declarations()
    header += '  let groups : Array (Lean.Name × List String) := #[\n' + ',\n'.join(
        '    (`' + ns + ',[' + ','.join('"' + n + '"' for n in names) + '])'
        for ns, names in groups.items()) + ']\n'
    header += '  let inherited : Array Lean.Name := #[\n' + ',\n'.join(
        '    ``FT1536.Source3.' + n for n in INHERITED) + ']\n'
    target = ROOT / 'formal/Source3/KeygenSecret081Audit.lean'
    with target.open('x') as stream:
        stream.write(header + tail)
    print({'modules': len(MODULES), 'new': sum(map(len, groups.values())), 'inherited': len(INHERITED)})

if __name__ == '__main__':
    main()
