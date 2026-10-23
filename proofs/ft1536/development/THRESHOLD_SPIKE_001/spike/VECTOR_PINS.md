# Wektory deterministyczne — T-THRESHOLD spike

**Ziarna jawne.** Zmiana modelu (`h_fold`, `g_frag`, `mul`) = zmiana FNV.
Testy: `tests_vectors` w `src/lib.rs` (v1–v3).

## H_fold (seed[i] = 7i+3, i=0..31)

- wzorzec: `H_fold(seed) = ⊕_{i=0..15} gf_mul(seed[2i], seed[2i+1])`
- test: `v1_h_fold_vector_pin`
- **pin: k0=`0xd7`, FNV=`0xaf648a4c86031436`**

## G_frag (seed[i] = (13i) XOR 0xA5)

- wzorzec: etap1 `out[i]=seed[i]⊕(seed[i+1]⊗seed[i+13])`; etap2 `out[32+i]=out[i]⊕(out[i]⊗seed[i])`
- test: `v2_g_frag_vector_pin`
- **pin: FNV(64 B)=`0x34ed69b6fbaa6613`**

## mul_shamir_reshare (StdRng seed 0xC0FFEE)

- a=0x11, b=0x22, xs=[1,2,3], k=2
- test: `v3_mul_vector_stable`, `mul_vector_fnv_pin`
- **pin: c=`[214, 235, 9]`, FNV=`0xce9d0b1c5c23329d`**

## PRSS `pair_seed(b"alice", b"bob")`

- test: `prss_key_pin`
- **pin: FNV(key)=`0x77503213bc5df998`**

## S4 — orakła toru sign v2 (seed=`[0x44;32]`, mh=`[0x55;32]`)

- derive: `SHAKE256("NEXUM-KEY-SHAKE-v1"||seed, 128 B)`
- nonce: `SHAKE256("NEXUM-NONCE-SHAKE-v1"||seed||mh, 40 B)`
- test: `s4_pins_sign_tor_v2_deterministic_oracle`
- **pin derive: FNV=`0xdf4a4067cba1c082`**
- **pin nonce: FNV=`0x53039e70fc54f445`**

## U1-D — Klein Q73 (σ=1)

- `q73_range_weight(0,0,2^73)` = `2^73`
- `q73_range_weight(-2..2, 2^73)` = **`23458184420803307425338`**
- test: `u1d_pins_range_weight_frozen`

## R1 — seed9 fixture (SHA-256, format R1 — NIE FNV)

- `K1_R1_ANSWERS.md` pyt. 6; hex `6d65617331…0009` („meas1"+counter 9)
- **SHA-256 = `4941edb1f4d7bcfdaa82833d1cda200ae85782dcaa7030fae439819298f3a450`**
- test: `r1_answers_sk_range_and_seed9_pin` / `entry_pin_seed9_r1`
- Format R1: SHA-256 + ENTRY_PINS/postseal; **nie przyrównywać FNV do SHA-256**

## Uwaga

`hash256` w PRSS to 4×FNV — **nie SHA**; piny PRSS osobno jeśli wejdą
do kontraktu. Wartości pinów wypisywane przy `--nocapture`; ten plik
jest mapą wektorów, nie skarbcem liczb (liczby w testach).
