# Meldunek — T-THRESHOLD spike 001 (rolling)

> **Stan:** tor otwarty, **414/414** (`cargo test --manifest-path spike/Cargo.toml`), 0 warnings.
> Kolejki ft-tryb-pracy: Q, G, H, I, J, K — zamknięte; **T7 PRSS** — kod+testy PASS_SCOPED (werdyfikator PASS).
> **T8 pairwise PRSS + DKG bez clear f,F** — kod+testy PASS_SCOPED (werdyfikator PASS).
> **T10 offline NTRU + H1** — kod+testy PASS_SCOPED (6 nowych testów).
> **T13 audyt fixes (#16, #2)** — NAPRAWIONY + **#9** RETAINED (granica G-2) + 11 testów.
> To jest SPIKE — nie threshold FT / MPC-90 / produkt.

**Status: SPIKE / PROTOTYP — otwarcie toru. NIE threshold signing gotowy.
Żadnych deklaracji bezpieczeństwa progu ani publikacji.**

W (migracja 2026-10-23): `free_falcon_sign/proofs/ft1536/development/THRESHOLD_SPIKE_001/`
Źródło zamrożone: `proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`.
Źródła w `Obrazy/...` — **tylko odczyt, nie zmienione**.
Dane wyłącznie syntetyczne.

---

## 1. Inwentaryzacja (`INVENTORY.md`)

Warsztat MPC rodziny zinwentaryzowany z inspekcji kodu (testy **nie
uruchomiono** — drzewo tylko-do-odczytu):

- **san-mpc**: Shamir GF(256), PRSS (uproszczony), Beaver, SPDZ-MAC — działa
  w modelu dealerskim/semi-honest. ~48 testów.
- **san-shard-processor**: escrow 32 B k-of-n + falcon512 na udziałach —
  **nie threshold signing**. ~26 testów.
- **san-dkg**: Pedersen VSS 4-z-7 in-process — harness zbiera wszystkie udziały.
- **H-28 potwierdzone**: `spdz_setup(0)` pętla, underflow pustych kluczy,
  batch open pusty/ragged. Brak testów na edge cases.
- **H-31 potwierdzone**: `SpdzKeyShare` Copy+Clone+Debug, `Share` Zeroize bez
  Drop, słaby wipe stackowy.
- **Granice**: brak threshold FT, Klein-samplera, DKG seeda, złośliwego
  bezpieczeństwa GF256, pairwise PRSS.

Naprawy w **kopii** kiełka (nie upstream): zeroizacja Drop + brak Clone/Copy
na typach sekretów (`INVENTORY.md` §G–H).

## 2. Projekt na papierze (`DESIGN.md`)

Dwa warianty porównane (rundy/koszt/luki/bezpieczeństwo, z odniesieniami
2026/1300 i ATMACA, bez przesady):

- **(a) udział w pułapce (f,g,F,G) + MPC-sampler** — bliższy literaturze Falcon,
  wyższy koszt MPC, ryzyko rejection bias.
- **(b) udział w seedzie + MPC `G(seed*)`** — **klucz nigdy nie istnieje
  w całości**, niższy koszt (silnik całkowity), mniej literatury, ryzyko
  poprawności obwodu `G`.

**2-z-2 nazwane wprost:** to quorum „obaj albo nikt", nie próg tolerancji
padającego (n>k). Kiełek = minimalny krok (b).

## 3. Kiełek (`spike/` — 9/9 PASS)

```
cargo test --manifest-path spike/Cargo.toml
→ 5 unit + 4 integration: ALL PASS
```

Jeden krok progowy: **2 strony, Shamir GF(256), 16 × MPC-mul (Beaver) + XOR
→ `K[0] = H_fold(seed)` z udziałów 32-bajtowego syntetycznego seeda.**

| # | Test | Wynik |
|---|---|---|
| 1 | Happy path | PASS |
| 2 | **Wierność vs `H_fold(seed)` lokalnie** (32 powtórzenia) | PASS |
| 3 | Brak quorum (1 z 2) | PASS |
| 4 | **Sfałszowany udział → cichy zły wynik** (brak VSS) | PASS (assert_ne) |

Zeroizacja Drop na `Share`/`BeaverTriple`/`MaskedTriple`/`Polynomial`;
brak `derive(Clone, Copy)` na sekretach (H-31 w kopii).

## 4. Lista badań (`RESEARCH.md`)

14 pytań z priorytetami P0–P3. P0 (blokujące):
1. rejection sampling w MPC,
2. zgodność F04/F05 z technikami 2026/1300,
3. obwód `G(seed*)` w MPC,
4. VSS/MAC vs cichy zły wynik (dowód w kiełku, test 4).

---

## Trzy zdania

**Co wykazane:** w kopii warsztatu działają dwa wierne kroki progowe —
spike 001: `K[0]=H_fold(seed)` 2-z-2 (9/9); spike 002: **prawdziwy próg 2-z-3**
z kontrolą spójności (15/15) — fałszywy udział jest **wykrywany i blokowany**
(fail-closed), a nie cichy; guardy H-28 i zeroizacja H-31 w kopii.

**Najbliższy brak:** rejection sampling w MPC i obwód `G(seed*)` na udziałach
(P0.1–P0.3) oraz produkcyjna VSS (Pedersen/Feldman na grupie DL-trudnej) —
bez nich nie ma progu FT1536, jest tylko arytmetyka na bajtach.

**Czego to NIE implikuje:** to nie jest threshold signing, nie jest bezpieczny
protokół, nie jest DKG, nie jest Klein-samplerem, nie jest pełnym VSS
(kontrola spójności n>k tylko), nie dotyczy produktów (FTKEY/[N]/NXMS)
i nie zamyka MPC-90 ani DKG-01 w `[N]`.

---

## Spike 002 (kontynuacja) — 15/15 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 8 unit + 7 integration: ALL PASS
```

Szczegóły: `spike/SPIKE002_NOTES.md`, `DESIGN.md` §Spike 002.
Retained failures spike 002: `FAILURES.md` F-05..F-07 (w tym utknięcie
subagenta `general-1` — implementacja dokończona bezpośrednio).

## Spike 003 — G_frag — 22/22 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 12 unit + 10 integration: ALL PASS (bez regresji 001/002)
```

Syntetyczny łańcuch `G_frag`: 32 B seeda → 64 B materiału klucza **wyłącznie
na udziałach** (2-z-3, Beaver). Otwarcie bajtu dopiero gdy kontrakt każe.
Kawałek P0.3; **nie** formalne `G(seed*)` (R1 nie jest lokalne).
Szczegóły: `spike/SPIKE003_NOTES.md`.

## Trzy zdania (po spike 003)

**Co wykazane:** 2-z-3 + kontrola spójności + `G_frag` 32→64 B na udziałach
(22/22); fałszerstwo wykrywane; „klucz nigdy w całości" na pełnym materiale
wyprowadzania, nie tylko na jednym bajcie.

**Najbliższy brak:** rejection sampling w MPC (P0.1) i zgodność `G_frag`
z formalnym `G(seed*)` z R1 (P0.3); produkcyjna VSS.

**Czego to NIE implikuje:** nie threshold FT, nie `G(seed*)` z R1, nie
Klein-sampler, nie DKG/VSS produkcyjne, nie MPC-90, nie produkty.

## Spike 004 — rejection sampling (kawałek P0.1) — 28/28 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 18 unit + 10 integration: ALL PASS
```

Pomiar w `spike/src/rejection.rs` + `spike/SPIKE004_NOTES.md`:
jawny bit accept ⇒ jawne T; **retained finding:** przy niezależnym reject
T ⊥ x (hipoteza obalona — F-08); gdy p(accept) zależy od sekretu, T go
zdradza; fixed-window ujawnia indeks + bias warunkowy.

## Trzy zdania (po spike 004)

**Co wykazane:** kawałek P0.1 empirycznie — jawność liczby prób w transkrypcie
MPC, realny wyciek T przy p(accept|sekret), obalona hipoteza T⊥x
w niezależnym reject; razem 28/28 testów.

**Najbliższy brak:** accept-bit bez otwierania + rozliczenie biasu okna
(ciąg P0.1); zgodność `G_frag` z R1; produkcyjna VSS.

**Czego to NIE implikuje:** nie Klein-sampler, nie bezpieczeństwa odrzucania
w FT1536, nie threshold FT, nie MPC-90.

## Spike 005 — accept-bit bez otwierania — 34/34 PASS

Obwód „pierwszy przyjęty" na udziałach (Beaver); **nie otwiera** accept-bits.
Jawne: finalny x + 1 bit `found`. Przegląd `explore` potwierdził algebraikę;
poprawki: placebo test, sentinel `x==0`, `Zeroizing` na pośrednich.
Szczegóły: `spike/SPIKE005_NOTES.md`.

## Trzy zdania (po spike 005)

**Co wykazane:** wybór pierwszego przyjętego bez otwierania bitów accept
(shared == clear oracle), jawny tylko wynik + 1 bit okna; 34/34; przegląd
niezależny obwodu z poprawkami w aktach.

**Najbliższy brak:** bitness/`verify_consistency` na accept-shares; pełne
rozliczenie biasu abort/retry; Klein i `G(seed*)` z R1.

**Czego to NIE implikuje:** nie Klein-sampler, nie malicious-secure MPC,
nie threshold FT, nie MPC-90.

## Spike 006 — integralność accept + bias abort/retry — 38/38 PASS

`select_first_accepted_checked`: spójność Shamir + bitność `a(a+1)`
(fail-closed: `InconsistentShare` / `NonBitShare`). `measure_abort_retry_bias`
mierzy `mean_windows_per_success` i `max_hist_rel_diff`.
Szczegóły: `spike/SPIKE006_NOTES.md`.

## Trzy zdania (po spike 006)

**Co wykazane:** accept-shares są fail-closed (fałsz/nie-bit → Err), a nie
ciche; bias abort/retry pomierzony (retry realnie zużywa wiele okien przy
małym `t_max`); 38/38 PASS.

**Najbliższy brak:** Klein / 73-bit precision i `G(seed*)` z R1; pełne
rozliczenie biasu dla docelowego rozkładu Gaussa.

**Czego to NIE implikuje:** nie Klein, nie bezpieczeństwa odrzucania
w FT1536, nie threshold FT, nie MPC-90.

## Spike 007 — bias vs target + wektory — 42/42 PASS

`target_absx_pmf` + `measure_vs_target` (TV mały — model akceptacji dąży
do target); `deterministic_vector`/`vector_fingerprint` (wektory z ziarnem).
Szczegóły: `spike/SPIKE007_NOTES.md`.

## Trzy zdania (po spike 007)

**Co wykazane:** `x|accept` dąży do PMF docelowego (TV<0.15 przy 2k);
wektory deterministyczne powtarzalne z pinem fingerprintu; 42/42 PASS.

**Najbliższy brak:** właściwy dyskretny Gauss/Klein (stand-in `accept_weight`
to nie 73-bit precision), `G(seed*)` z R1, pełne piny `H_fold`/`G_frag`.

**Czego to NIE implikuje:** nie Kleina, nie Gaussa FT1536, nie threshold FT.

## Granica: „żaden proces nie zna pełnego materiału" (zgłoszenie właściciela)

**Prawda — wcześniej fałszywie sugerowane.** `verify_consistency` przez
`interpolate_poly` odtwarzało `a0=sekret`; harness (jeden proces) trzyma
wszystkie udziały; dealer zna wejście. **Naprawione algebraicznie:**
usunięto interpolację współczynników; `eval_lagrange` tylko w `x≠0`;
`PartyView` = jedna kolumna. **NIE zamknięte:** izolacja procesów,
DKG (dealer bez wejścia), otwarcia tylko w kontrakcie.
Pełny spis granic: `spike/BOUNDARY_NO_FULL_MATERIAL.md`.
Testy: 44/44 PASS (`b1`, `b2`).

## Trzy zdania (po granicy)

**Co wykazane:** obwód wyprowadzania i kontrola spójności **nie tworzą**
już `f(0)`; to jest granica algebraiczna, nie twierdzenie o izolacji.

**Najbliższy brak:** osobny spike izolacji procesów + DKG/dealer bez wejścia
— bez tego „żaden proces nie zna materiału" **nie jest** wykazane.

**Czego to NIE implikuje:** nadal nie threshold FT, nie „nikt nie zna
materiału", nie MPC-90.

## Spike 008 — izolacja procesów — 45/45 PASS

Osobne procesy `iso dealer|party|mailbox|demo`. Po `DEALER_DONE`: seed nie
na dysku, każda party tylko własną kolumnę. Test `s8_process_isolation_demo`.
Szczegóły: `spike/SPIKE008_NOTES.md`, granice w `BOUNDARY_NO_FULL_MATERIAL.md`.

## Trzy zdania (po spike 008)

**Co wykazane:** izolacja kolumn w osobnych procesach po wyjściu dealera
(45/45); F-13 częściowo domknięty — nie „nikt nie zna" w pełni.

**Najbliższy brak:** G_frag/Beaver **między** procesami bez agregacji,
DKG (dealer bez wejścia), audyt braku cudzych odczytów.

**Czego to NIE implikuje:** nie threshold FT, nie produkcyjnej izolacji,
nie MPC-90.

## Spike 009 — G_frag między procesami — 46/46 PASS

`iso full`: full-dealer + 3× worker + mailbox plikowy; **64 muls Beaver**
wyprowadzają 64 B udziałów `G_frag` bez agregacji kolumn. Test
`s9_g_frag_across_processes`. `SPIKE009_NOTES.md`.

## Trzy zdania (po spike 009)

**Co wykazane:** pełne wyprowadzanie `G_frag` w osobnych procesach (64 rundy
maski d,e); party nie widzą cudzych kolumn; 46/46 PASS.

**Najbliższy brak:** DKG (dealer bez wejścia) — to jest teraz **główna**
otwarta własność F-13; dalej Klein / `G(seed*)` z R1.

**Czego to NIE implikuje:** nie „nikt nie zna materiału" w produkcji,
nie threshold FT, nie MPC-90.

## Spike 010 — DKG seeda — 47/47 PASS

`iso dkg`: strony same wnoszą `s_i`, Shamir-deal bez centralnego sekretu,
`G_frag` == oracle `g_frag_local(⊕ s_i)`. Retained F-14 (wyścigi mailboxa),
F-15 (deal 1 B). `SPIKE010_NOTES.md`.

## Trzy zdania (po spike 010)

**Co wykazane:** seed nie istnieje jako całość w żadnym procesie dealera;
DKG + G_frag między procesami wierne oracle; 47/47 PASS.

**Najbliższy brak:** preprocessing trójek bez dealera, Klein / `G(seed*)` z R1,
audyt syscalli.

**Czego to NIE implikuje:** nie threshold FT, nie „nikt nie zna" w produkcji
(s_i w oracle), nie MPC-90.

## Spike 011 — trójki bez stojącego dealera — 48/48 PASS

`iso triples`: DKG a,b + jednorazowy `sacrifice-mul` (zeroizuje) +
`sacrifice-check` c=a*b. `SPIKE011_NOTES.md`. Zaufanie: proces jednego
mnożenia — nie OT/HE.

## Trzy zdania (po spike 011)

**Co wykazane:** trójki Beaver bez stałego dealera a,b; c=a*b sprawdzalne;
48/48 PASS.

**Najbliższy brak:** pełne triple-gen (OT/HE/PRSS-CDI), Klein / `G(seed*)` z R1.

**Czego to NIE implikuje:** nie SPDZ preprocess, nie threshold FT, nie MPC-90.

## Spike 012 — PRSS-lite — 52/52 PASS

Pary nasion, `ZeroShareStream` (⊕=0), masked open. `SPIKE012_NOTES.md`.
Budulec pod BGW/triple-gen; nie CDI, nie SHA.

## Trzy zdania (po spike 012)

**Co wykazane:** udziały zera z PRSS-par sumują się do 0; masked open
zachowuje sekret; 52/52 PASS.

**Najbliższy brak:** BGW/OT triple-gen (zero-shares to fundament),
Klein / `G(seed*)` z R1.

**Czego to NIE implikuje:** nie CDI-PRSS, nie trójek, nie threshold FT.

## Spike 013 — pełne trójki bez sacrifice-mul — 56/56 PASS

`mul_shamir_reshare`: u_i = λ_i a_i b_i + re-deal → c = a·b.
`iso full-triples`. `SPIKE013_NOTES.md`.

## Trzy zdania (po spike 013)

**Co wykazane:** mnożenie Shamir bez otwierania a,b i bez sacrifice-mul;
gotowy preprocessing trójek; 56/56 PASS.

**Najbliższy brak:** wpięcie mul do ścieżki G_frag zamiast triple-dealer;
Klein / `G(seed*)` z R1.

**Czego to NIE implikuje:** nie BGW/OT/SPDZ, nie threshold FT.

---

## Y — konkretne rozwiązania po etapie badawczym (2026-10-21)

Właściciel: „etap badawczy przeszliśmy — teraz konkretne rozwiązania"
z wniosków THRESHOLD (`SECURITY_POSITION` / P5 / P0). Zamiast stand-inów:

| ID | Co | Dowód | Weryfikacja |
|---|---|---|---|
| **Y1** | **Prawdziwy SHAKE256 na udziałach** (Keccak-f[1600], χ=`mul_shamir_reshare`, 38400 muls/perm) | bit-exact vs `shake256_clear` ('' / 'abc' / 64B) | WERYFIKATOR **PASS** (`general-15`) |
| **Y2** | Multi-block absorb (msg ≥ rate; pad w ostatnim bloku) | 136/137/2×136+50 B vs FIPS; koszt 2×38400 | WERYFIKATOR **PASS** (`general-16`) |
| **Y3** | `derive_key_material_shake` (`KEY_DERIVE_DOMAIN \|\| seed`) | oracle == clear; jawne ≠ `g_frag_local` | WERYFIKATOR **PASS** (`general-17`) |
| **Y4** | Wagi **Q73** (precyzja 73-bit) + TV vs **analityczna** Gaussa | siatka vs f64 err<1e-6; TV<0.12 | okno główne + Y5 fallback |
| **Y5** | Weryfikacja pakietu | `Y5_VERIFY_Y_PACKAGE.md` | ultra **anulowany** (F-Y5-1); Y1–Y3 mają osoby PASS |

**Suita: 201/201** (178 lib + 13 iso + 10 spike), 0 warningów.

Akta: `spike/Y1_SHAKE_ON_SHARES.md`, `spike/X1_KLEIN_PRECISION.md` §Y4,
`spike/Y5_VERIFY_Y_PACKAGE.md`. Retained: Y1-RF-1..3 (λ vs punkty;
bit↔bajt nie z udziałów; reconstruct z 1 udziału), Y4 σ² overflow +
z×½ (naprawione), F-Y5-1 (cancel subagenta).

## S — duże TODO: G(seed*) + tor sign v2 (2026-10-21)

| ID | Co | Dowód |
|---|---|---|
| S1 | `g_seed_circuit_shares` — L1 real SHAKE + L3 NTT | L1 == oracle, ≠ G_frag; butterflies > 0 |
| S2 | `derive_nonce_shake` — nonce z SHAKE | == oracle; zależy od msg_hash |
| S3 | `sign_tor_v2` — derive+nonce+sygnet na realnym XOF | ≠ stand-in `gseed_chain` |
| S4 | Piny determinizmu orakłów | `s4_pins_sign_tor_v2_deterministic_oracle` |

**Suite: 225/225.** **NIE** formalne `G(seed*)` (R1 evaluate OPEN) ani
threshold signing (brak F04/F05).

## Trzy zdania (po Y)

**Co wykazane:** realny SHAKE256 (FIPS 202) na udziałach Shamir
z multi-block, derive z domeną, wagi Q73 + Klein-lite, SPDZ-MAC z ukrytym
δ i DKG δ oraz tor sign v2 (L1 SHAKE + L3 NTT) — 225/225.

**Najbliższy brak:** formalne `G(seed*)` (R1 evaluate OPEN, piny packet),
pełny Klein bit-by-bit, F04/F05 na udziałach, model złośliwy (Y13 mapa).

**Czego to NIE implikuje:** progu FT, bezpiecznego generatora klucza,
zmiany werdyktu SAFE-FOR-RESEARCH ani równoważności z formalnym
`G(seed*)` (R1).

---

*Retained failures: `FAILURES.md`. Oryginały w `Obrazy/` nietknięte.*

---

## ZŁOTO — MPS4 F2→G→H (2026-10-21) — 319/319

**Łańcuch złota domknięty:** `z=(z0,z1)` wyłącznie z udziałów f,F →
`(s1,s2)` na udziałach → `encode_sig_static` → **`Ft1536Signature::verify==true`**
(pełne N=1536). Po setupie (H1) **nikt w torze sign nie widzi f ani F w clear**.

| Etap | Co | Dowód |
|---|---|---|
| **F2** | Sampler `z=round(t·f/q)`, `f^{-1}` Euklides, równanie `s2·h−s1≡t` | `MPS_F2_NOTES.md` |
| **G** | Splot jawne-t + rounding na udziałach (wariant B) | `MPS_G_NOTES.md`, pin `103747771` |
| **H** | `ishare.rs` — Shamir i16 (P=2^61−1), bit-decomp, otwarcia masek | `MPS_H_NOTES.md` |

**Suite: 319/319** (294 lib + 14 iso + 1 flag + 10 spike), 0 warnings.
Koszt: ~9.4M reshare + 4.7M bit-AND, ~30 s debug — **pomiar, nie deklaracja
produkcyjna**.

### Trzy zdania (meldunek MPS4-H)

1. **Wykazano:** z z udziałów i16 f,F (splot jawne-t + rounding w MPC:
   bit-decomp, otwarcia tylko masek) — bit-exact z F2, pin 103747771,
   engine verify==true na N=1536. Po setupie nikt w torze sign nie widzi
   f ani F w clear.
2. **Najbliższy brak:** G-2 — semi-honest (maska W-bitowa, brak VSS /
   malicious / security proof) + warunek max|F|<q/2 (~54–65 ≪ 9216 na realnych).
3. **To NIE implikuje:** threshold signing ani redukcji EUF-CMA→MT-ISIS;
   koszty = pomiar, nie produkcja.

**Retained:** F2-1, G-1 (suplement), G-2, G-3, H-1..H-4, F-01..F-25.

**Pliki złota:** `src/ishare.rs`, `src/mpc_sign.rs`, `MPS_F2_NOTES.md`,
`MPS_G_NOTES.md`, `MPS_H_NOTES.md`.

---

*Retained failures: `FAILURES.md`. Oryginały w `Obrazy/` nietknięte.*

---

## T6 / R-G2-1 — szum DGDG w Babai (fix) — PASS — 349/349

**Łańcuch okna:** F2 → G → H → G-2 → T6, wszystkie PASS.

1. **Wykazano:** tajny szum DGDG(σ) na udziałach w liczniku przed /q
   (`z=round((x+g)/q)`) — krawędź Babai rozmyta (H≈0.95 bita, var 0→0.25);
   szum **nieotwierany** w torze sign; złoto σ=4 → `Ft1536Signature::verify==true`
   (n=104e6 < 2.09e9). Pin F2 w torze det nietknięty.
2. **Najbliższy brak:** to łagodzenie, **nie proof** — Eflipy≈0.27σ
   (σ=4 → ~66% podpisów z flipem); deal przez zaufanego dealera (nie PRSS);
   brak pełnego Klein/ffLDL `D_Λ` i uzasadnienia σ vs Nguyen–Regev.
3. **NIE implikuje:** bezpieczeństwa statystycznego / UC / EUF-CMA —
   wyciek zaadresowany przedmiotowo w semi-honest; security claim zamknięty.

**Dowody:** `t6_` 8/8 + `mps4h` 8/8 · weryfikator PASS · suite **349/349**.

**Retained/otwarte (wg weryfikatora T6):** PRSS/MPC rejection bez dealera ·
Klein/ffLDL sampler `D_Λ` · poziom σ vs atak · flake s8 (osobno, F-18).

**Pliki:** `MPS_T6_GAUSS_NOTES.md`, `MPS_G2_NOTES.md` (suplement R-G2-1),
`Y13_MALICIOUS_MAP.md`.

---

## T7 — PRSS/MPC bez dealera — PASS — 365/365

**Wejście 349/349 → po T7: 365/365, 0 warnings, 0 ignore.**

| Krok | Stan | Dowód |
|---|---|---|
| T7.1 maski W-bit bez dealera | tak | `paired_bit_mask_prss`, `t7_prss_bit_mask_*` |
| T7.2 szum DGDG bez dealera | tak | `prss_dgdg_*`; H=0.9544, var=0.249 |
| T7.3 i16 f,F | **zastrzeżenie** | H1 = moment setupu (clear f,F w `g2_deal_trapdoor`) + reshare |
| T7.4 matrix fałszerstw | tak | tamper → MacFail; luka bez G-2 retained |
| Regresja złota | tak | `t7_gold_with_prss_*_engine_verify`; pin F2 `n=103747771` nietknięty |

**Ocena własna (bez marketingu):** usunięcie centralnego dealera masek
i pełnego szumu ze ścieżki złota. **H1 (klucz f,F) nadal w clear w setupie.**
PRSS = symulacja in-process (jeden rng), nie pairwise CDI.

### Trzy zdania

1. **Wykazano:** maski bit-decomp i szum DGDG w torze sign bez centralnego
   dealera widzącego clear-bit/pełny g; złoto i pin F2 nietknięte, 365/365.
2. **Najbliższy brak:** pełne pairwise PRSS/CDI z osobnymi rng partii
   oraz H1/keygen bez clear f,F.
3. **NIE implikuje:** malicious-secure, UC, EUF-CMA, „próg FT gotowy”
   ani braku dealera klucza.

**Proces:** implementator-subagent anulowany (F-05/09/20); kod spójny,
domknięcie w oknie głównym. Werdyfikator niezależny: PASS.

**Retained:** F2-1, G-1..G-3, H-1..H-4, T6, F-01..F-25.  
**Pliki:** `MPS_T7_PRSS_NOTES.md`, `Y13_MALICIOUS_MAP.md`.

---

## T8 — pairwise PRSS/CDI + keygen bez clear f,F — PASS — 384/384

**Wejście 365/365 → 384/384** (359 lib + 14 iso + 1 measure + 10 spike),
0 warnings, werdyfikator niezależny PASS.

| Kryterium | Status | Dowód |
|---|---|---|
| Pairwise PRSS (osobne rng, Σ zer=0) | PASS | `t8_pairwise_prss_*`, `pairwise_zero_streams` |
| Keygen bez clear f,F | PASS | `dkg_trapdoor_from_contributions` + 3 testy; `g2_deal_trapdoor` retained |
| Złoto + pin F2 | PASS | `t8_gold_*` engine verify, n=103747771 |
| Tamper → fail-closed | PASS | 6/6: MacFail / CommitmentMismatch / InconsistentShare |
| Retained nietknięte | PASS | F2-1, G-1..3, H-1..4, T6, T7 |

**API:** `pairwise_prss_bit_masks`, `pairwise_zero_streams`, `*_pairwise`,
`dkg_trapdoor_from_contributions`.

### Trzy zdania

1. **Wykazano:** pairwise PRSS z osobnymi rng każdej strony (brak
   centralnego dealera masek/szumu) oraz DKG trapdoora z wkładów per
   partia + Pedersen VSS — w nowym torze setupu nikt nie widzi pełnego
   f,F w clear; złoto i pin F2 nietknięte; 6 klas fałszerstw fail-closed.
2. **Najbliższy brak:** pełny bezdealerowy keygen NTRU (ważny wkład
   offline, range proof max|F|<q/2 w MPC) oraz auth triples / MAC na
   s1,s2 po ring-mulach (R-G2-2).
3. **NIE implikuje:** malicious-secure / UC / EUF-CMA / CDI proof,
   „braku dealera klucza” w pełnym sensie (H1 retained), ani że próg FT
   jest gotowy.

**Pliki:** `MPS_T8_PRSS_CDI_NOTES.md`, `Y13_MALICIOUS_MAP.md`.

---

## T9 — weighted keygen NTRU + range proof F + MAC na s1,s2 — PASS — 394/394

**Wejście 384/384 → 394/394** (369 lib + 14 iso + 1 measure + 10 spike),
0 warnings. Werdyfikator PASS.

| Etap | Status | Dowód |
|---|---|---|
| T9.1 weighted keygen | PASS | `dkg_trapdoor_from_weighted_contributions`, Σ w_i·wkład_i, VSS ważone, pin F2 |
| T9.2 range proof F | PASS | `validate_f_bound_shares` na udziałach (bez clear F), `FBoundViolation` przy ±q/2 |
| T9.3 MAC na s1,s2 | zamknięty | auth triples Z_P, MAC na ring-mul, open z kontrolą δ, tamper → MacFail |
| T9.4 matrix + mapy | zamknięty | `MPS_T9_NOTES.md`, `Y13_MALICIOUS_MAP.md` |

### Trzy zdania

1. **Wykazano:** ważony DKG NTRU (Σ w_i·wkład_i) daje udziały f,F bez
   clear w torze setupu; `max|F|<q/2` fail-closed na udziałach; wyniki
   ring-mul (s1,s2) z MAC + ukryte δ; tamper → MacFail; złoto przechodzi
   engine verify (pin F2 n=103747771).
2. **Najbliższy brak:** ważny NTRU `fG−gF=q` na ważonej sumie wciąż
   wymaga procedury offline (retained H1); pełne Beaver na 4N² jest API
   (`i_poly_mul_ring_shares_auth`), złoto używa tańszego wariantu
   MAC-liniowości + open z kontrolą δ.
3. **NIE implikuje:** malicious-secure / UC / EUF-CMA / CDI / „próg FT
   gotowy” — zamknięcie 3 luk spiku w semi-honest + detekcja fałszerstw.

**Retained:** F2-1, G-1..3, H-1..4, T6, T7, T8, `g2_deal_trapdoor`.
**Pliki:** `ishare.rs`, `pedersen.rs`, `lib.rs`, `MPS_T9_NOTES.md`.

---

## T10 — offline NTRU fG−gF=q na ważonej sumie + domknięcie H1 — PASS — 400/400

**Wejście 394/394 → 400/400** (375 lib + 14 iso + 1 measure + 10 spike),
0 warnings. Czas suite ~156 s (było 144 s; poniżej 2×).

| Etap | Status | Dowód |
|---|---|---|
| T10.1 offline NTRU na udziałach | PASS | `ntru_fg_gf_check_weighted_shares`, open tylko różnicy = q=18433 |
| T10.2 domknięcie H1 | zamknięte | `g2_deal_trapdoor` = retained/test-only; tor = weighted DKG + offline check |
| T10.3 pełne Beaver (opcjonalnie) | retained | `*_auth` API; złoto używa `*_mac`; pomiar poniżej 2× |
| T10.4 matrix fałszerstw | zamknięty | tamper f / zepsuty wkład G → false; digest ≠; VSS/FBound jak T9 |

### Trzy zdania

1. **Wykazano:** ważona suma wkładów NTRU przechodzi offline check
   `fG−gF=q=18433` na udziałach (open wyłącznie różnicy kontrolnej);
   zepsuta relacja lub wkład → fail-closed (`false`); zgoda na wkłady
   przez SHA3-256 digesty; `g2_deal_trapdoor` zostaje retained/test-only.
2. **Najbliższy brak:** pełna ceremonia publicznego keygen NTRU (wkłady
   muszą **sumować się** do poprawnego NTRU — check weryfikuje wynik,
   nie generuje go); pełne Beaver w złocie i `delta_known` retained.
3. **NIE implikuje:** malicious-secure / UC / EUF-CMA / CDI / „brak
   dealera klucza” w pełnym sensie / „próg FT gotowy”.

**Retained:** F2-1, G-1..3, H-1..4, T6, T7, T8, T9, `g2_deal_trapdoor`,
`delta_known`, pełny Beaver w złocie.
**Pliki:** `ishare.rs` (`ntru_fg_gf_*`, `trapdoor_contribution_digest`),
`MPS_T10_NOTES.md`, `Y13_MALICIOUS_MAP.md`, `TESTS.md`.
