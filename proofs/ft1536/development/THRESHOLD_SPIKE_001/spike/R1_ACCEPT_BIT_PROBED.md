# R1 — accept-bit z udziałów u bez reconstruct(u)

**Status: zaimplementowane (gadget probed).** Tor: `src/cmp.rs`.

## Co

`accept_bit_from_u_shares_probed(rng, xs, k, u_shares, w)` → udziały bitu
`a = 1{u < w}` (porównanie **całkowite** bajtowe; w publiczne).

Nie jest to `accept_bit_from_u_opened` (select.rs) — tam jawny „moment"
rekonstruuje u. Tu **rekonstrukcji u nie ma**.

## Jak (uczciwie, bez bit-split)

GF(256) ≠ Z/256; rozbicie u na bity na udziałach wymaga bit-decomp
(brak w spike). Zamiast tego:

1. Predykat `j ↦ 1{j<w}` (j = wartość bajtowa) to funkcja GF(256)→GF(256);
   istnieje jedyny wielomian `P_w` stopnia ≤255 z `P_w(j)=1{j<w}` dla każdego
   j∈{0..255}. Rząd całkowity jest wtopiony w **jawne współczynniki** z
   publicznego w — nie „compare w GF".
2. `P_w(X) = Σ_{j<w} Π_{t≠j}(X-t)`; `Q_j = (X^{256}+X)/(X+j)` (syntetyczne
   dzielenie). `Π_{t≠j}(j-t)=1` (iloczyn niezerowych = 1 w char. 2).
3. Ewaluacja `P_w(u)` na udziałach: Horner + Beaver (`mul_vec`).
   Otwarcia: **tylko maski d,e**. Żadnego `reconstruct(u)`.
4. k+1 consistency: `verify_consistency` (eval w x≠0, brak f(0)).
   Fałszywy udział → `InconsistentShare` (fail-closed).

`w>255` → `WrongThreshold` (w=256 → Err). `w=0` → zera (pusty Σ).

## Testy (5 nowych; suite 102+9+10 = 123 pass)

- `r1_step_poly_matches_int_order` — P_w vs 1{j<w} dla **każdego** j, 8 wartości w
- `r1_accept_boundaries` — u==w→0, u==w-1→1
- `r1_accept_zero_and_max` — u=0→1, u=255→0 (oba w)
- `r1_w_256_err_and_guards` — w=256→Err, zły n→PartyCountMismatch
- `r1_forged_u_share_detected` — mutacja udziału u → InconsistentShare

## Granice (nie wynika stąd)

- Bezpieczeństwo progu FT1536 / malicious / DKG — poza zakresem.
- Beaver: dealerskie trójki (model testowy); otwarcia d,e ujawniają maski.
- Horner = 255 muls (koszt); nie jest to compare obwodowo optymalny.
- Bit-split u na udziałach **nie jest** tu zrobiony i nie jest udawany.

## Grep (brak reconstruct(u) w gadżecie)

`grep -n reconstruct src/cmp.rs`: tylko `reconstruct_vals` na maskach d,e
(mul_vec, Beaver) oraz `crate::reconstruct` w teście na **wyjściowym bicie**
(`bit_of`) — nie na u. W treści `accept_bit_from_u_shares_probed` — zero.
