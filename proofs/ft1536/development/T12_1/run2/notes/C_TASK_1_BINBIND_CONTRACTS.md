# CONTRACTS.md — C_TASK_1_BINBIND (Warstwa 1: warstwa FFT/NTT)

Żywy kontrakt wyjścia dla `C_TASK_2_FPERROR` (okno analizy błędów FPEMU)
i `C_TASK_3_REFINE`. Aktualizowany po każdym etapie. Zapisy wyłącznie w tym
folderze + własny `build/`; repo i RUN_002/RUN_003 tylko-do-odczytu.

## KOREKTA ZAKRESU (2026-09-29, właściciel) — OBOWIĄZUJĄCA

Pierwotny zakres (InstrSemantics + binarium keygen/FPEMU na poziomie
instrukcji) został **pokryty równolegle przez wykonawcę RUN_003** (GPT-6 Sol:
Source3 StableBinary/LeafScan/stable_positive — nie odtwarzam, traktuję jako
gotowe). Nowy zakres tego okna: **source-bound semantyka warstwy FFT/NTT
(falcon-fft.c + falcon-enc.c; NTT = modp_* z falcon-keygen.c) stylem Source3
(pinned text → parser → typed execution), dla potrzeb analizy błędów FPEMU**.

Twarde anti-collision (dotrzymane):
- fpr_add/mul/div: wykonanie i kontrakt zaokrągleń = okno C_TASK_2_FPERROR —
  tutaj WYŁĄCZNIE sygnatury hooków (poniżej), bez implementacji;
- fpr_half/double: linkowane wykonanie `Source3.StableBinary` Sola —
  parser nie duplikowany;
- kompozycja KeyGen (ft_keygen_leaf_certificate, stable top/binary, reverse
  reciprocal, caller Frame/typed views): NIE RUSZANE — obowiązek Sola.

Zasada nadrzędna: modelem jest wykonanie przypiętego tekstu M0; **komentarze C
ani RN binary64 nie są założeniami** (warunek Astry/właściciela).

---

## STATUS MODUŁÓW (build czysty 0 err/0 warn; axioms ≤ {propext, Classical.choice, Quot.sound})

| moduł | zawartość | status |
|---|---|---|
| `formal/FftBind/FftPin.lean` | przypięty tekst M0 falcon-fft.c (1455 linii) + falcon-enc.c (700 linii) + stałe SHA256 + kotwice tekstowe | ✅ |
| `formal/FftBind/FftGeometry.lean` | makro MKN: parsowanie z pinu + wykonanie + dokładne rozmiary/rozpisy pętli | ✅ |
| `formal/FftBind/FftSemantics.lean` | hooki fpr, stan Run/Mem/Event, 6 makr FPC: parser + wykonanie + kolejności wywołań + ramka pamięci | ✅ |
| `formal/FftBind/NttSemantics.lean` | piny PRIMES2/PRIMES3 + fakt PRIMES3[0], inwentarz modp_*, NTT FPEMU-free | ✅ |

Dowody reprezentatywne i ich aksjomaty (surowe logi: `logs/FftBind_*.build.log`):
`mkn_source`, `mkn_exec`, `mkn_exec_profile_full` — [propext, Classical.choice, Quot.sound];
`add_parses`/`mul_parses`/`div_parses`, `mul_calls`/`div_calls`, `runMacro_frame` — [propext, Classical.choice, Quot.sound];
`primes3_first_pin`, `primes2_first_pin`, `modp_ntt3_macro` — [propext];
`primes3_first_ne_primes2_first` — **bez aksjomatów**; `mkn_profile_full` — [propext].

---

## 1. SEMANTYKA WYWOŁAŃ FFT/NTT Z PINEM HASHA ŹRÓDEŁ M0

### Piny źródeł M0 (snapshot `FT1536_M0_CONTRACT_RUN_001/source`, source17)

| plik | SHA256 | uwaga |
|---|---|---|
| falcon-fft.c | `06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063` | tekst w `FftPin.fftLines` |
| falcon-enc.c | `0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05` | tekst w `FftPin.encLines` |
| falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` | NTT = modp_*; tekst linkowany: `Source3.Pinned.keygenLines` |
| fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` | **M0 source17**; nowszy (P02/żywy Extra) jest INNY — nie utożsamiać! |

Wiązanie tekst↔hash maszynowo: `inputs/SHA256SUMS_M0`, `scripts/verify_inputs.py`
(VERIFY_OK m0=18 link=21). Kotwice kernelowe wybranych linii w `FftPin`
(`fft_line_*`, `enc_line_*`, `mkn_split`, `*_wrapper`, `*_sig`).

### Sygnatury wywołań fpr — KONTRAKT dla Warstwy 2 (C_TASK_2_FPERROR)

```
FT1536.FftBind.FftSem.FftCalls : Type
  add  : Word → Word → Option Word     -- fpr_add
  sub  : Word → Word → Option Word     -- fpr_sub
  mul  : Word → Word → Option Word     -- fpr_mul
  div  : Word → Word → Option Word     -- fpr_div
  sqr  : Word → Option Word            -- fpr_sqr
  neg  : Word → Option Word            -- fpr_neg
  inv  : Word → Option Word            -- fpr_inv
  ofInt : Word → Option Word           -- fpr_of
  inverseOf : Word → Option Word       -- fpr_inverse_of
  scaled : Word → Word → Option Word   -- fpr_scaled
```
`Word = BitVec 64`. Pola = HOOKI: wykonanie i kontrakt zaokrągleń
fpr_add/mul/div/sqrt są zadaniem okna C_TASK_2_FPERROR (anti-collision).
fpr_half/fpr_double = wykonanie LINKOWANE: `Source3.StableBinary.half/double`
(parsowane z nagłówka M0 przez Sola). Rozwinięcia inline (fpr_sub → add+neg
itd.) należą do warstwy fpr (okno MiMo) — tutaj nie są modelowane.

### Sygnatury wykonania (styl Source3)

```
FftSem.evalM (c : FftCalls) (env : Name → Option Word) :
    CLogic.Expr → Run → Option (Word × Run)
FftSem.runMacro (c : FftCalls) (m : Macro) (env : Name → Option Word)
    (dest : Name → Option Addr) (r : Run) : Option Run
FftSem.fpcAdd/fpcSub/fpcMul (c) (r : Run) (drea dima : Addr)
    (are aim bre bim : Word) : Option Run
FftSem.fpcSqr/fpcInv (c) (r) (drea dima : Addr) (are aim : Word) : Option Run
FftSem.fpcDiv (c) (r) (drea dima : Addr) (are aim bre bim : Word) : Option Run
```

### Makra FPC_* — sparsowane z pinu + kolejności wywołań (kontrakt dla analizy błędów)

Parsery odrzucają każdy nadmiarowy/zmieniony token (`add_parses`…`div_parses`).
Kolejność wywołań = kolejność ewaluacji C (najpierw argumenty):

| makro | pin linii | callee w kolejności | teza |
|---|---|---|---|
| FPC_ADD | 55–61 | fpr_add, fpr_add | `add_calls` |
| FPC_SUB | 66–72 | fpr_sub, fpr_sub | `sub_calls` |
| FPC_MUL | 77–93 | mul, mul, sub, mul, mul, add | `mul_calls` |
| FPC_SQR | 98–107 | sqr, sqr, sub, mul, double | `sqr_calls` |
| FPC_INV | 112–123 | sqr, sqr, add, div, neg, div | `inv_calls` |
| FPC_DIV | 128–148 | sqr, sqr, add, div, neg, div, mul, mul, sub, mul, mul, add | `div_calls` |

### NTT (modp_*, falcon-keygen.c 2477–3315) — sygnatury z pinów

`modp_ninv31(p)`, `modp_montymul(a,b,p,p0i)`, `modp_div(a,b,p,p0i,R)`,
`modp_mkgm2(gm,igm,logn,…)`, `modp_NTT2_ext(a,stride,gm,logn,…)`,
`modp_iNTT2_ext(a,stride,igm,logn,…)`, `modp_mkgm3(gm,igm,…)`,
`modp_NTT3_ext(a,stride,gm,logn,full,…)`, `modp_iNTT3_ext(a,stride,igm,logn,full,…)`,
`modp_poly_rec_res(f,logn,…)` — makra `modp_NTT2/iNTT2/NTT3/iNTT3` = warianty
`_ext` ze stride = 1 (`modp_ntt2_macro`, `modp_intt2_macro`, `modp_ntt3_macro`).

**NTT jest FPEMU-free** (`modp_chunks_fpr_free`, `ntt_is_fpr_free`): region
modp nie zawiera ani jednego `fpr_` — kernelowo 10 kawałków po 88 linii
z 4-liniowym nachodzeniem; globalnie (cały region 2472–3317, 24008 B)
maszynowo: `scripts/check_no_fpr.py` = CHECK_NO_FPR_OK. Skutek dla analizy
błędów: **warstwa NTT nie wnosi żadnego błędu zaokrąglenia FPEMU**
(arytmetyka uint32/Montgomery na Z/pZ).

---

## 2. LICZBY/ROZMIARY TRANSFORMACJI DOKŁADNE (z egzekucji, NIE z komentarzy C)

- Makro MKN (falcon-fft.c:755) sparsowane z pinu i wykonane:
  `mkn_source : mknParse = some mknExpr`, `mkn_exec` (wykonanie = forma
  zamknięta dla 0 < logn ≤ 10, full ≤ 1 — pełne wyliczenie przypadków).
- Forma zamknięta: **`mkn logn full = (1 + 2*full) * 2^(logn - full)`**
  (`mkn_zero`, `mkn_full_one`).
- Profil FT1536 (logn = 10): **`mkn 10 0 = 1024`, `mkn 10 1 = 1536`**;
  połówki (sloty real/imag): **`hn = 512` / `hn = 768`** (`mkn_profile_half`,
  `mkn_profile_full`, `hn_profile_half`, `hn_profile_full`;
  `mkn_exec_profile_half/full` = wykonanie parsera daje 1024#64/1536#64).
- Dokładne rozpisy iteracji transformacji (falcon-fft.c:758–965):
  - `fft3DoublingSteps hn tmin : List (m, t, hm, ht)` — kroki podwajające
    FFT3 (`t = hn/2^k`, warunek `t > tmin`, `tmin = 1 + 2*full`);
  - `fft3DoublingInner hn tmin : List (m, u1, v)` — iteracje wewnętrzne
    (v = u1*t + offset);
  - `fft3Tripling logn hn : List (v0, u)` — krok potrajający (`u += 3`,
    `v += 2`, iteracji **⌈hn/3⌉**);
  - `ifft3HalvingSteps t0 m0 n` / `ifft3HalvingInner` (t = t0*2^k < n) —
    kroki halwingowe iFFT3 (`t0 = 2 + 4*full`, `m0 = 2^(logn-1-full)`).
- NTT: `ntt2Size logn = 2^logn` (`ntt2_profile = 1024`),
  `ntt3Size logn full = mkn logn full` (`ntt3_size_eq_mkn`, rfl!).

---

## 3. MEMORY FRAME WYWOŁAŃ (argumenty, aliasing, wynik)

Model (styl `Source3.StableBinary`): `Mem := Addr → Option Word`
(obiekt fpr = 8 bajtów, `addr base i = base + 8*i`; `none` = brak/
niezainicjalizowany obiekt — odczyt = wykonanie niezdefiniowane);
`Run := { mem : Mem; events : List Event }`, `Event` = schemat Sola
(`load`/`store`/`fpr name args out`/`enter`/`leave`) — dziennik wywołań dla
analizy błędów; `Run.chronology` = kolejność źródłowa; `countFpr` = liczniki.

Tezy ramki (kernelowe):
- `load_reads_only` — odczyt nie zmienia pamięci;
- `store_writes_only` — zapis TYLKO pod wskazany adres (poza nim bez zmian);
- `evalM_mem` — ewaluacja wyrażeń (w tym wywołań fpr) nie zmienia pamięci;
- **`runMacro_frame`** — makra FPC zapisują wyłącznie w sloty docelowe
  `(d_re, d_im)`; pamięć poza dest jest niezmieniona (wszystkie przebiegi
  zdefiniowane). Aliasing argumentów dozwolony jak w źródle („All overlaps
  are allowed"): kolejność = ewaluacja wszystkich źródeł przed zapisami
  (argumenty ładuje wołający przez `load`, patrz `fpc*`).

Ramki funkcji FFT/NTT (argumenty/aliasing/wynik) z sygnatur źródeł:
- falcon_FFT3/iFFT3(a, logn, full): a = RW (obiekt MKN·8 B), tablice
  `fpr_gm3_square`/`fpr_gm3_cubic` = R (nigdy zapisywane); wynik in-place;
- poly_*_fft3(a, b, logn, full) z `restrict` na a i b: a = RW, b = R,
  **rozłączność a#b wymagana przez restrict** (jawny warunek ramek);
  `falcon_poly_invnorm2_fft3(d, a, b, …)` / `add_muladj_fft3(d, F, G, f, g, …)`:
  d = W, argumenty = R, wszystkie restrict;
- NTT modp: `a` (stride-elementy) = RW, `gm`/`igm` = R, `gm, igm` = W przy
  mkgm* (restrict), `f` = RW w poly_rec_res.

---

## FAKTY (trzymać dokładnie — decyzja właściciela 2026-09-29)

1. **PRIMES3[0] = (2147355649, 1907584673, 127999)** — `primes3_first_pin`
   (kernelowo, tekst M0 w tezie). **PRIMES3[0].p = 2147355649 ≠
   PRIMES2[0].p = 2147473409** — `primes3_first_ne_primes2_first`
   (BEZ aksjomatów; „nie mylić z PRIMES2" ma postać tezy).
   Tabele: `small_prime {p,g,s}` (typedef pin 833–837); PRIMES2 = wiersze
   840–1360 (521 wierszy) + terminator 1361; PRIMES3 = wiersze 1370–2469
   (1100 wierszy) + terminator 2470 (piny brzegów: `primes2_*`/`primes3_*`).
2. **Finalny leaf scan = 1536 słów (NIE 768)** — fakt Sola poza zakresem
   tego okna (Source3.LeafScan.source_scan_1536); tu odnotowany dla zgodności.
3. **Pin M0 source17**: fpr-emulated.h M0 = `242a7027…`; nowszy (P02/żywy
   Extra/c = `6b897d6c…`) jest INNY i nie jest utożsamiany z kontraktem M0.

---

## OTWARTE (jawne — nie zastąpione diagnostyką)

1. Runnery transformacji: złożenie `fft3DoublingInner`/`fft3Tripling`/
   `ifft3HalvingInner` z ciałami FPC w typed execution + liczniki wywołań
   całych falcon_FFT3/iFFT3 (rozpisy JUŻ są; brak runnera i count-theorems).
2. Runnery 17 funkcji `falcon_poly_*` (rodziny FFT3 i 2-punktowej) +
   per-op ramki/county.
3. Typed execution modp_* (NTT2/3/iNTT/mkgm/montymul) + dokładne liczniki
   iteracji motylkowych (rozmiary DZIEDZIN są — sekcja 2).
4. Pełne parsowanie tabel PRIMES2/PRIMES3 do `List (Nat × Nat × Nat)`
   (piny wierszy/brzegów/terminatorów są; trzeba parser + długości).
5. Semantyka falcon-enc.c (encode/decode 12289/18433, compress_none/static,
   hash_to_point, is_short) — tekst przypięty + kotwice (`enc_line_*`),
   wykonanie otwarte.
6. Ścieżka **C Sign (M7)** — nie rozpoczęta (kolejna po FFT wg właściciela).
7. Globalna teza kernelowa „cały region modp bez fpr_" — hybryda: kernel =
   10 kawałków (4-liniowe nachodzenie), globalność = `check_no_fpr.py`
   (CHECK_NO_FPR_OK). Rozprucie superliniowej redukcji kernelowej (pomiar:
   `logs/Probe.*`) zostawione otwarte.

---

## MATERIAŁ Z POPRZEDNIEGO ZAKRESU (zachowany, NIE rozwijany)

- Pin binarium (poprzedni Etap 1): `build/c/*.o` + `build/c/{test_falcon,falcon}`
  + `logs/BINARIES.sha256`, `logs/TOOLCHAIN_C.txt` (c99→gcc 14.2.0,
  flagi Makefile, 2026-09-29T15:24:43Z). **Ostrzeżenie uczciwości**: budowa
  poszła z ŻYWYCH Extra/c, czyli z NOWSZYM fpr-emulated.h (`6b897d6c…`,
  różnym od M0 `242a7027…`) — **to nie jest binarium kontraktu M0**;
  materiał wyłącznie do cross-checku, nie do twierdzeń.
- `build/disasm/*` (objdump -d/-r/-t): transkrypcja instrukcji nie jest już
  zakresem tego okna (pokryta inaczej przez RUN_003); materiał pomocniczy.

## KONFIGURACJA / REPRODUKCJA

- Kompilacja: `scripts/run_lean.sh <root> <src> <out> [timeout]` — guardy
  (0 sorry/admit/native_decide; czekanie ≤20 min na wolne okno Lean wg
  protokołu współdzielenia CPU; log 0 err/0 warn), LEAN_PATH z własnym
  `build/` NA PIERWSZYM miejscu + `run/check_lib` + upstream B20/Mathlib;
  HOME/TMPDIR pod W.
- Linkowane zależności: przypięte kopie `inputs/link/` (B20.C.{Syntax, Integer,
  Parser, ByteMemory, Scalar, ScalarParser}, B20.Word.LESpec,
  Run2.{KeygenLeafGate, StableLeafSchedule}, Source3.{KeygenSource, CLogic,
  CLogicParser, BitcastObjects, CRefWord, KeygenHelpers, LeafRange, LeafScan,
  StablePositive, StableBinaryPin, StableBinary}); weryfikacja pinów =
  `scripts/verify_inputs.py` (VERIFY_OK m0=18 link=21). `StableBinary.lean` =
  wersja ZAAKCEPTOWANEGO joba `stable_binary_020` (`6524207b…`), NIE późniejszy
  wariant live `stable_binary_relaxed_scratch_001`.
