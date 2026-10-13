#!/usr/bin/env python3
"""Generate a complete term/type/axiom inventory for assembly whole assembly079-083."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
MODULES = ['KeygenAcceptedMaterial079', 'KeygenAcceptedLoop079', 'KeygenSerializationEntry079', 'KeygenAttemptSerialization079', 'KeygenCertificateReadonly080', 'KeygenCertificateReachable080', 'KeygenCertificateAt080', 'KeygenAcceptedLoop080', 'KeygenAttemptSerialization080', 'KeygenPrecertificate080', 'KeygenAttemptAt080', 'KeygenRetryAt080', 'KeygenLoopAt080', 'KeygenCertificateOccurrence080', 'KeygenLoopMaterial080', 'KeygenEntryAt080', 'KeygenTailCellsAt080', 'KeygenSameCertificate080', 'KeygenMakeAssembly080', 'KeygenCertificateSource080', 'KeygenPinnedInvocation080', 'KeygenSecretBits081', 'KeygenSecretSegment081', 'KeygenSecretPacket081', 'KeygenSecretChain081', 'KeygenSecretPrelude081', 'KeygenSecretObserved081', 'KeygenSecretCallerTrace081', 'KeygenPublicForeign081', 'KeygenPublicSuffixFrame081', 'KeygenSecretTailSource081', 'KeygenSecretLocal081', 'KeygenSecretTailBinding081', 'KeygenSecretInvocation081', 'KeygenOutputMemory081', 'KeygenSecretComplete081', 'KeygenSecretDecodeSource081', 'KeygenExternalSampling082', 'KeygenExternalGates082', 'KeygenExternalLoop082', 'KeygenPublicEntry082', 'KeygenPublicPrivateBridge082', 'KeygenPublicComplete082', 'KeygenEmittedFiber083']
INHERITED = ['FT1536.Source3.KeygenMakeProgram.source_bound', 'FT1536.Source3.KeygenCodecStaticBinding.source_bound', 'FT1536.Source3.KeygenDecodeStaticBinding.source_bound', 'FT1536.Source3.KeygenPublicEncodeBinding077.source_bound', 'FT1536.Source3.KeygenPublicDecodeBinding077.source_bound', 'FT1536.Source3.KeygenMakeEntry.Original', 'FT1536.Source3.KeygenMakeInvocation.VirtualLegal', 'FT1536.Source3.KeygenMakeMaterialWitness.Witness', 'FT1536.Source3.KeygenInt16Caller076.chain_transport', 'FT1536.Source3.KeygenDecodeStaticComplete.source_outcome', 'FT1536.Source3.KeygenPublicCallerComplete077.observed_output', 'FT1536.Source3.FftGlobalMemory.environment', 'FT1536.Source3.CertificateFunctionReference.Exec', 'FT1536.Run2.ActualNTRUFiber.coordinates_formula', 'FT1536.Run2.ActualNTRUFiber.gaussian_fiber_in_basis']

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
    header += '/- Coherent full audit of all new assembly079-083 declarations and exact inherited boundaries. -/\n'
    header += 'run_cmd Lean.Elab.Command.liftTermElabM do\n'
    groups = declarations()
    header += '  let groups : Array (Lean.Name × List String) := #[\n' + ',\n'.join(
        '    (`' + ns + ',[' + ','.join('"' + n + '"' for n in names) + '])'
        for ns, names in groups.items()) + ']\n'
    header += '  let inherited : Array Lean.Name := #[\n' + ',\n'.join(
        '    ``' + n for n in INHERITED) + ']\n'
    target = ROOT / 'formal/Source3/KeygenAssemblyWhole083Audit.lean'
    with target.open('x') as stream:
        stream.write(header + tail)
    print({'modules': len(MODULES), 'new': sum(map(len, groups.values())), 'inherited': len(INHERITED)})

if __name__ == '__main__':
    main()
