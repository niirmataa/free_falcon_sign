#!/usr/bin/env python3
"""Pin reference bytes and lexical function regions; no C adequacy claim."""
from pathlib import Path
import hashlib
import json
import re

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parents[4]
MANIFEST = REPO / 'provenance/ft1536-candidate.sha256'
REGIONS = {
    'falcon-sign.c': ['ffLDL_ternary_normalize_inner', 'ffLDL_ternary_normalize_depth1',
        'ffLDL_ternary_normalize', 'ft_validate_ternary_private', 'load_skey',
        'ffSampling_inner_fft3', 'ffSampling_fft3', 'do_sign', 'BerExp',
        'ft_adaptive_cdf_samples', 'ft_adaptive_proposal', 'sampler_large',
        'falcon_sign_set_private_key', 'falcon_sign_start', 'falcon_sign_start_external_nonce',
        'falcon_sign_update', 'falcon_sign_generate'],
    'falcon-enc.c': ['falcon_encode_small', 'falcon_decode_small', 'falcon_hash_to_point',
                     'falcon_is_short'],
    'frng.c': ['falcon_prng_init', 'falcon_prng_refill'],
}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def pin(p):
    return {'path': str(p.relative_to(REPO)), 'sha256': sha(p.read_bytes()), 'bytes': p.stat().st_size}


def body(text, name):
    starts = list(re.finditer(r'^' + re.escape(name) + r'\(', text, re.M))
    assert len(starts) == 1, (name, len(starts))
    start = starts[0].start()
    brace = text.index('{', start)
    # Strings/comments are consumed atomically so braces inside them do not count.
    tokens = re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[{}]', re.S)
    depth = 0
    for match in tokens.finditer(text, brace):
        token = match.group()
        if token == '{':
            depth += 1
        elif token == '}':
            depth -= 1
            if depth == 0:
                return start, match.end()
    raise ValueError(('unclosed function', name))


def main():
    assert sha(MANIFEST.read_bytes()) == '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985'
    sources = []
    for line in MANIFEST.read_text().splitlines():
        digest, name = line.split(maxsplit=1)
        path = REPO / 'Extra/c' / name.lstrip('*')
        assert sha(path.read_bytes()) == digest, ('INTEGRITY_STOP', str(path))
        sources.append(pin(path))
    assert len(sources) == 17
    out = ROOT / '.build/pre_do_sign084/source086'
    out.mkdir(exist_ok=False)
    regions = []
    for filename, names in REGIONS.items():
        path = REPO / 'Extra/c' / filename
        text = path.read_text()
        for name in names:
            start, end = body(text, name)
            raw = text[start:end].encode()
            snapshot = out / (filename + '.' + name + '.txt')
            snapshot.write_bytes(raw)
            regions.append({'source': str(path.relative_to(REPO)), 'function': name,
                'first_line': text.count('\n', 0, start) + 1,
                'last_line': text.count('\n', 0, end) + 1,
                'sha256': sha(raw), 'bytes': len(raw), 'snapshot': str(snapshot.relative_to(REPO))})
    text = (REPO / 'Extra/c/falcon-sign.c').read_text()
    anchors = ['#define SIGN_MAX_ATTEMPTS   16', '#if SIGN_MAX_ATTEMPTS != 16',
               'falcon_hash_to_point(&fs->sc, fs->q, hm, fs->logn);',
               'if (++ sign_loop_attempts > SIGN_MAX_ATTEMPTS)',
               'if (fs->ternary && tsc.fault != FT_SAMPLER_FAULT_NONE)',
               'short_ok = falcon_is_short(s1, s2, fs->logn, fs->ternary);',
               'sig_len = falcon_encode_small(sig_buf + 1, sig_max_len - 1,']
    anchor_rows = []
    for anchor in anchors:
        assert text.count(anchor) == 1, anchor
        anchor_rows.append({'text': anchor, 'line': text[:text.index(anchor)].count('\n') + 1})
    formal = ROOT.parent / 'run2/formal'
    support = [pin(formal / name) for name in ['T5Pointwise.lean', 'AttemptWeights.lean',
        'AttemptPointwise.lean', 'SignLayerSupport.lean', 'HacGlue.lean', 'Assembly.lean',
        'AssemblyComp.lean', 'CompPrg.lean', 'Run2/Games.lean']]
    support.append(pin(REPO / 'proofs/ft1536/stages/FT1536_FPEMU_FLOOR_CT_RUN_001/formal/FloorWord.lean'))
    data = {'stage': 'B1-ATTEMPT-SHAPE preparation', 'status': 'SOURCE_PINNED / REALIZATION_OPEN',
        'manifest': pin(MANIFEST), 'sources': sources, 'regions': regions, 'anchors': anchor_rows,
        'formal_inputs': support, 'generator': pin(Path(__file__)),
        'norm_control_shape': 'unconditioned one-attempt draw followed by norm test; retry at most16; encode once outside retry loop',
        'e2_conclusion': 'unconditioned route is the structural target, not a proved bound for the implementation',
        'unresolved': ['fatal sampler fault is not a retry miss', 'scalar rejection loop has no fixed bit bound',
            'source-defined weight laws', 'physical int16 and syndrome identity',
            'signature capacity/codec and game transport'],
        'scope': 'Lexical regions and byte hashes, not formal source execution or source-to-law proof.'}
    output = ROOT / 'notes/run/DO_SIGN_SOURCE_MAP_086.json'
    with output.open('x') as stream:
        json.dump(data, stream, indent=2)
        stream.write('\n')
    print(json.dumps({'source_files': len(sources), 'function_regions': len(regions),
                      'output': str(output.relative_to(REPO)), 'sha256': sha(output.read_bytes())}))


if __name__ == '__main__':
    main()
