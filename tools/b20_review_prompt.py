#!/usr/bin/env python3
"""Generate a paired-review prompt skeleton for one B20_001 reviewer (Vxx).

Reads INDEX.json for the Vxx entry and STATUS.json for already-bound author
pins. Before the author handoff exists, the prompt ships with explicit
placeholders; never invent pins. The skeleton follows the established review
prompt structure (roles, identification, pins, claims, integrity, replay).

Usage: python3 -B tools/b20_review_prompt.py V01 [--out PATH]
"""
import json
import sys
from pathlib import Path

B = Path(__file__).resolve().parents[1] / 'proofs/ft1536/batches/B20_001'
REPO = B.parents[2]


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
    bound = status['tasks'].get(pid, {})
    return index, entry, peer, bound


def render(index, entry, peer, bound):
    vid, pid = entry['id'], peer['id']
    task_path = B / entry['document']
    peer_task = B / peer['document']
    pins = []
    if bound.get('final_report_sha256'):
        pins.append(f"{pid} REPORT_SHA256: {bound['final_report_sha256']}")
        pins.append(f"{pid} OUTPUTS_SHA256: {bound['final_outputs_sha256']}")
        pins.append(f"{pid} HEAD: {bound.get('head') or placeholder('source HEAD z HANDOFF autora')}")
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
TASK_SHA256={placeholder('sha256 z INDEX/PACKAGE po sprawdzeniu bajtów')}
PEER_TASK={peer_task}
PEER_TASK_SHA256={placeholder('sha256 zadania autora po sprawdzeniu bajtów')}
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

- VERDICT: PASS_SCOPED_REVIEW / CHANGES_REQUIRED / BLOCKED (+ dokładny zakres)
- Binding: wszystkie piny i HEAD, które potwierdziłeś
- Replay: liczba plików semantic, exit code, czas
- Luki: numerowana lista z kontrprzykładami lub wskazaniem brakującego lematu
"""
    return text


def main():
    if len(sys.argv) < 2 or sys.argv[1].startswith('-h'):
        raise SystemExit(__doc__)
    if sys.argv[1] == '--all':
        outdir = Path(sys.argv[sys.argv.index('--outdir') + 1]) if '--outdir' in sys.argv \
            else B.parents[1] / 'work/B20_001/prompts'
        outdir.mkdir(parents=True, exist_ok=True)
        index = json.loads((B / 'INDEX.json').read_text())
        written = []
        for entry in index['entries']:
            if entry['role'] != 'reviewer':
                continue
            _, entry, peer, bound = load_pair(entry['id'])
            target = outdir / f"{entry['id']}_PROMPT.md"
            target.write_text(render(index, entry, peer, bound))
            written.append(dict(reviewer=entry['id'], paired=peer['id'],
                                author_bound=bool(bound.get('final_report_sha256')),
                                file=str(target)))
        print(json.dumps(written, ensure_ascii=False, indent=2))
        return
    vid = sys.argv[1].upper()
    index, entry, peer, bound = load_pair(vid)
    text = render(index, entry, peer, bound)
    out = next((Path(a) for a in sys.argv[2:] if a != '--out'), None)
    if '--out' in sys.argv:
        out = Path(sys.argv[sys.argv.index('--out') + 1])
    if out is None:
        print(text, end='')
        return
    out.write_text(text)
    print(json.dumps({'written': str(out), 'reviewer': vid, 'paired': peer['id'],
                      'author_bound': bool(bound.get('final_report_sha256'))}, indent=2))


if __name__ == '__main__':
    main()
