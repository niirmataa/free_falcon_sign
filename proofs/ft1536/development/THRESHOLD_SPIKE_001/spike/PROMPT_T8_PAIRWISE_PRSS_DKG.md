# PROMPT — T8: pairwise PRSS/CDI + keygen bez clear f,F

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Stan wejścia:** łańcuch F2→G→H→G-2→T6→T7 PASS — suite **365/365**.

---

## Cel T8

Domknąć **najbliższy brak T7** (meldunek zdanie 2):

1. **Pairwise PRSS / CDI** — osobne rng każdej strony (nie jeden in-process
   rng), strumienie zer jak `prss.rs` / `ZeroShareStream`; brak wspólnego
   dealera masek i szumu.
2. **H1 / keygen bez clear f,F** — udziały i16 f,F powstają bez momentu,
   w którym jeden proces widzi pełny f i F w clear (DKG / re-deal z
   contributions, jak `iso dkg` / spike 010; albo jawne zastrzeżenie
   + pełny DKG).

To **NIE** jest malicious-secure / UC / EUF-CMA. Ma być: brak centralnego
dealera **i** brak clear f,F w setupie + regresja złota (engine verify).

---

## Kontekst — co już jest (NIE psuć)

| Element | Gdzie |
|---|---|
| ZŁOTO: z z udziałów → s1,s2 → `Ft1536Signature::verify==true` | `ishare.rs`, `mpc_sign.rs`, `MPS_H_NOTES.md` |
| Szum DGDG w Babai (H≈0.95) | `MPS_T6_GAUSS_NOTES.md` |
| PRSS masek i szumu bez centralnego dealera (in-process) | `MPS_T7_PRSS_NOTES.md` |
| Shamir i16 (P=2^61−1), rounding w MPC | `ishare.rs` |
| DKG seeda bez `seed.bin` | `iso dkg`, spike 010 |
| SPDZ-MAC ukryte δ, DKG δ | `lib.rs` (Y6–Y10) |
| Pedersen VSS | `pedersen.rs` |

**Konwencja złota (zachowaj):**  
`z1 = round((t·f + g)/q)`, `z0 = round((−t·F + g')/q)`;  
`s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`;  
`s2·h − s1 = t`; `encode_sig_static(s2)` → engine verify.  
**Pin F2:** `n = 103747771` — nietknięty.

---

## Zakres T8 (kolejność)

1. **Pairwise PRSS** — per para strony strumień zero-share
   (`prss.rs` / `pair_seed`); wirtualne partie w testach z **osobnymi**
   rng; suma zer = 0 bez dealera.
2. **DGDG / maski z pairwise PRSS** — jak T7, ale nie in-process jeden rng.
3. **Keygen f,F bez clear** — DKG/re-deal: każda strona wnosi udział,
   Pedersen VSS, suma = f,F; **nigdy** `g2_deal_trapdoor` z pełnym f,F
   w jednym clear (albo jawne zastrzeżenie + test „brak clear”).
4. **Matrix fałszerstw** — tamper PRSS pairwise / wkład DKG → MacFail.
5. **Aktualizacja** `MPS_T8_PRSS_CDI_NOTES.md` + `Y13_MALICIOUS_MAP.md` + retained.

---

## Kryteria odbioru

1. Test: pairwise PRSS — osobne rng, Σ zero-shares = 0, brak dealera.
2. Test: keygen f,F — **brak** momentu z pełnym f,F w clear w torze
   setup (lub jawne zastrzeżenie + `g2_deal_trapdoor` oznaczony retained).
3. Regresja złota: `Ft1536Signature::verify==true`, pin F2 `103747771`,
   `mps4h`/`t6_`/`t7_*` zielone.
4. Tamper PRSS/DKG → detekcja (fail-closed).
5. Suite ≥ 365 + nowe, 0 warningów.
6. Retained w aktach; **nie kasować** F2-1, G-1..G-3, H-1..H-4, T6, T7.

---

## Zakres plików

| IN | OUT |
|---|---|
| `spike/src/ishare.rs`, `prss.rs`, `mpc_sign.rs`, `pedersen.rs`, testy, `MPS_T8_PRSS_CDI_NOTES.md`, `Y13_MALICIOUS_MAP.md` | `Obrazy/`, `Extra/c` (read-only), `[N]`, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS;
nie deklarować „malicious-secure”, „brak dealera klucza” (o ile H1 stoi),
ani „próg FT gotowy”.

---

## Testy startowe

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml
```

Spodziewane: 365/365, 0 warnings.  
Regresja złota: `t7_gold_with_prss_*`, `mps4h`, `t6_`.

---

## Trzy zdania na start

1. **Złoto + T7 (PRSS in-process) działa** — nie psuć regresji 365.  
2. **Brak** — pairwise CDI (osobne rng) + keygen bez clear f,F.  
3. **NIE implikuje** — malicious-secure / UC / EUF-CMA / brak dealera klucza
   o ile H1 w setupie stoi.
