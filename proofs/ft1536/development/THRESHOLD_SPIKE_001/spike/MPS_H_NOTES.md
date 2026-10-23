# MPS4-H — rounding w MPC + splot na udziałach (wariant B zamknięcia G-1)

**Status:** ZŁOTO osiągnięte (semi-honest spike, pełne N=1536).
Nie kasować retained F2-1, G-1, G-2, G-3 ani `MPS_F2_NOTES.md` / `MPS_G_NOTES.md`.

Cel ZŁOTA spełniony: `z = (z0, z1)` powstaje z udziałów f,F **bez otwierania**
f, F, t·f, t·F ani z; potem (s1,s2) na udziałach → open s1,s2 →
`Ft1536Signature::verify == true`. Po setupie udziałów (H1) nikt nie widzi
f ani F w clear w torze sign.

Konwencja bez zmian vs F2/G:
- `z1 = round(t·f/q)`, `z0 = round(−t·F/q)` w Z[X]/(φ) — `round_half_away`
  bit-exact vs `round_div_q_scalar` (f64::round, q nieparzyste)
- `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F` (potem mod q)
- `verify_sign_equation`, `encode_sig_static(s2)` + nonce → engine verify

---

## Co wdrożono (API) — `src/ishare.rs`

### H1 — Shamir na dużym module P = 2^61−1 (całkowite i16)

- `IShare`, `IPolyShares`, `ishare_poly(&[i16])`, `ireconstruct_poly[_i64]`
- Udziały f,g,F,G trzymają **całkowite i16**, nie R_q — rounding
  `round(t·F/q)` wymaga całkowitego F.
- `decode_sk_ft1536_i16` — dekod sk do prawdziwych i16 (bez redukcji mod q).

### H2 — jawne t × udział (liniowość, 0 reshare-mul)

- `mul_ring_public_t_shares(t, shares)` — per strona lokalnie splot w Z[X]/(φ)
  **nad Z_P** (udziały to elementy Z_P). α·share = share(α·s).
- Poprawność: reconstruct(tf) == t·f (integer ring).

### H3 — rounding w MPC (rdzeń)

- `round_div_q_shares(rng, x, xs, k, bits)` / `round_div_q_scalar_shares`
- Protokół (semi-honest):
  1. X = x + 2^{B−1} (jawne OFF)
  2. bit-dekompozycja X: losowa maska r (bity w GF(256) **i** Z_P),
     open `d = X − r` (**maska**, nie x), X_bits = r + d (dodawarka na bitach)
  3. sign = ¬X_bits[B−1]; |x| = (X_low ⊕ sign) + sign
  4. y = |x| + ⌊q/2⌋; dzielenie przywracające y/q → |z| bity
  5. |z| bity → Z_P (pary masek GF→Z_P); z = (1−2·sign)·|z| (1 reshare-mul)
- **Zakaz spełniony:** nie otwiera się f, F, t·f, t·F, z. Otwarcia: maski.
- Bity jako udziały GF(256): XOR free, AND = reshare-mul (wzór `shake.rs::and_bits`).
  Konwersja bitu 0/1 GF(256)→Z_P przez parę masek (open `b ⊕ m`).

### H4 — sign z tajnym z

- `i_poly_mul_ring_shares` — splot udział×udział w Z_P, O(N²) reshare-muls
  (G-3 przewiduje). `mps4h_sign_shares` → open **wyłącznie** s1,s2 (i64).
- `TrapdoorShares` z G (Z_q) **nie jest używany** w torze H — nowy
  `ITrapdoorShares` (Z_P, i16). Stary `TrapdoorShares` zostaje dla G.

---

## H-1 — koszt bit-decomp / pełne N (liczby zmierzone, debug, n=3, k=2)

Pomiar: seed 0x42, msg `gold-ff`, nonce 0, bits_tf=25, bits_tf_big=32.

| etap | reshare-muls / AND | opens | czas (debug) |
|---|---|---|---|
| H3 round full N (tf, bits=25) | 2 073 600 bit-AND | 43 008 | ~3 s |
| H3 round full N (tF, bits=32) | ~2 632 704 bit-AND | ~53 760 | ~4 s |
| H3 oba (z0+z1) | **4 706 304** bit-AND | **96 768** | ~10 s |
| H4 splot 4×N² (z·f,z·F,z·g,z·G) | **9 437 184** Z_P reshare | 0 | ~19 s |
| **MPS4-H gold razem** | 9 437 184 + 4 706 304 | 96 768 | **~29–30 s** |

- Koszt bit-AND skaluje się ~liniowo z `bits` (szerokość y i liczba kroków
  dzielenia). bits=25: 1350 AND/coeff; bits=32: ~1717 AND/coeff.
- Pełne N **mieści się** w budżecie debug < 2 min/test — **nie było potrzeby
  hybridu H-1**. Wariant B (rounding w MPC na pełnym N) jest pełnym dowodem.
- `bits` musi spełniać |x| < 2^{bits−1}. Dla realnych kluczy FT1536:
  |t·f| ≤ N·(q/2)·1 ≈ 1.4e7 (bits=25 wystarcza),
  |t·F| ≤ N·(q/2)·max|F| ≈ 0.9e9 przy max|F|≈65 (bits=32 wystarcza).
  Worst-case i16 max|F|=32767 ⇒ |t·F| ≤ 4.6e11 ⇒ bits=40.

## H-2 — z tajne ⇒ O(N²) reshare-muls na splot s (G-3)

| ścieżka | mnożenie | reshare-muls |
|---|---|---|
| z jawne × udział (G) | liniowość Shamir | **0** |
| **z tajne × udział (H)** | `i_poly_mul_ring_shares` per para | **O(N²)** = 2 359 296 na splot |
| 4 sploty (z0·f, z1·F, z0·g, z1·G) | H4 | **9 437 184** |
| jawne t × udział (H2) | liniowość | 0 |

G-3 potwierdzone empirycznie: 9 437 184 = 4·1536².

## H-3 — nadal semi-honest; brak VSS/malicious; to NIE threshold signing (G-2)

- Semi-honest spike. Brak: aktywnego bezpieczeństwa, VSS/Pedersen w tej
  ścieżce, odporności na malicious party, redukcji EUF-CMA → MT-ISIS.
- Otwieramy s1,s2 w całości (jak F2/G) — próg jest na **kluczu**
  (f,g,F,G nie leżą w jednym clear po setupie), nie na wyniku.
- Nie ogłaszać „threshold signing" ani „MPC sign secure". **G-2 zostaje.**
- Maska bitowa H3 jest semi-honest (dealer masek); brak weryfikacji
  spójności udziałów w torze round.

## H-4 — scope: co jest pełnym dowodem, co pomiarem

- **Pełny dowód (gold, pełne N):** `mps4h_ffsampling_shares_gold` —
  udziały i16 f,g,F,G → z z H3 (brak clear f,F) → s1,s2 → open →
  n = **103747771** < 2093922385 (pin F2, z≡clear) →
  `verify_sign_equation` → `Ft1536Signature::verify == true`.
- **Pełny dowód:** `mps4h_z_matches_clear_ffsampling` — z z MPC ≡
  `sample_z_ffsampling` **bit-exact** (ten sam t, seed 0x42, msg `gold-ff`).
- **Pełny dowód:** `mps4h_z_shares_no_clear_open` — konstrukcja toru
  H2+H3 nie otwiera f, F, t·f, t·F, z; otwarcia wyłącznie masek.
- **Pełny dowód:** `mps4h_mutation_forged_share` — sfałszowany udział f
  (strona 0, +1) ⇒ engine verify **false** (fail-closed).
- **Pełny dowód:** `mps4h_round_div_q_matches_clear` / `_scalar_matches_clear`
  — round_div_q_shares ≡ round_half_away ≡ f64::round (F2).
- **Pomiar (nie twierdzenie security):** koszty H-1; max|F| na kluczu.

---

## G-1 — zamknięte przez H (rounding w MPC) — SUPLEMENT, nie kasowanie

Historyczny wpis G-1 w `MPS_G_NOTES.md` pozostaje **zachowany** (patrz niżej).
Status uzupełniony:

- **Było (G-1):** z (poziom A) potrzebowało f,F w clear (reconstruct w ceremonii).
- **Jest (H, wariant B):** z powstaje z udziałów f,F przez H2 (splot t×udział)
  + H3 (rounding w MPC na bitach). **Pełne N, brak clear f,F w torze.**
- Warunek zamknięcia spełniony: gold na pełnym N + brak clear f,F
  (`mps4h_ffsampling_shares_gold`, `mps4h_z_shares_no_clear_open`).
- **G-1 nie jest kasowane z historii** — zamknięte merytorycznie, rekord
  retained zgodnie z zasadą suplementów.

## G-2 — RETAINED (NIE KASOWAĆ) — patrz wyżej H-3. Nie threshold signing.

## G-3 — koszt potwierdzony (H-2). z tajne ⇒ O(N²) reshare-muls.

---

## Pin (seed 0x42, nonce 0, msg `gold-ff`)

| wartość | oczekiwanie | status |
|---|---|---|
| z | jak F2 `sample_z_ffsampling` | bit-exact (test) |
| n | **103747771** (gdy z≡clear) | pin w gold |
| bound | 2093922385 | n < bound |
| engine verify | true | gold |
| max\|F\| i16 (seed 0x42) | 59 ≪ q/2=9216 | `tests/measure_fg.rs` |
| max\|G\| i16 (seed 0x42) | 56 | jw. |
| max\|F\| i16 (seed 0x77) | 54 | jw. |
| max\|G\| i16 (seed 0x77) | 65 | jw. |

Zbieżność max|F| ≪ q/2 ⇒ i16 F ≡ centered mod q ⇒ z z H3 ≡ z z F2 na tych
kluczach. Gdyby klucz miał max|F| ≥ q/2, z mogłoby się różnić od F2
(F2 używa F mod q); test `mps4h_z_matches_clear` ma asercję max|F| < q/2.

## Suite

- `cargo test` → **294 lib + 14 isolation + 1 measure_fg + 10 spike = 319
  passed, 0 failed**. 0 warningów build/test.
- Retained nie skasowane: F2-1, `mps4f_babai_norm_measured`,
  `mps4f2_ff_lite_lowers_norm`, `MPS_F2_NOTES.md`, G-1, G-2, G-3,
  `mps4g_*` (wszystkie 4), `MPS_G_NOTES.md`.
