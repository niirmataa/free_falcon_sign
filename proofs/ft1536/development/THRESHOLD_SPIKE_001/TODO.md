# TODO — tor T-THRESHOLD (konsolidacja)

**W:** `free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`
**Status toru:** SPIKE / PROTOTYP otwarty. **NIE** threshold signing gotowy.
**Reguła:** `[ ]` = brak odbioru; `[x]` = warunek zamknięty z dowodem w aktach.
Prawda przed tempem; retained failures w `FAILURES.md`; twierdzenia tylko
tak szeroko, jak dowody (`spike/BOUNDARY_NO_FULL_MATERIAL.md`).

---

## A. Zamknięte (dowody w aktach)

| ID | Pozycja | Dowód | Status |
|---|---|---|---|
| TT-00 | Inwentaryzacja warsztatu MPC (san-mpc / shard / dkg); H-28/H-31 w kodzie | `INVENTORY.md` | [x] |
| TT-01 | Projekt A vs B (pułapka vs seed) | `DESIGN.md` | [x] |
| TT-02 | Spike 001: `H_fold` 2-z-2 → `K[0]` | `spike/` 9/9 | [x] |
| TT-03 | Spike 002: próg **2-z-3** + detekcja fałszerstwa (fail-closed) | 15/15 | [x] |
| TT-04 | Spike 003: `G_frag` 32→64 B na udziałach | 22/22 | [x] |
| TT-05 | Spike 004: rejection — jawne T; **F-08** T⊥x obalone; T zdradza S | 28/28 | [x] |
| TT-06 | Spike 005: select pierwszego accept **bez otwierania** bitów | 34/34 | [x] |
| TT-07 | Spike 006: bitność `a(a+1)` + spójność; **F-11** retry vs single obalone | 38/38 | [x] |
| TT-08 | Spike 007: bias vs target (TV); wektory deterministyczne | 42/42 | [x] |
| TT-09 | Granica F-13: bez `f(0)` w kontroli; `PartyView` | `BOUNDARY_*.md` | [x] |
| TT-10 | Spike 008: izolacja procesów (dealer/party/mailbox) | 45/45 | [x] |
| TT-11 | Spike 009: `G_frag` 64 muls **między procesami** | 46/46 | [x] |
| TT-12 | Spike 010: **DKG seeda** (brak `seed.bin`) + G_frag == oracle | 47/47 | [x] |
| TT-13 | Spike 011: trójki DKG a,b + sacrifice-mul + check | 48/48 | [x] |
| TT-14 | Spike 012: PRSS-lite (udziały zera, masked open) | 52/52 | [x] |
| TT-15 | Spike 013: **pełne trójki** Lagrange re-deal, bez sacrifice-mul | 56/56 | [x] |

Stan testów: `cargo test --manifest-path spike/Cargo.toml` → **56/56 PASS**.

---

## B. Bliski tor (kolejność wykonania)

### B1. Integracja wewnętrzna spike (1–2 okna)

| ID | Zadanie | Warunek odbioru | Status |
|---|---|---|---|
| TT-20 | Wpiąć `mul_shamir_reshare` w `G_frag` zamiast `triple-dealer` | `iso dkg` bez `trip*`; testy zielone | [x] 56/56 |
| TT-21 | Mnożenie wieloprocesowe (`u_i` re-deal mailbox) | `um{m}_{p}_{x}.bin`; brak `u` w całości | [x] w TT-20 |
| TT-22 | `iso dkg` + re-deal scalone (pełny tor) | `DKG_OK` bez triple-dealer | [x] w TT-20/30 |
| TT-23 | Wektory `H_fold` / `G_frag` / `mul` + piny | `VECTOR_PINS.md`, tests_vectors | [x] 59/59 |

### B2. Granice F-13 / twierdzenia (wymagane zanim cokolwiek „próg")

| ID | Zadanie | Warunek odbioru | Status |
|---|---|---|---|
| TT-30 | Bez `contrib*.bin` na dysku | `CONTRIB` na stdout/oracle parenta | [x] 59/59 |
| TT-33 | Fałszywy udział w torze multi-process | `verify-cols` exit 3; `s33_forged_col_detected` | [x] 60/60 |
| TT-31 | Audyt odczytów party | `ISO_AUDIT` + `s31` (brak strace w env) | [x] 62/62 |
| TT-32 | 3-z-5 | `m4_mul_3of5`, `iso dkg5`, `s32` | [x] 63/63 |
| TT-40 | Klein-lite Gaussa | `SPIKE014`, g1–g4, gs1 | [x] 68/68 |
| TT-51 | retry vs target (Gaussa) | `tt51_retry_vs_gauss_target` | [x] 69/69 |
| TT-50 | koszt G_frag | 64 muls | [x] 71/71 |
| TT-41 | accept-bit z udziałów u | `tt41_*` (porównanie jawne w spiku — **częściowe**) | [x] 72/72 |
| TT-43 | notka F04 vs 2026/1300 | `TT43_F04_vs_2026_1300.md` | [x] notka |
| TT-52 | refresh udziałów | `tt52_refresh_preserves_secret` | [x] 73/73 |
| — | mutation-check mul | `mut1_corrupt_c_detected` | [x] 74/74 |
| — | cross-check 2-z-3 ≡ 3-z-5 | `x1_g_frag_2of3_matches_3of5` | [x] 75/75 |
| TT-53 | MAC na otwarcie (SPDZ-lite) | `tt53_*` — δ jawne | [x] 79/79 |
| TT-54 | MailboxTransport stub | `tt54_mem_mailbox_roundtrip` | [x] 80/80 |

### B3. P0 badawcze (blokuje „threshold FT")

| ID | Zadanie | Warunek odbioru |
|---|---|---|
| TT-40 | **Klein-sampler / dyskretna Gaussa w MPC** (stand-in `accept_weight` ≠ 73-bit) | pomiar precyzji + rejection na udziałach; odniesienia 2026/1300, ATMACA |
| TT-41 | Accept-bit / rejection **bez otwierania** w pełnym samplerze (ciąg P0.1) | brak jawnych bitów accept w transkrypcie; bias vs target rozliczony |
| TT-42 | **`G(seed*)` z R1** vs `G_frag` — zgodność / kompilacja obwodu | porównanie z formalnym opisem (R1 osobny tor — **stop-and-report** przy rozjeździe) |
| TT-43 | Zgodność F04/F05 z technikami 2026/1300 (co się psuje w fixed-point) | notka różnicowa + ewentualny kawałek implementacji |
| TT-44 | Produkcyjna VSS (Pedersen/Feldman na grupie DL-trudnej) zamiast kontroli spójności | wykrywanie fałszerstw bez tajemnicy po stronie sprawdzającego; nie GF(256)* |

### B4. P1–P2 (koszt, model, formalizacja)

| ID | Zadanie | Priorytet |
|---|---|---|
| TT-50 | Rundy / trójki / RAM: `G_frag` + sampler dla 2-z-3 i 3-z-5 | P1 |
| TT-51 | Abort/retry vs **target** (nie vs single) przy dużym `t_max` | P1 |
| TT-52 | Reshare / refresh udziałów seeda (stub upstream) | P2 |
| TT-53 | SPDZ-MAC na otwarciach (nie surowy Beaver) — wymóg E-21 | P2 |
| TT-54 | GhostDB → mailboxy zamiast plików (E-21 / MPC-05) | P2 |
| TT-55 | Formalizacja `G(seed*)` + próg w kernelu (tor R1) | P2 |
| TT-56 | Port napraw H-28/H-31 do san-mpc (lista `INVENTORY.md` §H) — **poza W**, decyzja właściciela | P3 |

---

## C. Wiązanie z `[N]` (SOURCE_OF_TRUTH) — NIE zamyka się sam

| ID w `[N]` | Co ten tor daje | Czego NIE zamyka |
|---|---|---|
| **MPC-90** | „jedna operacja na rozdzielonym materiale" — kiełki 001–013 | nie recovery, nie threshold FT, nie cała biblioteka |
| **MPC-01..07** | materiał badawczy do wyboru operacji / kosztów / ADR | brak ADR w `[N]`, brak Ghostnet, brak odbioru |
| **DKG-01..02** | DKG seeda (spike 010) to **nie** DKG materiału wydań | brak kontraktu epok / 2-z-3 pieczęci |

**Zasada:** statusy w `docs/SOURCE_OF_TRUTH.md` nadaje wyłącznie koordynator
`[N]`. Ten plik nie jest drugą listą pracy repo `[N]` — jest mapą toru
badawczego w W.

---

## D. Poza zakresem (celowo)

- Publikacja, integracja FTKEY / [N] / NXMS
- Deklaracja „threshold gotowy" / bezpieczeństwa progu bez dowodu
- Pełny port SPDZ, Klein FT1536, poprawki oryginałów w `Obrazy/`
- Push / commity poza W bez sygnału właściciela

---

## E. Kolejne okno (propozycja)

1. **TT-20** (wpinanie mul w G_frag) — szybkie, domyka preprocessing
2. **TT-21** (re-deal przez mailbox) — domyka F-13 na mnożeniu
3. **TT-23** (piny wektorów)
4. Potem **TT-40** (Klein) jako osobne okno badawcze

## Stan (rolling)

**365/365** (340 lib + 14 iso + 1 measure + 10 spike), 0 warnings. Wejście T7: 349/349.
Kolejki Q, G, H, I, J, K: **zamknięte**. Retained: F-01..F-21 (F-18 isolation, F-21 /tmp VM).

**T7 PRSS/MPC bez dealera (2026-10-21) — [x] kod+testy+notatki w W.**
- T7.1 maski W-bit: `paired_bit_mask_prss` / `shared_bit_masks` (b=⊕β_i bez clear).
- T7.2 szum: `prss_dgdg_*` w `mps4h_*`; pomiar H=0.9544, var=0.249.
- T7.3 H1=moment setupu (zastrzeżenie) + `reshare_ipoly`.
- T7.4 tamper matrix: `t7_tamper_*_macfail` + `t7_no_g2_noise_tamper_retained_gap`.
- Notatki: `spike/MPS_T7_PRSS_NOTES.md`, Y13 upd. Retained F2/G/H/T6 nieskasowane.
- Proces: implementator subagent anulowany w trakcie (kod spójny, suite zielone);
  weryfikator niezależny w toku. NIE deklarować malicious-secure / H1 bez dealera.

**Kolejka I1–I4: [x]** (139/139 unit+iso+spike przy pełnym biegu).
I1 koszt: H_fold 16B, G_frag 64, native 128, cmp 255/bit (`I1_COST_NOTES.md`).
I2 probed+select: `i2_probed_select_matches_clear`.
I3 SHAKE-MPC: `I3_SHAKE_MPC_COST.md` (10³–10⁵ × G_frag).
I4: TESTS.md rollup.

**Retained:** F-14/F-18 isolation flake (pod obciążeniem 0/11 — timeouty procesów).

**Kolejka Q1–Q5 (ft-tryb-pracy): ZAMKNIĘTA.** Weryfikator PASS×2 (Q1, Q2–Q5).
Implementator ultra-pro (general) 2× stall/cancel → fallback okno główne (F-05/09/20).

`cargo test --manifest-path spike/Cargo.toml` → **112/112** (93 lib + 9 iso + 10 spike).
Audyt ULTRA: `spike/AUDIT_TESTS_2026-10-20.md` (YELLOW → poprawki wciśnięte).
Po audycie: G_frag MAC tamper, PRSS n=5, min-k, u==w, StdRng seedy.
Retained: F-01..F-18 (`FAILURES.md`). Flak izolacji: F-18.
Otwarte blisko: TT-41 pełne porównanie w MPC, TT-54/55, TT-56 port upstream
(`H28_H31_PORT_PROPOSAL.md`). TT-42 (R1) — wymaga toru R1.
Piny: `VECTOR_PINS.md` (H_fold `0xd7`/`af648a4c86031436`, G_frag `34ed69b6fbaa6613`).

*Ostatnia aktualizacja: po TT-20..53 + piny + MAC 3-z-5 (79/79).*

---

## F. Kolejka FT-TRYB-PRACY (2026-10-20)

| ID | Zadanie | Priorytet | Zależności | Status |
|---|---|---|---|---|
| Q1 | Naprawa ostrzeżeń + seedy testów statyst. | P1 | — | [x] PASS 113/113, 0 warn; Weryfikator PASS |
| Q2 | TT-41: jasna korekta nazw + kontrakt (MPC-compare otwarte) | P1 | — | [x] rename `accept_bit_from_u_opened`, SPIKE015 |
| Q3 | MAC tamper matrix share/mac/delta | P2 | — | [x] 116/116 |
| Q4 | TESTS.md rejestr | P2 | Q1 | [x] 116 testów, `spike/TESTS.md` |
| Q5 | TT-56 propozycja portu H-28/H-31 | P3 | — | [x] `H28_H31_PORT_PROPOSAL.md` (bez upstream) |

**Role:** Implementator ultra-pro (kod+testy), Weryfikator (niezależny), Recenzent (krytyczne).
**Git:** jeden writer; na razie brak commitów (W robocze, bez sygnału push).

---

## G. DUŻE TODO — faza 2 (2026-10-20, ft-tryb-pracy)

```
ID: R1 [x]
Cel: pełne porównanie accept-bit bez otwierania u (MPC compare) w spiku
Zakres IN: spike/src/select.rs (lub cmp.rs), testy
Zakres OUT: Obrazy/, [N]/, R1-tor formalny
Kryteria: accept bit z udziałów u,w bez reconstruct(u); test u<w granice;
          nazwy bez „opened"; 116→N testów zielonych
Dowody: cargo test; brak reconstruct w torze accept (grep)
Zależności: BRAK

ID: R2 [x]
Cel: G_frag/MAC w iso multi-process (open z MAC w dkg/dkg5)
Zakres IN: spike/src/bin/iso.rs, tests/isolation.rs
Zakres OUT: GhostDB, [N]
Kryteria: iso dkg + open_with_mac; tamper → exit != 0
Dowody: s-test isolation + stderr
Zależności: R1 nieblokująco

ID: R3 [ ]
Cel: Klein-lite w torze select bez dealera accept (integracja R1+Gaussa)
Zakres IN: select.rs, rejection.rs
Kryteria: okno Gaussa, accept z u, select first-wins; oracle == clear
Zależności: R1

ID: R4 [x]
Cel: TESTS.md ↔ twierdzenia (audyt nazwa=test) + mutacje na G_frag
Zakres IN: TESTS.md, lib.rs testy mut
Kryteria: każdy fałszywy bit w G_frag etap1/2 łapany (≥2 mutacje)
Zależności: BRAK

ID: R5 [x]
Cel: notka R1-interface (co dokładnie trzeba z toru R1 do G(seed*))
Zakres IN: TT55_R1_Gseed_TODO.md rozszerzenie
Kryteria: lista symboli/obwodów z KEYGEN_* + kontrakt pytań do R1
Zależności: BRAK (researcher)
```

**R1: [x]** `cmp.rs` accept_bit_from_u_shares_probed (P_w, bez reconstruct u) — Weryfikator PASS 123/123.
**R5: [x]** `spike/R5_R1_INTERFACE_NOTES.md` — G(seed*)=KeygenByteGame134.evaluate, pytania do R1.

Kolejność: R1 → R3; równolegle R2, R4, R5.

---

## H. Poziom 1–3 — plan właściciela (2026-10-20)

**Wada:** kontrola spójności przez interpolację = odtwarzanie sekretu.
**Lekarstwo:** zobowiązania (Pedersen / ghost-dkg), nie interpolacja.

| ID | Cel | Kryteria | Status |
|---|---|---|---|
| H1 | **Pedersen VSS w spiku** (`src/pedersen.rs`, Ristretto) | verify_exp_share bez interpolacji | [x] 129/129 |
| H2 | Pedersen w osobnych procesach (`iso ped-demo`) | fałsz→exit 3, brak poly.bin | [x] 130/130 |
| H3 | Test graniczny reconstruct=FAIL | `h3_reconstruct_attempt_panics` | [x] |
| H4 | Share-native łańcuch `derive_key_material_native` 128 B | h4_* testy | [x] |
| H5 | Paper szkic | `H5_PAPER_SKETCH.md` | [x] szkic |

**Kolejność:** H1 → H3 → H2 → H4 → H5. **Wszystkie H: [x] (132/132).**
**Założenia:** trusted dealer w keygenie = „moment" zostaje do H4 (klucz urodzony z udziałów).
Wariant A (pułapka+MPC-sampler) — rezerwa, cięższy (NTRU trapdoor gen w MPC = badania).
SHAKE w MPC ~10^8 bramek — drogie, wykonalne.

R3 (Gaussa+cmp integracja) — **wstrzymane** na rzecz H.

---

## I. Kolejka po H (ft-tryb-pracy)

```
ID: I1 [x]
Cel: pomiar kosztu wyprowadzania (mnożenia/rundy) — G_frag vs native vs cmp
Zakres IN: spike/src/lib.rs, cmp.rs, testy pomiarowe, notka
Kryteria: liczba Beaver/mul_shamir_reshare na bajt i na łańcuch; tabela w I1_NOTES
Zależności: BRAK

ID: I2 [x]
Cel: integracja accept-bit probed (cmp) + select (dawne R3)
Zakres IN: select.rs, cmp.rs, testy
Kryteria: okno małe t_max, accept z cmp, first-wins == clear; bez reconstruct(u)
Zależności: I1 nieblokująco

ID: I3 [x]
Cel: notka kosztów SHAKE/KDF w MPC (szacunek + źródła)
Zakres IN: R5/H5 uzupełnienie, researcher
Kryteria: rząd wielkości bramek/rund, odniesienia
Zależności: BRAK

ID: I4 [x]
Cel: rollup TESTS.md + FAILURES + REPORT (spójność liczb)
Kryteria: liczby testów zgodne cargo test; retained nie skasowane
Zależności: I1–I3
```

---

## J. Kolejka po I

```
ID: J1 [x]
Cel: workdiry iso pod W, nie /tmp (F-21) + timeouty
Kryteria: TMPDIR/workdir w FT1536_.../work/.../iso-tmp; suite zielona bez /tmp
Zależności: BRAK

ID: J2 [x]
Cel: pełny tor Gaussa + probed accept + select (okno)
Kryteria: draw_gauss_window → probed accept → select == clear; test
Zależności: BRAK (I2 gotowe)

ID: J3 [x]
Cel: szkic paperu w dokument (nie markdown-only w spike) — outline
Kryteria: sekcje + dowody z TESTS/I1/I3
Zależności: BRAK
```

---

## K. Kolejka po J (po kolei)

| ID | Cel | Kryteria | Status |
|---|---|---|---|
| K1 | Pakiet pytań do R1 | `spike/K1_R1_QUESTIONS.md` | [x] |
| K2 | Patch H-28/H-31 (draft) | `spike/H28_H31.patch` (nie aplikowany) | [x] |
| K3 | SHAKE stub fail-closed + I3 notka | `k3_shake_stub_fail_closed` | [x] |
| K4 | Rollup REPORT | [x] |

---

## M. Kolejka z MAP_GSEED (odpowiedzi wstępne R1)

| ID | Cel | Status |
|---|---|---|
| M1 | Mapa L0–L4 | [x] `MAP_GSEED_SHARE_NATIVE.md` |
| M2 | Rząd kosztu XOF pk+sk | [x] w MAP §3 |
| M3 | `sample_gauss_native` | [x] 144/144 |
| M4 | Mapa regionów | [x] `M4_REGION_MAP.md` |
| M5 | Schemat pinów | [x] `M5_PINS_SCHEMA.md` |
| M6 | Failure → abort | [x] `M6_FAILURE_ABORT.md` |
| M7 | Doły GOAL + reguła | [x] `M7_BOUNDS_NOTE.md` |
| M8 | Stop-and-report | [x] `M8_STOP_AND_REPORT.md` |

**Korekta:** M4–M7 **nie czekają na R1** — mapowanie robimy sami z lokalnych
materiałów KEYGEN_* + `K1_R1_ANSWERS_PRELIM.md`. Cel: **kompletny wynik** spiku
(share-native G-fragment + mapa + koszty + piny syntetyczne + reguła dołów).

---

## N. Domknięcie pakietu (kompletny wynik)

| ID | Cel | Status |
|---|---|---|
| N1 | PACKAGE_INDEX | [x] |
| N2 | entry_pin_synthetic | [x] |
| N3 | łańcuch 10³ muls region-3 | [x] |

---

## O. Po N — integracja i dowody

| ID | Cel | Status |
|---|---|---|
| O1 | `iso pipeline` | [x] 170/170 |
| O2 | Audyt ULTRA YELLOW→poprawki (counts, F-16/17, false-greens, warn) | [x] 170/170 |
| O3 | Paper: rozwinięcie J3 na 1–2 strony tekstu | [ ] |

---

## P. PRÓG PODPISU FT1536 (cel długodystansowy)

| ID | Cel | Kryteria | Status |
|---|---|---|---|
| P1 | Protokół sign | [x] `P1_SIGN_PROTOCOL.md` |
| P2 | `derive_nonce_shares` 40 B | [x] 153/153 |
| P3 | Klein-lite: `sample_gauss_native` + I2 probed | [x] (koszt 259/bit) |
| P4 | `sygnet_synthetic` 32 B | [x] 154/154 |
| P5 | `P5_GAPS_TO_FULL_FT_SIGN.md` | [x] |

**Cel:** próg podpisu — nie deklaracja produktu. Trusted dealer/moment jeszcze wolno w spiku (do P4+).

| P6 | `sample_klein_lite_3` | [x] |
| P7 | `ntt_butterfly_shares` | [x] |

| P8 | mid-pass NTT łańcuch | [x] |
| P9 | div_const (model mq_div_18433) | [x] |

---

## W. DUŻE TODO — jeden rytm do końca (2026-10-20)

Cel końcowy: **kompletny pakiet progu** (współdzielony sign-tor, mapy,
koszty, piny, paper) — bez deklaracji „próg FT gotowy".

| ID | Zadanie | Kryterium | Status |
|---|---|---|---|
| W1 | NTRU-relacja model | [x] |
| W2 | `iso sign-demo` | [x] SIGN_DEMO_OK |
| W3 | `gseed_chain` | [x] 170/170 |
| W4 | `W4_PAPER.md` | [x] |
| W5 | Sync + **ULTRA-WERYFIKATOR PASS** | [x] |

**W1–W5: [x] — pakiet progu zamknięty w rytmie. 170/170.**

**Rygor (lekcja):** trudne zadania i weryfikacja = **ultra** subagent.
Implementacja w oknie głównym tylko jako fallback po awarii general-ultra
(F-05/09/20) — retained.

---

## X. Po W (ultra: implementacja + weryfikacja)

| ID | Zadanie | Status |
|---|---|---|
| X1 | Q16 gauss_weight_q + TV | [x] 170/170, X1_KLEIN_PRECISION.md |
| X2 | XOF multi-block squeeze stand-in | [x] `X2_XOF_SLICE.md` (stand-in, nie SHAKE) |
| X3 | ULTRA-WERYFIKATOR X1–X2 | [ ] |

---

## Y. KONKRETNE ROZWIĄZANIA (po etapie badawczym — 2026-10-20)

Cel: **realne implementacje wniosków** (SECURITY_POSITION / P5 / P0),
zamiast stand-inów. Nie deklarować „próg gotowy".

| ID | Zadanie | Kryterium | Status |
|---|---|---|---|
| Y1 | **Prawdziwy SHAKE256 na udziałach** (Keccak-f χ = mul_shamir_reshare) | bit-exact vs `shake256_clear`; 38400 muls/perm; `spike/src/shake.rs` | [x] **WERYFIKATOR PASS** — 186/186, `Y1_SHAKE_ON_SHARES.md` |
| Y2 | Multi-block absorb/squeeze (msg ≥ rate) | 136 B / 137 B / 2×136+50 vs clear; koszt 2×38400 na rate | [x] 190/190 |
| Y3 | `derive_key_material_shake` (real SHAKE, domena KEY) | oracle == clear; ≠ G_frag stand-in | [x] 194/194 |
| Y4 | Klein 73-bit: wagi Q73 + TV vs **analityczna** Gaussa | `exp_neg_q73`, `gauss_weight_q73`, TV < 0.12 | [x] 201/201 |
| Y5 | ULTRA-WERYFIKATOR Y1–Y4 + RECENZENT (crypto) | PASS / ACCEPT | [x] **częściowo** — `Y5_VERIFY_Y_PACKAGE.md` (okno główne; ultra anulowany F-Y5-1; Y1–Y3 mają osoby PASS) |
| Y6 | **SPDZ-MAC z ukrytym δ** (SECURITY_POSITION pkt 2) | open bez reconstruct δ; tamper value/mac/δ → MacFail | [x] 207/207 + guard `k` (flake open_mac_rejects_short domknięty) |
| Y7 | `open_g_frag_byte_mac_hidden` — G_frag + ukryte δ | open OK + tamper mac → MacFail | [x] 208/208 |
| Y8 | Ukryte δ w `iso` (procesy) | `mac-demo-hid`; brak `delta.txt`; forged exit 3 | [x] 209/209 |
| Y9 | Pipeline `iso` na ukrytym δ | `PIPE_MAC_HID_OK`; tamper is_err | [x] 209/209 |
| Y10 | **DKG δ bez dealera** (`dkg_delta_shares`) | δ=Σr_i; API bez pełnego δ; MAC open działa | [x] 211/211 |
| Y11 | Klein-lite Q73 na udziałach (`sample_gauss_q73_native`) | wagi Y4 + accept cmp; 215/215 | [x] |
| Y12 | Mutacje SHAKE (świadome zepsucie = FAIL) | flip bitu / zła domena ≠ FIPS | [x] 217/217 |
| Y13 | Mapa modelu złośliwego (audyt) | `Y13_MALICIOUS_MAP.md` — co łapiemy / luki | [x] notka |

---

## S. DUŻE TODO — tor G(seed*) + sign (po Y, pokolei)

| ID | Zadanie | Kryterium | Status |
|---|---|---|---|
| S1 | **G(seed*) circuit** L1 SHAKE + L3 NTT | `g_seed_circuit_shares`; L1 == oracle; ≠ G_frag | [x] 224/224 |
| S2 | Nonce przez prawdziwy SHAKE (R2) | `derive_nonce_shake` == oracle; zależy od msg | [x] 224/224 |
| S3 | **Tor sign v2** (real SHAKE derive+nonce+sygnet) | `sign_tor_v2`; ≠ stand-in chain | [x] 224/224 |
| S4 | Piny oracle derive/nonce (FNV stałe) | `0xdf4a4067cba1c082` / `0x53039e70fc54f445` | [x] 225/225 |
| S5 | ULTRA-WERYFIKATOR S1–S4 | PASS | [x] CHANGES→PASS: twarde FNV piny S4 (`VECTOR_PINS.md`); S1–S3, domena, NTT, zakres = PASS |

---

## U. DUŻE TODO — kilka dużych zadań na długą pracę (2026-10-21)

Każde to **wielodniowy** kawałek (nie spike na godzinę). Kolejność
wykonania: U1 → U2 → U3 → U4 → U5. Rozbiór na partie w trakcie.

```
ID: U1
Cel: pełny Klein MPC — bit-by-bit Bernoulli 73-bit na udziałach
     (zastąpienie Q16/Q73 stand-inu prawdziwym algorytmem Kleina)
Zakres IN: spike/src/ (nowy klein.rs lub select.rs+rejection.rs), testy
Zakres OUT: Obrazy/, [N], R1 formalny, F04/F05 solver
Kryteria: (a) Bernoulli(1/2^k) i Bernoulli(exp(-z)) na udziałach;
          (b) konstrukcja próbki bit-po-bicie jak Klein; (c) TV vs analityka;
          (d) accept bez otwierania bitów; (e) piny + mutacje
Dowody: testy z liczbami, koszt (Beaver/bit), porównanie vs Q73
Zależności: Y4 (Q73), I2 (accept-bit)
Status: [x] **ULTRA PASS** (247/247) — A–D + CHANGES (U1-RF-1..3, F-22)
  - `klein.rs`: Bernoulli (half, pow2, exp), `prob_right_q32`,
    `klein_step`/`klein_sample_cond_bits`, `accept_window_q73_no_open_u`,
    TV vs analityka, piny, mutacje
  - **Granica:** NIE pełny Klein 73-bit z 2026/1300 ani sampler FT
```

```
ID: U2
Cel: F04/F05 arytmetyka na udziałach — montymul, NTT regiony 2–4,
     relacja fG−gF=18433 w torze (M4 solver)
Zakres IN: mul.rs (montymul, NTT first/mid/triple), nowy solver.rs
Zakres OUT: Obrazy/, pełny keygen, pin R1 packet
Kryteria: (a) montymul na udziałach + wektory vs jawny;
          (b) NTT first+mid+triple zliczone (M4 SOURCE counts);
          (c) div_const / mq_div_18433; (d) brak reconstruct f,g,F,G
Dowody: liczniki muls/region, mapy zgodne z M4, mutacje
Zależności: P7–P9 (NTT stub), M4, R1 ans 3 (model kosztu OK)
Status: [x] **ULTRA PASS** (254/254) A–D + CHANGES (U2-RF-1, F-23)
  - montymul=real reshare; NTT 768/765/512 (SOURCE vs ESTIMATE jawnie);
  - ntru fG−gF bez reconstruct f,g,F,G; mutacje
  - **Granica:** model GF(256), NIE montymul 12289 / F04 z R1
  - **U2-A** `montymul_shares` (mul_shamir_reshare, model M4)
  - **U2-B** `ntt_first_pass_shares` (768) + `ntt_triple_pass_shares` (512) — SOURCE counts
  - **U2-C** `ntru_fg_gf_check_shares` (fG−gF=18433&0xFF, bez reconstruct f,g,F,G)
  - **U2-D** `ntt_full_chain_shares` (768+mid+512), koszt montymul=reshare,
    mutacje (count pin, zła stała NTRU) — **254/254**
    = 230 lib + 14 iso + 10 spike; `s8` flake = F-18 retained
  - **ULTRA U2:** CHANGES → poprawki retained mid-pass (U2-RF-1:
    8 rund = SOURCE; **765 butterfly** vs ESTIMATE 6144), nazwa testu,
    rozbicie counta
  - **Status:** [x] **ULTRA PASS** po CHANGES (F-23)
```

```
ID: U3
Cel: harness formalnego G(seed*) — spięcie z KeygenByteGame134.evaluate
     (R1), piny packet 2881/sk≤10370, ENTRY_PINS
Zakres IN: testy/piny, ewent. adapter do źródeł KEYGEN_* (read-only)
Zakres OUT: zmiana R1, produkcja kluczy
Kryteria: (a) kontrakt evaluate zmapowany na wejścia/wyjścia spiku;
          (b) piny syntetyczne w VECTOR_PINS; (c) stop-and-report
          przy rozjeździe z R1 (M8)
Dowody: mapa R5 + piny; evaluate OPEN = jawna granica
Zależności: U1, U2; odpowiedzi R1 (ans 4–6)
Status: [x] **harness** (257/257) — `EntryPin` SHA-256, `make_entry_pin_seed`
  / `make_entry_pin_pk_placeholder` (2881, witness pusty),
  `packet_len_contract_ok`, `evaluate_gseed_stub` = **None** (OPEN, fail-closed)
  **Ciągle zablokowane na R1:** prawdziwy packet + witness evaluate
```

```
ID: U4
Cel: model złośliwy — authenticated triples + MAC na mnożeniach
     (nie tylko open-path)
Zakres IN: mul.rs / lib.rs (auth triple, MAC na mul/cmp/select)
Zakres OUT: UC-dowód, pełny SPDZ
Kryteria: (a) triple z MAC; (b) mul z kontrolą MAC;
          (c) matrix fałszerstw; (d) mapa Y13 zaktualizowana
Dowody: testy tamper na każdej linii
Zależności: Y6–Y10, U1
Status: [x] **262/262** — `AuthTriple`, `generate_auth_triple_shares`,
  `verify_auth_triple`, `mul_auth_check_open`; tamper c/input → MacFail;
  z DKG δ; Y13 zaktualizowana. **NIE** pełne malicious-secure (brak UC)
```

```
ID: U5
Cel: paper / formalizacja — rozwinięcie O3+W4 na 2–3 strony,
     domknięcie TT-55 (G(seed*) w kernelu — stop-and-report)
Zakres IN: W4_PAPER.md / nowy paper, TT55
Zakres OUT: publikacja, push
Kryteria: sekcje z dowodami z TESTS/I1/I3/Y/S; zakres twierdzeń szczery
Dowody: szkic dokumentu
Zależności: U1–U3 wyniki
Status: [x] **szkic U5** — `W4_PAPER.md` (2 strony: architektura B,
  bezpieczeństwo JEST/NIE, koszt, wnioski). Nie publikacja.
```

**Zasada:** każde U to partia z weryfikatorem (ultra) + retained.
Nie deklarować „próg FT gotowy".

---

## R1 — odpowiedzi wpięte (2026-10-21, `spike/K1_R1_ANSWERS.md`)

| Fakt | Status | Wpięte w spike |
|---|---|---|
| G(seed*) = SHAKE/XOF + algebra (regiony 2–4) | POTWIERDZONE | kierunek Y1/S1 poprawny |
| pk **2881 B**; sk **7681–10369 B** (korekta!) | POTWIERDZONE | `packet_len_contract_ok` + test |
| Region 2: 768 motyli + 8 rund + 512 trójek | POTWIERDZONE | = U2 piny M4 |
| Failure = attemptLimit\|encoding, fail-closed | POTWIERDZONE | abort jak M6 |
| **seed9 fixture** 32 B + SHA-256 | POTWIERDZONE | `SEED9_HEX`/`SEED9_SHA256`/`entry_pin_seed9_r1` |
| Atom **2⁻²⁵⁶** wiążący (nie certified_set_lower) | POTWIERDZONE | M7 |
| Ownership rozjazdu pinów = **właściciel** | POTWIERDZONE | M8 |
| packet / Accepted / package_of_witness / G(seed*) | **OPEN** (regiony 3–5) | evaluate stub = None |
| Piny FNV spike ≠ SHA-256 R1 | zasada | `VECTOR_PINS.md` |

**Suite: 267/267** (243 lib + 14 iso + 10 spike). Retained: sha2 vs sha3
(piny R1 = SHA-256, nie SHA3).

---

## V1 — działający silnik FT1536 (2026-10-21)

Właściciel: **FT1536 działa (C); Lean4 formalizacja nie blokuje.**
`ft1536-sys` wpięty jako oracle (`tests_v1_ft1536_engine`):

| Test | Dowód |
|---|---|
| `v1_engine_sign_verify_roundtrip` | realny keygen+sign+verify; zły msg = odmowa |
| `v1_pk_sk_sizes_vs_r1_contract` | **pk=2881**, sk w **7681–10369** (zgadza się z R1) |
| `v1_sig_has_40b_nonce` | nonce 40 B = NONCE_LEN |

**Zmiana kierunku:** nie czekamy na R1 `evaluate` — silnik C jest
źródłem prawdy dla podpisów. Tor progowy (spike) dąży do bajtów
podpisu, które **ten** `verify` przyjmie.

---

## V2 — PRAWDZIWY SYSTEM (2026-10-21) — 271/271

`ft1536-sys::generate_from_seed` (deterministyczny C, `falcon_keygen_set_seed`)
+ `sign_ceremony_v2_from_matrix`:

| Element | Wynik |
|---|---|
| Próg seeda k-z-n → reconstruct w ceremonii | OK |
| `generate_from_seed` → realny keygen | deterministyczny (ten sam pk) |
| `sign` → **realne bajty** | weryfikowane `Ft1536Signature::verify` |
| zły msg / brak quorum | fail-closed |
| pk 2881 B | jak kontrakt R1 |

**Granica:** próg na poziomie **seeda** (klucz powstaje w procesie
ceremonii). Pełne MPC-sign (klucz nigdy w całości) = F04/F05 — otwarte.

```
ID: U6
Cel: weryfikacja pakietu U1–U5
Kryteria: protokół 5-punktowy + RECENZENT zakres twierdzeń
Status: [x] **ULTRA PASS** — `general-26` (ponowienie po F-U6-1
  platform cancel `general-25`; właściciel nie anulował). 262/262,
  0 warningów; paper/evaluate/U4 zakres PASS.
```

**Retained Y1:** RF-1 Lagrange λ vs zbiór punktów; RF-2 bit↔bajt nie z
udziałów bajtu; RF-3 `reconstruct` bez k. Szczegóły `spike/Y1_SHAKE_ON_SHARES.md`.

---

## V3 — system z FTKEY / YubiKey (2026-10-21)

Właściciel: seed 32 B w **FIDO2 hmac-secret na YubiKeyu** (FTKEY ADR-004).
Mapa stapki: `spike/V3_SYSTEM_STACK.md`.

YubiKey (PIN+touch) → seed 32 B → FTKEY `keygen_from_seed_32`
  **oraz** próg Shamir → V2 `generate_from_seed` → realny podpis FT1536.

Ten sam `falcon_keygen_set_seed(replace=1)` = ten sam pk z tego samego seeda.

---

## MPS — pełny MPC sign FT1536 (2026-10-21) — 275/275

**FT1536 = autorski wariant właściciela** — secret **ternarny**,
**q = 18433** (NIE 12289), N=1536, `X^1536-X^768+1`.
Mapa: `spike/FT1536_IDENTITY.md`.

| ID | Zadanie | Status |
|---|---|---|
| MPS1 | Shamir + mul re-deal nad **Z_18433** (`mpc_sign.rs`) | [x] 275/275 |
| MPS2 | Wielomiany (f,g,F,G) na udziałach mod q + NTT q-ary | [ ] |
| MPS3 | Hash-to-point + sampler krótkich s1,s2 (trapdoor) | [ ] |
| MPS4 | Otwarcie wyłącznie **s** + encoding + verify silnikiem | [ ] |

**Zasada:** klucz (f,g,F,G / seed) **nigdy w całości**; otwieramy tylko
jawny podpis `s`. GF(256) zostaje dla SHAKE/MAC; **q-arytmetyka** dla sign.

**MPS1–MPS3: [x] 283/283** (259 lib + 14 iso + 10 spike).
- MPS2: QPolyShares, mul ring clear `X^N-X^{N/2}+1`, NTT butterfly mod q
- MPS3: `hash_to_point` (rejection w<lim=55299, n=1536 — jak C),
  równanie `s1 + s2·h ≡ t`, `compute_s1_from_s2_shares`
- **C:** sign zwraca **tylko s2** (verify odtwarza s1) — w MPC otwieramy s2
**Zostało MPS4:** trapdoor+ffSampling na udziałach → s2 → encoding → verify silnikiem

**MPS4-A: [x] 287/287** — trapdoor `(s1,s2)=(t-z1·g-z2·G, z1·f+z2·F)`
na udziałach (f,g,F,G **nie otwierane**), równanie s1+s2·h≡t, header 0xAA,
encoding model s2. **Zostało MPS4-B:** Golomb-Rice `falcon_encode_small`
+ ffSampling (krótkie z1,z2) + verify silnikiem.

**MPS4-B: [x] 290/290** — `compress_static_18433` (j=8, bit-exact jak C)
+ `uncompress_static` roundtrip + `encode_sig_static` (header 0xAA).
**Zostało MPS4-C:** ffSampling (krótkie z1,z2) → s2 short → verify silnikiem.

**MPS4-C: [x] 292/292** — `sample_z_ternary`, `trapdoor_sign_reject(_shares)`
(rejection cap 200, fail-closed), norma s1,s2. Trivial trapdoor accept w 1.
**Zostało:** prawdziwy ffSampling (Gaussian lattice) dla NTRU f,g,F,G +
`FALCON_FT1536_NORM_BOUND2` + verify silnikiem na encodingu — MPS4-D.

**MPS4-D ZŁOTO: [x] 294/294**
- `decode_sk_ft1536` — f,g,F,G z realnego sk silnika (ternary, header 0xAA)
- **Codec bit-exact vs silnik:** realny podpis → `uncompress_static` →
  `encode_sig_static` → **engine verify = OK**
- `FALCON_FT1536_NORM_BOUND2 = 2093922385` wpięty
**Zostało MPS4-E:** ffSampling na udziałach (krótkie z dla prawdziwego
NTRU f,g,F,G) → s2 short → ten sam encoding → verify.

**MPS4-E ZŁOTO OPERACYJNE: [x] 272 lib + 14 iso (serial) = 286+**
- `sign_ceremony_sk_shares`: udziały **sk** → reconstruct w ceremonii →
  engine sign → **verify silnikiem OK**
- `measure_z_reject_rate` na prawdziwym trapdoorze — stopa ternary-z
  (ffSampling gap **jawny**; hits mierzone, nie zakładane)
- `Ft1536KeyPair::from_secret_key` w ft1536-sys

**Otwarte MPS4-F (ffSampling):** FFT3 + LDL tree → krótkie z dla
prawdziwego NTRU — wtedy s2 liczone **w całości na udziałach** bez
reconstruct sk.

**MPS4-F: [x] pomiar 273+14+10** — Babai diagonalny + poly_mul_ring_f64.
**Retained MPS4-F1:** diagonal Babai **nie** obniża normy na prawdziwym NTRU
(n=8.7e10 vs 4.3e10 dla z=0) — brak struktury pierścienia. Wierny
**ffSampling (FFT3+LDL tree, C:1783) = MPS4-F2** — ostatnia kreska do
s2 w całości na udziałach. Do tego czasu **ZŁOTO operacyjne** = ceremonia
sk-shares (verify OK).

**MPS4-F2: [x] pomiar 278+14+10** — Euclid f^{-1}, sampler z=round(t·f/q),
równanie `s2·h−s1≡t` **dowiedzione i testowane**. Retained F2-1: norma
nie spada vs z=0 (8.8e10 vs 4.4e10) — bez FFT3+LDL tree (C:1783).
**Złoto operacyjne trzyma:** ceremonia sk-shares → verify OK; codec bit-exact.

## MPS — podsumowanie „do końca"

| Element | Status |
|---|---|
| Shamir Z_18433, trapdoor, hash_to_point | [x] |
| Codec s2 bit-exact vs silnik | [x] **ZŁOTO** |
| Ceremonia sk-shares → realny podpis | [x] **ZŁOTO** |
| Równanie verify (s2·h−s1=t) | [x] |
| f^{-1} w R_q (Euclid) | [x] |
| **s2 w całości na udziałach** (ffSampling FFT3) | [ ] **OTWARTE** — port C:1783 |

---

## REGUŁA WŁAŚCICIELA (2026-10-21) — przy KAŻDYM kolejnym zadaniu

W promptach dla agentów i w oknie głównym **obowiązkowo ft-skills**,
w szczególności **`/ft-historia`** (wczytać historię toru z akt,
zaktualizować po meldunku):

- `/ft-tryb-pracy` (role, raporty, retained)
- **`/ft-historia`** (historia z dowodów — commity, meldunki, TABLICA_TOROW)
- `/ft-prawda-przed-tempem`, `/ft-window-discipline`
- `/ft-secrets-hygiene`, `/ft-suplementy-i-pulapki`
- `/ft-sage-lean` jeśli Lean/Sage (tu: Extra/c / KEYGEN_* read-only)

Po zadaniu: TESTS, REPORT, PACKAGE_INDEX, Y13, **historia**.
