#!/usr/bin/env python3
"""Pin and seal the exact KeyGen-law boundary; no mathematical computation."""
from pathlib import Path
import fcntl
import json
import re
import subprocess
import sys
import job079 as job
import pin_do_sign086 as regions
import pre_sign_evidence084 as prior

ROOT, REPO = prior.ROOT, prior.REPO
BUILD = ROOT / '.build/key_law087'
PREVIOUS = prior.BUILD / 'POSTSEAL_086.json'
PREVIOUS_SHA = '509ffbec8204a6db762d91fd4da4a1d0f31357473c15318e04267489a3c503b8'
BASE = ROOT / 'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_087.json'
PROOFS = ['KeygenLawBoundary087', 'KeygenSeedSupport087']
FAILURES = {
    '001': 'bwrap could not create NETLINK_ROUTE socket; Lean did not start',
    '002': 'unused simp argument and two already-closed impossible branches',
    '004': 'large exponent normalization refused; unreduced Law structure projection',
    '005': 'large exponent normalization still attempted in the compound proof',
    '006': 'definitional card reduction reached recursion limit; replaced by card_fun theorem',
    '007': 'elaboration still tried closed large power in monotonicity application',
    '008': 'explicit parameters did not avoid closed-power elaboration; moved to symbolic exponent lemma',
    '009': 'both proofs accepted; full pretty-term audit exceeded unchanged printing budget',
    '010': 'audit parser rejected reserved identifier syntax; renamed encodedExpr',
    '011': 'ordinary import did not expose private Lean.Idbg serializers',
    '012': 'import all requires the module command',
    '013': 'module audit cannot import the existing non-module proof files',
    '014': 'expanded expression JSON duplicated shared proof nodes and hit memory budget; replaced by DAG',
    '015': 'DAG visitor early return scope and multiline constructor syntax rejected',
    '016': 'nested return still escaped to visitor result; replaced by pure node construction',
}


def inherited():
    prior.check(PREVIOUS, PREVIOUS_SHA)
    data = json.loads(PREVIOUS.read_text())['checked']
    assert len(data) == 22434
    for p, h in data.items():
        prior.check(p, h)
    return data


def declarations():
    result = []
    for module in PROOFS:
        source = (ROOT / f'formal/Source3/{module}.lean').read_text()
        matches = re.findall(r'^(?:noncomputable )?(abbrev|def|theorem) (\w+)', source, re.M)
        result += [{'name': f'FT1536.Source3.{module}.{name}', 'kind': kind}
                   for kind, name in matches]
    return result


def source_map():
    manifest = REPO / 'provenance/ft1536-candidate.sha256'
    prior.check(manifest, '56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985')
    sources = []
    for line in manifest.read_text().splitlines():
        digest, name = line.split(maxsplit=1)
        path = REPO / 'Extra/c' / name.lstrip('*')
        prior.check(path, digest)
        sources.append(prior.pin(path))
    assert len(sources) == 17
    out = BUILD / 'source'
    out.mkdir(exist_ok=True)
    functions = {
        'falcon-keygen.c': ['get_rng_u64', 'sample_true_ternary_secret',
                           'falcon_keygen_new', 'falcon_keygen_set_seed',
                           'rng_ready', 'falcon_keygen_make'],
        'frng.c': ['urandom_get_seed', 'falcon_get_seed'],
    }
    extracted = []
    for file, names in functions.items():
        path = REPO / 'Extra/c' / file
        text = path.read_text()
        for name in names:
            start, end = regions.body(text, name)
            snapshot = out / f'{file}.{name}.txt'
            if snapshot.exists():
                assert snapshot.read_text() == text[start:end], ('INTEGRITY_STOP', snapshot)
            else:
                snapshot.write_text(text[start:end])
            extracted.append({'source': str(path.relative_to(REPO)), 'function': name,
                'first_line': text.count('\n', 0, start) + 1,
                'last_line': text.count('\n', 0, end) + 1, 'snapshot': prior.pin(snapshot)})
    inputs = [ROOT.parent / 'END_TO_END_SCOPE.md',
              ROOT.parent / 'run2/notes/S1_P_ACCEPT_FACTS.md',
              ROOT / 'formal/Source3/KeygenEntropySource.lean',
              ROOT / 'formal/Source3/KeygenRngSource.lean',
              ROOT / 'formal/Source3/KeygenSourceToFiber001.lean',
              ROOT / 'formal/Source3/KeygenSecretInvocation081.lean',
              ROOT / 'notes/run/PRE_DO_SIGN_086_REPORT.md',
              ROOT / 'notes/run/PRE_DO_SIGN_FINAL_001.md',
              ROOT.parent / 'run2/formal/AssemblyComp.lean',
              ROOT.parent / 'run2/formal/Run2/Games.lean',
              REPO / 'Extra/c/tool.c',
              Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/src/lean/Lean/Elab/Idbg.lean')]
    value = {'status': 'SOURCE_PINNED; NO_SOURCE_LAW_REALIZATION',
        'manifest': prior.pin(manifest), 'sources': sources, 'regions': extracted,
        'formal_and_scope_inputs': [prior.pin(p) for p in inputs],
        'generator': prior.pin(__file__),
        'preseal_metadata_history': [prior.pin(p) for p in sorted(BUILD.glob('SOURCE_MAP_*DRAFT_*'))],
        'scope': 'Lexical evidence. Uniform seed A2 is already recorded. No IID theorem for SHAKE or new entropy assumption.'}
    print(json.dumps(prior.write(ROOT / 'notes/run/KEYGEN_LAW_087_SOURCE_MAP.json', value)))


def audit_source():
    template = (ROOT / 'formal/Source3/SignRealization086Audit.lean').read_text()
    template = re.sub(r'\A(?:import [^\n]+\n)+',
                      'import Source3.KeygenLawBoundary087\nimport Source3.KeygenSeedSupport087\n', template)
    names = ',\n'.join('    ``' + row['name'] for row in declarations())
    template = re.sub(r'(let names : Array Lean.Name := #\[).*?(\]\n  let allowed)',
                      lambda m: m[1] + '\n' + names + m[2], template, flags=re.S)
    original = Path('/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/src/lean/Lean/Elab/Idbg.lean').read_text()
    start = original.index('/-- Custom `Name` serialization')
    end = original.index('/-- Serialize `Expr` to JSON.')
    header = original[:original.index('module\n')]
    helpers = header + '\n/- Audit-only expression serializers copied from the pinned Lean toolchain.\n   No interactive evaluator or network code is included. -/\nnamespace FT1536.Source3.KeygenLaw087AuditEncoding\nopen Lean\n\n' + original[start:end] + 'end FT1536.Source3.KeygenLaw087AuditEncoding\n\n'
    helpers += (ROOT / 'tools/key_law087_expr_dag.lean').read_text() + '\n'
    template = template.replace('run_cmd Lean.Elab.Command', helpers + 'run_cmd Lean.Elab.Command', 1)
    start = template.index('      | some term =>')
    end = template.index('      | none =>', start)
    body = '      | some term =>\n          let (root, (_, nodes)) :=\n            (FT1536.Source3.KeygenLaw087AuditEncoding.visit term).run ({}, #[])\n          let encodedExpr := Lean.toJson nodes\n          let decoded ← match (Lean.fromJson? encodedExpr : Except String\n              (Array FT1536.Source3.KeygenLaw087AuditEncoding.ExprNode)) with\n            | .ok value => pure value\n            | .error problem => throwError "DAG JSON decode failed: {problem}"\n          let restored ← match FT1536.Source3.KeygenLaw087AuditEncoding.restoreDag decoded root with\n            | .ok value => pure value\n            | .error problem => throwError "Expression decode failed: {problem}"\n          unless ← Lean.Meta.isDefEq term restored do\n            throwError "Expression roundtrip changed the term: {name}"\n          unless ← Lean.Meta.isDefEq (← Lean.Meta.inferType restored) info.type do\n            throwError "Expression roundtrip changed the type: {name}"\n          pure (Lean.Json.mkObj [("kind",Lean.toJson "full_expression_dag_json"),\n            ("term",encodedExpr),("root",Lean.toJson root),("metadata",Lean.toJson "nonsemantic mdata stripped; all expression nodes retained"),\n            ("roundtrip_term_and_type_checked",Lean.toJson true)])'
    template = template[:start] + body + '\n' + template[end:]
    target = ROOT / 'formal/Source3/KeygenLaw087Audit.lean'
    if target.exists():
        assert target.read_text() == template, 'audit reproduction mismatch'
    else:
        with target.open('x') as f:
            f.write(template)
    print(json.dumps({'audit': prior.pin(target), 'declarations': len(declarations())}))


def seal(label):
    inherited()
    assert not job.active(), job.active()
    folder = ROOT / '.build/jobs' / label
    records = json.loads((folder / 'RECEIPTS.json').read_text())
    assert len(records) == 3
    for record in records:
        assert record['accepted'] and record['clean_log'] and record['exit_code'] == 0
        assert not record['forbidden_proof_markers']
        assert (folder / record['stdout']).stat().st_size == 0
        assert (folder / record['stderr']).stat().st_size == 0
        prior.check(ROOT / 'formal/Source3' / (record['name'][8:] + '.lean'), record['source_sha256'])
    audit = json.loads((folder / 'SEARCH_AUDIT.json').read_text())
    names = {row['name'] for row in declarations()}
    assert {row['name'] for row in audit} == names and len(audit) == len(names)
    for row in audit:
        assert set(row['axioms']) <= {'propext', 'Classical.choice', 'Quot.sound'}
        assert '⋯' not in json.dumps(row, ensure_ascii=False)
        assert row['body']['kind'] == 'full_expression_dag_json'
        assert row['body']['roundtrip_term_and_type_checked'] is True
    evidence = [prior.pin(ROOT / f'formal/Source3/{name}.lean') for name in PROOFS + ['KeygenLaw087Audit']]
    evidence += [prior.pin(ROOT / p) for p in [
        'tools/key_law087_evidence.py', 'tools/key_law087_expr_dag.lean', 'tools/pre_sign086_job.py',
        'notes/run/KEYGEN_LAW_087_SOURCE_MAP.json', 'notes/run/KEYGEN_LAW_087_REPORT.md',
        'notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_087_NOTES.md', '.build/key_law087/ENTRY.json']]
    smap = json.loads((ROOT / 'notes/run/KEYGEN_LAW_087_SOURCE_MAP.json').read_text())
    evidence += smap['sources'] + smap['formal_and_scope_inputs']
    evidence += smap['preseal_metadata_history']
    evidence += [x['snapshot'] for x in smap['regions']]
    inputs = json.loads((folder / 'SOURCE_INPUTS.json').read_text())
    assert len(inputs['dependencies']) == 166
    for row in inputs['dependencies']:
        prior.check(row['source'], row['source_sha256'])
        prior.check(row['artifact'], row['artifact_sha256'])
        evidence += [prior.pin(row['source']), prior.pin(row['artifact'])]
    history = {}
    for path in sorted((ROOT / '.build/jobs').glob('key_law087_*')):
        rows = json.loads((path / 'RECEIPTS.json').read_text())
        failed = any(not r['accepted'] for r in rows)
        number = path.name.rsplit('_', 1)[1]
        if failed:
            assert number in FAILURES, ('UNEXPLAINED_JOB', number)
        history[number] = {'files': prior.job_files(path.name), 'failed_or_mixed': failed,
                           'cause': FAILURES.get(number), 'steps': len(rows)}
    value = {'batch': '087', 'stage': 'KEYGEN_LAW_BINDING',
        'status': 'BLOCKED_SOURCE_LAW_BINDING / NOT_REVIEWED',
        'acceptance': 'NOT_MET; exact generic D1 inference refuted, concrete C identity OPEN',
        'partial_result': 'PROVED_KERNEL_SCOPED: conditional-law algebra, correlated-retry counterexample, seed-support obstruction',
        'actual_key_law_constructed': False, 'actual_byte_game_constructed': False,
        'key_law_binding_produced': False, 'actual_c_e2_proved': False,
        'new_assumptions': False, 'independent_review': False, 'push': False,
        'do_sign_slot_items': 5, 'previous_postseal': prior.pin(PREVIOUS),
        'declarations': declarations(), 'counts': {'proof_modules': 2, 'audit_modules': 1,
            'declarations': len(names), 'theorems': sum(d['kind'] == 'theorem' for d in declarations()),
            'final_clean_modules': 3, 'inherited_pins': 22434, 'f04_dependencies': 166,
            'job_directories': len(history), 'failed_or_mixed_jobs': sum(h['failed_or_mixed'] for h in history.values())},
        'final_job': label, 'history': history, 'evidence': evidence,
        'proof_head': subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=REPO, text=True).strip()}
    print(json.dumps(prior.write(BASE, value)))


def postseal(expected):
    checked = dict(inherited())
    prior.check(BASE, expected)
    def add(path, sha):
        path = str(Path(path).resolve())
        prior.check(path, sha)
        assert path not in checked or checked[path] == sha, ('CONFLICTING_PIN', path)
        checked[path] = sha
    def walk(value):
        if isinstance(value, dict):
            if 'path' in value and 'sha256' in value:
                add(value['path'], value['sha256'])
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)
    add(PREVIOUS, PREVIOUS_SHA)
    add(BASE, expected)
    walk(json.loads(BASE.read_text()))
    assert not job.active(), job.active()
    print(json.dumps(prior.write(BUILD / 'POSTSEAL_087.json', {
        'status': 'PASS_INTEGRITY; KEYGEN_LAW_ACCEPTANCE_NOT_MET',
        'checked': checked, 'distinct_pinned_files': len(checked),
        'actual_key_law_constructed': False, 'independent_review': False, 'push': False})))


if __name__ == '__main__':
    command, *args = sys.argv[1:]
    if command == 'source-map' and not args:
        source_map()
    elif command == 'audit' and not args:
        audit_source()
    elif command in {'seal', 'postseal'} and len(args) == 1:
        with (ROOT / '.build/JOB.lock').open('a') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            (seal if command == 'seal' else postseal)(args[0])
    else:
        raise SystemExit('source-map | audit | seal FINAL_JOB | postseal RECEIPT_SHA256')
