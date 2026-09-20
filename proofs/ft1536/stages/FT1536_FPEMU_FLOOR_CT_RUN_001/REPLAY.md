# Odtworzenie FLOOR_CT

## Standard — odbudowa i zapisane raw, bez nowych pomiarów

W katalogu pakietu, z istniejącym `tmp/`, nowym ABSENT_DEST pod tym tmp
i **zewnętrznym** SHA-256 OUTPUTS otrzymanym w handoffie:

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/replay_001 EXPECTED_OUTPUTS_SHA256
```

Skrypt sprawdza zewnętrzny pin i każdy członek całego manifestu **przed
utworzeniem DEST**. Odrzuca istniejący DEST, symlinki/escapes i zmieniony
semantic scope. Kopiuje wyłącznie potrzebne publiczne źródła, piny i zapisane
dane pomiarowe; nie pobiera niczego ani nie używa oryginalnych Dokumenty,
innych W/historycznych stages, roboczych binariów lub olean.

W nowym cwd/ROOT:
1. TOOLCHAIN, exact source/PATCH/17-file binding i independent fixtures;
2.8 modułów Lean4.34/Std, czyste logs/axioms/types/terms i12 288 value checks;
3. baseline/candidate normal C i ASan/UBSan, smoke i meaningful mutations;
4. oryginalny Sign TU/wrapper, benchmark/harness i wszystkie5 ASM regions;
5.12 dostępnych historycznych raw trials oraz30 A/B trials, porównanie
   wszystkich102 per-batch states, percentiles i summaries;
6. ponowna kontrola pełnych lossless parts/stream hashes, source/binary/
   readiness pins i kolejności prób;235 path/SHA semantic matches;
7. powtórna weryfikacja oryginalnego manifestu; DEST/REPLAY_RESULT.json
   ma FRESH_REPLAY_PASS i pełne `matches`.

Pełne command receipts i stdout/stderr pozostają w nowym DEST, w tym
tmp/raw_replay/ każdej rekalkulacji. Nie wystarcza sam napis PASS: archiwizer
porównuje matches z artifacts/fresh_replay.json i rzeczywistymi bajtami.
Niestabilne elapsed/cwd/host snapshots nie należą do235 matches; pierwotne
warunki fizycznych pomiarów nadal są przypiętymi danymi wejściowymi.

Wymagane: Linux x86_64 LP64, GCC Debian14.2.0-19, binutils2.44, Python3.13.5,
bwrap, Lean4.34.0/Std pod ścieżką z TOOLCHAIN. Bez instalacji/sieci. Sage
nie jest potrzebny do tego replayu. Jobs są pojedyncze, bounded1–240 s,
normal8GiB, Lean-j1/-M2048; ASan osobno bez virtual-address-space cap.
Controller nie może dziedziczyć hard RLIMIT_AS8GiB, bo uniemożliwiłoby shadow
ASan. LSan pozostaje wyłączony. Lokalny rehearsal trwał210.484 s; prowadzący
może zastosować zewnętrzny watchdog600 s dla całego standardowego replayu.

Każdy child używa faktycznego W-only/network-off bwrap i osobnych RO bindów
inputs/baseline/candidate/vendor/harness; HOME/TMP/cache/olean/bin są w DEST.
Skrypt nie zapisuje do oryginalnego pakietu. `scripts/final_control.py replay
EXPECTED_OUTPUTS_SHA256` jest dodatkowym lokalnym checkiem: root pakietu RO,
writable tylko nowy tmp/final_replay_001; Dokumenty/H/stages ukryte, controller
limit240 s. Jego własne receipts nie zmieniają OUTPUTS.

## Rehearsal bez cyklu

Zarchiwizowany rehearsal użył osobnej kotwicy
artifacts/rehearsal_inputs.sha256, SHA
`c50a1738493314720588b0b94fbc47aedf5a5ffc59fd3d8bd8cc0c85cb1b2661`.
Tryb `--rehearsal` sprawdza tę kotwicę, nie finalny OUTPUTS. Nie jest
zastępstwem standardu po freeze. Wynik235/235 i242 pełne receipt/stream
copies są w artifacts/fresh_replay.json i artifacts/rehearsal/.

## Osobny jawny tryb nowych pomiarów

```sh
python3 -B scripts/replay.py /ABS/PACKAGE/tmp/new_timing_001 EXPECTED_OUTPUTS_SHA256 --physical-timing
```

Ten tryb nie jest uruchamiany automatycznie i nie był dodatkową kampanią
tego handoffu. W nowym DEST najpierw kończy builds/Lean/semantic/ASM/historical
replay, potem wybiera aktualny non-SMT CPU, zapisuje nowy plan i wykonuje
oddzielną bounded kampanię≤1800 s,≤60 s/trial, jeden worker. Progi/klasy/order
pozostają takie same. Zachowuje nowe raw/snapshots i przelicza je po końcu.
Nie oczekuje identycznych czasów/t-statistics, nie nadpisuje historycznego
wyniku i nie nadaje automatycznie statusu walidacji nowemu środowisku.
Nowy wynik może być INCONCLUSIVE/signal. Przy błędzie zachowuje partial
receipts/streams; nie robi retry. Potrzebuje większego zewnętrznego watchdog
niż standard, aby objąć osobny budżet kampanii i późniejszą rekalkulację.
