#!/usr/bin/env python3
"""Seal a successful current-source replay and its precisely scoped report."""
from datetime import datetime, timezone
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import sys

W = Path(__file__).resolve().parent.parent
R, O = W / 'run', W / 'output'


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def write(p, data):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(data, indent=2, sort_keys=True) + '\n')


def copy(p, q):
    q.parent.mkdir(parents=True, exist_ok=True)
    if q.exists():
        if sha(q) != sha(p):
            raise ValueError('seal destination conflict: ' + str(q))
    else:
        shutil.copyfile(p, q)


def verify_manifest(base, name):
    for line in (base / name).read_text().splitlines():
        h, rel = line.split(maxsplit=1)
        p = Path(rel)
        if p.is_absolute() or '..' in p.parts or (base / p).is_symlink() or sha(base / p) != h:
            raise ValueError('manifest mismatch: ' + rel)


def main():
    fresh = Path(sys.argv[1]).resolve()
    if not fresh.is_relative_to(R):
        raise ValueError('replay must be in this W')
    if (O / 'OUTPUTS.sha256').exists():
        raise ValueError('already sealed; no overwrite')
    rr = json.loads((fresh / 'REPLAY_RESULT.json').read_text())
    er = json.loads((fresh / 'EXECUTION_RECEIPTS.json').read_text())
    if rr['status'] != 'PASS' or er['status'] != 'PASS':
        raise ValueError('fresh replay is not PASS')
    for proc in Path('/proc').glob('[0-9]*'):
        if int(proc.name) == os.getpid():
            continue
        try:
            argv = [a.decode(errors='replace') for a in (proc / 'cmdline').read_bytes().split(b'\0') if a]
            cwd = (proc / 'cwd').resolve()
            if argv and cwd.is_relative_to(W) and (Path(argv[0]).name in {'lean', 'sage', 'lake'} or
                    any(Path(a).name in {'job.py', 'replay.py', 'final_replay.py', 'a3_job.py'} for a in argv[1:])):
                raise RuntimeError('own compute is still active: ' + proc.name)
        except (FileNotFoundError, PermissionError):
            continue
    if rr['external_manifest_sha256'] != sha(O / 'REPLAY_INPUTS.sha256'):
        raise ValueError('fresh replay not bound to current inputs')
    verify_manifest(O, 'REPLAY_INPUTS.sha256')
    build = json.loads((O / 'BUILD.json').read_text())
    exports = json.loads((O / 'FORMAL_EXPORTS.json').read_text())['exports']
    axioms = json.loads((fresh / 'AXIOMS.json').read_text())
    if set(axioms) != {e['name'] for e in exports} or any(
            set(a) - {'propext', 'Classical.choice', 'Quot.sound'} for a in axioms.values()):
        raise ValueError('axiom audit mismatch')
    records = {r['name']: r for r in er['jobs']}
    for rec in er['jobs']:
        if not rec['accepted'] or not rec['clean_log'] or rec['forbidden_proof_markers']:
            raise ValueError('unclean replay record')
        for key in ['stdout', 'stderr']:
            if sha(fresh / rec[key]) != rec[key + '_sha256']:
                raise ValueError('raw log changed')
    for module in build['modules']:
        rel = module.replace('.', '/') + '.lean'
        rec = records[module.replace('.', '_')]
        if rec['source_sha256'] != sha(O / 'formal' / rel) or sha(fresh / 'formal' / rel) != sha(O / 'formal' / rel):
            raise ValueError('source/replay binding differs: ' + module)
    for p in sorted((fresh / 'logs').iterdir()):
        if p.is_file():
            copy(p, O / 'replay/logs' / p.name)
    for name in ['REPLAY_RESULT.json', 'EXECUTION_RECEIPTS.json', 'AXIOMS.json', 'REPLAY_SOURCE.py', 'EXECUTION_SOURCE.py']:
        copy(fresh / name, O / 'replay' / name)
    for p in sorted((fresh / 'work').rglob('*.json')):
        copy(p, O / 'replay/products' / p.relative_to(fresh / 'work'))
    copy(fresh / 'logs/FinalAudit.stdout', O / 'formal_types.txt')
    copy(fresh / 'AXIOMS.json', O / 'AXIOMS.json')
    for p in sorted((R / 'FINAL_EVIDENCE_20260929').rglob('*')):
        if p.is_file():
            copy(p, O / p.relative_to(R / 'FINAL_EVIDENCE_20260929'))
    failed_replays = []
    for previous in sorted(R.glob('final_fresh_replay_20260929_*')):
        if previous == fresh or not (previous / 'REPLAY_RESULT.json').is_file():
            continue
        record = {'path': str(previous), 'result': json.loads((previous / 'REPLAY_RESULT.json').read_text()),
                  'changed_source_snapshots': []}
        base = O / 'history/replay_attempts' / previous.name
        for p in sorted((previous / 'logs').iterdir()):
            if p.is_file():
                copy(p, base / 'logs' / p.name)
        for name in ['REPLAY_RESULT.json', 'EXECUTION_RECEIPTS.json', 'REPLAY_SOURCE.py', 'EXECUTION_SOURCE.py']:
            if (previous / name).is_file():
                copy(previous / name, base / name)
        for folder, suffix in [('formal', '*.lean'), ('sage', '*.sage')]:
            for p in sorted((previous / folder).rglob(suffix)):
                rel = p.relative_to(previous)
                h = sha(p)
                if (O / rel).is_file() and sha(O / rel) == h:
                    continue
                stored = 'history/source-objects/' + h + ''.join(p.suffixes) + '.gz'
                q = O / stored
                if not q.exists():
                    q.parent.mkdir(parents=True, exist_ok=True)
                    with p.open('rb') as src, q.open('wb') as raw:
                        with gzip.GzipFile(fileobj=raw, mode='wb', filename='', mtime=0) as gz:
                            shutil.copyfileobj(src, gz, 1048576)
                record['changed_source_snapshots'].append({'source': str(rel), 'sha256': h, 'stored': stored})
        failed_replays.append(record)
    write(O / 'history/REPLAY_ATTEMPTS.json', failed_replays)
    for p in sorted((R / 'RESUME_A3_20260929').glob('INPUT_REVISION_*/*')):
        if p.is_file():
            copy(p, O / 'provenance/resume' / p.relative_to(R / 'RESUME_A3_20260929'))
    for p in sorted((R / 'RESUME_A3_20260929').glob('*_PREFLIGHT.json')):
        copy(p, O / 'provenance/resume' / p.name)
    for p in sorted((R / 'RESUME_A3_20260929').glob('PEER_WAIT_*.json')):
        copy(p, O / 'provenance/resume' / p.name)
    for p in sorted((R / 'failed-tools').rglob('*')):
        if p.is_file():
            copy(p, O / 'history/failed-tools' / p.relative_to(R / 'failed-tools'))
    for name in ['radial_engine.pyx', 'radial_engine.c', 'setup.py']:
        if (R / name).is_file():
            copy(R / name, O / 'history/radial_engine_source' / name)
    for p in sorted((R / 'RESUME_A3_20260929').glob('*.controller.*')):
        copy(p, O / 'provenance/resume' / p.name)
    for name in ['wait_preparation.py', 'collect_final_evidence.py', 'seal_final_package.py']:
        copy(R / name, O / 'tools' / name)
    copy(R / 'A3_RESOURCE_BOUND_DRAFT.md', O / 'RESOURCE_BOUND.md')
    copy(R / 'A3_NEXT_INTERFACE_DRAFT.md', O / 'NEXT_INTERFACE.md')
    now = datetime.now(timezone.utc).isoformat()
    report = (R / 'A3_REPORT_DRAFT.md').read_text()
    report += '\n## Aktualny replay i piny wejścia\n\n'
    report += f'- Freeze UTC: `{now}`.\n'
    report += f'- Własne moduły: **{len(build["modules"])}/{len(build["modules"])}**, świeży cache projektu.\n'
    report += f'- Audyt: **{len(exports)}** nazwanych eksportów, w tym **{sum(e["new_a3"] for e in exports)}** nowych A3.\n'
    report += '- Aksjomaty dowodowe wyłącznie `propext`, `Classical.choice`, `Quot.sound`; część eksportów bez aksjomatów.\n'
    report += f'- Łącznie **{len(er["jobs"])}** zaakceptowanych kroków, w tym wersje toolchain i sześć natywnych Sage.\n'
    report += '- Sprawdzono deterministyczne generatory Certificate, NumericCertificate, FieldConstants oraz CountsFoldCertificate względem przekazywanych źródeł.\n'
    report += f'- External REPLAY_INPUTS SHA256: `{sha(O / "REPLAY_INPUTS.sha256")}`.\n'
    report += f'- REPLAY_RESULT SHA256: `{sha(fresh / "REPLAY_RESULT.json")}`.\n'
    report += '- Współdzielone przypięte biblioteki RO: źródła i artefakty zweryfikowane; bibliotek nie kompilowano ponownie.\n'
    report += '- Raw logs, source bindings, source history i receipty są dołączone. Powyższy replay dotyczy aktualnego pakietu, nie starego snapshotu34/34.\n'
    report += '- Wszystkie obliczenia tego wznowienia zakończone przed seal; brak Git/push i innych modeli.\n'
    (O / 'REPORT.md').write_text(report)
    result = {
        'schema': 'FT1536_RUN002_A3_RESOURCE_COMPOSITION_V1', 'task_id': 'FT1536_MATH_EUFCMA_MTISIS_RUN_002',
        'roadmap_id': 'T12.1', 'status': 'PARTIAL_PROOF', 'handoff_status': 'FROZEN_AWAITING_INDEPENDENT_REVIEW',
        'freeze_utc': now, 'project_author': 'Niirmata', 'model': 'openai/gpt-6-astra-fast',
        'session': 'ses_f13464e70ffeuAM6Xf31ztFHAS', 'fresh_replay': rr,
        'A3_global_resources_proved_in_declared_reference_model': True,
        'A3_advantage_conjunction': 'ResourceReduction.exists_resource_bounded_concrete_reducer',
        'resource_semantics': 'maxima of actual annotated reference execution; ResourceRealization provides fixed code-family witness and proved erasure',
        'resource_bound_kind': 'upper bound; no claim of attainable maximum or actual C/CPU cost',
        'local_certificates_only': True, 'new_a3_modules': 10, 'new_a3_exports': sum(e['new_a3'] for e in exports),
        'formal_exports_audited': len(exports), 'M6_hbLo_hbHi_closed': False, 'M6_kernel_tail_consumption_closed': False,
        'all_key_probability_bound_proved': False, 'C_KeyGen_Gram_leaf_binding_proved': False,
        'T5_final_box_transport_consumed': False, 'historical_error_rounding': '1.27e-24 under stated numerical/analytic bindings',
        'public_sampler_instantiated': False, 'small_e_instantiated': False, 'real_PRNG_bridge': False,
        'source_security_proved': False, 'independently_reviewed': False, 'owner_accepted': False,
        'jobs_running_at_handoff': False, 'git_performed': False, 'push_performed': False,
        'missing_types': 'NEXT_INTERFACE.md', 'exact_formal_types_and_terms': 'formal_types.txt',
        'task_sha256': 'b4c11e3cf2a8cf3939a88400a2ea157b9d835e52c02aa974494b93b5f1376e45',
        'bootstrap_sha256': 'fe10e6e2f05022bbe0f699551ff09d9c22c5a00cfea8f6a744d85355d61a8aad',
    }
    write(O / 'RESULT.json', result)
    write(O / 'ASSUMPTIONS.json', {
        'theorem': 'FT1536.Run2.ResourceReduction.exists_resource_bounded_concrete_reducer',
        'ambient': ['SK : Type', 'Fintype SK', 'beta : Budget', 'muKey : Law (SK x Rq)',
                    'A : ClassicalAdversary beta', 'S : Sampler', 'e : Real'],
        'adversary_local': {'type': 'LocalMachineCode.AdversaryCertificate beta A',
            'fields': ['finite read/output literal code', 'Fits beta.bytes (A.code h coins) for every h/coins',
                       'local resume equals Program head at every At history']},
        'sampler_local': {'type': 'LocalMachineCode.SamplerCertificate beta S',
            'fields': ['finite read/output literal code', 'local run equals S.code on bounded state/message and its fair bits']},
        'joint_law': {'type': 'LocalJointCertificate S e', 'fields': [
            '0 <= e', 'forall h st m r, AC (samplerLaw S h st m r) (freshHonest h)',
            'forall h st m r, second (samplerLaw S h st m r) (freshHonest h) <= 1+e']},
        'no_whole_reducer_cost_premise': True, 'no_advantage_premise_in_local_certificates': True,
        'hardness_corollary_additional': ['epsilon <= 1', 'MT advantage <= epsilon for solvers with stated ResourceRealization'],
        'declared_cost_model': 'RESOURCE_BOUND.md; including fixed controller reservation and recursive arena convention',
        'not_instantiated': ['effective S', 'small e', 'C/PRNG/source bindings', 'all-KeyGen M6/T5 premises'],
        'printed_types': 'formal_types.txt'})
    write(O / 'RESOURCE_BOUND.json', {'definitions': ['ResourceReduction.resourceBound', 'ResourceReduction.Resources',
        'ResourceReduction.ResourceRealization'], 'bound_kind': 'conservative upper bound',
        'units': {'t': 'reference bit operations', 'w': 'peak reference bit cells', 'L': 'padded-byte transport traffic'},
        'formula': 'RESOURCE_BOUND.md', 'exact_arithmetic': 'replay/products/sage_resources/resource_envelope.json',
        'attainable_maximum_claim': False, 'C_compiler_machine_binding': False})
    write(O / 'GOAL_SPEC.json', {'task_id': result['task_id'], 'status': result['status'],
        'closed_scope': 'A1/A2 inherited concrete laws plus A3 resource composition in the declared reference model',
        'open_scope': ['M6 exact-window numerical binding', 'kernel tail facts', 'all-C-KeyGen Gram/leaf and T5 box transport',
                       'sampler/error/source instantiation'], 'actual_types': 'formal_types.txt'})
    (O / 'GOAL_SPEC.md').write_text('# GOAL_SPEC\n\nTASK.md preserves the pinned order A1/A2/A3.\n'
        'The current achieved theorem and its exact local assumptions are in REPORT.md and formal_types.txt.\n'
        'Resources of the semantic B are expressed by the proved ResourceRealization conclusion.\n'
        'The retained M6/T5/source obligations are listed by type in NEXT_INTERFACE.md.\n')
    (O / 'MODEL.md').write_text('# MODEL\n\nE0/coefficient-valued finite-box G16, unchanged cap16 and Emit.\n'
        'Games.lean defines the experiments, arbitrary byte queries, forty-byte nonce, SeenSign including aborts,\n'
        'finite QH+1 indexed targets, and ordinary-message freshness. muH is the public marginal of muKey.\n'
        'The concrete machine executes LocalMachineCode A/S and fixed public finite-file procedures.\n'
        'Its units, allocation convention, explicit code storage and upper bounds are in RESOURCE_BOUND.md.\n'
        'Typed literal leaves are canonical static output files; mathematical vector decoding is their denotation.\n'
        'The proof does not assert a C/Lean compiler or physical CPU cost model.\n')
    (O / 'BRIDGE_LEDGER.md').write_text('# BRIDGE_LEDGER\n\n'
        '| Bridge | Status | Export |\n|---|---|---|\n'
        '| Local bit code to typed outputs | kernel | LocalMachineCode.erasure |\n'
        '| Actual resume/sample execution to Reduction.build | kernel | MachineExecution.build_binding |\n'
        '| Metered execution erasure | kernel | MeteredExecution.erasure |\n'
        '| Global prefix resources and reachable finish | kernel | PrefixResources.execution_bound |\n'
        '| Finite witness output and final costs | kernel | FinishResources.fileFinish_correct / finalCost_bound |\n'
        '| Whole reducer resources and law | kernel | ResourceReduction.resources_bound / run_binding |\n'
        '| Resources with concrete advantage | kernel, local certificates explicit | exists_resource_bounded_concrete_reducer |\n'
        '| M6 engine endpoints to window mass | OPEN | hbLo/hbHi in NEXT_INTERFACE.md |\n'
        '| Required tail facts to kernel | OPEN | hchange/htail |\n'
        '| C-KeyGen to Gram/leaves and box-tail | OPEN, separate RO T5 | T5_DEPENDENCY_STATUS.json |\n'
        '| Sampler/small e/real PRNG/C security | OPEN | ASSUMPTIONS.json |\n')
    (O / 'DEPENDENCY_ATTRIBUTION.md').write_text('# Atrybucja\n\nProjekt FT1536: Niirmata (niirmataa).\n'
        'Falcon Project / Thomas Pornin i licencje źródeł zostały zachowane.\n'
        'Odziedziczone źródła Lean, Mathlib i inne biblioteki zachowują własne nagłówki i autorów.\n'
        'Pliki licencyjne: dependency-licenses/. Piny: SOURCE_BINDINGS.json i LIBRARY_CLOSURE.json.\n'
        'Wyniki MiMo v2.1 mają odrębną atrybucję w zachowanym archiwum wejściowym.\n')
    (O / 'REPLAY.md').write_text('# Fresh replay\n\n'
        f'External REPLAY_INPUTS SHA256: `{sha(O / "REPLAY_INPUTS.sha256")}`.\n\n'
        '`python3 -B tools/replay.py --bundle <output> --dest <new-directory-under-W> '
        '--manifest-sha <external-pin>`\n\n'
        'This starts from an empty project lib. All current formal modules, all named export types/axioms,\n'
        'new A3 proof terms, and six .sage jobs are replayed, with generated Lean bytes compared to the inputs.\n'
        'Source/hash-pinned external library caches are read-only and not rebuilt.\n'
        'Historical research scripts are retained as history and are not counted as newly replayed math.\n'
        'The 34/34 historical replay is not used as a replay of this package.\n')
    (O / 'FAILED_ROUTES.md').write_text('# Zachowane próby i ograniczenia\n\n'
        'history/attempts/ holds raw logs and receipts, including failures. SOURCE_SNAPSHOTS.json binds\n'
        'source versions either to current files or to gzip content-addressed objects. RAW_LOG_BINDINGS\n'
        'checks the stored receipt hashes. Failed declarations were never accepted into the proof cache.\n'
        'Current non-proof probes, Scratch and the external-assumption rawBadEnclosure draft are explicitly\n'
        'excluded from BUILD.json and preserved in history/non_proof_sources/.\n'
        'New A3 failures were elaboration/projection or strict-linter failures; no axiom target was introduced.\n'
        'A harness restart detached final_package.py; pidfd observation and products establish completion,\n'
        'not a fabricated controller exit code. All current accepted sources underwent the fresh replay.\n'
        'The first current replay stopped at Sage Integer JSON metadata serialization (no Lean proof-source change).\n'
        'The failed replay logs and original source are preserved; a subsequent preflight deferred while a foreign Lean ran.\n'
        'M6/T5 remain genuine open proof obligations, detailed in NEXT_INTERFACE.md.\n')
    copy(W / 'WORK_STATE.md', O / 'provenance/WORK_STATE_BEFORE_FREEZE.md')
    write(O / 'EXECUTION_RECEIPTS.json', er)
    write(O / 'FORMAL_REPLAY_BINDINGS.json', {'modules': [
        {'module': m, 'source_sha256': records[m.replace('.', '_')]['source_sha256'],
         'receipt': 'replay/logs/' + m.replace('.', '_') + '.receipt.json',
         'raw_stdout_sha256': records[m.replace('.', '_')]['stdout_sha256'],
         'olean_sha256': records[m.replace('.', '_')]['olean_sha256']} for m in build['modules']],
        'replay_result_sha256': sha(fresh / 'REPLAY_RESULT.json')})
    report_hash = sha(O / 'REPORT.md')
    (O / 'HANDOFF.md').write_text('# HANDOFF — PARTIAL_PROOF, niezależny odbiór oczekiwany\n\n'
        f'REPORT SHA256: `{report_hash}`.\n\n'
        'A3 is proved for the declared executable reference model, with local A/S and joint-law certificates.\n'
        'M6/window/tail/source-KeyGen/T5 and concrete sampler/error/security instantiations remain open.\n'
        'Read REPORT.md, RESOURCE_BOUND.md, ASSUMPTIONS.json, formal_types.txt and NEXT_INTERFACE.md.\n'
        'All compute jobs have ended. Coordinator performs independent review, accepted stage import and Git.\n'
        'OUTPUTS.sha256 includes this file; its external SHA256 is supplied in the parent W/HANDOFF.md\n'
        'and in the owner-facing handoff, avoiding a self-referential hash cycle.\n')
    # These unsealed preparation markers have never been in REPLAY_INPUTS.
    copy(O / 'NOT_FROZEN.md', O / 'history/preparation/NOT_FROZEN.md')
    copy(O / 'PREPARATION.json', O / 'history/preparation/PREPARATION.json')
    (O / 'NOT_FROZEN.md').unlink()
    (O / 'PREPARATION.json').unlink()
    write(O / 'FREEZE.json', {'status': 'FROZEN_AWAITING_INDEPENDENT_REVIEW', 'mathematical_status': 'PARTIAL_PROOF',
        'utc': now, 'report_sha256': report_hash, 'replay_inputs_sha256': sha(O / 'REPLAY_INPUTS.sha256'),
        'fresh_replay_result_sha256': sha(fresh / 'REPLAY_RESULT.json')})
    lines = []
    forbidden = []
    for p in sorted(O.rglob('*')):
        if p.is_symlink():
            raise ValueError('symlink in final bundle: ' + str(p))
        if p.is_file():
            if p.suffix in {'.so', '.o', '.pyc', '.olean', '.ir', '.ilean'} or '.olean.' in p.name:
                forbidden.append(str(p.relative_to(O)))
            lines.append(sha(p) + '  ' + str(p.relative_to(O)))
    if forbidden:
        raise ValueError('compiled/cache payload in bundle: ' + repr(forbidden))
    (O / 'OUTPUTS.sha256').write_text('\n'.join(lines) + '\n')
    verify_manifest(O, 'OUTPUTS.sha256')
    output_hash = sha(O / 'OUTPUTS.sha256')
    handoff = f'''# FT1536_MATH_EUFCMA_MTISIS_RUN_002 — frozen handoff

Status: PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW.
Project: Niirmata; model openai/gpt-6-astra-fast; session ses_f13464e70ffeuAM6Xf31ztFHAS.
Freeze UTC: {now}.

Package: {O}
REPORT_SHA256={report_hash}
OUTPUTS_SHA256={output_hash}
REPLAY_INPUTS_SHA256={sha(O / 'REPLAY_INPUTS.sha256')}

A3: composed resources of the declared reference executor and concrete advantage theorem,
with explicit local code/law certificates. Fresh replay: {len(build['modules'])} modules,
{len(exports)} named exports, {len(er['jobs'])} accepted jobs. No active compute jobs.
Open M6/T5/source and instantiation obligations: output/NEXT_INTERFACE.md.
Coordinator: independent review -> accepted stages -> local main commit. No executor Git/push.
'''
    (W / 'HANDOFF.md').write_text(handoff)
    pins = {'report_sha256': report_hash, 'outputs_sha256': output_hash, 'members': len(lines),
            'replay_inputs_sha256': sha(O / 'REPLAY_INPUTS.sha256'), 'status': 'PARTIAL_PROOF', 'freeze_utc': now}
    write(R / 'RESUME_A3_20260929/FINAL_HANDOFF_PINS.json', pins)
    print(json.dumps(pins, indent=2), flush=True)


if __name__ == '__main__':
    main()
