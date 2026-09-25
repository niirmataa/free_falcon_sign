# CENTERING_CLOSURE — kernelowe domknięcie boundu delta dla wszystkich dopuszczonych kluczy

Cel (zlecenie właściciela 2026-09-24): policzyć u siebie domknięcie dowodu dla
obliczonego przedziału `delta(h) ~ 1.27e-24` i wszystkich dopuszczonych kluczy
(sprawa `complete_new_kernel_source_binding=false` z RUN_002).

## Wynik

`formal/CenteringClosure.lean` — **kompilacja czysta** (0 błędów, 0 ostrzeżeń),
kernel sprawdza arytmetyczne domknięcie i szablon twierdzenia dla wszystkich
kluczy:

1. `honest_in_bracket`, `honest_upper_lt_claim` — dokładne końce przedziału
   (`honest_lower/upper_rational` z przypiętego rekordu RUN_002) leżą w
   otwartym przedziale 3 cyfr znaczących, a `honestHi < 127/10^26`
   (roszczenie 1.27e-24 ma zapas);
2. `t5_g00_bound` (g00 < 1/64), `machine_decode` + `machine_eq`
   (słowo 0x4090000053700377), `t5_leaf_floor_gt` (floor > 991) —
   konserwatywna marża T5 liczona wcześniej wyłącznie w Sage
   (`t5_conservative_margin.sage`) — teraz kernelowa;
3. `pow_succ_le` + `tau_budget` — tau = (1+a)^1536-1 < 2^-40 (dokładne ℚ);
4. `bridge_lb_rawLo`, `bridge_ub_rawHi` — prefaktory mostka rawBad→delta
   (budżety tauB=2^-40, rejB=2^-24, boxB=10^-1000 spinają przedział);
5. **`all_keys_bridge_closure` + `all_keys_headline`** — dla KAŻDEGO klucza
   dopuszczonego przez KeyGen: `1265/10^27 < delta(h) < 127/10^26`, z dokładnie
   dwiema mianowanymi przesłankami (honest boundary, patrz niżej).

## Uczciwa granica (dwie przesłanki, nazwane wprost)

- `hraw` : liczbowe spięcie `rawLo <= rawBad <= rawHi` (produkt radialny
  RUN_002 + poprawki; kernelowe wiązanie produktów/ogonów to ich otwarty
  punkt M6);
- `hbridge` : analityczny transport mostka dla każdego dopuszczonego klucza
  (T5 dual theta + porównanie mas cosetów Poissona dostarczające `FiniteFlat`
  + transport MGF normy/współrzędnych + cap16 po Emit);
- `Adm` : abstrakcyjny predykat „klucz z powodzeniem emitowany przez
  istniejący KeyGen" (wiązanie do realnego C-KeyGen poza zakresem).

## Niezależna reprodukcja liczby (sage, 2^25)

`sage arb_radial.sage full 25 16` (kopia ich skryptu, sha256 1b3f5975…;
uruchomiona u mnie w `repro/`): COUNTS_DONE 75497472, DFT/POWER/INVERSE OK,
`single_change_modular = [1.26606846923775048079607e-24 ± 3.5e-48,
1.26782517099974631855363e-24 ± 4.1e-48]`. Różnice wobec ich `raw_lower/upper`
to **dokładnie** ich poprawki z tabeli: `aliases = 9.9099791888…e-34`
(dolny koniec) i `input_tail = 2.1559222811…e-38` (górny) — zgodność co do cyfr.
Produkty liczbowe RUN_002 są **odtwarzalne**.

## Kontrola arytmetyki (Sage)

`sage sage/check_closure.sage` (z katalogu CENTERING_CLOSURE) →
`CLOSURE_ARITHMETIC_PASS` + `closure_numbers.json`. Lustrzane kontrole
RealBallField512 (kappa*991 > 65*ln2, reject < 2^-24, box_tail < 10^-1000)
są po stronie Sage; w Lean dokładnie ℚ — rozdział udokumentowany.

## Piny i provenencja

- przypięty rekord: `centering_interval_closure.PINNED.json`
  (sha256 5ac5c576ab08f7b0c9eebf85ce25139f5766d178c49aa60529746548c73f4e58);
- skrypty RUN_002 skopiowane do `sage/` (arb_radial 1b3f5975…,
  legal_key_bridge_numbers 347e752e…, t5_conservative_margin 19041d9a…,
  close_radial_interval 6e495ab9…) — wyłącznie jako źródło liczb;
- kompilacja: toolchain Lean 4.34.0 (pin TOOLCHAIN.json) + upstream
  `LIBRARY_CLOSURE.json` (B20_001/P01); build check: `run/check_all_lean.sh`.

## RejectionBound.lean — norm-reject (kolejny filar boundu, 2026-09-24)

Kompilacja czysta (0/0). Kernel daje:

- `trial_none_mass` — dokładna tożsamość: `Rejection A c` (norm-reject
  `Q (decode z) ≥ B` + abort pustego fibera) = `fiberTailMass/fiberMass`
  (albo 1 dla pustego fibera);
- `fiberTailMass_le_exp` — krok Markowa-Chernoffa: ogon normy przez MGF
  przy dowolnym `λ ≥ 0`;
- `rejection_le_one`, `trial_of_pos`, `trial_of_empty`.

Zostają trzy mianowane przesłanki analityczne (jedyne otwarte punkty boundu
`Rejection ≤ 2^-24`, opisy w docstringu modułu): `mgf_product` (rozkład MGF
na 1536 bloków A2), `block_theta_bound` (suma Gaussa A2 vs całka, ~1.5e-4
na blok — Euler-Maclaurin 2. stopnia) i `fiber_transport` (kosetowy transport
fiber↔full = odpowiednik ich „Poisson all-center coset comparison").

## MgfProduct.lean — lemat 1: rozkład MGF (2026-09-24, build czysty 0/0)

Kernel domyka pełny rozkład MGF na 1536 bloków A2:

- `sum_prod_fn` — Fubini dla iloczynów po typach funkcyjnych
  (`∑ v : Fin n → D, ∏ i, φ (v i) = (∑ d, φ d)^n`; indukcja z
  `Finset.sum_bij` po `Fin.cons`/`Fin.tail`);
- `pair_sum_factor` — generyczny rozkład sumy po parach na iloczyn potęg;
- `exp_Q_prod` — `exp(-s·Q(decode z)) = ∏ sloty` (iloczynowość wagi);
- **`mgf_product`**: `∑ z, exp(-s·Q(decode z)) = blockSum s^1536`;
- **`mgf_weighted`**: `∑ z, gaussianWeight z·exp(λ·Q) =
  blockSum(1/(2·768²)−λ)^1536` — dokładna forma spodziewana przez krok
  Chernoffa z `RejectionBound.fiberTailMass_le_exp`.

Znalezisko inżynierskie (istotne też dla RUN_002): instancje
`boxVecFintype`/`boxPairFintype` są choice'owe (`Fintype.ofFinite`), a sumy po
`Fin 768 → …` budują strukturalne `piFinset` — DEFEQ między nimi eksploduje
wykładniczo przy każdej aplikacji generycznych lematów i przy `rw` z otwartymi
metazmiennymi. Lekarstwo (jak przy `SigmaMath.nonceFintype` w pakiecie):
lokalne `attribute [-instance]` w module + aplikacje w pozycjach ascezji.
Pozostałe przesłanki boundu `Rejection ≤ 2^-24`:
(2) `block_theta_bound` — suma Gaussa A2 vs całka (~1.5e-4/blok,
Euler-Maclaurin 2. st.); (3) `fiber_transport` — kosetowy transport
fiber↔full (sumy Gaussa po skończonych grupach, odpowiednik T5-dual-theta).

## BlockTheta.lean — lemat 2, postać schodkowa (2026-09-24, w toku)

Struktura (każdy stopień osobnym twierdzeniem, sorry-free):
- `bridge_on_off` (+`fiberMass_off`/`fiberTailMass_off`/`mgf_on_off`/`mass_off`)
  — mostki instancji ON→OFF przez `Finset.ext`+`sum_congr`; bisekcja: czysto.
- `fiberMass_pos`, `rejection_split` — rozgałęzienie Rejection na niepustym
  fiberze.
- `corrections_le` — korekty potęgowe luzu eps elementarnie (Bernoulli).
- `rejection_ratio_bound` — krok B: ogon/masa ≤ exp(−λB)·(R·(1+eps)/(1−eps))^1536
  (Marków + lemat 1 + premisa theta, bez certyfikatu numerycznego).
- `full_rejection_bound` — złożenie z `hnum` (certyfikat Sage/Arb) → 2^-24.

Protokół procesowy: `run_lean_guarded.sh` (kontrola obcych workerów
lean/sage/lake przed każdym kompilatem, twarde timeouty). Wykryci
równolegli executorzy: B20_001/P02 (fpr_spec_*), Astra RUN_002
(packed_convolution_*) — moje kompilaty tylko w wolnych oknach.

## BlockTheta.lean — lemat 2: ZAMKNIĘTY (2026-09-24 14:14, build czysty v14)

Po pełnej bisekcji (c1→c9), naprawie trzech rodajów przeszkód i finale —
**`BlockTheta.olean` powstaje w ~110 s, log czysty (0 error / 0 warning),
0 sorry/admit/native_decide**.

Co siedzi w kernelu (29 twierdzeń + struktura):

- **Premisa analityczna** (`ThetaBounds`): `blockSum sStar ≤ 2π/(sStar·√3)·(1+eps)`,
  `2π/(c0·√3)·(1-eps) ≤ blockSum c0` — luz eps = 2^-20 (realna korekta s/12 ≈ 6e-8 ≪ eps).
- **Mostki instancji ON↔OFF**: `bridge_on_off` (przez `Finset.ext`+`sum_congr`,
  wolny od DEFEQ-instancji), `fiberMass_off`, `fiberTailMass_off`, `mgf_on_off`, `mass_off`.
- **Bernoulli elementarne**: `pow_mono_nonneg`, `one_add_pow_le`, `one_sub_pow_ge`
  (czysta indukcja, bez lematów analitycznych).
- **Addatniość**: `blockSum_pos` (tania domena Fin 131071 × Fin 131071),
  `fiberMass_pos` (przez fiberMass_off → mass_off → blockSum — omija ∑ po BoxPair).
- **Rozgałęzienie**: `rejection_split` (Rejection = ogon/masa na niepustym fiberze).
- **Korekty potęgowe**: `corrections_le` (((1+eps)/(1-eps))^1536 ≤ 10/9, elementarnie).
- **Algebra theta**: `theta_ratio` (stosunek blockSum przez premisę: czysta algebra
  div-pow + `div_le_div_of_nonneg_{left,right}` z poprawnymi sygnaturami).
- **Krok B**: `hmk_form` (Marków → blockSum), `rejection_ratio_bound`
  (B1 + theta_ratio: ogon/masa ≤ exp(−λB)·(R·(1+eps)/(1−eps))^1536).
- **Kompozycja**: `full_rejection_bound` — z premisy + `hnum` (certyfikat
  Sage/Arb: exp(−λB)·R^1536 = e^{-16.8709…} ≤ 2^-24·0.9) wynika kernelowo
  **`Rejection (fun _ => ()) () ≤ 2^-24`** — norm-reject pełnej wagi.

### Trzy przyczyny zawieszek (wykryte bisekcją, dla przyszłych modułów):

1. **Eager-synthesis instancji** przy `Finset.mem_univ`-TERMinie vs utrwalone
   ∑-termy z oleanów — unifikacja DEFEQ wybucha wykładniczo na 768-poziomowych
   typach. Lekarstwo: członkostwa przez `by simp [Finset.mem_univ]` (dopasowanie
   wzorca zamiast syntezy) + **def-aplikacje zamiast ∑-notacji** w twierdzeniach
   (reguła architektoniczna: ∑-notacja wyłącznie w mostkach).
2. **Zapis exp**: RejectionBound używa `exp((-lam) * B)`, nie `exp(-(lam * B))`
   — równoważne ringowo, ale nie definicjonalnie; `exact` na tej różnicy
   spalał ~270 s na DEFEQ zanim padł.
3. **`ring` rozwijał `Rrat^1536` numerycznie** (ułamek 10-cyfrowy do potęgi
   1536 → liczby astronomiczne w evaluatorze ringa, przekracza heartbeat-cap).
   Lekarstwo: czysta asocjatywność przez `rw [mul_pow, mul_assoc]` zamiast `ring`.

### Co pozostaje otwarte (już nie dla boundu, lemat 2 jest kompletny):

- `ThetaBounds` (premisa analityczna) — do udowodnienia przez Euler-Maclaurin
  2. stopnia (celowe porównanie cosch-symetryczne; realna korekta s/12).
- `hnum` (certyfikat numeryczny) — do zastąpienia pełnym dowodem przez
  mercator/exp-partial-rational-bounds.
Oba są mianowanymi przesłankami `full_rejection_bound` i są dokładnie
udokumentowane w docstringu modułu.

### Protokół procesowy (z_decyzji właściciela):

- Strażnik `run_lean_guarded.sh` sprawdza obcych workerów przed każdym kompilatem.
- Odłączony runner `run_compile_v8.sh` (setsid) przeżywa restarty serwera.
- Wykryci równolegli executorzy: B20_001/P02 (fpr_spec_*), Astra RUN_002
  (packed_convolution_*) — kompilaty tylko w wolnych oknach.

## Fazy A–D zamknięte: lemat 2 BEZ PREMISES (2026-09-25, tf21 + ta1)

Powyższa sekcja „Co pozostaje otwarte" została zdezaktualizowana przez
kolejne etapy (Fazy A–D) — obie przesłanki są teraz UDOWODNIONE kernelowo:

- `ThetaPoisson.lean` (A) → `Theta2Split.lean` (B) → `ThetaBox.lean` (C) →
  `ThetaFinal.lean` (D): kanapka Θ₂ (`theta2_lower`, `theta2_upper`),
  `blockSum_eq_boxSum`, `boxSum_le_theta2`, `tail_le_pow300 ≤ 2⁻³⁰⁰`.
- `ThetaAssembly.lean` (nowy): **`thetaBounds : ThetaBounds`** +
  **`hnum_cert`** (certyfikat wymiarowy: `Real.exp_one_gt_d9` +
  `Real.add_one_lt_exp` + `norm_num` na Rrat^1536) →
  **`full_rejection_bound_no_premises : Rejection (fun _ => ()) () ≤ 1/2^24`**.
- Audyt `#print axioms`: [propext, Classical.choice, Quot.sound] (ta1_audit).
- Buildy czyste 0/0, zero luk; szczegóły i pułapki forka w WORK_STATE.md.
