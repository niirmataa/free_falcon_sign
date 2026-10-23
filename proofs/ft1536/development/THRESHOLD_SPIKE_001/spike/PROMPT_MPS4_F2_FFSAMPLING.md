# PROMPT — MPS4-F2: port ffSampling (FFT3 + LDL) dla FT1536

**Wyślij ten plik agentowi jako prompt.**  
**W:** `/home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/`  
**Crate:** `spike/` (`cargo test --manifest-path spike/Cargo.toml`)  
**Źródła C (read-only):** `/home/footfalcon/FT1536_DATA/free_falcon_sign/Extra/c/`  
**Silnik oracle:** `ft1536-sys` (`/home/footfalcon/Muzyka/[N]/crates/ft1536-sys`)

---

## Cel ZŁOTA

`s2` liczone z trapdoora (f,g,F,G) → `encode_sig_static` → **`Ft1536Signature::verify` = true**.

Warunek krótkości: `poly_norm2_centered(s1)+poly_norm2_centered(s2) < FALCON_FT1536_NORM_BOUND2`  
gdzie **`FALCON_FT1536_NORM_BOUND2 = 2093922385`** (`Extra/c/internal.h:163`).

---

## Kontekst — co już jest (NIE psuć)

FT1536 = **autorski wariant**: q=**18433**, N=**1536**, pierścień `X^N − X^{N/2} + 1`, secret **ternary**.  
Mapa: `spike/FT1536_IDENTITY.md`.

W `spike/src/mpc_sign.rs` jest:

| Element | API |
|---|---|
| Shamir + mul re-deal nad Z_18433 | `q_shamir_share`, `q_mul_shamir_reshare` |
| Mnożenie pierścienia (X^N = X^{N/2}−1) | `q_poly_mul_ring_clear` |
| Decode sk (header 0xAA, compress_static) | `decode_sk_ft1536` → f,g,F,G |
| Trapdoor | `trapdoor_sign_clear(td, t, z0, z1)`: `s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F` |
| Równanie verify | `verify_sign_equation`: **`s2·h − s1 = t`** (jak `falcon-vrfy.c:1419`) |
| Hash-to-point | `hash_to_point_from_msg` (rejection w<lim=55299, jak `falcon-enc.c:564`) |
| Codec | `compress_static_18433` / `uncompress_static_18433` / `encode_sig_static` (header **0xAA**) |
| f^{-1} w R_q | `poly_inv_ring` (rozszerzony Euklides) — działa na prawdziwym f |

**ZŁOTO już potwierdzone (testy zielone):**
- `mps4d_sig_codec_roundtrip_engine` — realny podpis → nasz decode → nasz encode → **engine verify OK** (codec bit-exact)
- `mps4e_sk_share_ceremony_real_sig` — udziały sk k-z-n → ceremonia → realny podpis → **verify OK**
- `mps4f2_ntru_relation_holds` — fG−gF ≡ 0 w R_q (walidacja decode)

---

## Czego brakuje — TO JEST ZADANIE

Sampler `z = (z0, z1)` dający **KRÓTKIE** `(s1, s2)`.

Nasz Babai-lite (`sample_z_ff_lite`: `z1 = round(t·f/q)`, `z0 = −z1·F/f`) spełnia równanie, ale **NIE obniża normy** (retained F2-1: 8.8e10 vs 4.4e10 dla z=0).  
Powód: w R_q `z·q/f ≡ 0` — trzeba liczyć w **Z / FFT** jak w C.

---

## Źródło prawdy — C (czytaj, nie kopiuj bezmyślnie)

### `Extra/c/falcon-sign.c`
- **`do_sign`** (~1848–1990):  
  `t0 = t·F/q`, `t1 = −t·f/q` (w FFT)  
  `(tx,ty) = ffSampling_fft3(tree, t0, t1)`  
  `s1 = tx·g + ty·G`, `s2 = tx·f + ty·F` (po iFFT i rint)  
  reject jeśli `!is_short`
- **`ffSampling_fft3`** (~1783–1839) + `ffSampling_inner_fft3` / `ffSampling_depth1_fft3`
- **`load_skey`** (~1158): `b00=g, b01=f, b10=G, b11=F`; `B0 = [[g, −f], [G, −F]]`
- `sig_buf[0] = (ternary<<7)|(comp<<5)|logn = 0xAA`

### `Extra/c/falcon-vrfy.c:1388` `verify_raw`
`s1 = s2·h − t` (mq_NTT / montymul / iNTT / mq_poly_sub c0).  
Krótkość: `falcon_is_short`.

### `Extra/c/falcon-enc.c`
- `:289` `compress_static` (j=8 dla q=18433)
- `:564` `falcon_hash_to_point`

### `Extra/c/internal.h`
`FALCON_FT1536_NORM_BOUND2`

---

## Kryteria odbioru

1. Funkcja `trapdoor_sign_ffsampling(td, t) -> (s1, s2)`  
   w `mpc_sign.rs` lub nowym `mpc_sign_ff.rs`.
2. **Test złota:**
   - `Ft1536KeyPair::generate_from_seed` → `decode_sk_ft1536` → `td`
   - `t = hash_to_point_from_msg(pk, msg)`
   - `(s1,s2) = ffsampling(...)`
   - `verify_sign_equation(s1,s2,h,t) == true` (`h = g·f^{-1}`)
   - `norm(s1)+norm(s2) < 2093922385`
   - `encode_sig_static(s2)` + nonce → **`Ft1536Signature::verify == true`**
3. Suite zielona, 0 warningów: `cargo test --manifest-path spike/Cargo.toml`
4. Mutacja: zepsuty sampler (z=0) → verify false / norma za duża
5. Retained w `spike/MPS_F2_NOTES.md` (lub U1_KLEIN_MPC.md) — **nie kasować F2-1**

---

## Zakres

| IN | OUT |
|---|---|
| `spike/src/mpc_sign.rs` lub `mpc_sign_ff.rs`, testy, notatki w `spike/` | `Obrazy/`, `Extra/c` (read-only), `[N]`, inne craty, git push |

**Rygor:** prawda przed tempem; fail-closed; brak fałszywych PASS.  
Jeśli ffSampling nie da short s w tym oknie — **uczciwy pomiar + retained**, nie zielony test na siłę.

---

## Podpowiedź implementacyjna

1. Zacznij od **jasnego** ffSampling w f64 (ten sam algorytm co C) na prawdziwym f,g,F,G — doprowadź do normy < bound i engine verify.
2. Potem (opcjonalnie) przenieś mnożenia na udziały (`q_mul_shamir_reshare`) — „klucz nigdy w całości".
3. FFT3 dla `X^N − X^{N/2} + 1`: `y = X^{N/2}`, `y² − y + 1 = 0`, `y = (1±√−3)/2`; **−3 jest kwadratem w Z_18433** (legendre=1) — pierścień się rozbija, stąd FFT3 (3 składowe), nie zwykły NTT.
4. Alternatywa: Babai na pełnej macierzy kraty w Z^{2N} (sploty), ale **musi** zejść poniżej `NORM_BOUND2` i przejść engine verify.

---

## Testy istniejące (odpal na starcie)

```bash
cargo test --manifest-path /home/footfalcon/FT1536_DATA/free_falcon_sign/proofs/ft1536/work/FT1536_THRESHOLD_SPIKE_001/spike/Cargo.toml --lib mps
```

Spodziewane: `mps4d_sig_codec_roundtrip_engine` OK, `mps4e_sk_share_ceremony_real_sig` OK.  
`mps4f2_ff_lite_lowers_norm` może być w pomiarze (retained) — to jest punkt startu.

---

## Trzy zdania na start

1. **Złoto** = `encode_sig_static(s2)` + engine verify — codec już bit-exact.  
2. **Brak** = krótkie `s1,s2` (norma < 2093922385) — to jest **ffSampling** z C (`falcon-sign.c:1783`).  
3. Jak nie zejdzie w oknie — **pomiar + retained**, nie fałszywy PASS.
