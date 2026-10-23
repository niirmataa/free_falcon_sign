# I1 — koszt wyprowadzania (muls na udziałach)

Zliczenia z liczników `#[cfg(test)]` (`src/cost.rs`, thread-local),
potwierdzone strukturą kodu. Dwa prymitywy:

- **reshare** = `mul::mul_shamir_reshare` (re-deal Shamir, spike 013);
- **triple** = Beaver `generate_triple_shares` (dealerska trójka a,b,c=ab).

Liczniki nie ruszają API publicznego (`#[cfg(test)]` bump w ciele funkcji).

## Tabela kosztów

| tor | wynik | reshare muls | Beaver triples | muls/wynik | muls/łańcuch | vs cmp 255/bit |
|---|---|---|---|---|---|---|
| H_fold (`derive_key_byte_from_seed_shares`) | 1 B | 0 | **16** | 16 /B | 16 | 0.06× (16 vs 255) |
| G_frag (`derive_g_frag_shares`) | 64 B | **64** (32+32) | 0 | 1.0 /B | 64 | 0.25×/B (1 vs 4.0) |
| `derive_key_material_native` | 128 B | **128** (64+64) | 0 | 1.0 /B | 128 | 0.25×/B (1 vs 4.0) |
| `accept_bit_from_u_shares_probed` | 1 bit | 0 | **255** | 255 /bit | 255 | **1.00× = baza** |

Kolumna „vs cmp 255/bit" = koszt toru względem `accept_bit` (255 Beaver
muls na bit, Horner P_w stopnia 255). Dla G_frag/native porównanie na bajt:
1 reshare-mul/B vs 255 Beaver/bit = 2040 mul/B-ekwiwalent przy 8 bitach
liczonych osobno (tu: 4.0 mul/B gdyby każdy bit szedł przez cmp).

## Skąd liczby (struktura kodu)

- **H_fold 16**: `derive_key_byte_from_seed_shares` — 16 par `(seed[2i],
  seed[2i+1])`, każda przez `mul_shares_via_beaver` → 1×
  `generate_triple_shares` (lib.rs:620-629). Brak reshare na tej ścieżce.
- **G_frag 64 = 32+32**: etap1 `out[i] = seed[i] ⊕ (seed[i+1] ⊗ seed[i+13])`
  — 32× `mul_shamir_reshare`; etap2 `out[32+i] = out[i] ⊕ (out[i] ⊗ seed[i])`
  — 32× (lib.rs:764-789).
- **native 128 = 64+64**: `derive_g_frag_shares` (64) + łańcuch
  `out2[i] = out[i] ⊕ (out[i+32] ⊗ seed[i%32])` dla i=0..64 — 64×
  (lib.rs:1846-1864).
- **accept_bit 255**: Horner `acc ← acc·u ⊕ c_i` po 255 stopniach P_w,
  każdy krok = `cmp::mul_vec` → 1× `generate_triple_shares`
  (cmp.rs:128-133). Brzeg `w=0`: P_0 ≡ 0, **0 muls** (wczesny zwrot).

## Notatki kosztowe

- Jeden reshare-mul = n re-dealów `shamir_share` + n×`local_weighted_product`
  (2 gf_mul + Lagrange λ_i) — koszt ~O(n·k) gf_mul lokalnie, 1 runda deal.
- Jeden Beaver triple = 3×`shamir_share` + 1 gf_mul (dealerski preprocessing,
  model testowy) + 2 otwarcia masek (d,e) w `mul_vec`.
- G_frag/native są **tańsze na bajt** (1 reshare-mul/B) niż cmp na bit
  (255 Beaver/bit) — ale cmp liczy predykat, nie materiał; 255 to cena
  wierności `1{j<w}` na całym GF(256) bez bit-decomp.
- `derive_key_byte_checked` = te same 16 Beaver + kontrola spójności
  (bez mnożeń).

## Testy (green)

`src/cost.rs::tests`:
- `i1_hfold_cost_is_16_beaver_muls`
- `i1_g_frag_cost_is_64_reshare_muls`
- `i1_key_material_native_cost_is_128_reshare_muls`
- `i1_accept_bit_cost_is_255_beaver_muls`
- `i1_accept_bit_w0_is_zero_muls`
- `i1_counter_sees_raw_mul_calls` (mutation-check licznika)

## I2 — tor probed select (accept_bit + select_first_accepted_checked)

Zliczenia z `cost::measure` w teście `i2_probed_select_matches_clear`
(select.rs::tests_i2). t_max = 4 (małe okno — 255 Beaver/bit trzyma testy tanie).

| komponent | Beaver triples | uwagi |
|---|---|---|
| accept bits (t_max × `accept_bit_from_u_shares_probed`) | **t_max × 255** | Horner P_w; 255 muls na bit |
| `verify_accept_bits` (w `select_first_accepted_checked`) | t_max × 1 | a·(a+1) → 0 |
| `select_first_accepted_shares` (obwód) | t_max × 3 | t=a·(1+found), sel+=t·(x+sel), found+=a+found·a |
| **Razem (t_max=4)** | **4 × 259 = 1036** | w tym **4 × 255 = 1020** na accept bits |

- Zero `mul_shamir_reshare` na tej ścieżce (tylko Beaver triples).
- Accept bits liczone z udziałów u — **bez reconstruct(u)** (tylko maski d,e).
- w=0 brzeg: P_0 ≡ 0, 0 triples na accept bit (jak I1).
