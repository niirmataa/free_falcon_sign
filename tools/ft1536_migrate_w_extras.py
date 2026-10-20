#!/usr/bin/env python3
"""One-shot migration of the remaining GAME_BINDING executor-W material.

Owner decision 2026-09-30: full migration now. This script:

1. mirrors the un-migrated component subtrees of the frozen executor W into
   tracked component directories under proofs/ft1536/development/T12_1/
   (BASELINE schema FT1536_DEVELOPMENT_SOURCE_BASELINE_V1 per component);
2. keeps `output/` out of the mirror: it is already covered byte-wise by the
   committed stage FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001 (293/298
   identical; the four non-identical W originals migrate as
   `w_output_gaps/`, ERRATA.md exists only in the stage);
3. freezes the excluded work trees (run/, logs/, build/, *.olean) as ONE
   pinned archive under proofs/ft1536/work/FT1536_GAME_BINDING_RUN_001/
   with a full per-file sha256 listing tracked in the repo;
4. writes the gap report with byte-identity analysis of every run2_src
   snapshot vs known stage/development bytes.

Pure caches (home/, cache/, tmp/, .sage/, .cache/, __pycache__/) are neither
copied nor archived; the report records their exclusion.

Usage: python3 -B tools/ft1536_migrate_w_extras.py [--apply]
Default is a dry run (analysis + report preview, no writes).
"""
import argparse
import hashlib
import json
import shutil
import subprocess
import tarfile
from datetime import datetime, timezone
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
W = Path('/home/footfalcon/Obrazy/FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001')
DEV = REPO / 'proofs/ft1536/development/T12_1'
STORE = REPO / 'proofs/ft1536/work/FT1536_GAME_BINDING_RUN_001/w_archive'
STAGE_GB = REPO / ('proofs/ft1536/stages/FT1536_MATH_EUFCMA_GAME_BINDING'
                   '_RUN_001')
LIMIT = 8 * 1024 * 1024

SUBTREE_COMP = {
    'GAME_BINDING_RUN_002': 'w_game_binding_run002',
    'C_TASK_1_BINBIND': 'w_c_task_1_binbind',
    'C_TASK_2_FPERROR': 'w_c_task_2_fperror',
    'C_TASK_3_REFINE': 'w_c_task_3_refine',
    'CENTERING_CLOSURE': 'w_centering_closure',
}
COMPONENTS = list(SUBTREE_COMP.values()) + ['w_root', 'w_output_gaps']
GAP_OUTPUT = {'output/HANDOFF.md', 'output/OUTPUTS.sha256',
              'output/RESULT.json', 'output/formal/FT1536.tar.xz'}
EXCLUDE_DIRS = {'home', 'tmp', 'cache', 'build', 'logs', '.sage', '.cache',
                '__pycache__'}
CACHE_DIRS = {'home', 'tmp', 'cache', '.sage', '.cache', '__pycache__'}


def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def classify(path):
    """'cache' | 'stage_covered' | 'gap' | 'archive' | 'mirror'."""
    rel = path.relative_to(W).as_posix()
    if rel in GAP_OUTPUT:
        return 'gap'
    parts = set(Path(rel).parts[:-1])
    if parts & CACHE_DIRS:
        return 'cache'
    if Path(rel).parts[0] == 'output':
        return 'stage_covered'
    if parts & EXCLUDE_DIRS or path.suffix == '.olean':
        return 'archive'
    return 'mirror'


def walk():
    buckets = {'mirror': [], 'gap': [], 'archive': [], 'cache': [],
               'stage_covered': []}
    for p in sorted(W.rglob('*')):
        if p.is_symlink():
            raise ValueError('W symlink refused: ' + str(p))
        if p.is_file():
            buckets[classify(p)].append(p)
    return buckets


def target_for(p):
    rel = p.relative_to(W)
    top = rel.parts[0]
    if top in SUBTREE_COMP:
        return SUBTREE_COMP[top], Path(*rel.parts[1:]).as_posix()
    if top == 'inputs' or len(rel.parts) == 1:
        return 'w_root', rel.as_posix()
    if rel.as_posix() in GAP_OUTPUT:
        return 'w_output_gaps', rel.as_posix()
    raise ValueError('unmapped mirror file: ' + str(rel))


def baseline(component, origin, entries):
    return {
        'schema': 'FT1536_DEVELOPMENT_SOURCE_BASELINE_V1',
        'utc': datetime.now(timezone.utc).isoformat(),
        'repository_head': subprocess.check_output(
            ['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip(),
        'origin': origin,
        'component': component,
        'handoff_status': 'MIGRATED_FROM_FROZEN_W_OWNER_DECISION_2026-09-30',
        'proof_review': 'NOT_PERFORMED',
        'files': entries,
    }


def output_vs_stage():
    out_files = {p.relative_to(W / 'output').as_posix(): p
                 for p in sorted((W / 'output').rglob('*')) if p.is_file()}
    stage_files = {p.relative_to(STAGE_GB).as_posix(): p
                   for p in sorted(STAGE_GB.rglob('*')) if p.is_file()}
    lines = []
    for name in sorted(set(out_files) | set(stage_files)):
        a, b = out_files.get(name), stage_files.get(name)
        if a and b:
            status = 'IDENTICAL' if digest(a) == digest(b) else 'DIFFERENT'
        elif a:
            status = 'ONLY_IN_W_OUTPUT'
        else:
            status = 'ONLY_IN_STAGE'
        lines.append((status, name))
    return lines


def run2src_vs_known():
    known = {'stage': {}, 'development': {}}
    for p in (REPO / 'proofs/ft1536/stages').rglob('*.lean'):
        known['stage'].setdefault(p.name, []).append(p)
    dev = REPO / 'proofs/ft1536/development/T12_1'
    for p in dev.rglob('*.lean'):
        if '.build' in p.parts:
            continue
        known['development'].setdefault(p.name, []).append(p)
    lines = []
    for p in sorted(W.rglob('run2_src/*')):
        if not p.is_file():
            continue
        h = digest(p)
        matches = []
        for kind in ('stage', 'development'):
            for p2 in known[kind].get(p.name, []):
                if digest(p2) == h:
                    matches.append(kind + ':' + p2.relative_to(REPO).as_posix())
        status = 'IDENTICAL_TO ' + ', '.join(matches) if matches \
            else 'NO_MATCHING_BYTES_ANYWHERE'
        lines.append((p.relative_to(W).as_posix(), h, status))
    return lines


def build_report(buckets, comp_counts, oversized):
    report = []
    report.append('# W-migration gap report (GAME_BINDING executor W)')
    report.append('')
    report.append('Owner decision 2026-09-30: full migration now. Frozen W: '
                  + str(W))
    report.append('')
    report.append('## Components mirrored into development/T12_1')
    for name in COMPONENTS:
        report.append(f'- `{name}/`: {comp_counts.get(name, 0)} files')
    report.append('')
    report.append('## output/ vs committed stage '
                  '(FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001)')
    detailed = output_vs_stage()
    counts = {}
    for status, _ in detailed:
        counts[status] = counts.get(status, 0) + 1
    for status in sorted(counts):
        report.append(f'- {status}: {counts[status]}')
    report.append('')
    report.append('### Non-identical entries')
    for status, name in detailed:
        if status != 'IDENTICAL':
            report.append(f'- {status}: `{name}`')
    report.append('')
    report.append('## run2_src snapshots vs known bytes')
    unmatched = 0
    for rel, h, status in run2src_vs_known():
        if status.startswith('NO_MATCHING'):
            unmatched += 1
            report.append(f'- UNMATCHED `{rel}` sha256={h}')
    report.append(f'- unmatched run2_src files: {unmatched}')
    report.append('')
    report.append('## Archive (run/, logs/, build/, *.olean)')
    report.append('- files frozen into the pinned archive: '
                  + str(len(buckets['archive']) + len(oversized)))
    report.append('## Excluded pure caches (not copied, not archived)')
    report.append('- files: ' + str(len(buckets['cache'])))
    report.append('## Stage-covered (output/ history and logs; byte-identical '
                  'with the committed stage, not duplicated)')
    report.append('- files: ' + str(len(buckets['stage_covered'])))
    return '\n'.join(report) + '\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()
    assert W.is_dir(), W

    buckets = walk()
    mirror = buckets['mirror'] + buckets['gap']
    oversized = [p for p in mirror if p.stat().st_size > LIMIT]
    mirror_ok = [p for p in mirror if p.stat().st_size <= LIMIT]

    comp_files = {name: [] for name in COMPONENTS}
    for p in mirror_ok:
        name, target = target_for(p)
        comp_files[name].append((p, target))
    comp_counts = {name: len(v) for name, v in comp_files.items()}
    print('mirror=' + str(len(mirror_ok)) + ' oversized_to_archive='
          + str(len(oversized)) + ' archive=' + str(len(buckets['archive']))
          + ' cache_excluded=' + str(len(buckets['cache'])) + ' stage_covered='
          + str(len(buckets['stage_covered'])))

    text = build_report(buckets, comp_counts, oversized)
    if not args.apply:
        print(text)
        print('DRY RUN - nothing written')
        return

    entries_by_comp = {name: [] for name in COMPONENTS}
    for name, entries in comp_files.items():
        root = DEV / name
        for src, target in entries:
            dst = root / target
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.write_bytes(src.read_bytes())
            entries_by_comp[name].append({
                'source': ('ABSOLUTE_W:' + src.as_posix())
                if not src.is_relative_to(REPO)
                else src.relative_to(REPO).as_posix(),
                'target': target,
                'bytes': src.stat().st_size,
                'sha256': digest(src),
            })
    for name in COMPONENTS:
        if not entries_by_comp[name]:
            continue
        origin = next((k for k, v in SUBTREE_COMP.items() if v == name),
                      'W_ROOT_OR_OUTPUT_GAPS')
        (DEV / name / 'BASELINE.json').write_text(json.dumps(
            baseline(name, origin, entries_by_comp[name]), indent=2) + '\n')

    STORE.mkdir(parents=True, exist_ok=True)
    tar_path = STORE / 'w_run_logs_build_2026-09-30.tar'
    listing = []
    with tarfile.open(tar_path, 'w') as tf:
        for p in buckets['archive'] + oversized:
            arcname = p.relative_to(W).as_posix()
            tf.add(p, arcname='FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001/'
                   + arcname)
            listing.append(f'{digest(p)}  {arcname}')
    (STORE / 'W_ARCHIVE_FILES.sha256').write_text('\n'.join(listing) + '\n')
    final_path = tar_path
    if shutil.which('zstd'):
        subprocess.check_call(['zstd', '-q', '-f', '--rm', str(tar_path)])
        final_path = Path(str(tar_path) + '.zst')
    (DEV / 'W_ARCHIVE.json').write_text(json.dumps({
        'schema': 'FT1536_DEVELOPMENT_LARGE_ARTIFACTS_V1',
        'path': final_path.relative_to(REPO).as_posix(),
        'bytes': final_path.stat().st_size,
        'sha256': digest(final_path),
        'kind': 'frozen_w_run_logs_build_archive',
        'files': len(listing),
        'listing': (STORE / 'W_ARCHIVE_FILES.sha256').relative_to(
            REPO).as_posix(),
        'listing_sha256': digest(STORE / 'W_ARCHIVE_FILES.sha256'),
    }, indent=2) + '\n')
    (DEV / 'W_MIGRATION_2026-09-30.md').write_text(text)
    print('APPLIED - components, BASELINEs, archive pin and report written')


if __name__ == '__main__':
    main()
