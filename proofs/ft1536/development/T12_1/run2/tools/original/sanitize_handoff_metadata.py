#!/usr/bin/env python3
"""Metadata-only repack: omit unrelated IDE credential-bearing argv.

The first sealed local variant stays private in W. Mathematical sources,
execution tools, library pins, producer inputs and raw proof logs do not
change. A separate source-binding receipt records this fact; no repeated
mathematical execution is claimed.
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import shutil

W = Path(__file__).resolve().parent.parent
R, O = W / 'run', W / 'output'
PRIVATE = R / 'PRIVATE_UNPUBLISHED_OUTPUT_001'
REV = R / 'RESUME_A3_20260929/METADATA_REPACK_002'


def sha(p):
    h = hashlib.sha256()
    with p.open('rb') as f:
        for b in iter(lambda: f.read(1048576), b''):
            h.update(b)
    return h.hexdigest()


def write(p, obj):
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(json.dumps(obj, indent=2, sort_keys=True) + '\n')


def main():
    if PRIVATE.exists() or REV.exists():
        raise ValueError('repack already started; inspect state, no overwrite')
    first_outputs = sha(O / 'OUTPUTS.sha256')
    first_report = sha(O / 'REPORT.md')
    if first_outputs != '1e0fc45da3ce11b25afbe32049102bdd63689294a7b010f1ff5fe0be9c6d1aed':
        raise ValueError('unexpected first variant')
    records = json.loads((O / 'provenance/resume/INTAKE.json').read_text())
    selected = []
    for item in records.get('processes', []):
        cmd = item.get('cmd', '')
        if any(flag in cmd for flag in ['--csrf_token ', '--extension_server_csrf_token ', '--api-key ', '--password ']):
            selected.append(item['pid'])
            item.pop('cmd')
            item['process_name'] = 'unrelated IDE service'
            item['argv_omitted'] = 'not relevant to RUN_002 ownership; credential-bearing arguments excluded'
    if selected != [81328]:
        raise ValueError('unexpected ownership-record selection')
    REV.mkdir()
    shutil.copyfile(W / 'HANDOFF.md', REV / 'PRIVATE_FIRST_HANDOFF.md')
    shutil.copyfile(R / 'RESUME_A3_20260929/FINAL_HANDOFF_PINS.json', REV / 'PRIVATE_FIRST_PINS.json')
    O.rename(PRIVATE)
    shutil.copytree(PRIVATE, O)
    # The fresh copy is a new local version. The sealed first version is
    # retained byte-for-byte outside the deliverable and must not be shared.
    (O / 'OUTPUTS.sha256').unlink()
    (O / 'FREEZE.json').unlink()
    write(O / 'provenance/resume/INTAKE.json', records)
    original_inputs = (PRIVATE / 'REPLAY_INPUTS.sha256').read_text()
    input_rows = [line.split(maxsplit=1) for line in original_inputs.splitlines()]
    changed, lines = [], []
    for old, name in input_rows:
        new = sha(O / name)
        if old != new:
            changed.append({'path': name, 'before_sha256': old, 'after_sha256': new})
        lines.append(new + '  ' + name)
    if [c['path'] for c in changed] != ['provenance/resume/INTAKE.json']:
        raise ValueError('non-ownership replay input changed')
    replay = R / 'final_fresh_replay_20260929_002'
    build = json.loads((O / 'BUILD.json').read_text())
    source_bindings = []
    for module in build['modules']:
        rel = 'formal/' + module.replace('.', '/') + '.lean'
        if sha(O / rel) != sha(replay / rel):
            raise ValueError('formal source differs from completed replay')
        source_bindings.append({'path': rel, 'sha256': sha(O / rel), 'matches_completed_replay': True})
    for item in build['sage']:
        rel = 'sage/' + item['source']
        if sha(O / rel) != sha(replay / rel):
            raise ValueError('Sage source differs from completed replay')
        source_bindings.append({'path': rel, 'sha256': sha(O / rel), 'matches_completed_replay': True})
    for rel, replay_rel in [('tools/replay.py', 'REPLAY_SOURCE.py'), ('tools/execution.py', 'EXECUTION_SOURCE.py')]:
        if sha(O / rel) != sha(replay / replay_rel):
            raise ValueError('execution tool differs from completed replay')
        source_bindings.append({'path': rel, 'sha256': sha(O / rel), 'matches_completed_replay': True})
    # Preserve the ORIGINAL replay receipt and its original input-manifest
    # hash. This is not relabelled as a run against the repacked manifest.
    (O / 'provenance/COMPLETED_REPLAY_INPUTS.sha256').write_text(original_inputs)
    (O / 'REPLAY_INPUTS.sha256').write_text('\n'.join(lines) + '\n')
    original_pin, current_pin = sha(PRIVATE / 'REPLAY_INPUTS.sha256'), sha(O / 'REPLAY_INPUTS.sha256')
    now = datetime.now(timezone.utc).isoformat()
    binding = {'status': 'PASS_CURRENT_SOURCES_METADATA_ONLY_REPACK', 'utc': now,
        'original_completed_replay_manifest_sha256': original_pin,
        'current_replay_manifest_sha256': current_pin, 'changed_replay_inputs': changed,
        'all_other_replay_input_bytes_unchanged': True, 'formal_modules': len(build['modules']),
        'sage_sources': len(build['sage']), 'execution_tools': 2, 'bindings': source_bindings,
        'completed_replay_result_sha256': sha(replay / 'REPLAY_RESULT.json'),
        'mathematics_reexecuted_for_metadata_change': False,
        'scope': 'same proof/generator/tool/library bytes; only unrelated ownership argv omitted'}
    write(O / 'replay/CURRENT_SOURCE_BINDING.json', binding)
    errata = f'''# METADATA_ERRATA — wariant przekazania 002

UTC: {now}.

Początkowy zrzut procesów w provenance/resume/INTAKE.json przechwycił
argumenty niezwiązanej z tym W usługi IDE, w tym tokeny techniczne.
W wersji przekazywanej pominięto te argumenty. Pozostawiono PID, katalog
i informację, że chodziło o obcą usługę. Nie publikujemy wartości tokenów.

To jedyna zmiana w członkach wejścia wykonanego replayu. **130 źródeł Lean,
6 źródeł Sage, oba narzędzia wykonania, konfiguracja, wejścia producentów,
biblioteki i raw logs dowodów są identyczne.** Nowy receipt
replay/CURRENT_SOURCE_BINDING.json sprawdza ten binding.

Wykonany pełny replay miał wejście:
`{original_pin}`.
Jego oryginalnego receiptu nie zmieniono i nie przypisano mu innego pinu.
Oczyszczony pakiet do ponownego odtworzenia ma REPLAY_INPUTS:
`{current_pin}`.
Zmiana ownership metadata nie wymagała powtarzania zakończonych obliczeń.

Pierwsza lokalna wersja została zachowana poza output, w prywatnym katalogu
roboczym; nie jest przeznaczona do przekazania/importu. Ostateczne REPORT/
OUTPUTS i handoff dotyczą wyłącznie bieżącego output. Status matematyczny
PARTIAL_PROOF oraz otwarte M6/T5 pozostają niezmienione.
'''
    (O / 'METADATA_ERRATA.md').write_text(errata)
    shutil.copyfile(Path(__file__), O / 'tools/sanitize_handoff_metadata.py')
    report = (O / 'REPORT.md').read_text()
    report = report.replace(f'- Freeze UTC: `{json.loads((PRIVATE / "FREEZE.json").read_text())["utc"]}`.',
                            f'- Freeze wariantu przekazania002 UTC: `{now}`.')
    report = report.replace(f'- External REPLAY_INPUTS SHA256: `{original_pin}`.',
        f'- Wejście wykonanego replayu SHA256: `{original_pin}`.\n'
        f'- Aktualne oczyszczone REPLAY_INPUTS SHA256: `{current_pin}`. '
        'Binding niezmienionych źródeł: `replay/CURRENT_SOURCE_BINDING.json`; szczegóły: `METADATA_ERRATA.md`.')
    report += '\n## Korekta metadanych przekazania\n\n'
    report += 'Z kopii ownership usunięto argumenty cudzej usługi IDE. Źródła matematyczne i raw proof logs są identyczne z ukończonym replayem. Oryginalny receipt replayu zachowuje swój pin; nowy manifest oraz jawny binding opisują oczyszczony wariant. Nie wykonywano ponownie matematyki ani nie zmieniano jej zakresu.\n'
    (O / 'REPORT.md').write_text(report)
    for name in ['REPLAY.md']:
        text = (O / name).read_text().replace(original_pin, current_pin)
        text += '\nCompleted replay retains its original pin; metadata-only repack is bound in replay/CURRENT_SOURCE_BINDING.json and METADATA_ERRATA.md.\n'
        (O / name).write_text(text)
    result = json.loads((O / 'RESULT.json').read_text())
    result.update(freeze_utc=now, handoff_variant='002_METADATA_SANITIZED',
        current_source_binding='replay/CURRENT_SOURCE_BINDING.json',
        current_replay_inputs_sha256=current_pin,
        mathematical_sources_identical_to_completed_replay=True,
        metadata_errata='METADATA_ERRATA.md')
    write(O / 'RESULT.json', result)
    write(O / 'FORMAL_REPLAY_BINDINGS.json', {
        **json.loads((O / 'FORMAL_REPLAY_BINDINGS.json').read_text()),
        'current_manifest_binding': 'replay/CURRENT_SOURCE_BINDING.json'})
    report_pin = sha(O / 'REPORT.md')
    handoff = (O / 'HANDOFF.md').read_text().replace(first_report, report_pin)
    handoff += '\nHandoff variant002 omits unrelated IDE argv. All mathematical replay sources/logs are unchanged; see METADATA_ERRATA.md. Only the current output is for transfer.\n'
    (O / 'HANDOFF.md').write_text(handoff)
    write(O / 'FREEZE.json', {'status': 'FROZEN_AWAITING_INDEPENDENT_REVIEW',
        'mathematical_status': 'PARTIAL_PROOF', 'handoff_variant': '002_METADATA_SANITIZED', 'utc': now,
        'report_sha256': report_pin, 'replay_inputs_sha256': current_pin,
        'completed_replay_input_sha256': original_pin,
        'current_source_binding_sha256': sha(O / 'replay/CURRENT_SOURCE_BINDING.json')})
    # Check public text without printing any matched value. Compressed
    # histories are unchanged and contain no copy of this intake record.
    pattern = re.compile(rb'--(?:csrf_token|extension_server_csrf_token|api-key|password)\s+[A-Za-z0-9_-]{12,}')
    for p in O.rglob('*'):
        if p.is_file() and p.suffix in {'.json', '.md', '.txt', '.stdout', '.stderr', '.log'}:
            if pattern.search(p.read_bytes()):
                raise ValueError('credential-bearing argv remains in public text: ' + str(p.relative_to(O)))
    lines = [sha(p) + '  ' + str(p.relative_to(O)) for p in sorted(O.rglob('*')) if p.is_file()]
    (O / 'OUTPUTS.sha256').write_text('\n'.join(lines) + '\n')
    for line in (O / 'OUTPUTS.sha256').read_text().splitlines():
        expected, rel = line.split(maxsplit=1)
        if sha(O / rel) != expected:
            raise ValueError('final member mismatch')
    output_pin = sha(O / 'OUTPUTS.sha256')
    pins = {'status': 'PARTIAL_PROOF', 'handoff_variant': '002_METADATA_SANITIZED', 'freeze_utc': now,
        'report_sha256': report_pin, 'outputs_sha256': output_pin, 'members': len(lines),
        'replay_inputs_sha256': current_pin, 'completed_replay_inputs_sha256': original_pin,
        'current_source_binding_sha256': sha(O / 'replay/CURRENT_SOURCE_BINDING.json')}
    write(REV / 'REPACK_RECEIPT.json', pins)
    write(R / 'RESUME_A3_20260929/FINAL_HANDOFF_PINS.json', pins)
    (W / 'HANDOFF.md').write_text(f'''# FT1536_MATH_EUFCMA_MTISIS_RUN_002 — handoff 002

Status: PARTIAL_PROOF / FROZEN_AWAITING_INDEPENDENT_REVIEW.
Project: Niirmata. Model: openai/gpt-6-astra-fast.
Session: ses_f13464e70ffeuAM6Xf31ztFHAS. Freeze UTC: {now}.

Package: {O}
REPORT_SHA256={report_pin}
OUTPUTS_SHA256={output_pin}
REPLAY_INPUTS_SHA256={current_pin}
COMPLETED_REPLAY_INPUTS_SHA256={original_pin}
CURRENT_SOURCE_BINDING_SHA256={pins['current_source_binding_sha256']}

A3: resources and concrete advantage in the declared reference execution
model, with explicit local A/S and joint-law certificates. Completed fresh
replay:130 modules,1125 exports,138 accepted jobs. All compute ended.
Open M6/T5/source/instantiation types: output/NEXT_INTERFACE.md.

Metadata variant002 omits unrelated IDE argv. Proof/generator/tool/library
bytes and raw math logs are identical to the completed replay. Its original
receipt retains its original pin; the current source binding is explicit.
Only the current output is for transfer; older private local variants are
not deliverables. Coordinator: independent review -> accepted stages -> Git.
''')
    print(json.dumps(pins, indent=2), flush=True)


if __name__ == '__main__':
    main()
