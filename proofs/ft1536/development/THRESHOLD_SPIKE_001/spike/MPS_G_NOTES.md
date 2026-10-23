# MPS4-G — ffsampling sign NA UDZIAŁACH (klucz nie w całości)

**Status:** ZŁOTO osiągnięte (semi-honest spike). Nie kasować G-1, G-2, G-3.
F2-1 i `MPS_F2_NOTES.md` pozostają nietknięte.

Konwencja (bez zmian vs F2):
- `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F` (potem mod q)
- `verify_sign_equation`: `s2·h − s1 == t`
- `encode_sig_static(s2)` + nonce → `Ft1536Signature::verify`

Pola w kodzie: `f_big = F`, `g_big = G` (jak `decode_sk_ft1536`: f,g,F,G).

---

## Co wdrożono (API)

- `q_poly_mul_public_i64_shares(z, shares)` — jawny z (i64) × udział poly
  w R_q. Liniowość Shamir: α·share(s) = share(α·s) dla α jawne.
- `trapdoor_sign_ffsampling_shares(rng, td, t, z0, z1, xs, k)` —
  s1,s2 na udziałach; jawne krótkie z=(z0,z1) i jawne t; klucz tylko
  jako `TrapdoorShares`. Otwieranie poza funkcją (`q_reconstruct_poly`).
- `trapdoor_sign_ffsampling_share_ceremony(rng, td, t, xs, k)` —
  wariant A ceremonii: reconstruct f,F w buforze zeroize → z →
  drop/zeroize → sign wyłącznie na udziałach → open → (s1,s2,n).

## G-1 — RETAINED (NIE KASOWAĆ): z (poziom A) nadal potrzebuje f,F w clear

**SUPLEMENT (MPS4-H, wariant B):** zamknięte merytorycznie — z powstaje
z udziałów f,F przez rounding w MPC (H2+H3) na pełnym N, **bez** clear f,F.
Rekord historyczny poniżej pozostaje. Dowody: `MPS_H_NOTES.md`,
`mps4h_ffsampling_shares_gold`, `mps4h_z_shares_no_clear_open`.
G-2 i G-3 **nietknięte** (G-2 nadal retained — to nie threshold signing).

- **Objaw:** `sample_z_ffsampling` liczy `z1 = round(t·f/q)`,
  `z0 = round(−t·F/q)` w Z[X]/(φ) — wymaga f i F jako jawnych wielomianów.
- **W ceremonii (wariant A):** f,F są rekonstruowane z udziałów wyłącznie
  do z, w buforze zeroize; po z bufor jest kasowany. Dalej sign jest
  **wyłącznie** na udziałach — w ścieżce sign po z żaden kod nie ma
  f,g,F,G w jednym `TrapdoorClear`.
- **To NIE jest pełny próg:** strona rekonstruująca f,F do z widzi te dwa
  wielomiany w clear. Droga do pełnego progu:
  1. **Klein / U1:** z jako short vector z trapdoora na udziałach
     (odrzucanie na udziałach — koszt komunikacji),
  2. **mul na udziałach + rounding w MPC:** iloczyny t·f i t·F na udziałach
     (z·jawne = 0 reshare; t·udział = reshare-mul per coeff splotu),
     potem bezpieczne round(·/q) w MPC (porównanie/rounding protocol),
  3. inny sampler (Gaussian) w MPC — poziom security, nie wymagany do ZŁOTA.
- **Testy retained:** `mps4g_ffsampling_shares_gold` (z jeszcze z clear,
  jawnie udokumentowane w testcie), `mps4g_shares_match_clear` (ceremonia
  ≡ clear). Nie kasować.

## G-2 — RETAINED (NIE KASOWAĆ): to NIE jest threshold signing / security proof

- Semi-honest spike. Brak: aktywnego bezpieczeństwa, weryfikacji udziałów
  (VSS/Pedersen w tej ścieżce), bezpiecznego otwierania z wyciekiem
  wzorca, odporności na malicious party, dowodu redukcji EUF-CMA → MT-ISIS.
- Udziały Shamir w tym kroku są **liniowe i jawne w rekonstrukcji** —
  otwieramy s1,s2 w całości (jak w F2). Próg jest na **kluczu**
  (f,g,F,G nie leżą w jednym clear w sign path po z), nie na wyniku.
- Nie ogłaszać „threshold signing" ani „MPC sign secure".

## G-3 — koszt: z jawne unika reshare (0 reshare-muls)

| ścieżka | mnożenie | reshare-muls |
|---|---|---|
| z jawne × udział (G, ta) | kombinacja liniowa Shamir per coeff splotu | **0** |
| udział × udział (gdyby z było tajne) | `q_mul_shamir_reshare` per coeff | O(N²) = ~2.4M |
| jawne z, jawne t, otwarcie | local O(n·N²) mnożeń w R_q + Lagrange | 0 |

- `trapdoor_sign_ffsampling_shares`: 4× `q_poly_mul_public_i64_shares`
  (z0·f, z1·F, z0·g, z1·G) = 4·n mnożeń pierścieniowych jawnych
  (n = liczba stron; N=1536). Plus odejmowanie t per udział (O(n·N)).
- t jawne: minus t na każdym udziale (stały wielomian Shamir) —
  reconstruct daje dokładnie −t; też **bez** reshare.
- Gdyby z było tajne (próg pełny, G-1): splot t·f / t·F na udziałach
  = O(N²) reshare-muls na każdy z 2 iloczynów, plus rounding w MPC.

---

## Dowody (ZŁOTO — testy zielone)

- `mps4g_shares_match_clear` — s1,s2 otwarte z udziałów == clear
  (`trapdoor_sign_ffsampling` i `trapdoor_sign_clear`); ceremonia ≡ clear.
- `mps4g_ffsampling_shares_gold` — n < 2093922385, `verify_sign_equation`,
  `Ft1536Signature::verify == true` (seed 0x42, nonce 0).
- `mps4g_ceremony_shares_engine_verify` — sk-bajty na udziałach →
  udziały f,g,F,G → ceremonia A → open → engine verify == true
  (jak mps4e, ale nasz ffsampling sign, nie engine-sign).
- `mps4g_mutation_forged_share` — sfałszowany udział f[0] strony 0 (+1):
  reconstruct ≠ oracle, engine verify **false** (fail-closed).

## Suite

Retained nie skasowane: F2-1, `mps4f_babai_norm_measured`,
`mps4f2_ff_lite_lowers_norm`, `MPS_F2_NOTES.md`, G-1, G-2, G-3.
