# REPLAY — standardowy protokół i receipty

Standard: `python3 -B scripts/replay.py ABSENT_DEST EXTERNAL_OUTPUTS_SHA`.
Skrypt jest samodzielny (nie czyta COMMANDS.log — działa po odtworzeniu archiwum
z pustym COMMANDS.log). Weryfikuje PEŁNY manifest OUTPUTS + zewnętrzny hash
PRZED utworzeniem DEST; DEST = nieistniejąca ścieżka pod W/tmp bez symlinków;
fresh project + fresh cache/build/Lean pod DEST (kopie inputs/source RO);
przelicza od zera wszystkie semantic files i porównuje hashe.

Plan semantic files ustalony przed rehearsal (SEMANTIC_FILES.json, 11 plików):
checks/{constants_extract,exact_ring_checks,skeleton_cancellation,z_map_full,
gap_composition}.json, logs/{06_lean_skeleton,07_lean_rintgap}.log,
checks/c_slice/{out_normal,out_asan,out_ubsan}.txt + oracle_result.json.
Każdy match jest rzeczywiście przeliczony (re-run skryptów/Lean/buildów C).

## Schemat kotwicy (bez cyklu hashy)

1. Manifest tymczasowy (bez receiptu) → **rehearsal-001** (DEST=W/tmp/…) z
   anchor = hash tamtego manifestu; receipt mrożony do artifacts/fresh_replay.json
   (+ child artifacts/REPLAY_RESULT.json).
2. Finalny OUTPUTS mroży WSZYSTKIE regularne artefakty łącznie z receiptem
   (jego bajty nie zależą od hashu finalnego manifestu — stąd brak cyklu).
3. Replay po freeze weryfikuje już finalny manifest (zewnętrzny SHA) i przelicza
   semantic files w nowym DEST; wynik i receipt raportowane prowadzącemu (TASK
   §11) i pozostają w tamtym DEST (po freeze zapis wyłącznie do nowego DEST).

## Receipty

| Przebieg | DEST | Anchor (external sha) | Wynik | Match |
|---|---|---|---|---|
| rehearsal (sealed) | W/tmp/rehearsal-001 | dadf2ab4478890b3… (tymczasowy) | FRESH_REPLAY_PASS | 11/11 |
| po freeze v2 (pośredni) | W/tmp/postfreeze-001 | f13fc179acab716ad… | FRESH_REPLAY_PASS | 11/11 |
| po freeze (finalny, v3 manifest) | W/tmp/postfreeze-002 | SHA-256 OUTPUTS v3 (podany w §11) | patrz §11 | 11/11 oczekiwane |

Uwaga proceduralna: log konsolowy pośredniego przebiegu v2 zapisano do
logs/09_postfreeze_replay.log (nowy plik, zamrożone bajty nietknięte); dla
ścisłości finalny przebieg v3 nie zapisuje niczego poza DEST. Manifest v3 obejmuje
ten log, REPLAY.md i finalny HANDOFF.md.

## Suplement Sage (2026-09-22) i freeze v4

Właściciel nakazał przeniesienie autorytatywnego rachunku do `.sage`
(`sage lemma.sage`, zasada FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md).
W miało już freeze v3 (sha daf45e8a…, receipt rehearsal-001 w artifacts/
fresh_replay.json — NIE nadpisany). Zgłoszone odstępstwa i rekord portu:
checks/sage/PORT_PY_TO_SAGE.md/.json. Replay po poprawie uruchamia
checks/sage/*.sage przez pinned launcher (receipt SAGE_RUNS.json w DEST) i
porównuje te same 11 semantic files. Nowy receipt suplementu:
artifacts/fresh_replay_sage.json + artifacts/REPLAY_RESULT_sage.json
(osobno od v3). Manifest v4 obejmuje oba receipty.

Sealed artifacts/fresh_replay.json: FRESH_REPLAY_PASS, matches[{path,sha256}]×11,
mismatches=[], explicit domain/scope w polu domain_scope. Child
artifacts/REPLAY_RESULT.json: matched/expected 11/11.
