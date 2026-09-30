#!/usr/bin/env python3
"""Compact public sources/evidence; discard only regenerable development caches."""
import argparse
import gzip
import hashlib
import io
import json
import os
from pathlib import Path
import re
import shutil
import tarfile

from verify_artifact_package import verify

W = Path(__file__).resolve().parent.parent
R = W / 'run'
D = W / 'clean'
CONTROL = R / 'ARTIFACT_ORGANIZATION_001'
REPO = W.parents[3]
T5 = Path('/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon/evidence/candidates/framework_d641/T5-KEY-QUANTIFIER-DECOMPOSITION-001-20260822-a2')
MIMO = R / 'GAME_BINDING_REVIEW_002/source_snapshot_cc01337d'
IMPORT = re.compile(r'^(?:(?:public|private|meta)\s+)*import\s+(?:all\s+)?([\w.]+)', re.M)
origins = {}
stored = {}


def sha(p):
    h = hashlib.sha256()
    with Path(p).open('rb') as f:
        for block in iter(lambda: f.read(1048576), b''):
            h.update(block)
    return h.hexdigest()


def write_json(p, obj):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(obj, indent=2, sort_keys=True) + '\n')


def copy(src, rel):
    src = Path(src)
    if src.is_symlink() or not src.is_file():
        raise ValueError('expected regular source: ' + str(src))
    rel = Path(rel)
    if rel.is_absolute() or '..' in rel.parts:
        raise ValueError('unsafe package path')
    dst = D / rel
    h = sha(src)
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists():
        if sha(dst) != h:
            raise ValueError('destination already has different bytes: ' + str(dst))
    else:
        shutil.copyfile(src, dst)
    origins[rel.as_posix()] = {'original': str(src), 'sha256': h}
    stored.setdefault(h, rel.as_posix())
    return rel.as_posix()


def object_copy(src):
    h = sha(src)
    if h not in stored:
        copy(src, 'history/objects/' + h + ''.join(src.suffixes))
    return {'sha256': h, 'stored_as': stored[h]}


def tree(src, rel):
    for p in sorted(src.rglob('*')):
        if p.is_symlink():
            raise ValueError('symlink in source tree: ' + str(p))
        if p.is_file():
            copy(p, Path(rel) / p.relative_to(src))


def checked_manifest(base, name, pin):
    p = base / name
    if sha(p) != pin:
        raise ValueError('external manifest pin mismatch: ' + str(p))
    names = []
    for line in p.read_text().splitlines():
        h, n = line.split(maxsplit=1)
        rel = Path(n)
        if rel.is_absolute() or '..' in rel.parts or n in names:
            raise ValueError('unsafe/duplicate original manifest member: ' + n)
        f = base / rel
        if f.is_symlink() or not f.is_file() or sha(f) != h:
            raise ValueError('original input mismatch: ' + str(f))
        names.append(n)
    return names


def copy_frozen(base, name, pin, destination):
    names = checked_manifest(base, name, pin)
    for n in names + [name]:
        copy(base / n, Path(destination) / n)
    return len(names)


def idle():
    for p in Path('/proc').glob('[0-9]*'):
        try:
            if p.name == str(os.getpid()):
                continue
            cmd = (p / 'cmdline').read_bytes().replace(b'\0', b' ')
            cwd = (p / 'cwd').resolve()
        except (FileNotFoundError, PermissionError, ProcessLookupError, OSError):
            continue
        if cwd.is_relative_to(W) and any(s in cmd for s in
                (b' run/job.py ', b'/run/job.py ', b'/bin/lean ', b'game_binding_replay.py')):
            raise RuntimeError('active computation in W: PID ' + p.name)


def collect_attempt(d, label, snapshots, records):
    for sub in ['formal', 'sage']:
        for p in sorted((d / sub).rglob('*')):
            if p.is_file() and not p.is_symlink() and p.suffix in {'.lean', '.sage', '.py'} and not p.name.endswith('.sage.py'):
                snapshots.setdefault(label, []).append({'original': str(p),
                    'path_in_attempt': p.relative_to(d).as_posix(), **object_copy(p)})
    for p in sorted((d / 'logs').glob('*')):
        if p.is_file() and p.suffix in {'.stdout', '.stderr', '.json'}:
            copy(p, Path('evidence/attempts') / label / 'logs' / p.name)
    for name in ['RECEIPTS.json', 'EXECUTION_RECEIPTS.json', 'REPLAY_RESULT.json',
                 'COMMANDS.log', 'AXIOMS.json', 'SAGE_RUNS.json', 'MACHINE_COMPONENTS_AUDIT.json']:
        if (d / name).is_file():
            copy(d / name, Path('evidence/attempts') / label / name)
    products = []
    for sub in [d, d / 'generated', d / 'work']:
        if not sub.exists():
            continue
        candidates = sub.iterdir() if sub == d else sub.rglob('*')
        for p in sorted(candidates):
            if not p.is_file() or p.is_symlink() or p.suffix not in {'.json', '.lean', '.sage', '.pyx', '.c'}:
                continue
            if p.name in {'RECEIPTS.json', 'EXECUTION_RECEIPTS.json', 'REPLAY_RESULT.json',
                          'AXIOMS.json', 'SAGE_RUNS.json', 'MACHINE_COMPONENTS_AUDIT.json'}:
                continue
            products.append({'original': str(p), 'path_in_attempt':p.relative_to(d).as_posix(), **object_copy(p)})
    if products:
        write_json(D / 'evidence/attempts' / label / 'PRODUCTS.json', products)
    # Per-step receipts cover the DFT run whose top-level controller died.
    for receipt in sorted((d / 'logs').glob('*.receipt.json')):
        rec = json.loads(receipt.read_text())
        stdout = d / rec['stdout']
        stderr = d / rec['stderr']
        for key, file in [('stdout', stdout), ('stderr', stderr)]:
            if sha(file) != rec[key + '_sha256']:
                raise ValueError('recorded log hash mismatch: ' + str(file))
        argv = rec.get('argv', [])
        if argv and str(argv[-1]).endswith('.lean'):
            src = Path(argv[-1])
            if src.is_file() and src.is_relative_to(d / 'formal'):
                text = stdout.read_text(errors='replace') + stderr.read_text(errors='replace')
                records.append({'module': '.'.join(src.relative_to(d / 'formal').with_suffix('').parts),
                    'source_sha256': sha(src), 'exit_code':rec['exit_code'],
                    'clean_log':not stderr.stat().st_size and 'warning:' not in text and 'error:' not in text,
                    'finished':rec.get('stop', ''),
                    'receipt':'evidence/attempts/' + label + '/logs/' + receipt.name})


def library_closure():
    inherited = json.loads((R / 'INHERITED_LIBRARY_CLOSURE.json').read_text())
    roots = inherited['roots']
    own = {'.'.join(p.relative_to(D / 'formal').with_suffix('').parts)
           for p in (D / 'formal').rglob('*.lean')}
    pending = ['Init']
    for p in (D / 'formal').rglob('*.lean'):
        pending.extend(m for m in IMPORT.findall(p.read_text()) if m not in own)
    modules = {}
    archive_files = {}
    while pending:
        mod = pending.pop()
        if mod in modules or mod in own:
            continue
        rel = Path(mod.replace('.', '/') + '.lean')
        matches = [(k, Path(v['source']) / rel) for k, v in roots.items()
                   if (Path(v['source']) / rel).is_file()]
        if len(matches) != 1:
            raise ValueError(('missing or ambiguous library module', mod, matches))
        library, source = matches[0]
        member = library + '/' + rel.as_posix()
        ilean = Path(roots[library]['build']) / (mod.replace('.', '/') + '.ilean')
        if ilean.is_file():
            imports = [x[0] if isinstance(x, list) else x
                       for x in json.loads(ilean.read_text())['directImports']]
        else:
            imports = IMPORT.findall(source.read_text())
        modules[mod] = {'module':mod, 'library':library, 'member':member,
                        'sha256':sha(source), 'imports':imports, 'original':str(source)}
        archive_files[member] = source
        pending.extend(imports)
    for library, rootspec in roots.items():
        if not any(v['library'] == library for v in modules.values()):
            continue
        for name in ['LICENSE', 'LICENSE.txt', 'LICENSE.md', 'COPYING', 'lean-toolchain',
                     'lakefile.lean', 'lakefile.toml', 'lake-manifest.json']:
            p = Path(rootspec['source']) / name
            if p.is_file() and not p.is_symlink():
                archive_files[library + '/' + name] = p
    dep = D / 'dependencies'
    dep.mkdir(exist_ok=True)
    entries = []
    with tarfile.open(dep / 'library-sources.tar.xz', 'w:xz', preset=6) as archive:
        for member, source in sorted(archive_files.items()):
            data = source.read_bytes()
            info = tarfile.TarInfo(member)
            info.size = len(data)
            info.mode = 0o644
            info.mtime = 0
            archive.addfile(info, io.BytesIO(data))
            entries.append({'member':member, 'sha256':hashlib.sha256(data).hexdigest(), 'original':str(source)})
    write_json(dep / 'LIBRARY_SOURCES.json', {'schema':'RUN002_SOURCE_CLOSURE_V1',
        'modules':sorted(modules.values(), key=lambda x:x['module']), 'files':entries,
        'compiled_caches_included':False, 'library_rebuild_performed':False})
    # Original binary pins remain provenance; packaging is not a binary replay.
    (dep / 'HISTORICAL_LIBRARY_PINS.json.gz').write_bytes(
        gzip.compress((R / 'INHERITED_LIBRARY_CLOSURE.json').read_bytes(), mtime=0))
    return len(modules), len(entries)


def create(resume=False):
    idle()
    marker = D / 'PACKAGING_IN_PROGRESS.json'
    if D.exists() and not (resume and marker.is_file()):
        raise ValueError('destination exists; not overwriting an existing package')
    D.mkdir(exist_ok=resume)
    write_json(marker, {'task':'FT1536_MATH_EUFCMA_MTISIS_RUN_002', 'operation':'artifact organization'})
    task = REPO / 'proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_INTERACTIVE_GAME_BINDING_2026-09-23.md'
    if sha(task) != 'b4c11e3cf2a8cf3939a88400a2ea157b9d835e52c02aa974494b93b5f1376e45':
        raise ValueError('TASK pin differs')
    copy(task, 'TASK.md')
    copy(W / 'AGENTS.md', 'docs/ORIGINAL_WORKSPACE_RULES.md')
    copy(W / 'WORK_STATE.md', 'docs/WORK_STATE.md')
    for p in sorted((R / 'formal').rglob('*.lean')):
        base = 'history/current_probes' if p.name == 'Probe.lean' else 'formal'
        copy(p, Path(base) / p.relative_to(R / 'formal'))
    for p in sorted((R / 'sage').glob('*.sage')):
        copy(p, 'sage/' + p.name)
    tree(W / 'inputs', 'inputs')
    t5_count = copy_frozen(T5, 'output_hashes.sha256',
        '4dc5051289736004f5729c645c194beeb983a9203a3f79e38a0465d395dd0819', 'inputs/t5-a2')
    mimo_count = copy_frozen(MIMO, 'OUTPUTS.sha256',
        'cc01337d093029458d07946088066b1ffeae93ac59a0896b8e26968d8c215269', 'inputs/mimo-final')
    numeric = {
        'arb_radial_full_001/arb_radial_result.json':('results/probability/raw.json',
            'cac1c4f2c178bd8b8f21d775ba5ef5431f2f03b4a9eff20751d1116b3fb8b78a'),
        'radial_closure_001/centering_interval_closure.json':('results/probability/interval.json',
            '5ac5c576ab08f7b0c9eebf85ce25139f5766d178c49aa60529746548c73f4e58')}
    for src, (dst, pin) in numeric.items():
        if sha(R / src) != pin:
            raise ValueError('numeric result pin mismatch: ' + src)
        copy(R / src, dst)
    for name in ['LEGAL_KEY_NUMERIC_ROUTE.md', 'MIMO_INTEGRATION.json', 'RESTART_EVENT_001.json',
                 'SETUP.json', 'BOOTSTRAP_PLAN.json', 'BOOTSTRAP_RECEIPT.json']:
        copy(R / name, 'docs/' + name)
    for name in ['MODEL.md', 'ERROR_QUANTIFICATION.md', 'FAILED_ROUTES.md', 'REPORT.md',
                 'RESULT.json', 'NEXT_INTERFACE.md', 'TOOLCHAIN.json']:
        copy(W / 'output' / name, 'history/report_snapshots/' + name)
    for p in sorted(CONTROL.glob('*')):
        if p.is_file():
            copy(p, 'history/organization/' + p.name)
    snapshots = {}
    records = []
    attempts = []
    for d in sorted(R.iterdir()):
        if d.is_dir() and not d.is_symlink() and (d / 'formal').is_dir() and (d / 'logs').is_dir():
            collect_attempt(d, d.name, snapshots, records)
            attempts.append(d.name)
    for label in ['GAME_BINDING_REVIEW_001', 'GAME_BINDING_REVIEW_002']:
        base = R / label
        for p in sorted(base.glob('*')):
            if p.is_file() and p.suffix in {'.json', '.md', '.diff', '.lean', '.sage'}:
                copy(p, Path('evidence/import_reviews') / label / p.name)
        for d in sorted(base.iterdir()):
            if d.is_dir() and d.name.startswith(('replay_', 'checks_')) and (d / 'logs').is_dir():
                collect_attempt(d, label + '__' + d.name, snapshots, records)
    for p in sorted((R / 'failed-tools').rglob('*')):
        if p.is_file() and p.suffix in {'.py', '.sage', '.lean', '.json', '.txt', '.log', '.stdout', '.stderr'}:
            object_copy(p)
    (D / 'history/SOURCE_SNAPSHOTS.json.gz').write_bytes(
        gzip.compress(json.dumps(snapshots, sort_keys=True).encode(), mtime=0))
    source_status = []
    for p in sorted((D / 'formal').rglob('*.lean')):
        module = '.'.join(p.relative_to(D / 'formal').with_suffix('').parts)
        h = sha(p)
        matches = [r for r in records if r['module'] == module and r['source_sha256'] == h]
        clean = [r for r in matches if r['exit_code'] == 0 and r['clean_log']]
        latest = max(clean or matches, key=lambda r:r['finished'], default=None)
        source_status.append({'module':module, 'path':p.relative_to(D).as_posix(), 'sha256':h,
            'status':'RECORDED_CLEAN_BUILD' if clean else 'NO_CLEAN_BUILD_FOR_CURRENT_BYTES',
            'record':latest, 'scope':'recorded module build, not fresh whole-package replay'})
    write_json(D / 'evidence/CURRENT_SOURCE_STATUS.json', source_status)
    library_modules, library_files = library_closure()
    copy(R / 'job.py', 'tools/development_runner.py')
    copy(R / 'verify_artifact_package.py', 'tools/verify.py')
    copy(R / 'organize_artifacts.py', 'tools/organize_artifacts.py')
    write_json(D / 'STATUS.json', {'mathematical_status':'WORKING_NOT_FROZEN',
        'organization_only':True, 'fresh_full_replay_of_current_sources':False,
        'probability_interval_computed':True, 'probability_common_rounding':'1.27e-24',
        'all_key_kernel_source_binding_complete':False, 'whole_reducer_resources_complete':False,
        'concrete_game_advantage_inequality_kernel_checked':True,
        'mimo_final_manifest_members_verified':mimo_count, 't5_a2_manifest_members_verified':t5_count,
        'development_attempts':len(attempts), 'library_modules':library_modules,
        'library_archive_members':library_files,
        'current_sources_without_recorded_clean_build':[x['module'] for x in source_status
            if x['status'] != 'RECORDED_CLEAN_BUILD']})
    (D / 'README.md').write_text('''# RUN_002 — uporządkowane artefakty

Ten katalog jest punktem odczytu aktualnych materiałów. Porządkowanie nie
stanowi zakończenia dowodu, freeze ani nowego replayu matematycznego.

## Najważniejsze pliki

- `formal/` — jedna aktualna kopia źródeł Lean, wraz z odziedziczonymi modułami.
- `sage/` — źródła rachunków; historyczne badania nie stają się dowodem wyniku.
- `results/probability/raw.json`, `interval.json` — wykonany rachunek i domknięty
  przedział dający wspólne trzy cyfry **1.27e-24**. Formalne przesłanki przeniesienia
  na wszystkie klucze pozostają otwarte, zgodnie z `STATUS.json`.
- `inputs/` — przypięte wejścia, pełne T5-a2 i frozen finał MiMo.
- `dependencies/library-sources.tar.xz` — pojedyncza pełna closure źródeł bibliotek;
  wersje i hashe w `LIBRARY_SOURCES.json`. Bez kopii skompilowanych bibliotek.
- `evidence/CURRENT_SOURCE_STATUS.json` — źródła i odpowiadające im czyste buildy;
  zmieniona wersja bez odpowiedniego receiptu jest oznaczona jawnie.
- `evidence/attempts/` — raw logs i receipty, także nieudanych prób.
- `history/objects/` — każda dodatkowa wersja źródła/produktu przechowywana raz.
  `SOURCE_SNAPSHOTS.json.gz` odtwarza mapy historycznych źródeł przez hashe.
- `history/report_snapshots/` — stare raporty; bieżący status jest w `STATUS.json`.
- `CATALOG.json`, `FILES.sha256` — pochodzenie plików i manifest tego katalogu.

## Kontrola integralności

```sh
python3 -B tools/verify.py
```

Kontrola sprawdza bajty, mapy historyczne, bibliotekę źródłową i oryginalne
manifesty wejściowe. Nie uruchamia Lean, Sage, KeyGen ani Sign.

## Dalsza praca

Żywe źródła pozostają w nadrzędnym `run/formal` i `run/sage`. Poprawiony
`run/job.py` używa jednego read-only cache `run/devlib` i zapisuje tylko źródła
zleconego kroku, jego nowe produkty oraz receipty. `tools/development_runner.py`
jest kopią proweniencji tego runnera, nie launcherem dla przeniesionego katalogu.
Końcowy świeży replay całego dowodu pozostaje odrębnym obowiązkiem RUN_002.

Historyczne ścieżki w wejściach i receiptach zachowano jako proweniencję.
Historyczne AGENTS/prompty w wejściach są danymi archiwalnymi.
''')
    write_json(D / 'CATALOG.json', {'schema':'RUN002_COMPACT_ARTIFACTS_V1',
        'source_workspace':str(W), 'files':origins,
        'deduplication':'historical source/product references by SHA256; no copied compiled caches',
        'dependency_archive':'dependencies/LIBRARY_SOURCES.json'})
    marker.unlink()
    manifest = ''.join(sha(p) + '  ' + p.relative_to(D).as_posix() + '\n'
        for p in sorted(D.rglob('*')) if p.is_file() and p.name != 'FILES.sha256')
    (D / 'FILES.sha256').write_text(manifest)
    result = verify(D)
    result['manifest_sha256'] = sha(D / 'FILES.sha256')
    result['package'] = str(D)
    write_json(CONTROL / 'PACKAGE_RESULT.json', result)
    print(json.dumps(result, indent=2))


def prune():
    idle()
    result = verify(D)
    plan = []
    for d in sorted(R.iterdir()):
        if not d.is_dir() or d.is_symlink() or d.name.startswith('fresh_replay'):
            continue
        lib = d / 'lib'
        if not (d / 'formal').is_dir() or not lib.is_dir() or lib.is_symlink():
            continue
        if not (D / 'evidence/attempts' / d.name / 'logs').is_dir():
            raise ValueError('no archived receipts for cache: ' + str(lib))
        members = []
        for p in sorted(lib.rglob('*')):
            if p.is_symlink() or p.is_file() and p.suffix != '.olean':
                raise ValueError('unexpected cache member; preserve: ' + str(p))
            if p.is_file():
                st = p.stat()
                members.append({'path':p.relative_to(W).as_posix(), 'bytes':st.st_size,
                                'allocated_bytes':st.st_blocks*512})
        plan.append({'directory':str(lib), 'members':members})
    write_json(CONTROL / 'CACHE_REMOVAL_PLAN.json', {'package_check':result, 'caches':plan})
    idle()
    for item in plan:
        lib = Path(item['directory'])
        if lib.resolve().parent.parent != R.resolve() or lib.name != 'lib':
            raise ValueError('cache boundary changed')
        shutil.rmtree(lib)
    outcome = {'scope':'regenerable per-attempt Lean cache only',
        'removed_directories':len(plan),
        'removed_files':sum(len(x['members']) for x in plan),
        'removed_allocated_bytes':sum(p['allocated_bytes'] for x in plan for p in x['members']),
        'shared_devlib_preserved':True, 'fresh_replays_preserved':True,
        'all_original_sources_and_logs_preserved':True}
    write_json(CONTROL / 'CACHE_REMOVAL_RESULT.json', outcome)
    print(json.dumps(outcome, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('action', choices=['create', 'prune-caches'])
    parser.add_argument('--resume', action='store_true')
    args = parser.parse_args()
    if args.action == 'create':
        create(args.resume)
    else:
        prune()
