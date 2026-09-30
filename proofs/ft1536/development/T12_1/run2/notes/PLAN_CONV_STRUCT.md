# PLAN — okno (b): splot strukturalny kernel-side → certLo/certHi

Decyzja właściciela 2026-09-29: **droga (b)** — dowód strukturalny splotu
po stronie kernela (szeregi generujące), `PackedConvolution.certificate_sound`
zbędny. Cel: `certLo`/`certHi` (typ z `ConvolutionCert`, W2) dowodzone
kernelowo → `all_keys_delta_of_conv_cert` bez przesłanek liczbowych.

## 0. Rozbiór matematyczny (z definicji przypiętych — nie z pamięci)

Obiekty (piny: `run2_src/Run2/*`, `formal/ConvolutionCert.lean`):

- `Block` = punkt kraty; `blockEnergy b = Geometry.block x y = x²+xy+y²`;
  `blockWeight b = exp(−E/1179648)` (D = 1179648 = 1/c0).
- `before z` = energia sumy 1536 bloków BoxPair; `restEnergy z 0 =
  before z − blockEnergy (z.1 0)` = suma **1535 niezależnych** energii.
- `windowMassWin 0 b W` = P(restEnergy ∈ W | z.1 0 = b) — przez RawProductLaw
  (rozkład iloczynowy bloków!) = masa okna rozkładu **1535-krotnej splotu**
  szeregu jednoblokowego.
- `engineGapLo b` = CDF(loT2) − CDF(loT1) (W1 z ConvolutionCert — zamknięte);
  `engineTriangleLo = ∑ b, blockLaw.mass b · 1[region1 b] · engineGapLo b`.
- `certLo : engineLo − aliasCap ≤ 4·768·engineTriangleLo`; `engineLo`,
  `aliasCap` = literały ℚ (arb) — margines `aliasCap/engineLo ≈ 0,08%`.

Cel liczbowy: **dolne** oszacowanie `engineTriangleLo` z precyzją ≈ 0,1%
(certHi symetrycznie: górne). To jest CAŁE wymaganie — nie dokładna wartość.

## 1. Kluczowe spostrzeżenia (skracają drogę o rząd wielkości)

1. **Box jest zbędny analitycznie**: obcięcie `|x|,|y| ≤ 65535` gaussa
   o skali √D ≈ 768 to ~85σ — masa poza boxem ≤ e^{−3639} ≈ 10⁻¹⁵⁸⁰
   (na wzór `Tg_le`/„Gauss na pół" z ThetaBox). Suma jednoblokowa na boxie
   = Θ₂-typowa na CAŁEJ kratce z błędem < 10⁻¹⁵⁰⁰ — margines astronomiczny.
2. **Szereg jednoblokowy = nasza theta**: `∑_{ℤ²} exp(−block(u,v)/D)` to
   dokładnie `Theta2Split.Theta2` (`block = i²+ij+j² z Geometry`) — mamy
   `theta2_split`, `S0_bounds`, `s1_upper/lower`, `tail_le_pow300`.
   Suma NIEokrojona 1535-splotu = **potęga zamknięta**: Θ₂(s)^1535.
3. **Sigma-algebra splotu = strukturalnie**: N_E = [x^E] S(x)^1535 dla
   S = szereg jednoblokowy (wielomian/„theta-q"); własność definiująca
   splotu idzie przez `Polynomial`/`PowerSeries` + `Finset` (wzorce
   `PackedConvolution.split_polynomial`, `eval_injective` — REUSE).
   Wartości N_E nie muszą być liczone — potrzebne są OSZACOWANIA sum
   ważonych, nie współczynniki.

## 2. TWARDY RDZEŃ (uczciwie: tu jest ryzyko)

`certLo` wymaga mas okna PROGUJĄCEGO: `∑_{E ≤ T} N_E e^{−E/D}` — to
**niepełna theta / problem okręgu Gaussa** (sumy po powłokach x²+xy+y² ≤ T).
Brak formy zamkniętej; to jest jedyna realna matematyka okna.

Dopuszczone ścieżki (w kolejności rosnącej ryzyka):

- **P1 (rozbiór na ogony)**: jeśli okno `loWin` zawiera masę główną —
  `masa(okno) ≥ masa(całość) − masa(ogon < loT1) − masa(ogon > loT2)`.
  Suma całości = punkt 1.2 (zamknięta); ogony = Chernoff/MGF jak
  `MgfProduct`/`RejectionBound` + `exp_neg_le_inv_pow3`. **SKALA (analiza
  wstępna): okno ≈ +6σ w ogonie, szerokość ≈ 10⁻³σ — P1 dla dolnego
  boundu loWin NIE działa (bulk siedzi w dolnym ogonie okna); patrz P2′.**
- **P2′ (przekrzywienie Craméra — REUSE `mgf_product`!)**: DOKŁADNA
  postać okna (uwaga właściciela 2026-09-30 — nie zacierać zmienności
  wagi): `P(S ∈ I) = M(λ)^1535 · E_λ[e^{−λS}·1_I]`, więc dla `λ ≥ 0`,
  `I = [T1,T2]` **kanapka z oboma brzegami**:
  `M(λ)^1535·e^{−λT2}·P_λ(I) ≤ P(S ∈ I) ≤ M(λ)^1535·e^{−λT1}·P_λ(I)`.
  Skrót `e^{−Λ*(T)}` = przypadek brzegowy; przy marginesie ~1e-10
  czynnik `e^{−λS}` ma pozostać zmienny w oknie (kernel: waŜony moment
  `∑ w·e^{−λS}·1_I` — okno waŜone, nie pojedynczy czynnik).
  mgf splotu = potęga mgf jednoblokowej (`mgf1_eq` + `rest_moment_factor`
  — gotowe!). Reszta: `P_λ(I) = 1 − P_λ(I^c)` z ogonami pod tiltem
  (Chernoff w przekrzywionej mierze) albo bound lokalny
  (Fourier: `∫ φ_λ^1535`, |φ| jednoblokowe = theta).
- **P2 (Berry-Esseen z korektą)**: bez korekty ~2,5% (za mało na 0,08%);
  z korektą Edgewortha z rygorystycznym resztem — ciężkie, rezerwa.
- **P1** — tylko dla boundów GÓRNYCH i okien zawierających bulk
  (potencjalnie certHi — sprawdza L0).
- **P3 (pełna niepełna-theta / problem okręgu)**: poza zakresem; odmówić
  i zgłosić właścicielowi — bez cichych zmian drogi.

## 3. Drabina lematów (etapy mierzalne)

- **L0 — SAGE PRE-CHECK (obowiązkowy!):** `sage/check_conv_window.sage`
  liczy DOKŁADNIE wyrażenia z tezy (te same formy co dowód — lekcja
  `check_tail_chain`!): położenie progów vs odchylenie std masy głównej,
  margines `engineLo − aliasCap` vs `engineTriangleLo` w QQ/arb,
  werdykt P1/P2. **Asserty; `k = floor` (nie `//` na QQ!).**
- **L1 — jednoblokowo:** `singleMass_box_eq_theta : ∑_{b:Block} blockWeight b
  = Θ₂(s)` z błędem ≤ 2⁻³⁰⁰ (REUSE ThetaBox/Tg — box-tail ≈ 10⁻¹⁵⁸⁰).
- **L2 — splot strukturalny:** `restMass_le_T` jako współczynnik/progu
  `S^1535`; `restTotal : (całość) = (∑ blockWeight)^1535` (RawProductLaw +
  `Finset.prod`/`sum_prod_fn` — REUSE MgfProduct.Fubini).
- **L3 — kanapka okna (rdzeń P1):** `engineGapLo b ≥ restTotal_b ·
  (1 − tailLo − tailHi)` dla `b ∈ region1` — z MGF/Chernoff na splot
  1535-sumy (wariancja 1535·σ² — REUSE `mgf_product`!).
- **L4 — suma po region1:** `engineTriangleLo ≥ ...` — tu wchodzi
  `4·768` i `region1` (symetria: `RadialSymmetry`/`RadialTriangleSplit`
  REUSE); sprowadzenie do stałej × `singleMass`-type.
- **L5 — arytmetyka QQ:** `certLo`/`certHi` przez `norm_num` na literałach
  + granicach (wzór `lower_margin_Q`; `exponentiation.threshold` jak FinalTails).

## 4. Zasady okna (bez wyjątków)

Zero sorry/admit/native_decide; logi 0/0 (licznik błędów `error(\(|:)`!);
kompilacja seryjna przez `run_lean_guarded.sh`; Sage przez `sage <plik>.sage`;
asserty w każdym pre-checku; patche python `assert old in s`; zapisy
wyłącznie w W; praca równoległa sąsiadów (BINBIND/FPEMU) nie tykana.

## 5. Ryzyka i odmowa

- Jeśli L0 pokazuje, że progi leżą w masie głównej (nie w ogonie) —
  P1 odpada i okno raportuje `BLOCKED_ANALYTIC` z dokładnymi liczbami —
  **bez cichego przechodzenia na P3**. Decyzja o zmianie drogi = właściciel.
- Marża 0,08% jest cienka — każde oszacowanie liczyć na granicach
  jednostronnych (druga lekcja `tayl`/`tayl7`!).
