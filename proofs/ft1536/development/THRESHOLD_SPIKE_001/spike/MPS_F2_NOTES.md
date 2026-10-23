# MPS4-F2 — ffSampling / Babai: krótkie (s1, s2) dla FT1536

**Status:** ZŁOTO osiągnięte (poziom A). Nie kasować F2-1.

Konwencja (z `mpc_sign.rs`, nie łamiemy):
- `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F` (potem mod q)
- `verify_sign_equation`: `s2·h − s1 == t` (jak `falcon-vrfy.c:1419`)
- `encode_sig_static(s2)` + nonce → `Ft1536Signature::verify`

Algebra (w Q[X]/(φ), fG − gF = q):
- `z0 = −t·F / q`, `z1 = t·f / q`
- wtedy `z0·g + z1·G = t` i `z0·f + z1·F = 0` dokładnie w Q

Cytaty C:
- `Extra/c/falcon-sign.c:1848-1990` `do_sign` (ter=1: t0=−hm·F/q, t1=+hm·f/q,
  ffSampling, potem s1/s2 z bazy B0=[[g,−f],[G,−F]])
- `Extra/c/falcon-sign.c:1158-1253` `load_skey` (B0, Gram, `ffLDL_fft3`)
- `Extra/c/falcon-sign.c:1783` `ffSampling_fft3` / `:1617` `ffSampling_inner_fft3`
- `Extra/c/falcon-enc.c:564` `falcon_hash_to_point` (SHAKE→[0,q), lim=55299)
- `Extra/c/falcon-vrfy.c:1388-1441` `verify_raw`: `s1 = s2·h − c0`, `falcon_is_short`
- `Extra/c/internal.h:163` `FALCON_FT1536_NORM_BOUND2 = 2093922385`

Nonce / t (engine, `ft1536-sys` + C):
- `falcon_sign_start` (`falcon-sign.c:3281`): SHAKE wyciąga 40 B nonce
- `falcon_sign_start_external_nonce` (`:3293`): `shake_init(512)` + inject nonce
- `falcon_sign_update` (`:3301`): inject msg
- `falcon_sign_generate` (`:3324`): flip + `falcon_hash_to_point` → hm
- **t = hash_to_point(SHAKE256(nonce ‖ msg))** — pk **nie** wchodzi do tego SHAKE
- Nasze `hash_to_point_from_nonce_msg` to odwzorowuje; `hash_to_point_from_msg(pk,msg)`
  to starszy model i **nie** wystarcza do engine verify.

---

## F2-1 — RETAINED (NIE KASOWAĆ): ff-lite / Babai diagonal nie obniża normy

- **Objaw:** `sample_z_ff_lite` (`z1 = round(t·f/q)`, `z0 = −z1·F/f` w R_q)
  daje z ≠ 0 i równanie verify trzyma, ale norma **nie spada** vs z=0.
- **Pomiar (seed 0x42, msg `gold-ff`, nonce 0):**
  `n_zero = 44552128398`, `n_ff_lite = 44552128398` (identycznie).
- **Przyczyna:** `z0 = −z1·F/f` liczone w **R_q** daje `z·q/f ≡ 0` (mod q),
  więc s2 ≡ 0 w R_q, ale reprezentant w Z jest losowy w [0,q) — norma
  ~q²·N/12, czyli dokładnie rząd z=0. To **nie** jest CVP w kratcie NTRU
  (brak struktury Z[X]/(φ) i FFT3+LDL — C `falcon-sign.c:1783`).
- **Testy retained:** `mps4f2_ff_lite_lowers_norm`, `mps4f_babai_norm_measured`
  (pomiar, nie fałszywy PASS). Nie kasować.

## F2-2 — co wdrożono (poziom A) i zmierzone normy

**Poziom A (obowiązkowy start, O(N²) ring mul w Z[X]/(φ)):**
1. t jako i64 (centered z u16 w [0,q))
2. `tf = t·f`, `tF = t·F` w Z[X]/(φ) (`mul_ring_i64_i64`)
3. `z1[i] = round(tf[i]/q)`, `z0[i] = round(−tF[i]/q)`
4. s1,s2 przez mnożenie i64 w Z, potem reduce mod q
5. norma mierzona, nie zgadywana

**Poziom B (FFT / FFT3+LDL) — NIE był potrzebny** w tym oknie:
poziom A schodzi ~20× poniżej bound na prawdziwych kluczach engine.

**API:**
- `hash_to_point_from_nonce_msg(nonce, msg)` — t zgodne z engine
- `sample_z_ffsampling(td, t) -> (z0, z1)` w Z^N
- `trapdoor_sign_ffsampling(td, t) -> (s1, s2, n)`

**Zmierzone normy** (`poly_norm2_centered(s1)+poly_norm2_centered(s2)`,
bound = 2093922385):

| seed / msg | n_zero | n_ff-lite (F2-1) | n_ffsampling (A) |
|---|---|---|---|
| 0x42 / `gold-ff` (nonce 0) | 44552128398 | 44552128398 | **103747771** |
| 0x77 / `gold-ff-engine-nonce` (nonce z engine-sign) | — | — | **101122520** |

- ffsampling ≈ **1.03e8** vs bound **2.09e9** (≈20× zapasu)
- ffsampling vs z=0: ≈ **430×** niżej (1.03e8 vs 4.46e10)

**ZŁOTO (testy zielone):**
- `mps4f2_ffsampling_gold` — równanie OK, n=103747771 < bound,
  `Ft1536Signature::verify == true` (nonce = [0u8;40], t z tego nonce)
- `mps4f2_ffsampling_gold_engine_nonce` — nonce z `Ft1536Signature::sign`,
  t liczone jak engine, nasz (s1,s2) → verify == true, n=101122520
- `mps4f2_ffsampling_mutation_zero_z` — z=0 → n=44552128398 ≥ bound,
  engine verify false (poprawny FAIL)

## F2-3 — jeśli bound NIE byłby osiągnięty (nie wystąpiło)

Gdyby A ≥ bound, kolejność (nie wdrożono — zbędne):
1. **B1:** DFT na pierwiastkach φ / negacyclic length-4608; 2×2 [[g,G],[f,F]]
   per częstotliwość, rozwiązanie + **Babai w domenie współczynników**
   (samo round po iFFT = poziom A; korekta = nearest plane na bazie NTRU).
2. **B2:** wierny port FFT3 + split/merge + `ffLDL_fft3` tree
   (`falcon-sign.c:706,1158,1617,1783`); liście = **round** (Babai) wystarczy
   do ZŁOTA; pełny gaussian Z (Klein) = opcjonalny security, nie blokuje.
3. Uczciwy retained z realnym pomiarem — nigdy zielony test na siłę.

Uwaga: `falcon_is_short` (C) liczy formę kwadratową z cross-terms
`Σ s_i s_{i+hn}` (FFT embedding, `falcon-enc.c:597-666`), nie zwykłą L2.
Nasze ZŁOTO wymaga **obydwu**: nasza L2 < bound **i** engine verify
(używa formy C). Oba przeszły na pomiarach powyżej.

---

## Suite

`cargo test --manifest-path .../spike/Cargo.toml` → **282 lib + 14 isolation
+ 10 spike = 306 passed, 0 failed**. 0 warningów build/test.
Retained nie skasowane: F2-1, `mps4f_babai_norm_measured`,
`mps4f2_ff_lite_lowers_norm`.
