#!/usr/bin/env python3
"""Pin the current STABLE_BINARY source/product/receipt closure within W."""
from hashlib import sha256
import json
from pathlib import Path

W = Path(__file__).resolve().parent.parent
RUN = W / 'run'
MODULES = [
    'StableBinaryPin', 'StableBinary', 'StableBinaryAudit',
    'FprCSource', 'FprPrimitives', 'FprPrimitivesAudit',
    'FprCFrame', 'FprCErasure', 'StableBinarySourceSyntax',
    'StableBinaryByteView', 'StableBinaryByteLayout', 'StableBinaryByteSimulation',
    'StableBinarySourceTyped', 'StableBinaryCExec', 'StableBinaryCExecAudit',
    'StableBinaryBytePositive', 'StableBinaryRefinementGoal',
    'StableBinaryRelation', 'StableBinaryCalleeBridge', 'StableBinaryStepRefinement',
    'StableBinaryGroupRefinement', 'StableBinaryPrefixGrouping',
    'StableBinarySuffixGrouping', 'StableBinaryStepAssembly',
    'StableBinaryLoopRefinement', 'StableBinaryCopyRefinement',
    'StableBinaryRecursionRefinement', 'StableBinaryFinalBridge',
    'StableBinaryByteFrame', 'StableBinaryByteFrameGroups',
    'StableBinaryByteFrameRecursion', 'StableBinarySourceProof',
    'StableBinarySourceAudit', 'StableBinaryMemcpySpec',
    'StableBinaryTotality', 'StableBinaryInlineTotal', 'FprTotalityProbe',
]
SOURCES = {
    'falcon-keygen.c': '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
    'fpr-emulated.c': '7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
    'fpr-emulated.h': '242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa',
    'Makefile': '25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049',
}


def digest(path):
    h = sha256()
    with path.open('rb') as f:
        for buf in iter(lambda: f.read(1048576), b''):
            h.update(buf)
    return h.hexdigest()


def relative(path):
    return str(path.relative_to(W))


def main():
    for name, expected in SOURCES.items():
        assert digest(W / 'inputs/source' / name) == expected, name
    assert digest(RUN / 'STABLE_BINARY_001_REPORT.md') == (
        '5506e59eb94fa83cd718140edf78c3da03d46223998c9de5546e44edace93c7b')
    assert digest(RUN / 'STABLE_BINARY_002_BEFORE_BYTE_REFINEMENT.md') == (
        'a8188062350ba7075be571f8ae274429644c400dcef11727f840d616db8e5c3d')
    transport = RUN / 'stable_binary_fpr_transport_003/FPR_C_SOURCE_TRANSPORT.json'
    assert json.loads(transport.read_text())['generated_sha256'] == digest(
        RUN / 'formal/Source3/FprCSource.lean')
    receipts = []
    for path in RUN.glob('*/RECEIPTS.json'):
        for r in json.loads(path.read_text()):
            if r.get('accepted') and r.get('clean_log') and r.get('exit_code') == 0:
                receipts.append((path, r))
    closure = []
    for name in MODULES:
        source = RUN / 'formal/Source3' / (name + '.lean')
        product = RUN / 'devlib/Source3' / (name + '.olean')
        current = digest(source)
        matches = [(p, r) for p, r in receipts
                   if r.get('name') == 'Source3_' + name and r.get('source_sha256') == current]
        if not matches:
            raise ValueError('missing current accepted source: ' + name)
        p, r = max(matches, key=lambda item: item[1]['start'])
        if digest(product) != r['olean_sha256'] or r['forbidden_proof_markers']:
            raise ValueError('stale/forbidden product: ' + name)
        closure.append({
            'module': 'Source3.' + name,
            'source_path': relative(source),
            'source_sha256': current,
            'olean_path': relative(product),
            'olean_sha256': digest(product),
            'receipt_path': relative(p),
            'receipt_sha256': digest(p),
            'stdout_sha256': r['stdout_sha256'],
            'stderr_sha256': r['stderr_sha256'],
        })
    out = {
        'status': 'WORKING_NOT_FROZEN; source-fragment theorem; C99 completeness open',
        'source_pins': SOURCES,
        'm0_transport_receipt': {
            'path': relative(RUN / 'stable_binary_fpr_transport_003/RECEIPTS.json'),
            'sha256': digest(RUN / 'stable_binary_fpr_transport_003/RECEIPTS.json'),
        },
        'previous_reports': {
            'STABLE_BINARY_001_REPORT.md': digest(RUN / 'STABLE_BINARY_001_REPORT.md'),
            'STABLE_BINARY_002_BEFORE_BYTE_REFINEMENT.md': digest(
                RUN / 'STABLE_BINARY_002_BEFORE_BYTE_REFINEMENT.md'),
        },
        'modules': closure,
    }
    target = RUN / 'STABLE_BINARY_002_CLOSURE.json'
    target.write_text(json.dumps(out, sort_keys=True, indent=2) + '\n')
    print('STABLE_BINARY_CLOSURE_OK', len(closure), digest(target))


if __name__ == '__main__':
    main()
