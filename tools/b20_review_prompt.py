#!/usr/bin/env python3
"""Generate a paired-review prompt skeleton for one B20_001 reviewer (Vxx).

Reads INDEX.json for the Vxx entry and STATUS.json for already-bound author
pins. Before the author handoff exists, the prompt ships with explicit
placeholders; never invent pins. The skeleton follows the established review
prompt structure (roles, identification, pins, claims, integrity, replay).

Usage: python3 -B tools/b20_review_prompt.py V01 [--out PATH]
"""
import argparse
import importlib.util
import json
from pathlib import Path

B = Path(__file__).resolve().parents[1] / 'proofs/ft1536/batches/B20_001'
REPO = B.parents[3]
spec = importlib.util.spec_from_file_location('b20_bindings', REPO / 'tools/b20_status_set.py')
bindings = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bindings)
archive = bindings.archive


def placeholder(label):
    return f'<<DO_WYPEŁNIENIA_Z_HANDOFFU: {label}>>'


def load_pair(vid):
    index = json.loads((B / 'INDEX.json').read_text())
    status = json.loads((B / 'STATUS.json').read_text())
    entry = next((e for e in index['entries'] if e['id'] == vid), None)
    if entry is None or entry['role'] != 'reviewer':
        raise SystemExit(f'{vid}: no reviewer entry in INDEX.json')
    pid = entry['paired']
    peer = next((e for e in index['entries'] if e['id'] == pid), None)
    archive.require(peer is not None and peer['role'] == 'author' and peer['paired'] == vid,
                    'Broken author/reviewer pairing in INDEX')
    bound = status['tasks'].get(pid, {})
    return index, entry, peer, bound


def render(index, entry, peer, bound):
    vid, pid = entry['id'], peer['id']
    task_path = B / entry['document']
    peer_task = B / peer['document']
    manifest = archive.manifest(archive.read(B / 'PACKAGE.sha256'))
    for e in (entry, peer):
        archive.checked_path(e['document'])
        archive.require(manifest.get(e['document']) == e['document_sha256'], 'TASK pin differs from PACKAGE')
        archive.checked_bytes(B / e['document'], e['document_sha256'])
    pins = []
    if bound.get('final_report_sha256'):
        bindings.verify_frozen_row(B.parents[1], peer, bound)
        pins.append(f"{pid} REPORT_SHA256: {bound['final_report_sha256']}")
        pins.append(f"{pid} OUTPUTS_SHA256: {bound['final_outputs_sha256']}")
        pins.append(f"{pid} HEAD: {bound.get('head') or placeholder('source HEAD z HANDOFF autora')}")
        pins.append(f"{pid} REPORT: {bound['final_report_path']}")
        pins.append(f"{pid} OUTPUTS: {bound['final_outputs_path']}")
    else:
        pins.append(placeholder(f'piny {pid} REPORT/OUTPUTS/HEAD — po handoffie autora'))
    text = f"""# {vid} — {entry['title']} — niezależna weryfikacja

Autor projektu Niirmata. Pakiet B20_001, rewizja {index['revision']}.
Rola: RECENZENT. ROADMAP_ID={entry['roadmap']}. TASK_ID={entry['task_id']}. Para={pid}.
Nie jesteś wykonawcą dowodu. Ocenasz wynik, odtwarzasz obliczenia i szukasz luk;
nie dążysz do PASS za wszelką cenę.

## 1. Identyfikacja

```text
REPO={index['checkout']}
SOURCE_BASE={index['source_base_commit']}
W={entry['workspace']}
TASK={task_path}
TASK_SHA256={entry['document_sha256']}
PEER_TASK={peer_task}
PEER_TASK_SHA256={peer['document_sha256']}
```

Czytaj REPO/AGENTS.md, START_HERE, STATE i AGENT_GIT_PROTOCOL.md wyłącznie dla
orientacji; potem własny TASK, kontrakt wejść i handoff autora. Wszystkie zapisy
tylko pod W; bez systemowego tmp/tmpfs. Jeden recenzent/jeden job naraz, bez
subagentów/relay/drugiej sesji. Bez Git push, publikacji, dudect i sieci.

## 2. Zewnętrzne piny przekazane przez właściciela

```text
{chr(10).join(pins)}
```

Piny pochodzą z handoffu autora. Zweryfikuj je niezależnie przed i po własnym
replayu; rozbieżność = raport, nie ciche dopasowanie.

## 3. Tezy do oceny

Zakres i wymagane eksporty definiuje {task_path.relative_to(REPO)} oraz
INPUT_CONTRACT. Na wejściu traktuj deklaracje autora wyłącznie jako deklaracje.
Oceń: kompletność eksportów kontraktu, poprawność dowodu w zadeklarowanym
zakresie (SageMath/Lean4/Mathlib, kernelowo, bez mixed-proof substytutu),
integralność OUTPUTS/INPUTS oraz świeży replay we własnym W.

## 4. Integralność i replay

Zweryfikuj pełny OUTPUTS autora (manifest + bajty), TASK, INPUTS i bootstrap;
brak traversal/symlinków/duplikatów/mismatchów. Wykonaj własny replay zgodnie
z REPLAY etapu i porównaj semantyczne pliki z zarchiwizowanym receiptem.
Wyniki nieudanych tras zachowuj — są częścią raportu.

## 5. Format odpowiedzi

- VERDICT: PASS_SCOPED_REVIEW / CHANGES_REQUIRED / INTEGRITY_FAIL /
  REPLAY_FAIL / EXECUTION_BLOCKED / BLOCKED (+ dokładny zakres)
- Binding: wszystkie piny i HEAD, które potwierdziłeś
- Replay: liczba plików semantic, exit code, czas
- Luki: numerowana lista z kontrprzykładami lub wskazaniem brakującego lematu

Oddaj REVIEW.md, REVIEW_RESULT.json, INPUTS.sha256 i REVIEW_OUTPUTS.sha256
z checkerami,receiptami i raw logs według REVIEW_TASK. Manifesty mają dokładne
ścieżki względne (bez `./`),bez samoodwołań. W REVIEW_RESULT.json obowiązkowo:

```json
{{
  "review_id": "{entry['task_id']}",
  "source_task": "{peer['task_id']}",
  "source_report_sha256": "{bound.get('final_report_sha256') or placeholder('REPORT SHA autora')}",
  "source_outputs_sha256": "{bound.get('final_outputs_sha256') or placeholder('OUTPUTS SHA autora')}",
  "verdict": "<rzeczywisty werdykt>",
  "verdict_scope": "<dokładny odebrany zakres i otwarte obowiązki>"
}}
```

Pozostałe dowody,eksporty i pola określa TASK. Recenzja powstaje w W;
po zaakceptowaniu zakresu prowadzący importuje parę do stages i commituje na main.
"""
    return text


def save_prompt(path, text):
    path = bindings.inside(B.parents[1] / 'work', path)
    archive.put_once(path, text.encode())


def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument('reviewer', nargs='?', type=str.upper)
    p.add_argument('--all', action='store_true')
    p.add_argument('--out', type=Path)
    p.add_argument('--outdir', type=Path)
    args = p.parse_args(argv)
    if args.all:
        archive.require(args.reviewer is None and args.out is None, '--all accepts only --outdir')
        outdir = args.outdir or B.parents[1] / 'work/B20_001/prompts'
        index = json.loads((B / 'INDEX.json').read_text())
        pending = []
        for entry in index['entries']:
            if entry['role'] != 'reviewer':
                continue
            _, entry, peer, bound = load_pair(entry['id'])
            target = outdir / f"{entry['id']}_PROMPT.md"
            text = render(index, entry, peer, bound)
            bindings.inside(B.parents[1] / 'work', target)
            archive.require(not target.exists() or archive.read(target) == text.encode(),
                            f'Existing prompt differs; choose a new version/path: {target}')
            pending.append((entry, peer, bound, target, text))
        written = []
        for entry, peer, bound, target, text in pending:
            save_prompt(target, text)
            written.append(dict(reviewer=entry['id'], paired=peer['id'],
                                author_bound=bool(bound.get('final_report_sha256')), file=str(target)))
        print(json.dumps(written, ensure_ascii=False, indent=2))
        return
    archive.require(args.reviewer is not None and args.outdir is None, 'Select Vxx or --all --outdir')
    vid = args.reviewer
    index, entry, peer, bound = load_pair(vid)
    text = render(index, entry, peer, bound)
    out = args.out
    if out is None:
        print(text, end='')
        return
    save_prompt(out, text)
    print(json.dumps({'written': str(out), 'reviewer': vid, 'paired': peer['id'],
                      'author_bound': bool(bound.get('final_report_sha256'))}, indent=2))


if __name__ == '__main__':
    try:
        main()
    except (archive.ArchiveError, OSError, ValueError, KeyError, TypeError) as error:
        raise SystemExit(f'b20_review_prompt: {error}')
