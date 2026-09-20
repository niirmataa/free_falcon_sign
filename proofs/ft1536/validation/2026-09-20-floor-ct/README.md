# Niezależny odbiór FLOOR_CT — 2026-09-20

**PASS: FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD**, z jawnym
model/source/compiler boundary i eksploracyjnym timing scope.

Baza odbioru: `039180b8eef542f093bba1f0e7515d748e284341`.
REPORT: `4002cff773e58828eee13232fbd3fe3acdbe8ac224572527cd69ace1e021f707`.
OUTPUTS: `1628510e0887ad291b7ead8d16f359141eeecbf8b1863a250b8678ccc18cf0c1`.
Pakiet:1528 członków OUTPUTS,386 publicznych INPUTS,1297634267bytes outputs.

## Źródła i zakres

Nowy17-file manifest:
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
Header:
`6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f`.
Patch:
`c95b22821dd54d86f32454ba04774f2c8bb9077fe344c91acc33c72a27b7c684`.

Przejrzano dokładny diff, FloorWord/FloorConsumers, SEMANTICS, EQUIVALENCE,
SOURCE_MODEL_BINDING, ASSEMBLY_REVIEW, IMPACT_MATRIX i checkery. Nowy model
rzeczywiście definiuje unsigned AND/OR; nie jest aliasem starego floorC.
Cases mask0/all-ones, reprezentacje, count0..63 i negative cc są rozliczone
dla wszystkich Word64. Zachowano +0→0 i−0→−1 oraz NumericCenter consumers.
Definedness jest range proof z jawnym GCC/C99/LP64 bindingiem; nie jest
formalnym dowodem front-endu/optimizera GCC.

Zmiana obejmuje tylko ciało floor w headerze, pozostałe16 źródeł i flags
są identyczne. Kandydat jest dostępny w zamrożonym stage/candidate/source.
`production_source_changed=false`, `new_source_patch_integrated=false`,
`owner_accepted=false`. Aktywny Extra/c ma baseline pin2553358f…; odbiór
kandydata nie jest sam w sobie jego integracją do domyślnego builda.

## Niezależny replay

Wykorzystano byte-identical kopię repozytoryjnego archive.py na dysku
systemowym, aby nie umieszczać dużego replayu w RAM-backed /tmp.
[REVIEW_SETUP.json](REVIEW_SETUP.json) wiąże ścieżki i tool SHA:
`cf1f79f94c6779f0ec69f059ef1e45a963c858d8db30dd49d77b72c7e40eb536`.
Kanoniczny import Git wykonano tym samym narzędziem i tymi samymi pinami.

Odpowiadające polecenie w zwykłym checkout:

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_FPEMU_FLOOR_CT_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Fresh seed/DEST, bez dawnych olean/bin, sieć wyłączona, Dokumenty/H ukryte,
zapis wyłącznie do kopii. **235/235 semantic matches, exit0,362.035s**.
Wszystkie15 bounded drivers zakończyły się poprawnie.

- Lean:8 modułów,41 twierdzeń,15 nowych; trzy odziedziczone moduły identyczne
  z ZERO, przebudowane; czyste logs/types/terms/axioms.
- C normal i ASan/UBSan:1065562 przypadki, identyczne outputs;12288 Lean
  value controls; po12 smoke checks dla obu wariantów i trybów.
- Pięć machine regions: wrapper, official timing target oraz oryginalne
  BerExp/sampler/sampler_large. Sprawdzono ledger wszystkich instrukcji,
  code binding i obiekty; candidate bez operand-dependent transfers/memory
  w tych regionach. Caller branches i hardware latency mają osobny zakres.
- Zrekalkulowano42 raw trials:12 historycznych z dostarczonej projekcji
  oraz wszystkie30 A/B. Dla A/B **9771 partii, wszystkie102 stany zgodne**.
- Pełne hash/size/order:90 strumieni,105 części,948531594bytes. Zmierzone
  binary hashes są identyczne ze świeżym rebuildem.

## Wynik A/B i jego interpretacja

Baseline floor9/9 wykryć; candidate9/9 bez sygnału; controls dodatnie6/6
i ujemne6/6 poprawne. Minimum candidate31946427 próbek na klasę.
Końcowe max|t| candidate≤3.9058111; największe max|t| dowolnej partii
candidate floor≈4.0554694. Próg przypiętego silnika10.

Trzy public orders i kolejność A/B są przypięte sprzed pierwszego pomiaru.
30s engine budget spełnia task≤60s/trial; całość454.495s<1800s. Normalized
semantic replay nie jest nową fizyczną kampanią. Shared host/frequency
pozostają ograniczeniami; brak sygnału nie jest hardware/backend/Sign CT proof.

Pure replacement zachowuje wartości i następne source states/coins na
defined executions. Nie dowodzi Reach ani identycznego runtime/resource t.
Known fpr_lt(-0,+0)=1 pozostaje osobnym ustaleniem. Pełna source-security
redukcja i dalsze loader/normalization/targets/law obligations pozostają open.

## Trwałe dowody odbioru

[execution.json](execution.json), [review_checks.json](review_checks.json),
[REPLAY_RESULT.json](REPLAY_RESULT.json), pełne referenced receipts/streams,
w tym42 świeże raw recalculations, są zachowane i hash-zweryfikowane.
[VALIDATION.sha256](VALIDATION.sha256):454 pliki,162633740bytes, SHA:
`55955135c2afba5f387d662bcc6d33297afeff2a31b1a2bf9c0502acd7784137`.
README i sam manifest są poza tym wykazem. Historyczne logi/źródła są
zachowane bajtowo; nową dokumentację sprawdzono osobno.
