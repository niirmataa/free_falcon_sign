# S01 — przygotowanie niezależnego odbioru CORRECTIONS_RUN_003

2026-09-22. Autor projektu Niirmata. Właściciel przekazał handoff MiMo ze
statusem **FT_FAMILY_CORRECTIONS_COMPLETE_FOR_REVIEW**. S01 ma
**FROZEN_AWAITING_REVIEW**; publikacja czeka na pozytywny niezależny odbiór.

REVIEW_ID=FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001.
W=proofs/ft1536/work/FT_FAMILY_CORRECTIONS_INDEPENDENT_REVIEW_001.
Właściciel wybiera i uruchamia recenzenta. Prowadzący przygotował piny,
read-only kopie i zlecenie,bez obliczeń matematycznych lub nowego replayu.

Zewnętrzne piny autora:
- REPORT `7d2f17cc51126b6dbb03279d7c876c460aa9f48bb581f63b9f512f87adee485d`.
- OUTPUTS `9e093536dfd684f83ca9bc361049e00064f3d60848f8ecc999aa5481398c397e`.

W/inputs zawiera subject (100 outputs + manifest + bootstrap197 i manifest),
source17,kontekst TASK/POLICY oraz pięć zapisanych receiptów autora z rehearsal
i postfreeze. `BUNDLE.sha256` jest identyczny z W/inputs/MANIFEST.sha256;
`ORIGINS.json` wiąże każdy bajt z jego źródłem. `PREPARATION.json` opisuje
wyłącznie kontrolę integralności i zapisanych receiptów. Tutejszy MANIFEST
przypina cztery pliki metadanych; liczby i dokładne hashes podaje PREPARATION.

## Szczególne punkty odbioru

- Sealed INPUTS zawiera29 rekordów i3 komentarze. Zachowano oryginał;
  parser kontrolny pomija jawnie komentarze. Istnieją absolute source/task
  paths i historyczny układ katalogów runnera; wymagają jawnego transportu.
- Port/COMMANDS wskazuje dla lemma_controls.sage hash `be762252…`,a finalny
  OUTPUTS i postfreeze mirror mają `5a3466b9…`. Postfreeze wiąże finalny
  manifest i jego18 wyników; stary zapis portu wymaga osobnego wyjaśnienia.
- OUTPUTS obejmuje `scripts/__pycache__/chi_tail_rigorous.cpython-313.pyc`.
  To zachowany członek frozen pakietu jako dane,nie pozwolenie na wykorzystanie
  starego bytecode jako cache nowego obliczenia. Nie usuwaj go z manifestu autora.
- Guard runnera usuwa byte_deterministic targets; semantic-only/PDF oraz
  ciężkie kroki mają osobną ocenę. Sam napis FRESH_REPLAY_PASS nie rozstrzyga
  wszystkich reklamowanych wyników. Zachowano receipty wcześniejszych prób.
- R1–R7,wycofanie R4,ujemny wynik R5,proposed R6 i tekst/PDF wymagają własnej
  oceny recenzenta. Rachunek nowych checkerów: sage lemma.sage,rzeczywisty
  preparser,exact/rigorous domains oraz pełny source→execution→output binding.

Aktualne zadanie: proofs/ft1536/CURRENT_FAMILY_REVIEW_TASK.md.
