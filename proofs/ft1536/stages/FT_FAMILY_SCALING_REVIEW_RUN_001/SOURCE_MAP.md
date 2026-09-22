# SOURCE_MAP — profil pełnoternarny FT1536 i odseparowana historia Gaussian-like

Wersja: 2026-09-21. Baza źródłowa tego opracowania: commit
`683b71be3e5f988d494431e46ac643169d93764a` (lokalny `main`), katalog
`Extra/c/` = kandydat L_RHO + FLOOR_CT, manifest 17 plików
`56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`.
Snapshot przypięty w zleceniu (`56700dd`) jest o dwa commity wcześniejszy;
różnica w sekcji 5.

Wszystkie liczby poniższej tabeli mają przypięte artefakty. Żadne twierdzenie
nie opiera się na nazwie checkpointu ani napisie PASS.

## 1. Tabela: stan / data / commit / f,g / KeyGen gates / sigma_sign / B / metryka / zakres / artefakt

| wiersz | stan | data | commit / manifest | prawo f,g | bramki KeyGen | sigma_sign | B | metryka | zakres twierdzeń | dokładny artefakt |
|---|---|---|---|---|---|---|---|---|---|---|
| **A. FT1536 pełnoternarny (bieżący)** | aktywny build na `main` | 2026-09-21 | `683b71b`; manifest `56974571…` | surowa propozycja: współczynniki iid w `{-1,0,1}` (`ternary=1`, `MKN(logn,ter)`); populacja kluczy = warunkowana powodzeniem całego KeyGen | `TERNARY_KEYGEN_MAX_ATTEMPTS = 3000000`; predykat akceptacji w `fg_probe_record_attempt` (normy raw i GS vs bound, `falcon-keygen.c`); emitowany klucz wymaga `fG-gF = q mod Phi` i odwracalności f (por. `falcon_complete_private`) | `FT1536_SIGNING_SIGMA = 768` (szerokość docelowa; NIE jest to wariancja propozycji ani parametr sekretu), adaptacyjny CDF 5×512, `CT_BEREXP=1`, 3072 wywołań skalarnych/próbę, `SIGN_MAX_ATTEMPTS = 16` | `FALCON_FT1536_NORM_BOUND2 = 2093922385 = floor(1.075²·2N·768²)` (kernel: `lean/FTBounds.lean`), ścisła nierówność `<B`; wybór 768 i 1.075 = **OPEN (SIG-001)** w komentarzu źródła | `Q(z1,z2) = Q_A2(z1)+Q_A2(z2)`, `Q_A2(a) = Σ_{i<N/2}(a_i² + a_i a_{i+N/2} + a_{i+N/2}²)` = `(1/N)Tr(a·ā)` (`falcon-enc.c` `falcon_is_short`, ter) | L_RHO, L_NTT, L_V (bajty→Ext0: `Q<B`), M0 (kontrakt+pojemność), H3 (centra numeryczne), RAW_ASSEMBLY (layout), STABLE_NORMALIZATION, INITIAL_TARGETS, POSTPROCESSING (częściowo), SCALAR_KERNEL_IID, SCALAR_GAUSSIAN_COMPARISON — **dokładne zakresy w sekcji 3** | `Extra/c/`; `provenance/FT1536_ACTIVE_BUILD.md`; `proofs/ft1536/stages/*` |
| **B. Historyczny „Gaussian-like" (Maj 2026)** | **KWARANTANNA** — tło historyczne, nie jest rodziną FT | 2026-05-06 | gałęzie `audit/research-ternary1536` (głowy w pliku) | **NIE ternarny**: zmierzony rozkład f,g o odchyleniu ≈3.3737/3.3741, maks. \|f\|=19, \|g\|=20 (próbka 100 000 akceptowanych kluczy) | 1.70084 prób/klucz (w tym rozkładzie); „keygen bound scale 105/100" | brak — tamten profil nie ma `FT1536_SIGNING_SIGMA` | `ternary bound2 = 160982450` (tamten profil, logn=10) | tamten worksheet: „NTRU/circulant key-recovery", `Xs = Xe` = proxy zmierzonego rozkładu | wyłącznie dowody empiryczne/modelowe tamtej populacji; **niczego nie przenosi się na wiersz A** | `TERNARY1536_WORKFLOW.md` (sha tekstu w Git); worksheet estymatora `2^446.2` dotyczy tylko tamtego prawa |
| **C. Historyczny profil binarny Falcon** | tło | — | ten sam kod (`ter = 0`) | rozkład Gaussian sekretów (kod binarny) | — | — | `s < 7085·q >> (10−logn)` (komentarz `1.2·1.55·√q·√(2N)`) | zwykła norma ℓ2 (gałąź binarna) | tylko kontekst porównawczy | `Extra/c/falcon-enc.c` gałąź `else` |
| **D. FT768 / FT3072** | **profile planowane — brak implementacji** | — | — | zamierzone: jak A | — | — | brak przypiętych wartości (kandydacka tabela `falcon_is_short` ma wartości dla logn 3–9, patrz sekcja 2) | jw. | żaden dowód nie obejmuje tych stopni | patrz sekcja 4 |

## 2. Parametry i miejsca w kodzie (wiersz A)

- Pierścień: `R_N = Z[X]/(X^N − X^{N/2} + 1)`, `N = 3·2^(logn−1) = 1536`
  (`logn = 10`), `q = 18433`. **Dokładna tożsamość:** `X^N − X^{N/2} + 1 =
  Phi_{3N}(X)` dla N = 3·2^k — porównanie współczynników nad ZZ w
  `results/sage_exact.json` (SA1) dla wszystkich trzech stopni. Stąd
  `3N | q−1` daje pierwiastki NTT rzędu 3N, a nie „N potęga dwójki".
- Metryka Verify: dosłowna forma z `falcon_is_short` (parowanie offsetem
  `hn = N/2`, forma A2) — wyprowadzenie równoważności ze śladem znormalizowanym:
  `PARAMETRIC_TASK_LAYOUT.md` Lemat 2 i `results/sage_exact.json` (SA2/SA3).
- Sampler: `ft1536-adaptive-cdf-tables.h` (5 poziomów `sigma0² ∈ {5,20,80,320,768}`,
  tablice 512), `falcon-sign.c` (`FT_TERNARY_ADAPTIVE_CDF`, komentarz o
  `dss = 1/(2σ²)`), wsparcie propozycji `[-365,366]` (certyfikat H3_RANGE),
  Bernoulli `BerExp` w CT-BerExp.
- Próg B: `internal.h:163` (`FALCON_FT1536_NORM_BOUND2`), komentarz
  `falcon-enc.c:632` podaje wzór `floor(1.075²·2N·768²)` i jawnie oznacza
  **SIG-001 / final norm-security selection = OPEN**. Kandydacka tabela progów
  dla logn 3–9 w tym samym `switch` nie ma wyprowadzenia w przypiętych
  źródłach (archeologia: `results/bounds_table.json`; krok ≈ 1608.2 w
  `bound/(2N)`, wartość majowa 160982450 mieści się w liniowej ekstrapolacji
  z dokładnością < 1). **Nie używać tych progów jako rodziny bez wyprowadzenia.**
- Layout: `PARAMETRIC_TASK_LAYOUT.md` (rekurencje + liczby dla 768/3072).

## 3. Mapa dowodów: co jest gdzie i czego NIE obejmuje

Zakresy wzięte z raportów etapów (statusy zachowane dosłownie):

| checkpoint | status w raporcie | zakres | czego NIE obejmuje |
|---|---|---|---|
| L_RHO | `L_RHO_PROVED_FOR_PINNED_MODEL` | normalizacja kanoniczna całego int16 | nic poza przypiętym modelem |
| L_NTT_FORWARD | `L_NTT_PROVED_FOR_PINNED_MODEL` | pipeline Verify: NTT, iloczyn, odejmowanie | nie jest prawem Sign |
| L_V_BRIDGE | `L_V_PROVED_FOR_PINNED_MODEL` | bajty → Ext0: `Q(z1,z2) < 2093922385` | odwrotnej implikacji, rozkładu, EUF-CMA, MT-ISIS |
| M0 | `M0_CONTRACT_DEFINED_FOR_PINNED_CANDIDATE` | gra/protokół/budżety, payload STATIC ≤ 3160 przy 4096 | redukcji bezpieczeństwa (`security_reduction_proved=false`) |
| H3_ZERO_SCALAR … LEFT_ROOT | mieszane (patrz raporty) | centra numeryczne, zero-aware floor/cast | prawa samplera, całego Sign |
| RAW_ASSEMBLY | `H3_RAW_ASSEMBLY_PROVED_FOR_PINNED_MODEL` | 6144 basis + 18432 tree, kolejność/odczyty | stabilnego rebuildu, czasu |
| STABLE_NORMALIZATION | `…PROVED_FOR_EMITTED_PINNED_MODEL` | szerokości, sqrt/div, bramki | wąskiej akceptacji bramkowej (`OPEN_NOT_DISPROVED`) |
| SOURCE_POSTPROCESSING | **`PARTIAL_PROOF`** | iFFT/rint/zwężanie/bajty | uniwersalnego Safe16 (`OPEN_NOT_DISPROVED`) |
| SCALAR_KERNEL_IID | `…PROVED_FOR_PINNED_IID_BUFFER_MODEL` | prawo skalarnego jądra w grze IID_BUFFER | realnego PRNG, prawa całego Sign |
| SCALAR_GAUSSIAN_COMPARISON | `…BOUND_PROVED_FOR_PINNED_IID_BUFFER_MODEL` | TV(K_C,G) ≤ 2^−36, χ²(K_C‖G) ≤ 2^−60 lokalnie | straty całego wywołania, η_pre, kompozycji wspólnej |

Ogólny wniosek mapy: **żaden checkpoint nie jest dowodem bezpieczeństwa
skalowania ani gotowości FT768/FT3072**; H3_RANGE i ORDERED_REACH zachowują
`PARTIAL_PROOF`, a prawo samplera i realny PRNG pozostają otwartymi
obowiązkami (potwierdzone w NEXT_INTERFACE kolejnych etapów).

## 4. Czy repo zawiera FT768/FT3072? — dowody „braku"

To nie jest argument z nazwy; konkretne miejsca w kodzie (manifest `56974571…`):

1. `falcon-sign.c` `load_skey`, gałąź ternary: `if (logn != 10 || n != 1536 ||
   q != 18433) return 0;` — loader odrzuca inne stopnie.
2. `falcon-keygen.c` `ft_keygen_leaf_certificate`: `if (logn != 10 || …) return 0;`.
3. `falcon-keygen.c` `ffLDL_fft3_keygen`/`load_skey`: `treesize = 12 * n`
   oraz `tree_words == 12 * n` — stała `12 = logn+2` tylko dla logn = 10
   (dla 9 rekurencja wymaga 11n, dla 11 — 13n).
4. `falcon_is_short` ma co prawda kandydackie progi dla logn 3–10, ale bez
   wyprowadzenia (sekcja 2) — to nie jest implementacja profili.
5. `test_falcon.c` ma statyczne wektory `[768]` (logn=9, ternary KAT) — to
   **historyczny materiał testowy stopnia 768**, nie projektowany FT768
   (pełnoternarny profil z własnymi parametrami/progami/samplerem). Zgodnie z
   zleceniem: historyczny ternary-768 ≠ projektowany FT768.

Wniosek: repo zawiera **genericzne fragmenty** rozmiarowe (`MKN`) i historyczne
wektory 768, ale funkcjonalnie przypięty jest wyłącznie profil logn = 10.
FT768/FT3072 są profilami planowanymi.

## 5. Różnica: `56700dd` (snapshot zlecenia) → `683b71b` (zbadany) → `22e6dd4` (bieżący HEAD)

- `64af4cb` — zamknięcie checkpointu SCALAR_GAUSSIAN_COMPARISON (lokalne
  granice TV/χ² w IID_BUFFER; odwrotna χ² = ∞ z jawnej przyczyny nośnika).
  Przenosi to do mapy §3 wiersz przedostatni; nie zmienia żadnych parametrów.
- `683b71b` — przygotowanie zadania ORDERED_JOINT_KERNEL (755 przypiętych
  wejść).
- `22e6dd4` (HEAD w chwili finalizacji pakietu) — zamknięcie i odbiór
  ORDERED_JOINT_KERNEL (`22e6dd4`, odbiór 359/359) oraz przygotowanie
  zadania H6P_REFERENCE_BAD_EVENT (lane Astry, W
  `FT1536_H6P_REFERENCE_BAD_EVENT_RUN_001`; w indeksie Git znajdowały się
  wtedy staged pliki tego przygotowania — indeksu nie dotykano).
- **Źródła `Extra/c` są przez cały czas identyczne** (manifest 17 plików
  `56974571…` — ten sam w proweniencji aktywnego buildu i w pinach zadań
  ORDERED_JOINT/H6P). Audyt źródłowy tego pakietu wiąże się z manifestem,
  nie z numerem commita; wersjonowanie dowodów (H3/ORDERED_JOINT) nie
  zmienia badanego kodu. Mieszanie wersji źródeł nie występuje.

## 6. Kwarantanna: fakty historycznego workflow (maj 2026), dosłownie

Poniższe dotyczy wyłącznie wiersza B i pozostaje w tekście jako odseparowane
tło (wymóg przeglądu: „historyczne Gaussian-like dane mogą pozostać wyłącznie
jako wyraźnie oddzielone tło"):

- 100 000 akceptowanych kluczy: `stddev_f = 3.373701125763167931`,
  `stddev_g = 3.374115793156731106`, `max_abs_f = 19`, `max_abs_g = 20`,
  `keygen attempts per accepted key = 1.70084`.
- 100 000 podpisów: 0 błędów Verify, średni rozmiar ≈ 1983 B, maks. stosunek
  norma/próg ≈ 0.9184.
- Worksheet podciałowy: **wszystkie 7 podpól indeksu 2** (zgodne z naszą
  dokładną enumeracją, `results/sage_exact.json` SA4), najgorsza marża
  +3.659349022 bitów ponad GH, 0/100000 poniżej GH — dla tamtego rozkładu.
- Worksheet estymatora: SageMath + lattice-estimator, `2^446.2` — dla tamtego
  prawa sekretów.

Żadna z tych liczb nie jest użyta w wnioskach o rodzinie FT. Sam sampler
Gaussa, heurystyka Gaussa i porównania z rozkładem Gaussa pozostają poprawnymi
pojęciami — wycofuje się wyłącznie przenoszenie danych tamtej populacji.
