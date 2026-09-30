# C_TASK_1_BINBIND — Warstwa 1: wiązanie binarium keygena/FPEMU

Folder zadania w W `FT1536_MATH_EUFCMA_GAME_BINDING_RUN_001` (repo tylko-do-odczytu;
zapisy WYŁĄCZNIE w tym folderze + własny `build/`; inne foldery C_TASK_* piszą
równoległe sesje — NIE DOTYKAĆ; `run/check_lib` współdzielone tylko-do-odczytu).

## Cel

Powiązanie skompilowanego binarium `falcon_keygen_make` + FPEMU z modelem
formalnym — **na poziomie instrukcji, nie tekstu C** (komentarze C o RN
binary64 są zakazane jako źródło założeń! Decyzja/warunek Astry i właściciela).
Szablon: `KeygenLeafGate.lean` Astry (BitVec64/BitVec32, operacje słowne,
literalne stałe) — to jest WZÓR do naśladowania w skali całego FPEMU.

## Wejścia (przypiąć kopie lokalnie + SHA256SUMS, jak `CENTERING_CLOSURE/run2_src`)

- `RUN_002/run/formal/Run2/KeygenLeafGate.lean` (szablon BitVec — czytać, nie
  odtwarzać!), `StableLeafSchedule.lean` (kolejność liści — kontrakt wyjścia!).
- Binaria: ustalić z właścicielem pin skompilowanej biblioteki FPEMU/keygen
  (hash SHA256 + kompilator + flagi) — bez pinu binarium nie zaczynać!
- Disasembler do transkrypcji (objdump/ghidra-headless — bez sieci).

## Zakres

1. `InstrSemantics.lean` — semantyka używanych instrukcji na `BitVec 64/32`
   (add/sub/shift/cast/xor/and/or, load/store z modelem bajtowym, oraz
   operacje FP jako relacja `fpRound : ℝ → ℝ` z parametrami `u = 2⁻⁵³`:
   `|fpRound x − x| ≤ u*|x|` — ALE to jest KONTRAKT dla Warstwy 2, nie
   założenie o kodzie!).
2. `FPEMUTranscription.lean` — transkrypcja wywołań FPEMU z binarium:
   ścieżka instrukcja-po-instrukcji + tabela zgodności (adres, mnemonik,
   odpowiednik modelu) + kontrola pokrycia ścieżek z binarium (maszynowo).
3. `TraceModel.lean` — model wykonania: stan = rejestry + pamięć + flagi;
   twierdzenia o ścieżkach wyjątkowych/early-return jako JAWNE przypadki.

## Kontrakt wyjścia (dla C_TASK_2_FPERROR i C_TASK_3_REFINE)

- `step_sem : Instr → State → State` + `fpRound`-model z powyższymi własnościami;
- `fPEMU_trace : Input → Trace` z pinem hasha binarium w nazwie/tezie;
- `gate_trace_eq_keygenLeafGate : ...` — zgodność naszej transkrypcji pętli
  bramki z modelem Astry (cross-check z ich `KeygenLeafGate`)!

## Zasady (jak wszędzie: ZERO sorry/admit/native_decide; grep przed kompilacją;
logi 0 err/0 warn; kompilacja SERIALIZNIE z zapisem; `pgrep lean|sage` przed
kompilacją; python-patche z assert; bez Git; kontrakt wyjścia w pliku
`CONTRACTS.md` w folderze zadania po każdym etapie).

## Kryterium odbioru

`#print axioms` ≤ {propext, Classical.choice, Quot.sound}; tabela zgodności
pokrywa 100% ścieżek transkrybowanych funkcji; hash binarium w tezach.
