# T12.1/source3 — żywy stan

Status: **ACTIVE / STABLE_TOP_001 / WORKING_NOT_REVIEWED**.
Wykonawca: GPT-6 Astra / openai/gpt-6-astra.
Sesja: `ses_f12636605ffeL1FZg4teLUwUf5` (bez nowej sesji/workera).

## Przejęcie2026-09-30

Zweryfikowano5/5 source/target hashes według
`HANDOFF_RECONCILIATION_20260930_001.json`, SHA256
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.
Rozliczenie: commit `c358871ab99f4aabfefc78d0b6be873852f2678e`, main=origin/main.
Pięć historycznych różnic `pending source3` jest rozliczonych, BASELINE
pozostaje niezmieniony. Stan run2/t5 nie jest przejmowany.
Zastana zmiana `docs/onboarding/STATE.md` należy do innej pracy.

Źródła: `proofs/ft1536/development/T12_1/source3/{formal,sage,tools}`.
Runtime: ten komponent `.build/{jobs,cache,preflight}`.
Stary RUN_003 W oraz `tools/original/` i wcześniejsze notatki są read-only
proweniencją. STABLE_BINARY_004: PROVED_KERNEL_SCOPED / NOT_REVIEWED,
REPORT `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`,
CLOSURE `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.

## Bieżąca kolejność

1. Rebinding runnera zakończony: `tools/job.py`,
   `.build/jobs/stable_top_bootstrap_001` accepted/clean,1.016s.
   Sprawdzono import pinowanych eksportów `_004`; nie odtwarzano ich dowodów.
2. Source fpr_of(3)→fpr_scaled(3,0), norm/FPR **PROVED_KERNEL_SCOPED**:
   `FprOfThree.source_exists` i `source_exact`, słowo `0x4008000000000000`.
   `FprScaledBinding` wiąże parser C/headera/makra; `FprScaledBridge`
   dowodzi obu kierunków zgodności reference i modelu.
3. Parser/reference całego top, pętla u=3*v i256 iteracji.
4. Legalność/inicjalizacja leaves/scratch, trzy binary256, pełna pamięć/trace.
5. Istnienie/reference→operational/source outcome, mutacje, fresh closure.

Małe commity i push własnych plików po logicznych krokach; okno Git
przekazane przez właściciela/koordynatora. Bez przyjmowania cudzych zmian,
bez amend/force, innych modeli, samodzielnego REVIEWED lub zmian C.

Uruchamianie z katalogu komponentu:
`python3 -B tools/job.py lean <jednorazowa_etykieta> Source3.Modul ...`
lub `python3 -B tools/job.py sage <jednorazowa_etykieta> nazwa.sage`.
Runner sprawdza source/product piny konsumowanych zależności, zapisuje
snapshot źródła, SOURCE_INPUTS i RECEIPTS, izoluje sieć i zapis do jobu,
utrzymuje -j1/-M6144, AS12GiB/RSS8GiB/wall1800s oraz warningAsError.

## Zapisane kroki

- `d3e50a19`: przejęcie+runner+bootstrap, wypchnięty na origin/main.
- fpr_of3: jobs `stable_top_scaled_binding_001`, `stable_top_scaled_bridge_001`,
  `stable_top_of_three_003`, `stable_top_of_three_audit_001` accepted/clean;
  raw failed `_001/_002` zachowane. Typy/termy/aksjomaty w audycie.
- `stable_top_inputs_sage_001`: `sage check_stable_top_inputs.sage`,
  ZZ/QQ exact fpr_scaled/FPR cross-check daje3; kontrola indeksów768 i
  dwóch mutantów harmonogramu. To diagnostyka, nie dowód całej pętli.

Następny otwarty krok: parser/reference całego top i pamięć pętli; końcowe
istnienie i outcome top jeszcze nie zostały wyeksportowane.
