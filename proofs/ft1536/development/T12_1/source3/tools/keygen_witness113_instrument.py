#!/usr/bin/env python3
"""Add byte-observation calls to a generated copy; never edit Extra/c."""
from pathlib import Path
import hashlib
import json
import sys

ROOT=Path(__file__).resolve().parents[1]
REPO=ROOT.parents[4]


def main():
    destination=Path(sys.argv[1]).resolve()
    source=REPO/'Extra/c/falcon-keygen.c'
    expected=json.loads((ROOT/'.build/success112/POSTSEAL_112.json').read_text())['checked'][str(source)]
    raw=source.read_text();assert hashlib.sha256(source.read_bytes()).hexdigest()==expected
    changes=[]
    def replace(old,new,count=1):
        nonlocal raw
        assert raw.count(old)==count,(old[:100],raw.count(old),count)
        raw=raw.replace(old,new)
        changes.append({'original':old,'replacement':new,'count':count})
    replace('\t\t\tlocal_attempts ++;\n','\t\t\tlocal_attempts ++;\n\t\t\twitness_attempts = local_attempts;\n\t\t\twitness_emit("attempt", &local_attempts, sizeof local_attempts);\n')
    replace('\t\t\tsample_true_ternary_secret(fk, g, n);\n','\t\t\tsample_true_ternary_secret(fk, g, n);\n\t\t\twitness_emit("sample_f", f, n * sizeof *f);\n\t\t\twitness_emit("sample_g", g, n * sizeof *g);\n')
    for name in ['f','g']:
        old=f'mod2_res_ternary({name}, logn) == 0'
        replace(old,f'witness_int("resultant_{name}", mod2_res_ternary({name}, logn)) == 0')
    replace('\t\t\tif (!fpr_lt(norm, bound)) {','\t\t\twitness_emit("norm_value", &norm, sizeof norm);\n\t\t\twitness_emit("norm_bound", &bound, sizeof bound);\n\t\t\twitness_emit("norm_scratch", fk->tmp, fk->tmp_len);\n\t\t\tif (!fpr_lt(norm, bound)) {',2)
    replace('if (!falcon_compute_public(h, f, g, logn, ter))','if (!witness_int("public_return", falcon_compute_public(h, f, g, logn, ter)))')
    replace('\t\tif (!solve_NTRU(fk, F, G, f, g)) {','\t\twitness_emit("public_h", h, n * sizeof *h);\n\t\tif (!witness_int("solver_return", solve_NTRU(fk, F, G, f, g))) {')
    replace('\t\t/* FT1536 KeyGen Leaf Certificate */','\t\twitness_emit("solver_F", F, n * sizeof *F);\n\t\twitness_emit("solver_G", G, n * sizeof *G);\n\t\twitness_emit("solver_scratch", fk->tmp, fk->tmp_len);\n\t\t/* FT1536 KeyGen Leaf Certificate */')
    replace('if (!ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,\n\t\t\t\tlogn, ter))','if (!witness_int("leaf_return", ft_keygen_leaf_certificate((fpr *)fk->tmp, f, g, F, G,\n\t\t\t\tlogn, ter)))')
    replace('\t\t/*\n\t\t * Key pair is generated.','\t\twitness_emit("certificate_scratch", fk->tmp, fk->tmp_len);\n\t\t/*\n\t\t * Key pair is generated.')
    replace('\t\tif (elen == 0) {','\t\twitness_emit("encoded_segment_length", &elen, sizeof elen);\n\t\twitness_emit("encoded_segment", skbuf + skoff, elen);\n\t\tif (elen == 0) {')
    destination.write_text(raw)
    metadata={'source':str(source),'source_sha256':expected,'generated_source':str(destination),
        'generated_sha256':hashlib.sha256(destination.read_bytes()).hexdigest(),'observational_insertions':changes,
        'coverage':'SHAKE extraction states/bytes; per-attempt f,g; gate results; norm/solver/certificate scratch boundaries; codec segments/final packets. Not every scalar/store inside helpers.',
        'kernel_witness':False}
    destination.with_suffix('.json').write_text(json.dumps(metadata,indent=2)+'\n')


if __name__=='__main__':main()
