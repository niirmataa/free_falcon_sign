#!/usr/bin/env python3
"""Assemble current sources and pinned replay inputs. No mathematics here."""
from datetime import datetime, timezone
import gzip
import hashlib
import io
import json
from pathlib import Path
import re
import shutil
import tarfile

W = Path(__file__).resolve().parent.parent
R = W / 'run'
O = W / 'output'
REPO = W.parents[3]
IMPORT = re.compile(r'^(?:(?:public|private|meta)\s+)*import\s+(?:all\s+)?([\w.]+)', re.M)
NEW = ['LocalMachineCode', 'MachineExecution', 'MachineAccounting', 'BitAllocation',
       'VerifierAllocation', 'TableAllocation', 'MeteredExecution', 'PrefixResources',
       'FinishResources', 'ResourceReduction']
EXCLUDED = {
    'Probe': 'historical diagnostic probe',
    'Run2.Scratch': 'failed diagnostic branch, superseded by PackedConvolution',
    'Run2.rawBadEnclosure': 'rejected external numerical-assumption draft; NOT imported or a proved enclosure',
    'Audit': 'historical audit wrapper', 'AuditRun2': 'historical audit wrapper',
    'MachineAudit': 'historical audit wrapper', 'Run2.M6Audit': 'historical audit wrapper',
    'Run2.KernelBindingAudit': 'historical audit wrapper',
}


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def write(p, obj):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(obj, indent=2, sort_keys=True) + '\n')


def copy(src, dst):
    if src.is_symlink() or not src.is_file():
        raise ValueError('not a regular source: ' + str(src))
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists() and sha(dst) != sha(src):
        raise ValueError('destination conflict: ' + str(dst))
    if not dst.exists():
        shutil.copyfile(src, dst)


def strip_comments(text):
    # Nested block comments, strings and line comments are discarded only
    # for the lexical scan/inventory. Exact original source bytes are kept.
    return re.sub(r'/\-.*?\-/|--[^\n]*|"(?:\\.|[^"\\])*"',
                  lambda m: '\n' * m[0].count('\n'), text, flags=re.S)


def declarations(module, path):
    text = strip_comments(path.read_text())
    if re.search(r'\b(?:sorry|sorryAx|admit|native_decide|axiom|hypothesis)\b|Lean\.ofReduceBool', text):
        raise ValueError('forbidden source construct: ' + module)
    if re.search(r'set_option\s+(?:linter\.[\w.]+|warningAsError)\s+false', text):
        raise ValueError('warning suppression: ' + module)
    stack, exported = [], []
    for line in text.splitlines():
        if m := re.match(r'^namespace\s+([\w.]+)', line):
            stack.append(m[1])
        elif re.match(r'^section(?:\s|$)', line):
            stack.append('')
        elif re.match(r'^end(?:\s|$)', line):
            if stack:
                stack.pop()
        if m := re.match(r'^(?:@\[[^]]+\]\s*)?(?:protected\s+)?(?:theorem|lemma)\s+([\w.]+)', line):
            name = '.'.join([x for x in stack if x] + [m[1]])
            exported.append({'name': name, 'module': module, 'source': 'formal/' + module.replace('.', '/') + '.lean',
                             'source_sha256': sha(path), 'new_a3': module in {'Run2.' + x for x in NEW}})
    return exported


def library(own):
    p01 = W.parent / 'B20_001/P01'
    lean = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0')
    rootpaths = {'mathlib': p01 / 'bootstrap/mathlib4'}
    rootpaths.update({p.name: p for p in (p01 / 'run/.lake/packages').iterdir() if p.is_dir()})
    roots = {k: {'source': str(v), 'build': str(v / '.lake/build/lib/lean')} for k, v in rootpaths.items()}
    roots['lean'] = {'source': str(lean / 'src/lean'), 'build': str(lean / 'lib/lean')}
    if (rootpaths['mathlib'] / '.git/HEAD').read_text().strip() != '5ed2965256430c3649e86755f9576b54eca72435':
        raise ValueError('Mathlib revision differs')
    pending = ['Init', 'Lean']
    for p in own.values():
        pending.extend(m for m in IMPORT.findall(p.read_text()) if m not in own)
    seen, records = set(), []
    while pending:
        mod = pending.pop()
        if mod in seen or mod in own:
            continue
        seen.add(mod)
        rel = mod.replace('.', '/')
        matches = [(k, v) for k, v in roots.items() if (Path(v['build']) / (rel + '.olean')).is_file()]
        if len(matches) != 1:
            raise ValueError(('library resolution', mod, matches))
        key, root = matches[0]
        source = Path(root['source']) / (rel + '.lean')
        target = O / 'library-source' / key / (rel + '.lean')
        copy(source, target)
        ilean = Path(root['build']) / (rel + '.ilean')
        imports = [x[0] for x in json.loads(ilean.read_text())['directImports']] if ilean.exists() else IMPORT.findall(source.read_text())
        pending.extend(imports)
        artifacts = []
        for ext in ['.olean', '.olean.private', '.olean.server', '.ir', '.ilean']:
            p = Path(root['build']) / (rel + ext)
            if p.exists():
                artifacts.append({'path': rel + ext, 'sha256': sha(p)})
        records.append({'module': mod, 'library': key, 'source': str(target.relative_to(O)),
                        'source_sha256': sha(source), 'artifacts': artifacts, 'imports': imports})
    for key, root in roots.items():
        if not any(x['library'] == key for x in records):
            continue
        for name in ['LICENSE', 'LICENSE.txt', 'LICENSE.md', 'COPYING', 'lean-toolchain',
                     'lakefile.lean', 'lakefile.toml', 'lake-manifest.json']:
            p = Path(root['source']) / name
            if p.is_file() and not p.is_symlink():
                copy(p, O / 'dependency-licenses' / key / name)
    write(O / 'LIBRARY_CLOSURE.json', {'roots': roots, 'modules': sorted(records, key=lambda x: x['module']),
        'mathlib_revision': '5ed2965256430c3649e86755f9576b54eca72435', 'cache_rebuilt': False,
        'source_closure_complete': True, 'compiled_cache_in_bundle': False})
    return len(records)


def prepare():
    old = R / 'OUTPUT_DRAFT_20260929'
    if old.exists():
        raise ValueError('preparation already started; inspect existing state, do not overwrite')
    if (O / 'OUTPUTS.sha256').exists():
        raise ValueError('output has a final manifest; refusing to replace')
    O.rename(old)
    O.mkdir()
    write(O / 'PREPARATION.json', {'utc': datetime.now(timezone.utc).isoformat(), 'status': 'PREPARING_NOT_FROZEN',
                                 'previous_draft_preserved': str(old)})
    (O / 'NOT_FROZEN.md').write_text('# WORKING_NOT_FROZEN\n\nCurrent-source package preparation and fresh replay are in progress.\n')
    sources, exports, excluded = {}, [], []
    for p in sorted((R / 'formal').rglob('*.lean')):
        module = '.'.join(p.relative_to(R / 'formal').with_suffix('').parts)
        if module in EXCLUDED:
            copy(p, O / 'history/non_proof_sources' / p.relative_to(R / 'formal'))
            excluded.append({'module': module, 'sha256': sha(p), 'reason': EXCLUDED[module]})
            continue
        dst = O / 'formal' / p.relative_to(R / 'formal')
        copy(p, dst)
        sources[module] = dst
        exports.extend(declarations(module, dst))
    if len(exports) != len({e['name'] for e in exports}):
        raise ValueError('duplicate export names')
    for p in sources.values():
        for m in IMPORT.findall(p.read_text()):
            if m in EXCLUDED:
                raise ValueError('active import of excluded source: ' + m)
    order, visiting = [], set()
    def visit(m):
        if m in order:
            return
        if m in visiting:
            raise ValueError('import cycle: ' + m)
        visiting.add(m)
        for dep in IMPORT.findall(sources[m].read_text()):
            if dep in sources:
                visit(dep)
        visiting.remove(m)
        order.append(m)
    for m in sorted(sources):
        visit(m)
    audit = '\n'.join('import ' + m for m in order) + '\nset_option format.width 120\n'
    for e in exports:
        audit += '\n#check @' + e['name'] + '\n#print axioms ' + e['name'] + '\n'
        if e['new_a3']:
            audit += '#print ' + e['name'] + '\n'
    for name in ['FT1536.Run2.LocalJointCertificate',
                 'FT1536.Run2.LocalMachineCode.AdversaryCertificate',
                 'FT1536.Run2.LocalMachineCode.SamplerCertificate',
                 'FT1536.Run2.ResourceReduction.Implementation',
                 'FT1536.Run2.ResourceReduction.Resources',
                 'FT1536.Run2.ResourceReduction.ResourceRealization',
                 'FT1536.Run2.ResourceReduction.resourceBound']:
        audit += '\n#print ' + name + '\n'
    (O / 'formal/FinalAudit.lean').write_text(audit)
    sources['FinalAudit'] = O / 'formal/FinalAudit.lean'
    order.append('FinalAudit')
    write(O / 'FORMAL_EXPORTS.json', {'exports': exports, 'status': 'AWAITING_FRESH_KERNEL_REPLAY'})
    write(O / 'SOURCE_SCAN.json', {'active_modules': len(sources), 'forbidden_constructs': [],
        'excluded_preserved_sources': excluded, 'scope': 'lexical source guard; kernel axiom audit still required'})
    jobs = [
        {'name': 'sage_inherited', 'source': 'check_bounds.sage', 'generated': [
            {'product': 'generated/Certificate.lean', 'expected': 'formal/FT1536/Certificate.lean'}]},
        {'name': 'sage_emit', 'source': 'check_emit_error.sage', 'generated': [
            {'product': 'generated/NumericCertificate.lean', 'expected': 'formal/Run2/NumericCertificate.lean'}]},
        {'name': 'sage_field', 'source': 'reference_cost_constants.sage', 'generated': [
            {'product': 'generated/FieldConstants.lean', 'expected': 'formal/Run2/FieldConstants.lean'}]},
        {'name': 'sage_resources', 'source': 'resource_envelope.sage', 'generated': []},
        {'name': 'sage_tail', 'source': 'check_tail_obligations.sage', 'generated': []},
        {'name': 'sage_counts', 'source': 'extract_counts_certificate.sage', 'generated': [
            {'product': 'CountsFoldCertificate.lean', 'expected': 'formal/CountsFoldCertificate.lean'}]},
    ]
    for j in jobs:
        copy(R / 'sage' / j['source'], O / 'sage' / j['source'])
    for p in sorted((R / 'sage').glob('*.sage')):
        if p.name not in {j['source'] for j in jobs}:
            copy(p, O / 'history/research_sage' / p.name)
    write(O / 'BUILD.json', {'modules': order, 'sage': jobs, 'lean_flags': ['-DwarningAsError=true', '-j1', '-M6144'],
        'limits': {'wall_seconds_per_step': 1800, 'AS_bytes': 12884901888, 'normal_RSS_bytes': 8589934592},
        'own_cache': 'fresh empty lib; never devlib', 'historical_scripts': 'history/research_sage; not part of replay claims'})
    copy(R / 'job.py', O / 'tools/execution.py')
    copy(R / 'final_replay.py', O / 'tools/replay.py')
    copy(Path(__file__), O / 'tools/package_preparation.py')
    copy(R / 'a3_job.py', O / 'tools/development_preflight.py')
    copy(W / 'inputs/bootstrap/prior/TOOLCHAIN.json', O / 'TOOLCHAIN.json')
    shutil.copytree(W / 'inputs', O / 'inputs')
    copy(REPO / 'proofs/ft1536/documents/FT1536_ZADANIE_ASTRA_INTERACTIVE_GAME_BINDING_2026-09-23.md', O / 'TASK.md')
    copy(W / 'AGENTS.md', O / 'provenance/WORKSPACE_RULES.md')
    copy(R / 'LEAN_INSTANCE_HYGIENE.md', O / 'provenance/LEAN_INSTANCE_HYGIENE.md')
    for p in sorted((R / 'RESUME_A3_20260929').glob('*.json')):
        copy(p, O / 'provenance/resume' / p.name)
    for name in ['B_CERTIFICATE_PACKAGE.md', 'M6_BINDING_STATUS.md', 'KERNEL_BINDING_PROGRESS.md',
                 'INTERVAL_CERTIFICATES_MANIFEST.json', 'MIMO_INTEGRATION.json', 'RESTART_EVENT_001.json']:
        copy(R / name, O / 'provenance/historical' / name)
    for src, name in [('arb_radial_full_001/arb_radial_result.json', 'radial_engine.json'),
                      ('radial_closure_001/centering_interval_closure.json', 'interval_closure.json')]:
        copy(R / src, O / 'historical_results' / name)
    mimo = W.parent / 'FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001_V2_1_ERRATA'
    if sha(mimo / 'OUTPUTS.sha256') != 'c80b3e542288fe22f60cdb8d8d14465a1c41695cba923b3c87b68b6ac2581a10':
        raise ValueError('errata manifest changed')
    members = []
    for line in (mimo / 'OUTPUTS.sha256').read_text().splitlines():
        h, rel = line.split(maxsplit=1)
        if sha(mimo / rel) != h:
            raise ValueError('errata member changed: ' + rel)
        members.append(rel)
    members.append('OUTPUTS.sha256')
    with tarfile.open(O / 'inputs/MIMO_V2_1_ERRATA.tar.xz', 'w:xz', preset=3) as archive:
        for rel in sorted(members):
            data = (mimo / rel).read_bytes()
            info = tarfile.TarInfo(rel)
            info.size, info.mode, info.mtime = len(data), 0o644, 0
            archive.addfile(info, io.BytesIO(data))
    libraries = library(sources)
    write(O / 'SOURCE_BINDINGS.json', {'modules': [
        {'module': m, 'source': str(p.relative_to(O)), 'sha256': sha(p),
         'origin': str(R / 'formal' / p.relative_to(O / 'formal')) if m != 'FinalAudit' else 'generated audit inventory'}
        for m, p in sorted(sources.items())], 'library_modules': libraries})
    for p in sorted((old / 'dependency-licenses').rglob('*')):
        if p.is_file():
            copy(p, O / 'dependency-licenses/inherited' / p.relative_to(old / 'dependency-licenses'))
    copy(old / 'DEPENDENCY_ATTRIBUTION.md', O / 'provenance/historical/DEPENDENCY_ATTRIBUTION.md')
    lines = []
    for p in sorted(O.rglob('*')):
        if p.is_file() and p.name not in {'NOT_FROZEN.md', 'PREPARATION.json'}:
            lines.append(sha(p) + '  ' + str(p.relative_to(O)))
    (O / 'REPLAY_INPUTS.sha256').write_text('\n'.join(lines) + '\n')
    result = {'status': 'PREPARED_FOR_REPLAY', 'modules': len(order), 'exports': len(exports),
              'new_a3_exports': sum(x['new_a3'] for x in exports), 'library_modules': libraries,
              'replay_inputs_sha256': sha(O / 'REPLAY_INPUTS.sha256'), 'replay_members': len(lines)}
    write(R / 'RESUME_A3_20260929/PACKAGE_PREPARATION.json', result)
    print(json.dumps(result, indent=2), flush=True)


if __name__ == '__main__':
    prepare()
