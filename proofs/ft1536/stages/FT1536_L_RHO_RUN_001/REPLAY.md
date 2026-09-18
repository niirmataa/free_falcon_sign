# Replay L_RHO w świeżym katalogu

Wymagane są istniejące narzędzia: GCC 14.2.0, Python 3, bwrap, wrapper
`/home/footfalcon/.local/bin/sage` (Sage 10.9) i Lean 4.34.0/Std pod
`/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean`.
Nie instaluje się pakietów ani mathlib. Używany frontend Sage wykonuje `.py`
przez `sage plik.py ...`; `-python` okazało się tu nieobsługiwane.

Cwd:

```text
/home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001
```

Zewnętrzny oczekiwany digest OUTPUTS należy wziąć z przekazania wyniku,
a nie uwierzytelniać zmienionego pakietu jego własnym nowym hashem.
Po podstawieniu tego digestu:

```sh
python3 -B scripts/run.py 240 python3 -B scripts/replay.py /home/footfalcon/Dokumenty/FT1536_L_RHO_RUN_001/tmp/replay_002 EXPECTED_OUTPUTS_SHA256
```

Cel musi nie istnieć. W przeciwnym razie wybierz następny numer. Wszystkie
nowe pliki, kompilacje i cache powstają pod tym nowym katalogiem wewnątrz W.
Skrypt sprawdza manifest przed utworzeniem celu i odmawia nadpisania.

Replay kopiuje hash-sprawdzone publiczne wejścia oraz obie wersje źródeł.
Następnie `bind.py` od nowa sprawdza, że kandydat jest dokładnie dopuszczoną
zmianą referencji; odtwarza diff i manifest. Nie wywołuje `prepare.py`, nie
czyta sekretów i nie wykonuje nowego KeyGen lub runnerów R/D/H.

W świeżej kopii wykonuje kolejno:

1. `scripts/bind.py`;
2. Lean na `formal/Rho.lean`;
3. build rzeczywistego helpera i pełną enumerację normalną;
4. `scripts/scalar_suite.py`: ASan/UBSan, Sage, cztery mutacje i no-op;
5. `scripts/regression_suite.py`: dokładne fixtures i 56 wykonań Verify;
6. `scripts/audit.py`;
7. porównanie 64 plików znaczeniowych z zamrożonym runem.

Oczekiwany wynik: `tmp/replay_002/REPLAY_RESULT.json` z `FRESH_REPLAY_PASS`.
Nowe command receipts pozostają w kopii. Tablice skalarne poprawnego kandydata
(normalna oraz ASan/UBSan) mają
65 536 wierszy i hash
`7e1a00e898153e561ec8b0c4dcaa8ca19bc9343fe9f6c59cf99390632546217c`.
Nowy helper daje 16866 dla -20000; oryginalny świadek jest odrzucany przez
kandydata z normą 43058711057, a przyjmowany przez referencję z normą 400000000.

Nie uruchamiaj budowniczych lub suites ponownie bezpośrednio w ukończonym W:
pliki wynikowe celowo powstają w trybie exclusive. Obszary mutants/ i observed/
są pochodnymi testowymi, a nie produkcyjnym kandydatem.

Dokładna postać kandydata jest w `candidate.patch` i `CANDIDATE.sha256`
(baza drugiego manifestu: candidate/). Nie integruj jej automatycznie z S17.
Reprodukcja nie jest dowodem całego L_V ani formalizacją kompilatora.

Jeśli pod innym sandboxem wystąpi rozpoznany błąd LSan pod ptrace, suite
zachowuje nieudane wykonanie i może powtórzyć tylko z `detect_leaks=0`,
pozostawiając ASan/UBSan aktywne. Wynik trzeba opisać jako taki. W bieżącym
runie leak detection pozostało włączone i wszystkie wykonania przeszły.
